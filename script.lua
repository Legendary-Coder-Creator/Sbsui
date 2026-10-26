-- Delta Executor Custom Multi-Jumpscare Script

-- 1. CONFIGURATION (Replace 00000000 with your actual Asset IDs)
local PIC_1 = "rbxassetid://10527478747" -- First picture of your face
local PIC_2 = "rbxassetid://108101808734917" -- Second picture of your face
local PIC_3 = "rbxassetid://13767452957" -- Third picture of your face
local LOUD_SOUND_ID = "rbxassetid://137800374619679" -- Scary sound ID

-- Put the pictures in an ordered list for cycling
local pictureRotation = {PIC_1, PIC_2, PIC_3}
local totalPictures = #pictureRotation
local clickCount = 0 -- Keeps track of total clicks

-- 2. CREATE CORE SCREEN INTERFACE
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Clean up any existing instances of this menu to prevent overlay clutter
if CoreGui:FindFirstChild("MieshaCycleGui") then
    CoreGui.MieshaCycleGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MieshaCycleGui"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- 3. THE DRAGGABLE WINDOW CONTAINER
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 180)
MainFrame.Position = UDim2.new(0.5, -175, 0.4, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(150, 0, 0)
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 8)
FrameCorner.Parent = MainFrame

-- Make the Menu Draggable
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseBehavior or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- 4. SCARY WARNING FONT LABEL
local WarningLabel = Instance.new("TextLabel")
WarningLabel.Size = UDim2.new(1, 0, 0, 60)
WarningLabel.Position = UDim2.new(0, 0, 0, 15)
WarningLabel.BackgroundTransparency = 1
WarningLabel.Text = "DONT PRESS MIESHA JUMLI"
WarningLabel.TextColor3 = Color3.fromRGB(200, 0, 0)
WarningLabel.TextSize = 24
WarningLabel.Font = Enum.Font.Creepster
WarningLabel.TextWrapped = true
WarningLabel.Parent = MainFrame

-- 5. THE TARGET RED BUTTON
local RedButton = Instance.new("TextButton")
RedButton.Size = UDim2.new(0, 200, 0, 50)
RedButton.Position = UDim2.new(0.5, -100, 1, -75)
RedButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
RedButton.Text = "PRESS ME"
RedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RedButton.Font = Enum.Font.SourceSansBold
RedButton.TextSize = 20
RedButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = RedButton

RedButton.MouseEnter:Connect(function() RedButton.BackgroundColor3 = Color3.fromRGB(230, 0, 0) end)
RedButton.MouseLeave:Connect(function() RedButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0) end)

-- 6. JUMPSCARE OVERLAY CREATION
local JumpscareFrame = Instance.new("Frame")
JumpscareFrame.Size = UDim2.new(1, 0, 1, 0)
JumpscareFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
JumpscareFrame.Visible = false
JumpscareFrame.Parent = ScreenGui

local FaceImage = Instance.new("ImageLabel")
FaceImage.Size = UDim2.new(0.9, 0, 0.9, 0)
FaceImage.Position = UDim2.new(0.05, 0, 0.05, 0)
FaceImage.BackgroundTransparency = 1
FaceImage.Parent = JumpscareFrame

local ScarySound = Instance.new("Sound")
ScarySound.SoundId = LOUD_SOUND_ID
ScarySound.Volume = 10
ScarySound.Parent = JumpscareFrame

-- 7. ROTATION INJECTION LOGIC
RedButton.MouseButton1Click:Connect(function()
    -- 1. Increment total click count
    clickCount = clickCount + 1
    
    -- 2. Math formula to cleanly wrap around (1 -> 2 -> 3 -> 1 -> 2 -> 3)
    local targetIndex = ((clickCount - 1) % totalPictures) + 1
    
    -- Assign the image from our rotation sequence list
    FaceImage.Image = pictureRotation[targetIndex]
    
    -- 3. Trigger jumpscare sequence panel
    MainFrame.Visible = false
    JumpscareFrame.Visible = true
    ScarySound:Play()
    
    -- Screen shake sequence
    for i = 1, 10 do
        FaceImage.Position = UDim2.new(0.05 + math.random(-2, 2)/100, 0, 0.05 + math.random(-2, 2)/100, 0)
        task.wait(0.04)
    end
    FaceImage.Position = UDim2.new(0.05, 0, 0.05, 0)
    
    -- 4. Clear the overlay screen and reveal the draggable box again for the next click
    task.wait(1.5)
    JumpscareFrame.Visible = false
    MainFrame.Visible = true
end)
