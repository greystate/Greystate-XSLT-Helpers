# Grouping Helper

Closely related to pagination, grouping is another common task with XSLT - whether grouping into lists, table rows or other
constructs ...

## How to use it

You use the Grouping Helper just like you use the Pagination Helper - by creating a template for the individual items,
and then calling a named template with a `selection` parameter:

	<xsl:call-template name="GroupifySelection">
		<xsl:with-param name="selection" select="$currentPage/*[@isDoc]" />
	</xsl:call-template>
	
	<xsl:template match="*[@isDoc]">
		<p>...</p>
	</xsl:template>

This will use a default group size of 5 and thus output the childnodes of `$currentPage` in chunks of 5 paragraphs to each `div`, e.g:

	<div>
		<p>...</p>
		<p>...</p>
		<p>...</p>
		<p>...</p>
		<p>...</p>
	</div> 
	<div>
		<p>...</p>
		<p>...</p>
		<p>...</p>
		<p>...</p>
		<p>...</p>
	</div> 
	etc.

The `groupSize` parameter changes the number of items in each group:

	<xsl:call-template name="GroupifySelection">
		<xsl:with-param name="selection" select="$currentPage/*[@isDoc]" />
		<xsl:with-param name="groupSize" select="3" />
	</xsl:call-template>


You can use another wrapper element by sending in the `element` parameter:

	<xsl:call-template name="GroupifySelection">
		<xsl:with-param name="selection" select="$siteRoot/panels" />
		<xsl:with-param name="element" select="'ul'" />
	</xsl:call-template>




