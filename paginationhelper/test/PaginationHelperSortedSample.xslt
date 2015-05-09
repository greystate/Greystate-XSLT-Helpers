<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

	<xsl:template match="/">
		<body>
			<xsl:apply-templates />
		</body>
	</xsl:template>

	<xsl:template match="people">
		<xsl:call-template name="PaginateSelection">
			<xsl:with-param name="sortBy" select="'@nickname'" />
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="person">
		<p>
			<xsl:value-of select="name" />
		</p>
	</xsl:template>

	<xsl:include href="../_PaginationHelper.xslt" />

</xsl:stylesheet>
