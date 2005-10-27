<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  Description: Convert ...
  Author: Martin Lazar <mlazar@suse.cz>
  Usage:
    $ sabcmd cmdline2db.xsl cmdline_input.xml > cmdline_output_docbook.xml
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" encoding="utf-8" indent="yes" version="1.0" standalone="no"/>

<xsl:template match="options[@type='list']/listentry">
    <listitem>
	<para>
	    <literal><xsl:value-of select="option"/></literal>
	    <xsl:if test="type">
		<literal>&lt;<xsl:value-of select="type"/>&gt;</literal>
	    </xsl:if>
	    <xsl:text> </xsl:text>
	    <xsl:value-of select="help"/>
	</para>
    </listitem>
</xsl:template>

<xsl:template match="options[@type='list']">
    <itemizedlist>
	<xsl:apply-templates select="listentry"/>
    </itemizedlist>
</xsl:template>

<xsl:template match="commands/listentry">
    <section id="{name}">
	<title><xsl:value-of select="name"/></title>
	<para><xsl:value-of select="help"/></para>
	<xsl:apply-templates select="options"/>
	<xsl:if test="example">
	    <para>
		<programlisting>Examples:
<xsl:apply-templates select="example"/></programlisting>
	    </para>
	</xsl:if>
    </section>
</xsl:template>

<xsl:template match="/">

    <xsl:param name="module" select="/commands/module"/>

    <!-- docbook header -->
    <xsl:text disable-output-escaping="yes">
&lt;!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.2//EN"
"/usr/share/xml/docbook/schema/dtd/4.2/docbookx.dtd"[
]&gt;&#10;</xsl:text>

    <!-- docbook book -->
    <book id="cmdline_{$module}">
	<bookinfo>
	    <title>YaST CommandLine: <xsl:value-of select="$module"/></title>
	    <corpauthor>SUSE Linux AG</corpauthor>
	    <copyright>
		<year>2005</year>
		<holder> SUSE Linux AG</holder>
	    </copyright>
	</bookinfo>
	<chapter>
	    <title>Commands</title>
	    <xsl:apply-templates select="/commands/commands/listentry"/>
	</chapter>
    </book>
</xsl:template>

</xsl:stylesheet>

