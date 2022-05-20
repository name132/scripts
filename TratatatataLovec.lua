--Settings update 1.0

require "lib.moonloader"
local inicfg = require 'inicfg'
local directIni = 'lovec.ini'
local ini = inicfg.load(inicfg.load({
    main = {
        theme = 0
    },
}, directIni))
function save()
inicfg.save(ini, directIni)
end
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local counter2 = {}
local theme = {u8"Стандартная", u8"Зеленая", u8"Голубая{прямо как даня хахахаха}"}
local selected_theme = imgui.ImInt(ini.main.theme)

local main_window_state = imgui.ImBool(false)
local sw, sh = getScreenResolution()
local ev = require 'samp.events'

local fa = require 'fAwesome5'

local fa_font = nil
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })
function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig()
        font_config.MergeMode = true
        
        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 13.0, font_config, fa_glyph_ranges)
    end
end

local font_flag = require('moonloader').font_flag
local my_font = renderCreateFont('Verdana', 12, font_flag.BOLD + font_flag.SHADOW)
local font = renderCreateFont('ShellyAllegroC',12,5)

local house = {
    active = imgui.ImBool(false),
    infoButton = imgui.ImBool(false),
    slider = imgui.ImFloat(2),
    dialog = imgui.ImBool(true),
}

local biz = {
    active = imgui.ImBool(false),
    infoButton = imgui.ImBool(false),
    slider = imgui.ImFloat(2),
    dialog = imgui.ImBool(true),
}

local ferma = {
    active = imgui.ImBool(false),
    dialog = imgui.ImBool(true),
    offButtons = imgui.ImBool(true),
    infobar = imgui.ImBool(true),
    id = imgui.ImFloat(1),
}

local other = {
    nocols = imgui.ImBool(false),
}
---------- AUTO UPDATE SCRIPT ----------> 
local dlstatus = require('moonloader').download_status

update_state = false

local script_vers = 1
local script_vers_text = '1.00'

local update_url = "https://raw.githubusercontent.com/name132/scripts/main/update.ini"
local update_path = getWorkingDirectory().."/config/lovec.ini"

local script_url = "https://github.com/name132/scripts/raw/main/TratatatataLovec.lua"
local script_path = thisScript().path
function updateFunction()
    if update_state then
        downloadUrlToFile(script_url, script_path, function(id, status) 
            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                sms("Скрипт обновлен до нужной версии")
                thisScript():reload()
            end
        end)
    end
end
---------------------------------------->
function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    downloadUrlToFile(update_url, update_path, function(id, status) 
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = ini
            if tonumber(updateIni.info.vers) > script_vers then
                sms("Есть обновления! Версия: "..updateIni.info.vers_text)
                sms("Для обновления скрипта /lovec.update")
                update_state = true
            else
                sms("Скрипт актуальной версии")
            end
        end
    end)

    sampRegisterChatCommand('lovec', function()
        main_window_state.v = not main_window_state.v
    end)
    sampRegisterChatCommand('lovec.update', updateFunction)
    sampRegisterChatCommand('danil', function() sms('даня лох хахахахахахахаахаххаха\nахахах') end)

    sms('скрипт запущен')
    lua_thread.create(firstThread)
    tab = 1
    while true do wait(0)
        imgui.Process = main_window_state.v
        if house.active.v then
            if house.dialog.v then  
                sampSendDialogResponse(8868, 1, nil, nil)
            end
            for id = 0, 2048 do
                local result = sampIs3dTextDefined(id)
                if result then
                    local text, color, posX, posY, posZ, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById(id)
                    if text:find("*** Дом продается **") then 
                        local wposX, wposY, wposZ = convert3DCoordsToScreen(posX,posY,posZ)
                        local x, y, z = getCharCoordinates(PLAYER_PED)
                        distance3d = math.sqrt( ((posX-x)^2) + ((posY-y)^2) + ((posZ-z)^2))
                        if distance3d <= house.slider.v then
                            setVirtualKeyDown(78, true)
                            if house.infoButton.v then
                                sampAddChatMessage('Нажата N', -1)
                            end
                            wait(10)
                            setVirtualKeyDown(78, false)
                            if house.infoButton.v then
                                sampAddChatMessage('Отжата N', -1)
                            end
                        end
                    end
                end
            end
        end


        if biz.active.v then
            if biz.dialog.v then  
                sampSendDialogResponse(8869, 1, nil, nil)
            end
            for id = 0, 2048 do
                local result = sampIs3dTextDefined(id)
                if result then
                    local text, color, posX, posY, posZ, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById(id)
                    if text:find("Бизнес продается") then
                        local wposX, wposY, wposZ = convert3DCoordsToScreen(posX,posY,posZ)
                        local x, y, z = getCharCoordinates(PLAYER_PED)
                        distance3d = math.sqrt( ((posX-x)^2) + ((posY-y)^2) + ((posZ-z)^2))
                        if distance3d <= biz.slider.v then
                            setVirtualKeyDown(78, true)
                            if biz.infoButton.v then
                                sampAddChatMessage('Нажата N', -1)
                            end
                            wait(10)
                            setVirtualKeyDown(78, false)
                            if biz.infoButton.v then
                                sampAddChatMessage('Отжата N', -1)
                            end
                        end
                    end
                end
            end
        end
        if ferma.active.v then
            if ferma.offButtons.v then
                if isKeyDown(0x46) and isKeyJustPressed(0x4C) then
                    ferma.active = imgui.ImBool(false)
                    printString('flood stop', 300)
                end
            end
            if ferma.dialog.v then  
                int = getCharActiveInterior(PLAYER_PED)
                if int == 134 then
                    dialogID = nil
                    sampSendDialogResponse(dialogID, 1, nil, nil)
                end
            end
            for k, v in ipairs(counter2) do 
                if (os.clock() - v) > 1.0 then 
                    table.remove(counter2, k)
                end
            end
			sampSendDialogResponse(1490, 1, math.ceil(ferma.id.v) - 1, nil)
            sampSendDialogResponse(1490, 1, math.ceil(ferma.id.v) - 1, nil)
            counter2[#counter2 + 1] = os.clock()
            counter2[#counter2 + 1] = os.clock()

        end

    end
end

function firstThread()
   while true do wait(0)
        if ferma.active.v then
            if ferma.infobar.v then
			    renderFontDrawText(font, "Время: {FF1493}"..get_timer(jobTime2).."\n{FFFFFF}Количество диалогов:{FF1493} "..counter_dialog.."\n{FFFFFF}Диалогов:{FF1493} "..#counter2.." {FFFFFF}/ сек", 10, sh/2.3, 0xFFFFFFFF)
            end
        else
			counter_dialog = 0
			jobTime2 = os.time()
        end
    end
end

function ev.onServerMessage(color,text)
    if ferma.active.v then  
        if ferma.infobar.v then
            if text:find('Эта ферма уже куплена') then
                counter_dialog = counter_dialog + 1
                return false
            end
        end
    end
end

function imgui.OnDrawFrame()
    if ini.main.theme == 0 then theme_1_white() elseif ini.main.theme == 1 then theme_2_green() elseif ini.main.theme == 2 then theme_3_golybaya() end
    if not main_window_state.v then imgui.Process = false end
    imgui.SetNextWindowSize(imgui.ImVec2(400, 240), imgui.Cond.FirstUseEver)
	imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh /2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))

    imgui.Begin(u8'Ловля by walrik | '..script_vers_text.." update "..script_vers, main_window_state, imgui.WindowFlags.NoResize)

    if imgui.Button(fa.ICON_FA_COG) then tab = 4 end imgui.Hint(u8"Настройки скрипта") imgui.SameLine() imgui.CenterText(u8"В скрипте отсутствует автосохранение")
    imgui.Separator()
    if imgui.Button(u8'Ловля домов') then tab = 1 end imgui.SameLine(150) if imgui.Button(u8"Ловля бизнесов") then tab = 2 end imgui.SameLine(300) if imgui.Button(u8"Ловля ферм") then tab = 3 end
    imgui.BeginChild("##settings", imgui.ImVec2(-1, -1), true)
    if tab == 0 then 

    elseif tab == 1 then  
        imgui.Separator(50)
        imgui.CenterText(u8'Настройки для ловли домов')
        imgui.Separator(50)
        imgui.ToggleButton(house.active.v and u8'Включено' or u8'Выключено', house.active)
        imgui.Checkbox(u8"Автоматически закрывать диалог", house.dialog)
        imgui.Hint(u8"Автоматически нажимает на подтверждение покупки в диалоге после нажатия N")
        imgui.Checkbox(u8"Отображание нажатия виртуальных кнопок в чате", house.infoButton) imgui.SameLine() if imgui.Button(u8'сlick') then sampAddChatMessage('Нажата N', -1) sampAddChatMessage('Отжата N', -1) end
        imgui.Hint(u8"Пример сообщений")
        imgui.SliderFloat(u8"##бaксы?", house.slider, 0, 5)
        imgui.Hint(u8"Нажимать N если я нахожусь не более чем в "..math.ceil(house.slider.v) ..u8" метров от метки\nСоветую НЕ ставить больше 2х, иначе скрипт не будет работать.")
        imgui.SameLine() if imgui.Button(u8'click') then house.slider = imgui.ImFloat(2) end
        imgui.Hint(u8"Вернуть значение слайдера по умолчанию")
    elseif tab == 2 then  
        imgui.Separator(50)
        imgui.CenterText(u8'Настройки для ловли бизнесов')
        imgui.Separator(50)
        imgui.ToggleButton(biz.active.v and u8'Включено' or u8'Выключено', biz.active)
        imgui.Checkbox(u8"Автоматически закрывать диалог", biz.dialog)
        imgui.Hint(u8"Автоматически нажимает на подтверждение покупки в диалоге после нажатия N")
        imgui.Checkbox(u8"Отображание нажатия виртуальных кнопок в чате", biz.infoButton) imgui.SameLine() if imgui.Button(u8'сliсk') then sampAddChatMessage('Нажата N', -1) sampAddChatMessage('Отжата N', -1) end
        imgui.Hint(u8"Пример сообщений")
        imgui.SliderFloat(u8"##баксы?", biz.slider, 0, 5)
        imgui.Hint(u8"Нажимать N если я нахожусь не более чем в "..math.ceil(biz.slider.v) ..u8" метров от метки\nСоветую НЕ ставить больше 2х, иначе скрипт не будет работать.")
        imgui.SameLine() if imgui.Button(u8'cliсk') then biz.slider = imgui.ImFloat(2) end
        imgui.Hint(u8"Вернуть значение слайдера по умолчанию")
    elseif tab == 3 then
        imgui.Separator(50)
        imgui.CenterText(u8'Настройки для ловли ферм')
        imgui.Separator(50)
        imgui.ToggleButton(ferma.active.v and u8'Включено' or u8'Выключено', ferma.active)
        imgui.Checkbox(u8"Автоматически закрывать диалог", ferma.dialog)
        imgui.Hint(u8"Автоматически нажимает на подтверждение покупки в диалоге.\n[Не работает, ибо пока я не знаю ид диалога с подтверждением]")
        imgui.Checkbox(u8"InfoBar", ferma.infobar)
        imgui.Hint(u8"Информация слева")
        imgui.Checkbox(u8"Фаст офф", ferma.offButtons) 
        imgui.Hint(u8"Выключает флудер окном нажатием клавиш F+L")
        imgui.SliderFloat(u8"Ид фермы", ferma.id, 1, 14, "%.0f") imgui.SameLine()
        imgui.Text("["..math.ceil(ferma.id.v).."]")
    elseif tab == 4 then
        if imgui.Combo(u8'Выбор темы', selected_theme, theme, #theme) then
            ini.main.theme = selected_theme.v 
            save()
        end
    end
    imgui.EndChild()

    imgui.End()

end


function get_timer(time)
    local jobsTime = os.time() - time
	return string.format("%s:%s:%s", string.format("%s%s", (tonumber(os.date("%H", jobsTime)) < tonumber(os.date("%H", 0)) and 24 + tonumber(os.date("%H", jobsTime)) - tonumber(os.date("%H", 0)) or tonumber(os.date("%H", jobsTime)) - tonumber(os.date("%H", 0))) < 10 and 0 or "", tonumber(os.date("%H", jobsTime)) < tonumber(os.date("%H", 0)) and 24 + tonumber(os.date("%H", jobsTime)) - tonumber(os.date("%H", 0)) or tonumber(os.date("%H", jobsTime)) - tonumber(os.date("%H", 0))), os.date("%M", jobsTime), os.date("%S", jobsTime))
end


function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end

function imgui.Hint(text, delay, action)
	if imgui.IsItemHovered() then
		if go_hint == nil then go_hint = os.clock() + (delay and delay or 0.0) end
		local alpha = (os.clock() - go_hint) * 5
		if os.clock() >= go_hint then
			imgui.PushStyleVar(imgui.StyleVar.WindowPadding, imgui.ImVec2(10, 10))
			imgui.PushStyleVar(imgui.StyleVar.Alpha, (alpha <= 1.0 and alpha or 1.0))
			imgui.PushStyleColor(imgui.Col.PopupBg, imgui.GetStyle().Colors[imgui.Col.PopupBg])
			imgui.BeginTooltip()
			imgui.PushTextWrapPos(700)
			imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.ModalWindowDarkening], u8'Подсказка:')
			imgui.TextUnformatted(text)
			if action ~= nil then
				imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.TextDisabled], '\n'..' '..action)
			end
			if not imgui.IsItemVisible() and imgui.GetStyle().Alpha == 1.0 then go_hint = nil end
			imgui.PopTextWrapPos()
			imgui.EndTooltip()
			imgui.PopStyleColor()
			imgui.PopStyleVar(2)
		end
	end
end

function sms(arg)
	sampAddChatMessage('[MineCraft 1.8 release] {FFFFFF}'..arg, 0xA9A9A9)
end

function sampGetListboxItemByText(text, plain)
    if not sampIsDialogActive() then return -1 end
        plain = not (plain == false)
    for i = 0, sampGetListboxItemsCount() - 1 do
        if sampGetListboxItemText(i):find(text, 1, plain) then
            return i
        end
    end
    return -1
end

function imgui.ToggleButton(str_id, bool)
    local rBool = false

    if LastActiveTime == nil then
        LastActiveTime = {}
    end
    if LastActive == nil then
        LastActive = {}
    end

    local function ImSaturate(f)
        return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
    end

    local p = imgui.GetCursorScreenPos()
    local draw_list = imgui.GetWindowDrawList()

    local height = imgui.GetTextLineHeightWithSpacing()
    local width = height * 1.70
    local radius = height * 0.50
    local ANIM_SPEED = 0.15
    local butPos = imgui.GetCursorPos()

    if imgui.InvisibleButton(str_id, imgui.ImVec2(width, height)) then
        bool.v = not bool.v
        rBool = true
        LastActiveTime[tostring(str_id)] = os.clock()
        LastActive[tostring(str_id)] = true
    end

    imgui.SetCursorPos(imgui.ImVec2(butPos.x + width + 8, butPos.y + 2.5))
    imgui.Text( str_id:gsub('##.+', '') )

    local t = bool.v and 1.0 or 0.0

    if LastActive[tostring(str_id)] then
        local time = os.clock() - LastActiveTime[tostring(str_id)]
        if time <= ANIM_SPEED then
            local t_anim = ImSaturate(time / ANIM_SPEED)
            t = bool.v and t_anim or 1.0 - t_anim
        else
            LastActive[tostring(str_id)] = false
        end
    end

    local col_static = 0xFF202020
    local col = bool.v and imgui.ColorConvertFloat4ToU32(imgui.ImVec4(0.50, 0.50, 0.50, 1.00)) or 0xFF606060

    draw_list:AddRectFilled(imgui.ImVec2(p.x, p.y + (height / 6)), imgui.ImVec2(p.x + width - 1.0, p.y + (height - (height / 6))), col, 5.0)
    draw_list:AddCircleFilled(imgui.ImVec2(p.x + radius + t * (width - radius * 2.0), p.y + radius), radius - 0.75, col_static)
    draw_list:AddCircle(imgui.ImVec2(p.x + radius + t * (width - radius * 2.0), p.y + radius), radius - 0.75, col, 32, 2)

    return rBool
end

function theme_1_white()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding = imgui.ImVec2(8, 8)
    style.WindowRounding = 6
    style.ChildWindowRounding = 5
    style.FramePadding = imgui.ImVec2(5, 3)
    style.FrameRounding = 3.0
    style.ItemSpacing = imgui.ImVec2(5, 4)
    style.ItemInnerSpacing = imgui.ImVec2(4, 4)
    style.IndentSpacing = 21
    style.ScrollbarSize = 10.0
    style.ScrollbarRounding = 13
    style.GrabMinSize = 8
    style.GrabRounding = 1
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

        colors[clr.Text]                   = ImVec4(0.00, 0.00, 0.00, 1.00);
        colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00);
        colors[clr.WindowBg]               = ImVec4(0.86, 0.86, 0.86, 1.00);
        colors[clr.ChildWindowBg]          = ImVec4(0.71, 0.71, 0.71, 1.00);
        colors[clr.PopupBg]                = ImVec4(0.79, 0.79, 0.79, 1.00);
        colors[clr.Border]                 = ImVec4(0.00, 0.00, 0.00, 0.36);
        colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.10);
        colors[clr.FrameBg]                = ImVec4(1.00, 1.00, 1.00, 1.00);
        colors[clr.FrameBgHovered]         = ImVec4(1.00, 1.00, 1.00, 1.00);
        colors[clr.FrameBgActive]          = ImVec4(1.00, 1.00, 1.00, 1.00);
        colors[clr.TitleBg]                = ImVec4(1.00, 1.00, 1.00, 0.81);
        colors[clr.TitleBgActive]          = ImVec4(1.00, 1.00, 1.00, 1.00);
        colors[clr.TitleBgCollapsed]       = ImVec4(1.00, 1.00, 1.00, 0.51);
        colors[clr.MenuBarBg]              = ImVec4(1.00, 1.00, 1.00, 1.00);
        colors[clr.ScrollbarBg]            = ImVec4(1.00, 1.00, 1.00, 0.86);
        colors[clr.ScrollbarGrab]          = ImVec4(0.37, 0.37, 0.37, 1.00);
        colors[clr.ScrollbarGrabHovered]   = ImVec4(0.60, 0.60, 0.60, 1.00);
        colors[clr.ScrollbarGrabActive]    = ImVec4(0.21, 0.21, 0.21, 1.00);
        colors[clr.ComboBg]                = ImVec4(0.61, 0.61, 0.61, 1.00);
        colors[clr.CheckMark]              = ImVec4(0.42, 0.42, 0.42, 1.00);
        colors[clr.SliderGrab]             = ImVec4(0.51, 0.51, 0.51, 1.00);
        colors[clr.SliderGrabActive]       = ImVec4(0.65, 0.65, 0.65, 1.00);
        colors[clr.Button]                 = ImVec4(0.52, 0.52, 0.52, 0.83);
        colors[clr.ButtonHovered]          = ImVec4(0.58, 0.58, 0.58, 0.83);
        colors[clr.ButtonActive]           = ImVec4(0.44, 0.44, 0.44, 0.83);
        colors[clr.Header]                 = ImVec4(0.65, 0.65, 0.65, 1.00);
        colors[clr.HeaderHovered]          = ImVec4(0.73, 0.73, 0.73, 1.00);
        colors[clr.HeaderActive]           = ImVec4(0.53, 0.53, 0.53, 1.00);
        colors[clr.Separator]              = ImVec4(0.46, 0.46, 0.46, 1.00);
        colors[clr.SeparatorHovered]       = ImVec4(0.45, 0.45, 0.45, 1.00);
        colors[clr.SeparatorActive]        = ImVec4(0.45, 0.45, 0.45, 1.00);
        colors[clr.ResizeGrip]             = ImVec4(0.23, 0.23, 0.23, 1.00);
        colors[clr.ResizeGripHovered]      = ImVec4(0.32, 0.32, 0.32, 1.00);
        colors[clr.ResizeGripActive]       = ImVec4(0.14, 0.14, 0.14, 1.00);
        colors[clr.CloseButton]            = ImVec4(0.40, 0.39, 0.38, 0.16);
        colors[clr.CloseButtonHovered]     = ImVec4(0.40, 0.39, 0.38, 0.39);
        colors[clr.CloseButtonActive]      = ImVec4(0.40, 0.39, 0.38, 1.00);
        colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00);
        colors[clr.PlotLinesHovered]       = ImVec4(1.00, 1.00, 1.00, 1.00);
        colors[clr.PlotHistogram]          = ImVec4(0.70, 0.70, 0.70, 1.00);
        colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 1.00, 1.00, 1.00);
        colors[clr.TextSelectedBg]         = ImVec4(0.62, 0.62, 0.62, 1.00);
        colors[clr.ModalWindowDarkening]   = ImVec4(0.26, 0.26, 0.26, 0.60);
end

function theme_3_golybaya()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    style.WindowRounding = 2.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 2.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0

    colors[clr.FrameBg]                = ImVec4(0.16, 0.48, 0.42, 0.54)
    colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.98, 0.85, 0.40)
    colors[clr.FrameBgActive]          = ImVec4(0.26, 0.98, 0.85, 0.67)
    colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.16, 0.48, 0.42, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CheckMark]              = ImVec4(0.26, 0.98, 0.85, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.24, 0.88, 0.77, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.98, 0.85, 1.00)
    colors[clr.Button]                 = ImVec4(0.26, 0.98, 0.85, 0.40)
    colors[clr.ButtonHovered]          = ImVec4(0.26, 0.98, 0.85, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.06, 0.98, 0.82, 1.00)
    colors[clr.Header]                 = ImVec4(0.26, 0.98, 0.85, 0.31)
    colors[clr.HeaderHovered]          = ImVec4(0.26, 0.98, 0.85, 0.80)
    colors[clr.HeaderActive]           = ImVec4(0.26, 0.98, 0.85, 1.00)
    colors[clr.Separator]              = colors[clr.Border]
    colors[clr.SeparatorHovered]       = ImVec4(0.10, 0.75, 0.63, 0.78)
    colors[clr.SeparatorActive]        = ImVec4(0.10, 0.75, 0.63, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.26, 0.98, 0.85, 0.25)
    colors[clr.ResizeGripHovered]      = ImVec4(0.26, 0.98, 0.85, 0.67)
    colors[clr.ResizeGripActive]       = ImVec4(0.26, 0.98, 0.85, 0.95)
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.81, 0.35, 1.00)
    colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.98, 0.85, 0.35)
    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg]                = colors[clr.PopupBg]
    colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end
function theme_2_green()
  imgui.SwitchContext()
  local style  = imgui.GetStyle()
  local colors = style.Colors
  local clr    = imgui.Col
  local ImVec4 = imgui.ImVec4
  local ImVec2 = imgui.ImVec2

    style.WindowPadding = imgui.ImVec2(8, 8)
    style.WindowRounding = 6
    style.ChildWindowRounding = 5
    style.FramePadding = imgui.ImVec2(5, 3)
    style.FrameRounding = 3.0
    style.ItemSpacing = imgui.ImVec2(5, 4)
    style.ItemInnerSpacing = imgui.ImVec2(4, 4)
    style.IndentSpacing = 21
    style.ScrollbarSize = 10.0
    style.ScrollbarRounding = 13
    style.GrabMinSize = 8
    style.GrabRounding = 1
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

    colors[clr.Text]                 = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]         = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg]             = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg]        = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.PopupBg]              = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.Border]               = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow]         = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.FrameBg]              = ImVec4(0.44, 0.44, 0.44, 0.60)
    colors[clr.FrameBgHovered]       = ImVec4(0.57, 0.57, 0.57, 0.70)
    colors[clr.FrameBgActive]        = ImVec4(0.76, 0.76, 0.76, 0.80)
    colors[clr.TitleBg]              = ImVec4(0.04, 0.04, 0.04, 1.00)
    colors[clr.TitleBgActive]        = ImVec4(0.16, 0.16, 0.16, 1.00)
    colors[clr.TitleBgCollapsed]     = ImVec4(0.00, 0.00, 0.00, 0.60)
    colors[clr.MenuBarBg]            = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]          = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]        = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered] = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]  = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CheckMark]            = ImVec4(0.13, 0.75, 0.55, 0.80)
    colors[clr.SliderGrab]           = ImVec4(0.13, 0.75, 0.75, 0.80)
    colors[clr.SliderGrabActive]     = ImVec4(0.13, 0.75, 1.00, 0.80)
    colors[clr.Button]               = ImVec4(0.13, 0.75, 0.55, 0.40)
    colors[clr.ButtonHovered]        = ImVec4(0.13, 0.75, 0.75, 0.60)
    colors[clr.ButtonActive]         = ImVec4(0.13, 0.75, 1.00, 0.80)
    colors[clr.Header]               = ImVec4(0.13, 0.75, 0.55, 0.40)
    colors[clr.HeaderHovered]        = ImVec4(0.13, 0.75, 0.75, 0.60)
    colors[clr.HeaderActive]         = ImVec4(0.13, 0.75, 1.00, 0.80)
    colors[clr.Separator]            = ImVec4(0.13, 0.75, 0.55, 0.40)
    colors[clr.SeparatorHovered]     = ImVec4(0.13, 0.75, 0.75, 0.60)
    colors[clr.SeparatorActive]      = ImVec4(0.13, 0.75, 1.00, 0.80)
    colors[clr.ResizeGrip]           = ImVec4(0.13, 0.75, 0.55, 0.40)
    colors[clr.ResizeGripHovered]    = ImVec4(0.13, 0.75, 0.75, 0.60)
    colors[clr.ResizeGripActive]     = ImVec4(0.13, 0.75, 1.00, 0.80)
    colors[clr.PlotLines]            = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]     = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram]        = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.TextSelectedBg]       = ImVec4(0.26, 0.59, 0.98, 0.35)
    colors[clr.ModalWindowDarkening] = ImVec4(0.80, 0.80, 0.80, 0.35)
end