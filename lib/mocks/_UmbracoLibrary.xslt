<?xml version="1.0" encoding="utf-8" ?>
<!--
	## _UmbracoLibrary.xslt
	
	This file contains a set of mocks for the extension functions
	in the [umbraco.library][1] class, so I can run the exact same XSLT
	files locally on my Mac, as are running within Umbraco on the server.
	
	This works by importing this file in stylesheets that utilize the
	library functions - by way of an [entity trick][2] (surprise) so it only
	happens locally. See the accompanying `Sample.xslt` for how to use this
	along with the `entities.ent` file.
	
	[1]: http://our.umbraco.org/wiki/reference/umbracolibrary/
	[2]: http://pimpmyxslt.com/articles/entity-tricks-part3/
-->
<xsl:stylesheet
	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:func="http://exslt.org/functions"
	xmlns:umb="urn:umbraco.library"
	xmlns:dates="http://exslt.org/dates-and-times"
	xmlns:str="http://exslt.org/strings"
	xmlns:make="http://exslt.org/common"
	xmlns:dotnetstr="urn:Exslt.ExsltStrings"
	xmlns:msxslmake="urn:schemas-microsoft-com:xslt"
	xmlns:cropup="urn:Eksponent.CropUp"
	exclude-result-prefixes="func umb dates str make dotnetstr msxslmake cropup"
	extension-element-prefixes="func"
>

	<xsl:variable name="fixtures" select="document('LibraryMockFixtures.xml')/fixtures/fixture" />

	<!-- ===========================================================
	Mock for NiceUrl(nodeId)
	============================================================ -->
	<func:function name="umb:NiceUrl">
		<xsl:param name="nodeId" />
		<xsl:variable name="node" select="//*[@id = $nodeId]" />
		<func:result>
			<xsl:text>/</xsl:text>
			<xsl:for-each select="$node/ancestor-or-self::*[@isDoc][not(parent::root)]">
				<xsl:value-of select="concat(@urlName, '/')" />
			</xsl:for-each>
		</func:result>
	</func:function>
	
	<!-- ===========================================================
	Mock for GetXmlNodeById(nodeId) if you really must use it :-)
	============================================================ -->
	<func:function name="umb:GetXmlNodeById">
		<xsl:param name="nodeId" />
		<func:result select="//*[@id = $nodeId]" />
	</func:function>
	
	<!-- ===========================================================
	GetMedia(mediaId, deep) - depends on a `_media-fixture.xml` file with sample media nodes
	============================================================ -->
	<func:function name="umb:GetMedia">
		<xsl:param name="mediaId" />
		<xsl:param name="deep" />

		<xsl:variable name="mediaNodes" select="$fixtures[@name = 'Media']" />
		
		<!-- Return the node or a dummy for the error that would otherwise happen -->
		<func:result select="($mediaNodes//*[@id = number($mediaId)] | $mediaNodes//*[@id = 'NaN'])[1]" />
	</func:function>

	<!-- ===========================================================
	Mock for FormatDateTime(date, format)
	============================================================ -->
	<func:function name="umb:FormatDateTime">
		<xsl:param name="date-value" />
		<xsl:param name="format" />
		
		<!-- Split into parts -->
		<xsl:variable name="year" select="substring($date-value, 1, 4)" />
		<xsl:variable name="month" select="substring($date-value, 6, 2)" />
		<xsl:variable name="date" select="substring($date-value, 9, 2)" />

		<!-- TODO: Handle a couple of common formats, like 'YYYY', 'd-M-Y' etc. ? -->

		<!-- Assemble a return value -->
		<func:result select="concat($year, '-', $month, '-', $date)" />
	</func:function>
	
	<!-- ===========================================================
	Mock for CurrentDate() 
	============================================================ -->
	<func:function name="umb:CurrentDate">
		<func:result select="substring(dates:date-time(), 1, 19)" />
	</func:function>
	
	<!-- ===========================================================
	Mock for Split(text, character) 
	============================================================ -->
	<func:function name="umb:Split">
		<xsl:param name="text" />
		<xsl:param name="character" />
		<xsl:variable name="values" select="str:tokenize($text, $character)" />
		<xsl:variable name="result">
			<xsl:for-each select="$values">
				<value><xsl:value-of select="." /></value>
			</xsl:for-each>
		</xsl:variable>
		<func:result select="make:node-set($result)" />
	</func:function>

	<!-- ===========================================================
	Stub for Replace(text, oldValue, newValue) 
	============================================================ -->
	<func:function name="umb:Replace" />
	
	<!-- ===========================================================
	Mock for RequestQueryString()
	============================================================ -->
	<func:function name="umb:RequestQueryString">
		<xsl:param name="key" />
		<xsl:variable name="fixture" select="$fixtures[@name = 'QueryString']" />
		<func:result select="$fixture/item[@key = $key]" />
	</func:function>
	
	<!-- ===========================================================
	Mock for RequestServerVariables()
	============================================================ -->
	<func:function name="umb:RequestServerVariables">
		<xsl:param name="key" />
		<xsl:variable name="fixture" select="$fixtures[@name = 'ServerVariables']" />
		<func:result select="$fixture/item[@key = $key]" />
	</func:function>
	
	<!-- ===========================================================
	Mock for IsLoggedOn()
	============================================================ -->
	<func:function name="umb:IsLoggedOn">
		<xsl:variable name="fixture" select="$fixtures[@name = 'Access']" />
		<func:result select="boolean($fixture/isLoggedOn = 'true')" />
	</func:function>
	
	<!-- ===========================================================
	Mock for HasAccess(nodeId, nodePath)
	============================================================ -->
	<func:function name="umb:HasAccess">
		<xsl:param name="nodeId" />
		<xsl:param name="nodePath" />
		<xsl:variable name="fixture" select="$fixtures[@name = 'Access']/hasAccess" />
		<xsl:variable name="accessInfo" select="($fixture[@id = $nodeId][@path = $nodePath] | $fixture[last()])[1]" />
		<func:result select="boolean($accessInfo = 'true')" />
	</func:function>
	
	<!-- ===========================================================
	Mock for DateGreaterThanOrEqualToday()
	============================================================ -->
	<func:function name="umb:DateGreaterThanOrEqualToday">
		<xsl:param name="date" />
		<xsl:variable name="today" select="umb:CurrentDate()" />
		<func:result select="dates:seconds(dates:difference($today, $date)) &gt;= 0" />
	</func:function>
	
	<!-- ===========================================================
	Mock for DateGreaterThanOrEqual()
	============================================================ -->
	<func:function name="umb:DateGreaterThanOrEqual">
		<xsl:param name="firstDate" />
		<xsl:param name="secondDate" />
		<func:result select="dates:seconds(dates:difference($secondDate, $firstDate)) &gt;= 0" />
	</func:function>
	
	<!-- ===========================================================
	Mock for DateAdd()
	============================================================ -->
	<func:function name="umb:DateAdd">
		<xsl:param name="date" />
		<xsl:param name="type" />
		<xsl:param name="offset" />
		<xsl:variable name="duration">
			<xsl:if test="starts-with($offset, '-')">-</xsl:if>
			<xsl:text>P</xsl:text>
			<xsl:if test="contains('hsHS', $type)">T</xsl:if>
			<xsl:value-of select="translate($offset, '-', '')" />
			<xsl:value-of select="translate($type, 'ymdhs', 'YMDHS')" />
		</xsl:variable>
		<func:result select="dates:add($date, $duration)" />
	</func:function>
	
<!--
	## Miscellaneous extras
	
	We may need these (e.g. when using [some of these helpers][HELPERS])
	
	[HELPERS]: https://github.com/greystate/Greystate-XSLT-Helpers#readme
-->
	<!-- ===========================================================
	Mock for MSXML's node-set()
	============================================================ -->
	<func:function name="msxslmake:node-set">
		<xsl:param name="result-tree-fragment" />
		<func:result select="make:node-set($result-tree-fragment)" />
	</func:function>
	
	<!-- ===========================================================
	Mock for Exslt.NET's split()
	============================================================ -->
	<func:function name="dotnetstr:split">
		<xsl:param name="string" />
		<xsl:param name="char" />
		<func:result select="str:split($string, $char)" />
	</func:function>
	
	<!-- ===========================================================
	Mock for CropUp's UrlByMediaId()
	============================================================ -->
	<func:function name="cropup:UrlByMediaId">
		<xsl:param name="nodeId" />
		<xsl:param name="args" />
		<func:result select="umbracoFile" />
	</func:function>

	<!-- ===========================================================
	Mock for JsonToXml() 
	============================================================ -->
	<xsl:function name="umb:JsonToXml">
		<xsl:param name="property" />
		
		<xsl:variable name="fixture" select="$fixtures[@name = 'JsonToXml']" />
		<xsl:sequence select="$fixture/*[name() = name($property)][@media = $property/../@id]" />
	</xsl:function>

</xsl:stylesheet>