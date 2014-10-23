require "mysqloo"

LiveChat.DB 				= {}

LiveChat.DB.QueryQueue 		= {}
LiveChat.DB.MySQL 			= mysqloo.connect(LiveChat.Config.host, LiveChat.Config.username, LiveChat.Config.password, LiveChat.Config.database, LiveChat.Config.port)

LiveChat.DB.CDBQ 			= {
	[[
	CREATE TABLE IF NOT EXISTS `]] .. LiveChat.Config.table .. [[` (
	  `id` int(11) NOT NULL AUTO_INCREMENT,
	  `sentTime` datetime NOT NULL,
	  `serverID` int(11) DEFAULT NULL,
	  `name` varchar(40) DEFAULT NULL,
	  `steamID` varchar(18) DEFAULT NULL,
	  `team` varchar(255) DEFAULT NULL,
	  `teamColor` char(7) DEFAULT NULL,
	  `message` text,
	  PRIMARY KEY (`id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]]
}

function LiveChat.DB.MySQL:onConnected( db )
	MsgN( "[MySQL] Connnection establised!" )
	for k, v in pairs(LiveChat.DB.QueryQueue) do
		MsgN( "[MySQL] Running queued query.." )
		LiveChat.DB:RunPreparedQuery( v )
	end
	LiveChat.DB.QueryQueue = {}
	for k,v in pairs(LiveChat.DB.CDBQ) do
		LiveChat.DB:RunPreparedQuery({
			callback = function(data) end,
			sql = v
		})
	end
	timer.Create("MysqlKeepAlive",60,0, function() LiveChat.DB:KeepAlive() end)
end

function LiveChat.DB:connect()
	LiveChat.DB.MySQL.onConnectionFailed = function(Q,E) print( "[LiveChat-MySQL] Connection failed: "..E ) end
	LiveChat.DB.MySQL:connect()
end

--[[
	PreparedQuery Table
	{
		callback = function(data) end,
		sql = "SELECT 1+1",
		vargs = {},
		q.wait = false
	}
]]

function LiveChat.DB:RunPreparedQuery( q )
	q.callback = q.callback or function() end
	local query = self.MySQL:query( q.sql )
	if !query then
		table.insert(LiveChat.DB.QueryQueue, q )
		return
	end
	function query:onSuccess( data )
		--MsgN( "[MySQL] Query Successful!\nQuery: " .. q.sql )
		q.callback( data, unpack( q.vargs or {} ) )
	end

	function query:onError( e, sql )
		MsgN( "[LiveChat-MySQL] Query Failed!\nQuery: " .. sql .. "\nError: " .. e )
		local stat = LiveChat.DB.MySQL:status()
		if stat ~= mysqloo.DATABASE_CONNECTED then
			table.insert(LiveChat.DB.QueryQueue, q )
			if stat == mysqloo.DATABASE_NOT_CONNECTED then
				LiveChat.DB.MySQL:connect()
			end
		end
	end
	query:start()
	if q.wait then
		query:wait()
	end
end

function LiveChat.DB:escape(str)
	return self.MySQL:escape(tostring(str))
end

function LiveChat.DB:insert(Table, Data, c)
	local fields = ""
	local values = ""
	for k, v in pairs(Data) do
		fields = fields .. k .. ", "
		values = values .. "'" .. self.MySQL:escape(tostring(v)) .. "', "
	end
	fields = string.sub(fields, 1, #fields - 2)
	values = string.sub(values, 1, #values - 2)
	
	query = "INSERT INTO " .. Table .. " (" .. fields .. ") VALUES (" .. values .. ");"
	self:RunPreparedQuery({
		sql = query,
		callback = c
	})
end

function LiveChat.DB:KeepAlive()
	self:RunPreparedQuery({
		sql = "SELECT 1+1"
	})
end

LiveChat.DB:connect()