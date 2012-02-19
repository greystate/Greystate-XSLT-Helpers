<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % entities SYSTEM "entities.ent">
	%entities;
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

	<!-- :: Groupify Helper :: -->
	<xsl:template name="GroupifySelection">
		<xsl:param name="selection" select="/.." />
		<xsl:param name="groupSize" select="5" />
		<xsl:param name="wrapperElement" select="'ul'" />
		
		<xsl:apply-templates select="$selection[position() mod $groupSize = 1]" mode="group">
			<xsl:with-param name="groupSize" select="$groupSize" />
			<xsl:with-param name="wrapperElement" select="$wrapperElement" />
		</xsl:apply-templates>
		
	</xsl:template>
	
	<xsl:template match="*" mode="group">
		<xsl:param name="groupSize" />
		<xsl:param name="wrapperElement" />
		<xsl:element name="{$wrapperElement}">
			<xsl:apply-templates select=". | following-sibling::*[position() &lt; $groupSize]" mode="item" />
		</xsl:element>
	</xsl:template>
	
	<!-- Override this in your stylesheet -->
	<xsl:template match="*" mode="item">
		<li>
			<xsl:value-of select="." />
		</li>
	</xsl:template>	

</xsl:stylesheet>

