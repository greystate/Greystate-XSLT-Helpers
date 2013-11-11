# MultiPicker Helper

Helper file for rendering various [uComponents][UCOM] datatypes that store node ids; Currently supports:

* Multi-Node Tree Picker
* XPath CheckBox List
* CheckBoxTree
* WidgetGrid (separate package from Matt Brailsford)

\- when using "XML" as Storage Type and "Node Ids" as Values (if applicable).

## How to use it

Include this file in any XSLT file using `<xsl:include href="_MultiPickerHelper.xslt" />` and in your
main XSLT file just apply templates to the property you want to render, in the *multipicker* mode,
like this:

```xslt
<xsl:apply-templates select="propertyName" mode="multipicker" />
```

[UCOM]: http://ucomponents.org/