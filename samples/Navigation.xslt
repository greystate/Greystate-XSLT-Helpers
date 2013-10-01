<?xml version="1.0" encoding="utf-8" ?>
<!--
	Navigation.xslt
	
	Sample all-in-one navigation macro for use with [Umbraco](http://umbraco.com),
	using the _NavigationHelper.xslt - Read more here:
	https://github.com/greystate/Greystate-XSLT-Helpers/tree/master/navigationhelper
-->
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:umb="urn:umbraco.library"
    exclude-result-prefixes="umb"
>

    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

    <xsl:param name="currentPage" />
    
    <xsl:variable name="mode" select="/macro/mode" />
    
    <xsl:template match="/">
        <!-- Use The MEXAH, Luke ... -->
        <xsl:apply-templates select="$currentPage[$mode = 'mainnav']" mode="navigation.main" />
        <xsl:apply-templates select="$currentPage[$mode = 'subnav']" mode="navigation.sub" />
        <xsl:apply-templates select="$currentPage[$mode = 'breadcrumb']" mode="navigation.crumb" />
        <xsl:apply-templates select="$currentPage[$mode = 'sitemap']" mode="navigation.map" />
    </xsl:template>

    <xsl:include href="helpers/_NavigationHelper.xslt" />

</xsl:stylesheet>