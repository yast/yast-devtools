<?xml version="1.0"?><!-- -*- XML -*- -->
<!-- $Id$ -->
<!-- a template for yxp queries -->
<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
version="1.0">

  <xsl:output method="text"/>

  <!-- disable copying of text and attrs -->
  <xsl:template match="text()|@*"/>
   
  <!-- this is currently substituted by a sed script -->
  <xsl:template match="&PATTERN;">
    <!-- 
	Cannot simply use @line because only the lexical elements have it.
	So we use the first lexical element's line
    -->
    <xsl:value-of select="descendant-or-self::*/@line"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>
</xsl:stylesheet>
