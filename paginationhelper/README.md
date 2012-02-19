# Pagination Helper

You&#8217;ve probably been doing pagination more than once in your life as a developer; and most likely in
more than one language, right? Yeah, so have I &#8212; and every time I&#8217;ve said to myself: "Why can&#8217;t
I just include some kind of file that does this and be done with it already?".
So I finally went and built a general purpose, easily modifiable way to paginate stuff with XSLT, and I couldn&#8217;t
think of a single reason why it shouldn&#8217;t be available to you too, so here it is. 

This was developed while using the excellent [Umbraco CMS](http://umbraco.com) but I have extracted the generic bits so
it should be usable as a drop-in solution whenever you&#8217;re doing XSLT and suddenly get that "Oh, I guess I&#8217;ll need
to paginate this set..." feeling.

## How to use it

There&#8217;s very little work involved in using the Pagination Helper, basically you do three things:

1. Include `_PaginationHelper.xslt` in your main XSLT file (e.g. an Umbraco macro XSLT file)

		<xsl:include href="_PaginationHelper.xslt" />

2. Create a *template* for a single item to be rendered (e.g. a search result or a thumbnail image)

		<xsl:template match="Textpage">
			<li>
				<a href="{umbraco.library:NiceUrl(@id)}">
					<img src="{pageImageThumbnail}" width="100" height="80" alt="{@nodeName}" />
				</a>
			</li>
		</xsl:template>

3. Call the `PaginateSelection` template where you want the paged result to appear 

		<xsl:template match="/">
			<xsl:call-template name="PaginateSelection">
				<xsl:with-param name="selection" select="$currentPage/Textpage" />
			</xsl:call-template>
		</xsl:template>

Simple, huh?

## Details

By default, the `PaginateSelection` template will paginate the children of the context node when called, but you can
specify the exact selection of nodes to paginate by supplying the parameter `selection` when calling the template.
(So, in Umbraco, we&#8217;ll use `$currentPage` for context as long as we&#8217;re inside the *root* template.

If for some reason you need to render the *pager controls* in a specific place and not as part of the automatic
output, you can turn them off with the `showPager` parameter by supplying `false()` or `0` (zero). Then you
can manually output the controls by calling `RenderPager`, using the same `selection` parameter as you called the
`PaginateSelection` template with, to get the paging controls where you want them.

## Customization

The actual pagination is done with a *QueryString* parameter named `p`, which can be changed if you need to - it&#8217;s
defined in the *variable* `pagerParam` right at the top of the file. Here you can also change the wording of the
*Previous* and *Next* links generated, and the number of results per page (default is 10). You can even change the function that
retrieves the options for the current page, which defaults to Umbraco&#8217;s `umbraco.library:RequestQueryString`
but if you&#8217;re not using this with Umbraco you&#8217;re bound to get that from some other extension function.
It assumes the standard query string `key=value&otherkey=othervalue` format.


### Paginating search results

TODO




