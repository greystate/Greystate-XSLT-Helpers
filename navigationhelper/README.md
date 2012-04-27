# Navigation Helper

Building navigations is a great way to learn the intricacies of XSLT and XPath. If you've done navigations you'll have noticed that
they're usually very similar to each other, and yet there seem to always be a single little difference that requires you to change something or swap stuff around.

This is why most of the "Generic Navigation" scripts you'll encounter, have grown to be pretty large "libraries" with a myriad of settings.

So this is actually mostly a test to see if I'll use this myself. I always write my navigations from scratch because they're never
really identical to the previous one I wrote.

`_NavigationHelper.xslt` was extracted from various navigations I've built (the reusable parts, anyway) and intended to use as an include for your own.

## Usage

The easiest way to use Navigation Helper with Umbraco, is to create a Macro called "Navigation" and point it to the _NavigationHelper.xslt file - then add a Macro Parameter with the allias `mode` and you're good to go. To add subnavigation to a template just add the `<umbraco:Macro>` server control, like this:

	<umbraco:Macro alias="Navigation" mode="subnav" runat="server" />
	
