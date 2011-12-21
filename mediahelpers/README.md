# Media Helpers

These helper templates will do all the heavy lifting associated with using Media in your Umbraco XSLT.

The big problem with Media in Umbraco (from an XSLT standpoint) is, that if you have a property of the "Media Picker" data type,
it stores the id of the chosen media (a good thing, really). To get to your precious media file, you need to use a library function
called `GetMedia()` which takes the id and a boolean (whether to return childnodes as well as the one requested by the id).

And here's the problem: Beginners usually think that they can do something similar to this, and "magically" get an `<img>` tag with the
selected image:

	<xsl:value-of select="umbraco.library:GetMedia(pageImage, 0)" />

There's multiple problems with this - *first of all:* The extension function returns the XML for the media item, so one has to dig
into that and find the various bits needed (e.g.: `<umbracoFile>` and `<umbracoWidth>` etc.). *Second:* If the editor hasn't yet chosen
an image (thus calling the extension with ""), the extension fails miserably and throws an error, which is why there's usually an 
`<xsl:if>` statement wrapped around a call to `GetMedia()`.

>	The `_MediaHelper.xslt` makes it really easy to handle your Umbraco media from XSLT.

## Basic use cases

1. **Render an image tag for the chosen image**

	We can do this with a single line:

		<xsl:apply-templates select="pageImage" mode="media" />
	
	This will only render something if there's actually an id in the `pageImage` property
	and that item is published.

1. **Render only the URL for the chosen image**

	Use the `media.url` mode instead:

		<xsl:apply-templates select="pageImage" mode="media.url" />
		
	Handles missing ids etc. just like the first one. 

1. **Add a specific CSS class to the image**

	Add the `class` parameter to the statement:

		<xsl:apply-templates select="pageImage" mode="media">
			<xsl:with-param name="class" select="'slide'" />
		</xsl:apply-templates>

	
