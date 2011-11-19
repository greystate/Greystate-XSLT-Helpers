<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE xsl:stylesheet [
	<!-- Define RequestQueryString function (this one's from Umbraco) -->
	<!ENTITY queryString "umb:RequestQueryString">
	
	<!-- Paging constants -->
	<!ENTITY prevPage "&#8249; Previous">
	<!ENTITY nextPage "Next &#8250;">

	<!ENTITY pagerParam "p">		<!-- Name of QueryString parameter for 'page' --> 
	<!ENTITY perPage "10">			<!-- Number of items on a page -->
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umb="urn:umbraco.library"
	exclude-result-prefixes="umb"
>

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

	<!-- Paging variables -->
	<xsl:variable name="perPage" select="&perPage;" />
	<xsl:variable name="reqPage" select="&queryString;('&pagerParam;')" />
	<xsl:variable name="page">
		<xsl:choose>
			<xsl:when test="number($reqPage) = $reqPage">
				<xsl:value-of select="$reqPage" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="1" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:template name="PaginateSelection">
		<!-- The stuff to paginate - defaults to all children of the context node when invoking this  -->
		<xsl:param name="selection" select="*" />

		<!-- This is to allow forcing a specific page without using QueryString  -->
		<xsl:param name="page" select="$page" />

		<!-- You can disable the "Pager" control by setting this to false() - then manually calling RenderPager somewhere else -->
		<xsl:param name="showPager" select="true()" />
		
		<xsl:variable name="startIndex" select="$perPage * ($page - 1) + 1" /><!-- First item on this page -->
		<xsl:variable name="endIndex" select="$page * $perPage" /><!-- First item on next page -->
		
		<!-- Render the current page using apply-templates -->
		<xsl:apply-templates select="$selection[position() &gt;= $startIndex and position() &lt;= $endIndex]" />
		
		<!-- Should we render the pager controls? -->
		<xsl:if test="$showPager">
			<xsl:call-template name="RenderPager">
				<xsl:with-param name="selection" select="$selection" />
				<xsl:with-param name="page" select="$page" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="RenderPager">
		<xsl:param name="selection" select="*" />
		<xsl:param name="page" select="$page" />
		
		<xsl:variable name="total" select="count($selection)" />
		<xsl:variable name="lastPageNum" select="ceiling($total div $perPage)" />

		<ul class="pager">
			<!-- Create the "Previous" link -->
			<li class="prev">
				<xsl:choose>
					<xsl:when test="$page = 1">&prevPage;</xsl:when>
					<xsl:otherwise>
						<a href="?&pagerParam;={$page - 1}">&prevPage;</a>
					</xsl:otherwise>
				</xsl:choose>
			</li>
			<!-- Create links for each page available -->
			<xsl:for-each select="$selection[position() &lt;= $lastPageNum]">
				<li>
					<xsl:choose>
						<xsl:when test="$page = position()">
							<xsl:attribute name="class">current</xsl:attribute>
							<xsl:value-of select="position()" />
						</xsl:when>
						<xsl:otherwise>
							<a href="?&pagerParam;={position()}">
								<xsl:value-of select="position()" />
							</a>
						</xsl:otherwise>
					</xsl:choose>
				</li>
			</xsl:for-each>
			<li class="next">
				<xsl:choose>
					<xsl:when test="$page = $lastPageNum">&nextPage;</xsl:when>
					<xsl:otherwise>
						<a href="?&pagerParam;={$page + 1}">&nextPage;</a>
					</xsl:otherwise>
				</xsl:choose>
			</li>			
		</ul>
	</xsl:template>

</xsl:stylesheet>