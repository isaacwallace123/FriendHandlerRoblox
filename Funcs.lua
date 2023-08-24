local Song = {}

function Song:Skip()
	if self.Sound then
		xpcall(function()
			print("Skipped")
		end, function(Error) warn("Music Load Error: " .. Error) end)
	end
end

function Song:Play()
	if self.Sound then
		xpcall(function()
			self.Sound:Play()
		end, function(Error) warn("Music Load Error: " .. Error) end)
	end
end

function Song:Create()
	local Sound = Instance.new("Sound")
	
	Sound.SoundId = "rbxassetid://" .. self.ID
	
	if self.Params and self.Params ~= {} then
		for Property,Value in pairs(self.Params) do
			if Property == "Playing" or Property == "Looped" then continue end

			xpcall(function()
				Sound[Property] = Value
			end, function(Error) warn("Music Handler: " .. Error) end)
		end
	end
	
	if self.Effects and self.Effects ~= {} then
		for Effect, Params in pairs(self.Effects) do
			Effect = Effect:Clone()
			
			Effect.Parent = Sound

			for Property, Value in pairs(Params) do
				xpcall(function()
					Effect[Property] = Value
				end, function(Error) warn("Sound Effects: " .. Error) end)
			end
		end
	end
	
	Sound.Parent = _G.SoundService
	
	self.Sound = Sound
	
	return Sound
end

function Song:Remove()
	if self.Sound then
		xpcall(function()
			self.Sound:Destroy()
			self.Sound = nil
		end, function(Error)
			warn(Error)
		end)
	end
end

return Song
