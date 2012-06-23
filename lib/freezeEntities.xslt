<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % version SYSTEM "../version.ent">
	%version;
]>
<!--
	The development versions of the XSLT Helpers relies on a solid set of entity definitions.
	This stylesheet is a modified "Identity Transform" used for freezing the entities to their
	"RELEASE" values so the release versions don't rely on any external entities.
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:x="http://www.w3.org/1999/XSL/TransformAlias"
	xmlns:freeze="http://xmlns.greystate.dk/2012/freezer"
>

	<xsl:output method="xml"
		indent="yes"
		omit-xml-declaration="no"
		cdata-section-elements="Design readme"
	/>

	<!-- Identity transform -->
	<xsl:template match="/">
		<xsl:apply-templates select="* | text() | comment() | processing-instruction('umbraco-package')" />
	</xsl:template>
		
	<xsl:template match="* | text()">
		<xsl:copy>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates select="* | text() | comment() | processing-instruction()" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="comment() | processing-instruction()">
		<xsl:copy-of select="." />
	</xsl:template>
	
	<xsl:template match="*[@freeze:remove = 'yes']" priority="1">
		<!-- Remove from output -->
	</xsl:template>
	
<!--
	Converts the dummy processing-instruction to a versioned header.
	(Entities in comments + processing-instructions are not resolved by the XML parser.)
-->
	<xsl:template match="processing-instruction('umbraco-package')">
		<xsl:processing-instruction name="umbraco-package">
			<xsl:text>&XSLTHelpersVersionHeader;</xsl:text>
			<xsl:apply-templates select="following-sibling::processing-instruction()" />
		</xsl:processing-instruction>
		<xsl:text>&#x0A;</xsl:text>
	</xsl:template>
	
	<xsl:template match="processing-instruction('MediaHelperVersion')">
		<xsl:text> - MediaHelper v&MediaHelperVersion;</xsl:text>
	</xsl:template>
	
	<xsl:template match="processing-instruction('PaginationHelperVersion')">
		<xsl:text> - PaginationHelper v&PaginationHelperVersion;</xsl:text>
	</xsl:template>
	
	<xsl:template match="processing-instruction('NavigationHelperVersion')">
		<xsl:text> - NavigationHelper v&NavigationHelperVersion;</xsl:text>
	</xsl:template>
	
	<xsl:template match="processing-instruction('GroupingHelperVersion')">
		<xsl:text> - GroupingHelper v&GroupingHelperVersion;</xsl:text>
	</xsl:template>
	
	<xsl:template match="processing-instruction('CalendarHelperVersion')">
		<xsl:text> - CalendarHelper v&CalendarHelperVersion;</xsl:text>
	</xsl:template>
	
</xsl:stylesheet>