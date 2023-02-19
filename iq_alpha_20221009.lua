local text = ui.new_label("AA", "Anti-aimbot angles", "\aA0FFFAFF 提升了iq大腦的對AA進行了升級")
local text2 = ui.new_label("rage", "aimbot", "\aA0FFFAFF提升了iq大腦的對解析進行了升級")
local text3 = ui.new_label("lua", "B", "\aA0FFFAFF ")
local text4 = ui.new_label("lua", "B", "\aA0FFFAFF================[ iq.lua ]================")
local Enableiq = ui.new_checkbox("lua", "B", "\a6495EDFFEnable iq+")
local iq_indicator = ui.new_checkbox("lua", "B", "\a6495EDFFEnable iq+ indicator")
local iq_mode1 = ui.new_combobox("lua", "B", "\a6495EDFFgame mode",{ "MM mode","11 mode","hvh mode"})
local iq_mode2 = ui.new_combobox("lua", "B", "\a6495EDFFiq+ mode",{ "+iq legit","+iq rage"})
local info = ui.new_checkbox("lua", "B", "\aD3D3D3FFiq.lua info")
local info_text1 = ui.new_label("lua", "B", "\aD3D3D3FF 版本：alpha ")
local text5 = ui.new_label("lua", "B", "\aA0FFFAFF================[ iq.lua ]================")
local text6 = ui.new_label("lua", "B", "\aA0FFFAFF ")
ui.set_visible(iq_indicator, false)
ui.set_visible(iq_mode1, false)
ui.set_visible(iq_mode2, false)
ui.set_visible(info_text1, false)
ui.set_visible(info_text2, false)

ui.set_callback(Enableiq, function()
	local enabled = ui.get(Enableiq)
	
	ui.set_visible(iq_indicator, enabled)
    ui.set_visible(iq_mode1, enabled)
    ui.set_visible(iq_mode2, enabled)
end)

ui.set_callback(info, function()
	local enabled = ui.get(info)
	
	ui.set_visible(info_text1, enabled)
    ui.set_visible(info_text2, enabled)
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
