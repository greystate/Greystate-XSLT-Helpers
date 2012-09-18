<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % entities SYSTEM "entities.ent">
	%entities;
]>
<?umbraco-package This is a dummy for the packageVersion entity - see ../lib/freezeEntities.xslt ?>
<?NavigationHelperVersion ?>
<!-- You can change this to suit your environment -->
<?ENTITY subPages "*[@isDoc][not(@template = 0) and not(umbracoNaviHide = 1)]"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umb="urn:umbraco.library"
	xmlns:freeze="http://xmlns.greystate.dk/2012/freezer"
	exclude-result-prefixes="umb freeze"
>

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

<!-- :: Configuration :: -->
	<!-- CSS class for selected/active items -->
	<xsl:variable name="selectedClass" select="'selected'" />
	
	<!-- Top level to output -->
	<xsl:variable name="topLevel" select="&topLevel;" />
	
<!-- :: Templates :: -->
	<!-- Main navigation -->
	<xsl:template match="*" mode="navigation.main">
		<!-- Find the top-level node -->
		<xsl:variable name="siteRoot" select="ancestor-or-self::&homeNode;" />
		
		<xsl:apply-templates select="$siteRoot/&subPages;" mode="navigation.link" freeze:keep-entity="subPages" />
	</xsl:template>
	
	<!-- Sub navigation -->
	<xsl:template match="*" mode="navigation.sub">
		<xsl:param name="levels" select="concat($topLevel, '-', &maxLevel;)" />
		<xsl:variable name="topLevelNode" select="ancestor-or-self::*[@level = $topLevel]" />
		<xsl:variable name="currentSection" select="($topLevelNode | ancestor-or-self::*[@level = substring-before($levels, '-') - 1])[last()]" />

		<xsl:apply-templates select="$currentSection/&subPages;" mode="navigation.link" freeze:keep-entity="subPages">
			<xsl:with-param name="endLevel" select="substring-after($levels, '-')" />
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Breadcrumb -->
	<xsl:template match="*" mode="navigation.crumb">
		<xsl:apply-templates select="ancestor-or-self::*[@level &gt;= $topLevel]" mode="navigation.link">
			<xsl:with-param name="highlight" select="&NO;" />
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Sitemap -->
	<xsl:template match="*" mode="navigation.map">
		<xsl:apply-templates select="." mode="navigation.link">
			<xsl:with-param name="recurse" select="&YES;" />
			<xsl:with-param name="highlight" select="&NO;" />
		</xsl:apply-templates>
	</xsl:template>

	<!-- Generic template for nav items -->
	<xsl:template match="*" mode="navigation.link">
		<xsl:param name="endLevel" select="0" />
		<xsl:param name="highlight" select="&YES;" />
		<xsl:param name="recurse" />
		<xsl:variable name="hasCurrentPageInBranch" select="descendant-or-self::*[@id = $currentPage/@id]" />
		<li>
			<!-- Add the selected class if needed -->
			<xsl:if test="$highlight and $hasCurrentPageInBranch"><xsl:attribute name="class"><xsl:value-of select="$selectedClass" /></xsl:attribute></xsl:if>

			<!-- Generate link -->
			<a href="{&linkURL;}" title="{&linkName;}">
				<xsl:value-of select="&linkName;" />
			</a>

			<!-- Recurse if needed (and there are pages to show) -->
			<xsl:if test="($recurse or (@level &lt; $endLevel and $hasCurrentPageInBranch)) and &subPages;" freeze:keep-entity="subPages">
				<ul>
					<xsl:apply-templates select="&subPages;" mode="navigation.link" freeze:keep-entity="subPages">
						<xsl:with-param name="recurse" select="$recurse" />
						<xsl:with-param name="endLevel" select="$endLevel" />
						<xsl:with-param name="highlight" select="$highlight" />
					</xsl:apply-templates>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>

</xsl:stylesheet>