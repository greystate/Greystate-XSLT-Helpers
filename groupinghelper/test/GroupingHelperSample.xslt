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
		<xsl:call-template name="GroupifySelection" />
	</xsl:template>
	
	<xsl:template match="person">
		<p>
			<a href="{email}"><xsl:value-of select="name" /></a>
		</p>
	</xsl:template>

	<xsl:include href="../_GroupingHelper.xslt" />

	<!-- Overrides item mode template in "_GroupingHelper.xslt" -->
	<xsl:template match="name">
		<p>
			<xsl:value-of select="." />
		</p>
	</xsl:template>

</xsl:stylesheet>
