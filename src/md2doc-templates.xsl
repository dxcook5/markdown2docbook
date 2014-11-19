<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns="http://docbook.org/ns/docbook"
    xmlns:xl="http://www.w3.org/1999/xlink"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:md2doc="http://www.markdown2docbook.com/ns/md2doc"
    exclude-result-prefixes="xs xl html md2doc"
    xpath-default-namespace="">
    
    <xsl:template match="root" mode="md2doc:transform">
        <xsl:param name="root-element"/>
        <xsl:param name="headline-element"/>
        <xsl:choose>
            <xsl:when test="$root-element != ''">
                <xsl:element name="{$root-element}">
                    <xsl:attribute name="version" select="5"/>
                    <xsl:if test="boolean(/root/*//a)">
                        <xsl:namespace name="xl">http://www.w3.org/1999/xlink</xsl:namespace>  
                    </xsl:if>   
                    <xsl:if test="
                        ($root-element eq 'chapter' or
                        $root-element eq 'article' or
                        $root-element eq 'preface' or
                        $root-element eq 'glossary' or
                        $root-element eq 'dedication' or
                        $root-element eq 'bibliography')
                        ">
                        <title><xsl:value-of select="$root-element"/></title>
                    </xsl:if>
                    <xsl:call-template name="md2doc:headline-grouping">
                        <xsl:with-param name="headline-element" select="$headline-element"/>
                        <xsl:with-param name="root-element" select="$root-element"/>
                    </xsl:call-template>
                </xsl:element>    
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="md2doc:headline-grouping">
                    <xsl:with-param name="headline-element" select="$headline-element"/>
                    <xsl:with-param name="root-element" select="$root-element"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="md2doc:headline-grouping">
        <xsl:param name="headline-element"/>
        <xsl:param name="root-element"/>
        <xsl:for-each-group select="*" 
            group-starting-with="h1|
            h2[not(preceding-sibling::h1)]|
            h3[not(preceding-sibling::h2)]|
            h4[not(preceding-sibling::h3)]|
            h5[not(preceding-sibling::h4)]|
            h6[not(preceding-sibling::h5)]
            ">                    
            <xsl:apply-templates select="." mode="md2doc:group">
                <xsl:with-param name="headline-element" select="$headline-element"/>
                <xsl:with-param name="root-element" select="$root-element"/>
            </xsl:apply-templates>
            <!--            <xsl:message select="'headline grouping: ',."/>-->
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="h1|h2|h3|h4|h5|h6" mode="md2doc:group">
        <xsl:param name="headline-element"/>
        <xsl:param name="root-element"/>
        <xsl:variable name="this" select="name()"/>
        <xsl:variable name="next" select="translate($this, '123456', '234567')"/>
        <xsl:element name="{
            if ($this eq 'h1' and $headline-element != '') 
            then $headline-element 
            else concat('sect',translate(replace($this,'h',''),'23456','12345'))
            }">
            <xsl:if test="$root-element eq '' and $this eq 'h1'">
                <xsl:attribute name="version" select="5"/>
                <xsl:if test="boolean(/root//*[a])">
                    <xsl:namespace name="xl">http://www.w3.org/1999/xlink</xsl:namespace>  
                </xsl:if>             
            </xsl:if>
            <title><xsl:apply-templates select="." mode="md2doc:transform"/></title>
            <xsl:for-each-group select="current-group() except ." group-starting-with="*[name() = $next]">
<<<<<<< HEAD
                <xsl:apply-templates select="." mode="md2doc:group">
                    <xsl:with-param name="headline-element" select="$headline-element"/>
                    <xsl:with-param name="root-element" select="$root-element"/>
                </xsl:apply-templates>
=======
                <xsl:apply-templates select="." mode="md2doc:group"/>
>>>>>>> parent of 1729a78... added documentation
                <!--<xsl:message>hX rule: <xsl:copy-of select="."/></xsl:message>-->
            </xsl:for-each-group>
            <xsl:message select="'root: ',$root-element"/>
        </xsl:element>
    </xsl:template> 
    
    <xsl:template match="p" mode="md2doc:group">
        <xsl:apply-templates select="current-group()" mode="md2doc:transform"/>
        <!--        <xsl:message select="'Rule * group mode: ', current-group()"/>-->
    </xsl:template>
    
    <xsl:template match="p" mode="md2doc:transform">
        <para><xsl:apply-templates select="node()|@*" mode="md2doc:transform"/></para>
        <!--        <xsl:message select="'Rule p no mode: ', ."/>-->
    </xsl:template>
    
    <xsl:template match="blockquote" mode="md2doc:group">
        <xsl:apply-templates select="current-group()" mode="md2doc:transform"/>
    </xsl:template>
    
    <xsl:template match="blockquote" mode="md2doc:transform">
        <blockquote>
            <xsl:apply-templates mode="md2doc:transform"/>
        </blockquote>
    </xsl:template>
    
    <xsl:template match="blockquote/h1" mode="md2doc:transform">
        <title><xsl:apply-templates mode="md2doc:transform"/></title>
    </xsl:template>
    
    <xsl:template match="ul" mode="md2doc:group">
        <xsl:apply-templates select="current-group()" mode="md2doc:transform"/>
    </xsl:template>
    
    <xsl:template match="ul" mode="md2doc:transform">
        <itemizedlist>
            <xsl:apply-templates mode="md2doc:transform"/>
        </itemizedlist>
    </xsl:template>
    
    <xsl:template match="ol" mode="md2doc:group">
        <xsl:apply-templates select="current-group()" mode="md2doc:transform"/>
    </xsl:template>
    
    <xsl:template match="ol" mode="md2doc:transform">
        <orderedlist>
            <xsl:apply-templates select="*" mode="md2doc:transform"/>
        </orderedlist>
    </xsl:template>
    
    <xsl:template match="li" mode="md2doc:transform">
        <listitem>
            <xsl:choose>
                <xsl:when test="p">
                    <xsl:apply-templates select="node()|@*" mode="md2doc:transform"/>
                </xsl:when>
                <xsl:otherwise>
                    <para><xsl:apply-templates select="node()|@*" mode="md2doc:transform"/></para>
                </xsl:otherwise>
            </xsl:choose>
        </listitem>
    </xsl:template>
    
    <xsl:template match="li/h1" mode="md2doc:transform">
        <xsl:apply-templates mode="md2doc:transform"/>
    </xsl:template>
    
    <xsl:template match="pre" mode="md2doc:group">
        <xsl:apply-templates select="current-group()" mode="md2doc:transform"/>
    </xsl:template>
    
    <xsl:template match="pre" mode="md2doc:transform">
        <example>
            <xsl:apply-templates mode="md2doc:transform"/>    
        </example>
    </xsl:template>
    
    <xsl:template match="code[ancestor::pre]" mode="md2doc:transform">
        <programlisting>         
            <xsl:value-of select="." disable-output-escaping="no"/>
        </programlisting>
    </xsl:template>
    
    <xsl:template match="hr" mode="md2doc:group">
        <xsl:apply-templates select="current-group()" mode="md2doc:transform"/>
    </xsl:template>
    
    <xsl:template match="hr" mode="md2doc:transform"/>
    
    <xsl:template match="textarea" mode="md2doc:group">
        <xsl:apply-templates select="current-group()" mode="md2doc:transform"/>      
    </xsl:template>
    
    <xsl:template match="textarea" mode="md2doc:transform">
        <example>
            <programlisting language="html">
                <xsl:value-of select="text()" disable-output-escaping="no"/> 
            </programlisting>
        </example>          
    </xsl:template>
    
    <!--During seriliazation, this template will cause that textarea string is turned into html-->
    <!--<xsl:template match="textarea" mode="md2doc:transform">
        <xsl:value-of select="text()" disable-output-escaping="yes"/>      
    </xsl:template>-->
    
    <xsl:template match="code|samp" mode="md2doc:transform">
        <computeroutput>
            <xsl:value-of select="." disable-output-escaping="yes"/>
        </computeroutput>
    </xsl:template>
    
    <xsl:template match="em|strong" mode="md2doc:transform">
        <emphasis>
            <xsl:apply-templates select="node()|@*" mode="md2doc:transform"/>
        </emphasis>
    </xsl:template>
    
    <xsl:template match="img" mode="md2doc:transform">
        <inlinemediaobject>
            <imageobject>
                <imagedata fileref="{@src}"/>
            </imageobject>
            <alt><xsl:value-of select="@alt"/></alt>
            <!--existuje i alt tag a kam dam title informaci?-->
        </inlinemediaobject>
    </xsl:template>
    
    <xsl:template match="a" mode="md2doc:transform">
        <link>
            <xsl:attribute name="xl:href">
                <xsl:value-of select="@href"/>
            </xsl:attribute>
            <xsl:if test="@title = ''">
                <alt><xsl:value-of select="@title"/></alt>
            </xsl:if>         
            <xsl:apply-templates select="node()" mode="md2doc:transform"/>
        </link>
    </xsl:template>
    
    <!--HTML TEMPLATES-->
    
    <xsl:template match="address|article|aside|body|button|div|
        figure|fieldset|footer|form|header|map|nav|object|section|
        video|script|noscript|iframe" mode="md2doc:group">
        <xsl:apply-templates select="current-group()" mode="md2doc:transform"/> 
    </xsl:template>

    <xsl:template match="article|aside|body|button|div|
        figure|fieldset|footer|form|header|map|nav|object|section|
        script|noscript|iframe" mode="md2doc:transform">
        <para><xsl:value-of select="node()|@*"/></para>
    </xsl:template>
    
    <xsl:template match="address" mode="md2doc:transform">
        <address>
            <xsl:apply-templates mode="md2doc:transform"/>
        </address>
    </xsl:template>
    
    <xsl:template match="video" mode="md2doc:transform">
        <mediaobject>
            <videobject>
                <videodata fileref="{@src}"/>
            </videobject>
            <textobject>
                <para><xsl:value-of select="text()"/></para>
            </textobject>
        </mediaobject>
    </xsl:template>
    
    <xsl:template match="embed[starts-with(@type,'video')]" mode="md2doc:transform">
        <mediaobject>
            <videobject>
                <videodata fileref="{@src}"/>
            </videobject>
        </mediaobject>
    </xsl:template>
    
    <!--Table transform-->   
    <xsl:template match="table" mode="md2doc:group">
        <xsl:apply-templates select="current-group()" mode="md2doc:transform"/>
    </xsl:template>
    
    <xsl:template match="table" mode="md2doc:transform">
        <xsl:choose>
            <xsl:when test="caption">
                <table>
                    <xsl:apply-templates mode="md2doc:transform"/>
                </table>
            </xsl:when>
            <xsl:otherwise>
                <informaltable>
                    <xsl:apply-templates mode="md2doc:transform"/>
                </informaltable>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="thead" mode="md2doc:transform">
        <thead>
            <xsl:apply-templates mode="md2doc:transform"/>
        </thead>
    </xsl:template>
    
    <xsl:template match="tbody" mode="md2doc:transform">
        <tbody>
            <xsl:apply-templates mode="md2doc:transform"/>
        </tbody>
    </xsl:template>
    
    <xsl:template match="tfoot" mode="md2doc:transform">
        <tfoot>
            <xsl:apply-templates mode="md2doc:transform"/>
        </tfoot>
    </xsl:template>
    
    <xsl:template match="caption" mode="md2doc:transform">
        <caption>
            <xsl:apply-templates mode="md2doc:transform"/>
        </caption>
    </xsl:template>
    
    <xsl:template match="tr" mode="md2doc:transform">
        <tr>
            <xsl:for-each select="th">
                <th>
                    <xsl:apply-templates mode="md2doc:transform"/>
                </th>
            </xsl:for-each>
            <xsl:for-each select="td">
                <td>
                    <xsl:apply-templates mode="md2doc:transform"/>
                </td>
            </xsl:for-each>
        </tr>
    </xsl:template>
    
    <!--Definition list transform-->
    <xsl:template match="dl" mode="md2doc:group">
        <xsl:apply-templates select="current-group()" mode="md2doc:transform"/>
    </xsl:template>
    
    <xsl:template match="dl" mode="md2doc:transform">
        <variablelist>
            <varlistentry>
                <xsl:for-each select="dt">
                    <term>
                        <xsl:apply-templates mode="md2doc:transform"/>
                    </term>
                </xsl:for-each>
                <xsl:for-each select="dd">
                    <listitem>
                        <para><xsl:apply-templates mode="md2doc:transform"/></para>
                    </listitem>
                </xsl:for-each>
            </varlistentry>
        </variablelist>
    </xsl:template>
    
    <!--HTML inline elements-->
    <xsl:template match="b|i|del|ins|span|small|dfn|object|textarea|script|button|label" mode="md2doc:transform">
        <xsl:apply-templates mode="md2doc:transform"/>
    </xsl:template>
    
    <xsl:template match="abbr" mode="md2doc:transform">
        <abbrev>
            <xsl:apply-templates mode="md2doc:transform"/>
        </abbrev>
    </xsl:template>
    
    <xsl:template match="cite" mode="md2doc:transform">
        <citation>
            <xsl:apply-templates mode="md2doc:transform"/>
        </citation>
    </xsl:template>
    
    <xsl:template match="kbd" mode="md2doc:transform">
        <keycap>
            <xsl:apply-templates mode="md2doc:transform"/>
        </keycap>
    </xsl:template>
    
    <xsl:template match="var" mode="md2doc:transform">
        <varname>
            <xsl:apply-templates mode="md2doc:transform"/>
        </varname>
    </xsl:template>
    
    <xsl:template match="q" mode="md2doc:transform">
        <quote>
            <xsl:apply-templates mode="md2doc:transform"/>
        </quote>
    </xsl:template>
    
    <xsl:template match="sub" mode="md2doc:transform">
        <subscript>
            <xsl:apply-templates mode="md2doc:transform"/>
        </subscript>
    </xsl:template>
    
    <xsl:template match="sup" mode="md2doc:transform">
        <superscript>
            <xsl:apply-templates mode="md2doc:transform"/>
        </superscript>
    </xsl:template>
    
    <!--<xsl:template match="node()|@*" name="identity" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="#current"/>
        </xsl:copy>
    </xsl:template>-->
    
</xsl:stylesheet>