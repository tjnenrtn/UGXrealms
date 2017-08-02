-- Privs Shop

-- Global privs shop price, settable by /shop
shop.price1 = 2
shop.price2 = 8

-- Formspec
function shop.setform(pos)
	local spos = pos.x..","..pos.y..","..pos.z
	local formspec =
		"size[8,7]" ..
		default.gui_bg ..
		default.gui_bg_img ..
		default.gui_slots ..
		"label[3.3,0;Privs Shop]" ..
		"label[2,0.4;Fly]" ..
		"label[5,0.4;Fast]" ..
		"list[nodemeta:" ..spos.. ";fly;2,1;1,1;]" ..
		"list[nodemeta:" ..spos.. ";fast;5,1;1,1;]" ..
		"item_image[2,1;1,1;shop:coin]" ..
		"item_image[5,1;1,1;shop:coin]" ..
		"label[2,2;" .. shop.price1 .. " Coin per second]" ..
		"label[5,2;" .. shop.price2 .. " Coins per second]" ..
		"list[current_player;main;0,3;8,4;]"
	return formspec
end

function shop.buy(pos, listname, index, stack, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	if listname == "fly" then
		local count = stack:get_count()
		inv:remove_item("fly", stack)
		local name = player:get_player_name()
		local time = count / shop.price1

		local q = playereffects.get_player_effects(name)
		for i=1, #q do
			if q[i].effect_type_id == "fly" then
				local countdown_fly = playereffects.get_remaining_effect_time(q[i].effect_id)
				local effectid_fly = playereffects.apply_effect_type("fly", time + countdown_fly, player)
				return
			end
		end

		local effectid_fly = playereffects.apply_effect_type("fly", time, player)

	elseif listname == "fast" then
		local count = stack:get_count()
		inv:remove_item("fast", stack)
		local name = player:get_player_name()
		local time = count / shop.price2

		local q = playereffects.get_player_effects(name)
		for i=1, #q do
			if q[i].effect_type_id == "fast" then
				local countdown_fast = playereffects.get_remaining_effect_time(q[i].effect_id)
				local effectid_fast = playereffects.apply_effect_type("fast", time + countdown_fast, player)
				return
			end
		end

		local effectid_fast = playereffects.apply_effect_type("fast", time, player)
	end
end

minetest.register_alias("shop:shop", "shop:privs")
minetest.register_node("shop:privs", {
	description = "Privs Shop",
	tiles = {"xdecor_barrel_top.png^shop_wings.png",
		"xdecor_barrel_top.png",
		"xdecor_barrel_top.png^shop_wings.png",
		"xdecor_barrel_top.png^shop_wings.png",
		"xdecor_barrel_top.png^shop_wings.png",
		"xdecor_barrel_top.png^shop_wings.png"},
	is_ground_content = true,
	groups = {cracky=2, choppy=3, oddly_breakable_by_hand=1},
	paramtype2 = "facedir",
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Shop for privs")
		local inv = meta:get_inventory()
		inv:set_size("fly", 1)
		inv:set_size("fast", 1)
	end,
	on_rightclick = function(pos, node, clicker, itemstack)
		minetest.show_formspec(clicker:get_player_name(), "shop:privs", shop.setform(pos))
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		shop.buy(pos, listname, index, stack, player)
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local s = stack:get_name()
		local c = stack:get_count()
		if listname == "fly" then
			if s == "shop:coin" then
				return -1
			else
				return 0
			end
		elseif listname == "fast" then
			if s == "shop:coin" then
				return -1
			else
				return 0
			end
		else
			return 0
		end
	end
})

-- playereffects registration
playereffects.register_effect_type("fly", "Fly mode available", nil, {"fly"},
	function(player)
		local playername = player:get_player_name()
		local privs = minetest.get_player_privs(playername)
		privs.fly = true
		minetest.set_player_privs(playername, privs)
	end,
	function(effect, player)
		local privs = minetest.get_player_privs(effect.playername)
		privs.fly = nil
		minetest.set_player_privs(effect.playername, privs)
	end,
	false,
	false)

playereffects.register_effect_type("fast", "Fast mode available", nil, {"fast"},
	function(player)
		local playername = player:get_player_name()
		local privs = minetest.get_player_privs(playername)
		privs.fast = true
		minetest.set_player_privs(playername, privs)
	end,
	function(effect, player)
		local privs = minetest.get_player_privs(effect.playername)
		privs.fast = nil
		minetest.set_player_privs(effect.playername, privs)
	end,
	false,
	false)

--Lets do this via code instead since there are now two different prices.
--[[
-- /shop chat command registration
minetest.register_chatcommand("shop", {
	params = "<price>",
	privs = {server=true},
	description = "Adjust privs shop price",
	func = function(name, param)
		param = tonumber(param)
		if param then
			local price = math.floor(math.abs(param))
			if price < 60 then
				shop.price = price
			end
		end
	end
})
--]]

minetest.register_craft({
	output = "shop:privs",
	recipe = {
		{"group:wood", "default:mese", "group:wood"},
		{"group:wood", "default:goldblock", "group:wood"},
		{"group:wood", "default:diamondblock", "group:wood"}
		}
})
