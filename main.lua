--Define variables

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ServerStorage = game:GetService("ServerStorage")

local MapsFolder = ServerStorage:WaitForChild("Maps")

local Status = ReplicatedStorage:WaitForChild("Status")

local GameLength = 240

local reward = 100

--Game Loop

while true do
	
	Status.Value = "Waiting for more warriors"
	
	repeat wait(1) until game.Players.NumPlayers >= 2
	
	Status.Value = "Intermission"
	
	wait(10)
	
	local plrs = {}
	
	for i, player in pairs(game.Players:GetPlayers()) do
		if player then
			table.insert(plrs,player) --Add each playeer into plrs table
		end
	end
	
	wait(2)
	
	local AvailableMaps = MapsFolder:GetChildren()
	
	local ChosenMap = AvailableMaps[math.random(1, #AvailableMaps)]
	
	Status.Value = ChosenMap.Name.." Chosen"
	
	local ClonedMap = ChosenMap:Clone()
	ClonedMap.parent = game.workspace
	
	local SpawnPoints = ClonedMap:FindFirstChild("SpawnPoints")
	if not SpawnPoints then
		print("Spawnpoints not found!")
	end
	
	local AvailableSpawnsPoints = SpawnPoints:GetChildren()
	
	for i, player in pairs(plrs) do
		if player then
			character = player.character
			
			if character then
				--Teleport them
				character:FindFirstChild("HumanoidRootPart").CFrame = AvailableSpawnsPoints[1].CFrame + Vector3.new(0,7,0)
				table.remove(AvailableSpawnsPoints,1)
				
				--give sword
				local sword = ServerStorage.Sword.clone()
				sword.parent = player.backpack

				local GameTag = Instance.new("BoolValue")
				GameTag.Name = "GamerTag"
				GameTag.Parent = player.character
				
			else
				if not player then
					table.remove(plrs,i)
				end
			end
		end
	end

	Status.Value = "Prepare for Battle Frenzy!!!"

	wait(5)

	for i = GameLength,0,-1 do
	
	for x, player in pairs(plrs) do
		if player then
			
			character = player.character
			
			if not character then
					--player left
					table.remove(plrs,x)
			else
				if character:FindFirstChild("GameTag") then
					--They are still alive
					print(player.name.." is still in the Frenzy")
				else
					--They are dead
					table.remove(plrs,x)
					print(player.name.." has been Defeated!!!")
					
				end
			end
		else
			table.remove(plrs,x)
			print(player.name.." has been Defeated!!!")
		end
	end
	
	Status.Value = "There are "..i.." seconds remaining, and "..#plrs.." players left"
	
	if #plrs == 1 then
		Status.Value = "The Winner is "..plrs(1).Name
		plrs(1).leaderstats.coin.Value = plrs(1).leaderstats.coin.Value + reward
		break
	elseif #plrs == 0 then
		Status.Value ="No Victory..."
		break
	elseif i == 0 then
		Status.Value = "Times Up!!!"
		break
	end
	
	wait(5)
	
end

print ("Battle Frenzy Over!!!")

for i, player in pairs(game.Players:GetPlayer()) do
	character = player.Character
	
	if not character then
	else
		if character:FindFirstChild("GameTag") then
			character.GameTage:Destory()
		end
		
		if player.Back:FindFirstChild("Sword") then
			player.Back.Sword:Destory()
		end
		
		if character:FindFirstChild("Sword") then
			character.Sword:Destory()
		end
	end
		player:LoadCharacter()
	end	
ClonedMap:Destroy()	
Status.Value = "Prepping Battle Frenzy"
	wait(5)
end
