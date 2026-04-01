--[[
    🌌 CHRISS SOFTWARE V3.9 - ULTRA SUPREME EDITION 🌌
    DEVELOPER: CODEX & CHRIXUS (FLOURITE SOFTWORKS)
    DATE: APRIL 1, 2026 | VERSION: 3.9.1 FINAL
    
    
]]

-- [[ 🛠️ SERVICIOS Y SEGURIDAD ]]
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")

-- [[ 👤 REFERENCIAS ]]
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = lp:GetMouse()

-- [[ 🔑 DATABASE: 25 LICENCIAS ]]
local CH_KEYS = {
    "CHKEY-2a7d9f3b1c", "CHKEY-5g1h4j6k8l", "CHKEY-9m2n0p5q3r", "CHKEY-4s6t8u1v7w",
    "CHKEY-3x5y9z2a4b", "CHKEY-7c1d3e6f8g", "CHKEY-2h5i7j9k1l", "CHKEY-6m8n3p0q2r",
    "CHKEY-1s4t6u9v3w", "CHKEY-5x2y7z4a6b", "CHKEY-8c3d5e1f9g", "CHKEY-4h9i2j5k7l",
    "CHKEY-7m1n6p8q4r", "CHKEY-3s5t9u2v6w", "CHKEY-6x8y3z1a5b", "CHKEY-9c2d7e4f1g",
    "CHKEY-5h3i8j2k6l", "CHKEY-2m7n4p1q9r", "CHKEY-8s1t5u7v3w", "CHKEY-4x6y2z9a3b",
    "CHKEY-1c9d4e7f2g", "CHKEY-6h7i1j8k4l", "CHKEY-3m5n9p2q6r", "CHKEY-7s3t8u4v9w",
    "CHKEY-2x9y5z6a8b"
}

-- [[ ⚙️ CONFIGURACIÓN ]]
local Config = {
    Toggles = {
        Noclip = false, InfJump = false, WalkSpeed = false,
        Aimbot = false, ESP_Murd = false, ESP_Sheriff = false,
        ESP_Inno = false, Traces = false, Hitbox = false,
        AutoFarm = false, FullBright = false, AntiLag = false
    },
    Values = {
        Speed = 50, FOV = 70, Smooth = 0.12,
        HitboxSize = 20, JumpPower = 50,
        JumpDebounce = false, LastSheriffPos = nil
    },
    Colors = {
        Murd = Color3.fromRGB(255, 30, 30),
        Sher = Color3.fromRGB(0, 160, 255),
        Inno = Color3.fromRGB(50, 255, 50),
        Accent = Color3.fromRGB(0, 210, 255),
        Bg = Color3.fromRGB(15, 15, 30)
    }
}

-- [[ 🖱️ DRAGGABLE ENGINE ]]
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    obj.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [[ 👁️ MOTOR ESP V4 (INSTANT DETECT) ]]
local active_esp = {}
local function GetRole(p)
    if not p or not p.Character then return "Inno" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murd" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sher" end
    return "Inno"
end

local function ApplyESP(p)
    if active_esp[p] then return end
    local high = Instance.new("Highlight", CoreGui)
    local line = Drawing.new("Line")
    line.Thickness = 2
    
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if p and p.Parent and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local role = GetRole(p)
            high.Enabled = Config.Toggles["ESP_"..role]
            high.Adornee = p.Character
            high.FillColor = Config.Colors[role]
            
            local pos, vis = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if Config.Toggles.Traces and vis then
                line.Visible = true; line.Color = Config.Colors[role]
                line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y)
            else line.Visible = false end
        else
            high.Enabled = false; line.Visible = false
        end
    end)
    active_esp[p] = {H = high, L = line, C = conn}
end

local function ClearESP(p)
    if active_esp[p] then
        active_esp[p].H:Destroy(); active_esp[p].L:Remove(); active_esp[p].C:Disconnect()
        active_esp[p] = nil
    end
end

-- [[ ⚔️ MOTOR DE COMBATE (FIXED JUMP & HITBOX) ]]
local function InitCombat()
    RunService.Stepped:Connect(function()
        -- NOCLIP FIXED (Sin colisión física)
        if Config.Toggles.Noclip and lp.Character then
            for _, v in pairs(lp.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
            end
        end
    end)

    RunService.RenderStepped:Connect(function()
        -- JUMP FIXED (Impulso real)
        if Config.Toggles.InfJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            if not Config.Values.JumpDebounce and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                Config.Values.JumpDebounce = true
                lp.Character.HumanoidRootPart.Velocity = Vector3.new(lp.Character.HumanoidRootPart.Velocity.X, Config.Values.JumpPower, lp.Character.HumanoidRootPart.Velocity.Z)
                task.wait(0.1); Config.Values.JumpDebounce = false
            end
        end

        -- AIMBOT & HITBOX (Para que cuenten las balas)
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local role = GetRole(p)
                
                if role == "Murd" then
                    if Config.Toggles.Aimbot then
                        local goal = CFrame.new(camera.CFrame.Position, hrp.Position)
                        camera.CFrame = camera.CFrame:Lerp(goal, Config.Values.Smooth)
                    end
                    if Config.Toggles.Hitbox then
                        hrp.Size = Vector3.new(Config.Values.HitboxSize, Config.Values.HitboxSize, Config.Values.HitboxSize)
                        hrp.Transparency = 0.7; hrp.CanCollide = false -- Mantenemos CanCollide false para no bugear pero el Hitbox cuenta el toque
                    else
                        hrp.Size = Vector3.new(2, 2, 1); hrp.Transparency = 1
                    end
                elseif role == "Sher" then Config.Values.LastSheriffPos = hrp.CFrame end
            end
        end
        
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = Config.Toggles.WalkSpeed and Config.Values.Speed or 16
        end
        camera.FieldOfView = Config.Values.FOV
    end)
end

-- [[ 🏙️ UI SUPREME MOVIBLE ]]
local function CreateUI()
    local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "FLOURITE_V3_9"
    local Widget = Instance.new("ImageButton", sg)
    Widget.Size = UDim2.new(0, 55, 0, 55); Widget.Position = UDim2.new(0, 15, 0.4, 0); Widget.BackgroundColor3 = Config.Colors.Bg; Widget.Image = "rbxassetid://6031068433"; Widget.Visible = false; Instance.new("UICorner", Widget).CornerRadius = UDim.new(1, 0); Instance.new("UIStroke", Widget).Color = Config.Colors.Accent; MakeDraggable(Widget)

    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 460, 0, 320); main.Position = UDim2.new(0.5, -230, 0.5, -160); main.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", main); local ms = Instance.new("UIStroke", main); ms.Color = Config.Colors.Accent; ms.Thickness = 2.5; MakeDraggable(main)

    local CloseBtn = Instance.new("TextButton", main); CloseBtn.Size = UDim2.new(0, 32, 0, 32); CloseBtn.Position = UDim2.new(1, -38, 0, 6); CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40); CloseBtn.TextColor3 = Color3.new(1,1,1); CloseBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", CloseBtn)
    CloseBtn.MouseButton1Click:Connect(function() main.Visible = false; Widget.Visible = true end)
    Widget.MouseButton1Click:Connect(function() main.Visible = true; Widget.Visible = false end)

    local bar = Instance.new("Frame", main); bar.Size = UDim2.new(0, 120, 1, 0); bar.BackgroundTransparency = 0.95; Instance.new("UIListLayout", bar).Padding = UDim.new(0, 6)
    local container = Instance.new("Frame", main); container.Position = UDim2.new(0, 130, 0, 45); container.Size = UDim2.new(1, -140, 1, -55); container.BackgroundTransparency = 1

    local function Tab(name)
        local f = Instance.new("ScrollingFrame", container); f.Size = UDim2.new(1, 0, 1, 0); f.Visible = false; f.BackgroundTransparency = 1; f.ScrollBarThickness = 0; Instance.new("UIListLayout", f).Padding = UDim.new(0, 8)
        local b = Instance.new("TextButton", bar); b.Size = UDim2.new(1, 0, 0, 40); b.Text = name; b.BackgroundColor3 = Color3.new(0,0,0); b.BackgroundTransparency = 0.8; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold
        b.MouseButton1Click:Connect(function() for _, v in pairs(container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; f.Visible = true end)
        return f
    end

    local t1 = Tab("MAIN"); t1.Visible = true; local t2 = Tab("VISUALS"); local t3 = Tab("COMBAT"); local t4 = Tab("MISC")

    local function AddToggle(parent, text, key)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(0.95, 0, 0, 38); b.Text = text .. " [OFF]"; b.BackgroundColor3 = Color3.fromRGB(35, 35, 60); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            Config.Toggles[key] = not Config.Toggles[key]
            b.Text = text .. (Config.Toggles[key] and " [ON]" or " [OFF]")
            b.BackgroundColor3 = Config.Toggles[key] and Config.Colors.Accent or Color3.fromRGB(35, 35, 60); b.TextColor3 = Config.Toggles[key] and Color3.new(0,0,0) or Color3.new(1,1,1)
        end)
    end

    AddToggle(t1, "SPEED HACK", "WalkSpeed"); AddToggle(t1, "NOCLIP (FIXED)", "Noclip"); AddToggle(t1, "INF JUMP (FIXED)", "InfJump")
    AddToggle(t2, "ESP MURDERER", "ESP_Murd"); AddToggle(t2, "ESP SHERIFF", "ESP_Sheriff"); AddToggle(t2, "TRACERS", "Traces")
    AddToggle(t3, "AIMBOT (SMOOTH)", "Aimbot"); AddToggle(t3, "HITBOX 20x20", "Hitbox")
    AddToggle(t4, "AUTO COIN FARM", "AutoFarm"); AddToggle(t4, "FULLBRIGHT", "FullBright"); AddToggle(t4, "ANTI-LAG", "AntiLag")

    spawn(function()
        while task.wait(0.5) do
            if Config.Toggles.AutoFarm then
                for _, v in pairs(workspace:GetDescendants()) do
                    if not Config.Toggles.AutoFarm then break end
                    if v.Name == "Coin_Sub" and v:IsA("BasePart") then lp.Character.HumanoidRootPart.CFrame = v.CFrame; task.wait(0.28) end
                end
            end
            if Config.Toggles.FullBright then Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.OutdoorAmbient = Color3.new(1,1,1) end
        end
    end)
end
es
-- [[ 🚀 LAUNCHER ]]
local function Start()
    CreateUI(); InitCombat()
    for _, p in pairs(Players:GetPlayers()) do if p ~= lp then ApplyESP(p) end end
    Players.PlayerAdded:Connect(function(p) task.wait(1); ApplyESP(p) end)
    Players.PlayerRemoving:Connect(function(p) ClearESP(p) end)
end

local function RunKeys()
    local kg = Instance.new("ScreenGui", CoreGui); local f = Instance.new("Frame", kg); f.Size = UDim2.new(0, 350, 0, 250); f.Position = UDim2.new(0.5, -175, 0.5, -125); f.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = Config.Colors.Accent
    local t = Instance.new("TextBox", f); t.Size = UDim2.new(0.8, 0, 0, 45); t.Position = UDim2.new(0.1, 0, 0.35, 0); t.PlaceholderText = "CHKEY-XXXXX"; t.TextColor3 = Color3.new(1,1,1); t.BackgroundColor3 = Color3.fromRGB(30, 20, 50); Instance.new("UICorner", t)
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(0.8, 0, 0, 45); b.Position = UDim2.new(0.1, 0, 0.7, 0); b.Text = "VERIFICAR"; b.BackgroundColor3 = Config.Colors.Accent; b.TextColor3 = Color3.new(0,0,0); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() if table.find(CH_KEYS, t.Text) then kg:Destroy(); Start() end end)
end


RunKeys()
-- [[ FIN DEL SCRIPT SUPREME ]]
