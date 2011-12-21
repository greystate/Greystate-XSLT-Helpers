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

The `_MediaHelper.xslt` makes it really easy to handle your Umbraco media from XSLT, because most of the time, you can use a single
line of code to get what you want - the following use cases illustrate how:


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

1. **Set a specific id for the image**

	Add the `id` parameter:

		<xsl:apply-templates select="pageImage" mode="media">
			<xsl:with-param name="id" select="'topBanner'" />
		</xsl:apply-templates>
	
1. **Add a specific CSS class to the image**

	Add the `class` parameter to the statement:

		<xsl:apply-templates select="pageImage" mode="media">
			<xsl:with-param name="class" select="'slide'" />
		</xsl:apply-templates>

1. **Override the `width` and `height` attributes for an image**

	Add the `size` parameter:
	
		<xsl:apply-templates select="pageImage" mode="media">
			<xsl:with-param name="size" select="'400x300'" />
		</xsl:apply-templates>

1. **Combine the various options**

	You can use all of them together where it makes sense (e.g., in the media.url mode,
	only the crop parameter makes sense):
	
		<xsl:apply-templates select="pageImage" mode="media">
			<xsl:with-param name="class" select="'slide'" />
			<xsl:with-param name="crop" select="'ImageGallery'" />
			<xsl:with-param name="id" select="concat('slide', position())" />
		</xsl:apply-templates>
	
## Advanced usage

### Getting a random image from a specified folder

A common pattern on a web page is to have an image that changes on every page load, and to make that very easy,
there's a simple change you can make to have that happen automatically. Just create a folder of images to choose
from, and create a Media Picker property that points to the folder, so the editor can change it at will. Then put
a simple `mode.random` on the apply-templates instruction:

	<xsl:apply-templates select="imageFolder" mode="media.random" />
	
Of course, you can combine this with the `size`, `class` and `id` parameters. And you can *even* use this next one too: 

### Cropping support baked in

If you use the `Image Cropper` Data Type (or one of the [compatible packages][DAMP]), you can grap a specific crop very easy;
just add the `crop` parameter:

	<xsl:apply-templates select="pageImage" mode="media">
		<xsl:with-param name="crop" select="'GalleryThumb'" />
	</xsl:apply-templates>

By default, this will create an image tag with empty `width` and `height` attributes, because that info is not available in the XML,
but you can create a config file for the Media Helper to use, if you would like to generate the correct dimensions (which can
eliminate potential reflow during rendering). Create an XML file called `cropping-config.xml` in the XSLT directory and specify the sizes you've set up for the crops, e.g.:

	<crops>
		<crop name="Large" size="800x600" />
		<crop name="Small" size="320x480" />
	</crops>

That's it!


[DAMP]: http://our.umbraco.org/projects/backoffice-extensions/digibiz-advanced-media-picker	

