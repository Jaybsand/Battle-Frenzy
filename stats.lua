local DataStores = game:GetService("DataStoreService"):GetDataStore("SilverDataStore")
local DefaultSilver = 50
local PlayersLeft = 0

game.Players.PlayerAdded:Connect(function(player)
	
	PlayersLeft = PlayersLeft + 1
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local silver = Instance.new("IntValue")
	silver.Name = "Silver"
	silver.Value = 0
	silver.Parent = leaderstats
	
	player.CharacterAdded:Connect(function(character)
	
		character.Humanoid.Died:Connect(function(character)
			if character:FindFirstChild("Gamertag") then
				character.GamerTag:Destroy()
			end
			
			player:LoadCharacter()
			
		end)
	end)
	
	--Data Stores
	local player_data
	
	pcall(function()
		player_data = DataStores:GetAsync(player.UserId.."-Silver")
	end)
	
	if player_data ~= nil then
		--if player has saved data lad data in
		silver.Value = player_data
		
	else
		--new player
		silver.Value = DefaultSilver
	end
	
end)

local bindableEvent = Instance.new("bindableEvent")

game.Player.PlayerRemoving:connect(function(player)
	
	pcall(function()
		DataStores:SetAsync(player.UserId.."-Silver",player.leaderstats.silver.value)
		print("saved")
		PlayersLeft = PlayersLeft - 1
		bindableEvent:Fire()
	end)
	
end)


game:BindToClose(function()
	--Triggered apon shutdown
	while PlayersLeft > 0 do
		bindableEvent.Event:Wait()
	end
end)
