<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:freeze="http://xmlns.greystate.dk/2012/freezer" version="1.0" exclude-result-prefixes="freeze">

	<xsl:param name="currentPage" select="/.."/>
	
<!--
	The `mode` parameter decides which kind of navigation to create. Currently four exist:
	
	* mainnav   	- children of `$siteRoot`
	* subnav    	- children of the "current section" (typically the siblings of the selected node)
	* breadcrumb	- ancestors of "current page" 
	* sitemap    	- "exploded" view of all pages and their children
-->
	<xsl:param name="mode" select="'mainnav'"/>
	
<!-- :: Templates :: -->

	<!-- Root template -->
	<xsl:template match="/" name="Navigation">
		<!-- Enable testing in specific mode -->
		<xsl:param name="mode" select="$mode"/>
		<xsl:param name="context" select="$currentPage"/>
		
		<!-- Mutually Exclusive xsl:choose Avoidance Hack (TM) -->
		<xsl:apply-templates select="$context[$mode = 'subnav']" mode="subnav"/>
		<xsl:apply-templates select="$context[$mode = 'mainnav']" mode="mainnav"/>
		<xsl:apply-templates select="$context[$mode = 'sitemap']" mode="sitemap"/>
		<xsl:apply-templates select="$context[$mode = 'breadcrumb']" mode="breadcrumb"/>
		
	</xsl:template>
	
	<!-- Main navigation -->
	<xsl:template match="*" mode="mainnav">
		<xsl:variable name="siteRoot" select="ancestor-or-self::*[@level = 1]"/>
		
		<xsl:apply-templates select="$siteRoot/*[@isDoc][not(umbracoNaviHide = 1)]"/>
	</xsl:template>
	
	<!-- Sub navigation -->
	<xsl:template match="*" mode="subnav">
		<xsl:variable name="currentSection" select="ancestor-or-self::*[parent::*[@level = 1]]"/>
		
		<xsl:apply-templates select="$currentSection/*[@isDoc][not(umbracoNaviHide = 1)]"/>
	</xsl:template>
	
	<!-- Breadcrumb -->
	<xsl:template match="*" mode="breadcrumb">
		<xsl:apply-templates select="ancestor-or-self::*[ancestor::*[@level = 1]]"/>
	</xsl:template>
	
	<!-- Sitemap -->
	<xsl:template match="*" mode="sitemap">
		<xsl:apply-templates select="."/>
	</xsl:template>
	
	<!-- Generic template for creating the links -->
	<xsl:template match="*">
		<xsl:param name="isSitemap" select="$mode = 'sitemap'"/>
		<xsl:variable name="isCurrentPage" select="@id = $currentPage/@id"/>
		<xsl:variable name="hasCurrentPageBelow" select="descendant::*[@id = $currentPage/@id]"/>
		<li>
			<!-- Add the selected class if needed -->
			<xsl:if test="not($mode = 'breadcrumb') and ($isCurrentPage or $hasCurrentPageBelow)"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
			<a href="{umb:NiceUrl}">
				<xsl:value-of select="@nodeName"/>
			</a>
			<xsl:if test="$isSitemap and *[@isDoc][not(umbracoNaviHide = 1)]">
				<ul>
					<xsl:apply-templates select="*[@isDoc][not(umbracoNaviHide = 1)]"/>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>

</xsl:stylesheet>
