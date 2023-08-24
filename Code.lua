local Tween = game:GetService("TweenService")
local Rep = game:GetService("ReplicatedStorage")

local Distance = 150

local Camera = game.Workspace.CurrentCamera

local Friends = {}

return function()
	for _, Player in pairs(_G.Players:GetPlayers()) do
		if Player == _G.Player or not Player:IsFriendsWith(_G.Player.UserId) or Friends[Player] then continue end
		
		local Overhead = script.Player:Clone()
		Overhead.Parent = _G.Main
		
		local OverheadOGSize = UDim2.fromOffset(Overhead.Size.X.Offset,Overhead.Size.Y.Offset)
		
		local function Clicked()
			Rep.TeleportToFriend:FireServer(Player)
		end
		
		local function MouseEntered()
			Tween:Create(Overhead, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = OverheadOGSize + UDim2.fromOffset(5, 5)}):Play()
		end
		
		local function MouseLeave()
			Tween:Create(Overhead, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = OverheadOGSize}):Play()
		end
		
		Overhead.Main.ImageContainer.Icon.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. Player.UserId .. "&width=420&height=420&format=png"
		
		Overhead.Main.MouseButton1Click:Connect(Clicked)
		Overhead.Main.Corner.MouseButton1Click:Connect(Clicked)
		
		Overhead.Main.MouseEnter:Connect(MouseEntered)
		Overhead.Main.MouseLeave:Connect(MouseLeave)
		
		Friends[Player] = Overhead
	end
	
	for Player, Overhead in pairs(Friends) do
		print(Player)
		if not Player.Parent or not Player.Parent.Parent then Friends[Player] = nil Overhead:Destroy() end
		if not Player.Character or not Player.Character.PrimaryPart then continue end
		
		Overhead.Adornee = Player.Character.PrimaryPart
		Overhead.Enabled = (Camera.CFrame.Position - Player.Character.PrimaryPart.CFrame.Position).Magnitude >= Distance
	end
end