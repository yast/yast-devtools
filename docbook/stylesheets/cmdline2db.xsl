<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  Description:
    Convert the XML form of yast2 command line interface
    help to docbook
  Maintainer: Martin Vidner <mvidner@suse.cz>
  Original author: Martin Lazar <mlazar@suse.cz>
  Usage:
    $ yast2 $module xmlhelp xmlfile=$module.help.xml
    $ sabcmd cmdline2db.xsl $module.help.xml > $module.db.xml
    $ db2ps $module.db.xml
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:config="http://www.suse.com/1.0/configns"
  exclude-result-prefixes="config"
  >

<xsl:output method="xml" encoding="utf-8" indent="yes" version="1.0" standalone="no"
	doctype-public="-//OASIS//DTD DocBook XML V4.2//EN"
	doctype-system="/usr/share/xml/docbook/schema/dtd/4.2/docbookx.dtd"/>

<xsl:template match="options[@config:type='list']/option">
  <varlistentry>
    <term>
      <literal><xsl:value-of select="name"/></literal>
      <xsl:if test="type">
        <xsl:text> (</xsl:text>
        <literal><xsl:value-of select="type"/></literal>
        <xsl:text>)</xsl:text>
      </xsl:if>
   </term>
    <listitem>
	<para>
          <xsl:value-of select="help"/>
	</para>
    </listitem>
  </varlistentry>
</xsl:template>

<xsl:template match="options[@config:type='list']">
    <variablelist>
        <title>Options</title>
	<xsl:apply-templates select="option"/>
    </variablelist>
</xsl:template>

<xsl:template match="commands/command">
    <section id="{name}">
	<title><xsl:value-of select="name"/></title>
	<para><xsl:value-of select="help"/></para>
	<xsl:apply-templates select="options"/>
	<xsl:if test="examples">
          <itemizedlist>
            <title>Examples</title>
            <xsl:apply-templates select="examples/example"/>
          </itemizedlist>
	</xsl:if>
    </section>
</xsl:template>

<xsl:template match="example">
  <listitem>
    <para>
      <literal><xsl:apply-templates /></literal>
    </para>
  </listitem>
</xsl:template>

<xsl:template name="info">
  <xsl:param name="module" select="/commandline/module"/>

  <title>YaST CommandLine: <xsl:value-of select="$module"/></title>
  <corpauthor>SUSE Linux AG</corpauthor>
  <copyright>
    <year>2005</year>
    <holder> SUSE Linux AG</holder>
  </copyright>
</xsl:template>

<xsl:template match="/">

    <xsl:param name="module" select="/commandline/module"/>

    <!-- docbook book -->
    <article id="cmdline_{$module}">
	<articleinfo>
          <xsl:call-template name="info" />
	</articleinfo>
        <section>
          <title>Commands</title>
          <xsl:apply-templates select="/commandline/commands/command"/>
        </section>
    </article>
</xsl:template>

</xsl:stylesheet>

