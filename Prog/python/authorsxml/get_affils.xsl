<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cal="http://www.slac.stanford.edu/spires/hepnames/authors_xml/"
    xmlns:foaf="http://xmlns.com/foaf/0.1/">

    <xsl:output method="text" />

<xsl:template match="/">
    <xsl:for-each select="collaborationauthorlist/cal:organizations/foaf:Organization">
        <xsl:value-of select="@id"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="foaf:name"/>
        <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
</xsl:template>
</xsl:stylesheet>


