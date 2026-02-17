-- [[ 🟢 CHRISSHUB V2 SUPREME - FULL UNABRIDGED VERSION 🟢 ]]
-- [[ NO LIMITS - FULL CODE - ALL FEATURES INCLUDED ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [[ 🔑 BASE DE DATOS COMPLETA: 15 KEYS ]]
local CH_KEYS = {
    "CHKEY_2964173850", "CHKEY_8317642950", "CHKEY_5729184630", "CHKEY_9463825170",
    "CHKEY_1857396240", "CHKEY_7248163950", "CHKEY_3692581740", "CHKEY_6159274830",
    "CHKEY_4836917250", "CHKEY_8527419630", "CHKEY_2769318450", "CHKEY_9148526730",
    "CHKEY_5382761940", "CHKEY_7615928340", "CHKEY_3974182650"
}

local Config = {
    Toggles = {
        Noclip = false, InfJump = false, WalkSpeed = false,
        Aimbot = false, KillAura = false,
        ESP_Murd = false, ESP_Sheriff = false, ESP_Inno = false, Traces = false
    },
    SpeedValue = 50
}

-- [[ 📢 SISTEMA DE NOTIFICACIONES PROFESIONAL ]]
local function SendNotify(txt, col)
    spawn(function()
        local sg = Instance.new("ScreenGui", CoreGui)
        local frame = Instance.new("Frame", sg)
        frame.Size = UDim2.new(0, 250, 0, 55)
        frame.Position = UDim2.new(1, 10, 0.15, 0)
        frame.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
        frame.BorderSizePixel = 0
        Instance.new("UICorner", frame)
        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = col
        stroke.Thickness = 2
        
        local l = Instance.new("TextLabel", frame)
        l.Size = UDim2.new(1, 0, 1, 0)
        l.Text = txt
        l.TextColor3 = col
        l.Font = Enum.Font.GothamBold
        l.BackgroundTransparency = 1
        l.TextSize = 14
        
        frame:TweenPosition(UDim2.new(1, -260, 0.15, 0), "Out", "Back", 0.5, true)
        task.wait(3.5)
        frame:TweenPosition(UDim2.new(1, 10, 0.15, 0), "In", "Quad", 0.5, true)
        task.wait(0.6)
        sg:Destroy()
    end)
end

-- [[ 👁️ MOTOR ESP SUPREME CON REINICIO DE RONDA ]]
local active_esp = {}

local function GetPlayerRole(p)
    if not p or not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

local function CleanAllESP()
    for p, data in pairs(active_esp) do
        if data.Highlight then data.Highlight:Destroy() end
        if data.Line then data.Line:Remove() end
    end
    active_esp = {}
end

local function CreateESP(p)
    if active_esp[p] then return end
    
    local highlight = Instance.new("Highlight", CoreGui)
    highlight.OutlineTransparency = 0
    highlight.FillTransparency = 0.5
    
    local line = Drawing.new("Line")
    line.Thickness = 2
    line.Transparency = 1
    
    active_esp[p] = {Highlight = highlight, Line = line}
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local role = GetPlayerRole(p)
            local color = (role == "Murderer" and Color3.new(1,0,0)) or (role == "Sheriff" and Color3.new(0,0.7,1)) or Color3.new(0,1,0)
            local enabled = (role == "Murderer" and Config.Toggles.ESP_Murd) or (role == "Sheriff" and Config.Toggles.ESP_Sheriff) or (role == "Innocent" and Config.Toggles.ESP_Inno)
            
            highlight.Adornee = p.Character
            highlight.Enabled = enabled
            highlight.FillColor = color
            
            local pos, vis = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if Config.Toggles.Traces and vis and enabled then
                line.Visible = true
                line.Color = color
                line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                line.To = Vector2.new(pos.X, pos.Y)
            else
                line.Visible = false
            end
        else
            highlight.Enabled = false
            line.Visible = false
            if not Players:FindFirstChild(p.Name) then
                highlight:Destroy()
                line:Remove()
                active_esp[p] = nil
                connection:Disconnect()
            end
        end
    end)
end

-- Reiniciar ESP al iniciar ronda (detectado por aparición de personajes)
workspace.ChildAdded:Connect(function(child)
    if child:IsA("Model") and Players:GetPlayerFromCharacter(child) then
        task.wait(1)
        CleanAllESP()
        for _, v in pairs(Players:GetPlayers()) do if v ~= lp then CreateESP(v) end end
    end
end)

-- [[ ⚔️ COMBAT & MOVEMENT LOGIC ]]
RunService.Stepped:Connect(function()
    -- Speed & Noclip
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        if Config.Toggles.WalkSpeed then lp.Character.Humanoid.WalkSpeed = Config.SpeedValue end
        if Config.Toggles.Noclip then
            for _, v in pairs(lp.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
    
    -- Aimbot 100% Fijo
    if Config.Toggles.Aimbot then
        for _, p in pairs(Players:GetPlayers()) do
            if GetPlayerRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("Head") then
                camera.CFrame = CFrame.new(camera.CFrame.Position, p.Character.Head.Position)
            end
        end
    end
    
    -- Kill Aura
    if Config.Toggles.KillAura and GetPlayerRole(lp) == "Murderer" and lp.Character:FindFirstChild("Knife") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist < 25 then
                    firetouchinterest(p.Character.HumanoidRootPart, lp.Character.Knife.Handle, 0)
                    firetouchinterest(p.Character.HumanoidRootPart, lp.Character.Knife.Handle, 1)
                end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Config.Toggles.InfJump and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- [[ 🏙️ INTERFAZ AZUL NEÓN FUTURISTA ]]
local function BuildMain()
    local sg = Instance.new("ScreenGui", CoreGui)
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 480, 0, 320)
    main.Position = UDim2.new(0.5, -240, 0.5, -160)
    main.BackgroundColor3 = Color3.fromRGB(5, 10, 25)
    main.BorderSizePixel = 0
    Instance.new("UICorner", main)
    local stroke = Instance.new("UIStroke", main)
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Thickness = 3

    -- Botón Flotante Movible
    local float = Instance.new("TextButton", sg)
    float.Size = UDim2.new(0, 70, 0, 70)
    float.Position = UDim2.new(0.05, 0, 0.4, 0)
    float.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    float.Text = "CH-HUB"
    float.Font = Enum.Font.GothamBold
    float.TextColor3 = Color3.new(1,1,1)
    float.Visible = false
    Instance.new("UICorner", float).CornerRadius = UDim.new(1, 0)
    local f_drag = false; local f_start; local f_pos;
    float.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then f_drag = true; f_start = i.Position; f_pos = float.Position end end)
    float.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then f_drag = false end end)
    UserInputService.InputChanged:Connect(function(i) if f_drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - f_start
        float.Position = UDim2.new(f_pos.X.Scale, f_pos.X.Offset + delta.X, f_pos.Y.Scale, f_pos.Y.Offset + delta.Y)
    end end)

    local close = Instance.new("TextButton", main)
    close.Size = UDim2.new(0, 35, 0, 35)
    close.Position = UDim2.new(1, -40, 0, 5)
    close.Text = "✖"
    close.TextColor3 = Color3.new(1, 0.2, 0.2)
    close.BackgroundTransparency = 1
    close.TextSize = 25
    close.MouseButton1Click:Connect(function() main.Visible = false; float.Visible = true end)
    float.MouseButton1Click:Connect(function() main.Visible = true; float.Visible = false end)

    local side = Instance.new("Frame", main); side.Size = UDim2.new(0, 120, 1, -20); side.Position = UDim2.new(0, 10, 0, 10); side.BackgroundTransparency = 1
    Instance.new("UIListLayout", side).Padding = UDim.new(0, 8)
    local container = Instance.new("Frame", main); container.Size = UDim2.new(1, -150, 1, -60); container.Position = UDim2.new(0, 140, 0, 50); container.BackgroundTransparency = 1

    local function CreateTab(name)
        local f = Instance.new("ScrollingFrame", container)
        f.Size = UDim2.new(1, 0, 1, 0); f.Visible = false; f.BackgroundTransparency = 1; f.ScrollBarThickness = 0
        Instance.new("UIListLayout", f).Padding = UDim.new(0, 12)
        local b = Instance.new("TextButton", side)
        b.Size = UDim2.new(1, 0, 0, 45); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(15, 25, 50); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            for _, v in pairs(container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            f.Visible = true
        end)
        return f
    end

    local tabMain = CreateTab("MAIN"); tabMain.Visible = true
    local tabESP = CreateTab("ESP")
    local tabCombat = CreateTab("COMBAT")

    local function CreateFunc(parent, name, key)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0.95, 0, 0, 50)
        btn.Text = name
        btn.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        Instance.new("UICorner", btn)
        
        btn.MouseButton1Click:Connect(function()
            Config.Toggles[key] = not Config.Toggles[key]
            local active = Config.Toggles[key]
            btn.BackgroundColor3 = active and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
            SendNotify(name .. (active and " ACTIVADO" or " DESACTIVADO"), active and Color3.new(0,1,0) or Color3.new(1,0,0))
            task.wait(5)
            btn.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
        end)
    end

    -- MAIN
    CreateFunc(tabMain, "NOCLIP", "Noclip")
    CreateFunc(tabMain, "INFINITY JUMP", "InfJump")
    CreateFunc(tabMain, "SPEED", "WalkSpeed")
    local credit = Instance.new("TextLabel", tabMain); credit.Size = UDim2.new(1,0,0,40); credit.Text = "Follow me on TikTok: sasware32 😏"; credit.TextColor3 = Color3.fromRGB(0, 180, 255); credit.BackgroundTransparency = 1; credit.Font = Enum.Font.GothamBold

    -- ESP
    CreateFunc(tabESP, "ESP ASESINO (RED)", "ESP_Murd")
    CreateFunc(tabESP, "ESP SHERIFF (BLUE)", "ESP_Sheriff")
    CreateFunc(tabESP, "ESP INOCENTE (GREEN)", "ESP_Inno")
    CreateFunc(tabESP, "TRACES", "Traces")

    -- COMBAT
    CreateFunc(tabCombat, "AIMBOT FIXED", "Aimbot")
    CreateFunc(tabCombat, "KILL AURA", "KillAura")
    
    local tpBtn = Instance.new("TextButton", tabCombat)
    tpBtn.Size = UDim2.new(0.95, 0, 0, 50); tpBtn.Text = "TP SHERIFF"; tpBtn.BackgroundColor3 = Color3.fromRGB(30, 35, 50); tpBtn.TextColor3 = Color3.new(1,1,1); tpBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", tpBtn)
    
    tpBtn.MouseButton1Click:Connect(function()
        tpBtn.BackgroundColor3 = Color3.new(0, 1, 0)
        SendNotify("TELETRANSPORTANDO", Color3.fromRGB(0, 190, 255))
        task.wait(3)
        local sheriff = nil
        for _, p in pairs(Players:GetPlayers()) do if GetPlayerRole(p) == "Sheriff" and p.Character then sheriff = p break end end
        if sheriff then
            lp.Character.HumanoidRootPart.CFrame = sheriff.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,2)
            SendNotify("TELEPORTACIÓN EXITOSA", Color3.new(0, 1, 0))
        else
            SendNotify("SHERIFF NO ENCONTRADO", Color3.new(1, 0, 0))
        end
        task.wait(2); tpBtn.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    end)
end

-- [[ 🚀 INTRO CAYENDO (BOMBA FINAL) ]]
local function StartIntro()
    local sg = Instance.new("ScreenGui", CoreGui)
    local title = "CHRISSHUB V2"
    local labels = {}
    for i = 1, #title do
        local l = Instance.new("TextLabel", sg)
        l.Text = title:sub(i,i)
        l.Size = UDim2.new(0, 60, 0, 60)
        l.Position = UDim2.new(0.32 + (i*0.04), 0, -0.2, 0)
        l.TextColor3 = Color3.fromRGB(0, 255, 120)
        l.TextSize = 70; l.Font = Enum.Font.Code; l.BackgroundTransparency = 1; l.TextStrokeTransparency = 0
        table.insert(labels, l)
        l:TweenPosition(UDim2.new(0.32 + (i*0.04), 0, 0.45, 0), "Out", "Bounce", 1 + (i*0.12), true)
    end
    task.wait(4)
    for _, v in pairs(labels) do
        TweenService:Create(v, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextSize = 350, TextTransparency = 1, TextColor3 = Color3.new(0,1,0)}):Play()
    end
    task.wait(0.7); sg:Destroy(); BuildMain()
end

-- [[ 🔑 KEY SYSTEM NEÓN MORADO ]]
local function RunKeys()
    local sg = Instance.new("ScreenGui", CoreGui)
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 350, 0, 250); frame.Position = UDim2.new(0.5, -175, 0.5, -125); frame.BackgroundColor3 = Color3.fromRGB(15, 5, 35); Instance.new("UICorner", frame)
    local stroke = Instance.new("UIStroke", frame); stroke.Color = Color3.fromRGB(180, 0, 255); stroke.Thickness = 3
    
    local input = Instance.new("TextBox", frame); input.Size = UDim2.new(0.8, 0, 0, 50); input.Position = UDim2.new(0.1, 0, 0.35, 0); input.PlaceholderText = "Enter licencia"; input.Text = ""; input.TextColor3 = Color3.new(1,1,1); input.BackgroundColor3 = Color3.fromRGB(30, 15, 60); Instance.new("UICorner", input)
    
    local btn = Instance.new("TextButton", frame); btn.Size = UDim2.new(0.8, 0, 0, 50); btn.Position = UDim2.new(0.1, 0, 0.7, 0); btn.Text = "VERIFY"; btn.BackgroundColor3 = Color3.fromRGB(180, 0, 255); btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold; Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        if table.find(CH_KEYS, input.Text) then
            btn.Text = "Verifying key..."; btn.TextColor3 = Color3.new(1, 1, 0)
            task.spawn(function()
                while btn.Text == "Verifying key..." do
                    btn.TextTransparency = 0.3; task.wait(0.2); btn.TextTransparency = 0; task.wait(0.2)
                end
            end)
            task.wait(3); sg:Destroy(); StartIntro()
        else
            input.Text = ""; input.PlaceholderText = "Incorrect key"; input.PlaceholderColor3 = Color3.new(1, 0, 0); task.wait(2); input.PlaceholderText = "Enter licencia"
        end
    end)
end

RunKeys()
