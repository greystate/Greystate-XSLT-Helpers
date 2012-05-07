<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umb="urn:umbraco.library"
	exclude-result-prefixes="umb"
>

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

	<xsl:variable name="currentPage" select="//*[@id = 1503]" />
	<xsl:variable name="siteRoot" select="$currentPage/ancestor-or-self::*[@level = 1]" />

	<xsl:template match="/">
		<ul id="mainnav">
			<xsl:apply-templates select="$currentPage" mode="mainnav" />
		</ul>
		
		<ul id="breadcrumb">
			<xsl:apply-templates select="$currentPage" mode="breadcrumb" />
		</ul>
		
		<ul id="subnav">
			<xsl:apply-templates select="$currentPage" mode="subnav" />
		</ul>
		
		<ul id="sitemap">
			<xsl:apply-templates select="$siteRoot" mode="sitemap" />
		</ul>
	</xsl:template>
	
	<xsl:template name="subNavLevels3to4">
		<ul id="subnav">
			<xsl:apply-templates select="$currentPage" mode="subnav">
				<xsl:with-param name="levels" select="'3-4'" />
			</xsl:apply-templates>
		</ul>
	</xsl:template>
	
	<xsl:include href="../_NavigationHelper.xslt" />

</xsl:stylesheet>