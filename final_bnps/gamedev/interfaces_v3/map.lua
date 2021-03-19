--
-- custom maps
--

if (game==nil) then
	game= {};
end

-- alternative textures for maps
game.mapTextures = {}
-- game.mapTextures["zorai_map.tga"] = "tryker_map.tga"

-- Dynamic points for the map
game.mapArkPoints = {}

-- register alternative texture for map
function game:setAltMap(mapName, altMap)
	self.mapTextures[mapName] = altMap
end

-- remove alternative map texture
function game:removeAltMap(mapName)
	self.mapTextures[mapName] = nil
end

function game:addMapArkPoint(section, x, y, name, title, texture, url, h)
	if game.mapArkPoints[section] == nil then
		game.mapArkPoints[section] = {}
	end
	if url == nil then
		game.mapArkPoints[section][name] = {x, y, title, texture, ""}
	else
		if h ~= nil and h > 0 then
			game.mapArkPoints[section][name] = {x, y, title, texture, "", "game:openMapArkPointHelp([["..url.."]], "..tostring(h)..")"}
		else
			game.mapArkPoints[section][name] = {x, y, title, texture, "game:openMapArkPointUrl([["..url.."]])", "game:updateMapArkPointColor()"}
		end
	end
end

function game:delMapArkPoint(section, name)
	game.mapArkPoints[section][name] = nil
end

function game:delMapArkSection(section)
	game.mapArkPoints[section] = nil
end

function game:openMapArkPointUrl(url)
	local webig = getUI("ui:interface:webig")
	webig.active=1
	webig.opened=1
	local html = webig:find("html")
	html:browse(url)
	setTopWindow(webig)
	webig:blink(2)
end

function game:updateMapArkPointColor()
	local button = getUICaller()
	button.texture_over = "lm_respawn_over.tga"
end

function game:openMapArkPointHelp(url, h)
	local whm = getUI("ui:interface:webig_html_modal")
	if whm.active == false  then
		runAH(nil, "enter_modal", "group=ui:interface:webig_html_modal")
		whm.child_resize_h = false
		whm.w = 480
		if h == nil then
			h = 240
		end
		whm.h = h
		if game.mapMapArkPointHelpUrl ~= url then
			whm_html = getUI("ui:interface:webig_html_modal:html")
			if whm_html ~= nil then
				whm_html:browse(url)
				game.mapMapArkPointHelpUrl = url
			end
		end
		game.mapArkPointHelpMousePosX , game.mapArkPointHelpMousePosY = getMousePos()
		setOnDraw(getUI("ui:interface:webig_html_modal"), "game:updateMapArkPointHelp('"..getUICaller().id.."')")
		game.mapArkPointHelpOpened = 1
	end
end

function game:updateMapArkPointHelp(caller_id)
	local caller = getUI("ui:interface:webig_html_modal")
	local x, y = getMousePos()
	x0 = game.mapArkPointHelpMousePosX
	y0 = game.mapArkPointHelpMousePosY
	debug("-- X --")
	debug(x)
	debug(caller.x - 20)
	debug(caller.x + caller.w + 20)
	debug("-- Y --")
	debug(y)
	debug(caller.y - caller.h - 20)
	debug(caller.y + 20)
	if x < caller.x - 20 or x > caller.x + caller.w + 20 or y < caller.y - caller.h - 20 or y > caller.y + 20 then
		setOnDraw(getUI("ui:interface:webig_html_modal"), "")
		runAH(nil, "leave_modal", "group=ui:interface:webig_html_modal")
	end
end

-- map = getUI("ui:interface:map:content:map_content:actual_map")
function game:onLoadMap(map)
	-- debugInfo("onLoadMap(id=".. map.id ..", texture=".. map.texture ..")");

	delArkPoints()
	game.mapMapArkPointHelpUrl = ""
	for section, points in pairs(game.mapArkPoints) do
		debug("Display section ["..section.."]")
		for name, point in pairs(points) do
			debug("  Display point "..name.." = "..point[5])
			addLandMark(point[1], point[2], point[3], point[4], "lua", point[5], "", "", "lua", point[6])
		end
	end

	-- if alt view not enabled
	if getDbProp("UI:VARIABLES:SHOW_ALT_MAP") == 0 or map:isIsland() then
		return
	end

	local texture = map.texture
	if self.mapTextures[texture] ~= nil then
		-- debugInfo("-- using ".. self.mapTextures[texture] .." for " .. texture)
		return self.mapTextures[texture]
	end

end


-- register map overrride
-- game:setAltMap("fyros_map.tga", "fyros_map_sp.tga")

-- TEST
-- game:addMapArkPoint("test", 3785,-3233, "Ulu", "", "ico_visibility.tga", "https://app.ryzom.com/app_arcc/index.php?action=mScript_Run&script=9894", 140)
