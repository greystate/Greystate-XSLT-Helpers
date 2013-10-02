# Navigation Helper

Building navigations is a great way to learn the intricacies of XSLT and XPath. If you've done navigations you'll have noticed that
they're usually very similar to each other, and yet there seem to always be a single little difference that requires you to change something or swap stuff around.

This is why most of the "Generic Navigation" scripts you'll encounter, have grown to be pretty large "libraries" with a myriad of settings.

So this is actually mostly a test to see if I'll use this myself. I always write my navigations from scratch because they're never
really identical to the previous one I wrote.

`_NavigationHelper.xslt` was extracted from various navigations I've built (the reusable parts, anyway) and intended to use as an include for your own.

## Basic Usage

The Navigation Helper makes it very easy to create four of the most common navigation types: **Main Navigation**, **Sub Navigation**, **Breadcrumb** & **Sitemap** - you simply apply templates to `$currentPage` in the desired mode, e.g.:

```xslt
<xsl:template match="/">
	<nav id="main">
		<ul>
			<xsl:apply-templates select="$currentPage" mode="navigation.main" />
		</ul>
	</nav>
</xsl:template>

<xsl:include href="helpers/_NavigationHelper.xslt" />
```

Note that Navigation Helper renders all the `<li>` and `<a>` elements for you - but you need to wrap your own `<ul>` and/or `<div>`, `<nav>` etc. around them - this gives you maximum flexibility in shaping as many class/id/wrapper combinations as possible.

The available modes are:

* **navigation.main** 	: Main site navigation (children of the *Home* node)
* **navigation.sub** 	: Subnavigation (children of the selected node in Main)
* **navigation.crumb** 	: Breadcrumb trail - *$currentPage*, it's parent, parent's parent etc. Does *not* render the top node (see below)
* **navigation.map**	: Traditional Sitemap - the full tree below the node it's applied to, in an exploded view

There's a fifth mode called **navigation.link** which is the one all of the others use for rendering the actual `<li><a href="...">...</a></li>` combo.
You can use that mode if you've got a custom menu where all the items are *hand-picked*
(e.g. using a [Multi-Node Tree Picker][MNTP] in Umbraco) - and then you'd get all the behavior you get from the others, like automatic 'selected' class if applicable.

[MNTP]: http://ucomponents.codeplex.com/documentation/

## Customization

As with most of the other helpers in this package, you can send a couple of parameters along when you invoke the templates, to tailor the output:

### Turn off *higlighting* selected nodes

By default, the **main** and **sub** modes will add the "selected" class to nodes on the `$currentPage` branch, but you can turn that off by sending `false()` into the `highlight` parameter:

```xslt
<xsl:template match="/">
	<ul>
		<xsl:apply-templates select="$currentPage" mode="navigation.main">
			<!-- Client does not want highlighting for main items -->
			<xsl:with-param name="highlight" select="false()" />
		</xsl:apply-templates>
	</ul>
</xsl:template>
```

### Specifying levels to output

By default, the **sub** mode renders the children of the selected node in the main navigation, but it lets you specify a *start-* and *endlevel* for those times where you need something a little different, e.g.:    

```xslt
<ul id="subnav">
	<xsl:apply-templates select="$currentPage" mode="navigation.sub">
		<!-- Confine subnav to levels 3 and 4 -->
		<xsl:with-param name="levels" select="'3-4'" />
	</xsl:apply-templates>
</ul>
```

### CSS class for selected nodes

I have always used the CSS class name "selected" - if you're used to something different,
you can change the name in the `$selectedClass` variable. *Note: This is the only class Navigation Helper applies - CSS is pretty smart these days, and besides, I've not had the need myself for any additional classes (e.g. "first", "last", "inPath" etc.) - if you're on a project with requirements like that, you need to modify the template in mode "navigation.link".*

### Why do you exclude the Home node in the breadcrumb mode?

The main reason for this is that in 98% of all cases you'll want to change it anyway; Umbraco will usually give you a link like this:

```html
<li><a href="/clientsite-com">ClientSite.com</a></li>
```

But you want the link to be to the root ("/") and the text to be something like "Front", "Home", "&#x2191;", e.g.:

```html
<li><a href="/">Home</a></li>
```

So to create breadcrumbs with Navigation Helper, just do like this:

```xslt
<ul class="breadcrumb">
	<li><a href="/" title="Go to the home page">Home</a></li>
	<xsl:apply-templates select="$currentPage" mode="navigation.crumb" />
</ul>
```

### How to render all navigations from a single macro in Umbraco

You can create a single XSLT macro to render all of your site's navigations like this:

1. Create a new XSLT file - use the "Clean" template and name it "Navigation"
2. Find the "Navigation" Macro and add a Macro Parameter called `mode` of type `text`
3. Replace the XSLT with the following code and Save the file (if you're editing in the Umbraco UI you need to check the **Skip testing (ignore errors)** checkbox before saving):

```xslt
<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umb="urn:umbraco.library"
	exclude-result-prefixes="umb"
>

	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

	<xsl:param name="currentPage" />
	
	<xsl:variable name="mode" select="/macro/mode" />
	
	<xsl:template match="/">
		<!-- Use The MEXAH, Luke ... -->
		<xsl:apply-templates select="$currentPage[$mode = 'mainnav']" mode="navigation.main" />
		<xsl:apply-templates select="$currentPage[$mode = 'subnav']" mode="navigation.sub" />
		<xsl:apply-templates select="$currentPage[$mode = 'breadcrumb']" mode="navigation.crumb" />
		<xsl:apply-templates select="$currentPage[$mode = 'sitemap']" mode="navigation.map" />
	</xsl:template>

	<xsl:include href="helpers/_NavigationHelper.xslt" />

</xsl:stylesheet>
```

(Remember to put the `dist/_NavigationHelper.xslt` file in the `xslt/helpers` folder as well)

Now, in your templates, you can just add the **Navigation** macro and choose the appropriate mode
(you should use the mode names inside the squarebrackets above), e.g.:

```html
<asp:Content PlaceHolderId="bodyContent" runat="server">
	
	<ul id="mainnav">
		<umbraco:Macro alias="Navigation" mode="mainnav" runat="server" />
	</ul>
	
	<ul>
		<li><a href="/">Home</a></li>
		<umbraco:Macro alias="Navigation" mode="breadcrumb" runat="server" />
	</ul>
	
</asp:Content>
```

