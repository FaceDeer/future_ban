future_ban_list = {}

local file = io.open(minetest.get_worldpath().."/future_banlist.lua", "r")
if file then
	future_ban_list = minetest.deserialize(file:read("*all"))
	file:close()
	if not future_ban_list then
		future_ban_list = {}
	end
end

local function save_file()
	local file = io.open(minetest.get_worldpath().."/future_banlist.lua", "w")
	if file then
		file:write(minetest.serialize(future_ban_list))
		file:close()
	end
end

minetest.register_chatcommand("future_ban", {
	params = "<playername> | omit playername to see the future ban list",
	description = "The player will be banned when trying to join",
	privs = {ban=true},
	func = function(name, param)
		if param == "" then
			local list = {}
			local n=0
			for k,v in pairs(future_ban_list) do
				n = n+1
				list[n] = k
			end
			if n == 0 then
				minetest.chat_send_player(name, "Future ban list is empty.")
			else
				minetest.chat_send_player(name, "Future ban list:\n" .. table.concat(list, "\n"))
			end
			return
		end
		if minetest.get_ban_description(param) ~= "" then
			local desc = minetest.get_ban_description(param)
			minetest.chat_send_player(name, param .. " has been previously banned with the IP numbers " .. desc .. ".")
		end
		if future_ban_list[param] then
			future_ban_list[param] = nil
			minetest.chat_send_player(name, param .. " removed from the future ban list.")
			return
		end
		if not minetest.get_player_by_name(param) then
			future_ban_list[param] = true
			minetest.chat_send_player(name, param .. " added to the future ban list.")
			minetest.log("action", name .. " added " .. param .. " to the future ban list.")
			save_file()
			return
		end
		if not minetest.ban_player(param) then
			future_ban_list[param] = true
			minetest.chat_send_player(name, param .. " added to the future ban list.")
			minetest.log("action", name .. " added " .. param .. " to the future ban list.")
			save_file()
		else
			local desc = minetest.get_ban_description(param)
			minetest.chat_send_player(name, "Banned " .. desc .. ".")
			minetest.log("action", name .. " bans " .. desc .. ".")
		end
	end
})

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	if future_ban_list[name] then
		if not minetest.ban_player(name) then
			minetest.log("warning", "Failed to ban player " .. name .. " who was on the future ban list when he joined.")
		else
			local desc = minetest.get_ban_description(name)
			minetest.log("action", desc .. " banned (from future ban list).")
			future_ban_list[name] = nil
			save_file()
		end
	end
end)