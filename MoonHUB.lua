local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/main/source.lua", true))()

local Window = Luna:CreateWindow({
	Name = "Moon Hub", -- This Is Title Of Your Window
	Subtitle = nil, -- A Gray Subtitle next To the main title.
	LogoID = "82795327169782", -- The Asset ID of your logo. Set to nil if you do not have a logo for Luna to use.
	LoadingEnabled = true, -- Whether to enable the loading animation. Set to false if you do not want the loading screen or have your own custom one.
	LoadingTitle = "Moon Hub", -- Header for loading screen
	LoadingSubtitle = "By: Krafty Cheese", -- Subtitle for loading screen

	ConfigSettings = {
		RootFolder = nil, -- The Root Folder Is Only If You Have A Hub With Multiple Game Scripts and u may remove it. DO NOT ADD A SLASH
		ConfigFolder = "Big Hub" -- The Name Of The Folder Where Luna Will Store Configs For This Script. DO NOT ADD A SLASH
	},

	KeySystem = false, -- As Of Beta 6, Luna Has officially Implemented A Key System!
	KeySettings = {
		Title = "Moon Hub Key",
		Subtitle = "Key System",
		Note = "",
		SaveInRoot = false, -- Enabling will save the key in your RootFolder (YOU MUST HAVE ONE BEFORE ENABLING THIS OPTION)
		SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
		Key = {"KraftyisHOT"}, -- List of keys that will be accepted by the system, please use a system like Pelican or Luarmor that provide key strings based on your HWID since putting a simple string is very easy to bypass
		SecondAction = {
			Enabled = false, -- Set to false if you do not want a second action,
			Type = "Link", -- Link / Discord.
			Parameter = "" -- If Type is Discord, then put your invite link (DO NOT PUT DISCORD.GG/). Else, put the full link of your key system here.
		}
	}
})

-- Universal Stuff
local Tab = Window:CreateTab({
	Name = "UNIVERSAL",
	Icon = "view_in_ar",
	ImageSource = "Material",
	ShowTitle = true -- This will determine whether the big header text in the tab will show
})

local Button = Tab:CreateButton({
	Name = "Close Hub",
	Description = nil, -- Creates A Description For Users to know what the button does (looks bad if you use it all the time),
    	Callback = function()
         Luna:Destroy()
    	end
})

Tab:CreateDivider()

-- WalkSpeed
local Slider = Tab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 1000}, -- The Minimum And Maximum Values Respectively
    Increment = 1,     -- Basically The Changing Value/Rounding Off
    CurrentValue = 16, -- The Starting Value
    Callback = function(Value)
        -- The function that takes place when the slider changes
        -- The variable (Value) is a number which correlates to the value the slider is currently at

        -- Get the local player and their character
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")

        -- Set the humanoid's WalkSpeed to the current value of the slider
        humanoid.WalkSpeed = Value
    end
}, "WalkSpeed") -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps

Tab:CreateDivider()

-- Jump Shit
local Slider = Tab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 500}, -- The Minimum And Maximum Values Respectively
    Increment = 5,     -- Basically The Changing Value/Rounding Off
    CurrentValue = 50, -- The Starting Value
    Callback = function(Value)
        -- The function that takes place when the slider changes
        -- The variable (Value) is a number which correlates to the value the slider is currently at

        -- Get the local player and their character
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")

        -- Set the humanoid's WalkSpeed to the current value of the slider
        humanoid.JumpPower = Value
    end
}, "JumpPower") -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps

Tab:CreateDivider()

-- Flying Variables
local flying = false
local bv, bg = nil, nil
local flySpeed = 50 -- Default Fly Speed

-- Function to enable or disable flying
local function setFly(state)
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    if flying == state then return end -- Prevent multiple toggles
    flying = state

    if flying then
        -- Create BodyVelocity and BodyGyro
        bv = Instance.new("BodyVelocity", hrp)
        bg = Instance.new("BodyGyro", hrp)
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bg.P = 3000
    else
        -- Destroy the flying components
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        bv, bg = nil, nil
    end
end

-- Update flying behavior during RenderStepped
local function updateFly()
    if flying and bv and bg then
        local player = game.Players.LocalPlayer
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local mv, cam = Vector3.zero, workspace.CurrentCamera
        local uis = game:GetService("UserInputService")
        if uis:IsKeyDown(Enum.KeyCode.W) then mv += cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then mv -= cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then mv -= cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then mv += cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.Space) then mv += Vector3.new(0, 1, 0) end
        if uis:IsKeyDown(Enum.KeyCode.LeftControl) then mv -= Vector3.new(0, 1, 0) end
        bv.Velocity = mv.Magnitude > 0 and mv.Unit * flySpeed or Vector3.zero
        bg.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
    end
end

game:GetService("RunService").RenderStepped:Connect(updateFly)

-- Reapply fly setup on respawn
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    if flying then
        setFly(true) -- Reinitialize flying for the new character
    end
end)

-- Create toggle for flying
Tab:CreateToggle({
    Name = "Fly Toggle",
    Description = "Enable or disable flying",
    CurrentValue = false, -- Default off
    Callback = function(Value)
        setFly(Value)
    end
}, "FlyToggle")

-- Fly speed slider
Tab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200}, -- The Minimum And Maximum Values Respectively
    Increment = 5, -- The Changing Value/Rounding Off
    CurrentValue = flySpeed, -- The Starting Value
    Callback = function(Value)
        flySpeed = Value -- Update the fly speed value when slider is adjusted
    end
}, "FlySpeed")

Tab:CreateDivider()

-- Fling Toggle
local active = false
local power = 500

local function startFling()
    local thrust = Instance.new("BodyThrust", game.Players.LocalPlayer.Character.HumanoidRootPart)
    thrust.Force = Vector3.new(power, 0, power)
    thrust.Location = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
end

local function stopFling()
    local thrust = game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("BodyThrust")
    if thrust then
        thrust:Destroy()
    end
end

Tab:CreateToggle({
    Name = "Enable Fling",
    Default = false,
    Callback = function(state)
        active = state
        if active then
            startFling()
        else
            stopFling()
        end
    end
}, "EnableFling")

-- Power Slider
Tab:CreateSlider({
    Name = "Adjust Power",
    Range = {100, 1000},
    Increment = 50,
    CurrentValue = power,
    Callback = function(value)
        power = value
    end
}, "AdjustPower")

Tab:CreateDivider()

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local noclipEnabled = false
local noclipConnection = nil

-- Update character reference on respawn
player.CharacterAdded:Connect(function(newCharacter)
    char = newCharacter
end)

-- Function to toggle no-clip
local function toggleNoclip(state)
    noclipEnabled = state

    if noclipEnabled then
        -- Connect to RunService Stepped for no-clip
        noclipConnection = game:GetService("RunService").Stepped:Connect(function()
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        -- Disconnect the connection and restore collisions
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end

        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

Tab:CreateToggle({
    Name = "No-Clip Toggle",
    Description = "Enable or disable no-clip",
    CurrentValue = false,
    Callback = function(Value)
        toggleNoclip(Value)
    end
}, "NoClipToggle") -- Unique flag for configuration saving

Tab:CreateDivider()

-- Infinite Yield
local Button = Tab:CreateButton({
    Name = "Infinite Yield",
    Description = "Click to get admin commands.",
    Callback = function()
        -- Load the admin script
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end
}, "AdminButton") -- Unique flag for saving configuration

Tab:CreateDivider()

local player = game.Players.LocalPlayer
local targetPlayerName = nil -- Store the name of the player to follow
local following = false -- State for the follow toggle

-- Helper function to find a player by name or display name
local function findPlayerByName(partialName)
    for _, targetPlayer in ipairs(game.Players:GetPlayers()) do
        if string.find(targetPlayer.Name:lower(), partialName:lower()) or string.find(targetPlayer.DisplayName:lower(), partialName:lower()) then
            return targetPlayer
        end
    end
    return nil -- Return nil if no match is found
end

-- Function to follow the target player
local function followPlayer()
    task.spawn(function()
        while following do
            task.wait(0.1) -- Adjust the frequency of updates as needed

            local targetPlayer = findPlayerByName(targetPlayerName)
            if not targetPlayer then
                print("Target player not found:", targetPlayerName)
                following = false
                break
            end

            local targetCharacter = targetPlayer.Character
            local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
            local localCharacter = player.Character
            local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")

            if targetRoot and localRoot then
                -- Move the local player towards the target player's position
                localRoot.CFrame = targetRoot.CFrame
            else
                print("Invalid character or missing parts for either player.")
                following = false
                break
            end
        end
    end)
end

-- Input box for entering the target player's name
Tab:CreateInput({
    Name = "Player Name",
    Description = "Enter the name of the player to follow",
    PlaceholderText = "Enter player name",
    Callback = function(value)
        targetPlayerName = value
        print("Target player set to:", targetPlayerName)
    end
}, "FollowPlayerInput")

-- Toggle for enabling/disabling follow
Tab:CreateToggle({
    Name = "Follow Player",
    Description = "Toggle to follow the specified player",
    CurrentValue = false, -- Default off
    Callback = function(state)
        following = state
        if following then
            if targetPlayerName then
                print("Started following:", targetPlayerName)
                followPlayer()
            else
                print("No player name entered.")
                following = false
            end
        else
            print("Stopped following.")
        end
    end
}, "FollowPlayerToggle")

Tab:CreateDivider()

local function setInvincibility(state)
    local player = game.Players.LocalPlayer

    -- Function to apply invincibility logic to the humanoid
    local function applyInvincibility(humanoid)
        if humanoid then
            if state then
                humanoid.Health = math.huge
                humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                    if invincibilityToggle then
                        humanoid.Health = math.huge
                    end
                end)
                print("Invincibility enabled.")
            else
                humanoid.Health = humanoid.MaxHealth -- Reset to normal
                print("Invincibility disabled.")
            end
        end
    end

    -- Handle current character
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    applyInvincibility(humanoid)

    -- Handle respawn
    player.CharacterAdded:Connect(function(newCharacter)
        local newHumanoid = newCharacter:WaitForChild("Humanoid", 5)
        applyInvincibility(newHumanoid)
    end)
end

Tab:CreateDivider()

-- Sex Shit
local Tab = Window:CreateTab({
	Name = "Sex Stuff",
	Icon = "view_in_ar",
	ImageSource = "Material",
	ShowTitle = true -- This will determine whether the big header text in the tab will show
})

local Button = Tab:CreateButton({
	Name = "Close Hub",
	Description = nil, -- Creates A Description For Users to know what the button does (looks bad if you use it all the time),
    	Callback = function()
         Luna:Destroy()
    	end
})

Tab:CreateDivider()

local Button = Tab:CreateButton({
    Name = "R6 Jerk Off",
    Description = "Click To Jerk OFF.",
    Callback = function()
        -- Load the admin script
        loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
    end
}, "R6Jerk") -- Unique flag for saving configuration

local Button = Tab:CreateButton({
    Name = "R15 Jerk Off",
    Description = "Click To Jerk OFF.",
    Callback = function()
        -- Load the admin script
        loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
    end
}, "R15Jerk") -- Unique flag for saving configuration

Tab:CreateDivider()

local Button = Tab:CreateButton({
    Name = "Bang Hub",
    Callback = function()
        -- Load the admin script
        loadstring(game:HttpGet("https://pastebin.com/raw/38Jra00x"))()
    end
}, "BangHub") -- Unique flag for saving configuration

Tab:CreateDivider()

local Button = Tab:CreateButton({
    Name = "Chat Bypass",
    Description = "CAN GET BANNED IF REPORTED",
    Callback = function()
        -- Load the admin script
        loadstring(game:HttpGet('https://raw.githubusercontent.com/shakk-code/SigmaBypasser/refs/heads/main/source', true))()
    end
}, "ChatBypass") -- Unique flag for saving configuration

Tab:CreateDivider()

-- First Person Shooter Stuff
local Tab = Window:CreateTab({
	Name = "FPS",
	Icon = "view_in_ar",
	ImageSource = "Material",
	ShowTitle = true -- This will determine whether the big header text in the tab will show
})

local Button = Tab:CreateButton({
	Name = "Close Hub",
	Description = nil, -- Creates A Description For Users to know what the button does (looks bad if you use it all the time),
    	Callback = function()
         Luna:Destroy()
    	end
})

Tab:CreateDivider()

-- Variables for ESP functionality
local espEnabled = false
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local espObjects = {}

-- Function to create ESP for a player
local function createESP(player)
    if player == players.LocalPlayer then return end -- Skip the local player

    -- Ensure we add the highlight only when the character is available
    local function addHighlight(character)
        if not espObjects[player] then
            local highlight = Instance.new("Highlight")
            highlight.Parent = character
            highlight.Adornee = character
            highlight.FillColor = Color3.new(1, 0, 0) -- Red highlight
            highlight.OutlineColor = Color3.new(1, 1, 1) -- White outline
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            espObjects[player] = highlight
        end
    end

    if player.Character then
        addHighlight(player.Character)
    end

    player.CharacterAdded:Connect(function(character)
        if espEnabled then
            addHighlight(character)
        end
    end)
end

-- Function to remove ESP for a player
local function removeESP(player)
    if espObjects[player] then
        espObjects[player]:Destroy()
        espObjects[player] = nil
    end
end

-- Toggle ESP functionality
local function toggleESP(state)
    espEnabled = state

    if espEnabled then
        -- Add ESP for all current players
        for _, player in ipairs(players:GetPlayers()) do
            createESP(player)
        end

        -- Listen for new players joining
        players.PlayerAdded:Connect(function(player)
            createESP(player)
        end)

        -- Listen for players leaving
        players.PlayerRemoving:Connect(function(player)
            removeESP(player)
        end)
    else
        -- Disable ESP by removing all highlights
        for _, highlight in pairs(espObjects) do
            highlight:Destroy()
        end
        espObjects = {}
    end
end

-- Toggle button for ESP
Tab:CreateToggle({
    Name = "ESP Toggle",
    Description = "Enable or disable ESP.",
    CurrentValue = false,
    Callback = function(state)
        toggleESP(state)
    end
}, "ESPToggle")

-- Optional Color Picker for ESP
local currentColor = Color3.new(1, 0, 0) -- Default Red
Tab:CreateColorPicker({
    Name = "ESP Color",
    Default = currentColor,
    Callback = function(color)
        currentColor = color
        for _, highlight in pairs(espObjects) do
            highlight.FillColor = currentColor
        end
    end
}, "ESPColorPicker")

Tab:CreateDivider()

-- Infinite Jump
-- Services and variables
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local infiniteJumpEnabled = false

-- Assuming 'Tab:CreateToggle' is a function from your Luna interface library
local Toggle = Tab:CreateToggle({
    Name = "Infinite Jump",
    Description = "Enable or disable infinite jumping",
    CurrentValue = false, -- Default state is OFF
    Callback = function(Value)
        -- Value is a boolean that represents the toggle state
        infiniteJumpEnabled = Value
    end
}, "InfiniteJumpToggle")

-- Infinite jump functionality
userInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

Tab:CreateDivider()

-- Function to create and manage name tags
local function manageNameTags(enabled)
    if enabled then
        local function addTagToPlayer(player)
            if player ~= game.Players.LocalPlayer then
                local character = player.Character or player.CharacterAdded:Wait()
                local head = character:WaitForChild("Head")

                -- Check if the tag is already added
                if not head:FindFirstChild("UsernameTag") then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "UsernameTag"
                    billboard.Size = UDim2.new(0, 200, 0, 50)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Parent = head

                    local textLabel = Instance.new("TextLabel")
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Text = player.Name
                    textLabel.TextColor3 = Color3.new(1, 1, 1)
                    textLabel.TextScaled = false
                    textLabel.TextSize = 14
                    textLabel.Font = Enum.Font.SourceSansBold
                    textLabel.Parent = billboard
                end
            end
        end

        for _, player in pairs(game.Players:GetPlayers()) do
            addTagToPlayer(player)
        end

        game.Players.PlayerAdded:Connect(addTagToPlayer)

        -- Monitor distance and toggle visibility
        game:GetService("RunService").Heartbeat:Connect(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    local character = player.Character
                    if character then
                        local head = character:FindFirstChild("Head")
                        local tag = head and head:FindFirstChild("UsernameTag")

                        if tag then
                            local distance = (head.Position - game.Players.LocalPlayer.Character.Head.Position).Magnitude
                            if distance <= 10 then -- Adjust this value as necessary
                                tag.Enabled = false
                            else
                                tag.Enabled = true
                            end
                        end
                    end
                end
            end
        end)
    else
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                local character = player.Character
                if character then
                    local head = character:FindFirstChild("Head")
                    if head then
                        local tag = head:FindFirstChild("UsernameTag")
                        if tag then
                            tag:Destroy()
                        end
                    end
                end
            end
        end
    end
end

-- Toggle setup
local Toggle = Tab:CreateToggle({
    Name = "Show Usernames",
    Description = "Toggle to show usernames above players' heads",
    Default = false,
    Callback = function(Value)
        manageNameTags(Value)
    end
})

Tab:CreateDivider()

local aimbotToggle = false -- Initial state of aimbot toggle
local player = game.Players.LocalPlayer

-- Helper function to check if a player is on the same team
local function isOnTeam(target)
    if player.Team and target.Team then
        return player.Team == target.Team
    end
    return false
end

-- Function to find the closest target
local function findClosestTarget()
    local shortestDistance = math.huge
    local closestTarget = nil

    for _, target in pairs(game.Players:GetPlayers()) do
        if target ~= player and not isOnTeam(target) then
            local character = target.Character
            local targetHead = character and character:FindFirstChild("Head")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local localHead = player.Character and player.Character:FindFirstChild("Head")

            if targetHead and humanoid and humanoid.Health > 0 and localHead then
                local distance = (targetHead.Position - localHead.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestTarget = targetHead
                end
            end
        end
    end

    return closestTarget
end

-- Function to lock onto the target
local function lockOnTarget()
    if not aimbotToggle then return end

    local target = findClosestTarget()
    if target then
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position)
    end
end

-- Toggle for aimbot
Tab:CreateToggle({
    Name = "Aimbot Toggle",
    Description = "Enable or disable aimbot functionality",
    CurrentValue = false, -- Default off
    Callback = function(Value)
        aimbotToggle = Value
    end
}, "AimbotToggle")

-- Main loop for aimbot
game:GetService("RunService").RenderStepped:Connect(function()
    lockOnTarget()
end)
