# Media Helpers

These helper templates will do all the heavy lifting associated with using Media in your Umbraco XSLT.

The big problem with Media in Umbraco (from an XSLT standpoint) is, that if you have a property of the "Media Picker" data type,
it stores the id of the chosen media (a good thing, really). To get to your precious media file, you need to use a library function
called `GetMedia()` which takes the id and a boolean (whether to return childnodes as well as the one requested by the id).

And here's the problem: Because most things in Umbraco are easy and simple, newcomers usually think that they can do something 
similar to this, and "magically" get an `<img>` tag with the selected image:

```xslt
<xsl:value-of select="umbraco.library:GetMedia(pageImage, 0)" />
```

There are multiple problems with this - *first of all:* The extension function returns the XML for the media item, so one has to dig
into that and find the various bits needed (e.g.: `<umbracoFile>` and `<umbracoWidth>` etc.). *Second:* If the editor hasn't yet chosen
an image (thus calling the extension with an empty string), the extension fails miserably and throws an error, which is why there's usually an 
`<xsl:if>` statement wrapped around a call to `GetMedia()`.

The `_MediaHelper.xslt` makes it really easy to handle your Umbraco media from XSLT, because most of the time, you can use a single
line of code to get what you want - the following use cases illustrate how:


## Basic use cases

In Umbraco you can use this simple boilerplate for most of the following examples:

```xslt
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umb="urn:umbraco.library"
	exclude-result-prefixes="umb"
>

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

	<xsl:template match="/">

		<!-- Add the sample code here -->

	</xsl:template>
	
	<!-- Include helpers -->
	<xsl:include href="_MediaHelper.xslt" />

</xsl:stylesheet>
```

**NOTE:** *All of the following scenarios "just works", even if you're using the [Digibiz Advanced Media Picker][DAMP] (DAMP) for selecting images (magic!)*


1. **Render an image tag for the chosen image**

	We can do this with a single line where you want the `<img>` to occur:

		<xsl:apply-templates select="$currentPage/pageImage" mode="media" />
	
	This will only render something if there's actually an id in the `pageImage` property
	and that item is published.

1. **Render only the URL for the chosen image**

	Use the `media.url` mode instead:

		<xsl:apply-templates select="$currentPage/pageImage" mode="media.url" />
		
	Handles missing ids etc. just like the first one. 

1. **Set a specific id for the image**

	Add the `id` parameter:

		<xsl:apply-templates select="$currentPage/pageImage" mode="media">
			<xsl:with-param name="id" select="'topBanner'" />
		</xsl:apply-templates>
	
1. **Add a specific CSS class to the image**

	Add the `class` parameter to the statement:

		<xsl:apply-templates select="$currentPage/pageImage" mode="media">
			<xsl:with-param name="class" select="'slide'" />
		</xsl:apply-templates>

1. **Override the `width` and `height` attributes for an image**

	Add the `size` parameter:
	
		<xsl:apply-templates select="$currentPage/pageImage" mode="media">
			<xsl:with-param name="size" select="'400x300'" />
		</xsl:apply-templates>

1. **Combine the various options**

	You can use all of them together where it makes sense (e.g., in the media.url mode,
	only the crop parameter makes sense):
	
		<xsl:apply-templates select="$currentPage/pageImage" mode="media">
			<xsl:with-param name="class" select="'slide'" />
			<xsl:with-param name="crop" select="'ImageGallery'" />
			<xsl:with-param name="id" select="concat('slide', position())" />
		</xsl:apply-templates>

## Advanced usage

### Getting a random image from a specified folder

A common pattern on a web page is to have an image that changes on every page load, and to make that very easy,
there's a simple change you can make to have that happen automatically. Just create a folder of images to choose
from, and create a Media Picker property that points to the folder, so the editor can change it at will. Then put
a simple `media.random` on the apply-templates instruction:

	<xsl:apply-templates select="$currentPage/imageFolder" mode="media.random" />
	
Of course, you can combine this with the `size`, `class` and `id` parameters. And you can *even* use this next one too: 

### Cropping support baked in

If you use cropping with the built-in `Image Cropper` (or the one in the [Image Extras][EXTRAS] package), you can grap a specific crop very easy;
just add the `crop` parameter:

```xslt
<xsl:apply-templates select="$currentPage/pageImage" mode="media">
	<xsl:with-param name="crop" select="'GalleryThumb'" />
</xsl:apply-templates>
```

By default, this will create an `<img>` element with empty `width` and `height` attributes, because that info is not available in the crop XML.
However, you can create a config file for the Media Helper to use, if you would like to generate the correct dimension attributes (which can
eliminate potential reflow during rendering, not to mention protecting against the odd giant image uploaded by "somebody", wrecking the entire frontpage for an hour).

Just edit the included sample XML file called `cropping-config.xml` in the App_Data directory and specify the names and sizes you've set up for the crops, e.g.:

```xml
<crops>
	<crop name="Large" size="800x600" />
	<crop name="Small" size="320x480" />
</crops>
```

That's it - the helpers will make sure to consult your config file before writing the `width` and `height` of crops. 

#### Cropping with the "CropUp" cropper

The [Eksponent.CropUp cropper][CROPUP] is a very cool cropper, and you should of course be able to have these helpers "just work" with that too. Cool thing is you don't even need to create a config file because the helper will just read the one you already made for CropUp!

You can tell the helper to use CropUp when a crop is requested by editing the `useCropUp` variable at the top of the `_MediaHelper.xslt` file:

```xslt
<xsl:variable name="useCropUp" select="true()" />
```

Once you've enabled CropUp support, the `crop` parameter functions as the `args` you can send to CropUp, so if you send a crop name (or its alias) you will get the predefined crop size from the config file, but you can also send a custom crop format, like `600x-` to get an image cropped to 600 pixels wide, keeping the aspect ratio. You can check out the various options on the [CropUp project page.][CROPUP]

### Overriding the templates for Media Types

If you need to further change the HTML that gets rendered for e.g. an Image, you can do so by overriding the `Image` template in your own XSLT
file - *after* the include statement. For example, here's a way to render a `<figure>` element instead:

```xslt
<xsl:template match="/">
	<!-- Render my figure element here, thank you: -->
	<xsl:apply-templates select="$currentPage/pageImage" mode="media" />
</xsl:template>

<!-- Include helpers -->
<xsl:include href="_MediaHelper.xslt" />

<!-- Override Image template -->
<xsl:template match="Image">
	<figure>
		<img src="{umbracoFile}" />
		<figcaption>
			<xsl:value-of select="Fig.: {caption}" />
		</figcaption>
	</figure>
</xsl:template>
```

This gives you the ability to leverage all the error- and parameter-handling of the helper file, but to use your own actual output templates. Your template will even get the parameters you send in the original mode="media" call, so you just need to have your template "accept" them - let's use that same example, specifying a CSS class too:

```xslt
<xsl:template match="/">
	<!-- Render my figure element here, using the 'bantha' class: -->
	<xsl:apply-templates select="$currentPage/pageImage" mode="media">
		<xsl:with-param name="class" select="'bantha'" />
	</xsl:apply-templates>
</xsl:template>

<!-- Include helpers -->
<xsl:include href="_MediaHelper.xslt" />

<!-- Override Image template -->
<xsl:template match="Image">
	<xsl:param name="class" />
	<figure>
		<img src="{umbracoFile}" class="{$class}">
		<figcaption>
			<xsl:value-of select="Fig.: {caption}" />
		</figcaption>
	</figure>
</xsl:template>
```

### Supporting custom Media Types 

This is almost the exact same as the above - except you'll not be overriding, but merely specifying a template for the new type.

Imagine a Media Type called **DownloadItem** - it has a simple *Upload* property, a *Size in bytes* property and a *Description* property - you know
it will be used for PDF files and ZIP files, so you create a template to render both and the rest is just like before:

```xslt
<xsl:template match="/">
	<!-- Render the download item here -->
	<xsl:apply-templates select="$currentPage/downloadItem" mode="media" />
</xsl:template>

<!-- Include helpers -->
<xsl:include href="_MediaHelper.xslt" />

<!-- Custom template for DownloadItem Media Type -->
<xsl:template match="DownloadItem">
	<p>
		<xsl:value-of select="description" />
	</p>
	<a class="download {umbracoExtension}file" href="{umbracoFile}" title="Download {@nodeName} ({umbracoBytes} bytes)">Download</a>
</xsl:template>
```



[DAMP]: http://our.umbraco.org/projects/backoffice-extensions/digibiz-advanced-media-picker	
[EXTRAS]: http://our.umbraco.org/projects/backoffice-extensions/images-extras
[CROPUP]: http://our.umbraco.org/projects/website-utilities/eksponent-cropup

