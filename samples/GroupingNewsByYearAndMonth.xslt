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
		<!-- Apply templates to unique years -->
		<xsl:apply-templates select="NewsItem[count(. | key('NewsByYear', substring(newsDate, 1, 4))[1]) = 1]" mode="years">
			<xsl:sort select="newsDate" data-type="text" order="descending" />
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="NewsItem" mode="years">
		<xsl:variable name="year" select="substring(newsDate, 1, 4)" />
		<xsl:variable name="current-group" select="key('NewsByYear', $year)" />
		
		<h2><xsl:value-of select="$year" /></h2>
			
		<!-- Apply templates to unique months in current year -->
		<xsl:apply-templates select="$current-group[count(. | key('NewsByMonth', substring(newsDate, 1, 7))[1]) = 1]" mode="months">
			<xsl:sort select="newsDate" data-type="text" order="descending" />
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="NewsItem" mode="months">
		<xsl:variable name="year" select="substring(newsDate, 1, 4)" />
		<xsl:variable name="month" select="substring(newsDate, 6, 2)" />

		<h3><xsl:apply-templates select="newsDate" mode="date.monthname" /></h3>
		
		<!-- Apply templates to dates in the current month -->
		<xsl:apply-templates select="key('NewsByMonth', concat($year, '-', $month))">
			<xsl:sort select="newsDate" data-type="text" order="descending" />
		</xsl:apply-templates>
	</xsl:template>

	<!-- Template for a single NewsItem -->
	<xsl:template match="NewsItem">
		<p>
			<xsl:value-of select="title" />
		</p>
	</xsl:template>
	
	<!-- Template for monthname -->
	<xsl:template match="* | @*" mode="date.monthname">
		<xsl:variable name="names" select="'January   February  March     April     May       June      July      August    September October   November  December'" />
		<xsl:variable name="m" select="number(substring(., 6, 2))" />
		<xsl:value-of select="normalize-space(substring($names, 10 * ($m - 1), 10))" />
	</xsl:template>

</xsl:stylesheet>