<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % entities SYSTEM "entities.ent">
	%entities;
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:freeze="http://xmlns.greystate.dk/2012/freezer"
	exclude-result-prefixes="freeze"
>

	<xsl:param name="currentPage" select="/.." />
	
<!--
	The `mode` parameter decides which kind of navigation to create. Currently four exist:
	
	* mainnav   	- children of `$siteRoot`
	* subnav    	- children of the "current section" (typically the siblings of the selected node)
	* breadcrumb	- ancestors of "current page" 
	* sitemap    	- "exploded" view of all pages and their children
-->
	<xsl:param name="mode" select="'mainnav'" />
	
<!-- :: Templates :: -->

	<!-- Root template -->
	<xsl:template match="/" name="Navigation">
		<!-- Enable testing in specific mode -->
		<xsl:param name="mode" select="$mode" />
		<xsl:param name="context" select="$currentPage" />
		
		<!-- Mutually Exclusive xsl:choose Avoidance Hack (TM) -->
		<xsl:apply-templates select="$context[$mode = 'subnav']" mode="subnav" />
		<xsl:apply-templates select="$context[$mode = 'mainnav']" mode="mainnav" />
		<xsl:apply-templates select="$context[$mode = 'sitemap']" mode="sitemap" />
		<xsl:apply-templates select="$context[$mode = 'breadcrumb']" mode="breadcrumb" />
		
	</xsl:template>
	
	<!-- Main navigation -->
	<xsl:template match="*" mode="mainnav">
		<xsl:variable name="siteRoot" select="ancestor-or-self::&homeNode;" />
		
		<xsl:apply-templates select="$siteRoot/&page;" />
	</xsl:template>
	
	<!-- Sub navigation -->
	<xsl:template match="*" mode="subnav">
		<xsl:variable name="currentSection" select="ancestor-or-self::*[parent::&homeNode;]" />
		
		<xsl:apply-templates select="$currentSection/&page;" />
	</xsl:template>
	
	<!-- Breadcrumb -->
	<xsl:template match="*" mode="breadcrumb">
		<xsl:apply-templates select="ancestor-or-self::*[ancestor::&homeNode;]" />
	</xsl:template>
	
	<!-- Sitemap -->
	<xsl:template match="*" mode="sitemap">
		<xsl:apply-templates select="."><xsl:with-param name="isSitemap" select="true()" freeze:remove="yes" /></xsl:apply-templates>
	</xsl:template>
	
	<!-- Generic template for creating the links -->
	<xsl:template match="*">
		<xsl:param name="isSitemap" select="$mode = 'sitemap'" />
		<xsl:variable name="isCurrentPage" select="@id = $currentPage/@id" />
		<xsl:variable name="hasCurrentPageBelow" select="descendant::*[@id = $currentPage/@id]" />
		<li>
			<!-- Add the selected class if needed -->
			<xsl:if test="not($mode = 'breadcrumb') and ($isCurrentPage or $hasCurrentPageBelow)"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
			<a href="{&linkURL;}">
				<xsl:value-of select="&linkName;" />
			</a>
			<xsl:if test="$isSitemap and &page;">
				<ul>
					<xsl:apply-templates select="&page;"><xsl:with-param name="isSitemap" select="true()" freeze:remove="yes" /></xsl:apply-templates>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>

</xsl:stylesheet>