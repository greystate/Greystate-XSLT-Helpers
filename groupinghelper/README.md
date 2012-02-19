# Grouping Helper

Closely related to pagination, grouping is another common task with XSLT - whether grouping into lists, table rows or other
constructs ...

## How to use it

You use the Grouping Helper just like you use the Pagination Helper - by calling a named template with a `selection` parameter:

	<xsl:call-template name="GroupifySelection">
		<xsl:with-param name="selection" select="$currentPage/*[@isDoc]" />
	</xsl:call-template>

This will use a default group size of 5 and thus output the childnodes of `$currentPage` in unordered lists of 5 nodes, e.g:

	<ul>
		<li>...</li>
		<li>...</li>
		<li>...</li>
		<li>...</li>
		<li>...</li>
	</ul> 
	<ul>
		<li>...</li>
		<li>...</li>
		<li>...</li>
		<li>...</li>
		<li>...</li>
	</ul> 
	etc.

The `groupSize` parameter changes the number of items in each group:

	<xsl:call-template name="GroupifySelection">
		<xsl:with-param name="selection" select="$currentPage/*[@isDoc]" />
		<xsl:with-param name="groupSize" select="3" />
	</xsl:call-template>


You can use another wrapper element by sending in the `element` parameter:

	<xsl:call-template name="GroupifySelection">
		<xsl:with-param name="selection" select="$siteRoot/panels" />
		<xsl:with-param name="element" select="'div'" />
	</xsl:call-template>

## Advanced usage

Because the individual items are wrapped in `<li>` elements, you'll almost always want to override the 'item' template
when specifying the `element` parameter (unless you just want to change from unordered to ordered lists), so to do that,
you create a template specifying `mode="item"` in the stylesheet that includes the helper, e.g:

	<xsl:stylesheet
		version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	>

		<xsl:template match="/">
			<xsl:call-template name="GroupifySelection">
				<xsl:with-param name="selection" select="$siteRoot/News/NewsItem" />
				<xsl:with-param name="element" select="'dl'" />
				<xsl:with-param name="groupSize" select="4" />
			</xsl:call-template>
		</xsl:template>

		<xsl:include href="_GroupingHelper.xslt" />
	
		<!-- Override for items in each group -->
		<xsl:template match="NewsItem" mode="item">
			<dt><a href="#{@urlName}"><xsl:value-of select="title" /></a></dt>
			<dd><xsl:value-of select="excerpt" /></dd>
		</xsl:template>

	</xsl:stylesheet>
	
Which would group the output in [definition lists][DL] of 4 items each.


[DL]: http://www.w3.org/TR/html4/struct/lists.html#edef-DL





