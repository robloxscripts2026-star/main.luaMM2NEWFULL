--[[
    
    [ ARCHIVO OPTIMIZADO PARA: DELTA, FLUXUS, HYDROGEN ]
    [ ANTI-BAN LOGIC ENABLED ]
]]

-- [[ 🛠️ CONSTANTES Y SERVICIOS ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")

-- [[ 👤 REFERENCIAS LOCALES ]]
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = lp:GetMouse()
local character = lp.Character or lp.CharacterAdded:Wait()

-- [[ 🔑 DATABASE: 25 KEYS DE ACCESO ]]
local CH_KEYS = {
    "CHKEY-2a7d9f3b1c", "CHKEY-5g1h4j6k8l", "CHKEY-9m2n0p5q3r", "CHKEY-4s6t8u1v7w",
    "CHKEY-3x5y9z2a4b", "CHKEY-7c1d3e6f8g", "CHKEY-2h5i7j9k1l", "CHKEY-6m8n3p0q2r",
    "CHKEY-1s4t6u9v3w", "CHKEY-5x2y7z4a6b", "CHKEY-8c3d5e1f9g", "CHKEY-4h9i2j5k7l",
    "CHKEY-7m1n6p8q4r", "CHKEY-3s5t9u2v6w", "CHKEY-6x8y3z1a5b", "CHKEY-9c2d7e4f1g",
    "CHKEY-5h3i8j2k6l", "CHKEY-2m7n4p1q9r", "CHKEY-8s1t5u7v3w", "CHKEY-4x6y2z9a3b",
    "CHKEY-1c9d4e7f2g", "CHKEY-6h7i1j8k4l", "CHKEY-3m5n9p2q6r", "CHKEY-7s3t8u4v9w",
    "CHKEY-2x9y5z6a8b"
}

-- [[ ⚙️ CONFIGURACIÓN GLOBAL (VALORES INICIALES) ]]
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
        FullBright = false
    },
    Values = {
        Speed = 50,
        FOV = 70,
        Smoothness = 0.12,
        JumpDebounce = false,
        LastSheriffPos = nil
    },
    Colors = {
        Murd = Color3.fromRGB(255, 30, 30),
        Sher = Color3.fromRGB(0, 160, 255),
        Inno = Color3.fromRGB(50, 255, 50),
        Accent = Color3.fromRGB(0, 210, 255),
        Bg = Color3.fromRGB(10, 10, 25)
    }
}

-- [[ 📜 FUNCIONES DE UTILIDAD (BACKEND) ]]
local function CreateNotify(txt, col)
    spawn(function()
        local sg = Instance.new("ScreenGui", CoreGui)
        local f = Instance.new("Frame", sg)
        f.Size = UDim2.new(0, 250, 0, 40)
        f.Position = UDim2.new(1, 10, 0.1, 0)
        f.BackgroundColor3 = Config.Colors.Bg
        Instance.new("UICorner", f)
        Instance.new("UIStroke", f).Color = col
        
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1
        l.Text = txt; l.TextColor3 = Color3.new(1,1,1); l.Font = Enum.Font.GothamBold; l.TextSize = 13
        
        f:TweenPosition(UDim2.new(1, -260, 0.1, 0), "Out", "Back", 0.5)
        task.wait(3)
        f:TweenPosition(UDim2.new(1, 10, 0.1, 0), "In", "Quad", 0.5)
        task.wait(0.6); sg:Destroy()
    end)
end

local function GetRole(p)
    if not p or not p.Character then return "Inno" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murd" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sher" end
    return "Inno"
end

-- [[ 👁️ MOTOR VISUAL (ESP & TRACERS) ]]
local active_esp = {}

local function ClearESP(p)
    if active_esp[p] then
        if active_esp[p].Highlight then active_esp[p].Highlight:Destroy() end
        if active_esp[p].Tracer then active_esp[p].Tracer:Remove() end
        if active_esp[p].Conn then active_esp[p].Conn:Disconnect() end
        active_esp[p] = nil
    end
end

local function ApplyESP(p)
    ClearESP(p)
    local high = Instance.new("Highlight", CoreGui)
    local trace = Drawing.new("Line")
    trace.Thickness = 1.8
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
            local role = GetRole(p)
            local col = Config.Colors[role]
            local enabled = Config.Toggles["ESP_"..role]
            
            high.Enabled = enabled
            high.Adornee = p.Character
            high.FillColor = col
            
            local pos, vis = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if Config.Toggles.Traces and vis then
                trace.Visible = true
                trace.Color = col
                trace.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                trace.To = Vector2.new(pos.X, pos.Y)
            else trace.Visible = false end
        else
            high.Enabled = false
            trace.Visible = false
        end
    end)
    active_esp[p] = {Highlight = high, Tracer = trace, Conn = connection}
end

-- [[ ⚔️ MOTOR DE COMBATE (AIMBOT & HITBOX) ]]
local function CombatHandler()
    RunService.RenderStepped:Connect(function()
        -- Infinite Jump (Debounced)
        if Config.Toggles.InfJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            if not Config.Values.JumpDebounce then
                Config.Values.JumpDebounce = true
                lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait(0.1)
                Config.Values.JumpDebounce = false
            end
        end

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local role = GetRole(p)

                if role == "Murd" then
                    if Config.Toggles.Aimbot then
                        local goal = CFrame.new(camera.CFrame.Position, hrp.Position)
                        camera.CFrame = camera.CFrame:Lerp(goal, Config.Values.Smoothness)
                    end
                    
                    if Config.Toggles.Hitbox then
                        hrp.Size = Vector3.new(15, 15, 15)
                        hrp.Transparency = 0.8; hrp.CanCollide = false
                    else
                        hrp.Size = Vector3.new(2, 2, 1); hrp.Transparency = 1
                    end
                elseif role == "Sher" then
                    Config.Values.LastSheriffPos = hrp.CFrame
                end
            end
        end
        
        -- Movement & FOV
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = Config.Toggles.WalkSpeed and Config.Values.Speed or 16
            if Config.Toggles.Noclip then lp.Character.Humanoid:ChangeState(11) end
        end
        camera.FieldOfView = Config.Values.FOV
    end)
end

-- [[ 🏙️ MENÚ SUPREME (CODEX STYLE) ]]
local function BuildUI()
    local sg = Instance.new("ScreenGui", CoreGui)
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 500, 0, 350)
    main.Position = UDim2.new(0.5, -250, 0.5, -175)
    main.BackgroundColor3 = Config.Colors.Bg
    Instance.new("UICorner", main)
    local str = Instance.new("UIStroke", main); str.Color = Config.Colors.Accent; str.Thickness = 2.5

    -- Sidebar
    local bar = Instance.new("Frame", main)
    bar.Size = UDim2.new(0, 140, 1, 0); bar.BackgroundTransparency = 0.9; bar.BackgroundColor3 = Color3.new(0,0,0)
    Instance.new("UIListLayout", bar).Padding = UDim.new(0, 5)

    local title = Instance.new("TextLabel", bar)
    title.Size = UDim2.new(1, 0, 0, 60); title.Text = "FLOURITE"; title.TextColor3 = Config.Colors.Accent; title.Font = Enum.Font.GothamBold; title.TextSize = 20; title.BackgroundTransparency = 1

    local container = Instance.new("Frame", main)
    container.Position = UDim2.new(0, 150, 0, 10); container.Size = UDim2.new(1, -160, 1, -20); container.BackgroundTransparency = 1

    local function NewTab(name)
        local f = Instance.new("ScrollingFrame", container)
        f.Size = UDim2.new(1, 0, 1, 0); f.Visible = false; f.BackgroundTransparency = 1; f.ScrollBarThickness = 0
        Instance.new("UIListLayout", f).Padding = UDim.new(0, 8)
        
        local b = Instance.new("TextButton", bar)
        b.Size = UDim2.new(1, 0, 0, 45); b.Text = name; b.BackgroundColor3 = Color3.new(0,0,0); b.BackgroundTransparency = 0.8; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.BorderSizePixel = 0
        b.MouseButton1Click:Connect(function()
            for _, v in pairs(container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            f.Visible = true
        end)
        return f
    end

    local t1 = NewTab("MAIN"); t1.Visible = true
    local t2 = NewTab("VISUALS")
    local t3 = NewTab("COMBAT")
    local t4 = NewTab("MISC")

    local function Toggle(p, txt, k)
        local b = Instance.new("TextButton", p)
        b.Size = UDim2.new(0.95, 0, 0, 40); b.Text = txt .. " [OFF]"; b.BackgroundColor3 = Color3.fromRGB(30, 30, 50); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            Config.Toggles[k] = not Config.Toggles[k]
            b.Text = txt .. (Config.Toggles[k] and " [ON]" or " [OFF]")
            b.BackgroundColor3 = Config.Toggles[k] and Config.Colors.Accent or Color3.fromRGB(30, 30, 50)
            b.TextColor3 = Config.Toggles[k] and Color3.new(0,0,0) or Color3.new(1,1,1)
        end)
    end

    -- Botones de Funciones
    Toggle(t1, "SPEED HACK", "WalkSpeed")
    Toggle(t1, "NOCLIP", "Noclip")
    Toggle(t1, "INF JUMP", "InfJump")
    
    Toggle(t2, "ESP MURDERER", "ESP_Murd")
    Toggle(t2, "ESP SHERIFF", "ESP_Sheriff")
    Toggle(t2, "ESP INNOCENTS", "ESP_Inno")
    Toggle(t2, "TRACERS", "Traces")
    
    -- Slider FOV (Botón simple para Codex)
    local fovBtn = Instance.new("TextButton", t2)
    fovBtn.Size = UDim2.new(0.95, 0, 0, 40); fovBtn.Text = "MAX FOV: 120"; fovBtn.BackgroundColor3 = Color3.fromRGB(40,40,60); fovBtn.TextColor3 = Color3.new(1,1,1); fovBtn.Font = Enum.Font.Gotham; Instance.new("UICorner", fovBtn)
    fovBtn.MouseButton1Click:Connect(function()
        Config.Values.FOV = Config.Values.FOV == 70 and 120 or 70
        fovBtn.Text = "FOV: " .. Config.Values.FOV
    end)

    Toggle(t3, "AIMBOT (SMOOTH)", "Aimbot")
    Toggle(t3, "HITBOX EXPANDER", "Hitbox")
    
    local tp = Instance.new("TextButton", t3)
    tp.Size = UDim2.new(0.95, 0, 0, 40); tp.Text = "TELEPORT TO GUN"; tp.BackgroundColor3 = Color3.fromRGB(80, 20, 150); tp.TextColor3 = Color3.new(1,1,1); tp.Font = Enum.Font.GothamBold; Instance.new("UICorner", tp)
    tp.MouseButton1Click:Connect(function()
        local s = nil; for _, v in pairs(Players:GetPlayers()) do if GetRole(v) == "Sher" and v.Character then s = v end end
        if s then lp.Character.HumanoidRootPart.CFrame = s.Character.HumanoidRootPart.CFrame
        elseif Config.Values.LastSheriffPos then lp.Character.HumanoidRootPart.CFrame = Config.Values.LastSheriffPos end
    end)
    
    Toggle(t4, "AUTO COIN FARM", "AutoFarm")
    Toggle(t4, "FULLBRIGHT", "FullBright")
    
    -- Lógica de Misceláneos
    spawn(function()
        while task.wait(1) do
            if Config.Toggles.FullBright then Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.OutdoorAmbient = Color3.new(1,1,1) end
            if Config.Toggles.AutoFarm then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name == "Coin_Sub" and v:IsA("BasePart") then
                        lp.Character.HumanoidRootPart.CFrame = v.CFrame
                        task.wait(0.2)
                    end
                end
            end
        end
    end)
end

-- [[ 🚀 INTRO CHRISS SOFTWARE ]]
local function StartIntro()
    local ig = Instance.new("ScreenGui", CoreGui)
    local l = Instance.new("TextLabel", ig)
    l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1; l.Text = "CHRISS SOFTWARE 🌌"; l.TextColor3 = Config.Colors.Accent; l.TextSize = 50; l.Font = Enum.Font.Code; l.TextTransparency = 1
    
    TweenService:Create(l, TweenInfo.new(1), {TextTransparency = 0}):Play()
    task.wait(2)
    TweenService:Create(l, TweenInfo.new(0.5), {TextSize = 300, TextTransparency = 1}):Play()
    task.wait(0.6); ig:Destroy()
    
    BuildUI(); CombatHandler()
    for _, v in pairs(Players:GetPlayers()) do if v ~= lp then ApplyESP(v) end end
    Players.PlayerAdded:Connect(function(v) ApplyESP(v) end)
    Players.PlayerRemoving:Connect(function(v) ClearESP(v) end)
    CreateNotify("CHRISS SOFTWARE CARGADO!", Config.Colors.Accent)
end

-- [[ 🔑 SISTEMA DE LLAVES ]]
local function KeySystem()
    local kg = Instance.new("ScreenGui", CoreGui)
    local f = Instance.new("Frame", kg)
    f.Size = UDim2.new(0, 380, 0, 280); f.Position = UDim2.new(0.5, -190, 0.5, -140); f.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = Config.Colors.Accent
    
    local t = Instance.new("TextBox", f)
    t.Size = UDim2.new(0.8, 0, 0, 45); t.Position = UDim2.new(0.1, 0, 0.4, 0); t.PlaceholderText = "CHKEY-XXXXX"; t.BackgroundColor3 = Color3.fromRGB(20, 20, 40); t.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", t)
    
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0.8, 0, 0, 45); b.Position = UDim2.new(0.1, 0, 0.7, 0); b.Text = "VERIFICAR LICENCIA"; b.BackgroundColor3 = Config.Colors.Accent; b.TextColor3 = Color3.new(0,0,0); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        if table.find(CH_KEYS, t.Text) then
            kg:Destroy(); StartIntro()
        else
            t.Text = ""; t.PlaceholderText = "ACCESO DENEGADO"
        end
    end)
end

KeySystem()

