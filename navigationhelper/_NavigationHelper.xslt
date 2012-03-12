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

	<xsl:param name="currentPage" />
	
	<xsl:variable name="siteRoot" select="$currentPage/ancestor-or-self::&homeNode;" />
	<xsl:variable name="currentSection" select="$currentPage/ancestor-or-self::*[parent::&homeNode;]" />
	
<!--
	The `mode` parameter decides which kind of navigation to create. Currently two exist:
	
	* mainnav   - children of `$siteRoot`
	* subnav    - children of the "current section" (typically the siblings of the selected node)
-->
	<xsl:param name="mode" select="'mainnav'" />
	
<!-- :: Templates :: -->

	<!-- Root template -->
	<xsl:template match="/">
		
		<!-- Mutually Exclusive xsl:choose Avoidance Hack (TM) -->
		<xsl:apply-templates select="$currentPage[$mode = 'subnav']" mode="subnav" />
		<xsl:apply-templates select="$currentPage[$mode = 'mainnav']" mode="mainnav" />
		
	</xsl:template>
	
	<!-- Main navigation -->
	<xsl:template match="*" mode="mainnav">
		<xsl:apply-templates select="$siteRoot/&page;" />
	</xsl:template>
	
	<!-- Sub Navigation -->
	<xsl:template match="*" mode="subnav">
		<xsl:apply-templates select="$currentSection/&page;" />
	</xsl:template>
	
	<!-- Generic template for creating the links -->
	<xsl:template match="*">
		<li>
			<xsl:if test="descendant-or-self::*[@id = $currentPage/@id]"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
			<a href="{&linkURL;}">
				<xsl:value-of select="&linkName;" />
			</a>
		</li>
	</xsl:template>

</xsl:stylesheet>