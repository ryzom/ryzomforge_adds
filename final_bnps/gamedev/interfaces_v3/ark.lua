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
	htmlb.home = url
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



