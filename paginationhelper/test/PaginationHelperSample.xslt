<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

	<xsl:template match="/">
		<body>
			<!-- <xsl:call-template name="parseOptions">
				<xsl:with-param name="options" select="'page=7&amp;v=34&amp;f=345&amp;start=yuriuyiuyeæøås'" />
			</xsl:call-template> -->
			<xsl:apply-templates />
		</body>
	</xsl:template>

	<xsl:template match="people">
		<xsl:call-template name="PaginateSelection">
			<xsl:with-param name="page" select="4" />
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="person">
		<p>
			<a href="{email}"><xsl:value-of select="name" /></a>
		</p>
	</xsl:template>

	<xsl:include href="../_PaginationHelper.xslt" />

</xsl:stylesheet>