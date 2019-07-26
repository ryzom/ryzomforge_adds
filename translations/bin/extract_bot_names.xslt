<?xml version="1.0" encoding="UTF-8"?>
<?xmlspysamplexml L:\primitives\urban_matis.primitive?>
<!--<?xmlspysamplexml R:\code\ryzom\translation\extracted_bot_names.xml?>-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/PRIMITIVES">
		<!-- Extract npc group name-->
		<xsl:for-each select="//CHILD/PROPERTY[NAME = 'class'][STRING = 'npc_group']">
			<xsl:call-template name="output_line">
				<xsl:with-param name="name" select="../PROPERTY[NAME = 'name']/STRING"/>
				<xsl:with-param name="sheet" select="../PROPERTY[NAME = 'bot_sheet_client']/STRING"/>
			</xsl:call-template>
		</xsl:for-each>
		<!-- Extract npc bot name-->
		<xsl:for-each select="//CHILD/PROPERTY[NAME = 'class'][STRING = 'npc_bot']">
			<xsl:choose>
				<xsl:when test="../PROPERTY[NAME = 'sheet_client']/STRING != ''">
					<xsl:call-template name="output_line">
						<xsl:with-param name="name" select="../PROPERTY[NAME = 'name']/STRING"/>
						<xsl:with-param name="sheet" select="../PROPERTY[NAME = 'sheet_client']/STRING"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="output_line">
						<xsl:with-param name="name" select="../PROPERTY[NAME = 'name']/STRING"/>
						<xsl:with-param name="sheet" select="../../PROPERTY[NAME = 'bot_sheet_client']/STRING"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<!-- Extract npc group template name-->
		<xsl:for-each select="//CHILD/PROPERTY[NAME = 'class'][STRING = 'group_template_npc']">
			<xsl:call-template name="output_line">
				<xsl:with-param name="name" select="../PROPERTY[NAME = 'name']/STRING"/>
				<xsl:with-param name="sheet" select="../PROPERTY[NAME = 'bot_sheet_look']/STRING"/>
			</xsl:call-template>
		</xsl:for-each>
		<!-- Extract npc bot template name-->
		<xsl:for-each select="//CHILD/PROPERTY[NAME = 'class'][STRING = 'bot_template_npc']">
			<xsl:choose>
				<xsl:when test="../PROPERTY[NAME = 'sheet_look']/STRING != ''">
					<xsl:call-template name="output_line">
						<xsl:with-param name="name" select="../PROPERTY[NAME = 'name']/STRING"/>
						<xsl:with-param name="sheet" select="../PROPERTY[NAME = 'sheet_look']/STRING"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="output_line">
						<xsl:with-param name="name" select="../PROPERTY[NAME = 'name']/STRING"/>
						<xsl:with-param name="sheet" select="../../PROPERTY[NAME = 'bot_sheet_look']/STRING"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="output_line">
		<xsl:param name="name"/>
		<xsl:param name="sheet"/>
		<xsl:if test="$name and $name != '' and $sheet and $sheet != ''">
			<!-- name -->
			<xsl:value-of select="$name"/>
			<xsl:text>	</xsl:text>
			<!-- short name -->
			<xsl:choose>
				<xsl:when test="contains($name, '$')">
					<xsl:value-of select="substring-before($name, '$')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$name"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- sheet -->
			<xsl:text>	</xsl:text>
			<xsl:choose>
				<xsl:when test="$sheet and $sheet != ''">
					<!-- sheet -->
					<xsl:value-of select="$sheet"/>
					<xsl:text>	</xsl:text>
					<xsl:choose>
						<xsl:when test="substring($sheet, 1, 7) = 'ka_ship'">
							<!-- extract from a lami sheet -->
							<!-- gender -->
							<xsl:text>n	</xsl:text>
							<!-- race -->
							<xsl:call-template name="sheet_race">
								<xsl:with-param name="sheet" select="$sheet"/>
								<xsl:with-param name="race" select="'karavan'"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="substring($sheet, 1, 4) = 'kami'">
							<!-- extract from a lami sheet -->
							<!-- gender -->
							<xsl:text>n	</xsl:text>
							<!-- race -->
							<xsl:call-template name="sheet_race">
								<xsl:with-param name="sheet" select="$sheet"/>
								<xsl:with-param name="race" select="'kami'"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="substring($sheet, 1, 5) = 'tribe' or substring($sheet, 1, 8) = 'cuthroat' or substring($sheet, 1, 11) = 'fyros_guard' or substring($sheet, 1, 11) = 'matis_guard' or substring($sheet, 1, 11) = 'zorai_guard' or substring($sheet, 1, 12) = 'tryker_guard' or substring($sheet, 1, 13) = 'karavan_guard'">
							<!-- extract from a tribe, cuthroat or guard sheet -->
							<!-- gender -->
							<xsl:value-of select="substring($sheet, string-length($sheet), 1)"/>
							<xsl:text>	</xsl:text>
							<!-- race -->
							<xsl:call-template name="sheet_race">
								<xsl:with-param name="sheet" select="$sheet"/>
								<xsl:with-param name="race" select="substring($sheet, string-length($sheet)-2, 1)"/>
							</xsl:call-template>
<!--							<xsl:value-of select="substring($sheet, string-length($sheet)-2, 1)"/>-->
						</xsl:when>
						<xsl:otherwise>
							<!-- extract for a 'normal' sheet -->
							<!-- gender -->
							<xsl:value-of select="substring($sheet, 3, 1)"/>
							<xsl:text>	</xsl:text>
							<!-- race -->
							<xsl:call-template name="sheet_race">
								<xsl:with-param name="sheet" select="$sheet"/>
								<xsl:with-param name="race" select="substring($sheet, 1, 1)"/>
							</xsl:call-template>
<!--							<xsl:value-of select="substring($sheet, 1, 1)"/>-->
						</xsl:otherwise>
					</xsl:choose>
					
				</xsl:when>
				<xsl:otherwise>
					<!-- sheet -->
					<xsl:text>	</xsl:text>
					<!-- gender -->
					<xsl:text>	</xsl:text>
					<!-- race -->
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>
</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="sheet_race">
		<xsl:param name="sheet"/>
		<xsl:param name="race"/>
		<xsl:choose>
			<xsl:when test="substring($sheet, 1, 4) = 'kami'">kami</xsl:when>
			<xsl:when test="substring($sheet, 1, 7) = 'karavan'">karavan</xsl:when>
			<xsl:when test="substring($sheet, 7, 4) = 'cute'">cute</xsl:when>
			<xsl:when test="substring($sheet, 7, 6) = 'frahar'">frahar</xsl:when>
			<xsl:when test="substring($sheet, 7, 6) = 'gibbay'">gibbay</xsl:when>
			<xsl:when test="$race = 'm'">matis</xsl:when>
			<xsl:when test="$race = 'z'">zorai</xsl:when>
			<xsl:when test="$race = 'f'">fyros</xsl:when>
			<xsl:when test="$race = 't'">tryker</xsl:when>
			<xsl:when test="$race = 'k'">karavan</xsl:when>
			<xsl:when test="$race = 'karavan'">karavan</xsl:when>
			<xsl:when test="$race = 'kami'">kami</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="extracted_bot_names">
		<xsl:for-each select="extracted/bot">
			<xsl:sort select="short_name"/>
			<xsl:variable name="current_pos" select="position()"/>
			<xsl:variable name="current_name" select="short_name"/>
			<xsl:call-template name="find_entry">
				<xsl:with-param name="name" select="$current_name"/>
				<xsl:with-param name="node" select="."/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="find_entry">
		<xsl:param name="name"/>
		<xsl:param name="node"/>
		<xsl:if test="not(/extracted_bot_names/translated/bot[name = $name])">
			<!-- output a line of missing translation -->
			<xsl:value-of select="$node/short_name"/><xsl:text>	</xsl:text><xsl:value-of select="sheet"/><xsl:text>	</xsl:text><xsl:value-of select="gender"/><xsl:text>	</xsl:text><xsl:value-of select="race"/><xsl:text>
</xsl:text>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
