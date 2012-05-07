<?xml version="1.0"?>
<?umbraco-package XSLT Helpers v0.7 - NavigationHelper v1.0?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:umb="urn:umbraco.library" version="1.0" exclude-result-prefixes="umb">

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<!-- :: Configuration :: -->
	<!-- CSS class for selected/active items -->
	<xsl:variable name="selectedClass" select="'selected'"/>
	
	<!-- Top level -->
	<xsl:variable name="topLevel" select="2"/>
	
<!-- :: Templates :: -->
	<!-- Main navigation -->
	<xsl:template match="*" mode="navigation.main">
		<!-- Find the top-level node -->
		<xsl:variable name="siteRoot" select="ancestor-or-self::*[@level = $topLevel]"/>
		
		<xsl:apply-templates select="$siteRoot/*[@isDoc][not(umbracoNaviHide = 1)]" mode="navigation.link"/>
	</xsl:template>
	
	<!-- Sub navigation -->
	<xsl:template match="*" mode="navigation.sub">
		<xsl:param name="levels" select="concat($topLevel, '-', 99)"/>
		<xsl:variable name="topLevelNode" select="ancestor-or-self::*[@level = $topLevel]"/>
		<xsl:variable name="currentSection" select="($topLevelNode | ancestor-or-self::*[@level = substring-before($levels, '-') - 1])[last()]"/>

		<xsl:apply-templates select="$currentSection/*[@isDoc][not(umbracoNaviHide = 1)]" mode="navigation.link">
			<xsl:with-param name="endLevel" select="substring-after($levels, '-')"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Breadcrumb -->
	<xsl:template match="*" mode="navigation.crumb">
		<xsl:apply-templates select="ancestor-or-self::*[ancestor::*[@level = $topLevel]]" mode="navigation.link">
			<xsl:with-param name="highlight" select="false()"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Sitemap -->
	<xsl:template match="*" mode="navigation.map">
		<xsl:apply-templates select="." mode="navigation.link">
			<xsl:with-param name="recurse" select="true()"/>
			<xsl:with-param name="highlight" select="false()"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- Generic template for nav items -->
	<xsl:template match="*" mode="navigation.link">
		<xsl:param name="endLevel" select="0"/>
		<xsl:param name="highlight" select="true()"/>
		<xsl:param name="recurse"/>
		<xsl:variable name="hasCurrentPageInBranch" select="descendant-or-self::*[@id = $currentPage/@id]"/>
		<li>
			<!-- Add the selected class if needed -->
			<xsl:if test="$highlight and $hasCurrentPageInBranch"><xsl:attribute name="class"><xsl:value-of select="$selectedClass"/></xsl:attribute></xsl:if>

			<!-- Generate link -->
			<a href="{umb:NiceUrl}" title="{@nodeName}">
				<xsl:value-of select="@nodeName"/>
			</a>

			<!-- Recurse if needed (and there are pages to show) -->
			<xsl:if test="($recurse or (@level &lt; $endLevel and $hasCurrentPageInBranch)) and *[@isDoc][not(umbracoNaviHide = 1)]">
				<ul>
					<xsl:apply-templates select="*[@isDoc][not(umbracoNaviHide = 1)]" mode="navigation.link">
						<xsl:with-param name="recurse" select="$recurse"/>
						<xsl:with-param name="endLevel" select="$endLevel"/>
						<xsl:with-param name="highlight" select="$highlight"/>
					</xsl:apply-templates>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>

</xsl:stylesheet>
