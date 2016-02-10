<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
	<!-- Add your custom Image Media Type aliases here -->
	<!ENTITY CustomImageTypes "*[@id and @nodeTypeAlias]">
]>
<!--
	_MediaHelper.xslt
	
	Enables simple retrieval of media by handling the GetMedia() call and error-checking
-->
<?umbraco-package XSLT Helpers v1.2.2 - MediaHelper v2.1?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:umb="urn:umbraco.library" xmlns:freeze="http://xmlns.greystate.dk/2012/freezer" xmlns:get="urn:Exslt.ExsltMath" xmlns:make="urn:schemas-microsoft-com:xslt" version="1.0" exclude-result-prefixes="umb get make freeze">

	

	<xsl:variable name="maxWidthForUnknownCrop" select="800"/>

	<!-- Template for any media that needs fetching - handles potential error -->
	<xsl:template match="*" mode="media">
		<xsl:param name="class"/>
		<xsl:param name="crop"/>
		<xsl:param name="id"/>
		<xsl:param name="size"/>
		<xsl:param name="retinafy"/>
		<xsl:variable name="mediaNode" select="umb:GetMedia(., false())"/>
		<xsl:apply-templates select="$mediaNode[not(error)]">
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="crop" select="$crop"/>
			<xsl:with-param name="id" select="$id"/>
			<xsl:with-param name="size" select="$size"/>
			<xsl:with-param name="retinafy" select="$retinafy"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Template for any mediafolder that needs fetching - handles potential error -->
	<xsl:template match="*" mode="media.folder">
		<xsl:param name="class"/>
		<xsl:param name="crop"/>
		<xsl:param name="size"/>
		<xsl:param name="retinafy"/>
		<xsl:variable name="mediaFolder" select="umb:GetMedia(., true())"/>
		<xsl:apply-templates select="$mediaFolder[not(error)]">
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="crop" select="$crop"/>
			<xsl:with-param name="size" select="$size"/>
			<xsl:with-param name="retinafy" select="$retinafy"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Template for getting a random item from a mediafolder -->
	<xsl:template match="*" mode="media.random">
		<xsl:param name="class"/>
		<xsl:param name="crop"/>
		<xsl:param name="size"/>
		<xsl:param name="count" select="1"/><!-- Currently unused -->
		<xsl:variable name="mediaFolder" select="umb:GetMedia(., true())"/>
		<xsl:variable name="randomNumber" select="floor(get:random() * (count($mediaFolder/*[@id])) + 1)"/>
		
		<xsl:apply-templates select="$mediaFolder[not(error)]/*[@id][position() = $randomNumber]">
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="crop" select="$crop"/>
			<xsl:with-param name="size" select="$size"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Template for a Media Folder - default to rendering all images/files inside -->
	<xsl:template match="Folder">
		<xsl:param name="class"/>
		<xsl:param name="crop"/>
		<xsl:param name="size"/>
		<xsl:param name="retinafy"/>
		<xsl:apply-templates select="*[@id]">
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="crop" select="$crop"/>
			<xsl:with-param name="size" select="$size"/>
			<xsl:with-param name="retinafy" select="$retinafy"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Template for a Media Image -->
	<xsl:template match="Image" name="GenericImage">
		<xsl:param name="class"/>
		<xsl:param name="crop"/>
		<xsl:param name="id"/>
		<xsl:param name="size"/>
		<xsl:param name="retinafy"/>
		<img src="{umbracoFile}" width="{umbracoWidth}" height="{umbracoHeight}" alt="{@nodeName}">
			<!-- In retina mode use half dimensions -->
			<xsl:if test="$retinafy">
				<xsl:attribute name="width"><xsl:value-of select="floor(umbracoWidth div 2)"/></xsl:attribute>
				<xsl:attribute name="height"><xsl:value-of select="floor(umbracoHeight div 2)"/></xsl:attribute>
				<xsl:attribute name="src">
					<xsl:value-of select="concat(umbracoFile,       '?width=', floor(umbracoWidth div 2),       '&amp;height=', floor(umbracoHeight div 2))"/>
				</xsl:attribute>
				<xsl:attribute name="srcset"><xsl:value-of select="concat(umbracoFile, ' 2x')"/></xsl:attribute>
			</xsl:if>

			<xsl:if test="$crop">
				<xsl:variable name="cropData" select="umb:JsonToXml(umbracoFile)"/>
				<xsl:variable name="cropset" select="$cropData/crops[alias = $crop]"/>

				<!-- Fallback if specified crop does not exist -->
				<xsl:attribute name="src"><xsl:value-of select="concat(umbracoFile, '?width=', $maxWidthForUnknownCrop)"/></xsl:attribute>
				
				<xsl:if test="$cropset">
					<xsl:attribute name="src">
						<xsl:value-of select="$cropData/src"/>
						<xsl:apply-templates select="$cropset">
							<xsl:with-param name="halfsize" select="$retinafy"/>
						</xsl:apply-templates>
					</xsl:attribute>
					<xsl:attribute name="width"><xsl:value-of select="$cropset/width"/></xsl:attribute>
					<xsl:attribute name="height"><xsl:value-of select="$cropset/height"/></xsl:attribute>
					
					<xsl:if test="$retinafy">
						<xsl:attribute name="srcset">
							<xsl:value-of select="$cropData/src"/>
							<xsl:apply-templates select="$cropset"/>
							<xsl:text> 2x</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="width"><xsl:value-of select="floor($cropset/width div 2)"/></xsl:attribute>
						<xsl:attribute name="height"><xsl:value-of select="floor($cropset/height div 2)"/></xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:if test="not($cropset)">
					<xsl:attribute name="width"/>
					<xsl:attribute name="height"/>
				</xsl:if>
			</xsl:if>
			
			<!-- $size can override original + cropped sizes -->
			<xsl:if test="$size">
				<xsl:attribute name="width"><xsl:value-of select="substring-before($size, 'x')"/></xsl:attribute>
				<xsl:attribute name="height"><xsl:value-of select="substring-after($size, 'x')"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$class"><xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute></xsl:if>
			<xsl:if test="$id"><xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute></xsl:if>
		</img>
	</xsl:template>
			
<!-- :: URL Templates :: -->
	<!-- Entry template -->
	<xsl:template match="*" mode="media.url">
		<xsl:param name="crop"/>
		<xsl:variable name="mediaNode" select="umb:GetMedia(., false())"/>
		<xsl:apply-templates select="$mediaNode[not(error)]" mode="url">
			<xsl:with-param name="crop" select="$crop"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- Safeguards for empty elements - need one for each mode -->
	<xsl:template match="*[not(normalize-space())]" mode="media">
		<!-- Render info to the developer looking for clues in the source, as to why nothing renders -->
		<xsl:comment>Missing Media ID in <xsl:value-of select="name()"/> on <xsl:value-of select="../@nodeName"/> (ID: <xsl:value-of select="../@id"/>)</xsl:comment>
	</xsl:template>
	
	<xsl:template match="*[not(normalize-space())]" mode="media.url">
		<xsl:apply-templates select="." mode="media"/><!-- Redirect to the one above -->
	</xsl:template>
	
	<xsl:template match="*[not(normalize-space())]" mode="media.folder" priority="0">
		<xsl:apply-templates select="." mode="media"/><!-- Redirect to the one above -->
	</xsl:template>
	
	<!-- URL Template for Images -->
	<xsl:template match="Image" mode="url">
		<xsl:param name="crop"/>
		<xsl:choose>
			<xsl:when test="$crop">
				<xsl:variable name="cropData" select="umb:JsonToXml(umbracoFile)"/>
				<xsl:if test="$cropData and $cropData/crops[alias = $crop]">
					<xsl:value-of select="$cropData/src"/>
					<xsl:apply-templates select="$cropData/crops[alias = $crop]"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="umbracoFile"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Template for easier support of custom Media Types -->
	<xsl:template priority="-1" match="&CustomImageTypes;">
		<xsl:param name="class"/>
		<xsl:param name="crop"/>
		<xsl:param name="id"/>
		<xsl:param name="size"/>
		<xsl:param name="retinafy"/>

		<xsl:call-template name="GenericImage">
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="crop" select="$crop"/>
			<xsl:with-param name="id" select="$id"/>
			<xsl:with-param name="size" select="$size"/>
			<xsl:with-param name="retinafy" select="$retinafy"/>
		</xsl:call-template>
	</xsl:template>
	
<!-- :: Crop templates :: -->
	<xsl:template match="json/crops">
		<xsl:param name="halfsize"/>
		<xsl:variable name="fp" select="../focalPoint"/>
		<xsl:variable name="fpTop" select="format-number($fp/top, '#.0000000')"/>
		<xsl:variable name="fpLeft" select="format-number($fp/left, '#.0000000')"/>
		<xsl:variable name="width" select="floor(width div (1 + number(boolean($halfsize))))"/>
		<xsl:variable name="height" select="floor(height div (1 + number(boolean($halfsize))))"/>
		
		<xsl:value-of select="concat('?', 'mode=crop', '&amp;center=', $fpTop, ',', $fpLeft)"/>
		
		<xsl:value-of select="concat('&amp;width=', $width, '&amp;height=', $height)"/>
	</xsl:template>
	
	<xsl:template match="json/crops[coordinates]">
		<xsl:param name="halfsize"/>
		<xsl:variable name="coords" select="coordinates"/>
		<xsl:variable name="width" select="floor(width div (1 + number(boolean($halfsize))))"/>
		<xsl:variable name="height" select="floor(height div (1 + number(boolean($halfsize))))"/>

		<xsl:value-of select="concat('?', 'crop=', $coords/x1, ',', $coords/y1, ',', $coords/x2, ',', $coords/y2)"/>
		<xsl:value-of select="concat('&amp;cropmode=', 'percentage')"/>
		<xsl:value-of select="concat('&amp;width=', $width, '&amp;height=', $height)"/>
	</xsl:template>
	
</xsl:stylesheet>
