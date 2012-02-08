<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:umb="urn:umbraco.library" xmlns:str="urn:Exslt.ExsltStrings" xmlns:make="urn:schemas-microsoft-com:xslt" version="1.0" exclude-result-prefixes="umb str make">

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<!-- Config constants -->
	<xsl:variable name="pagerParam" select="'p'"/><!-- Name of QueryString parameter for 'page' -->
	<xsl:variable name="perPage" select="10"/><!-- Number of items on a page -->
	<xsl:variable name="prevPage" select="'&#x2039; Previous'"/>
	<xsl:variable name="nextPage" select="'Next &#x203A;'"/>
	
	<!--
		This is where we get the options for the page, which defaults to the QueryString
		but as long as it is formatted like a QueryString it can come from anywhere you like.
	-->
	<xsl:variable name="optionString" select="umb:RequestServerVariables('QUERY_STRING')"/>
	
	<!--
		Build an `options` variable of all the query string params for easy lookup,
		e.g.: If you need to pass a search-string (q=xslt) along to all pages, it
		will be available as $options[@key = 'q']
	-->
	<xsl:variable name="optionsProxy">
		<xsl:call-template name="parseOptions">
			<xsl:with-param name="options" select="$optionString"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="options" select="make:node-set($optionsProxy)/options/option"/>

	<!-- Paging variables -->
	<xsl:variable name="reqPage" select="$options[@key = $pagerParam]"/>
	<xsl:variable name="page">
		<xsl:choose>
			<xsl:when test="number($reqPage) = $reqPage"><xsl:value-of select="$reqPage"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="1"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:template name="PaginateSelection">
		<!-- The stuff to paginate - defaults to all children of the context node when invoking this  -->
		<xsl:param name="selection" select="*"/>
		
		<!-- This is to allow forcing a specific page without using QueryString  -->
		<xsl:param name="page" select="$page"/>

		<!-- Also, allow forcing specific options -->
		<xsl:param name="options" select="$options"/>

		<!-- You can disable the "Pager" control by setting this to false() - then manually calling RenderPager somewhere else -->
		<xsl:param name="showPager" select="true()"/>
		
		<xsl:variable name="startIndex" select="$perPage * ($page - 1) + 1"/><!-- First item on this page -->
		<xsl:variable name="endIndex" select="$page * $perPage"/><!-- First item on next page -->
		
		<!-- Render the current page using apply-templates -->
		<xsl:apply-templates select="$selection[position() &gt;= $startIndex and position() &lt;= $endIndex]"/>
		
		<!-- Should we render the pager controls? -->
		<xsl:if test="$showPager">
			<xsl:call-template name="RenderPager">
				<xsl:with-param name="selection" select="$selection"/>
				<xsl:with-param name="page" select="$page"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="RenderPager">
		<xsl:param name="selection" select="*"/>
		<xsl:param name="page" select="$page"/>
		
		<xsl:variable name="total" select="count($selection)"/>
		<xsl:variable name="lastPageNum" select="ceiling($total div $perPage)"/>

		<ul class="pager">
			<!-- Create the "Previous" link -->
			<li class="prev">
				<xsl:choose>
					<xsl:when test="$page = 1"><xsl:value-of select="$prevPage"/></xsl:when>
					<xsl:otherwise>
						<a href="?{$pagerParam}={$page - 1}"><xsl:value-of select="$prevPage"/></a>
					</xsl:otherwise>
				</xsl:choose>
			</li>
			<!-- Create links for each page available -->
			<xsl:for-each select="$selection[position() &lt;= $lastPageNum]">
				<li>
					<xsl:choose>
						<xsl:when test="$page = position()">
							<xsl:attribute name="class">current</xsl:attribute>
							<xsl:value-of select="position()"/>
						</xsl:when>
						<xsl:otherwise>
							<a href="?{$pagerParam}={position()}">
								<xsl:value-of select="position()"/>
							</a>
						</xsl:otherwise>
					</xsl:choose>
				</li>
			</xsl:for-each>
			<li class="next">
				<xsl:choose>
					<xsl:when test="$page = $lastPageNum"><xsl:value-of select="$nextPage"/></xsl:when>
					<xsl:otherwise>
						<a href="?{$pagerParam}={$page + 1}"><xsl:value-of select="$nextPage"/></a>
					</xsl:otherwise>
				</xsl:choose>
			</li>			
		</ul>
	</xsl:template>
	
	<!-- Options Parsing -->
	<xsl:template name="parseOptions">
		<xsl:param name="options" select="''"/>
		<options>
			<xsl:apply-templates select="str:split($options, '&amp;')" mode="parse"/>
		</options>
	</xsl:template>

	<xsl:template match="token" mode="parse">
		<xsl:variable name="key" select="substring-before(., '=')"/>
		<option key="{$key}">
			<xsl:value-of select="umb:RequestQueryString($key)"/>
		</option>
	</xsl:template>

</xsl:stylesheet>
