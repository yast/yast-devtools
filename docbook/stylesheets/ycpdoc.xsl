<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes" encoding="ISO-8859-1"/> 
    <xsl:param name="module" />
    <xsl:param name="include" />
    <xsl:variable name="moduleName" />

    <xsl:template match="/">
        <xsl:apply-templates/> 
    </xsl:template>

    <xsl:template match="//file_item[@key=$include]">
        <xsl:apply-templates> 
            <xsl:with-param name="moduleName" select="$moduleName" />
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="header">
    </xsl:template>

    <xsl:template match="intro_html">
    </xsl:template>

    <xsl:template match="files">
        <xsl:apply-templates select="file_item"/>
    </xsl:template>

    <xsl:template match="file_item">
        <xsl:variable name="moduleName" select="substring-before(@key,'.')"/>
        <xsl:variable name="referenceName"
            select="concat(substring-before(@key,'.'), '.xml')"/>

        <xsl:if test="requires/requires_item/kind = 'module'" >
            <xsl:document href="{$referenceName}" method="xml" indent="yes" encoding="ISO-8859-1"> 
                <reference>
                    <xsl:attribute name="id">
                        <xsl:text>Module_</xsl:text>
                        <xsl:value-of select="$moduleName"/>
                        <xsl:text>_</xsl:text>
                        <xsl:text>reference</xsl:text>
                    </xsl:attribute>
                    <title>
                        <xsl:apply-templates select="header/summary"/>
                    </title>

                    <xsl:apply-templates select="provides">
                        <xsl:with-param name="moduleName" select="$moduleName" />
                    </xsl:apply-templates>

                    <xsl:apply-templates select="requires"> 
                        <xsl:with-param name="moduleName" select="$moduleName" />
                    </xsl:apply-templates>
                </reference>
            </xsl:document>
        </xsl:if>
    </xsl:template>


    <xsl:template match="descr">
        <xsl:if test="count(descr_item) > 0">
            <refsect1>
                <title>Description</title>
                <xsl:for-each select="descr_item">
                    <para>
                        <xsl:value-of select="."/>
                    </para>
                </xsl:for-each>
            </refsect1>
        </xsl:if>
    </xsl:template>

    <xsl:template match="see">
        <xsl:if test="count(see_item) > 0">
            <refsect1>
                <title>See</title>
                <itemizedlist>
                    <xsl:for-each select="see_item">
                        <listitem>
                                <xsl:choose>
                                    <xsl:when
                                        test="starts-with(normalize-space(.),'bug #')">
                                        <ulink>
                                            <xsl:attribute name="url">
                                                <xsl:text>http://bugzilla.suse.de/</xsl:text><xsl:value-of
                                                        select="substring(normalize-space(.),6,5)"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="."/>
                                        </ulink>
                                    </xsl:when>
                                    <xsl:when test="contains(.,' ')">
                                        <para>
                                            <xsl:value-of select="."/>
                                        </para>
                                    </xsl:when>
                                    <xsl:otherwise>
                            <link>

                                        <xsl:attribute name="linkend">
                                            <xsl:text>Module_</xsl:text>
                                            <xsl:value-of select="$moduleName"/>
                                            <xsl:text>_</xsl:text>
                                            <xsl:value-of select="."/>
                                        </xsl:attribute>
                                        <xsl:value-of select="$moduleName"/>
                                        <xsl:text>::</xsl:text>
                                        <xsl:value-of select="."/>
                            </link>
                                    </xsl:otherwise>
                                </xsl:choose>
                        </listitem>
                    </xsl:for-each>
                </itemizedlist>
            </refsect1>
        </xsl:if>
    </xsl:template>

    <xsl:template match="screenshot">
        <xsl:if test=". != ''">
            <refsect1>
                <title>Screenshot</title>
                <informalfigure>

                    <mediaobject>
                        <imageobject>
                            <imagedata>
                                <xsl:attribute name="fileref">
                                    <xsl:value-of select="."/>
                                </xsl:attribute>
                                <xsl:attribute name="revision">
                                    <xsl:text>1</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="format">
                                    <xsl:text>PNG</xsl:text>
                                </xsl:attribute>
                            </imagedata>
                        </imageobject>
                    </mediaobject>
                </informalfigure>

            </refsect1>
        </xsl:if>
    </xsl:template>
    <xsl:template match="deprecated">
        <xsl:if test=". = 'magicnumber'">
            <refsect1>
                <title>Deprecated</title>
                <para>
                    This function is deprecated.
                </para>
            </refsect1>
        </xsl:if>
    </xsl:template>


    <xsl:template match="requires">
        <xsl:apply-templates select="requires_item"> 
            <xsl:with-param name="moduleName" select="$moduleName" />
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="requires_item">
        <xsl:if test="kind = 'include'">
            <xsl:variable name="include" select="substring-after(name,'/')"/>
            <xsl:apply-templates select="//file_item[@key=$include]">
                    <xsl:with-param name="moduleName" select="$moduleName" />
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>

    <xsl:template match="provides">
        <xsl:if test="count(provides_item) > 0">
            <xsl:for-each select="provides_item">
                <xsl:sort select="name"/>
                <xsl:if test='global = 1'>
                    <xsl:call-template name="provides_item">
                        <xsl:with-param name="moduleName" select="$moduleName" />
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <xsl:template name="provides_item">
        <xsl:if test="kind = 'function'">
            <refentry>
                <xsl:attribute name="id">
                    <xsl:text>Module_</xsl:text>
                    <xsl:value-of select="$moduleName"/>
                    <xsl:text>_</xsl:text>
                    <xsl:value-of select="name"/>
                </xsl:attribute>

                <refmeta>
                    <refentrytitle>
                        <xsl:value-of select="$moduleName"/>
                        <xsl:text>::</xsl:text>
                        <xsl:value-of select="name"/>
                    </refentrytitle>
                    <manvolnum>3</manvolnum>
                </refmeta>
                <refnamediv>
                    <refname>
                        <xsl:value-of select="$moduleName"/>
                        <xsl:text>::</xsl:text>
                        <xsl:value-of select="name"/>
                    </refname>
                    <refpurpose><xsl:value-of select="short"/></refpurpose>
                </refnamediv>
                <refsynopsisdiv>

                    <funcsynopsis>
                        <funcsynopsisinfo>Import <xsl:value-of
                                select="$moduleName"/><xsl:text>;</xsl:text></funcsynopsisinfo>
                        <funcprototype>
                            <funcdef>
                                <type>
                                    <xsl:value-of select="type"/>
                                </type>
                                <function>
                                    <xsl:value-of select="$moduleName"/>
                                    <xsl:text>::</xsl:text>
                                    <xsl:value-of select="name"/>
                                </function>
                            </funcdef>
                            <xsl:apply-templates select="parameters"/>
                        </funcprototype>
                    </funcsynopsis>
                </refsynopsisdiv>
                <xsl:call-template name="varlist_parameters"/>
                <refsect1>
                    <title>Return Value</title>
                    <variablelist>
                        <varlistentry>
                            <term>
                                <type>
                                    <xsl:value-of select="type"/>
                                </type>
                            </term>
                            <listitem>
                                <para>
                                    <xsl:value-of select="return"/>
                                </para>
                            </listitem>
                        </varlistentry>
                    </variablelist>
                </refsect1>
                <xsl:apply-templates select="descr"/>
                <xsl:call-template name="examples"/>
                <xsl:apply-templates select="screenshot"/>
                <xsl:apply-templates select="see">
                    <xsl:with-param name="moduleName" select="$moduleName" />
                </xsl:apply-templates>
                <xsl:apply-templates select="deprecated"/>
            </refentry>
        </xsl:if>
    </xsl:template>


    <xsl:template name="examples">
        <xsl:if test="example != '' or example_file != ''">
            <refsect1>
                <title>Examples</title>
                <xsl:if test="example != ''">
                    <informalexample>
                        <programlisting>
                            <xsl:value-of select="example"/>
                        </programlisting>
                    </informalexample>
                </xsl:if>
                <xsl:apply-templates select="example_file"/>
            </refsect1>
        </xsl:if>
    </xsl:template>

    <xsl:template match="example_file">
        <xsl:if test="count(example_file_item) > 0">
            <xsl:for-each select="example_file_item">
                <informalexample>
                    <programlisting><xi:include 
                            xmlns:xi="http://www.w3.org/2001/XInclude">
                            <xsl:attribute name="href">
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                            <xsl:attribute name="parse">
                                <xsl:text>text</xsl:text>
                            </xsl:attribute>

                        </xi:include>

                    </programlisting>
                </informalexample>
            </xsl:for-each>
        </xsl:if>

    </xsl:template>

    <xsl:template name="varlist_parameters">
        <xsl:if test="count(parameters/parameters_item) > 0 ">
            <refsect1>
                <title>Parameters</title>
                <variablelist>
                    <xsl:for-each select="parameters/parameters_item">
                        <varlistentry>
                            <term>
                                <type>
                                    <xsl:value-of select="type"/>
                                </type>
                                <parameter>
                                    <xsl:value-of select="name"/>
                                </parameter>
                            </term>
                            <listitem>
                                <para>
                                    <xsl:value-of select="description"/>
                                </para>
                            </listitem>
                        </varlistentry>
                    </xsl:for-each>
                </variablelist>
            </refsect1>
        </xsl:if>
    </xsl:template>

    <xsl:template match="parameters">
        <xsl:choose>
            <xsl:when test="count(parameters_item) > 0 ">
                <xsl:for-each select="parameters_item">
                    <paramdef>
                        <type>
                            <xsl:value-of select="type"/>
                        </type>
                        <parameter>
                            <xsl:value-of select="name"/>
                        </parameter>
                    </paramdef>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <void/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
