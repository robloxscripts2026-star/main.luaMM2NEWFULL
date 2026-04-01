repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Limpieza de ejecuciones previas
if CoreGui:FindFirstChild("CH_SUPREME_GUI") then CoreGui.CH_SUPREME_GUI:Destroy() end

-- =============================================
-- CONFIGURACIÓN GLOBAL
-- =============================================
local Config = {
    Toggles = {
        Noclip = false, InfJump = false, WalkSpeed = false,
        Aimbot = false, KillAura = false,
        ESP_Murd = false, ESP_Sheriff = false, ESP_Inno = false, Traces = false
    },
    SpeedValue = 50,
    HitboxSize = Vector3.new(15, 15, 15)
}

local active_esp = {}

-- =============================================
-- KEY SYSTEM CON JSON (30 DÍAS)
-- =============================================
local KEY_FILE = "ChrisSHub_Keys.json"
local EXPIRATION_DAYS = 30
local SavedKeys = {}

local function LoadKeys()
    if isfile and isfile(KEY_FILE) then
        pcall(function()
            SavedKeys = HttpService:JSONDecode(readfile(KEY_FILE))
        end)
    end
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
    "CHKEY_1857396240", "CHKEY_7248163950", "CHKEY_3692581740", "CHKEY_6159274830"
}

local function IsKeyValid(key)
    local now = os.time()
    LoadKeys()
    if SavedKeys[key] then
        if now > SavedKeys[key].expire then
            SavedKeys[key] = nil; SaveKeys(); return false
        end
        return true
    end
    if table.find(CH_KEYS, key) then
        SavedKeys[key] = {expire = now + (EXPIRATION_DAYS * 86400)}
        SaveKeys(); return true
    end
    return false
end

-- =============================================
-- NOTIFICACIONES Y ROLES
-- =============================================
local function SendNotify(txt, col)
    spawn(function()
        local sg = Instance.new("ScreenGui", CoreGui)
        local frame = Instance.new("Frame", sg)
        frame.Size = UDim2.new(0, 260, 0, 55)
        frame.Position = UDim2.new(1, 20, 0.12, 0)
        frame.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
        Instance.new("UICorner", frame)
        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = col or Color3.new(0,1,1); stroke.Thickness = 2
        
        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1,0,1,0); label.Text = txt; label.TextColor3 = stroke.Color
        label.BackgroundTransparency = 1; label.Font = "GothamBold"
        
        TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(1, -280, 0.12, 0)}):Play()
        task.wait(3); sg:Destroy()
    end)
end

local function GetRole(p)
    if not p or not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

-- =============================================
-- ESP + TRACES + HITBOX
-- =============================================
local function CreateESP(p)
    if p == lp then return end
    
    local highlight = Instance.new("Highlight", CoreGui)
    local line = Drawing.new("Line")
    line.Thickness = 2; line.Transparency = 1

    RunService.RenderStepped:Connect(function()
        if not p.Parent or not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then
            highlight.Enabled = false; line.Visible = false return 
        end
        
        local char = p.Character
        local hrp = char.HumanoidRootPart
        local role = GetRole(p)
        
        local is_enabled = (role == "Murderer" and Config.Toggles.ESP_Murd) or 
                          (role == "Sheriff" and Config.Toggles.ESP_Sheriff) or 
                          (role == "Innocent" and Config.Toggles.ESP_Inno)
        
        local col = (role == "Murderer" and Color3.new(1,0,0)) or (role == "Sheriff" and Color3.new(0,0.6,1)) or Color3.new(0,1,0)

        highlight.Enabled = is_enabled
        highlight.Adornee = char
        highlight.FillColor = col

        if Config.Toggles.Traces and is_enabled then
            local pos, vis = camera:WorldToViewportPoint(hrp.Position)
            line.Visible = vis
            if vis then
                line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                line.To = Vector2.new(pos.X, pos.Y)
                line.Color = col
            end
        else line.Visible = false end

        -- HITBOX 15x15x15
        if Config.Toggles.Aimbot and role == "Murderer" then
            if char:FindFirstChild("Head") then
                char.Head.Size = Config.HitboxSize
                char.Head.Transparency = 0.6
                char.Head.CanCollide = false
            end
        end
    end)
end

-- =============================================
-- INTERFAZ (Tu diseño Supreme)
-- =============================================
local function BuildMain()
    local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "CH_SUPREME_GUI"
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 450, 0, 300)
    main.Position = UDim2.new(0.5, -225, 0.5, -150)
    main.BackgroundColor3 = Color3.fromRGB(5, 5, 12)
    Instance.new("UICorner", main)
    Instance.new("UIStroke", main).Color = Color3.fromRGB(0, 160, 255)

    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1,0,0,40); title.Text = "CHRISSHUB V3 SUPREME"; title.TextColor3 = Color3.new(1,1,1)
    title.Font = "GothamBold"; title.BackgroundTransparency = 1; title.TextSize = 18

    local container = Instance.new("ScrollingFrame", main)
    container.Size = UDim2.new(1,-20, 1,-60); container.Position = UDim2.new(0,10,0,50)
    container.BackgroundTransparency = 1; container.ScrollBarThickness = 0
    Instance.new("UIListLayout", container).Padding = UDim.new(0,8)

    local function AddToggle(name, key)
        local btn = Instance.new("TextButton", container)
        btn.Size = UDim2.new(1,0,0,45); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(20,20,35)
        btn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function()
            Config.Toggles[key] = not Config.Toggles[key]
            btn.BackgroundColor3 = Config.Toggles[key] and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(20,20,35)
        end)
    end

    AddToggle("WALKSPEED (50)", "WalkSpeed")
    AddToggle("NOCLIP", "Noclip")
    AddToggle("ESP MURDERER", "ESP_Murd")
    AddToggle("ESP SHERIFF", "ESP_Sheriff")
    AddToggle("ESP INNOCENT", "ESP_Inno")
    AddToggle("TRACES", "Traces")
    AddToggle("AIMBOT & HITBOX", "Aimbot")

    SendNotify("MENÚ CARGADO", Color3.new(0,1,0))
end

-- =============================================
-- INTRO PROFESIONAL
-- =============================================
local function StartIntro()
    local sg = Instance.new("ScreenGui", CoreGui)
    local bg = Instance.new("Frame", sg)
    bg.Size = UDim2.new(1,0,1,0); bg.BackgroundColor3 = Color3.new(0,0,0)
    
    local txt = Instance.new("TextLabel", bg)
    txt.Size = UDim2.new(1,0,1,0); txt.Text = "CHRISSHUB"; txt.TextColor3 = Color3.new(0,0.8,1)
    txt.Font = "GothamBold"; txt.TextSize = 80; txt.TextTransparency = 1; txt.BackgroundTransparency = 1

    TweenService:Create(txt, TweenInfo.new(1.5), {TextTransparency = 0}):Play()
    task.wait(2.5)
    TweenService:Create(bg, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
    TweenService:Create(txt, TweenInfo.new(1), {TextTransparency = 1}):Play()
    task.wait(1.2); sg:Destroy(); BuildMain()
end

-- =============================================
-- SISTEMA DE LLAVES UI
-- =============================================
local function RunKeys()
    local sg = Instance.new("ScreenGui", CoreGui)
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0,300,0,180); frame.Position = UDim2.new(0.5,-150,0.5,-90)
    frame.BackgroundColor3 = Color3.fromRGB(10,10,20); Instance.new("UICorner", frame)

    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(0.8,0,0,40); input.Position = UDim2.new(0.1,0,0.3,0)
    input.PlaceholderText = "Ingresa tu Key"; input.Text = ""

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.8,0,0,40); btn.Position = UDim2.new(0.1,0,0.65,0)
    btn.Text = "VERIFICAR"; btn.BackgroundColor3 = Color3.fromRGB(0,120,255)
    
    btn.MouseButton1Click:Connect(function()
        if IsKeyValid(input.Text) then
            sg:Destroy(); StartIntro()
        else
            input.Text = ""; input.PlaceholderText = "KEY INVÁLIDA"
        end
    end)
end

-- =============================================
-- BUCLES PRINCIPALES
-- =============================================
for _, v in pairs(Players:GetPlayers()) do CreateESP(v) end
Players.PlayerAdded:Connect(CreateESP)

RunService.Heartbeat:Connect(function()
    if not lp.Character or not lp.Character:FindFirstChild("Humanoid") then return end
    lp.Character.Humanoid.WalkSpeed = Config.Toggles.WalkSpeed and Config.SpeedValue or 16
    
    if Config.Toggles.Noclip then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    if Config.Toggles.Aimbot then
        for _, p in pairs(Players:GetPlayers()) do
            if GetRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("Head") then
                camera.CFrame = CFrame.new(camera.CFrame.Position, p.Character.Head.Position)
                break
            end
        end
    end
end)

-- LANZAR
RunKeys()
