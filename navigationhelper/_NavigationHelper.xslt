<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % entities SYSTEM "entities.ent">
	%entities;
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:freeze="http://xmlns.greystate.dk/2012/frezer"
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
	<xsl:template match="/">
		<!-- Mutually Exclusive xsl:choose Avoidance Hack (TM) -->
		<xsl:apply-templates select="$currentPage[$mode = 'subnav']" mode="subnav" />
		<xsl:apply-templates select="$currentPage[$mode = 'mainnav']" mode="mainnav" />
	</xsl:template>
	
	<xsl:template match="*" mode="mainnav">
		<xsl:apply-templates select="$siteRoot/&page;" />
	</xsl:template>
	
	<!-- Generic template for creating the links -->
	<xsl:template match="*">
		<!-- This is only needed for testing, so ... freeze:remove="yes" -->
		<xsl:param name="currentPage" select="$currentPage" freeze:remove="yes" />
		<li>
			<xsl:if test="descendant-or-self::*[@id = $currentPage/@id]"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
			<a href="{&linkURL;}">
				<xsl:value-of select="&linkName;" />
			</a>
		</li>
	</xsl:template>

</xsl:stylesheet>