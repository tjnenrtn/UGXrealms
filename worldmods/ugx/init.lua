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