<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	
	<xsl:param name="currentPage" select="/root/*[1]" />

	<!-- Index by year -->
	<xsl:key name="NewsByYear" match="NewsItem" use="substring(newsDate, 1, 4)" />
	<!-- Index by month (in year) -->
	<xsl:key name="NewsByMonth" match="NewsItem" use="substring(newsDate, 1, 7)" />
	
	<xsl:template match="/">
		<div>
			<xsl:apply-templates select="$currentPage/NewsSection[1]" />
		</div>
	</xsl:template>
	
	<xsl:template match="NewsSection">
		
		<xsl:for-each select="NewsItem[count(. | key('NewsByYear', substring(newsDate, 1, 4))[1]) = 1]">
			<xsl:sort select="newsDate" data-type="text" order="descending" />
			
			<xsl:variable name="year" select="substring(newsDate, 1, 4)" />
			<xsl:variable name="month" select="substring(newsDate, 6, 2)" />
			<xsl:variable name="newsThisYear" select="key('NewsByYear', $year)" />
			
			<h2><xsl:value-of select="$year" /></h2>
			
			<div>
				<xsl:apply-templates select="$newsThisYear[count(. | key('NewsByMonth', substring(newsDate, 1, 7))[1]) = 1]" mode="months">
					<xsl:sort select="newsDate" data-type="text" order="descending" />
				</xsl:apply-templates>
			</div>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="NewsItem" mode="year">
		<h2>
			<xsl:value-of select="substring(newsDate, 1, 4)" />
		</h2>
	</xsl:template>
	
	<xsl:template match="NewsItem" mode="months">
		<xsl:variable name="year" select="substring(newsDate, 1, 4)" />
		<xsl:variable name="month" select="substring(newsDate, 6, 2)" />

		<h3><xsl:value-of select="$month" /></h3>
		<xsl:apply-templates select="key('NewsByMonth', concat($year, '-', $month))" mode="item" />
	</xsl:template>
	
	<xsl:template match="NewsItem" mode="item">
		<p>
			<xsl:value-of select="title" />
		</p>
	</xsl:template>

</xsl:stylesheet>