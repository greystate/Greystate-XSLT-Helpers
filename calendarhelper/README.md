# Calendar Helper

This helper will generate a calendar for any given month and you can have it automatically apply your
custom templates to events (XML nodes with a datetime attribute/property) that occur on dates in that
month.

It's fully localizable and you don't have to put up with the "but Sunday *is* the first day of the week"
from various others :-)

## Credits

This helper was originally written for a specific project, and thus partly paid for by [Udbrud](http://udbrud.nu).
They agreed to open-source the code so we can all benefit from it - [#h5yr](http://h5yr.com)

## Usage

### Getting a calendar for the current month

This is the simplest thing you can do with the Calendar Helper - you simply call the BuildCalendar named template, e.g.:

```xslt
<div id="calendar">
	<xsl:call-template name="BuildCalendar" />
</div>
```

Of course you'll get a `class="today"` on today's date, if it appears in the calendar.


### Showing a specific month

You can of course ask for any given month - just send in the `date` parameter with any date within that
month:

```xslt
<xsl:call-template name="BuildCalendar">
	<xsl:with-param name="date" select="'1970-12-28'" />
</xsl:call-template>
```

### Localizing the calendar

The `_CalendarHelper.xslt` file has a config file in the `App_Data` folder called `calendar-config.xml`,
which contains some easy to understand XML for localizing the calendar. You can add your own language
if you want (*fork, edit, pull request* anyone?), or you can change what you need to get the
output you want. If, say, you needed a very compact calendar&#8212;you could change all the
weekday headers to just the first letter.

### Specifying a class and/or id for the calendar

To help with styling, you can specify a CSS class and/or id which will be attached to the 
main table element:

```xslt
<xsl:call-template name="BuildCalendar">
	<xsl:with-param name="id" select="'weekcal'" />
	<xsl:with-param name="class" select="'cg13theme'" />
</xsl:call-template>
```

### Highlighting a specific date in the calendar

To highlight a specific date in the calendar you specify the `selectedDate` parameter:

```xslt
<xsl:call-template name="BuildCalendar">
	<xsl:with-param name="selectedDate" select="16" />
</xsl:call-template>
```

The date will get a `class="selected"` so you can do the styling yourself.

### Setting first day of week to Sunday

If you're not from around here (I live in Denmark), you may want to change the order of the days
to having Sunday as the first day of the week - there's a global setting for that called `$firstDayOfWeekIsMonday`, that you would then set to `false()` (it's at the top of the file).

But if you need to set it for a specific calendar on a page, you can do so with a parameter of the same name:

```xslt
<xsl:call-template name="BuildCalendar">
	<xsl:with-param name="firstDayOfWeekIsMonday" select="false()" />
</xsl:call-template>
```

## Advanced usage

One of the reasons to have a calendar on a webpage very often is to be able to browse
news or events of some sort, and to do that we take advantage of XSLT's template mechanism,
where you create a template for how you'd like your events rendered inside the calendar - and
then you just pass your events into the **BuildCalendar** template, e.g.:

```xslt
<xsl:call-template name="BuildCalendar">
	<xsl:with-param name="events" select="$siteRoot/News//NewsItem" />
</xsl:call-template>
```

The helper will issue an `<xsl:apply-templates />` instruction on any date that you have events
for and wrap the output in a `<div class="events_today">`.

### How does Calendar Helper know which dates to put events on?

Good question! - OK, for this to work, you need to tell the helper where you store the *date* on your events. At the top of the `_CalendarHelper.xslt` file there's a line that looks like this:

```xml
<!ENTITY eventDate "eventStartDateTime">
```

You can change the *eventStartDateTime* part to match your XML - if you have event nodes that look like this:

```xml
<Events>
	<Event datetime="2012-06-13T22:02:12+0200">
		<title>We're building something great</title>
		<bodyText>...</bodyText>
	</Event>
	<Event datetime="2012-07-01T14:20:35+0200">
		<title>It's almost here</title>
		<bodyText>...</bodyText>
	</Event>
</Events>
```

\- you should change it to this:

```xml
<!ENTITY eventDate "@datetime">
```

On the other hand, if you had some News nodes looking like these:

```xml
<News>
	<NewsItem>
		<categories>breaking,local</categories>
		<dates>
			<pubDate>2011-08-19T14:00:00+0200</pubDate>
			<regDate>2011-08-17T03:27:01+0200</regDate>
			<offlineDate></offlineDate>
		</dates>
		...
	</NewsItem>
</News>
```

\- you should set it to this:

```xml
<!ENTITY eventDate "dates/pubDate">
```

In other words: It's just an XPath for selecting the value on the event node, so you should be
able to tailor it to your needs. Note that the date value itself MUST be a valid XML Date (but any system that outputs dates to an XML file should do that for your, regardless of how you work with it.)







