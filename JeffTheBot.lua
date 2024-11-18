local plrs = game:GetService("Players")
local htpserv = game:GetService("HttpService")
local dstore = game:GetService("DataStoreService")
local cht = game:GetService("Chat")

local cfg = {
	npcname = "Player",
	gkey = "MY-KEY",
	clr = Enum.ChatColor.Green,
	dname = "NPC_ASSISTANT_SAVES"
}

local npcstuf = {
	cmds = {},
	mod = 0,
	cd = {},
	svd = {}
}

local function getkys(t)
	local k = {}
	for ky in pairs(t) do
		table.insert(k, ky)
	end
	return k
end

local function getnpc()
	local n = game.Workspace:FindFirstChild(cfg.npcname)
	if n and n:FindFirstChild("Humanoid") and n:FindFirstChild("Head") then
		return n
	else
		return nil
	end
end

local function npcspk(msg)
	if msg and msg ~= "" then
		local n = getnpc()
		if n then
			cht:Chat(n.Head, msg, cfg.clr)
		end
	end
end

local function askapi(prmt)
	local url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" .. cfg.gkey

	local bod = htpserv:JSONEncode({
		contents = {{
			parts = {{
				text = prmt
			}}
		}}
	})

	local ok, resp = pcall(function()
		return htpserv:PostAsync(url, bod, Enum.HttpContentType.ApplicationJson, false)
	end)

	if ok then
		local dcd = htpserv:JSONDecode(resp)
		if dcd.candidates and dcd.candidates[1] and dcd.candidates[1].content and dcd.candidates[1].content.parts[1] then
			local txt = dcd.candidates[1].content.parts[1].text
			return txt
		else
			return "sry, got weird response"
		end
	else
		return nil
	end
end

local defcmd = {
	help = "im here 2 help! use '!list' 4 commands",
	hello = "hi! wat u need?",
	joke = "y did robot cross road? 2 update firmware lol!",
	time = "time is " .. os.date("%H:%M:%S"),
	date = "2day is " .. os.date("%Y-%m-%d"),
	advice = "keep learnin n stay curious!"
}

for c, r in pairs(defcmd) do
	npcstuf.cmds[c] = r
end

local function docmd(p, cmd, a)
	if cmd == "list" then
		local cmdlst = table.concat(getkys(npcstuf.cmds), ", ")
		npcspk("cmds: " .. cmdlst)
	elseif cmd == "add" then
		local c, r = table.concat(a, " "):match("(%S+)%s*:%s*(.*)")
		if c and r then
			npcstuf.cmds[c] = r
			npcspk("cmd '" .. c .. "' added: " .. r)
		else
			npcspk("bad format! do '!add [cmd]: [reply]'")
		end
	elseif cmd == "remove" then
		local rm = table.concat(a, " ")
		if npcstuf.cmds[rm] then
			npcstuf.cmds[rm] = nil
			npcspk("cmd '" .. rm .. "' gone")
		else
			npcspk("cmd '" .. rm .. "' not here")
		end
	elseif cmd == "switch" then
		local m = tonumber(table.concat(a, " "))
		if m == 0 or m == 1 then
			npcstuf.mod = m
			npcspk("mode = " .. tostring(m))
		else
			npcspk("bad mode! use 0 or 1")
		end
	elseif cmd == "save" then
		local sv = table.concat(a, " ")
		if sv ~= "" then
			npcstuf.svd[sv] = npcstuf.svd
			npcspk("saved as '" .. sv .. "'")
		else
			npcspk("giv name 4 save")
		end
	elseif cmd == "open" then
		local sv = table.concat(a, " ")
		if npcstuf.svd[sv] then
			npcstuf.svd = npcstuf.svd[sv]
			npcspk("opened '" .. sv .. "'")
		else
			npcspk("save '" .. sv .. "' not found")
		end
	elseif npcstuf.cmds[cmd] then
		npcspk(npcstuf.cmds[cmd])
	else
		npcspk("wat? type '!list' 4 cmds")
	end
end

local function dochat(p, msg)
	local lst = npcstuf.cd[p.UserId] or 0
	if os.time() - lst < 1 then return end
	npcstuf.cd[p.UserId] = os.time()

	local cmd, a = msg:lower():match("^!(%w+)%s*(.-)$")
	if cmd then
		a = string.split(a, " ")
		docmd(p, cmd, a)
	elseif npcstuf.mod == 1 then
		local rsp = askapi(msg)
		if rsp and rsp ~= "" then
			npcspk(rsp)
		else
			npcspk("cant think rn sry")
		end
	else
		for c, r in pairs(npcstuf.cmds) do
			if msg:lower():match(c:lower()) then
				npcspk(r)
				return
			end
		end
		npcspk("cmd mode on. use ! b4 cmd")
	end

	table.insert(npcstuf.svd, {p.Name, msg})
end

local function initplr(p)
	p.Chatted:Connect(function(msg)
		dochat(p, msg)
	end)
end

local dstr = dstore:GetDataStore(cfg.dname)

local function savestuf()
	local ok, err = pcall(function()
		dstr:SetAsync("npcstuf", {
			cmds = npcstuf.cmds,
			mod = npcstuf.mod,
			svd = npcstuf.svd
		})
	end)
	if not ok then
		warn("save fail:", err)
	end
end

local function loadstuf()
	local ok, dat = pcall(function()
		return dstr:GetAsync("npcstuf")
	end)
	if ok and dat then
		npcstuf.cmds = dat.cmds or defcmd
		npcstuf.mod = dat.mod or 0
		npcstuf.svd = dat.svd or {}
	else
		npcstuf.cmds = defcmd
		npcstuf.mod = 0
		npcstuf.svd = {}
	end
end

local function start()
	local n = getnpc()
	if n then
		loadstuf()
		game:BindToClose(savestuf)
		plrs.PlayerAdded:Connect(initplr)
		for _, p in ipairs(plrs:GetPlayers()) do
			initplr(p)
		end
	end
end

start()
