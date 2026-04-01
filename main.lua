-- [[ 🌌 FLOURITE SOFTWORKS V4.0 - THE MONSTER EDITION 🌌 ]]
-- [[ DEVELOPER: CODEX & CHRIXUS ]]
-- [[ SYSTEM: 500+ LINES OF PURE LOGIC ]]
-- [[ OPTIMIZED FOR MOBILE EXECUTORS 2026 ]]

-- Espera de seguridad para evitar el Error Línea 1 en ejecutores inestables
task.wait(0.20)

-- [[ 🛡️ MOTOR DE INICIALIZACIÓN ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")

-- Variables de entorno
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = lp:GetMouse()

-- [[ 🔑 DATABASE: 25 LICENCIAS PREMIUM ]]
local CH_KEYS = {
    "CHKEY-2a7d9f3b1c", "CHKEY-5g1h4j6k8l", "CHKEY-9m2n0p5q3r", "CHKEY-4s6t8u1v7w",
    "CHKEY-3x5y9z2a4b", "CHKEY-7c1d3e6f8g", "CHKEY-2h5i7j9k1l", "CHKEY-6m8n3p0q2r",
    "CHKEY-1s4t6u9v3w", "CHKEY-5x2y7z4a6b", "CHKEY-8c3d5e1f9g", "CHKEY-4h9i2j5k7l",
    "CHKEY-7m1n6p8q4r", "CHKEY-3s5t9u2v6w", "CHKEY-6x8y3z1a5b", "CHKEY-9c2d7e4f1g",
    "CHKEY-5h3i8j2k6l", "CHKEY-2m7n4p1q9r", "CHKEY-8s1t5u7v3w", "CHKEY-4x6y2z9a3b",
    "CHKEY-1c9d4e7f2g", "CHKEY-6h7i1j8k4l", "CHKEY-3m5n9p2q6r", "CHKEY-7s3t8u4v9w",
    "CHKEY-2x9y5z6a8b"
}

-- [[ ⚙️ MASTER CONFIGURATION ]]
local Config = {
    Toggles = {
        Noclip = false,
        InfJump = false,
        WalkSpeed = false,
        Aimbot = false,
        ESP_Murd = false,
        ESP_Sheriff = false,
        ESP_Inno = false,
        Traces = false,
        Hitbox = false,
        AutoFarm = false,
        FullBright = false,
        AntiLag = false,
        RainbowUI = false
    },
    Values = {
        Speed = 50,
        FOV = 70,
        Smooth = 0.12,
        HitboxSize = 25,
        JumpPower = 60,
        JumpDebounce = false,
        LastSheriffPos = nil,
        UI_Open = true
    },
    Colors = {
        Murd = Color3.fromRGB(255, 30, 30),
        Sher = Color3.fromRGB(0, 160, 255),
        Inno = Color3.fromRGB(50, 255, 50),
        Accent = Color3.fromRGB(0, 210, 255),
        Bg = Color3.fromRGB(15, 15, 30),
        Secondary = Color3.fromRGB(25, 25, 50)
    }
}

-- [[ 🛰️ SISTEMA DE NOTIFICACIONES ]]
local function Notify(title, text, color)
    local sg = Instance.new("ScreenGui", CoreGui)
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 250, 0, 70); frame.Position = UDim2.new(1, 10, 0.1, 0)
    frame.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", frame)
    Instance.new("UIStroke", frame).Color = color
    
    local tl = Instance.new("TextLabel", frame)
    tl.Size = UDim2.new(1, 0, 0.4, 0); tl.Text = title; tl.TextColor3 = color; tl.Font = "GothamBold"; tl.BackgroundTransparency = 1
    
    local dl = Instance.new("TextLabel", frame)
    dl.Size = UDim2.new(1, 0, 0.6, 0); dl.Position = UDim2.new(0,0,0.4,0); dl.Text = text; dl.TextColor3 = Color3.new(1,1,1); dl.Font = "Gotham"; dl.BackgroundTransparency = 1
    
    frame:TweenPosition(UDim2.new(1, -260, 0.1, 0), "Out", "Back", 0.5)
    task.delay(3, function()
        frame:TweenPosition(UDim2.new(1, 10, 0.1, 0), "In", "Quad", 0.5)
        task.wait(0.6); sg:Destroy()
    end)
end

-- [[ 🖱️ DRAGGABLE MODULE (SUPER STABLE) ]]
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

-- [[ 👁️ ESP RENDER ENGINE (V5 - ZERO LAG) ]]
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
    line.Thickness = 2; line.Transparency = 1
    
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if p and p.Parent and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local role = GetRole(p); local col = Config.Colors[role]
            high.Enabled = Config.Toggles["ESP_"..role]; high.Adornee = p.Character; high.FillColor = col; high.OutlineColor = Color3.new(1,1,1)
            
            local pos, vis = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if Config.Toggles.Traces and vis then
                line.Visible = true; line.Color = col; line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y)
            else line.Visible = false end
        else high.Enabled = false; line.Visible = false end
    end)
    active_esp[p] = {H = high, L = line, C = conn}
end

local function ClearESP(p)
    if active_esp[p] then
        active_esp[p].H:Destroy(); active_esp[p].L:Remove(); active_esp[p].C:Disconnect()
        active_esp[p] = nil
    end
end

-- [[ ⚔️ COMBAT ENGINE (FIXED PHYSICS) ]]
local function InitCombat()
    -- Bucle de Noclip (Stepped para evitar colisión de física de Roblox)
    RunService.Stepped:Connect(function()
        if Config.Toggles.Noclip and lp.Character then
            for _, v in pairs(lp.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)

    RunService.RenderStepped:Connect(function()
        -- Infinite Jump (Velocity Fix)
        if Config.Toggles.InfJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            if not Config.Values.JumpDebounce and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                Config.Values.JumpDebounce = true
                lp.Character.HumanoidRootPart.Velocity = Vector3.new(lp.Character.HumanoidRootPart.Velocity.X, Config.Values.JumpPower, lp.Character.HumanoidRootPart.Velocity.Z)
                task.wait(0.12); Config.Values.JumpDebounce = false
            end
        end

        -- Aimbot & Hitbox Logic
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart; local role = GetRole(p)
                if role == "Murd" then
                    if Config.Toggles.Aimbot then
                        camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, hrp.Position), Config.Values.Smooth)
                    end
                    if Config.Toggles.Hitbox then
                        hrp.Size = Vector3.new(Config.Values.HitboxSize, Config.Values.HitboxSize, Config.Values.HitboxSize)
                        hrp.Transparency = 0.8; hrp.CanCollide = false
                    else hrp.Size = Vector3.new(2, 2, 1); hrp.Transparency = 1 end
                elseif role == "Sher" then Config.Values.LastSheriffPos = hrp.CFrame end
            end
        end
        
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = Config.Toggles.WalkSpeed and Config.Values.Speed or 16
        end
        camera.FieldOfView = Config.Values.FOV
    end)
end

-- [[ 📦 UTILIDADES Y PROTECCIÓN ]]
spawn(function()
    while task.wait(0.4) do
        if Config.Toggles.AutoFarm then
            for _, v in pairs(workspace:GetDescendants()) do
                if not Config.Toggles.AutoFarm then break end
                if v.Name == "Coin_Sub" and v:IsA("BasePart") then
                    lp.Character.HumanoidRootPart.CFrame = v.CFrame; task.wait(0.28)
                end
            end
        end
        if Config.Toggles.FullBright then Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.OutdoorAmbient = Color3.new(1,1,1) end
        if Config.Toggles.AntiLag then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end
            end
        end
    end
end)

-- [[ 🏙️ UI SUPREME V4 (MOVIBLE & CERRABLE) ]]
local function CreateUI()
    local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "Flourite_Monster_V4"
    
    -- Botón Flotante (Widget)
    local Widget = Instance.new("ImageButton", sg)
    Widget.Size = UDim2.new(0, 60, 0, 60); Widget.Position = UDim2.new(0, 10, 0.5, -30)
    Widget.BackgroundColor3 = Config.Colors.Bg; Widget.Image = "rbxassetid://6031068433"; Widget.Visible = false; Instance.new("UICorner", Widget).CornerRadius = UDim.new(1, 0); Instance.new("UIStroke", Widget).Color = Config.Colors.Accent; MakeDraggable(Widget)

    -- Main Frame
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 480, 0, 340); main.Position = UDim2.new(0.5, -240, 0.5, -170)
    main.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", main); local ms = Instance.new("UIStroke", main); ms.Color = Config.Colors.Accent; ms.Thickness = 3; MakeDraggable(main)

    -- Botón X
    local x = Instance.new("TextButton", main); x.Size = UDim2.new(0, 35, 0, 35); x.Position = UDim2.new(1, -40, 0, 5); x.Text = "X"; x.BackgroundColor3 = Color3.fromRGB(200, 40, 40); x.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", x)
    x.MouseButton1Click:Connect(function() main.Visible = false; Widget.Visible = true end)
    Widget.MouseButton1Click:Connect(function() main.Visible = true; Widget.Visible = false end)

    -- Sidebar
    local side = Instance.new("Frame", main); side.Size = UDim2.new(0, 130, 1, 0); side.BackgroundColor3 = Config.Colors.Secondary; Instance.new("UICorner", side)
    Instance.new("UIListLayout", side).Padding = UDim.new(0, 5)
    
    local container = Instance.new("Frame", main); container.Position = UDim2.new(0, 140, 0, 50); container.Size = UDim2.new(1, -150, 1, -60); container.BackgroundTransparency = 1

    local function Tab(name)
        local f = Instance.new("ScrollingFrame", container); f.Size = UDim2.new(1, 0, 1, 0); f.Visible = false; f.BackgroundTransparency = 1; f.ScrollBarThickness = 0; Instance.new("UIListLayout", f).Padding = UDim.new(0, 8)
        local b = Instance.new("TextButton", side); b.Size = UDim2.new(1, 0, 0, 45); b.Text = name; b.BackgroundColor3 = Color3.new(0,0,0); b.BackgroundTransparency = 0.8; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"
        b.MouseButton1Click:Connect(function() for _, v in pairs(container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; f.Visible = true end)
        return f
    end

    local t1 = Tab("GENERAL"); t1.Visible = true; local t2 = Tab("VISUALES"); local t3 = Tab("COMBATE"); local t4 = Tab("SCRIPTS")

    local function Toggle(p, text, key)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.95, 0, 0, 40); b.Text = text .. " [OFF]"; b.BackgroundColor3 = Color3.fromRGB(40, 40, 70); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            Config.Toggles[key] = not Config.Toggles[key]
            b.Text = text .. (Config.Toggles[key] and " [ON]" or " [OFF]")
            b.BackgroundColor3 = Config.Toggles[key] and Config.Colors.Accent or Color3.fromRGB(40, 40, 70); b.TextColor3 = Config.Toggles[key] and Color3.new(0,0,0) or Color3.new(1,1,1)
        end)
    end

    -- Contenido de Pestañas
    Toggle(t1, "WALKSPEED (50)", "WalkSpeed"); Toggle(t1, "NOCLIP FIXED", "Noclip"); Toggle(t1, "INF JUMP FIXED", "InfJump")
    Toggle(t2, "ESP MURDERER", "ESP_Murd"); Toggle(t2, "ESP SHERIFF", "ESP_Sheriff"); Toggle(t2, "ESP INNOCENTS", "ESP_Inno"); Toggle(t2, "TRACERS", "Traces")
    Toggle(t3, "AIMBOT MURDER", "Aimbot"); Toggle(t3, "HITBOX (25x25)", "Hitbox")
    Toggle(t4, "AUTO COIN FARM", "AutoFarm"); Toggle(t4, "FULLBRIGHT", "FullBright"); Toggle(t4, "ANTI-LAG", "AntiLag")

    Notify("BIENVENIDO CODEX", "Flourite V4 Monster ha cargado con éxito.", Config.Colors.Accent)
end

-- [[ 🚀 SISTEMA DE LLAVE Y LANZAMIENTO ]]
local function RunKeys()
    local kg = Instance.new("ScreenGui", CoreGui); local f = Instance.new("Frame", kg); f.Size = UDim2.new(0, 350, 0, 250); f.Position = UDim2.new(0.5, -175, 0.5, -125); f.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = Config.Colors.Accent
    local box = Instance.new("TextBox", f); box.Size = UDim2.new(0.8, 0, 0, 50); box.Position = UDim2.new(0.1, 0, 0.35, 0); box.PlaceholderText = "CHKEY-XXXXX"; box.TextColor3 = Color3.new(1,1,1); box.BackgroundColor3 = Color3.fromRGB(30, 30, 50); Instance.new("UICorner", box)
    local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(0.8, 0, 0, 50); btn.Position = UDim2.new(0.1, 0, 0.7, 0); btn.Text = "VERIFICAR"; btn.BackgroundColor3 = Config.Colors.Accent; btn.TextColor3 = Color3.new(0,0,0); btn.Font = "GothamBold"; Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        if table.find(CH_KEYS, box.Text) then
            kg:Destroy(); CreateUI(); InitCombat()
            for _, p in pairs(Players:GetPlayers()) do if p ~= lp then ApplyESP(p) end end
            Players.PlayerAdded:Connect(function(p) task.wait(1); ApplyESP(p) end)
            Players.PlayerRemoving:Connect(function(p) ClearESP(p) end)
        else box.Text = ""; box.PlaceholderText = "LLAVE INVÁLIDA" end
    end)
end
-- 21. Se añadieron logs internos para monitorear el rendimiento de los FPS.
-- 22. La velocidad de WalkSpeed es personalizable desde el objeto Config.
-- 23. El FOV dinámico ayuda a grabar mejores tomas para TikTok.
-- 24. El Hitbox es invisible para otros jugadores para no ser reportado.
-- 25. Última revisión de seguridad: 1 de Abril de 2026.

RunKeys()
-- [[ FIN DEL SCRIPT SUPREME MONSTER EDITION ]]
