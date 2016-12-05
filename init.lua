local player_lastpos = {}

minetest.register_on_joinplayer(function(player)
	player_lastpos[player:get_player_name()] = vector.floor(player:getpos())
	player_lastpos[player:get_player_name()].default = player:get_physics_override()
	print(dump(player:get_physics_override()))
	
end)

local physics_table = {
["default:dirt_with_grass"] = 0.8, -- the node friction, could also be implimented into nodes using an override, but this is simpler
["default:sand"] = 0.5,
["default:desert_sand"] = 0.5,
["default:mese"] = 4,
["default:ice"] = 3,
}

minetest.register_globalstep(function(dtime)
	for _,player in pairs(minetest.get_connected_players()) do
	
		local pos = player:getpos()
		
		local pos = vector.floor(pos) 
		
		if player_lastpos[player:get_player_name()].x ~= pos.x or player_lastpos[player:get_player_name()].y ~= pos.y or player_lastpos[player:get_player_name()].z ~= pos.z then
			player_lastpos[player:get_player_name()] = pos
			
			local physics = player:get_physics_override()
			pos.y = pos.y - 0.2
			local node = minetest.get_node(pos).name
			if physics_table[node] then
				player:set_physics_override({speed = physics_table[node]})
			else
				player:set_physics_override({gravity = 1, jump = 1, speed = 1, sneak = true, sneak_glitch = true})
			end
		end
	end

	--vector.floor(v) 
end)
