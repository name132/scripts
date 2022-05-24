require "lib.moonloader"

local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local counter2 = {}

local main_window_state = imgui.ImBool(false)
local sw, sh = getScreenResolution()
local ev = require 'samp.events'

local font_flag = require('moonloader').font_flag
local my_font = renderCreateFont('Verdana', 12, font_flag.BOLD + font_flag.SHADOW)

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
    id = imgui.ImFloat(1), -- ����� �� ����� ��� ����
}

function main()
if not isSampLoaded() or not isSampfuncsLoaded() then return end
while not isSampAvailable() do wait(100) end
sampRegisterChatCommand('lovec', function()
      main_window_state.v = not main_window_state.v
      imgui.Process = main_window_state.v
end)
lua_thread.create(firstThread)
lua_thread.create(firstThread2)
tab = 0
    while true do wait(0)
        if house.active.v then
            if house.dialog.v then  
                sampSendDialogResponse(216, 1, nil, nil)
            end
            for id = 0, 2048 do
                local result = sampIs3dTextDefined(id)
                if result then
                    local text, color, posX, posY, posZ, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById(id)
                    if text:find("*** ��� ��������� **") then 
                        local wposX, wposY, wposZ = convert3DCoordsToScreen(posX,posY,posZ)
                        local x, y, z = getCharCoordinates(PLAYER_PED)
                        if distance3d <= house.slider.v then
                            setVirtualKeyDown(78, true)
                            if house.infoButton.v then
                                sampAddChatMessage('������ N', -1)
                            end
                            wait(50)
                            setVirtualKeyDown(78, false)
                            if house.infoButton.v then
                                sampAddChatMessage('������ N', -1)
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
                    if text:find("������ ���������") then
                        local wposX, wposY, wposZ = convert3DCoordsToScreen(posX,posY,posZ)
                        local x, y, z = getCharCoordinates(PLAYER_PED)
                        if distance3d <= biz.slider.v then
                            setVirtualKeyDown(78, true)
                            if biz.infoButton.v then
                                sampAddChatMessage('������ N', -1)
                            end
                            wait(50)
                            setVirtualKeyDown(78, false)
                            if biz.infoButton.v then
                                sampAddChatMessage('������ N', -1)
                            end
                        end
                    end
                end
            end
        end
        if ferma.active.v then
            if ferma.offButtons.v then
                if isKeyDown(0x46) and isKeyJustPressed(0x4C) then -- F and L
                    ferma.active = imgui.ImBool(false)
                    printString('flood stop', 300)
                end
            end
            if ferma.dialog.v then  
                dialogID = nil -- ����� ������ nil ���� ��������� �� ������� ������������� ������� �����
                sampSendDialogResponse(dialogID, 1, nil, nil)
            end
			sampSendDialogResponse(1490, 1, math.ceil(ferma.id.v) - 1, nil)
        end

    end
end

function firstThread2()
    while true do wait(0)
        for k, v in ipairs(counter2) do 
			if (os.clock() - v) > 1.0 then 
				table.remove(counter2, k)
			end
		end
        counter2[#counter2 + 1] = os.clock()
		wait(150)
    end
end

function firstThread()
    while true do wait(0)
        if ferma.active.v then
            renderFontDrawText(font, "�����: {FF1493}"..get_timer(jobTime2).."\n{FFFFFF}���������� ��������:{FF1493} "..counter_dialog.."\n{FFFFFF}��������:{FF1493} "..#counter2.." {FFFFFF}/ ���", 10, sh/2.3, 0xFFFFFFFF)
        else
            jobTime2 = os.time()
            counter_dialog = 0
        end
    end
end

function samp.onServerMessage(color,text)
    if ferma.active.v then  
        if text:find('��� ����� ��� �������') then
            counter_dialog = counter_dialog + 1
            --return false
        end
    end
end
--[[
-->��� �������� �������� ������� ������� 
function ev.onShowDialog(id, s, t, btn1, btn2, text)
    if ferma.active.v then
        lua_thread.create(function()
            if id == 1490 then
                wait(1)
                stroka = math.ceil(ferma.id.v) - 1
                sampSendDialogResponse(id, 1, stroka, nil)
            end
        end)
    end
end
]]
function imgui.OnDrawFrame()
    imgui.SetNextWindowSize(imgui.ImVec2(400, 230), imgui.Cond.FirstUseEver)
	imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh /2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))

    imgui.Begin(u8'��� �������� ��� ��� by walerik', main_window_state, imgui.WindowFlags.NoResize)

    imgui.CenterText(u8"� ������� ����������� ��������������")
    imgui.Separator()
    if imgui.Button(u8'����� �����') then tab = 1 end imgui.SameLine(150) if imgui.Button(u8"����� ��������") then tab = 2 end imgui.SameLine(300) if imgui.Button(u8"����� ����") then tab = 3 end
    imgui.BeginChild("##settings", imgui.ImVec2(-1, -1), true)
    if tab == 0 then 

    elseif tab == 1 then  
        imgui.CenterText(u8'��������� ��� ����� �����')
        imgui.ToggleButton(house.active.v and u8'��������' or u8'���������', house.active)
        imgui.Checkbox(u8"������������� ��������� ������", house.dialog)
        imgui.Hint(u8"������������� �������� �� ������������� ������� � ������� ����� ������� N")
        imgui.Checkbox(u8"����������� ������� ����������� ������ � ����", house.infoButton) imgui.SameLine() if imgui.Button(u8'�lick') then sampAddChatMessage('������ N', -1) sampAddChatMessage('������ N', -1) end
        imgui.Hint(u8"������ ���������")
        imgui.SliderFloat(u8"##�����?", house.slider, 0, 5)
        imgui.Hint(u8"�������� N ���� � �������� �� ����� ��� � "..math.ceil(house.slider.v) ..u8" ������ �� �����\n������� �� ������� ������ 2�, ����� ������ �� ����� ��������.")
        imgui.SameLine() if imgui.Button(u8'click') then house.slider = imgui.ImFloat(2) end
        imgui.Hint(u8"������� �������� �������� �� ���������")
    elseif tab == 2 then  
        imgui.CenterText(u8'��������� ��� ����� ��������')
        imgui.ToggleButton(biz.active.v and u8'��������' or u8'���������', biz.active)
        imgui.Checkbox(u8"������������� ��������� ������", biz.dialog)
        imgui.Hint(u8"������������� �������� �� ������������� ������� � ������� ����� ������� N")
        imgui.Checkbox(u8"����������� ������� ����������� ������ � ����", biz.infoButton) imgui.SameLine() if imgui.Button(u8'�li�k') then sampAddChatMessage('������ N', -1) sampAddChatMessage('������ N', -1) end
        imgui.Hint(u8"������ ���������")
        imgui.SliderFloat(u8"##�����?", biz.slider, 0, 5)
        imgui.Hint(u8"�������� N ���� � �������� �� ����� ��� � "..math.ceil(biz.slider.v) ..u8" ������ �� �����\n������� �� ������� ������ 2�, ����� ������ �� ����� ��������.")
        imgui.SameLine() if imgui.Button(u8'cli�k') then biz.slider = imgui.ImFloat(2) end
        imgui.Hint(u8"������� �������� �������� �� ���������")
    elseif tab == 3 then
        imgui.CenterText(u8'��������� ��� ����� ����')
        imgui.ToggleButton(ferma.active.v and u8'��������' or u8'���������', ferma.active)
        imgui.Checkbox(u8"������������� ��������� ������", ferma.dialog)
        imgui.Hint(u8"������������� �������� �� ������������� ������� � �������.\n[�� ��������, ��� ���� � �� ���� �� ������� � ��������������]")
        imgui.Checkbox(u8"���� ���", ferma.offButtons) 
        imgui.Hint(u8"��������� ������ ����� �������� ������ F+L")
        imgui.SliderFloat(u8"�� �����", ferma.id, 1, 14, "%.0f") imgui.SameLine()
        imgui.Text("["..math.ceil(ferma.id.v).."]")
    end
    imgui.EndChild()

    imgui.End()

end

--> ����� ������
function get_timer(time)
    local jobsTime = os.time() - time
	return string.format("%s:%s:%s", string.format("%s%s", (tonumber(os.date("%H", jobsTime)) < tonumber(os.date("%H", 0)) and 24 + tonumber(os.date("%H", jobsTime)) - tonumber(os.date("%H", 0)) or tonumber(os.date("%H", jobsTime)) - tonumber(os.date("%H", 0))) < 10 and 0 or "", tonumber(os.date("%H", jobsTime)) < tonumber(os.date("%H", 0)) and 24 + tonumber(os.date("%H", jobsTime)) - tonumber(os.date("%H", 0)) or tonumber(os.date("%H", jobsTime)) - tonumber(os.date("%H", 0))), os.date("%M", jobsTime), os.date("%S", jobsTime))
end


--> ��������� ����� �� ������ ����
function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end

--> Hint
function imgui.Hint(text, delay, action)
	if imgui.IsItemHovered() then
		if go_hint == nil then go_hint = os.clock() + (delay and delay or 0.0) end
		local alpha = (os.clock() - go_hint) * 5 -- �������� ���������
		if os.clock() >= go_hint then
			imgui.PushStyleVar(imgui.StyleVar.WindowPadding, imgui.ImVec2(10, 10))
			imgui.PushStyleVar(imgui.StyleVar.Alpha, (alpha <= 1.0 and alpha or 1.0))
			imgui.PushStyleColor(imgui.Col.PopupBg, imgui.GetStyle().Colors[imgui.Col.PopupBg])
			imgui.BeginTooltip()
			imgui.PushTextWrapPos(700)
			imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.ModalWindowDarkening], u8'���������:')
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

--> �������� ������ � �������
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

--> ToggleButton
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

--> ����� �����
function theme_white() -- Rice Style
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
theme_white()
