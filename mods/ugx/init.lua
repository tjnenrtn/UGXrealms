--Disabled now that [lava_protect] mod is installed
--[[
-- Temporarily prevent lava griefing until proper code can be written.
minetest.register_abm({
	nodenames = {"default:lava_source"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		if pos.y >= 0 then
			minetest.remove_node(pos)
		end
	end
})
--]]

-- Add craft for green dye.
minetest.register_craft({
	type = "shapeless",
	output = "dye:green 4",
	recipe = {"default:cactus"},
})

-- Add craft for bones.
local x = "bonemeal:bone"
minetest.register_craft({
	output = "bones:bones",
	recipe = {
		{x,x,x},
		{x,x,x},
		{x,x,x},
	},
})

-- Add cooking craft for keys AND resolve coins craft conflict.
minetest.clear_craft({
	output = "default:skeleton_key",
})
minetest.register_craft({
	type = "cooking",
	output = "default:skeleton_key",
	recipe = "default:gold_ingot",
})