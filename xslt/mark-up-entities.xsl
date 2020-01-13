<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:html="http://www.w3.org/1999/xhtml" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd html"
    version="2.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheet adds <tei:att>xml:lang</tei:att> to every node that lacks this attribute. The value is based on the ancestor.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output encoding="UTF-8" indent="no" method="xml" name="xml" omit-xml-declaration="no" version="1.0"/>
    
    <!-- identify the author of the change by means of a @xml:id -->
<!--    <xsl:param name="p_id-editor" select="'pers_TG'"/>-->
    <xsl:include href="../../../OpenArabicPE/oxygen-project/OpenArabicPE_parameters.xsl"/>
  

    <!-- reproduce everything -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:choice[tei:expan='مطبعة']">
        <xsl:element name="tei:publisher">
            <xsl:attribute name="change" select="concat('#',$p_id-change)"/>
            <xsl:element name="tei:orgName">
                <xsl:attribute name="change" select="concat('#',$p_id-change)"/>
        <!-- check if the change is preceded by "al-" -->
        <xsl:choose>
            <xsl:when test="ends-with(preceding-sibling::text()[1],'ال')">
                <xsl:text>ال</xsl:text>
            </xsl:when>
        </xsl:choose>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
                <!-- add the following word  -->
                <xsl:analyze-string select="following-sibling::text()[1]" regex="(\s*\w+?)\W">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
        </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- document the changes -->
    <xsl:template match="tei:revisionDesc" priority="100">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:element name="tei:change">
                <xsl:attribute name="when" select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                <xsl:attribute name="who" select="concat('#',$p_id-editor)"/>
                <xsl:attribute name="xml:id" select="$p_id-change"/>
                <xsl:text>Added the </xsl:text><tei:att>xml:lang</tei:att><xsl:text> attribute to all nodes that lacked this attribute. The value is based on the closest ancestor.</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
    
</xsl:stylesheet>