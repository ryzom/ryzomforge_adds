--
-- teleport interface
--
local html = [[
<html>
    <head>
        <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    </head>
    <body style="background-image:url(skin_blank.tga);">
        <table cellspacing="3" cellpadding="3" width="100%">
            <div name="info_banner">
                <tr><img src="#faction.tga"></tr>
            </div>
            <table cellspacing="5" cellpadding="2" width="100%">
                <tr>
                    <td>
                        #fyros
                    </td>
                </tr>
            </table>
            <table cellspacing="5" cellpadding="1" width="100%">
                    <td>
                        #tryker
                    </td>
                </tr>
            </table>
            <table cellspacing="5" cellpadding="2" width="100%">
                <tr>
                    <td>
                        #matis
                    </td>
                </tr>
            </table>
            <table cellspacing="5" cellpadding="2" width="100%">
                <tr>
                    <td>
                        #zorai
                    </td>
                </tr>
            </table>
            <table cellspacing="5" cellpadding="2" width="100%">
                <tr>
                    <td>
                        #primes
                    </td>
                    <table width="100%">
                        <tr>
                            <div name="info_money">
                                <td><img align="left" src="money_seve.tga"></td>
                                <td width="100%"><font color="white" size="12">#money</font></td>
                            </div>
                            <td><font color="white" size="10">#dopact</font></td>
                            <td><form><input name="auto" alt="#help" type="checkbox" #check></form></td>
                        </tr>
                    </table>
                </tr>
            </table>
        </table>
    </body>
</html>]]

if artefact == nil then
    artefact = {
        h = 479,
        w = 526,
        max_h = 479,
        max_w = 603,
        min_h = 200,
        min_w = 234,
        isCompact = false,
        isMinimized = true,
        isLogoMinimized = false,
        isTimerActive = false,
        web_item = "params_l:#L;template:webig_inv_item_artefact;\
                    display:inline-block;id:pact#P;tooltip:u:#T;\
                    quantity:q0;#Q;img1:tp_#I.tga;\
                    bg:bk_#E.tga;col_over:255 255 255 45", -- slotbg:blank2.tga;
        uiWindow = nil,
        idWindow = "ui:interface:artefact", -- _"..tostring(math.random(0,999)),
        template = "artefactv1",
        webcode = html,
        zone = ""
    }

    -- on_event window
    function artefact:onActive()
        if self.uiWindow then
            self:restoreWindow()
        end
    end

    function artefact:onClickHeader(opened)
        if self.uiWindow then
            if opened > 0 then
                self:restoreWindow()
                self.uiWindow:find("header_minimize").params_l = "artefact:onClickHeader(0)"
                return
            end
            -- on_close
            self:saveWindow()
            self.uiWindow:find("header_minimize").params_l = "artefact:onClickHeader(1)"
        end
    end

    function artefact:onResize()
        -- on resize max width
        if self.uiWindow.w == self.max_w then
            local size = 42
            -- adjust height size
            if getDbProp(self.banner) == 0 then
                size = 114
            end
            self.uiWindow.pop_max_h = self.max_h - size
            -- vertical down only
            if self.uiWindow.h >= self.uiWindow.pop_max_h then
                -- now resize window height
                self.uiWindow.h = self.uiWindow.pop_max_h
            end
        else
            if not self.isCompact then
                if getDbProp(self.banner) == 0 then
                    self.uiWindow.pop_max_h = self.max_h - 69
                    -- on resize height if width not maxed
                    if self.uiWindow.h >= self.uiWindow.pop_max_h then
                        self.uiWindow.h = self.uiWindow.pop_max_h
                    end
                else
                    -- logo pop up
                    self.uiWindow.pop_max_h = self.max_h
                end
            end
        end
        -- force dimension
        if self.isMinimized then
            self.uiWindow.h = self.uiWindow.pop_min_h
            self.uiWindow.w = self.uiWindow.pop_min_w
        end
        -- special case
        if self.isCompact then
            if not self.isMinimized then
                self.uiWindow.pop_max_w = self.min_h/2 + 1
                self.uiWindow.pop_max_h = getUI("ui:interface").h
            end
        end
    end

    -- toggle on checkbox event
    function artefact:onChecked()
        if getDbProp(self.dopact) == 1 then
            setDbProp(self.dopact, 0)
            sendMsgToServerAutoPact(false)
            return
        end
        setDbProp(self.dopact, 1)
        sendMsgToServerAutoPact(true)
    end

    function artefact:onMenu(menu)
        local node = ":toggle_banner_"
        -- can not switch logo in compact mode
        if self.isCompact then
            getUI(menu..node.."hide").active = false
            getUI(menu..node.."show").active = false
        else
            if getDbProp(self.banner) == 1 then
                getUI(menu..node.."hide").active = true
                getUI(menu..node.."show").active = false
            else
                getUI(menu..node.."hide").active = false
                getUI(menu..node.."show").active = true
            end
        end
        node = ":window_on_tp_"
        -- toggle on teleport close menu
        if getDbProp(self.closeTp) == 1 then
            getUI(menu..node.."close").active = false
            getUI(menu..node.."open").active = true
        else
            getUI(menu..node.."close").active = true
            getUI(menu..node.."open").active = false
        end
        node = ":window_compact"
        -- disable compact mode if minimized
        if self.isMinimized then
            getUI(menu..node).active = false
        else
            getUI(menu..node).active = true
        end
        launchContextMenuInGame(menu)
    end

    -- event onclick menu
    function artefact:onSelect(event)
        -- toggle on teleport close
        if event == 2 then
            if getDbProp(self.closeTp) == 1 then
                setDbProp(self.closeTp, 0)
                return
            end
            setDbProp(self.closeTp, 1)
            return
        end
        -- do not switch mode while minimized
        if self.isMinimized and event == 4 then
            return
        end
        -- do not allow logo in compact mode
        if event == 1 then
            if self.isCompact then
                return
            end
            -- toggle logo
            if getDbProp(self.banner) == 1 then
                setDbProp(self.banner, 0)
                self.uiWindow.h = self.max_h - 69
            else
                setDbProp(self.banner, 1)
                self.uiWindow.pop_max_h = self.max_h
                self.uiWindow.h = self.max_h
                -- draw in minimized
                if self.isMinimized then
                    self.isLogoMinimized = true
                end
            end
        end
        -- toggle mode
        if event == 4 then
            if not self.isCompact then
                -- store original window
                self.pop_compact_h = self.uiWindow.h
                self.pop_compact_w = self.uiWindow.w
                self.pop_compact_l = getDbProp(self.banner)
                -- switch to compact
                setDbProp(self.banner, 0)
                self.isCompact = true
            else
                self.isCompact = false
                -- restore default mode
                self.uiWindow.h = self.pop_compact_h
                self.uiWindow.w = self.pop_compact_w
                self.uiWindow.pop_max_w = self.max_w
                if self.pop_compact_l == 1 then
                    setDbProp(self.banner, 1)
                end
            end
        end
        self:doRefresh() -- event 3
        if event == 1 then
            self:onResize()
        end
    end

    function artefact:saveWindow()
        -- save current window dimension
        self.isMinimized = true
        self.h = self.uiWindow.h
        self.w = self.uiWindow.w
        -- minimize
        self.uiWindow.pop_min_h = 32
        self.uiWindow.pop_min_w = self.min_h / 2
        self.uiWindow.w = self.min_h / 2
        self.uiWindow.h = 0
    end

    function artefact:restoreWindow()
        if self.isMinimized then
            self.isMinimized = false
            -- restore dimension
            self.uiWindow.pop_min_h = self.min_h
            self.uiWindow.pop_min_w = self.min_w
            self.uiWindow.h = self.h
            self.uiWindow.w = self.w
            -- logo is activated when minimized
            if self.isLogoMinimized then
                self.uiWindow.h = self.uiWindow.pop_max_h
                -- reset
                self.isLogoMinimized = false
            end
            self:onResize()
        end
    end

    -- hide inventory bag pacts
    function artefact:hidePact()
        if getDbProp(self.filter) == 1 then
            setDbProp(self.filter, 0)
        end
    end

    function artefact:doRefresh()
        if self.uiWindow then
            local html = self.uiWindow:find("html")
            if html then
                self:dynRender(html)
            end
        end
    end

    function artefact:doTime()
        if nltime.getLocalTime()/1000 - self.start >= self.loadTpTime then
            setOnDraw(self.uiWindow, "")
            self.isTimerActive = false
            self:doRefresh()
        end
    end

    function artefact:usePact(pactId)
        if self.isTimerActive then
            setOnDraw(self.uiWindow, "")
            -- reset previous timer
            self.isTimerActive = false
        end
        sendMsgToServerUseItem(pactId)
        -- on teleport event
        if getDbProp(self.closeTp) == 1 then
            self.uiWindow.opened = false
            self.uiWindow.active = false
            return
        end
        -- keep opened
        self.start = nltime.getLocalTime() / 1000
        self.isTimerActive = true
        -- pact cooldown is 15s
        setOnDraw(self.uiWindow, "artefact:doTime()")
    end

    function artefact:dynRender(html)
        local content = self.webcode
        -- list teleportation pacts
        for eco, tp in pairs(self.pacts) do
            for _, item in pairs(tp) do
                -- list items in bag
                for i = 0, self.max_slots-1 do
                    local sheet = self:getitem(i, "sheet")
                    -- sheet do exist
                    if sheet > 0 then
                        local name = getSheetName(sheet)
                        local quantity = self:getitem(i, "quantity")
                        -- matches with owned pacts
                        if self:strcmp(name, "tp_"..self.faction) then
                            if self:strcmp(name, ".sitem", false) then
                                if name:find(item.name) then
                                    self.zone = self:webInv(item, eco, quantity, i)
                                end
                            end
                        end
                    end
                end
            end
            content = string.gsub(content, "#"..eco, self.zone)
            self.zone = ""
        end
        local banner = "ban_artefact_"
        local dappers = getDbProp(self.dapper)
        local checkbox = getDbProp(self.dopact)
        local autopact = "Auto&nbsp;Pacts"
        -- mode
        if self.isCompact then
            autopact = "Pacts&nbsp;"
        end
        -- toggle auto pact checkbox
        if checkbox > 0 then
            checkbox = "checked" else checkbox = ""
        end
        if dappers < 0 then dappers = 0 end
        -- construct page
        for k, v in pairs({
            faction = banner..self.faction,
            dopact = autopact,
            check = checkbox,
            money = self:formatint(dappers),
            help = i18n.get("uiArtefactHelp"):toUtf8()
        }) do
            content = string.gsub(content, "#"..k, v)
        end
        if content then
            -- now render
            html:renderHtml(content)
            -- set mode
            if self.isCompact then
                html:showDiv("info_money", false)
            end
            -- hide logo
            if getDbProp(self.banner) == 0 then
                html:showDiv("info_banner", false)
                self:onResize()
            end
            -- trigger checkbox event
            self.uiWindow:find("auto").onclick_l = "lua:artefact:onChecked()"
        end
    end

    -- use template
    function artefact:webInv(item, ecosystem, quantity, id)
        -- limit max quantity
        if quantity > 999 then
            quantity = 999
        end
        local n = 1
        local s = ""
        -- format quantity as q1:;q2:;q3:;..
        for q in string.gmatch(tostring(quantity), "%d") do
            s = s.."q"..n..":"..q..";"
            n = n + 1
        end
        local wi = string.gsub(self.web_item, "#Q", s)
        local desc = item.desc:toUtf8()
        -- keep only the name of the zone
        for i = 1, #self.blacklist do
            desc = string.gsub(desc, self.blacklist[i], "")
        end
        desc = desc:gsub("^%l", string.upper)
        -- construct item
        for k, v in pairs({
            T = desc.." - "..self:formatint(item.cost),
            L = "artefact:usePact("..id..")",
            I = self.faction,
            E = ecosystem,
            P = id
        }) do
            wi = string.gsub(wi, "#"..k, v)
        end
        -- because ryzom
        if self.faction:find("kar") then
            wi = string.gsub(wi, "karavan", "caravane")
        end
        return self.zone..string.gsub(
            '<div class="ryzom-ui-grouptemplate" id="icon" style="#webitem"></div>',
            "#webitem", wi
        )
    end

    function artefact:strcmp(str, offset, s)
        if s ~= nil then
            return offset == '' or str:sub(-#offset) == offset
        end
        return str:sub(1, #offset) == offset
    end

    function artefact:formatint(n)
        local left, num, right = string.match(n, "^([^%d]*%d)(%d*)(.-)$")
        return left..(num:reverse():gsub("(%d%d%d)", "%1,"):reverse())..right
    end

    function artefact:getitem(id, s)
        return getDbProp(self.bag..':'..id..':'..s:upper())
    end

    artefact.__index = artefact
end


function artefact:__init__()
    local vars = {
        bag = "SERVER:INVENTORY:BAG",
        kami = "SERVER:FAME:PLAYER4:VALUE",
        kara = "SERVER:FAME:PLAYER5:VALUE",
        fame = "SERVER:FAME:CULT_ALLEGIANCE",
        dapper = "SERVER:INVENTORY:MONEY",
        filter = "UI:SAVE:INV_BAG:FILTER_TP",
        dopact = "UI:SAVE:TELEPORT:DO_PACT",
        banner = "UI:SAVE:TELEPORT:BANNER",
        closeTp = "UI:SAVE:TELEPORT:CLOSE_AFTER_TP",
        -- minimum fame required
        threshold = 33,
        max_slots = 500,
        loadTpTime = 16,
        pacts = {
            -- ecosystem
            fyros = {
                -- sheetName = price
                tp_f_pyr = 1000,
                tp_f_dyron = 1000,
                tp_f_thesos = 1000,
                tp_f_oflovaksoasis = 1500,
                tp_f_frahartowers = 2500,
                tp_f_sawdustmines = 2500,
                tp_f_outlawcanyon = 4000,
                tp_f_thescorchedcorridor = 6000
            },
            tryker = {
                tp_f_fairhaven = 1000,
                tp_karavan_crystabell = 1000,
                tp_karavan_windermeer = 1000,
                tp_karavan_avendale = 1000,
                tp_f_dewdrops = 1500,
                tp_f_windsofmuse = 1500,
                tp_f_thefount = 2500,
                tp_f_restingwater = 2500,
                tp_f_bountybeaches = 4000,
                tp_f_enchantedisle = 4000,
                tp_f_lagoonsofloria = 6000
            },
            matis = {
                tp_f_yrkanis = 1000,
                tp_karavan_davae = 1000,
                tp_karavan_avalae = 1000,
                tp_karavan_natae = 1000,
                tp_f_fleetinggarden = 1500,
                tp_f_knollofdissent = 2500,
                tp_f_hiddensource = 4000,
                tp_f_hereticshovel = 4000,
                tp_f_upperbog = 4000,
                tp_f_groveofconfusion = 6000
            },
            zorai = {
                tp_f_zora = 1000,
                tp_kami_hoi_cho = 1000,
                tp_kami_jen_lai = 1000,
                tp_kami_min_cho = 1000,
                tp_f_maidengrove = 1500,
                tp_f_havenofpurity = 2500,
                tp_f_groveofumbra = 4000,
                tp_f_knotofdementia = 4000,
                tp_f_thevoid = 6000
            },
            primes = {
                tp_f_ranger_camp = 1000,
                tp_kami_shining_lake = 1000,
                tp_karavan_shattered_ruins = 1000,
                tp_f_almati = 10000,
                tp_f_nexus_terre = 10000,
                tp_f_the_windy_gate = 10000,
                tp_f_the_sunken_city = 10000,
                tp_f_forbidden_depths = 10000,
                tp_f_gate_of_obscurity = 10000,
                tp_f_the_elusive_forest = 10000,
                tp_f_the_land_of_continuity = 10000,
                tp_f_the_under_spring_fyros = 10000,
                tp_f_the_abyss_of_ichor_matis = 10000,
                tp_f_the_trench_of_trials_zorai = 10000
            }
        },
        -- item description to remove
        blacklist = {
            -- kami
            "Pacte kami %/ Téléporteur vers ",                  -- FR
            "Pacte Kami %/ Téléporteur vers ",
            "Соглашение с Ками о перемещении в ",               -- RU
            "Kami Teleportationspakt für ",                     -- DE
            "Kami%-Teleportationspakt für ",
            "Kami Teleporter Pact for the ",                    -- EN
            "Kami Teleporter Pact for ",
            "Pacto Teletransportador Kami para ",               -- ES
            "Pacto Teletransportador para ",
            "Pacto Teletransportador Kamik ",
            "Pacto Kami %/ Teleportador hacia ",
            "Pacto Teletransportador ",
            "Pacto de Teletransportacoin Kama para madera ",
            -- kara
            "Pacte karavan %/ Téléporteur vers ",               -- FR
            "Pacte Karavan %/ Téléporteur vers ",
            "Соглашение с Караваном о перемещении в",           -- RU
            "Karavan Teleportationspakt für ",                  -- DE
            "Karavan%-Teleportationspakt für ",
            "Karavan Teleporter Pact for the ",                 -- EN
            "Karavan Teleporter Pact for ",
            "Pacto Teletransportador Karavan para ",            -- ES
            "Pacto Teletransportdor Karavan para ",
            "Pacto Teletransportador Karavn para ",
            "Pacto Teletransportador para ",
            "Pacto Karavan %/ Teleportador hacia ",
            "Pacto de Teletransportacion Karavan para madera ",
            "Pacto Teletransportador "
        },
        psort = function(p0, p1) return p0.desc < p1.desc end
    }
    vars.__index = vars

    return setmetatable(artefact, vars)
end

function artefact:startInterface()
    -- main
    local app = artefact:__init__()
    -- 3 karavan
    -- 2 kami
    local fame = getDbProp(app.fame)

    if fame > 1 and fame < 4 then
        local getFaction = function(id)
            if id == 3 then return "karavan" end
            if id == 2 then return "kami" end
        end
        app.faction = getFaction(fame)

        if getDbProp(app.kara) >= app.threshold or
            getDbProp(app.kami) >= app.threshold then
            local tmp = {}
            -- load the bunch of pacts at first run
            if not app.uiWindow then
                for eco, tp in pairs(app.pacts) do
                    tmp[eco] = {}
                    for sheet, price in pairs(tp) do
                        sheet = string.gsub(sheet, "_f_", "_"..app.faction.."_")
                        -- one faction only
                        if self:strcmp(sheet, "tp_"..app.faction) then
                            tmp[eco][#tmp[eco]+1] = {
                                name = sheet,
                                desc = getSheetLocalizedName(sheet..".sitem"),
                                cost = tostring(price)
                            }
                        end
                    end
                    -- alphabetic order
                    table.sort(tmp[eco], app.psort)
                end
                -- update
                app.pacts = tmp
            end
            -- create window
            if not app.uiWindow then
                -- reuse the previous frame if exist
                app.uiWindow = getUI(app.idWindow, false)
                -- otherwise
                if not app.uiWindow then
                    app.uiWindow = createRootGroupInstance(
                        app.template,
                        app.idWindow:match("ui:interface:([^:]*):?"),
                        {
                            x = 0, y = 0,
                            w = app.w, h = app.h,
                            pop_max_w = app.max_w,
                            pop_max_h = app.max_h,
                            pop_min_w = app.min_w,
                            pop_min_h = app.min_h
                        }
                    )
                    if not app.uiWindow then
                        return
                    end
                    app.uiWindow:center()
                end
            end
            -- trigger on_open event
            if not app.uiWindow.opened then
                app.uiWindow.opened = true
            end
            -- trigger on_active event
            if not app.uiWindow.active then
                app.uiWindow.active = true
            end
            local html = app.uiWindow:find("html")
            -- render content
            if html then
                app:dynRender(html)
            end
            self:hidePact()
            setTopWindow(app.uiWindow)
            return
        end
    end
    -- Your allegiance or level of fame does not allow to use this item.
    displaySystemInfo(i18n.get("uiArtefactRestrict"), "BC")
end
--
--