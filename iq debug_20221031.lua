local client_log = client.log
local client_cmd = client.exec

local ui_get = ui.get
local ui_set = ui.set
local ui_new_checkbox = ui.new_checkbox
local ui_new_slider = ui.new_slider

local entity_get_local_player = entity.get_local_player
local entity_get_prop = entity.get_prop
local entity_get_player_name = entity.get_player_name
local entity_get_players = entity.get_players

local uidToEntIndex = client.userid_to_entindex

local globals_tickcount = globals.tickcount

local seteventcallback = client.set_event_callback

local text = ui.new_label("AA", "Anti-aimbot angles", "\aA0FFFAFF 提升了iq的大腦對AA進行了升級")
local text2 = ui.new_label("rage", "aimbot", "\aA0FFFAFF提升了iq的大腦對解析進行了升級")
local text3 = ui.new_label("lua", "B", "\aA0FFFAFF ")
local text4 = ui.new_label("lua", "B", "\aA0FFFAFF=============[ iq.lua ]=============")
local Enableiq = ui.new_checkbox("lua", "B", "\a6495EDFFEnable iq+")
local iq_indicator = ui.new_checkbox("lua", "B", "\a78FDF9FFEnable iq+ indicator")
local iq_mode1 = ui.new_combobox("lua", "B", "\a78FDC3FFgame mode",{ "MM mode","11 mode","hvh mode"})
local iq_mode2 = ui.new_combobox("lua", "B", "\a78FDC3FFiq+ mode",{ "+iq legit","+iq rage"})
local misc = ui.new_checkbox("lua", "B", "\aD3D3D3FFmisc")
local misc_expose_team = ui.new_checkbox("LUA", "B", "全自動報點機器人")
local misc_expose_team_delay = ui.new_slider("LUA", "B", "Spam delay", 1, 1000, 300)
local misc_steam_presence = ui.new_checkbox("LUA", "B", "修改steam csgo狀態")
local info = ui.new_checkbox("lua", "B", "\aFFFFE0FFiq.lua info")
local info_text1 = ui.new_label("lua", "B", "\aFFFFE0FF 版本：\aFF0000FFdebug ")
local info_text2 = ui.new_label("lua", "B", "\aFFFFE0FF 上次更新：\aF08080FF2022.10.31 ")
local text5 = ui.new_label("lua", "B", "\aA0FFFAFF=============[ iq.lua ]=============")
local text6 = ui.new_label("lua", "B", "\aA0FFFAFF ")
ui.set_visible(iq_indicator, false)
ui.set_visible(iq_mode1, false)
ui.set_visible(iq_mode2, false)
ui.set_visible(info_text1, false)
ui.set_visible(info_text2, false)
ui.set_visible(info_text3, false)
ui.set_visible(misc_expose_team, false)
ui.set_visible(misc_expose_team_delay, false)
ui.set_visible(misc_steam_presence, false)
ui.set_visible(text2, false)
ui.set_visible(text, false)

ui.set_callback(Enableiq, function()
	local enabled = ui.get(Enableiq)
	ui.set_visible(iq_indicator, enabled)
    ui.set_visible(iq_mode1, enabled)
    ui.set_visible(iq_mode2, enabled)
	ui.set_visible(text, enabled)
	ui.set_visible(text2, enabled)
end)

ui.set_callback(misc, function()
	local enabled = ui.get(misc)
	ui.set_visible(misc_expose_team, enabled)
	ui.set_visible(misc_expose_team_delay, enabled)
	ui.set_visible(misc_steam_presence, enabled)
end)

ui.set_callback(info, function()
	local enabled = ui.get(info)
	ui.set_visible(info_text1, enabled)
    ui.set_visible(info_text2, enabled)
	ui.set_visible(info_text3, enabled)
end)

client.set_event_callback("paint", function()
	if not ui.get(iq_indicator) then
			return
	else 
		if ui.get(iq_mode1) == "MM mode" then
			renderer.indicator(245, 200, 0, 255, "MM mode")
            else
		        if ui.get(iq_mode1) == "11 mode" then
			    renderer.indicator(245, 200, 0, 255, "11 mode")
                else
                    renderer.indicator(245, 200, 0, 255, "hvh mode")
            end
		end
	end

end)

client.set_event_callback("paint", function()
	if not ui.get(iq_indicator) then
			return
	else 
		if ui.get(iq_mode2) == "+iq rage" then
			renderer.indicator(220, 20, 60, 255, "iq+ rage")
		else
			renderer.indicator(0, 250, 150, 200, "iq+ legit")
		end
	end
end)

--全自動報點機器人 開始
if misc_expose_team == nil or misc_expose_team_delay == nil then return end

local last_tickcount = 0

local function m_iTeamNum(entity_index) return entity.get_prop(entity_index, "m_iTeamNum") end

local function LocationSpam(context)
	if ui_get(misc_expose_team) == false then return end

	if last_tickcount == 0 then 
		last_tickcount = globals_tickcount()
		return
	end

	local spam_delay_value = ui_get(misc_expose_team_delay)
	local current_tickcount = globals_tickcount()

	local players = entity_get_players() -- 获取所有玩家

	for i=1, #players do
		local player = players[i]

		if m_iTeamNum(entity_get_local_player()) == m_iTeamNum(player) and player ~= entity_get_local_player() then

			local player_position = entity_get_prop(player, "m_szLastPlaceName") -- 获得最后的已知位置
			local player_name = entity_get_player_name(player) -- 获取id
			local player_hp = entity_get_prop(player, "m_iHealth") --  获取hp
			local panorama_events = require 'gamesense/panorama_events'
			local js = panorama.open()
			local _ = js['$']
			local Locali_player_position = _.Localize(entity.get_prop(player, 'm_szLastPlaceName')) or '  '
			local tempname = "nil"

			if string.match(player_name, "*;*") or string.match(player_name, ";*") or string.match(player_name, "*;") then
				string.gsub(player_name, ";", "_")
				tempname = player_name
			else
				tempname = player_name
			end

			if player_position ~= nil and player_name ~= nil and tempname ~= nil and player_hp ~= nil then

				if entity_get_prop(player, "m_lifeState") == 0 then -- 检查敌人是否活着 | Alive = 0, KillCam = 1, Dead = 2
					if current_tickcount - last_tickcount > spam_delay_value then
						last_tickcount = current_tickcount	
						client_cmd('say ', tempname, ' 在 ', Locali_player_position, ' 他的血量是 ', player_hp, ' HP') -- 发送名字位置血量
					end
				end
			end	
		end
	end	
end

seteventcallback("paint", LocationSpam)

--全自動報點機器人 結束

--steam游戏状态 开始
local a = '正在使用iq.lua提升iq'
local ffi = require("ffi")
ffi.cdef[[
typedef struct
      {
        void* steam_client;
        void* steam_user;
        void* steam_friends;
      } S_steamApiCtx_t;

typedef bool(__thiscall* fnSetRichPresence)(void*, const char*, const char*);
]]

local signature = client.find_signature("client_panorama.dll", "\xFF\x15\xCC\xCC\xCC\xCC\xB9\xCC\xCC\xCC\xCC\xE8\xCC\xCC\xCC\xCC\x6A")
local steam_ctx = ffi.cast("S_steamApiCtx_t**", ffi.cast("char*", signature) + 7)[0]
local steam_friends = steam_ctx.steam_friends
local vtable = ffi.cast("void***", steam_friends)[0]
local SetRichPresence = ffi.cast("fnSetRichPresence", vtable[43])
local b = ' \u{3000}'

local function update()
	if ui.get(misc_steam_presence) then
		SetRichPresence(steam_friends, "steam_display", "#bcast_teamvsteammap")
		SetRichPresence(steam_friends, "team1", a .. string.rep(b, (113 - #a)/2 )) 
		SetRichPresence(steam_friends, "team2", string.rep(b, 50))
		SetRichPresence(steam_friends, "map", "de_dust2")
		SetRichPresence(steam_friends, "game:mode", "competitive")
		SetRichPresence(steam_friends, "system:access", "private")
	end
	client.delay_call(5, update) 
end

update()
--steam游戏状态 结束
