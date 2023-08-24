local settings = _G.Settings

local Funcs = require(script.Funcs)

local Music = {}

local PermanentPlaylist = {}
local Playlist = {}

local Meta = {__index = Funcs}

function Music.New(ID, Params, Effects, Index)
	local self = setmetatable({
		ID = ID,
		Params = Params,
		Effects = Effects,
	}, Meta)
	
	PermanentPlaylist[Index] = self
end

function Music.Shuffle()
	Playlist = {}
	
	for Index, Data in pairs(PermanentPlaylist) do
		Playlist[Index] = Data
	end
	
	local Shuffled = {}
	
	while true do
		local add = math.random(1,#Playlist)
		
		table.insert(Shuffled,Playlist[add])
		
		table.remove(Playlist,add)
		
		if #Playlist == 0 then -- No more songs
			break
		end
	end
	
	Playlist = Shuffled
	
	return Playlist
end

for Position, Data in pairs(settings.Music) do
	if not Data.ID then continue end
	
	xpcall(function()
		Music.New(Data.ID, Data.Params or {}, Data.Effects or {}, Position)
	end, function(Error)
		warn(Error)
	end)
end

spawn(function()
	while task.wait() do
		Music.Shuffle()
		
		local Index = 1
		
		while true do
			if Index > #Playlist then
				break
			elseif Index < 1 then
				break
			end
			
			local Current = Playlist[Index]
			
			xpcall(function()
				Current:Create()
				Current:Play()

				Current.Sound.Ended:Wait()

				Current:Remove()
			end, function(Error)
				warn(Error)
			end)
			
			Index += 1
		end
	end
end)

Music.Shuffle()

return Music
