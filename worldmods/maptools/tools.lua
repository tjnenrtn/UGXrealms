--[[
Map Tools: tool definitions

Copyright (c) 2012-2017 Hugo Locurcio and contributors.
Licensed under the zlib license. See LICENSE.md for more information.
--]]

local S = maptools.intllib

maptools.creative = maptools.config["hide_from_creative_inventory"]

minetest.register_tool("maptools:pick_admin", {
	description = S("Admin Pickaxe"),
	range = 12,
	inventory_image = "maptools_adminpick.png",
	groups = {not_in_creative_inventory = maptools.creative},
	tool_capabilities = {
		full_punch_interval = 0.1,
		max_drop_level = 3,
		groupcaps= {
			unbreakable = {times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
			fleshy =      {times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
			choppy =      {times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
			bendy =       {times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
			cracky =      {times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
			crumbly =     {times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
			snappy =      {times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
		},
		damage_groups = {fleshy = 1000},
	},
})

minetest.register_tool("maptools:pick_admin_with_drops", {
	description = S("Admin Pickaxe with Drops"),
	range = 12,
	inventory_image = "maptools_adminpick_with_drops.png",
	groups = {not_in_creative_inventory = maptools.creative},
	tool_capabilities = {
		full_punch_interval = 0.35,
		max_drop_level = 3,
		groupcaps = {
			unbreakable = {times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
			fleshy =      {times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
			choppy =      {times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
			bendy =       {times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
			cracky =      {times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
			crumbly =     {times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
			snappy =      {times={[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
		},
		damage_groups = {fleshy = 1000},
	},
})

minetest.register_on_punchnode(function(pos, node, puncher)
	if puncher:get_wielded_item():get_name() == "maptools:pick_admin"
	and minetest.get_node(pos).name ~= "air" and minetest.check_player_privs(puncher:get_player_name(), {worldedit = true}) then
		minetest.log("action", puncher:get_player_name() .. " digs " .. minetest.get_node(pos).name .. " at " .. minetest.pos_to_string(pos) .. " using an Admin Pickaxe.")
		minetest.remove_node(pos) -- The node is removed directly, which means it even works on non-empty containers and group-less nodes.
		nodeupdate(pos) -- Run node update actions like falling nodes.
	end
end)

minetest.register_on_dignode(function(pos, node, digger)
	if not digger == nil then
		local inv = digger:get_inventory()
		if digger:get_wielded_item():get_name() == "maptools:pick_admin" or digger:get_wielded_item():get_name() == "maptools:pick_admin_with_drops" then
			if not minetest.check_player_privs(digger:get_player_name(), {worldedit = true}) then
				digger:set_wielded_item("")
				minetest.swap_node(pos, {
						name = node.name,
						param2 = node.param2 })
--				inv:remove_item("main",node.name)
				minetest.log("action", digger:get_player_name() .. " tried to use an Admin Pick!")
			end
		end
	end
end)
