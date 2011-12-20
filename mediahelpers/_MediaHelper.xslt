<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % entities SYSTEM "entities.ent">
	%entities;
]>
<!--
	_MediaHelper.xslt
	
	Enables simple retrieval of media by handling the GetMedia() call and error-checking
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umb="urn:umbraco.library"
	xmlns:get="&random-ns-uri;"
	exclude-result-prefixes="umb get"
>

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	
	<!-- Template for any media that needs fetching - handles potential error -->
	<xsl:template match="*" mode="media">
		<xsl:param name="class" />
		<xsl:param name="id" />
		<xsl:param name="size" />
		<xsl:variable name="mediaNode" select="&GetMediaFile;" />
		<xsl:apply-templates select="$mediaNode[not(error)]">
			<xsl:with-param name="class" select="$class" />
			<xsl:with-param name="id" select="$id" />
			<xsl:with-param name="size" select="$size" />
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Template for any mediafolder that needs fetching - handles potential error -->
	<xsl:template match="*" mode="media.folder">
		<xsl:param name="class" />
		<xsl:param name="size" />
		<xsl:variable name="mediaFolder" select="&GetMediaFolder;" />
		<xsl:apply-templates select="$mediaFolder[not(error)]">
			<xsl:with-param name="class" select="$class" />
			<xsl:with-param name="size" select="$size" />
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Template for getting a random item from a mediafolder -->
	<xsl:template match="*" mode="media.random">
		<xsl:param name="class" />
		<xsl:param name="size" />
		<xsl:param name="count" select="1" /><!-- Currently unused -->
		<xsl:variable name="mediaFolder" select="&GetMediaFolder;" />
		<xsl:variable name="randomNumber" select="floor(get:random() * (count($mediaFolder/*[@id])) + 1)" />
		
		<xsl:apply-templates select="$mediaFolder[not(error)]/*[@id][position() = $randomNumber]">
			<xsl:with-param name="class" select="$class" />
			<xsl:with-param name="size" select="$size" />
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Template for a Media Folder - default to rendering all images/files inside -->
	<xsl:template match="Folder">
		<xsl:apply-templates select="*[@id]" />
	</xsl:template>
	
	<!-- Template for a Media Image -->
	<xsl:template match="Image">
		<xsl:param name="class" />
		<xsl:param name="id" />
		<xsl:param name="size" />
		<img src="{umbracoFile}" width="{umbracoWidth}" height="{umbracoHeight}" alt="{@nodeName}">
			<xsl:if test="$size">
				<xsl:attribute name="width"><xsl:value-of select="substring-before($size, 'x')" /></xsl:attribute>
				<xsl:attribute name="height"><xsl:value-of select="substring-after($size, 'x')" /></xsl:attribute>
			</xsl:if>
			<xsl:if test="$class"><xsl:attribute name="class"><xsl:value-of select="$class" /></xsl:attribute></xsl:if>
			<xsl:if test="$id"><xsl:attribute name="id"><xsl:value-of select="$id" /></xsl:attribute></xsl:if>
		</img>
	</xsl:template>
	
<!-- :: URL Templates :: -->
	<!-- Entry template -->
	<xsl:template match="*" mode="media.url">
		<xsl:variable name="mediaNode" select="&GetMediaFile;" />
		<xsl:apply-templates select="$mediaNode[not(error)]" mode="url" />
	</xsl:template>
	
	<!-- Safeguards for empty elements - need one for each mode -->
	<xsl:template match="*[not(normalize-space())]" mode="media">
		<xsl:comment>Missing Media ID</xsl:comment>
	</xsl:template>
	
	<xsl:template match="*[not(normalize-space())]" mode="media.url">
		<xsl:apply-templates select="." mode="media" />
	</xsl:template>
	
	<xsl:template match="*[not(normalize-space())]" mode="media.folder">
		<xsl:apply-templates select="." mode="media" />
	</xsl:template>
	
	<!-- Template for Images -->
	<xsl:template match="Image" mode="url">
		<xsl:value-of select="umbracoFile" />
	</xsl:template>
	
</xsl:stylesheet>