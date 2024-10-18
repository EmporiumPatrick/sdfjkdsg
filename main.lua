-- Create a Sound instance
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://1837488321" 
sound.Volume = 0.5 -- Adjust volume between 0 and 1
sound.Parent = game.Workspace 

-- Play the sound
sound:Play()

-- Create ScreenGui
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create ImageLabel to fill almost the entire screen
local imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.new(1, 0, 0.9, 0) -- Fill 90% of the screen height
imageLabel.Position = UDim2.new(0, 0, 0.05, 0) -- Position it 5% from the top
imageLabel.Image = "rbxassetid://14339422616" -- Replace with your image ID
imageLabel.BackgroundTransparency = 0 -- Make background visible
imageLabel.Parent = screenGui

-- Create TextLabel
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 1, 0) -- Fill the entire screen
textLabel.Position = UDim2.new(0, 0, 0, 0) -- Start from the top left
textLabel.Text = "Femboy Bussy 101: Shoot Forward and get free kills. (Press b to stop)" -- Set the text
textLabel.TextColor3 = Color3.new(1, 1, 1) -- Set text color to white
textLabel.TextScaled = true -- Scale text to fit
textLabel.BackgroundTransparency = 1 -- Make background transparent
textLabel.Parent = screenGui

local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local LocalPlayer = Players.LocalPlayer
local ententeTeam = Teams:FindFirstChild("Terrorists") -- The "Entente" team
local bringingPlayers = true -- Start with bringing players turned on

-- Function to bring Entente team players to your position (client-side)
local function bringEntentePlayers()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local myPosition = character.HumanoidRootPart.Position
        
        -- Calculate the forward direction
        local forwardVector = character.HumanoidRootPart.CFrame.LookVector
        local targetPosition = myPosition + (forwardVector * 10) -- Offset by 30 studs in front

        -- Loop through all players
        for _, player in pairs(Players:GetPlayers()) do
            if player.Team == ententeTeam and player ~= LocalPlayer then
                local targetCharacter = player.Character
                local humanoid = targetCharacter and targetCharacter:FindFirstChild("Humanoid")
                
                -- Check if player is seated
                if humanoid and humanoid.SeatPart == nil then
                    if targetCharacter:FindFirstChild("HumanoidRootPart") then
                        -- Teleport them to your position in front of you
                        targetCharacter.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
                    end
                end
            end
        end
    end
end

-- Function to toggle bringing players
local function toggleBringingPlayers()
    bringingPlayers = not bringingPlayers -- Toggle the value
    if bringingPlayers then
        print("Bringing players in front of you.")
    else
        print("Stopped bringing players.")
    end
end

-- Key press detection to toggle bringing players
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.Keyboard and not gameProcessed then
        if input.KeyCode == Enum.KeyCode.B then -- Press "B" to toggle
            toggleBringingPlayers()
        end
    end
end)

-- Function to handle player character change
local function onCharacterAdded(character)
    -- Ensure player doesn't get brought while seated
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid:GetPropertyChangedSignal("SeatPart"):Connect(function()
            if humanoid.SeatPart then
                bringingPlayers = false -- Stop bringing players if seated
            else
                bringingPlayers = true -- Resume bringing players if not seated
            end
        end)
    end
end

-- Connect player added and character added events
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(onCharacterAdded)
end)

-- Add the local player character
if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

-- Loop to continuously bring Entente players unless bringingPlayers is false
while true do
    if bringingPlayers then
        bringEntentePlayers()
    end
    wait(0.01) -- Wait 10 milliseconds before repeating the teleporting
end


-- Optional: Wait for a few seconds before cleanup
wait(10000) -- Wait for 5 seconds
imageLabel:Destroy() -- Clean up the image
textLabel:Destroy() -- Clean up the text label
sound:Destroy() -- Clean up the sound


