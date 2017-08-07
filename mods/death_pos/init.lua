local mod_storage = minetest.get_mod_storage()

hud_msg = {}
hud_id = {}
hud_on = {}

local hud_update = function(player)
	local name = player:get_player_name()
	if hud_on[name] == true then
		player:hud_remove(hud_id[name])
		hud_id[name] = player:hud_add({
			hud_elem_type = "text",
			position = {x = 1, y = 1},
			offset = {x=-20, y = -20},
			scale = {x = 100, y = 100},
			text = hud_msg[name],
			number = 0xFFFFFF,
			alignment = {x = -1, y = 0},
			direction = 2,
		})
	else
		player:hud_remove(hud_id[name])
	end

end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	hud_on[name] = false
	hud_id[name] = nil
	if mod_storage:get_string(name) == "" then
		hud_msg[name] = "You haven't died \non this server... yet."
	else
		hud_msg[name] = "You last died at: \n"..mod_storage:get_string(name)
	end
end)

minetest.register_on_dieplayer(function(player)
	local name = player:get_player_name()
	local pos = player:get_pos()
	pos.x = math.floor(pos.x*10)/10
	pos.y = math.floor(pos.y*10)/10
	pos.z = math.floor(pos.z*10)/10
	mod_storage:set_string(name, minetest.pos_to_string(pos))
	hud_msg[name] = "You last died at \n"..mod_storage:get_string(name)
	hud_update(player)
end)

minetest.register_chatcommand("death_pos", {
description = "Show or hide the deathposition from the hud",
privs = {interact = true},
params = "show|hide",
func = function(name, param)
	if param == "show" then
		hud_on[name] = true
	elseif param == "hide" then
		hud_on[name] = false
	end
	hud_update(minetest.get_player_by_name(name))
end,
})

minetest.register_node("death_pos:bone_finder", {
	description = "Bone Finder",
	tiles = {
		"death_pos_bones_top.png^death_pos_magnifying_glass.png",
		"death_pos_bones_bottom.png^death_pos_magnifying_glass.png",
		"death_pos_bones_side.png^death_pos_magnifying_glass.png",
		"death_pos_bones_side.png^death_pos_magnifying_glass.png",
		"death_pos_bones_rear.png^death_pos_magnifying_glass.png",
		"death_pos_bones_front.png^death_pos_magnifying_glass.png"
	},
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand = 2},
	after_place_node = function(pos, placer, itemstack)
		local meta = minetest.get_meta(pos)
		local owner = placer:get_player_name()
		meta:set_string("infotext","Right Click or double tap on me to teleport to you last known death position.")
	end,
	on_rightclick = function(pos, node, clicker, itemstack)
		local name = clicker:get_player_name()
		local pos = minetest.string_to_pos(mod_storage:get_string(name))
		pos.y = pos.y+1
		clicker:setpos(pos)
		minetest.chat_send_player(name, "Teleported to ypur last known death position")
	end
})

minetest.register_craft({
	output = "death_pos:bone_finder",
	recipe = {
		{"","default:glass",""},
		{"","default:stick",""},
		{"default:mese_block","bones:bones",""},
	},
})
