-- In this file we define functions that serves outgame character creation


------------------------------------------------------------------------------------------------------------
-- create the game namespace without reseting if already created in an other file.
if (outgame == nil) then
	outgame = {}
end



------------------------------------------------------------------------------------------------------------
-- Name generator.

--nb noms:
-- matis: male 621 - female 621 - FirstName 621
-- fyros: given name 14269, FirstName 841
-- zorai: given name one 318, given name two 644, FirstName 1287
-- tryker: given name 4500, FirstName 4335

-- Fyros
function outgame:getFyrosFirstName()
	local nbFyrosFirstNames = #fyrosFirstNames

	return fyrosFirstNames[math.random(nbFyrosFirstNames)]
end

function outgame:getFyrosLastName()
	local nbFyrosLastNames = #fyrosLastNames

	return fyrosLastNames[math.random(nbFyrosLastNames)]
end

-- Matis
function outgame:getMatisFirstName(sex)
	-- 1 = male, 2 = female
	local dbNameSex = getDbProp("UI:TEMP:NAME_SEX")

	if sex ~= nil then
		dbNameSex = sex
	end

	local FirstName = ""
	if tonumber(dbNameSex) == 1 then
		local nbMatisMaleFirstNames = #matisMaleFirstNames
		FirstName = matisMaleFirstNames[math.random(nbMatisMaleFirstNames)]
	else
		local nbMatisFemaleFirstNames = #matisFemaleFirstNames
		FirstName = matisFemaleFirstNames[math.random(nbMatisFemaleFirstNames)]
	end

	return FirstName
end

function outgame:getMatisLastName()
	local nbMatisLastNames = #matisLastNames

	return matisLastNames[math.random(nbMatisLastNames)]
end

-- Tryker
function outgame:getTrykerFirstName()
	local nbTrykerFirstNames = #trykerFirstNames

	return trykerFirstNames[math.random(nbTrykerFirstNames)]
end

function outgame:getTrykerLastName()
	local nbTrykerLastNames = #trykerLastNames

	return trykerLastNames[math.random(nbTrykerLastNames)]
end

-- Zoraï
function outgame:getZoraiFirstName()
	local nbFirstNamesOne = #zoraiFirstNamesOne
	local FirstNameOne = zoraiFirstNamesOne[math.random(nbFirstNamesOne)]

	local nbFirstNamesTwo = #zoraiFirstNamesTwo
	local FirstNameTwo = zoraiFirstNamesTwo[math.random(nbFirstNamesTwo)]

	return FirstNameOne .. "-" .. FirstNameTwo
end

function outgame:getZoraiLastName()
	local nbLastNames = #zoraiLastNames

	return zoraiLastNames[math.random(nbLastNames)]
end

function outgame:procGenerateName()
	local uiNameFull = getUI("ui:outgame:appear_name:name_full")
	local uiGenText = getUI("ui:outgame:appear_name:eb")
	local dbNameRace = getDbProp("UI:TEMP:NAME_RACE")
	local dbNameSubRaceFirstName = getDbProp("UI:TEMP:NAME_SUB_RACE_FIRST_NAME")
	local dbNameSubRaceLastName = getDbProp("UI:TEMP:NAME_SUB_RACE_LAST_NAME")

	local nameResult = ""
	local fullnameResult = ""

	-- Look at outgame:procUpdateNameRaceLabel() for the "race" list.
	-- fy ma try zo -->
	local firstName = "test2"
	local lastName = "test"

	-- Fyros and Matis are using "first name, last name" order
	-- Trykers and Zoraïs are using "last name, first name" order
	if  tonumber(dbNameRace) == 1 then
	-- Fyros
		firstName = self:getFyrosFirstName()
		lastName = self:getFyrosLastName()
		fullnameResult = firstName .. " " .. lastName
	elseif  tonumber(dbNameRace) == 2 then
	-- Matis
		firstName = self:getMatisFirstName()
		lastName = self:getMatisLastName()
		fullnameResult = firstName .. " " .. lastName
	elseif  tonumber(dbNameRace) == 3 then
	-- Tryker
		firstName = self:getTrykerFirstName()
		lastName = self:getTrykerLastName()
		fullnameResult = lastName .. " " .. firstName
	elseif  tonumber(dbNameRace) == 4 then
	-- Zorai
		firstName = self:getZoraiFirstName()
		lastName = self:getZoraiLastName()
		fullnameResult = lastName .. " " .. firstName
	elseif  tonumber(dbNameRace) == 5 then
	-- Maraudeurs

		-- firstName
		if tonumber(dbNameSubRaceFirstName) == 1 then
		-- Fyros
			firstName = self:getFyrosFirstName()
		elseif  tonumber(dbNameSubRaceFirstName) == 2 then
		-- Matis M
			firstName = self:getMatisFirstName(1)
		elseif  tonumber(dbNameSubRaceFirstName) == 3 then
		-- Matis F
			firstName = self:getMatisFirstName(2)
		elseif  tonumber(dbNameSubRaceFirstName) == 4 then
		-- Tryker
			firstName = self:getTrykerFirstName()
		elseif  tonumber(dbNameSubRaceFirstName) == 5 then
		-- Zorai
			firstName = self:getZoraiFirstName()
		end

		-- lastName
		if tonumber(dbNameSubRaceLastName) == 1 then
		-- Fyros
			lastName = self:getFyrosLastName()
		elseif  tonumber(dbNameSubRaceLastName) == 2 then
		-- Matis
			lastName = self:getMatisLastName()
		elseif  tonumber(dbNameSubRaceLastName) == 3 then
		-- Tryker
			lastName = self:getTrykerLastName()
		elseif  tonumber(dbNameSubRaceLastName) == 4  then
		-- Zorai
			lastName = self:getZoraiLastName()
		end

		fullnameResult = firstName .. " " .. lastName
	end

	-- always use first name for character name
	nameResult = firstName

	uiNameFull.hardtext = fullnameResult

	nameResult = string.gsub(nameResult, "'", "")
	nameResult = string.gsub(nameResult, " ", "")
	nameResult = string.gsub(nameResult, "-", "")
	nameResult = string.lower(nameResult)
	nameResult = nameResult:gsub("^%l", string.upper)
	uiGenText.input_string = nameResult
end

-- Name sex slider update.
function outgame:procUpdateNameSexLabel()
	local nameSexType = { "uiCP_Sex_Male", "uiCP_Sex_Female" }
	local uiNameSexText = getUI("ui:outgame:appear_name:name_sex_slider:name_sex")
	local uiNameSex = getDbProp("UI:TEMP:NAME_SEX")

	tempstr = tostring(i18n.get(nameSexType[tonumber(uiNameSex)]))
	tempstr = string.lower(tempstr)
	tempstr = (tempstr:gsub("^%l", string.upper))

	uiNameSexText.hardtext = tempstr
end

-- Name race slider update.
function outgame:procUpdateNameRaceLabel()
	local nameRaceType = { "Fyros", "Matis", "Tryker", "Zoraï", "uiCP_Maraudeur" }

	local uiNameRaceText = getUI("ui:outgame:appear_name:name_race_slider:name_race")
	local dbNameRace = getDbProp("UI:TEMP:NAME_RACE")

	local uiNameSexSlider = getUI("ui:outgame:appear_name:name_sex_slider")

	local uiNameSubRaceFirstNameSlider = getUI("ui:outgame:appear_name:name_sub_race_first_name_slider")
	local uiNameSubRaceLastNameSlider = getUI("ui:outgame:appear_name:name_sub_race_last_name_slider")

	local uiNameGenerate = getUI("ui:outgame:appear_name:generate")
	-- Show/Hide sex slider
	uiNameGenerate.y = "-50"
	if tonumber(dbNameRace) == 2 then
		uiNameSexSlider.active = true
		uiNameGenerate.y = "-65"
	else
		uiNameSexSlider.active = false
	end

	-- Show/Hide sub race slider
	if tonumber(dbNameRace) == 5 then
		uiNameSubRaceFirstNameSlider.active = true
		uiNameSubRaceLastNameSlider.active = true
		uiNameGenerate.y = "-105"
	else
		uiNameSubRaceFirstNameSlider.active = false
		uiNameSubRaceLastNameSlider.active = false
	end

	-- also update keyboard pointer
	getUI("ui:outgame:appear_name:select_generate").y = uiNameGenerate.y

	uiNameRaceText.hardtext = tostring(nameRaceType[tonumber(dbNameRace)])
end


local matisF = "Matis " .. (string.lower(tostring(i18n.get("uiCP_Sex_Female")) )):gsub("^%l", string.upper)
local matisM = "Matis " .. (string.lower(tostring(i18n.get("uiCP_Sex_Male")) )):gsub("^%l", string.upper)

function outgame:procUpdateNameSubRaceFirstNameLabel()
	local nameSubRaceFirstNameType = { "Fyros", matisM, matisF, "Tryker", "Zoraï" }
	local uiNameSubRaceFirstNameText = getUI("ui:outgame:appear_name:name_sub_race_first_name_slider:name_race")
	local dbNameSubRaceFirstName = getDbProp("UI:TEMP:NAME_SUB_RACE_FIRST_NAME")

	uiNameSubRaceFirstNameText.hardtext= tostring(nameSubRaceFirstNameType[tonumber(dbNameSubRaceFirstName)])
end

function outgame:procUpdateNameSubRaceLastNameLabel()
	local nameSubRaceLastNameType = { "Fyros", "Matis", "Tryker", "Zoraï" }
	local uiNameSubRaceLastNameText = getUI("ui:outgame:appear_name:name_sub_race_last_name_slider:name_race")
	local dbNameSubRaceLastName = getDbProp("UI:TEMP:NAME_SUB_RACE_LAST_NAME")

	uiNameSubRaceLastNameText.hardtext= tostring(nameSubRaceLastNameType[tonumber(dbNameSubRaceLastName)])
end

------------------------------------------------------------------------------------------------------------
-- called to construct icons
function outgame:activePackElement(id, icon)
	local uiDesc = getUI("ui:outgame:appear:job_options:options:desc")
	uiDesc['ico' .. tostring(id)].active = true
	uiDesc['ico' .. tostring(id)].texture = icon
	uiDesc['ico' .. tostring(id) .. 'txt'].active = true
end


------------------------------------------------------------------------------------------------------------
-- called to construct pack text
function outgame:setPackJobText(id, spec)
	-- Set Pack content
	local uiPackText = getUI("ui:outgame:appear:job_options:options:desc:pack_" .. id)
	uiPackText.hardtext= "uiCP_Job_" .. id .. tostring(spec)

	-- Set specialization text
	local uiResText = getUI("ui:outgame:appear:job_options:options:result:res")
	if(spec==2) then
		uiResText.hardtext= "uiCP_Res_" .. id
	end
end

------------------------------------------------------------------------------------------------------------
-- called to construct pack
function outgame:buildActionPack()

	local uiDesc = getUI("ui:outgame:appear:job_options:options:desc")
	if (uiDesc==nil) then
		return
	end

	-- Reset All
	for i = 1,20 do
		uiDesc['ico' .. tostring(i)].active = false
		uiDesc['ico' .. tostring(i) .. 'txt'].active = false
	end

	-- Build Default Combat
	self:activePackElement(1, 'f1.tga')		-- Dagger
	self:activePackElement(2, 'f2.tga')		-- Accurate Attack

	-- Build Default Magic
	self:activePackElement(6, 'm2.tga')		-- Gloves
	self:activePackElement(7, 'm1.tga')		-- Acid

	-- Build Default Forage
	self:activePackElement(11, 'g1.tga')	-- Forage Tool
	self:activePackElement(12, 'g2.tga')	-- Basic Extract

	-- Build Default Craft
	self:activePackElement(16, 'c2.tga')	-- Craft Tool
	self:activePackElement(17, 'c1.tga')	-- 50 raw mat
	self:activePackElement(18, 'c3.tga')	-- Craft Root
	self:activePackElement(19, 'c4.tga')	-- Boots Plan

	-- Build Option
	if (getDbProp('UI:TEMP:JOB_FIGHT') == 2) then
		self:activePackElement(3, 'f3.tga')		-- Increase damage
	elseif (getDbProp('UI:TEMP:JOB_MAGIC') == 2) then
		self:activePackElement(8, 'm5.tga')		-- Fear
	elseif (getDbProp('UI:TEMP:JOB_FORAGE') == 2) then
		self:activePackElement(13, 'g3.tga')	-- Basic Prospection
	elseif (getDbProp('UI:TEMP:JOB_CRAFT') == 2) then
		self:activePackElement(20, 'c6.tga')	-- Gloves Plan
		self:activePackElement(17, 'c5.tga')	-- Replace 17, with 100x RawMat
	end


	-- Reset Text
	self:setPackJobText('F', 1)
	self:setPackJobText('M', 1)
	self:setPackJobText('G', 1)
	self:setPackJobText('C', 1)

	-- Set correct text for specalized version
	if (getDbProp('UI:TEMP:JOB_FIGHT') == 2) then
		self:setPackJobText('F', 2)
	elseif (getDbProp('UI:TEMP:JOB_MAGIC') == 2) then
		self:setPackJobText('M', 2)
	elseif (getDbProp('UI:TEMP:JOB_FORAGE') == 2) then
		self:setPackJobText('G', 2)
	elseif (getDbProp('UI:TEMP:JOB_CRAFT') == 2) then
		self:setPackJobText('C', 2)
	end

end


------------------------------------------------------------------------------------------------------------
-------------------
-- BG DOWNLOADER --
-------------------

--function outgame:getProgressGroup()
--	--debugInfo("*** 1 ***")
--	local grp = getUI("ui:outgame:charsel:bgd_progress")
--	--debugInfo(tostring(grp))
--	return grp
--end
--
--function outgame:setProgressText(ucstr, color, progress, ellipsis)
--	--debugInfo("*** 2 ***")
--	local text = self:getProgressGroup():find("text")
--	local ellipsisTxt = self:getProgressGroup():find("ellipsis")
--	text.color = color
--	text.uc_hardtext = ucstr
--	if ellipsis then
--		ellipsisTxt.hardtext = ellipsis
--	else
--		ellipsisTxt.hardtext = ""
--	end
--	ellipsisTxt.color = color
--	local progressCtrl = self:getProgressGroup():find("progress")
--	progressCtrl.range = 100
--	progressCtrl.value = progress * 100
--	progressCtrl.active = true
--end
--
--
--local progress progressSymbol = { ".", "..", "..." }
--
---- set patching progression (from 0 to 1)
--function outgame:setPatchProgress(progress)
--	--debugInfo("*** 3 ***")
--	local progressPercentText = string.format("%d%%", 100 * progress)
--	local progressPostfix = math.fmod(os.time(), 3)
--	--debugInfo("Patch in progress : " .. tostring(progress))
--	local progressDate = nltime.getLocalTime() / 500
--	local colValue = math.floor(230 + 24 * math.sin(progressDate))
--	local color = string.format("%d %d 	%d %d", colValue, colValue, colValue, 255)
--	self:setProgressText(concatUCString(i18n.get("uiBGD_Progress"), ucstring(progressPercentText)), color, progress, progressSymbol[progressPostfix + 1])
--end
--
--function outgame:setPatchSuccess()
--	--debugInfo("*** 4 ***")
--	--debugInfo("Patch up to date")
--	self:setProgressText(i18n.get("uiBGD_PatchUpToDate"), "0 255 0 255", 1)
--end
--
--
--function outgame:setPatchError()
--	--debugInfo("*** 5 ***")
--	--debugInfo("Patch error")
--	self:setProgressText(i18n.get("uiBGD_PatchError"), "255 0 0 255", 0)
--end
--
--function outgame:setNoPatch()
--	--self:getProgressGroup().active = false
--end


------------------------------------------------------------------------------------------------------------
----------------
--LAUNCH GAME --
----------------
function outgame:launchGame()
	if not isPlayerSlotNewbieLand(getPlayerSelectedSlot()) then
		if not isFullyPatched() then
			messageBoxWithHelp(i18n.get("uiBGD_MainlandCharFullPatchNeeded"), "ui:outgame")
			return
		end
	end
	runAH(getUICaller(), "proc", "proc_charsel_play")
end

function outgame:procCharcreate()
	local ui = getUI("ui:outgame:appear")
	if not getOnDraw(ui) then
		setOnDraw(ui, "outgame:eventCharcreateKeyGet()")
	end
end

function outgame:eventCharcreateKeyGet(event)
	if not event then
		if self.charcreate == nil then
			self.charcreate = {}
		end
		-- reset
		if not getUI("ui:outgame:appear_mainland").active then
			self.charcreate.shards = nil
		end
		if not getUI("ui:outgame:appear_keyset").active then
			self.charcreate.keyset = nil
		end
		return runAH(getUICaller(), "navigate_charcreate", "")
	end
	local modals = {
		name = false,
		infos = false,
		abort = false,
		keyset = false,
		mainland = false
	}
	if getDbProp("UI:TEMP:INFOS") > 0 then
		modals.infos = true
	end
	if getUI("ui:outgame:appear_name").active then
		modals.name = true
	end
	if getUI("ui:outgame:appear_abort").active then
		modals.abort = true
	end
	-- list modals
	local id
	if getUI("ui:outgame:appear_mainland").active then
		if self.charcreate.shards == nil then
			id = "mainland"
		end
		modals.mainland = true
	end
	if getUI("ui:outgame:appear_keyset").active then
		if self.charcreate.keyset == nil then
			id = "keyset"
		end
		modals.keyset = true
	end
	-- update state
	if id then
		local list = getUI(string.format("ui:outgame:appear_%s:%s_list", id, id))
		if list then
			-- list group elements generated by c++
			local nb = list:getNumGroups()
			if nb > 0 then
				if id == "mainland" then
					self.charcreate.shards = {}
				else
					self.charcreate.keyset = {}
				end
				for i = 0, nb-1 do
					local element = list:getGroup(i)
					if element then
						if id == "mainland" then
							table.insert(self.charcreate.shards, element)
						else
							table.insert(self.charcreate.keyset, element)
						end
					end
				end
			end
			-- to navigate
			self.charcreate.index = 1
		end
	end
	-- update index
	if modals.keyset or modals.mainland then
		local t = self.charcreate.shards
		if modals.keyset then
			t = self.charcreate.keyset
		end
		for i = 1, #t do
			if t[i]:find("but").pushed then
				self.charcreate.index = i
				break
			end
		end
	end
	local slot = getDbProp("UI:TEMP:CP_MENU")
	-- event:
	if event > 2 then
		if event > 4 then
			if event == 5 then
				-- infos
				if not modals.name and
				   not modals.abort and
				   not modals.keyset and
				   not modals.mainland
				then
					if slot == 0 then
						if modals.infos then
							return self:pAh("proc_charsel_infos")
						end
						self:pAh("proc_appear_infos")
					end
				end
				return
			end
			-- play
			if not modals.name and
			   not modals.abort and
			   not modals.infos and
			   not modals.keyset and
			   not modals.mainland
			then
				local play_anim = getUI("ui:outgame:appear:play_anim")
				if play_anim then
					if play_anim.pushed then
						play_anim.pushed = false
					else
						play_anim.pushed = true
					end
					self:pAh("anim_perso")
				end
			end
			return
		else
			if modals.abort then
				if event < 4 then
					self:pAh("proc_appear_abort_confirm_over|1|0")
				else
					self:pAh("proc_appear_abort_confirm_over|0|1")
				end
				return
			end
			if modals.keyset or modals.mainland then
				local m = "mainland"
				if modals.keyset then
					m = "keyset"
				end
				local appear = getUI("ui:outgame:appear_"..m)
				if appear then
					local but = "cancel"
					if event < 4 then
						but = "submit"
					end
					if appear:find("select_"..but).active then
						local nb = 0
						if modals.mainland then
							nb = #self.charcreate.shards
						else
							nb = #self.charcreate.keyset
						end
						-- select elements
						if event < 4 then
							if self.charcreate.index >= nb then
								self.charcreate.index = nb
							else
								self.charcreate.index = self.charcreate.index + 1
							end
						else
							if self.charcreate.index <= 1 then
								self.charcreate.index = 1
							else
								self.charcreate.index = self.charcreate.index - 1
							end
						end
						for i = 1, nb do
							local bval = false
							if i == self.charcreate.index then
								local value
								if modals.mainland then
									-- register shard
									value = string.match(self.charcreate.shards[i].id, "%d+")
								else
									-- register keyset
									value = string.match(self.charcreate.keyset[i].id, "keyset_list(.*)$")
								end
								if value then
									self:pAh("proc_appear_"..m.."_register|"..value)
								end
								bval = true
							end
							if modals.mainland then
								self.charcreate.shards[i]:find("but").pushed = bval
							else
								self.charcreate.keyset[i]:find("but").pushed = bval
							end
						end
					else
						if event < 4 then
							self:pAh("proc_appear_"..m.."_over|1|0")
						else
							self:pAh("proc_appear_"..m.."_over|0|1")
						end
					end
				end
				return
			end
			if modals.name then
				local appear_name = getUI("ui:outgame:appear_name")
				if appear_name then
					if event < 4 then
						if appear_name:find("select_generate").active then
							return self:pAh("proc_appear_name_over|0|1|0")
						end
						if appear_name:find("select_cancel").active then
							self:pAh("proc_appear_name_over|1|0|0")
						end
					else
						if appear_name:find("select_submit").active then
							return self:pAh("proc_appear_name_over|0|1|0")
						end
						if appear_name:find("select_cancel").active then
							self:pAh("proc_appear_name_over|0|0|1")
						end
					end
					return
				end
			end
			if event == 3 then
				-- down
				if slot >= 4 then slot = 4 else slot = slot + 1 end
			else
				-- up
				if slot <= 0 then slot = 0 else slot = slot - 1 end
			end
			return self:pAh("proc_CP_menu|"..slot)
		end
	end
	if event > 0 then
		-- enter
		if modals.infos then
			return self:pAh("proc_charsel_infos")
		end
		if modals.abort then
			local appear_abort = getUI("ui:outgame:appear_abort")
			if appear_abort then
				if appear_abort:find("select_submit").active then
					return self:pAh("proc_appear_abort_continue")
				end
				return self:pAh("proc_appear_abort_cancel")
			end
			return
		end
		if modals.mainland then
			local appear_mainland = getUI("ui:outgame:appear_mainland")
			if appear_mainland then
				if appear_mainland:find("select_submit").active then
					return self:pAh("proc_appear_mainland_enter")
				end
				return self:pAh("proc_appear_mainland_cancel")
			end
			return
		end
		if modals.keyset then
			local appear_keyset = getUI("ui:outgame:appear_keyset")
			if appear_keyset then
				if appear_keyset:find("select_submit").active then
					return self:pAh("proc_appear_keyset_enter")
				end
				return self:pAh("proc_appear_keyset_cancel")
			end
			return
		end
		if modals.name then
			local appear_name = getUI("ui:outgame:appear_name")
			if appear_name then
				if appear_name:find("select_generate").active then
					self:pAh("proc_appear_name_generate")
				end
				if appear_name:find("select_cancel").active then
					self:pAh("proc_appear_name_cancel")
				end
				if appear_name:find("select_submit").active then
					self:pAh("proc_appear_name_enter")
				end
			end
			return
		end
		return self:pAh("proc_finish")
	end
	-- escape
	if modals.infos then
		return self:pAh("proc_charsel_infos")
	end
	if modals.abort then
		return self:pAh("proc_appear_abort_cancel")
	end
	if modals.mainland then
		return self:pAh("proc_appear_mainland_cancel")
	end
	if modals.keyset then
		return self:pAh("proc_appear_keyset_cancel")
	end
	if modals.name then
		return self:pAh("proc_appear_name_cancel")
	end
	self:pAh("proc_abort")
end
