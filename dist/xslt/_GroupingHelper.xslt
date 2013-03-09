<?xml version="1.0"?>
<?umbraco-package XSLT Helpers v0.8.3 - GroupingHelper v1.0?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- 'Groupify' template -->
	<xsl:template name="GroupifySelection">
		<xsl:param name="selection" select="/.."/>
		<xsl:param name="groupSize" select="5"/>
		<xsl:param name="element" select="'div'"/>
		<xsl:param name="class"/>
		
		<xsl:apply-templates select="$selection[position() mod $groupSize = 1]" mode="group">
			<xsl:with-param name="selection" select="$selection"/>
			<xsl:with-param name="groupSize" select="$groupSize"/>
			<xsl:with-param name="element" select="$element"/>
			<xsl:with-param name="class" select="$class"/>
		</xsl:apply-templates>
		
	</xsl:template>
	
	<!-- Group/wrapper template -->
	<xsl:template match="*" mode="group">
		<xsl:param name="selection" select="/.."/>
		<xsl:param name="groupSize"/>
		<xsl:param name="element"/>
		<xsl:param name="class"/>
		<xsl:element name="{$element}">
			<xsl:if test="$class"><xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute></xsl:if>
			<xsl:variable name="pos" select="position()"/>
			<xsl:variable name="first" select="$groupSize * ($pos - 1) + 1"/>
			<xsl:variable name="last" select="$pos * $groupSize"/>
			
			<xsl:apply-templates select="$selection[position() &gt;= $first and position() &lt;= $last]"/>
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>
