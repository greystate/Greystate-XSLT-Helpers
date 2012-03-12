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
	The `mode` parameter decides which kind of navigation to create. Currently two exist:
	
	* mainnav   - children of `$siteRoot`
	* subnav    - children of the "current section" (typically the siblings of the selected node)
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
		<xsl:apply-templates select="$context[$mode = 'breadcrumb']" mode="breadcrumb" />
		
	</xsl:template>
	
	<!-- Main navigation -->
	<xsl:template match="*" mode="mainnav">
		<xsl:variable name="siteRoot" select="ancestor-or-self::&homeNode;" />
		
		<xsl:apply-templates select="$siteRoot/&page;" />
	</xsl:template>
	
	<!-- Sub Navigation -->
	<xsl:template match="*" mode="subnav">
		<xsl:variable name="currentSection" select="ancestor-or-self::*[parent::&homeNode;]" />
		
		<xsl:apply-templates select="$currentSection/&page;" />
	</xsl:template>
	
	<!-- Breadcrumb -->
	<xsl:template match="*" mode="breadcrumb">
		<xsl:apply-templates select="$currentPage/ancestor-or-self::*[ancestor::Website]" />
	</xsl:template>
	
	<!-- Generic template for creating the links -->
	<xsl:template match="*">
		<xsl:variable name="isCurrentPage" select="@id = $currentPage/@id" />
		<xsl:variable name="hasCurrentPageBelow" select="descendant::*[@id = $currentPage/@id]" />
		<li>
			<!-- Add the selected class if needed -->
			<xsl:if test="not($mode = 'breadcrumb') and ($isCurrentPage or $hasCurrentPageBelow)"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
			<a href="{&linkURL;}">
				<xsl:value-of select="&linkName;" />
			</a>
		</li>
	</xsl:template>

</xsl:stylesheet>