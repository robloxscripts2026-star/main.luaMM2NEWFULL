-- [[ 🟢 CHRISSHUB V2 SUPREME - OFFICIAL RELEASE 🟢 ]]
-- [[ GITHUB REPOSITORY: robloxscripts2026-star / main.luaMM2NEWFULL ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [[ 🔑 CONFIGURATION & DATABASE ]]
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

-- [[ 📢 NOTIFICATION SYSTEM ]]
local function SendNotify(txt, col)
    local sg = Instance.new("ScreenGui", CoreGui)
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 220, 0, 45)
    frame.Position = UDim2.new(1, 10, 0.15, 0)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    Instance.new("UICorner", frame)
    Instance.new("UIStroke", frame).Color = col
    
    local l = Instance.new("TextLabel", frame)
    l.Size = UDim2.new(1, 0, 1, 0); l.Text = txt; l.TextColor3 = col
    l.Font = Enum.Font.GothamBold; l.BackgroundTransparency = 1; l.TextSize = 13
    
    frame:TweenPosition(UDim2.new(1, -230, 0.15, 0), "Out", "Back", 0.5, true)
    task.delay(3.5, function()
        frame:TweenPosition(UDim2.new(1, 10, 0.15, 0), "In", "Quad", 0.5, true)
        task.wait(0.5); sg:Destroy()
    end)
end

-- [[ 👁️ VISUAL ENGINE (ESP & TRACERS) ]]
local function GetPlayerRole(p)
    if not p or not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

local function CreateESP(p)
    local highlight = Instance.new("Highlight", CoreGui)
    local line = Drawing.new("Line")
    line.Thickness = 2; line.Transparency = 1

    local render
    render = RunService.RenderStepped:Connect(function()
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
            local role = GetPlayerRole(p)
            local color = (role == "Murderer" and Color3.new(1,0,0)) or (role == "Sheriff" and Color3.new(0,0.7,1)) or Color3.new(0,1,0)
            local active = (role == "Murderer" and Config.Toggles.ESP_Murd) or (role == "Sheriff" and Config.Toggles.ESP_Sheriff) or (role == "Innocent" and Config.Toggles.ESP_Inno)
            
            highlight.Adornee = p.Character; highlight.Enabled = active; highlight.FillColor = color
            
            local pos, vis = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if Config.Toggles.Traces and vis and active then
                line.Visible = true; line.Color = color
                line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                line.To = Vector2.new(pos.X, pos.Y)
            else line.Visible = false end
        else
            highlight.Enabled = false; line.Visible = false
            if not Players:FindFirstChild(p.Name) then
                highlight:Destroy(); line:Remove(); render:Disconnect()
            end
        end
    end)
end

for _, v in pairs(Players:GetPlayers()) do if v ~= lp then CreateESP(v) end end
Players.PlayerAdded:Connect(function(v) if v ~= lp then CreateESP(v) end end)

-- [[ ⚔️ COMBAT LOGIC & BYPASS ]]
RunService.RenderStepped:Connect(function()
    if Config.Toggles.WalkSpeed and lp.Character then lp.Character.Humanoid.WalkSpeed = 50 end
    if Config.Toggles.Noclip and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    if Config.Toggles.Aimbot then
        for _, p in pairs(Players:GetPlayers()) do
            if GetPlayerRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("Head") then
                camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, p.Character.Head.Position), 0.1)
                break
            end
        end
    end
    if Config.Toggles.KillAura and GetPlayerRole(lp) == "Murderer" and lp.Character:FindFirstChild("Knife") then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < 40 then
                    firetouchinterest(p.Character.HumanoidRootPart, lp.Character.Knife.Handle, 0)
                    firetouchinterest(p.Character.HumanoidRootPart, lp.Character.Knife.Handle, 1)
                end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Config.Toggles.InfJump and lp.Character then lp.Character.Humanoid:ChangeState(3) end
end)

-- [[ 🏙️ MAIN INTERFACE ]]
local function BuildMain()
    local sg = Instance.new("ScreenGui", CoreGui)
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 460, 0, 310); main.Position = UDim2.new(0.5, -230, 0.5, -155)
    main.BackgroundColor3 = Color3.fromRGB(5, 10, 20); Instance.new("UICorner", main)
    local stroke = Instance.new("UIStroke", main); stroke.Color = Color3.fromRGB(0, 180, 255); stroke.Thickness = 3

    local close = Instance.new("TextButton", main)
    close.Size = UDim2.new(0, 30, 0, 30); close.Position = UDim2.new(1, -35, 0, 5)
    close.Text = "✖"; close.TextColor3 = Color3.new(1,0,0); close.BackgroundTransparency = 1; close.TextSize = 20

    local float = Instance.new("TextButton", sg)
    float.Size = UDim2.new(0, 60, 0, 60); float.Position = UDim2.new(0, 15, 0.5, 0)
    float.BackgroundColor3 = Color3.fromRGB(0, 180, 255); float.Text = "CH-HUB"; float.Visible = false
    Instance.new("UICorner", float).CornerRadius = UDim.new(1, 0)

    close.MouseButton1Click:Connect(function() main.Visible = false; float.Visible = true end)
    float.MouseButton1Click:Connect(function() main.Visible = true; float.Visible = false end)

    local side = Instance.new("Frame", main); side.Size = UDim2.new(0, 100, 1, -20); side.Position = UDim2.new(0, 10, 0, 10); side.BackgroundTransparency = 1
    Instance.new("UIListLayout", side).Padding = UDim.new(0, 6)
    local cont = Instance.new("Frame", main); cont.Size = UDim2.new(1, -130, 1, -50); cont.Position = UDim2.new(0, 120, 0, 40); cont.BackgroundTransparency = 1

    local function Tab(name)
        local f = Instance.new("ScrollingFrame", cont)
        f.Size = UDim2.new(1, 0, 1, 0); f.Visible = false; f.BackgroundTransparency = 1; f.ScrollBarThickness = 0
        Instance.new("UIListLayout", f).Padding = UDim.new(0, 10)
        local b = Instance.new("TextButton", side)
        b.Size = UDim2.new(1, 0, 0, 35); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
        b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            for _, v in pairs(cont:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            f.Visible = true
        end)
        return f
    end

    local mT = Tab("GENERAL"); mT.Visible = true
    local eT = Tab("VISUAL")
    local cT = Tab("COMBAT")

    local function RectBtn(parent, txt, key)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(0.95, 0, 0, 45); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
        local s = Instance.new("UIStroke", b); s.Color = Color3.fromRGB(70, 70, 80); s.Thickness = 2

        b.MouseButton1Click:Connect(function()
            Config.Toggles[key] = not Config.Toggles[key]
            local act = Config.Toggles[key]
            b.BackgroundColor3 = act and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
            SendNotify(txt .. (act and " ACTIVADO" or " DESACTIVADO"), act and Color3.new(0,1,0) or Color3.new(1,0,0))
            task.wait(5); b.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        end)
    end

    RectBtn(mT, "NOCLIP", "Noclip"); RectBtn(mT, "INF JUMP", "InfJump"); RectBtn(mT, "SPEED", "WalkSpeed")
    RectBtn(eT, "ESP MURDER", "ESP_Murd"); RectBtn(eT, "ESP SHERIFF", "ESP_Sheriff"); RectBtn(eT, "LÍNEAS", "Traces")
    RectBtn(cT, "AIMBOT", "Aimbot"); RectBtn(cT, "KILL AURA", "KillAura")
end

-- [[ 🚀 INTRO ANIMATION ]]
local function StartIntro()
    local sg = Instance.new("ScreenGui", CoreGui)
    local txt = "CHRISSHUB V2"
    local labels = {}
    for i = 1, #txt do
        local c = txt:sub(i,i)
        local l = Instance.new("TextLabel", sg)
        l.Text = c; l.Size = UDim2.new(0, 50, 0, 50); l.Position = UDim2.new(0.3 + (i*0.04), 0, -0.2, 0)
        l.TextColor3 = Color3.fromRGB(0, 255, 100); l.TextSize = 60; l.Font = Enum.Font.Code; l.BackgroundTransparency = 1
        table.insert(labels, l)
        l:TweenPosition(UDim2.new(0.3 + (i*0.04), 0, 0.45, 0), "Out", "Bounce", 1 + (i*0.1), true)
    end
    task.wait(3.5)
    for _, v in pairs(labels) do
        TweenService:Create(v, TweenInfo.new(0.6), {TextSize = 300, TextTransparency = 1, TextColor3 = Color3.new(1,1,1)}):Play()
    end
    task.wait(0.7); sg:Destroy(); BuildMain()
end

-- [[ 🔑 KEY VALIDATION SYSTEM ]]
local function RunKeys()
    local sg = Instance.new("ScreenGui", CoreGui)
    local f = Instance.new("Frame", sg); f.Size = UDim2.new(0, 330, 0, 230); f.Position = UDim2.new(0.5, -165, 0.5, -115)
    f.BackgroundColor3 = Color3.fromRGB(15, 5, 30); Instance.new("UICorner", f)
    Instance.new("UIStroke", f).Color = Color3.fromRGB(180, 0, 255)
    
    local i = Instance.new("TextBox", f); i.Size = UDim2.new(0.8, 0, 0, 45); i.Position = UDim2.new(0.1, 0, 0.35, 0)
    i.PlaceholderText = "Enter licencia"; i.Text = ""; i.BackgroundColor3 = Color3.fromRGB(30, 10, 50); i.TextColor3 = Color3.new(1,1,1)
    
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(0.8, 0, 0, 45); b.Position = UDim2.new(0.1, 0, 0.7, 0)
    b.Text = "VERIFY"; b.BackgroundColor3 = Color3.fromRGB(180, 0, 255); b.Font = Enum.Font.GothamBold
    
    b.MouseButton1Click:Connect(function()
        if table.find(CH_KEYS, i.Text) then
            b.Text = "Verifying key..."; b.BackgroundColor3 = Color3.new(1, 1, 0)
            task.wait(2.5); sg:Destroy(); StartIntro()
        else
            i.Text = ""; i.PlaceholderText = "Key incorrecta"; i.PlaceholderColor3 = Color3.new(1, 0, 0)
        end
    end)
end

RunKeys()
