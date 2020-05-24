if Ark == nil then
	Ark = {
	}
end

function broadcast(text, t)
	if t == nil then
		t = "AMB"
	end
	local message  = ucstring()
	text = message:fromUtf8(tostring(text))
	displaySystemInfo(message, t)
end

--------------------------------------------------------------------------------
--- ARK MISSION CATALOG ---
--------------------------------------------------------------------------------
if ArkMissionCatalog == nil then
	ArkMissionCatalog = {
		window = nil,
		window_id = "ui:interface:ark_mission_catalog"
	}
end

function ArkMissionCatalog:OpenWindow(urlA, urlB)
	local winframe = WebBrowser:addWindow("ark_mission_catalog", "Mission Catalog", getUI(ArkMissionCatalog.window_id))
	winframe.opened=true
	winframe.active=true
	winframe.w = 950

	ArkMissionCatalog.window = winframe

	getUI(ArkMissionCatalog.window_id..":content:htmlA"):browse(urlA)

	local htmlb = getUI(ArkMissionCatalog.window_id..":content:htmlB")
	if htmlb.home == "" then
		htmlb.home = urlB
	end
	htmlb:browse("home")

end


function ArkMissionCatalog:OpenCat(url)
	local htmlb = getUI(ArkMissionCatalog.window_id..":content:htmlB")
	htmlb.home = url+"&continent="+getContinentSheet()
	htmlb:browse("home")
end

function ArkMissionCatalog:UpdateMissionTexts(win, id, text1, text2)
	local w = win:find("ark_mission_"..id)
	local text = ucstring()
	text:fromUtf8(text1)
	w:find("text1").uc_hardtext = text
	text:fromUtf8(text2)
	w:find("text2").uc_hardtext = text
end

function ArkMissionCatalog:startResize()
	local ency = getUI("ui:interface:encyclopedia")
	ency.w = 950
	ency.h = 700
	setOnDraw(ency, "ArkMissionCatalog:autoResize()")
end

function ArkMissionCatalog:autoResize()
	if ArkMissionCatalog.bypass_resize then
		ArkMissionCatalog.bypass_resize = false
		return
	end

	local ui = getUI(ArkMissionCatalog.window_id)
	local htmlA = getUI(ArkMissionCatalog.window_id..":content:htmlA")
	local htmlB = getUI(ArkMissionCatalog.window_id..":content:htmlB")

	if ArkMissionCatalog.cat == "storyline" then
		if ui.w < 784 then
			if ArkMissionCatalog.cat == "storyline" then
				local td30 = htmlB:find("storyline_content")
				if td30 ~= nil then
					td30.x = math.max(0, 200-784+ui.w)
					ArkMissionCatalog.need_restore_td30 = true
				end
			end
		else
			if ArkMissionCatalog.need_restore_td30 then
				local td30 = htmlB:find("storyline_content")
				if td30 ~= nil then
					td30.x = 200
					ArkMissionCatalog.need_restore_td30 = false
				end
			end
		end
	end

	if ui.w < 950 then
		htmlA.w = math.max(60, 220-950+ui.w)
		htmlB.x = math.max(35, 190-950+ui.w)
		ArkMissionCatalog.need_restore = true
	else
		if ArkMissionCatalog.need_restore then
			htmlA.w = 220
			htmlB.x = 190
			ArkMissionCatalog.need_restore = false
		end
	end
end

function ArkMissionCatalog:showLegacyEncyclopedia(state)
	if state == 1 then
		getUI("ui:interface:legacy_encyclopedia").active=1
	else
		getUI("ui:interface:legacy_encyclopedia").active=0
	end
end

