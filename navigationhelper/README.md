# Navigation Helper

Building navigations is a great way to learn the intricacies of XSLT and XPath. If you've done navigations you'll have noticed that
they're usually very similar to each other, and yet there seem to always be a single little difference that requires you to change something or swap stuff around.

This is why most of the "Generic Navigation" scripts you'll encounter, have grown to be pretty large "libraries" with a myriad of settings.

So this is actually mostly a test to see if I'll use this myself. I always write my navigations from scratch because they're never
really identical to the previous one I wrote.

`_NavigationHelper.xslt` was extracted from various navigations I've built (the reusable parts, anyway) and intended to use as an include for your own.

## Usage

The Navigation Helper makes it very easy to create four of the most common navigation types: **Main Navigation**, **Sub Navigation**, **Breadcrumb** & **Sitemap** - you simply apply templates to `$currentPage` in the desired mode, e.g.:

	<nav id="main">
		<ul>
			<xsl:apply-templates select="$currentPage" mode="navigation.main" />
		</ul>
	</nav>

Note that Navigation Helper renders all the `<li>` and `<a>` elements for you - but you need to wrap your own <ul> and/or <div>, <nav> etc. around them - this gives you maximum flexibility in shaping as many class/id/wrapper combinations as possible.

The available modes are:

* **navigation.main** 	: Main site navigation (children of the *Home* node)
* **navigation.sub** 	: Subnavigation (children of the selected node in Main)
* **navigation.crumb** 	: Breadcrumb trail - currentPage, it's parent, parent's parent etc. Does *not* render the top node (see below)
* **navigation.map**	: Traditional Sitemap - the full tree below *Home* in an exploded view





