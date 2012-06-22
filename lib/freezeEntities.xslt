<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % version SYSTEM "../version.ent">
	%version;
	
	<!ENTITY indent "&#x09;">
	<!ENTITY newline "&#x0a;">
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
		<xsl:if test="//processing-instruction('ENTITY')">
			<xsl:call-template name="GenerateDoctype" />
		</xsl:if>
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
			<xsl:apply-templates select="following-sibling::processing-instruction()[not(name() = 'ENTITY')]" />
		</xsl:processing-instruction>
		<xsl:text>&newline;</xsl:text>
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
	
	<!-- Major trickery here - NOT recommended, but the only way to do what I want using XSLT 1.0 -->
	<xsl:template name="GenerateDoctype">
		<xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE xsl:stylesheet []]></xsl:text>
			<xsl:text>&newline;</xsl:text>
			<xsl:apply-templates select="/processing-instruction('ENTITY')" />
		<xsl:text disable-output-escaping="yes"><![CDATA[]>]]></xsl:text>
		<xsl:text>&newline;</xsl:text>
	</xsl:template>
	
	<!-- Creates the equivalent of an ENTITY declaration in the result tree -->
	<xsl:template match="processing-instruction('ENTITY')">
		<xsl:text>&indent;</xsl:text>
		<xsl:text disable-output-escaping="yes"><![CDATA[<!ENTITY ]]></xsl:text>
		<xsl:value-of select="." disable-output-escaping="yes" />
		<xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
		<xsl:text>&newline;</xsl:text>
	</xsl:template>
	
</xsl:stylesheet>