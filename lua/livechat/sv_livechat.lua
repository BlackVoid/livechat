LiveChat = {}

include("livechat/sv_config.lua")
include("livechat/sv_database.lua")

function LiveChat:DecToBase(input, base, pad)
	pad = pad or 0
	local b = base or 10
	local k = "0123456789ABCDEFGHIJkLMNOPQRSTUVW"
	local out = ""
	while input>0 do
		input,d=math.floor(input/b),math.mod(input,b)+1
		out=string.sub(k,d,d)..out
	end
	if #out < pad then
		out = string.rep("0", pad-#out) .. out
	end
	return out
end

function LiveChat:ColorToHex(c,inca)
	inca = inca == nil and true or inca
	return "#" .. (inca and self:DecToBase(c.a, 16, 2) or "") .. self:DecToBase(c.r, 16, 2) .. self:DecToBase(c.g, 16, 2) .. self:DecToBase(c.b, 16, 2)
end

hook.Add( "PlayerSay", "LiveChat_SaveChat", function( ply, text, teamChat )
	if LiveChat.Config['ShowTeamChat'] == false then return end
	if hook.Call("SendToLiveChat", ply, text, teamChat) == false then return end
	timer.Simple(0, function()
		tbl = {}
		tbl['sentTime'] = os.date("%Y-%m-%d %H:%M:%S")
		tbl['serverID'] = LiveChat.Config.serverID
		tbl['name'] = ply:Nick()
		tbl['steamID'] = ply:SteamID()
		tbl['team'] = team.GetName(ply:Team())
		tbl['teamColor'] = LiveChat:ColorToHex(team.GetColor(ply:Team()), false)
		tbl['message'] = text
		LiveChat.DB:insert(LiveChat.Config.table, tbl)
	end)
end)