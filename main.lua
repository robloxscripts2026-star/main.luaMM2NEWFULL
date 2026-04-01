--[[
    🌌 CHRISS SOFTWARE V3.8 - SUPREME HYBRID ULTIMATE 🌌
    DEVELOPER: CODEX & CHRIXUS (FLOURITE SOFTWORKS)
    DATE: APRIL 1, 2026 | VERSION: 3.8.2 STABLE

]]

-- [[ 🛡️ SISTEMA DE SEGURIDAD E INICIALIZACIÓN ]]
if not game:IsLoaded() then game.Loaded:Wait() end
print("[FLOURITE]: INICIANDO CARGA DE COMPONENTES...")

-- [[ 🛠️ SERVICIOS PRINCIPALES ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")

-- [[ 👤 REFERENCIAS LOCALES ]]
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = lp:GetMouse()

-- [[ 🔑 DATABASE: 25 LICENCIAS ACTIVAS ]]
local CH_KEYS = {
    "CHKEY-2a7d9f3b1c", "CHKEY-5g1h4j6k8l", "CHKEY-9m2n0p5q3r", "CHKEY-4s6t8u1v7w",
    "CHKEY-3x5y9z2a4b", "CHKEY-7c1d3e6f8g", "CHKEY-2h5i7j9k1l", "CHKEY-6m8n3p0q2r",
    "CHKEY-1s4t6u9v3w", "CHKEY-5x2y7z4a6b", "CHKEY-8c3d5e1f9g", "CHKEY-4h9i2j5k7l",
    "CHKEY-7m1n6p8q4r", "CHKEY-3s5t9u2v6w", "CHKEY-6x8y3z1a5b", "CHKEY-9c2d7e4f1g",
    "CHKEY-5h3i8j2k6l", "CHKEY-2m7n4p1q9r", "CHKEY-8s1t5u7v3w", "CHKEY-4x6y2z9a3b",
    "CHKEY-1c9d4e7f2g", "CHKEY-6h7i1j8k4l", "CHKEY-3m5n9p2q6r", "CHKEY-7s3t8u4v9w",
    "CHKEY-2x9y5z6a8b"
}

-- [[ ⚙️ CONFIGURACIÓN MAESTRA ]]
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
        AntiLag = false
    },
    Values = {
        Speed = 50,
        FOV = 70,
        Smooth = 0.15,
        HitboxSize = 15,
        JumpDebounce = false,
        LastSheriffPos = nil,
        FloatingOpen = false
    },
    Colors = {
        Murd = Color3.fromRGB(255, 30, 30),
        Sher = Color3.fromRGB(0, 160, 255),
        Inno = Color3.fromRGB(50, 255, 50),
        Accent = Color3.fromRGB(0, 210, 255),
        Bg = Color3.fromRGB(15, 15, 35)
    }
}

-- [[ 🛰️ SISTEMA DE NOTIFICACIONES SUPREME ]]
local function Notify(title, text, color)
    spawn(function()
        local sg = Instance.new("ScreenGui", CoreGui)
        local frame = Instance.new("Frame", sg)
        frame.Size = UDim2.new(0, 280, 0, 60)
        frame.Position = UDim2.new(1, 10, 0.05, 0)
        frame.BackgroundColor3 = Config.Colors.Bg
        Instance.new("UICorner", frame)
        Instance.new("UIStroke", frame).Color = color
        
        local tLabel = Instance.new("TextLabel", frame)
        tLabel.Size = UDim2.new(1, 0, 0.4, 0); tLabel.BackgroundTransparency = 1
        tLabel.Text = title; tLabel.TextColor3 = color; tLabel.Font = Enum.Font.GothamBold; tLabel.TextSize = 14
        
        local dLabel = Instance.new("TextLabel", frame)
        dLabel.Size = UDim2.new(1, 0, 0.6, 0); dLabel.Position = UDim2.new(0,0,0.4,0); dLabel.BackgroundTransparency = 1
        dLabel.Text = text; dLabel.TextColor3 = Color3.new(1,1,1); dLabel.Font = Enum.Font.Gotham; dLabel.TextSize = 12
        
        frame:TweenPosition(UDim2.new(1, -290, 0.05, 0), "Out", "Back", 0.5)
        task.wait(3.5)
        frame:TweenPosition(UDim2.new(1, 10, 0.05, 0), "In", "Quad", 0.5)
        task.wait(0.6); sg:Destroy()
    end)
end

-- [[ 🖱️ DRAGGABLE ENGINE (MULTI-INPUT) ]]
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [[ 👁️ MOTOR DE VISUALES (ESP & TRACERS) ]]
local function GetPlayerRole(p)
    if not p or not p.Character then return "Inno" end
    local inv = p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")
    if inv then return "Murd" end
    local gun = p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")
    if gun then return "Sher" end
    return "Inno"
end

local active_esp = {}
local function CreateESP(p)
    if active_esp[p] then return end
    local highlight = Instance.new("Highlight", CoreGui)
    local line = Drawing.new("Line")
    line.Thickness = 2; line.Transparency = 1
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local role = GetPlayerRole(p)
            local color = Config.Colors[role]
            local enabled = Config.Toggles["ESP_"..role]
            
            highlight.Enabled = enabled
            highlight.Adornee = p.Character
            highlight.FillColor = color
            highlight.OutlineTransparency = 0.2
            
            local pos, onScreen = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if Config.Toggles.Traces and onScreen then
                line.Visible = true; line.Color = color
                line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                line.To = Vector2.new(pos.X, pos.Y)
            else line.Visible = false end
        else
            highlight.Enabled = false; line.Visible = false
        end
    end)
    active_esp[p] = {H = highlight, L = line, C = connection}
end

local function ClearESP(p)
    if active_esp[p] then
        active_esp[p].H:Destroy()
        active_esp[p].L:Remove()
        active_esp[p].C:Disconnect()
        active_esp[p] = nil
    end
end

-- [[ ⚔️ MOTOR DE COMBATE SUPREME ]]
local function InitCombat()
    RunService.RenderStepped:Connect(function()
        -- Infinite Jump con Física Mejorada
        if Config.Toggles.InfJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            if not Config.Values.JumpDebounce and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                Config.Values.JumpDebounce = true
                lp.Character.Humanoid:ChangeState(3)
                lp.Character.HumanoidRootPart.Velocity = Vector3.new(0, 52, 0)
                task.wait(0.18); Config.Values.JumpDebounce = false
            end
        end

        -- Aimbot & Hitbox Logic
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local role = GetPlayerRole(p)
                
                if role == "Murd" then
                    if Config.Toggles.Aimbot then
                        local goal = CFrame.new(camera.CFrame.Position, hrp.Position)
                        camera.CFrame = camera.CFrame:Lerp(goal, Config.Values.Smooth)
                    end
                    if Config.Toggles.Hitbox then
                        hrp.Size = Vector3.new(Config.Values.HitboxSize, Config.Values.HitboxSize, Config.Values.HitboxSize)
                        hrp.Transparency = 0.7; hrp.CanCollide = false
                    else
                        hrp.Size = Vector3.new(2, 2, 1); hrp.Transparency = 1
                    end
                elseif role == "Sher" then
                    Config.Values.LastSheriffPos = hrp.CFrame
                end
            end
        end

        -- Atributos de Personaje
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = Config.Toggles.WalkSpeed and Config.Values.Speed or 16
            if Config.Toggles.Noclip then lp.Character.Humanoid:ChangeState(11) end
        end
        camera.FieldOfView = Config.Values.FOV
    end)
end

-- [[ 📦 SISTEMA DE UTILIDADES (AUTO-FARM & ANTI-LAG) ]]
spawn(function()
    while task.wait(0.5) do
        -- Auto-Farm Inteligente
        if Config.Toggles.AutoFarm then
            for _, v in pairs(workspace:GetDescendants()) do
                if not Config.Toggles.AutoFarm then break end
                if v.Name == "Coin_Sub" and v:IsA("BasePart") then
                    lp.Character.HumanoidRootPart.CFrame = v.CFrame
                    task.wait(0.28) -- Tiempo de seguridad para evitar kick
                end
            end
        end
        
        -- Fullbright
        if Config.Toggles.FullBright then
            Lighting.Brightness = 2; Lighting.ClockTime = 14
            Lighting.OutdoorAmbient = Color3.new(1,1,1); Lighting.GlobalShadows = false
        end
        
        -- Anti-Lag (Limpieza de basura visual)
        if Config.Toggles.AntiLag then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end
            end
        end
    end
end)

-- [[ 🏙️ UI SUPREME MOVIBLE (FLOURITE STYLE) ]]
local function CreateUI()
    local sg = Instance.new("ScreenGui", CoreGui)
    sg.Name = "Flourite_Ultimate_V3"

    -- BOTÓN WIDGET FLOTANTE
    local Widget = Instance.new("ImageButton", sg)
    Widget.Size = UDim2.new(0, 55, 0, 55); Widget.Position = UDim2.new(0, 20, 0.4, 0)
    Widget.BackgroundColor3 = Config.Colors.Bg; Widget.Image = "rbxassetid://6031068433"
    Widget.Visible = false; Instance.new("UICorner", Widget).CornerRadius = UDim.new(1, 0)
    local wStroke = Instance.new("UIStroke", Widget); wStroke.Color = Config.Colors.Accent; wStroke.Thickness = 2.5
    MakeDraggable(Widget)

    -- FRAME PRINCIPAL
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 460, 0, 320); main.Position = UDim2.new(0.5, -230, 0.5, -160)
    main.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", main)
    local mStroke = Instance.new("UIStroke", main); mStroke.Color = Config.Colors.Accent; mStroke.Thickness = 2
    MakeDraggable(main)

    -- CABECERA Y CIERRE
    local header = Instance.new("Frame", main)
    header.Size = UDim2.new(1, 0, 0, 40); header.BackgroundTransparency = 1
    
    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(0.6, 0, 1, 0); title.Position = UDim2.new(0.05, 0, 0, 0)
    title.Text = "FLOURITE SOFTWORKS V3.8"; title.TextColor3 = Config.Colors.Accent; title.Font = Enum.Font.GothamBold; title.TextSize = 16; title.TextXAlignment = 0; title.BackgroundTransparency = 1
    
    local close = Instance.new("TextButton", header)
    close.Size = UDim2.new(0, 35, 0, 35); close.Position = UDim2.new(1, -40, 0, 2)
    close.Text = "X"; close.BackgroundColor3 = Color3.fromRGB(220, 40, 40); close.TextColor3 = Color3.new(1,1,1); close.Font = Enum.Font.GothamBold; Instance.new("UICorner", close)

    close.MouseButton1Click:Connect(function() main.Visible = false; Widget.Visible = true end)
    Widget.MouseButton1Click:Connect(function() main.Visible = true; Widget.Visible = false end)

    -- NAVEGACIÓN
    local nav = Instance.new("Frame", main); nav.Size = UDim2.new(0, 130, 1, -45); nav.Position = UDim2.new(0, 10, 0, 40); nav.BackgroundTransparency = 0.95
    local layout = Instance.new("UIListLayout", nav); layout.Padding = UDim.new(0, 5)
    
    local container = Instance.new("Frame", main); container.Size = UDim2.new(1, -155, 1, -55); container.Position = UDim2.new(0, 145, 0, 45); container.BackgroundTransparency = 1

    local function Tab(name)
        local p = Instance.new("ScrollingFrame", container)
        p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0,0,1.5,0)
        Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
        
        local b = Instance.new("TextButton", nav)
        b.Size = UDim2.new(1, 0, 0, 40); b.Text = name; b.BackgroundColor3 = Color3.new(0,0,0); b.BackgroundTransparency = 0.8; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold
        b.MouseButton1Click:Connect(function()
            for _, v in pairs(container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            p.Visible = true
        end)
        return p
    end

    local mainT = Tab("MAIN"); mainT.Visible = true
    local espT = Tab("VISUALS"); local combT = Tab("COMBAT"); local miscT = Tab("UTIL")

    local function Toggle(par, text, key)
        local btn = Instance.new("TextButton", par)
        btn.Size = UDim2.new(0.95, 0, 0, 40); btn.Text = text .. " [OFF]"; btn.BackgroundColor3 = Color3.fromRGB(30, 30, 55); btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.Gotham; Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function()
            Config.Toggles[key] = not Config.Toggles[key]
            btn.Text = text .. (Config.Toggles[key] and " [ON]" or " [OFF]")
            btn.BackgroundColor3 = Config.Toggles[key] and Config.Colors.Accent or Color3.fromRGB(30, 30, 55)
            btn.TextColor3 = Config.Toggles[key] and Color3.new(0,0,0) or Color3.new(1,1,1)
        end)
    end

    -- PESTAÑA MAIN
    Toggle(mainT, "SPEED HACK", "WalkSpeed")
    Toggle(mainT, "NOCLIP (ATRAVESAR)", "Noclip")
    Toggle(mainT, "SALTO INFINITO", "InfJump")
    
    -- PESTAÑA VISUALS
    Toggle(espT, "ESP MURDERER", "ESP_Murd")
    Toggle(espT, "ESP SHERIFF", "ESP_Sheriff")
    Toggle(espT, "ESP INNOCENTS", "ESP_Inno")
    Toggle(espT, "TRACERS (LINEAS)", "Traces")
    
    local fovBtn = Instance.new("TextButton", espT)
    fovBtn.Size = UDim2.new(0.95, 0, 0, 40); fovBtn.Text = "MAX FOV: 120"; fovBtn.BackgroundColor3 = Color3.fromRGB(50,50,80); fovBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", fovBtn)
    fovBtn.MouseButton1Click:Connect(function() Config.Values.FOV = (Config.Values.FOV == 70 and 120 or 70); fovBtn.Text = "FOV: "..Config.Values.FOV end)

    -- PESTAÑA COMBAT
    Toggle(combT, "AIMBOT MURDERER", "Aimbot")
    Toggle(combT, "HITBOX EXPANDER", "Hitbox")
    
    local tpGun = Instance.new("TextButton", combT)
    tpGun.Size = UDim2.new(0.95, 0, 0, 40); tpGun.Text = "TP TO SHERIFF/GUN"; tpGun.BackgroundColor3 = Color3.fromRGB(100, 30, 200); tpGun.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", tpGun)
    tpGun.MouseButton1Click:Connect(function()
        if Config.Values.LastSheriffPos then lp.Character.HumanoidRootPart.CFrame = Config.Values.LastSheriffPos else Notify("ERROR", "No se detectó al Sheriff aún.", Color3.new(1,0,0)) end
    end)

    -- PESTAÑA UTIL
    Toggle(miscT, "AUTO COIN FARM", "AutoFarm")
    Toggle(miscT, "FULLBRIGHT", "FullBright")
    Toggle(miscT, "ANTI-LAG MODE", "AntiLag")

    Notify("BIENVENIDO", "CHRISS SOFTWARE SUPREME CARGADO.", Config.Colors.Accent)
end

-- [[ 🔑 SISTEMA DE VERIFICACIÓN DE LICENCIA ]]
local function VerifyKey()
    local kg = Instance.new("ScreenGui", CoreGui)
    local f = Instance.new("Frame", kg)
    f.Size = UDim2.new(0, 360, 0, 260); f.Position = UDim2.new(0.5, -180, 0.5, -130); f.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = Config.Colors.Accent
    
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 0, 50); t.Text = "INGRESE SU LICENCIA"; t.TextColor3 = Config.Colors.Accent; t.Font = Enum.Font.GothamBold; t.BackgroundTransparency = 1
    
    local box = Instance.new("TextBox", f)
    box.Size = UDim2.new(0.8, 0, 0, 45); box.Position = UDim2.new(0.1, 0, 0.4, 0); box.PlaceholderText = "CHKEY-XXXXX-XXXXX"; box.TextColor3 = Color3.new(1,1,1); box.BackgroundColor3 = Color3.fromRGB(20, 20, 40); Instance.new("UICorner", box)
    
    local verify = Instance.new("TextButton", f)
    verify.Size = UDim2.new(0.8, 0, 0, 45); verify.Position = UDim2.new(0.1, 0, 0.7, 0); verify.Text = "VERIFICAR"; verify.BackgroundColor3 = Config.Colors.Accent; verify.TextColor3 = Color3.new(0,0,0); verify.Font = Enum.Font.GothamBold; Instance.new("UICorner", verify)
    
    verify.MouseButton1Click:Connect(function()
        if table.find(CH_KEYS, box.Text) then
            Notify("ÉXITO", "Licencia válida. Iniciando...", Config.Colors.Inno)
            kg:Destroy(); CreateUI(); InitCombat()
            for _, p in pairs(Players:GetPlayers()) do if p ~= lp then CreateESP(p) end end
            Players.PlayerAdded:Connect(function(p) CreateESP(p) end)
            Players.PlayerRemoving:Connect(function(p) ClearESP(p) end)
        else
            box.Text = ""; box.PlaceholderText = "LLAVE INCORRECTA"
        end
    end)
end



VerifyKey()
-- [[ FIN DEL SCRIPT EDITION ]]
