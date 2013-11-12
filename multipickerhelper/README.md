# MultiPicker Helper

Helper file for rendering various [uComponents][UCOM] datatypes that store node ids; Currently supports:

* Multi-Node Tree Picker
* XPath CheckBox List
* CheckBoxTree
* WidgetGrid (separate package from Matt Brailsford)

**Note:** You need to use "XML" as *Storage Type* and "Node Ids" as *Values* (if applicable) for these data types for this to work.

## How to use it

I wrote a somewhat longer [article about this on Pimp My XSLT][PIMP] - but these are the basics:

1. Include this file in your main XSLT file:

	```xslt
	<xsl:include href="_MultiPickerHelper.xslt" />
	```
	
1. Create templates as usual for the types of nodes that are selectable in the picker, e.g.:

	```xslt
	<xsl:template match="Event">
		<!-- Code for an event -->
	</xsl:template>

	<xsl:template match="Article">
		<!-- Code for an article -->
	</xsl:template>
	```

1. Apply templates in "multipicker" mode, to the picker property:

	```xslt
	<xsl:apply-templates select="featuredContent" mode="multipicker" />
	```

[UCOM]: http://ucomponents.org/
[PIMP]: http://pimpmyxslt.com/articles/multipicker/