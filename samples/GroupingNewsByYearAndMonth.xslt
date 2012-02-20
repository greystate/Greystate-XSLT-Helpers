<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE xsl:stylesheet [
	<!-- Replace with the actual DocumentType aliases (or element names) -->
	<!ENTITY NewsSection "NewsSection">
	<!ENTITY NewsItem "NewsItem">
	
	<!-- Replace with name of date property on NewsItems (if used) -->
	<!ENTITY dateProperty "newsDate">
	<!ENTITY datePropertyWithFallback "(@createDate[not(normalize-space(../&dateProperty;))] | &dateProperty;)[1]">
	
	<!-- Use either dateProperty or datePropertyWithFallback here: -->
	<!ENTITY newsDate "&dateProperty;">
	
	<!-- Sort order for output -->
	<!ENTITY sortOrder "descending">
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	
	<xsl:param name="currentPage" select="/root/*[1]" />

	<!-- Index by year -->
	<xsl:key name="NewsByYear" match="&NewsItem;" use="substring(&newsDate;, 1, 4)" />
	<!-- Index by month (in year) -->
	<xsl:key name="NewsByMonth" match="&NewsItem;" use="substring(&newsDate;, 1, 7)" />
	
	<xsl:template match="/">
		<div>
			<xsl:apply-templates select="$currentPage/&NewsSection;[1]" />
		</div>
	</xsl:template>
	
<!-- :: Functionality templates :: -->
<!--
	The three templates here performs the grouping and structuring.
	All actual output is delegated to separate templates below.
-->
	<xsl:template match="&NewsSection;">
		<!-- Apply templates to unique years -->
		<xsl:apply-templates select="&NewsItem;[count(. | key('NewsByYear', substring(&newsDate;, 1, 4))[1]) = 1]" mode="uniq.years">
			<xsl:sort select="&newsDate;" data-type="text" order="&sortOrder;" />
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="&NewsItem;" mode="uniq.years">
		<xsl:variable name="year" select="substring(newsDate, 1, 4)" />
		<xsl:variable name="current-group" select="key('NewsByYear', $year)" />
		
		<!-- Output year -->
		<xsl:apply-templates select="newsDate" mode="year" />
			
		<!-- Apply templates to unique months in current year -->
		<xsl:apply-templates select="$current-group[count(. | key('NewsByMonth', substring(&newsDate;, 1, 7))[1]) = 1]" mode="uniq.months">
			<xsl:sort select="&newsDate;" data-type="text" order="&sortOrder;" />
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="&NewsItem;" mode="uniq.months">
		<xsl:variable name="year" select="substring(&newsDate;, 1, 4)" />
		<xsl:variable name="month" select="substring(&newsDate;, 6, 2)" />

		<!-- Output month -->
		<xsl:apply-templates select="&newsDate;" mode="month" />
		
		<!-- Apply templates to dates in the current month -->
		<xsl:apply-templates select="key('NewsByMonth', concat($year, '-', $month))">
			<xsl:sort select="&newsDate;" data-type="text" order="&sortOrder;" />
		</xsl:apply-templates>
	</xsl:template>

<!-- :: Output templates :: -->
<!--
	All output has been confined to these templates so it's easier to modify.
	You will only need to modify the templates above, if you need to change the
	overall structure (i.e., create wrapping elements or similar).
-->

	<!-- Writing the year -->
	<xsl:template match="* | @*" mode="year">
		<h2><xsl:value-of select="substring(., 1, 4)" /></h2>
	</xsl:template>
	
	<!-- Writing the month -->
	<xsl:template match="* | @*" mode="month">
		<h3><xsl:value-of select="substring(., 6, 2)" /></h3>
	</xsl:template>

	<!-- Sample template for a single NewsItem -->
	<xsl:template match="&NewsItem;">
		<p>
			<xsl:value-of select="title" />
		</p>
	</xsl:template>
	
</xsl:stylesheet>