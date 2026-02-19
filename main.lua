-- [[ 🟣 CRISSHUB V6.1 - ANTI-FLING UPDATE 🟣 ]]
-- [[ FIX: AUTOFARM ESTABLE | KEY MORADA | MENÚ AZUL CON X ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

if _G.ChrisHubLoaded then return end
_G.ChrisHubLoaded = true

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
        ESP_Murd = false, ESP_Sheriff = false, ESP_Inno = false, Traces = false,
        AutoFarm = false
    },
    SpeedValue = 50
}

-- [[ 📢 NOTIFICACIONES DERECHA ]]
local function SendNotify(txt, col)
    task.spawn(function()
        local sg = Instance.new("ScreenGui", CoreGui)
        local frame = Instance.new("Frame", sg)
        frame.Size = UDim2.new(0, 240, 0, 50)
        frame.Position = UDim2.new(1, 10, 0.15, 0)
        frame.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
        Instance.new("UICorner", frame)
        local st = Instance.new("UIStroke", frame); st.Color = col; st.Thickness = 2
        local l = Instance.new("TextLabel", frame)
        l.Size = UDim2.new(1, 0, 1, 0); l.Text = txt; l.TextColor3 = col
        l.Font = Enum.Font.GothamBold; l.BackgroundTransparency = 1; l.TextSize = 13
        frame:TweenPosition(UDim2.new(1, -250, 0.15, 0), "Out", "Back", 0.5, true)
        task.wait(3)
        frame:TweenPosition(UDim2.new(1, 10, 0.15, 0), "In", "Quad", 0.5, true)
        task.wait(0.6); sg:Destroy()
    end)
end

-- [[ 💰 MOTOR AUTOFARM ESTABLE (ANTI-FLING) ]]
local function GetClosestCoin()
    local closest, dist = nil, math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if (v.Name == "Coin_Y" or v.Name == "Coin_M") and v:IsA("BasePart") then
            local d = (lp.Character.HumanoidRootPart.Position - v.Position).Magnitude
            if d < dist then dist = d; closest = v end
        end
    end
    return closest
end

task.spawn(function()
    while task.wait() do
        if Config.Toggles.AutoFarm and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local coin = GetClosestCoin()
            if coin then
                -- ESTABILIZADOR
                lp.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                lp.Character.Humanoid.PlatformStand = true
                -- NOCLIP PARA EVITAR SALIR VOLANDO
                for _, v in pairs(lp.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
                lp.Character.HumanoidRootPart.CFrame = coin.CFrame * CFrame.new(0, -3.5, 0)
            end
        elseif lp.Character and lp.Character:FindFirstChild("Humanoid") then
            if not Config.Toggles.Noclip then
                lp.Character.Humanoid.PlatformStand = false
            end
        end
    end
end)

-- [[ 👁️ ESP MOTOR ]]
local active_esp = {}
local function CreateESP(p)
    if active_esp[p] then return end
    local highlight = Instance.new("Highlight", CoreGui)
    local line = Drawing.new("Line")
    line.Thickness = 2; line.Transparency = 1
    active_esp[p] = {Highlight = highlight, Line = line}
    RunService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local role = GetRole(p)
            local color = (role == "Murderer" and Color3.new(1,0,0)) or (role == "Sheriff" and Color3.new(0,0.7,1)) or Color3.new(0,1,0)
            local enabled = (role == "Murderer" and Config.Toggles.ESP_Murd) or (role == "Sheriff" and Config.Toggles.ESP_Sheriff) or (role == "Innocent" and Config.Toggles.ESP_Inno)
            if enabled and p.Character.Humanoid.Health > 0 then
                highlight.Enabled = true; highlight.Adornee = p.Character; highlight.FillColor = color
                local pos, vis = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if Config.Toggles.Traces and vis then
                    line.Visible = true; line.Color = color; line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y); line.To = Vector2.new(pos.X, pos.Y)
                else line.Visible = false end
            else highlight.Enabled = false; line.Visible = false end
        else highlight.Enabled = false; line.Visible = false end
        if not Players:FindFirstChild(p.Name) then highlight:Destroy(); line:Remove(); active_esp[p] = nil end
    end)
end

function GetRole(p)
    if not p or not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

-- [[ 🏙️ MENÚ AZUL CON X ]]
local function BuildMain()
    local sg = Instance.new("ScreenGui", CoreGui)
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 480, 0, 320); main.Position = UDim2.new(0.5, -240, 0.5, -160)
    main.BackgroundColor3 = Color3.fromRGB(5, 10, 25); Instance.new("UICorner", main)
    Instance.new("UIStroke", main).Color = Color3.fromRGB(0, 180, 255)

    local float = Instance.new("TextButton", sg)
    float.Size = UDim2.new(0, 70, 0, 70); float.Position = UDim2.new(0.05, 0, 0.4, 0); float.Visible = false; float.Text = "CH-HUB"; float.BackgroundColor3 = Color3.fromRGB(0, 150, 255); float.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", float).CornerRadius = UDim.new(1,0)
    
    local close = Instance.new("TextButton", main); close.Size = UDim2.new(0, 35, 0, 35); close.Position = UDim2.new(1, -40, 0, 5); close.Text = "✖"; close.TextColor3 = Color3.new(1,0,0); close.BackgroundTransparency = 1; close.TextSize = 25
    close.MouseButton1Click:Connect(function() main.Visible = false; float.Visible = true end)
    float.MouseButton1Click:Connect(function() main.Visible = true; float.Visible = false end)

    local side = Instance.new("Frame", main); side.Size = UDim2.new(0, 120, 1, -20); side.Position = UDim2.new(0, 10, 0, 10); side.BackgroundTransparency = 1; Instance.new("UIListLayout", side).Padding = UDim.new(0, 8)
    local container = Instance.new("Frame", main); container.Size = UDim2.new(1, -150, 1, -60); container.Position = UDim2.new(0, 140, 0, 50); container.BackgroundTransparency = 1

    local function Tab(n)
        local f = Instance.new("ScrollingFrame", container); f.Size = UDim2.new(1, 0, 1, 0); f.Visible = false; f.BackgroundTransparency = 1; f.ScrollBarThickness = 0; Instance.new("UIListLayout", f).Padding = UDim.new(0, 12)
        local b = Instance.new("TextButton", side); b.Size = UDim2.new(1, 0, 0, 45); b.Text = n; b.BackgroundColor3 = Color3.fromRGB(15, 25, 50); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() for _, v in pairs(container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end f.Visible = true end)
        return f
    end

    local t1 = Tab("MAIN"); t1.Visible = true; local t2 = Tab("ESP"); local t3 = Tab("COMBAT"); local t4 = Tab("FARM")

    local function CreateFunc(p, name, key)
        local btn = Instance.new("TextButton", p); btn.Size = UDim2.new(0.95, 0, 0, 50); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(30, 35, 50); btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold; Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function()
            Config.Toggles[key] = not Config.Toggles[key]
            btn.BackgroundColor3 = Config.Toggles[key] and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
            SendNotify(name .. (Config.Toggles[key] and " ACTIVADO" or " DESACTIVADO"), Config.Toggles[key] and Color3.new(0,1,0) or Color3.new(1,0,0))
            task.wait(1); btn.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
        end)
    end

    CreateFunc(t1, "NOCLIP", "Noclip"); CreateFunc(t1, "INF JUMP", "InfJump"); CreateFunc(t1, "SPEED", "WalkSpeed")
    CreateFunc(t2, "ESP ASESINO", "ESP_Murd"); CreateFunc(t2, "ESP SHERIFF", "ESP_Sheriff"); CreateFunc(t2, "TRACES", "Traces")
    CreateFunc(t3, "AIMBOT", "Aimbot"); CreateFunc(t3, "KILL AURA", "KillAura")
    CreateFunc(t4, "ESTABLE FARM", "AutoFarm")
end

-- [[ 🚀 INTRO ORIGINAL ]]
local function StartIntro()
    local sg = Instance.new("ScreenGui", CoreGui); local title = "CHRISSHUB V2"; local labels = {}
    for i = 1, #title do
        local l = Instance.new("TextLabel", sg); l.Text = title:sub(i,i); l.Size = UDim2.new(0, 60, 0, 60); l.Position = UDim2.new(0.32 + (i*0.04), 0, -0.2, 0); l.TextColor3 = Color3.fromRGB(0, 255, 120); l.TextSize = 70; l.Font = Enum.Font.Code; l.BackgroundTransparency = 1; table.insert(labels, l)
        l:TweenPosition(UDim2.new(0.32 + (i*0.04), 0, 0.45, 0), "Out", "Bounce", 1 + (i*0.12), true)
    end
    task.wait(4); for _, v in pairs(labels) do TweenService:Create(v, TweenInfo.new(0.6), {TextSize = 350, TextTransparency = 1, TextColor3 = Color3.new(0,1,0)}):Play() end
    task.wait(0.7); sg:Destroy(); BuildMain()
end

-- [[ 🔑 KEY SYSTEM MORADO ]]
local function RunKeys()
    local sg = Instance.new("ScreenGui", CoreGui)
    local frame = Instance.new("Frame", sg); frame.Size = UDim2.new(0, 350, 0, 250); frame.Position = UDim2.new(0.5, -175, 0.5, -125); frame.BackgroundColor3 = Color3.fromRGB(15, 5, 35); Instance.new("UICorner", frame)
    Instance.new("UIStroke", frame).Color = Color3.fromRGB(180, 0, 255)
    local input = Instance.new("TextBox", frame); input.Size = UDim2.new(0.8, 0, 0, 50); input.Position = UDim2.new(0.1, 0, 0.35, 0); input.PlaceholderText = "Enter licencia"; input.TextColor3 = Color3.new(1,1,1); input.BackgroundColor3 = Color3.fromRGB(30, 15, 60); Instance.new("UICorner", input)
    local btn = Instance.new("TextButton", frame); btn.Size = UDim2.new(0, 120, 0, 40); btn.Position = UDim2.new(0.5, -60, 0.75, 0); btn.Text = "VERIFY"; btn.BackgroundColor3 = Color3.fromRGB(180, 0, 255); btn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        if table.find(CH_KEYS, input.Text) then sg:Destroy(); StartIntro()
        else input.Text = ""; input.PlaceholderText = "Incorrect Key" end
    end)
end

-- [[ LOOP FISICAS ]]
RunService.Stepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        if Config.Toggles.WalkSpeed then lp.Character.Humanoid.WalkSpeed = Config.SpeedValue end
        if Config.Toggles.Noclip or Config.Toggles.AutoFarm then
            for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)
UserInputService.JumpRequest:Connect(function() if Config.Toggles.InfJump and lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid:ChangeState(3) end end)

for _, v in pairs(Players:GetPlayers()) do if v ~= lp then CreateESP(v) end end
RunKeys()
