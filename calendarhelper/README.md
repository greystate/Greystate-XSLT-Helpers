# Calendar Helper

This helper will generate a calendar for any given month and you can have it automatically apply your
custom templates to events (XML nodes with a datetime attribute/property) that occur on dates in that
month.

It's fully localizable and you don't have to put up with the "but Sunday *is* the first day of the week"
from various others :-)


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






