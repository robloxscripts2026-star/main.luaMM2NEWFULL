-- [[ CH-HUB MM2 V3.1 MODDED ]] --
-- [[ SILENT AIM + MAGIC BULLETS + SHOTMURDER ]] --

task.wait(0.5)

-- [[ 🛠️ SERVICIOS ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [[ 🔑 DATABASE: 25 KEYS ]]
local MANUAL_KEYS = {
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
        Noclip = false, InfJump = false, WalkSpeed = false, FOV_Toggle = false,
        Aimbot = false, KillAura = false, Hitbox = false,
        ESP_Inno = false, ESP_Sheriff = false, ESP_Murd = false,
        Traces = false, UILocked = false, SilentAim = false
    },
    Values = {
        Speed = 50, FOV_Max = 120, FOV_Min = 70, 
        HitboxSize = 10, AuraRange = 48, Smooth = 0.8,
        LastSheriffPos = nil
    },
    Colors = {
        Murd = Color3.fromRGB(255, 35, 35),
        Sher = Color3.fromRGB(0, 180, 255),
        Inno = Color3.fromRGB(0, 255, 140),
        Accent = Color3.fromRGB(0, 230, 255),
        Bg = Color3.fromRGB(15, 15, 20)
    }
}

-- [[ 🛰️ FUNCIONES DE APOYO ]]
local function GetRole(p)
    if not p or not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

local function GetMurderer()
    for _, v in pairs(Players:GetPlayers()) do
        if GetRole(v) == "Murderer" and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            return v.Character.HumanoidRootPart
        end
    end
    return nil
end

-- [[ 🎯 LÓGICA DE SILENT AIM / MAGIC BULLETS ]]
local oldNamecall
oldNamecall = hookmetatable(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if Config.Toggles.SilentAim and method == "FindPartOnRayWithIgnoreList" then
        local target = GetMurderer()
        if target then
            -- Redirigir el Raycast directamente al Murderer (Magic Bullet logic)
            args[1] = Ray.new(camera.CFrame.Position, (target.Position - camera.CFrame.Position).Unit * 1000)
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- [[ 🛰️ NOTIFICACIONES ]]
local function Notify(title, text, color)
    local sg = Instance.new("ScreenGui", CoreGui)
    local f = Instance.new("Frame", sg); f.Size = UDim2.new(0, 280, 0, 85); f.Position = UDim2.new(1, 20, 0.15, 0); f.BackgroundColor3 = Config.Colors.Bg; Instance.new("UICorner", f); local s = Instance.new("UIStroke", f); s.Color = color; s.Thickness = 2.5
    local tl = Instance.new("TextLabel", f); tl.Size = UDim2.new(1, 0, 0.4, 0); tl.Text = title; tl.TextColor3 = color; tl.Font = Enum.Font.GothamBold; tl.BackgroundTransparency = 1; tl.TextSize = 16
    local dl = Instance.new("TextLabel", f); dl.Size = UDim2.new(1, 0, 0.6, 0); dl.Position = UDim2.new(0,0,0.4,0); dl.Text = text; dl.TextColor3 = Color3.new(1,1,1); dl.Font = Enum.Font.Gotham; dl.BackgroundTransparency = 1; dl.TextSize = 13; dl.TextWrapped = true
    f:TweenPosition(UDim2.new(1, -300, 0.15, 0), "Out", "Back", 0.5)
    task.delay(3.5, function() if f then f:TweenPosition(UDim2.new(1, 20, 0.15, 0), "In", "Quad", 0.5); task.wait(0.6); sg:Destroy() end end)
end

-- [[ 🖱️ DRAGGABLE ENGINE ]]
local function MakeDraggable(obj, isFloatingFrame)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if isFloatingFrame and Config.Toggles.UILocked then return end
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true; dragStart = input.Position; startPos = obj.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [[ 🏙️ UI PRINCIPAL ]]
local function BuildUI()
    local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "CH_HUB_V3_MOD"
    
    -- BOTÓN SHOTMURDER (FLOTANTE DINÁMICO)
    local ShotBtn = Instance.new("TextButton", sg)
    ShotBtn.Size = UDim2.new(0, 120, 0, 45)
    ShotBtn.Position = UDim2.new(0.8, 0, 0.8, 0)
    ShotBtn.Text = "SHOTMURDER 🎯"
    ShotBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    ShotBtn.TextColor3 = Color3.new(1,1,1)
    ShotBtn.Font = Enum.Font.GothamBold
    ShotBtn.Visible = false
    Instance.new("UICorner", ShotBtn)
    local ShotStroke = Instance.new("UIStroke", ShotBtn); ShotStroke.Color = Color3.new(1,1,1); ShotStroke.Thickness = 2
    MakeDraggable(ShotBtn, false)

    ShotBtn.MouseButton1Click:Connect(function()
        local gun = lp.Character:FindFirstChild("Gun") or lp.Backpack:FindFirstChild("Gun")
        if gun then
            lp.Character.Humanoid:EquipTool(gun)
            gun:Activate()
            Notify("MAGIC SHOT", "Disparo enviado al Murderer", Config.Colors.Murd)
        else
            Notify("ERROR", "No tienes el arma", Color3.new(1,0,0))
        end
    end)

    -- PANEL PRINCIPAL (Igual al tuyo pero con el nuevo toggle)
    local Main = Instance.new("Frame", sg); Main.Size = UDim2.new(0, 360, 0, 340); Main.Position = UDim2.new(0.5, -180, 0.5, -170); Main.BackgroundColor3 = Config.Colors.Bg; Main.Visible = false; Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Config.Colors.Accent; MakeDraggable(Main, false)
    
    -- (Omitiré la creación repetitiva de botones para ir al grano, pero aquí integras el SilentAim Toggle)
    -- ... (Aquí va tu lógica de Sidebar y Contenido de Tabs) ...
    
    -- EN LA TAB DE COMBAT AÑADIMOS:
    -- Toggle(t3, "SILENT AIM", "SilentAim") 
    -- Al activar "SilentAim", ShotBtn.Visible = true
    
    -- (Resto de motores: ESP, Hitbox, Jump, etc se mantienen igual al original que pasaste)
    
    -- [ESTA FUNCIÓN SE ENCARGA DE LA VISIBILIDAD DEL BOTÓN]
    RunService.RenderStepped:Connect(function()
        ShotBtn.Visible = Config.Toggles.SilentAim
    end)

    Notify("CH-HUB MODDED", "Sistemas de combate listos", Config.Colors.Accent)
end

-- (Aquí sigue tu función RunLogin() y el resto del código original)
