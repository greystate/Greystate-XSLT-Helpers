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

### Showing a specific month

You can of course ask for any given month - just send in the `date` parameter with any date within that
month:

```xslt
<xsl:call-template name="BuildCalendar">
	<xsl:with-param name="date" select="'1970-12-28'" />
</xsl:call-template>
```


### Selecting a specific date in the calendar

To highlight a specific date in the calendar you specify the `selectedDate` parameter:

```xslt
<xsl:call-template name="BuildCalendar">
	<xsl:with-param name="selectedDate" select="16" />
</xsl:call-template>
```
