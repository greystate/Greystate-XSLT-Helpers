# Greystate XSLT Helpers

Miscellaneous XSLT files for use as included stylesheets to ease certain common tasks.

Hopefully, using these helpers you should be able to keep your XSLT clean and
readable, while offering a level of indirection for tasks that could require changes in
the low-level implementation, when moved from one system to another.

## Basic usage

Using these helpers usually just require the same 2 steps:

1.	Include the file(s) in your main XSLT file
2.	Perform one of the following actions
	* Applying templates in a specific mode
	* Calling a named template
	
## Helpers

Each helper has its own README but here&#8217;s a quick rundown: 

### Pagination Helper

A self-contained clip-on solution for pagination of node-sets.

> "Just add Pagination"

### Media Helpers

These are probably only applicable to Umbraco macros, since they tackle a very common scenarios:

> How can I output Media files and/or folders from my XSLT macros?

> But I just want to render the image the user picked - why is it so hard???

