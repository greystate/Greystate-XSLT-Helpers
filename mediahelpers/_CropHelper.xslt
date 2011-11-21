<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY cropPropertyName "imageCropper">
	<!ENTITY GetMedia "umb:GetMedia">
	<!ENTITY nodeset-ns-uri "urn:schemas-microsoft-com:xslt">
]>
<!--
	_CropHelper.xslt
	
	Helper templates for using the ImageCropper Datatype
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umb="urn:umbraco.library"
	xmlns:make="&nodeset-ns-uri;"
	exclude-result-prefixes="umb make"
>

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

	<!-- Dictionary of crop sizes -->
	<xsl:variable name="cropSizesProxy">
		<crop name="Crop.Front" size="1400x542" />
		<crop name="Crop.Sub" size="1400x280" />
		<crop name="Crop.GraphicThumb" size="192x128" />
	</xsl:variable>
	<xsl:variable name="cropSizes" select="make:node-set($cropSizesProxy)" />

	<!-- Get the media node here - handles potential errors -->
	<xsl:template match="*" mode="media.crop">
		<xsl:param name="crop" select="'Crop.Front'" />
		<xsl:param name="class" />
		<xsl:variable name="mediaNode" select="&GetMedia;(., false())" />
		<!-- Continue with requested crop -->
		<xsl:apply-templates select="$mediaNode[not(error)]" mode="media.crop">
			<xsl:with-param name="crop" select="$crop" />
			<xsl:with-param name="class" select="$class" />
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="Image" mode="media.crop">
		<xsl:param name="crop" select="'Crop.Front'" />
		<xsl:param name="class" />
		<xsl:variable name="size" select="$cropSizes[@name = $crop]/@size" />
		
		<img src="{&cropPropertyName;/crops/crop[@name = $crop]/@url}"
			width="{substring-before($size, 'x')}"
			height="{substring-after($size, 'x')}"
			alt="{@nodeName}">
			<xsl:if test="$class">
				<xsl:attribute name="class">
					<xsl:value-of select="$class" />
				</xsl:attribute>
			</xsl:if>
		</img>
	</xsl:template>
	
	<!-- Templates for returning only the URL for a specific crop on an Image -->
	<xsl:template match="*" mode="media.crop.url">
		<xsl:param name="type" select="'Crop.Front'" />
		<xsl:variable name="mediaNode" select="&GetMedia;(., false())" />
		<xsl:apply-templates select="$mediaNode[not(error)]" mode="crop.url" />
	</xsl:template>
	
	<xsl:template match="Image" mode="crop.url">
		<xsl:param name="crop" select="'Crop.Front'" />
		<xsl:value-of select="&cropPropertyName;/crops/crop[@name = $crop]/@url" />
	</xsl:template>
	
</xsl:stylesheet>