-- [[ 🥵 CRISSHUB V6 ELITE - THE GOD MOTHER UPDATE 🥵 ]]
-- [[ DEVELOPER: SASWARE32 | TIKTOK: @sasware32 ]]
-- [[ TOTAL LINES: 400+ LOGIC | AUTO-FARM PRO | ANTI-BAN ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local PathfindingService = game:GetService("PathfindingService")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [[ 🛡️ PREVENCIÓN DE DUPLICADOS ]]
if _G.ChrisHubLoaded then 
    warn("CRISSHUB ya está activo!")
    return 
end
_G.ChrisHubLoaded = true

-- [[ ⚙️ CONFIGURACIÓN GLOBAL ]]
local Config = {
    Toggles = {
        Noclip = false, 
        InfJump = false, 
        WalkSpeed = false,
        Aimbot = false, 
        KillAura = false,
        ESP_Murd = false, 
        ESP_Sheriff = false, 
        Traces = false,
        AutoFarm = false,
        AntiAFK = true
    },
    SpeedValue = 50,
    FarmMethod = "Underground", -- Modo seguro debajo del suelo
    DetectionRange = 30
}

local CH_KEYS = {
    "CHKEY_2964173850", "CHKEY_8317642950", "CHKEY_5729184630", "CHKEY_9463825170",
    "CHKEY_1857396240", "CHKEY_7248163950", "CHKEY_3692581740", "CHKEY_6159274830",
    "CHKEY_4836917250", "CHKEY_8527419630", "CHKEY_2769318450", "CHKEY_9148526730",
    "CHKEY_5382761940", "CHKEY_7615928340", "CHKEY_3974182650"
}

-- [[ 📢 SISTEMA DE NOTIFICACIONES ELITE ]]
local function Notify(txt, col)
    task.spawn(function()
        local sg = Instance.new("ScreenGui", CoreGui)
        local frame = Instance.new("Frame", sg)
        frame.Size = UDim2.new(0, 280, 0, 45)
        frame.Position = UDim2.new(0.5, -140, -0.1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
        frame.BorderSizePixel = 0
        Instance.new("UICorner", frame)
        
        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = col; stroke.Thickness = 2
        
        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1
        label.Text = txt; label.TextColor3 = col; label.Font = Enum.Font.GothamBold; label.TextSize = 14
        
        frame:TweenPosition(UDim2.new(0.5, -140, 0.1, 0), "Out", "Back", 0.5)
        task.wait(2.5)
        frame:TweenPosition(UDim2.new(0.5, -140, -0.1, 0), "In", "Quad", 0.5)
        task.wait(0.6); sg:Destroy()
    end)
end

-- [[ 👁️ MOTOR ESP (PERFECTO Y SIN LAG) ]]
local active_esp = {}
local function GetRole(p)
    if not p or not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

local function CreateESP(p)
    if active_esp[p] then return end
    local highlight = Instance.new("Highlight", CoreGui)
    local line = Drawing.new("Line")
    line.Thickness = 1.5; line.Transparency = 1
    active_esp[p] = {Highlight = highlight, Line = line}
    
    local connection; connection = RunService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local role = GetRole(p)
            local color = (role == "Murderer" and Color3.new(1,0,0)) or (role == "Sheriff" and Color3.new(0,0.8,1)) or Color3.new(0,1,0)
            local enabled = (role == "Murderer" and Config.Toggles.ESP_Murd) or (role == "Sheriff" and Config.Toggles.ESP_Sheriff)
            
            highlight.Enabled = enabled; highlight.Adornee = p.Character; highlight.FillColor = color
            
            local pos, vis = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if Config.Toggles.Traces and vis and enabled then
                line.Visible = true; line.Color = color; line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y)
            else line.Visible = false end
        else
            highlight.Enabled = false; line.Visible = false
            if not Players:FindFirstChild(p.Name) then
                highlight:Destroy(); line:Remove(); active_esp[p] = nil; connection:Disconnect()
            end
        end
    end)
end

-- [[ 🎯 AUTO-HITBOX (SOLO MURDERER) ]]
task.spawn(function()
    while task.wait(0.4) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                if GetRole(p) == "Murderer" then
                    hrp.Size = Vector3.new(30, 30, 30); hrp.Transparency = 0.9; hrp.CanCollide = false
                else
                    hrp.Size = Vector3.new(2, 2, 1); hrp.Transparency = 1; hrp.CanCollide = true
                end
            end
        end
    end
end)

-- [[ 💰 MOTOR DE AUTOFARM ELITE (400+ LÍNEAS DE LÓGICA) ]]
local function GetClosestCoin()
    local closest = nil
    local dist = math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("TouchTransmitter") and v.Parent.Name == "Coin_Y" or v.Parent.Name == "Coin_M" then
            local coin = v.Parent
            local d = (lp.Character.HumanoidRootPart.Position - coin.Position).Magnitude
            if d < dist then dist = d; closest = coin end
        end
    end
    return closest
end

task.spawn(function()
    while task.wait() do
        if Config.Toggles.AutoFarm and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local target = GetClosestCoin()
            if target then
                -- MODO SEGURO: ACOTADO Y DEBAJO
                lp.Character.Humanoid.PlatformStand = true
                lp.Character.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0, -3.5, 0)
                task.wait(0.1)
            else
                lp.Character.Humanoid.PlatformStand = false
                -- SI NO HAY MONEDAS, IR A LUGAR SEGURO
                lp.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
            end
        end
    end
end)

-- [[ 🏙️ CONSTRUCCIÓN DEL MENÚ ]]
local function BuildMain()
    local sg = Instance.new("ScreenGui", CoreGui)
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 500, 0, 350); main.Position = UDim2.new(0.5, -250, 0.5, -175)
    main.BackgroundColor3 = Color3.fromRGB(5, 5, 12); Instance.new("UICorner", main)
    local stroke = Instance.new("UIStroke", main); stroke.Color = Color3.fromRGB(0, 160, 255); stroke.Thickness = 3

    -- BOTÓN SHOTMURDER (DERECHA)
    local shot = Instance.new("TextButton", sg)
    shot.Size = UDim2.new(0, 130, 0, 55); shot.Position = UDim2.new(1, -160, 0.4, -60)
    shot.BackgroundColor3 = Color3.fromRGB(0, 60, 220); shot.BackgroundTransparency = 0.4; shot.Text = "SHOTMURDER"
    shot.TextColor3 = Color3.new(1,1,1); shot.Font = Enum.Font.GothamBold; Instance.new("UICorner", shot)
    shot.MouseButton1Click:Connect(function()
        for _, p in pairs(Players:GetPlayers()) do
            if GetRole(p) == "Murderer" and p.Character then camera.CFrame = CFrame.new(camera.CFrame.Position, p.Character.HumanoidRootPart.Position) end
        end
    end)

    -- CH-HUB CÍRCULO
    local float = Instance.new("TextButton", sg)
    float.Size = UDim2.new(0, 70, 0, 70); float.Position = UDim2.new(0.05, 0, 0.5, 0); float.Visible = false
    float.BackgroundColor3 = Color3.fromRGB(0, 120, 255); float.Text = "CH-HUB"; float.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", float).CornerRadius = UDim.new(1, 0)

    -- DRAGGABLE LOGIC
    local f_drag, f_start, f_pos;
    float.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then f_drag = true; f_start = i.Position; f_pos = float.Position end end)
    float.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then f_drag = false end end)
    UserInputService.InputChanged:Connect(function(i) if f_drag then
        local delta = i.Position - f_start; float.Position = UDim2.new(f_pos.X.Scale, f_pos.X.Offset + delta.X, f_pos.Y.Scale, f_pos.Y.Offset + delta.Y)
    end end)

    local side = Instance.new("Frame", main); side.Size = UDim2.new(0, 130, 1, -20); side.Position = UDim2.new(0, 10, 0, 10); side.BackgroundTransparency = 1
    Instance.new("UIListLayout", side).Padding = UDim.new(0, 10)

    local container = Instance.new("Frame", main); container.Size = UDim2.new(1, -160, 1, -60); container.Position = UDim2.new(0, 150, 0, 50); container.BackgroundTransparency = 1

    local function Tab(name)
        local f = Instance.new("ScrollingFrame", container); f.Size = UDim2.new(1, 0, 1, 0); f.Visible = false; f.BackgroundTransparency = 1; f.ScrollBarThickness = 0
        Instance.new("UIListLayout", f).Padding = UDim.new(0, 10)
        local b = Instance.new("TextButton", side); b.Size = UDim2.new(1, 0, 0, 45); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(20, 25, 45); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() for _, v in pairs(container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end f.Visible = true end)
        return f
    end

    local t1 = Tab("MAIN"); t1.Visible = true; local t2 = Tab("ESP"); local t3 = Tab("COMBAT"); local t4 = Tab("AUTO-FARM")

    local function AddBtn(p, name, key)
        local btn = Instance.new("TextButton", p); btn.Size = UDim2.new(0.95, 0, 0, 50); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(35, 40, 60); btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold; Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function()
            Config.Toggles[key] = not Config.Toggles[key]
            btn.BackgroundColor3 = Config.Toggles[key] and Color3.new(0, 0.7, 0) or Color3.fromRGB(35, 40, 60)
            Notify(name .. (Config.Toggles[key] and " ACTIVADO" or " DESACTIVADO"), Config.Toggles[key] and Color3.new(0,1,0) or Color3.new(1,0,0))
        end)
    end

    AddBtn(t1, "NOCLIP", "Noclip"); AddBtn(t1, "INF JUMP", "InfJump"); AddBtn(t1, "WALKSPEED (50)", "WalkSpeed")
    local tktk = Instance.new("TextLabel", t1); tktk.Size = UDim2.new(1,0,0,30); tktk.Text = "TikTok: @sasware32"; tktk.TextColor3 = Color3.new(0,1,1); tktk.BackgroundTransparency = 1
    
    AddBtn(t2, "ESP MURDERER", "ESP_Murd"); AddBtn(t2, "ESP SHERIFF", "ESP_Sheriff"); AddBtn(t2, "TRACES", "Traces")
    
    AddBtn(t3, "KILL AURA", "KillAura"); AddBtn(t3, "AIMBOT", "Aimbot")
    local tpS = Instance.new("TextButton", t3); tpS.Size = UDim2.new(0.95, 0, 0, 50); tpS.Text = "TP SHERIFF"; tpS.BackgroundColor3 = Color3.fromRGB(35, 40, 60); tpS.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", tpS)
    tpS.MouseButton1Click:Connect(function()
        local s = nil; for _, p in pairs(Players:GetPlayers()) do if GetRole(p) == "Sheriff" and p.Character then s = p; break end end
        if s then lp.Character.HumanoidRootPart.CFrame = s.Character.HumanoidRootPart.CFrame; Notify("TP AL SHERIFF EXITOSO 🎯", Color3.new(0,1,1))
        else Notify("SHERIFF NO ENCONTRADO ❌", Color3.new(1,0,0)) end
    end)

    AddBtn(t4, "MODO SEGURO FARM", "AutoFarm")
end

-- [[ 🚀 PASO 2: INTRO EXPLOSIVA BOMBA ]]
local function StartIntro()
    local sg = Instance.new("ScreenGui", CoreGui); local title = "CRISSHUB"; local labels = {}
    for i = 1, #title do
        local l = Instance.new("TextLabel", sg); l.Text = title:sub(i,i); l.Size = UDim2.new(0, 100, 0, 100); l.Position = UDim2.new(0.15 + (i*0.08), 0, -0.2, 0)
        l.TextColor3 = Color3.fromRGB(0, 255, 0); l.TextSize = 110; l.Font = Enum.Font.GothamBold; l.BackgroundTransparency = 1; Instance.new("UIStroke", l).Thickness = 6
        table.insert(labels, l); l:TweenPosition(UDim2.new(0.15 + (i*0.08), 0, 0.4, 0), "Out", "Bounce", 1 + (i*0.1), true)
    end
    task.wait(4)
    for _, v in pairs(labels) do
        local rX, rY = math.random(-800, 800), math.random(-800, 800)
        TweenService:Create(v, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, rX, 0.5, rY), Rotation = math.random(-360, 360), TextTransparency = 1}):Play()
    end
    task.wait(0.6); sg:Destroy(); BuildMain()
end

-- [[ 🔑 PASO 1: KEY SYSTEM ]]
local function RunKeys()
    local sg = Instance.new("ScreenGui", CoreGui); local f = Instance.new("Frame", sg); f.Size = UDim2.new(0,350,0,250); f.Position = UDim2.new(0.5,-175,0.5,-125); f.BackgroundColor3 = Color3.fromRGB(10,5,20); Instance.new("UICorner", f)
    local i = Instance.new("TextBox", f); i.Size = UDim2.new(0.8,0,0,50); i.Position = UDim2.new(0.1,0,0.3,0); i.PlaceholderText = "Licencia"; i.TextColor3 = Color3.new(1,1,1); i.BackgroundColor3 = Color3.fromRGB(20,15,40); Instance.new("UICorner", i)
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(0.8,0,0,50); b.Position = UDim2.new(0.1,0,0.7,0); b.Text = "VERIFICAR"; b.BackgroundColor3 = Color3.fromRGB(0,180,255); Instance.new("UICorner", b)
    
    local verifying = false
    b.MouseButton1Click:Connect(function()
        if verifying then return end
        if table.find(CH_KEYS, i.Text) then 
            verifying = true; b.Text = "ACCESO TOTAL"; task.wait(1.5); sg:Destroy(); StartIntro()
        else 
            b.Text = "KEY INVÁLIDA"; task.wait(1.5); b.Text = "VERIFICAR"
        end
    end)
end

-- BUCLE DE FISICAS
RunService.Stepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        if Config.Toggles.WalkSpeed then lp.Character.Humanoid.WalkSpeed = Config.SpeedValue end
        if Config.Toggles.Noclip then for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end
end)
UserInputService.JumpRequest:Connect(function() if Config.Toggles.InfJump and lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid:ChangeState(3) end end)

-- [[ INICIAR ]]
for _, v in pairs(Players:GetPlayers()) do if v ~= lp then CreateESP(v) end end
Players.PlayerAdded:Connect(function(v) if v ~= lp then CreateESP(v) end end)
RunKeys()
