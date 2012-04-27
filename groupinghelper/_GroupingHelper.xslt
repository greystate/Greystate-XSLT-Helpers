<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % entities SYSTEM "entities.ent">
	%entities;
]>
<?umbraco-package This is a dummy for the packageVersion entity - see ../lib/freezeEntities.xslt ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

	<!-- 'Groupify' template -->
	<xsl:template name="GroupifySelection">
		<xsl:param name="selection" select="/.." />
		<xsl:param name="&groupSizeParam;" select="5" />
		<xsl:param name="&elementParam;" select="'div'" />
		
		<xsl:apply-templates select="$selection[position() mod $&groupSizeParam; = 1]" mode="group">
			<xsl:with-param name="selection" select="$selection" />
			<xsl:with-param name="&groupSizeParam;" select="$&groupSizeParam;" />
			<xsl:with-param name="&elementParam;" select="$&elementParam;" />
		</xsl:apply-templates>
		
	</xsl:template>
	
	<!-- Group/wrapper template -->
	<xsl:template match="*" mode="group">
		<xsl:param name="selection" select="/.." />
		<xsl:param name="&groupSizeParam;" />
		<xsl:param name="&elementParam;" />
		<xsl:element name="{$&elementParam;}">
			<xsl:variable name="pos" select="position()" />
			<xsl:variable name="first" select="$&groupSizeParam; * ($pos - 1) + 1" />
			<xsl:variable name="last" select="$pos * $&groupSizeParam;" />
			
			<xsl:apply-templates select="$selection[position() &gt;= $first and position() &lt;= $last]" />
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>

