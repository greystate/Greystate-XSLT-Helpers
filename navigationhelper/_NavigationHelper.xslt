<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % entities SYSTEM "entities.ent">
	%entities;
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

	
	<xsl:template match="*">
		<li>
			<a href="{&linkURL;}">
				<xsl:value-of select="&linkName;" />
			</a>
		</li>
	</xsl:template>

</xsl:stylesheet>