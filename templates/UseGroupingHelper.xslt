<?xml version="1.0" encoding="utf-8" ?>
<!--
	Sample use of the _GroupingHelper.xslt
	Will render clickable thumbnails of all images in a folder selected
	by a Media Picker, as list items in groups of 4 wrapped in a <ul class="slide">.
-->
<xsl:stylesheet
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library"
	{0}
	exclude-result-prefixes="msxml umbraco.library {1}"
>

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

	<xsl:param name="currentPage" />
	<xsl:variable name="siteRoot" select="$currentPage/ancestor-or-self::*[@level = 1]" />

	<!-- galleryFolder is a Media Picker property on the current page -->
	<xsl:variable name="mediaFolderId" select="$currentPage/galleryFolder" />
	
	<xsl:template match="/">
		<!-- The GetMedia() extension fails without an id -->
		<xsl:if test="normalize-space($mediaFolderId)">
			
			<xsl:variable name="mediaFolder" select="umbraco.library:GetMedia($mediaFolderId, true())" />
			
			<xsl:call-template name="GroupifySelection">
				<xsl:with-param name="selection" select="$mediaFolder/Image" />
				<xsl:with-param name="groupSize" select="4" />
				<xsl:with-param name="element" select="'ul'" />
				<xsl:with-param name="class" select="'slide'" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- This is the template for every item in the group -->
	<xsl:template match="Image">
		<xsl:variable name="baseName" select="substring-before(umbracoFile, concat('.', umbracoExtension))" />
		<li>
			<a href="{umbracoFile}">
				<img src="{$baseName}_thumb.jpg" alt="{@nodeName}" />
			</a>
		</li>
	</xsl:template>
	
	<!-- Include Grouping Helper -->
	<xsl:include href="_GroupingHelper.xslt" />

</xsl:stylesheet>