<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % entities SYSTEM "entities.ent">
	%entities;
]>
<?umbraco-package This is a dummy for the packageVersion entity - see ../lib/freezeEntities.xslt ?>
<?NavigationHelperVersion ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umb="urn:umbraco.library"
	exclude-result-prefixes="umb"
>

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

	<!-- CSS class for selected/active items -->
	<xsl:variable name="selectedClass" select="'selected'" />
	
	<!-- Main navigation -->
	<xsl:template match="*" mode="mainnav">
		<!-- Find the top-level node -->
		<xsl:variable name="siteRoot" select="ancestor-or-self::&homeNode;" />
		
		<xsl:apply-templates select="$siteRoot/&subPages;" mode="nav" />
	</xsl:template>
	
	<!-- Sub navigation -->
	<xsl:template match="*" mode="subnav">
		<xsl:variable name="currentSection" select="ancestor-or-self::*[parent::&homeNode;]" />
		
		<xsl:apply-templates select="$currentSection/&subPages;" mode="nav" />
	</xsl:template>
	
	<!-- Breadcrumb -->
	<xsl:template match="*" mode="breadcrumb">
		<xsl:apply-templates select="ancestor-or-self::*[ancestor::&homeNode;]" mode="nav" />
	</xsl:template>
	
	<!-- Sitemap -->
	<xsl:template match="*" mode="sitemap">
		<xsl:apply-templates select="." mode="nav">
			<xsl:with-param name="recurse" select="true()" />
		</xsl:apply-templates>
	</xsl:template>

	<!-- Generic template for nav items -->
	<xsl:template match="*" mode="nav">
		<xsl:param name="recurse" />
		<xsl:variable name="isCurrentPage" select="@id = $currentPage/@id" />
		<xsl:variable name="hasCurrentPageBelow" select="descendant::*[@id = $currentPage/@id]" />
		<li>
			<!-- Add the selected class if needed -->
			<xsl:if test="$isCurrentPage or $hasCurrentPageBelow"><xsl:attribute name="class"><xsl:value-of select="$selectedClass" /></xsl:attribute></xsl:if>

			<!-- Generate link -->
			<a href="{&linkURL;}" title="{&linkName;}">
				<xsl:value-of select="&linkName;" />
			</a>

			<!-- Recurse if needed (and there are pages to show) -->
			<xsl:if test="$recurse and &subPages;">
				<ul>
					<xsl:apply-templates select="&subPages;" mode="nav">
						<xsl:with-param name="recurse" select="true()" />
					</xsl:apply-templates>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>

</xsl:stylesheet>