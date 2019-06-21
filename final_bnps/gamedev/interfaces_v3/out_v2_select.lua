-- In this file we define functions that serves outgame character creation


------------------------------------------------------------------------------------------------------------
-- create the game namespace without reseting if already created in an other file.
if outgame == nil then
	outgame = {}
	function outgame:pAh(arg)
		runAH(nil, "proc", arg)
	end
end

function outgame:openEditorMenu()
	if not isFullyPatched() then		
		messageBoxWithHelp(i18n.get("uiBGD_FullPatchNeeded"), "ui:outgame");		
		return
	end
	local value = getDbProp('UI:TEMP:HAS_EDITSESSION')
	if value == 0 then
		runAH(nil, "proc", "proc_charsel_edit_scenario")
	else

		local editorButton = getUI("ui:outgame:charsel:edit_session_but")
		assert(editorButton)

		local menuName =  "ui:outgame:r2ed_editor_menu"
		local menu = getUI(menuName)	
		assert(menu)
		launchContextMenuInGame(menu.id)
		menu.x = editorButton.x_real
		menu.y = editorButton.y_real + editorButton.h_real
		menu:updateCoords()	
	end
end

--[[
function outgame:openEditorMenuWarningNewScenario()
	local menuName =  "ui:outgame:r2ed_editor_new_sceneario_warning"
	local menu = getUI(menuName)
	menu.active = true
end--]]

function outgame:procCharselClickSlot()
	local value = getDbProp('UI:SELECTED_SLOT')
	runAH(nil, "proc", "proc_charsel_clickslot|"..value)
end

function outgame:procCharselKeySlot()
	local ui = getUI("ui:outgame:charsel")
	if not getOnDraw(ui) then
		setOnDraw(ui, "outgame:eventCharselKeyGet()")
	end
end

function outgame:eventCharselKeyGet(event)
	if not event then
		return runAH(getUICaller(), "navigate_charsel", "")
	end
	local delchar = false
	if getDbProp("UI:TEMP:CHARSELDELCHAR") > 0 then
		delchar = true
	end
	local slot = getDbProp("UI:TEMP:CHARSELSLOT")
	-- event:
	if event > 2 then
		if event == 4 then
			-- up
			if delchar then
				return self:pAh("proc_charsel_delchar_confirm_over|0|1")
			end
			slot = slot - 1
			if slot < 0 then
				slot = 0
			end
		else
			-- down
			if delchar then
				return self:pAh("proc_charsel_delchar_confirm_over|1|0")
			end
			slot = slot + 1
			if slot > 4 then
				slot = 4
			end
		end
		return self:pAh("proc_charsel_clickslot|"..slot)
	end
	if event > 0 then
		if event == 1 then
			-- delete
			if not delchar then
				if getUI("ui:outgame:charsel:slot"..slot).active then
					return self:pAh("proc_charsel_del")
				end
			end
			-- goto create if non-existent
		end
		-- enter
		if delchar then
			local modal = getUI("ui:outgame:charsel_delchar_confirm")
			if modal then
				if modal:find("select_submit").active then
					return self:pAh("proc_charsel_delchar_confirm_ok")
				end
				return self:pAh("proc_charsel_delchar_confirm_cancel")
			end
		else
			if getUI("ui:outgame:charsel:create_new_but").active then
				return self:pAh("proc_charsel_create_new")
			end
			outgame:launchGame()
			return
		end
	end
	-- escape
	if delchar then
		return self:pAh("proc_charsel_delchar_confirm_cancel")
	end
	self:pAh("proc_quit")
end
