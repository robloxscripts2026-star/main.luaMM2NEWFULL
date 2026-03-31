-- [[  CHRISSHUB V3 SUPREME - DELTA STABLE EDITION ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

print("[+] CHRISSHUB V3 Supreme cargado correctamente")

-- [[ 🔑 KEY SYSTEM (30 DÍAS) - Simple pero funcional ]]
local KEY_FILE = "ChrisSHub_Keys.json"
local EXPIRATION_DAYS = 30

local SavedKeys = {}
if isfile and isfile(KEY_FILE) then
    pcall(function()
        SavedKeys = HttpService:JSONDecode(readfile(KEY_FILE))
    end)
end

local function SaveKeys()
    if writefile then
        pcall(function()
            writefile(KEY_FILE, HttpService:JSONEncode(SavedKeys))
        end)
    end
end

local CH_KEYS = {
    "CHKEY_2964173850", "CHKEY_8317642950", "CHKEY_5729184630", "CHKEY_9463825170",
    "CHKEY_1857396240", "CHKEY_7248163950", "CHKEY_3692581740", "CHKEY_6159274830",
    "CHKEY_4836917250", "CHKEY_8527419630", "CHKEY_2769318450", "CHKEY_9148526730",
    "CHKEY_5382761940", "CHKEY_7615928340", "CHKEY_3974182650"
}

local function IsKeyValid(key)
    local now = os.time()
    if SavedKeys[key] then
        if now > SavedKeys[key].expire then
            SavedKeys[key] = nil
            SaveKeys()
            return false
        end
        return true
    end
    if table.find(CH_KEYS, key) then
        SavedKeys[key] = {expire = now + (EXPIRATION_DAYS * 86400)}
        SaveKeys()
        return true
    end
    return false
end

-- [[ 🛡️ BYPASS SEGURO PARA DELTA ]]
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        local name = tostring(self):lower()
        if name:find("anticheat") or name:find("report") or name:find("ban") or 
           name:find("detect") or name:find("cheat") or name:find("log") then
            return nil
        end
    end
    return OldNamecall(self, unpack(args))
end)

-- Configuración
local Config = {
    Toggles = {
        Noclip = false, InfJump = false, WalkSpeed = false,
        Aimbot = false, KillAura = false,
        ESP_Murd = false, ESP_Sheriff = false, ESP_Inno = false, Traces = false
    },
    SpeedValue = 50
}

local murderHitbox = nil

local function GetRole(p)
    if not p or not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

local function SendNotify(txt, col)
    col = col or Color3.fromRGB(0, 255, 100)
    spawn(function()
        local sg = Instance.new("ScreenGui", CoreGui)
        local frame = Instance.new("Frame", sg)
        frame.Size = UDim2.new(0, 260, 0, 55)
        frame.Position = UDim2.new(1, -280, 0.12, 0)
        frame.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
        
        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = col
        stroke.Thickness = 2.5
        
        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1, -20, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Text = txt
        label.TextColor3 = col
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.BackgroundTransparency = 1
        
        frame:TweenPosition(UDim2.new(1, 20, 0.12, 0), "Out", "Back", 0.45, true)
        task.wait(3.8)
        frame:TweenPosition(UDim2.new(1, -280, 0.12, 0), "In", "Quad", 0.5, true)
        task.wait(0.7)
        sg:Destroy()
    end)
end

-- [[ INTRO BONITA ]]
local function StartIntro()
    local sg = Instance.new("ScreenGui", CoreGui)
    local bg = Instance.new("Frame", sg)
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = Color3.new(0,0,0)
    bg.BackgroundTransparency = 0

    local title = Instance.new("TextLabel", bg)
    title.Size = UDim2.new(0.8,0,0.25,0)
    title.Position = UDim2.new(0.1,0,0.35,0)
    title.Text = "CHRISSHUB"
    title.TextColor3 = Color3.fromRGB(0, 255, 200)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 100
    title.BackgroundTransparency = 1
    title.TextTransparency = 1

    local subtitle = Instance.new("TextLabel", bg)
    subtitle.Size = UDim2.new(0.6,0,0.1,0)
    subtitle.Position = UDim2.new(0.2,0,0.55,0)
    subtitle.Text = "V3 • SUPREME"
    subtitle.TextColor3 = Color3.fromRGB(180, 0, 255)
    subtitle.Font = Enum.Font.GothamBold
    subtitle.TextSize = 45
    subtitle.BackgroundTransparency = 1
    subtitle.TextTransparency = 1

    TweenService:Create(title, TweenInfo.new(1.2, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
    TweenService:Create(subtitle, TweenInfo.new(1.5, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()

    task.wait(3.8)
    TweenService:Create(bg, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
    TweenService:Create(title, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
    TweenService:Create(subtitle, TweenInfo.new(0.8), {TextTransparency = 1}):Play()

    task.wait(1.3)
    sg:Destroy()
    BuildMain()
end

-- [[ FLING ]]
local function FlingPlayer(role)
    local target = nil
    for _, plr in Players:GetPlayers() do
        if GetRole(plr) == role and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            target = plr.Character.HumanoidRootPart
            break
        end
    end
    if not target or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then
        SendNotify(role .. " NO ENCONTRADO", Color3.new(1,0,0))
        return
    end

    local root = lp.Character.HumanoidRootPart
    local att = Instance.new("Attachment", root)

    local av = Instance.new("AngularVelocity", root)
    av.Attachment0 = att
    av.AngularVelocity = Vector3.new(0, 9999, 0)
    av.MaxTorque = math.huge

    local lv = Instance.new("LinearVelocity", root)
    lv.Attachment0 = att
    lv.Velocity = (target.Position - root.Position).Unit * 250 + Vector3.new(0, 80, 0)
    lv.MaxForce = math.huge

    local oldNoclip = Config.Toggles.Noclip
    Config.Toggles.Noclip = true

    task.wait(0.45)
    av:Destroy()
    lv:Destroy()
    att:Destroy()
    Config.Toggles.Noclip = oldNoclip

    SendNotify(role .. " FLINGEADO", Color3.fromRGB(255, 140, 0))
end

-- [[ MENÚ COMPLETO Y BONITO ]]
local function BuildMain()
    local sg = Instance.new("ScreenGui", CoreGui)
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 480, 0, 320)
    main.Position = UDim2.new(0.5, -240, 0.5, -160)
    main.BackgroundColor3 = Color3.fromRGB(5, 10, 25)
    Instance.new("UICorner", main)

    local stroke = Instance.new("UIStroke", main)
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Thickness = 3

    -- Botón flotante
    local float = Instance.new("TextButton", sg)
    float.Size = UDim2.new(0, 70, 0, 70)
    float.Position = UDim2.new(0.05, 0, 0.4, 0)
    float.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    float.Text = "CH-HUB"
    float.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", float).CornerRadius = UDim.new(1, 0)
    float.Visible = false

    -- Draggable
    local dragging, dragStart, startPos
    float.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = float.Position
        end
    end)
    float.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            float.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local close = Instance.new("TextButton", main)
    close.Size = UDim2.new(0, 35, 0, 35)
    close.Position = UDim2.new(1, -40, 0, 5)
    close.Text = "✖"
    close.TextColor3 = Color3.new(1,0,0)
    close.BackgroundTransparency = 1
    close.TextSize = 25
    close.MouseButton1Click:Connect(function() main.Visible = false; float.Visible = true end)
    float.MouseButton1Click:Connect(function() main.Visible = true; float.Visible = false end)

    local side = Instance.new("Frame", main)
    side.Size = UDim2.new(0, 120, 1, -20)
    side.Position = UDim2.new(0, 10, 0, 10)
    side.BackgroundTransparency = 1
    Instance.new("UIListLayout", side).Padding = UDim.new(0, 8)

    local container = Instance.new("Frame", main)
    container.Size = UDim2.new(1, -150, 1, -60)
    container.Position = UDim2.new(0, 140, 0, 50)
    container.BackgroundTransparency = 1

    local function CreateTab(name)
        local f = Instance.new("ScrollingFrame", container)
        f.Size = UDim2.new(1, 0, 1, 0)
        f.Visible = false
        f.BackgroundTransparency = 1
        f.ScrollBarThickness = 0
        Instance.new("UIListLayout", f).Padding = UDim.new(0, 12)

        local b = Instance.new("TextButton", side)
        b.Size = UDim2.new(1, 0, 0, 45)
        b.Text = name
        b.BackgroundColor3 = Color3.fromRGB(15, 25, 50)
        b.TextColor3 = Color3.new(1,1,1)
        b.Font = Enum.Font.GothamBold
        Instance.new("UICorner", b)

        b.MouseButton1Click:Connect(function()
            for _, v in pairs(container:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
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
            btn.BackgroundColor3 = Config.Toggles[key] and Color3.new(0,1,0) or Color3.new(1,0,0)
            SendNotify(name .. (Config.Toggles[key] and " ACTIVADO" or " DESACTIVADO"), Config.Toggles[key] and Color3.new(0,1,0) or Color3.new(1,0,0))
            task.wait(3)
            btn.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
        end)
    end

    -- Tabs
    CreateFunc(tabMain, "NOCLIP", "Noclip")
    CreateFunc(tabMain, "INFINITY JUMP", "InfJump")
    CreateFunc(tabMain, "SPEED HACK", "WalkSpeed")

    CreateFunc(tabESP, "ESP ASESINO (RED)", "ESP_Murd")
    CreateFunc(tabESP, "ESP SHERIFF (BLUE)", "ESP_Sheriff")
    CreateFunc(tabESP, "ESP INOCENTE (GREEN)", "ESP_Inno")
    CreateFunc(tabESP, "TRACES", "Traces")

    CreateFunc(tabCombat, "AIMBOT", "Aimbot")
    CreateFunc(tabCombat, "KILL AURA", "KillAura")

    -- Fling Buttons
    local flingSheriff = Instance.new("TextButton", tabCombat)
    flingSheriff.Size = UDim2.new(0.95, 0, 0, 50)
    flingSheriff.Text = "FLING SHERIFF"
    flingSheriff.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    flingSheriff.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", flingSheriff)
    flingSheriff.MouseButton1Click:Connect(function() FlingPlayer("Sheriff") end)

    local flingMurder = Instance.new("TextButton", tabCombat)
    flingMurder.Size = UDim2.new(0.95, 0, 0, 50)
    flingMurder.Text = "FLING MURDERER"
    flingMurder.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    flingMurder.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", flingMurder)
    flingMurder.MouseButton1Click:Connect(function() FlingPlayer("Murderer") end)
end

-- [[ INICIO ]]
local function RunKeys()
    local sg = Instance.new("ScreenGui", CoreGui)
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 350, 0, 250)
    frame.Position = UDim2.new(0.5, -175, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(15, 5, 35)
    Instance.new("UICorner", frame)
    Instance.new("UIStroke", frame).Color = Color3.fromRGB(180, 0, 255)

    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(0.8, 0, 0, 50)
    input.Position = UDim2.new(0.1, 0, 0.35, 0)
    input.PlaceholderText = "Enter licencia"
    input.BackgroundColor3 = Color3.fromRGB(30, 15, 60)
    Instance.new("UICorner", input)

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.8, 0, 0, 50)
    btn.Position = UDim2.new(0.1, 0, 0.7, 0)
    btn.Text = "VERIFY"
    btn.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        if IsKeyValid(input.Text) then
            btn.Text = "Verifying..."
            task.wait(2)
            sg:Destroy()
            StartIntro()
        else
            input.Text = ""
            input.PlaceholderText = "Key inválida o expirada"
            task.wait(2)
            input.PlaceholderText = "Enter licencia"
        end
    end)
end

RunKeys()
