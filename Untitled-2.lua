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
		SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
		Key = {"KraftyisHOT"}, -- List of keys that will be accepted by the system, please use a system like Pelican or Luarmor that provide key strings based on your HWID since putting a simple string is very easy to bypass
		SecondAction = {
			Enabled = true, -- Set to false if you do not want a second action,
			Type = "Link", -- Link / Discord.
			Parameter = "" -- If Type is Discord, then put your invite link (DO NOT PUT DISCORD.GG/). Else, put the full link of your key system here.
		}
	}
})

local Tab = Window:CreateTab({
	Name = "UNIVERSAL",
	Icon = "view_in_ar",
	ImageSource = "Material",
	ShowTitle = true -- This will determine whether the big header text in the tab will show
})

Tab:CreateDivider()

local Slider = Tab:CreateSlider({
    Name = "WalkSpeed",
    Range = {10, 1000}, -- The Minimum And Maximum Values Respectively
    Increment = 5,     -- Basically The Changing Value/Rounding Off
    CurrentValue = 10, -- The Starting Value
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
}, "Slider") -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps

Tab:CreateDivider()

local Slider = Tab:CreateSlider({
    Name = "Jump Power",
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
}, "Slider") -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps

Tab:CreateDivider()

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local flying, bv, bg = false, nil, nil
local flySpeed = 50 -- Default Fly Speed

-- Function to enable or disable flying
local function setFly(state)
    if flying == state then return end -- Prevent multiple toggles
    flying = state

    if flying then
        bv = Instance.new("BodyVelocity", hrp)
        bg = Instance.new("BodyGyro", hrp)
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bg.P = 3000
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        bv, bg = nil, nil
    end
end

-- Create toggle for flying
local Toggle = Tab:CreateToggle({
    Name = "Fly Toggle",
    Description = "Enable or disable flying",
    CurrentValue = false, -- Default off
    Callback = function(Value)
        setFly(Value) -- Enable or disable flying based on the toggle state
    end
}, "FlyToggle") -- Unique flag for saving configuration

-- Fly speed slider
local Slider = Tab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200}, -- The Minimum And Maximum Values Respectively
    Increment = 5, -- Basically The Changing Value/Rounding Off
    CurrentValue = flySpeed, -- The Starting Value
    Callback = function(Value)
        flySpeed = Value -- Update the fly speed value when slider is adjusted
    end
}, "FlySpeed") -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps

-- Update flying behavior during RenderStepped
game:GetService("RunService").RenderStepped:Connect(function()
    if flying and bv and bg then
        local mv, cam = Vector3.zero, workspace.CurrentCamera
        local uis = game:GetService("UserInputService")
        if uis:IsKeyDown(Enum.KeyCode.W) then mv += cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then mv -= cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then mv -= cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then mv += cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.Space) then mv += Vector3.new(0, 1, 0) end
        if uis:IsKeyDown(Enum.KeyCode.LeftControl) then mv -= Vector3.new(0, 1, 0) end
        bv.Velocity = mv.Magnitude > 0 and mv.Unit * flySpeed or Vector3.zero -- Use the updated flySpeed value
        bg.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
    end
end)

Tab:CreateDivider()

local Button = Tab:CreateButton({
    Name = "Infinity Yield",
    Description = "Click to get admin commands.",
    Callback = function()
        -- Load the admin script
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end
}, "AdminButton") -- Unique flag for saving configuration

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

local Button = Tab:CreateButton({
    Name = "Chat Bypass",
    Callback = function()
        -- Load the admin script
        loadstring(game:HttpGet('https://raw.githubusercontent.com/shakk-code/SigmaBypasser/refs/heads/main/source', true))()
    end
}, "ChatBypass") -- Unique flag for saving configuration

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

local targetPlayer = nil
local following = false

-- Function to find a player by partial username or display name
local function findPlayerByName(partialName)
    for _, player in ipairs(game.Players:GetPlayers()) do
        if string.find(player.Name:lower(), partialName:lower()) or string.find(player.DisplayName:lower(), partialName:lower()) then
            return player
        end
    end
    return nil -- Return nil if no match is found
end

-- Function to teleport to and follow the target player
local function toggleFollow(state)
    local localPlayer = game.Players.LocalPlayer
    local target = findPlayerByName(targetPlayer)

    if state and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        -- Teleport to target and start following
        localPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame

        following = true
        while following do
            task.wait(0.1)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                localPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
            else
                following = false -- Stop following if target is no longer valid
            end
        end
    else
        following = false
        print("Stopped following or invalid player.")
    end
end

-- Input box to specify player name
Tab:CreateInput({
    Name = "Player Name",
    Description = "Enter Username OR Display Name",
    PlaceholderText = "Enter Here",
    Callback = function(value)
        targetPlayer = value
    end
}, "PlayerNameInput")

-- Toggle to start/stop following
Tab:CreateToggle({
    Name = "Follow Player",
    Description = "Toggle to teleport to and follow the specified player.",
    CurrentValue = false, -- Default off
    Callback = function(state)
        if targetPlayer then
            toggleFollow(state)
        else
            print("Please enter a valid player name or display name.")
        end
    end
}, "FollowPlayerToggle")

-- Finalize GUI
Window:Toggle()

Tab:CreateDivider()
