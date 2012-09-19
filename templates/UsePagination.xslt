<?xml version="1.0" encoding="utf-8" ?>
<!--
	Sample use of the _PaginationHelper.xslt
	Paginates the visible children of $currentPage.
	No. of items per page is configurable in the helper file.
-->
<xsl:stylesheet
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library"
	{0}
	exclude-result-prefixes="msxml umbraco.library {1}"
>

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

	<xsl:param name="currentPage" />
	<xsl:variable name="siteRoot" select="$currentPage/ancestor-or-self::*[@level = 1]" />
	
	<xsl:template match="/">
		<xsl:call-template name="PaginateSelection">
			<xsl:with-param name="selection" select="$currentPage/*[@isDoc][not(umbracoNaviHide = 1)]" />
			<xsl:with-param name="showPager" select="true()" />
		</xsl:call-template>
	</xsl:template>
	
	<!-- This is the generic template for every paged item -->
	<xsl:template match="*[@isDoc]">
		<p>
			<xsl:value-of select="@nodeName" />
		</p>
	</xsl:template>
	
	<!-- Include Pagination Helper -->
	<xsl:include href="_PaginationHelper.xslt" />

</xsl:stylesheet>