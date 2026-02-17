-- [[ 🟢 CHRISSHUB V2 SUPREME - OFFICIAL RELEASE 🟢 ]]
-- [[ DEVELOPER: SASWARE32 | TIKTOK: @sasware32 ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [[ 🔑 BASE DE DATOS: 15 KEYS ]]
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
    }
}

-- [[ 📢 SISTEMA DE NOTIFICACIONES RECTANGULARES ]]
local function SendNotify(txt, col)
    local sg = Instance.new("ScreenGui", CoreGui)
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 240, 0, 50)
    frame.Position = UDim2.new(1, 10, 0.15, 0)
    frame.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
    Instance.new("UICorner", frame)
    local st = Instance.new("UIStroke", frame); st.Color = col; st.Thickness = 2
    
    local l = Instance.new("TextLabel", frame)
    l.Size = UDim2.new(1, 0, 1, 0); l.Text = txt; l.TextColor3 = col
    l.Font = Enum.Font.GothamBold; l.BackgroundTransparency = 1; l.TextSize = 14
    
    frame:TweenPosition(UDim2.new(1, -250, 0.15, 0), "Out", "Back", 0.5, true)
    task.delay(3.5, function()
        frame:TweenPosition(UDim2.new(1, 10, 0.15, 0), "In", "Quad", 0.5, true)
        task.wait(0.5); sg:Destroy()
    end)
end

-- [[ 👁️ MOTOR DE ESP SUPREME (AUTO-LIMPIEZA) ]]
local active_esp = {}

local function GetRole(p)
    if p.Character and p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character and p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

local function CleanESP(p)
    if active_esp[p] then
        if active_esp[p].Highlight then active_esp[p].Highlight:Destroy() end
        if active_esp[p].Line then active_esp[p].Line:Remove() end
        active_esp[p] = nil
    end
end

local function UpdateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
            local role = GetRole(p)
            local color = (role == "Murderer" and Color3.new(1,0,0)) or (role == "Sheriff" and Color3.new(0,0.7,1)) or Color3.new(0,1,0)
            local enabled = (role == "Murderer" and Config.Toggles.ESP_Murd) or (role == "Sheriff" and Config.Toggles.ESP_Sheriff) or (role == "Innocent" and Config.Toggles.ESP_Inno)
            
            if not active_esp[p] then
                active_esp[p] = {
                    Highlight = Instance.new("Highlight", CoreGui),
                    Line = Drawing.new("Line")
                }
            end
            
            local data = active_esp[p]
            data.Highlight.Adornee = p.Character
            data.Highlight.Enabled = enabled
            data.Highlight.FillColor = color
            
            local pos, vis = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if Config.Toggles.Traces and vis and enabled then
                data.Line.Visible = true; data.Line.Color = color
                data.Line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                data.Line.To = Vector2.new(pos.X, pos.Y)
            else data.Line.Visible = false end
        else
            CleanESP(p)
        end
    end
end

RunService.RenderStepped:Connect(UpdateESP)

-- [[ ⚔️ COMBAT: AIMBOT 100% FIJO ]]
RunService.RenderStepped:Connect(function()
    if Config.Toggles.Aimbot then
        for _, p in pairs(Players:GetPlayers()) do
            if GetRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("Head") then
                camera.CFrame = CFrame.new(camera.CFrame.Position, p.Character.Head.Position)
                break
            end
        end
    end
    if Config.Toggles.KillAura and GetRole(lp) == "Murderer" and lp.Character:FindFirstChild("Knife") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < 25 then
                firetouchinterest(p.Character.HumanoidRootPart, lp.Character.Knife.Handle, 0)
                firetouchinterest(p.Character.HumanoidRootPart, lp.Character.Knife.Handle, 1)
            end
        end
    end
end)

-- [[ 🏙️ MENÚ AZUL NEÓN & DRAG ]]
local function BuildMain()
    local sg = Instance.new("ScreenGui", CoreGui)
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 460, 0, 310); main.Position = UDim2.new(0.5, -230, 0.5, -155)
    main.BackgroundColor3 = Color3.fromRGB(5, 10, 20); Instance.new("UICorner", main)
    local stroke = Instance.new("UIStroke", main); stroke.Color = Color3.fromRGB(0, 180, 255); stroke.Thickness = 3

    local float = Instance.new("TextButton", sg)
    float.Size = UDim2.new(0, 65, 0, 65); float.Position = UDim2.new(0.05, 0, 0.5, 0)
    float.BackgroundColor3 = Color3.fromRGB(0, 100, 255); float.Text = "CH-HUB"; float.Visible = false
    Instance.new("UICorner", float).CornerRadius = UDim.new(1, 0)
    -- Draggable float button logic
    local d, di, ds, sp; float.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true; ds = i.Position; sp = float.Position end end)
    float.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
    UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local del = i.Position - ds; float.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y) end end)

    local close = Instance.new("TextButton", main); close.Size = UDim2.new(0, 30, 0, 30); close.Position = UDim2.new(1, -35, 0, 5); close.Text = "✖"; close.TextColor3 = Color3.new(1,0,0); close.BackgroundTransparency = 1; close.TextSize = 25
    close.MouseButton1Click:Connect(function() main.Visible = false; float.Visible = true end)
    float.MouseButton1Click:Connect(function() main.Visible = true; float.Visible = false end)

    local side = Instance.new("Frame", main); side.Size = UDim2.new(0, 110, 1, -20); side.Position = UDim2.new(0, 10, 0, 10); side.BackgroundTransparency = 1
    Instance.new("UIListLayout", side).Padding = UDim.new(0, 5)
    local cont = Instance.new("Frame", main); cont.Size = UDim2.new(1, -140, 1, -50); cont.Position = UDim2.new(0, 130, 0, 40); cont.BackgroundTransparency = 1

    local function Tab(name)
        local f = Instance.new("ScrollingFrame", cont); f.Size = UDim2.new(1, 0, 1, 0); f.Visible = false; f.BackgroundTransparency = 1; f.ScrollBarThickness = 0
        Instance.new("UIListLayout", f).Padding = UDim.new(0, 10)
        local b = Instance.new("TextButton", side); b.Size = UDim2.new(1, 0, 0, 40); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(20, 30, 50); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() for _, v in pairs(cont:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end f.Visible = true end)
        return f
    end

    local mT = Tab("MAIN"); mT.Visible = true; local eT = Tab("ESP"); local cT = Tab("COMBAT")

    local function RectBtn(parent, txt, key)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(0.95, 0, 0, 45); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(30, 30, 40); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            Config.Toggles[key] = not Config.Toggles[key]
            b.BackgroundColor3 = Config.Toggles[key] and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
            SendNotify(txt .. (Config.Toggles[key] and " ACTIVADO" or " DESACTIVADO"), Config.Toggles[key] and Color3.new(0,1,0) or Color3.new(1,0,0))
            task.delay(5, function() b.BackgroundColor3 = Color3.fromRGB(30,30,40) end)
        end)
    end

    RectBtn(mT, "NOCLIP", "Noclip"); RectBtn(mT, "INF JUMP", "InfJump"); RectBtn(mT, "SPEED", "WalkSpeed")
    local tk = Instance.new("TextLabel", mT); tk.Size = UDim2.new(1,0,0,40); tk.Text = "Follow TikTok: sasware32 😏"; tk.TextColor3 = Color3.new(0, 0.7, 1); tk.BackgroundTransparency = 1

    RectBtn(eT, "ESP ASESINO", "ESP_Murd"); RectBtn(eT, "ESP SHERIFF", "ESP_Sheriff"); RectBtn(eT, "ESP INOCENTE", "ESP_Inno"); RectBtn(eT, "TRACES", "Traces")
    
    RectBtn(cT, "AIMBOT FIXED", "Aimbot"); RectBtn(cT, "KILL AURA", "KillAura")
    local tps = Instance.new("TextButton", cT); tps.Size = UDim2.new(0.95, 0, 0, 45); tps.Text = "TP SHERIFF"; tps.BackgroundColor3 = Color3.fromRGB(30,30,40); tps.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", tps)
    tps.MouseButton1Click:Connect(function()
        tps.BackgroundColor3 = Color3.new(0,1,0); SendNotify("TELETRANSPORTANDO", Color3.new(0, 0.8, 1))
        task.wait(3)
        local s; for _, p in pairs(Players:GetPlayers()) do if GetRole(p) == "Sheriff" and p.Character then s = p break end end
        if s then lp.Character.HumanoidRootPart.CFrame = s.Character.HumanoidRootPart.CFrame; SendNotify("TELEPORTACIÓN EXITOSA", Color3.new(0,1,0))
        else SendNotify("SHERIFF NO HALLADO", Color3.new(1,0,0)) end
        task.wait(2); tps.BackgroundColor3 = Color3.fromRGB(30,30,40)
    end)
end

-- [[ 🚀 INTRO BOMBA ]]
local function StartIntro()
    local sg = Instance.new("ScreenGui", CoreGui); local txt = "CHRISSHUB V2"; local labels = {}
    for i = 1, #txt do
        local l = Instance.new("TextLabel", sg); l.Text = txt:sub(i,i); l.Size = UDim2.new(0, 60, 0, 60); l.Position = UDim2.new(0.3 + (i*0.04), 0, -0.2, 0); l.TextColor3 = Color3.fromRGB(0, 255, 100); l.TextSize = 65; l.Font = Enum.Font.Code; l.BackgroundTransparency = 1; table.insert(labels, l)
        l:TweenPosition(UDim2.new(0.3 + (i*0.04), 0, 0.45, 0), "Out", "Bounce", 1 + (i*0.1), true)
    end
    task.wait(3.5)
    for _, v in pairs(labels) do
        TweenService:Create(v, TweenInfo.new(0.5), {TextSize = 250, TextTransparency = 1, TextColor3 = Color3.fromRGB(0, 255, 0)}):Play()
    end
    task.wait(0.6); sg:Destroy(); BuildMain()
end

-- [[ 🔑 KEY SYSTEM MORADO ]]
local function RunKeys()
    local sg = Instance.new("ScreenGui", CoreGui); local f = Instance.new("Frame", sg); f.Size = UDim2.new(0, 340, 0, 240); f.Position = UDim2.new(0.5, -170, 0.5, -120); f.BackgroundColor3 = Color3.fromRGB(15, 5, 30); Instance.new("UICorner", f); Instance.new("UIStroke", f).Color = Color3.fromRGB(180, 0, 255)
    local i = Instance.new("TextBox", f); i.Size = UDim2.new(0.8, 0, 0, 45); i.Position = UDim2.new(0.1, 0, 0.35, 0); i.PlaceholderText = "Enter licencia"; i.Text = ""; i.TextColor3 = Color3.new(1,1,1); i.BackgroundColor3 = Color3.fromRGB(30,10,50); Instance.new("UICorner", i)
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(0.8, 0, 0, 45); b.Position = UDim2.new(0.1, 0, 0.7, 0); b.Text = "VERIFY"; b.BackgroundColor3 = Color3.fromRGB(180, 0, 255); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        if table.find(CH_KEYS, i.Text) then
            b.Text = "Verifying key..."; b.TextColor3 = Color3.new(1,1,0)
            task.spawn(function() while b.Text == "Verifying key..." do b.Visible = not b.Visible; task.wait(0.3) end b.Visible = true end)
            task.wait(3); sg:Destroy(); StartIntro()
        else
            i.Text = ""; i.PlaceholderText = "Incorrect Key"; i.PlaceholderColor3 = Color3.new(1, 0, 0); task.wait(2); i.PlaceholderText = "Enter licencia"
        end
    end)
end

RunKeys()
