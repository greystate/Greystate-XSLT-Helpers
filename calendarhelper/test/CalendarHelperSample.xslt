<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:func="http://exslt.org/functions"
	xmlns:date="http://xmlns.greystate.dk/functions"
>

	<xsl:template match="/">
		
		<xsl:call-template name="BuildCalendar" />
		
	</xsl:template>

	<xsl:include href="../_CalendarHelper.xslt" />

</xsl:stylesheet>