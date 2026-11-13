-- PASALP HUB - Fly GUI removed, pastebin button added
if game.CoreGui:FindFirstChild("PASALP_HUB") then
    game.CoreGui.PASALP_HUB:Destroy()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local function safeHttpGet(url)
    local ok, res = pcall(function() return game:HttpGet(url, true) end)
    if ok then return res end
    return nil, res
end

local function notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title; Text = text; Duration = duration or 3;
        })
    end)
end

local function make(parent, class, props)
    local inst = Instance.new(class)
    for k,v in pairs(props or {}) do
        if k == "Parent" then inst.Parent = v else inst[k] = v end
    end
    inst.Parent = parent or inst.Parent
    return inst
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PASALP_HUB"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = make(ScreenGui, "Frame", {
    Name = "MainFrame",
    Size = UDim2.new(0, 440, 0, 264),
    Position = UDim2.new(0.3, 0, 0.3, 0),
    BackgroundColor3 = Color3.fromRGB(4,4,4),
    BackgroundTransparency = 0.5,
    BorderSizePixel = 0,
    Active = true,
    Draggable = true
})
make(Frame, "UICorner", { CornerRadius = UDim.new(0,10) })

local Title = make(Frame, "TextLabel", {
    Size = UDim2.new(0,322,0,34),
    Position = UDim2.new(0,2,0,0),
    Text = "PASALP HUB",
    TextScaled = true,
    TextColor3 = Color3.fromRGB(255,255,255),
    BackgroundColor3 = Color3.fromRGB(4,4,4),
    BackgroundTransparency = 0.5,
    BorderSizePixel = 0
})
make(Title, "UICorner", { CornerRadius = UDim.new(0,8) })

local CloseBtn = make(Frame, "TextButton", {
    Size = UDim2.new(0,56,0,34),
    Position = UDim2.new(0,384,0,0),
    Text = "×", TextScaled = true, TextColor3 = Color3.fromRGB(255,255,255),
    BackgroundColor3 = Color3.fromRGB(4,4,4), BackgroundTransparency = 0.5, BorderSizePixel = 0
})
make(CloseBtn, "UICorner", { CornerRadius = UDim.new(0,6) })
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local MinBtn = make(Frame, "TextButton", {
    Size = UDim2.new(0,56,0,34),
    Position = UDim2.new(0,326,0,0),
    Text = "-", TextScaled = true, TextColor3 = Color3.fromRGB(255,255,255),
    BackgroundColor3 = Color3.fromRGB(4,4,4), BackgroundTransparency = 0.5, BorderSizePixel = 0
})
make(MinBtn, "UICorner", { CornerRadius = UDim.new(0,6) })
MinBtn.MouseButton1Click:Connect(function()
    Frame.Visible = false
    local Mini = make(ScreenGui, "TextButton", {
        Size = UDim2.new(0,120,0,30),
        Position = Frame.Position,
        Text = "PASALP HUB", TextScaled = true, Font = Enum.Font.SourceSansBold,
        BackgroundColor3 = Color3.fromRGB(20,20,20), TextColor3 = Color3.fromRGB(255,255,255)
    })
    make(Mini, "UICorner", { CornerRadius = UDim.new(0,8) })
    Mini.MouseButton1Click:Connect(function()
        Frame.Visible = true
        Mini:Destroy()
    end)
end)

local ButtonList = make(Frame, "ScrollingFrame", {
    Size = UDim2.new(0,114,0,218),
    Position = UDim2.new(0,8,0,38),
    BackgroundColor3 = Color3.fromRGB(4,4,0), BackgroundTransparency = 0.3,
    BorderSizePixel = 0, CanvasSize = UDim2.new(0,0,0,600),
    VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
})
make(ButtonList, "UICorner", { CornerRadius = UDim.new(0,8) })

local Content = make(Frame, "ScrollingFrame", {
    Size = UDim2.new(0,300,0,218),
    Position = UDim2.new(0,128,0,38),
    BackgroundColor3 = Color3.fromRGB(10,10,10),
    BackgroundTransparency = 0.2, BorderSizePixel = 0,
    CanvasSize = UDim2.new(0,0,0,4000),
    VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
})
make(Content, "UICorner", { CornerRadius = UDim.new(0,8) })

local function clearContent()
    for _,v in pairs(Content:GetChildren()) do
        if not v:IsA("UIGridStyleLayout") and v ~= Content:FindFirstChild("Layout") then
            v:Destroy()
        end
    end
end

local function makeContentButton(text, posY, onClick)
    local btn = make(Content, "TextButton", {
        Size = UDim2.new(0,280,0,36),
        Position = UDim2.new(0,10,0,posY),
        Text = text, TextScaled = true, TextColor3 = Color3.fromRGB(255,255,255),
        BackgroundColor3 = Color3.fromRGB(20,20,20), BackgroundTransparency = 0.15, BorderSizePixel = 0
    })
    make(btn, "UICorner", { CornerRadius = UDim.new(0,6) })
    btn.MouseButton1Click:Connect(function()
        pcall(onClick)
    end)
    return btn
end

local function addLeftButton(name, y, callback)
    local btn = make(ButtonList, "TextButton", {
        Size = UDim2.new(0,88,0,40),
        Position = UDim2.new(0,10,0,y),
        Text = name, TextScaled = true, TextColor3 = Color3.fromRGB(255,255,255),
        BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 0.2, BorderSizePixel = 0
    })
    make(btn, "UICorner", { CornerRadius = UDim.new(0,6) })
    btn.MouseButton1Click:Connect(function()
        for i,v in pairs(ButtonList:GetChildren()) do
            if v:IsA("TextButton") then
                v.BackgroundColor3 = Color3.fromRGB(0,0,0)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        clearContent()
        callback()
    end)
    return btn
end

local function showMainCategory()
    local y = 10

    local function addMain(name, url)
        makeContentButton(name, y, function()
            local code = safeHttpGet(url)
            if code then
                loadstring(code)()
                notify(name, "Çalıştırıldı", 2)
            else
                notify("Hata", "Script alınamadı", 3)
            end
        end)
        y = y + 46
    end

    -- God Mode
    addMain("God Mode", "https://raw.githubusercontent.com/mascaracathub/Test-Script/refs/heads/main/godmodev1.lua.txt")

    -- FE Fly
    addMain("FE Fly", "https://pastebin.com/raw/eKjmz6Hj")

    -- Auto Jump
    addMain("Auto Jump", "https://raw.githubusercontent.com/catwljzy/catwljz/refs/heads/main/aotojump.txt")

    -- Mobile / PC Keyboard
    addMain("Keyboard", "https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt")

    -- Invincible Fly
    addMain("Invincible Fly", "https://rawscripts.net/raw/Universal-Script-Invinicible-Flight-R15-45414")

addMain("Invisible", 
"https://rawscripts.net/raw/Universal-Script-Fe-invisible-script-77421")

addMain("Shiftlock",
"https://rawscripts.net/raw/Universal-Script-Shiftlock-script-42373")

addMain("Flip Screen",
"https://pastebin.com/raw/E7N3E0v2")
end

local function showHubsCategory()
    local y = 10
    local function addHub(name, url)
        makeContentButton(name, y, function()
            local ok, err = pcall(function()
                local code = safeHttpGet(url)
                if not code then error("Script alınamadı") end
                loadstring(code)()
            end)
            if ok then
                notify(name, "Hub Yüklendi", 2)
            else
                notify("Hata", tostring(err), 3)
            end
        end)
        y = y + 46
    end

    -- Eskiden olan Hub Scriptleri
addHub("Nds Fake Vr", 
"https://pastebin.com/raw/0nhr6Dyi") 
    addHub("GhostHub", "https://rawscripts.net/raw/Universal-Script-Ghost-Hub-27383") 
    addHub("Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
    addHub("Hathub", "https://rawscripts.net/raw/Universal-Script-Hat-Hub-33544")
    addHub("Ink Game Hub", "https://raw.githubusercontent.com/ScripterVaz/InkGameAzure/main/Protected_7974105512464815.lua.txt")
    addHub("Lennon Hub", "https://pastefy.app/MJw2J4T6/raw")
    addHub("Float Part Hub", "https://pastefy.app/gJj81HMi/raw") 
    addHub("Grow a Garden Hub", "https://raw.githubusercontent.com/gumanba/Scripts/main/GrowaGarden") 

    -- Yeni ve eklenen Hub Scriptleri
    addHub("Nekos Hub v2", "https://rawscripts.net/raw/Universal-Script-Nekos-Hub-V2-41014")
    addHub("Ultimate Troll GUI", "https://pastefy.app/eQA7OWqN/raw")
    addHub("Ro-Xploit 6.0", "https://rawscripts.net/raw/Universal-Script-ro-xploit-6-9233")
    addHub("RobHub", "https://pastebin.com/raw/KSvbtcPE")
    addHub("Draw and Donate Auto Draw", "https://api.junkie-development.de/api/v1/luascripts/public/eb46b9dafc8cd9bfae487791b4810720fa372387d9f6663beae48af9af924b57/download")
    addHub("Escape Tsunami For Brainrots Hub", "https://raw.githubusercontent.com/gumanba/Scripts/main/EscapeTsunamiForBrainrots")
    addHub("Evade Hub [Ying Yang]", "https://raw.githubusercontent.com/yesimsoul/Yin-Yang-Hub/refs/heads/main/evade")
    addHub("Evade Hub [Draconic Hub]", "https://raw.githubusercontent.com/Unknownproooolucky/Draconic-Hub-X/refs/heads/main/files/Evade/Overhaul.lua")
    addHub("Evade Hub [Algol Hub]", "https://raw.githubusercontent.com/marcelosero7-cyber/Algolevade/refs/heads/main/obfuscated.lua%20(15).txt")
    addHub("Voidware Hub [99 Nights in Forest]", "https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/loader.lua")
addHub("MM2 [Vision Hub]",
"https://raw.githubusercontent.com/orialdev/VisionHub/refs/heads/main/main.lua")
addHub("FTAP [Solaris Hub]",
"https://raw.githubusercontent.com/nooblol2/SolarisHub-xoxlol-Intel/refs/heads/main/lol.luau")
addHub("Krystal Dance Giant Fix",
"https://raw.githubusercontent.com/PIDIDDYI/Animation-Hub/refs/heads/main/Hub")
addHub("Krystal Dance Menu",
"https://rawscripts.net/raw/Universal-Script-MENU-SCRIPT-KRYSTAL-DANCE-59353")
addHub("UGC Emote Hub",
"https://rawscripts.net/raw/Universal-Script-7yd7-I-Emote-Script-48024")
addHub("Flamingo Evade Map", 
"https://raw.githubusercontent.com/Catwljzdyh/Scripts/refs/heads/main/Flamingo")
addHub("Shaders", 
"https://raw.githubusercontent.com/randomstring0/pshade-ultimate/refs/heads/main/src/cd.lua") 
end

local function showGamesCategory()
    local y = 10
    makeContentButton("Steal all players tool", y, function()
        local ok,err = pcall(function()
            for i,v in pairs(game.Players:GetPlayers()) do
                for _,b in pairs(v:WaitForChild("Backpack"):GetChildren()) do
                    pcall(function() b.Parent = LocalPlayer.Backpack end)
                end
            end
        end)
        if ok then notify("Tools", "Kopyalandı (denendi)",2) else notify("Tools", tostring(err),3) end
    end); y = y + 46

    makeContentButton("Slap All (load)", y, function()
        local code = safeHttpGet("https://rawscripts.net/raw/Slap-Tower-Slap-Tower-Works-Other-Slap-Gamep*-Games-too-34092")
        if code then loadstring(code)() notify("Slap", "Çalıştırıldı",2) else notify("Slap", "URL alınamadı",3) end
    end); y = y + 46

    makeContentButton("Cartola Hub", y, function()
        local code = safeHttpGet("https://raw.githubusercontent.com/Davi999z/Cartola-Hub/refs/heads/main/Brookhaven")
        if code then loadstring(code)() notify("Cartola", "Çalıştırıldı",2) else notify("Cartola", "URL alınamadı",3) end
    end); y = y + 46

    makeContentButton("Untitled game loader", y, function()
        local code = safeHttpGet("https://raw.githubusercontent.com/nAlwspa/Into/refs/heads/main/Loader")
        if code then loadstring(code)() notify("Untitled", "Çalıştırıldı",2) else notify("Untitled", "URL alınamadı",3) end
    end); y = y + 46

    makeContentButton("Fling Thing And People", y, function()
        local code = safeHttpGet("https://raw.githubusercontent.com/BlizTBr/scripts/main/FTAP.lua")
        if code then loadstring(code)() notify("FTAP", "Çalıştırıldı",2) else notify("FTAP", "URL alınamadı",3) end
    end); y = y + 46
end

local function showSystemCategory()
    local y = 10
    local function addSys(name, url)
        makeContentButton(name, y, function()
            local ok, err = pcall(function()
                local code = safeHttpGet(url)
                if not code then error("Script alınamadı") end
                loadstring(code)()
            end)
            if ok then
                notify(name, "Script Yüklendi", 2)
            else
                notify("Hata", tostring(err), 3)
            end
        end)
        y = y + 46
    end

    -- Eskiden olan System Scriptleri
    addSys("System Chat", "https://pastebin.com/raw/yHKEz3pT")
    addSys("Free Gamepass Giver", "https://raw.githubusercontent.com/BaconBossScript/Crazy/main/Crazy")
    addSys("Auto Piano", "https://raw.githubusercontent.com/TribalFootball/Pandahub-on-crack/refs/heads/main/Choose")
    addSys("Wallhop V4", "https://raw.githubusercontent.com/ScpGuest666/Random-Roblox-script/refs/heads/main/Roblox%20WallHop%20V4%20script")
    addSys("Dex Explorer", "https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt")
    addSys("Aimbot", "https://raw.githubusercontent.com/Joshingtonn123/JoshScript/refs/heads/main/SyrexhubSniperOrDie")
    addSys("Free Private Server", "https://rawscripts.net/raw/Universal-Script-FREE-PRIVATE-SERVER-GUI-ANY-GAME-55939")
    addSys("NPC Panel", "https://raw.githubusercontent.com/randomstring0/fe-source/refs/heads/main/NPC/source/main.Luau")

    -- Yeni eklenen System Scriptleri
    addSys("Axur Bypasser v2", "https://rawscripts.net/raw/Universal-Script-Axur-Bypasser-V2-48316")
    addSys("Fling GUI", "https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt")
    addSys("PS (Private Server GUI)", "https://gist.githubusercontent.com/Tesker-103/ed48b3ae8120b0c040584b661cbda063/ra/210408b3f107dc740a4c9b832bfa647f92aa25d1/FreePrivateServerGUI")
    addSys("FE Sound [Brookhaven]", "https://raw.githubusercontent.com/nmalka01/nmalka01/refs/heads/main/Brookhaven_audio")
    addSys("Ghosthub Chat Translate", "https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/Translator")
addSys("Player sniper", 
"https://raw.githubusercontent.com/Guest3D/ZirconHub/refs/heads/main/StreamSniper.lua") 
makeContentButton("Audio Tester", y, function()  
-- Services
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

-- Player
local player = Players.LocalPlayer

-- Remove old GUI if exists
if game.CoreGui:FindFirstChild("MusicGUI") then
    game.CoreGui.MusicGUI:Destroy()
end

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "MusicGUI"
gui.Parent = game.CoreGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 260, 0, 150)
frame.Position = UDim2.new(0.5, -130, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0

-- Title
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🎵 Music Player"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- TextBox
local textbox = Instance.new("TextBox")
textbox.Parent = frame
textbox.PlaceholderText = "Music ID gir"
textbox.Size = UDim2.new(1, -20, 0, 35)
textbox.Position = UDim2.new(0, 10, 0, 40)
textbox.BackgroundColor3 = Color3.fromRGB(50,50,50)
textbox.TextColor3 = Color3.new(1,1,1)
textbox.Font = Enum.Font.Gotham
textbox.TextSize = 14
textbox.ClearTextOnFocus = false
textbox.BorderSizePixel = 0

-- Play Button
local playBtn = Instance.new("TextButton")
playBtn.Parent = frame
playBtn.Size = UDim2.new(0.45, 0, 0, 35)
playBtn.Position = UDim2.new(0.05, 0, 0, 90)
playBtn.Text = "▶ Play"
playBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
playBtn.TextColor3 = Color3.new(1,1,1)
playBtn.Font = Enum.Font.GothamBold
playBtn.TextSize = 14
playBtn.BorderSizePixel = 0

-- Stop Button
local stopBtn = Instance.new("TextButton")
stopBtn.Parent = frame
stopBtn.Size = UDim2.new(0.45, 0, 0, 35)
stopBtn.Position = UDim2.new(0.5, 0, 0, 90)
stopBtn.Text = "⏹ Stop"
stopBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14
stopBtn.BorderSizePixel = 0

-- Sound
local sound = Instance.new("Sound")
sound.Parent = SoundService
sound.Volume = 1
sound.Looped = true

-- Play function
playBtn.MouseButton1Click:Connect(function()
    local id = textbox.Text
    if id ~= "" then
        sound.SoundId = "rbxassetid://" .. id
        sound:Play()
    end
end)

-- Stop function
stopBtn.MouseButton1Click:Connect(function()
    sound:Stop()
end)
end) 
y = y + 46
 end

local function showAnimCategory()
    local y = 10
    local function addAnim(name, url)
        makeContentButton(name, y, function()
            local ok, err = pcall(function()
                local code = safeHttpGet(url)
                if not code then error("Script alınamadı") end
                loadstring(code)()
            end)
            if ok then
                notify(name, "Script Yüklendi", 2)
            else
                notify("Hata", tostring(err), 3)
            end
        end)
        y = y + 46
    end

    -- Eski Animation Scriptleri
    addAnim("AquaMatrix Animation", "https://raw.githubusercontent.com/ExploitFin/AquaMatrix/refs/heads/AquaMatrix/AquaMatrix")
    addAnim("Fe Zombie", "https://pastefy.app/JOWniO6o/raw")
    addAnim("Fe Noli", "https://raw.githubusercontent.com/randomstring0/Qwerty/refs/heads/main/qwerty65.lua")
    addAnim("Fe Slasher (complex)", "https://pastebin.com/raw/pzxK2xx7") -- eski local script için notify
    addAnim("Ban Hammer", "https://pastebin.com/raw/zGhJpZcg")
    addAnim("Server Admin", "https://raw.githubusercontent.com/gObl00x/Pendulum-Fixed-AND-Others-Scripts/refs/heads/main/Server%20Admin")
    addAnim("Caducus", "https://rawscripts.net/raw/Universal-Script-Caducus-the-fallen-god-script-53019")
    addAnim("Backflip & Frontflip", "https://rawscripts.net/raw/Universal-Script-Universal-Frontflip-and-Backflip-Tools-47199")
    addAnim("Goner", "https://rawscripts.net/raw/Universal-Script-Goner-47954")
    addAnim("Spectrum Glitcher", "https://rawscripts.net/raw/Universal-Script-Spectrum-Glitcher-47547")
    addAnim("Sit GUI", "https://rawscripts.net/raw/Universal-Script-Sit-gui-51529")
    addAnim("Xester-v1", "https://rawscripts.net/raw/Universal-Script-Xester-V1-46145")
    addAnim("Xester-Astra", "https://rawscripts.net/raw/Universal-Script-Xester-astra-44171")
    addAnim("Xester-Monster", "https://rawscripts.net/raw/Universal-Script-Roblox-VEREUS-monster-script-3746")
    addAnim("fe guest 666", "https://rawscripts.net/raw/Universal-Script-Fe-Guest-666-Only-anims-are-fe-53309")
    addAnim("bluudud", "https://pastebin.com/raw/CcHxT0Gj")
    addAnim("Pandora fe", "https://rawscripts.net/raw/Universal-Script-Pandora-Fe-55559")
    addAnim("Forsaken C00lkidd", "https://rawscripts.net/raw/Universal-Script-FE-C00lKidd-Forsaken-UNIVERSAL-FOR-R6-44107")
    addAnim("forsaken john doe", "https://rawscripts.net/raw/Universal-Script-forsaken-cript-builder-john-doe-script-40004")
    addAnim("ultra john doe", "https://rawscripts.net/raw/Client-Replication-ULTRA-JOHN-DOE-39837")
    addAnim("LOL dance", "https://raw.githubusercontent.com/L0OLKIDD0/K1ng-dance/refs/heads/main/K1NG%20dance")
    addAnim("FE Epik Dancezz Animation", "https://rawscripts.net/raw/Universal-Script-Epik-R6-Dancezz-42246")
    addAnim("Fake VR v3", "https://raw.githubusercontent.com/randomstring0/Qwerty/refs/heads/main/qwerty45.lua")
    addAnim("Invincible Fly", "https://rawscripts.net/raw/Universal-Script-Invinicible-Flight-R15-45414")
    addAnim("PASALP Dance GUI", "https://pastebin.com/LgNgXu15")
addAnim("Serapic Blade", 
"https://pastefy.app/59mJGQGe/raw") 
addAnim("Uhhhhhh reanimate", 
"https://raw.githubusercontent.com/STEVE-916-create/Uhhhhhh/main/source/reanim.lua")
end

local function showFunCategory()
    local y = 10

    local function addFun(name, url)
        makeContentButton(name, y, function()
            local code = safeHttpGet(url)
            if code then
                loadstring(code)()
                notify(name, "Çalıştırıldı", 2)
            else
                notify("Hata", "Script alınamadı", 3)
            end
        end)
        y = y + 46
    end

    addFun("Kidnap", "https://pastebin.com/raw/vP2D2vnC")
    addFun("FE John Doe", "https://rawscripts.net/raw/Universal-Script-John-Doe-Script-46855")
    addFun("Grab Knife", "https://rawscripts.net/raw/Universal-Script-Grab-knife-v4-24753")
    addFun("Gun", "https://pastefy.app/xxRyJ8xN/raw")
    addFun("No FE Snake", "https://raw.githubusercontent.com/Avtor1zaTion/NO-FE-SNAKE/refs/heads/main/NO-FE-Snake.txt")
    addFun("Fe Sin Dragon", "https://pastebin.com/raw/2aRWmwRF")
    addFun("Flash", "https://pastefy.app/hUB1FSPB/raw")
    addFun("Time Stop", "https://pastebin.com/raw/pzxK2xx7")
    addFun("Gojo", "https://rawscripts.net/raw/Universal-Script-Gojo-21950")
    addFun("MLG Gun", "https://gist.githubusercontent.com/zupersponge/8c39ed77f2817679294d70aff18d479d/raw/ed5e04b72c4fa77b8bf522d7275abf64ae585416/MLG%2520Gun%2520Script%2520ROBLOX")
    addFun("Fe Big Hand", "https://raw.githubusercontent.com/ian49972/SCRIPTS/refs/heads/main/hand")
    addFun("Raining Tacos v1", "https://pastebin.com/raw/D0yLFy5Y")
    addFun("Raining Tacos v2", "https://pastebin.com/raw/Yx05z4L5")
    addFun("Hacker X", "https://raw.githubusercontent.com/ian49972/SCRIPTS/refs/heads/main/Hacker%20X")
    addFun("No More Games", "https://raw.githubusercontent.com/L0OLKIDD0/No-more-games-tool/refs/heads/main/No%20more%20games%20tool")
    addFun("John Doe Eyes Effect", "https://raw.githubusercontent.com/L0OLKIDD0/John-doe-eyes-effect/refs/heads/main/John%20doe%20eyes%20effect")
addFun("Anime Jumpscare",
"https://rawscripts.net/raw/Universal-Script-Sadrc7-anime-jumpscare-102478")
makeContentButton("Orbit controller ", y, function()
--// MODE + SPEED + SPIN + ORBIT + ESP (FINAL FIXED)

if game.CoreGui:FindFirstChild("ModeSpeedSpinGUI") then
    game.CoreGui.ModeSpeedSpinGUI:Destroy()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

--------------------------------------------------
-- CHAT
--------------------------------------------------
local function sendChat(msg)
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local ch = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if ch then ch:SendAsync(msg) end
    else
        ReplicatedStorage.DefaultChatSystemChatEvents
            .SayMessageRequest:FireServer(msg, "All")
    end
end

--------------------------------------------------
-- GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "ModeSpeedSpinGUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 330, 0, 420)
main.Position = UDim2.new(0.5,-165,0.5,-210)
main.BackgroundColor3 = Color3.fromRGB(20,20,28)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

--------------------------------------------------
-- TITLE
--------------------------------------------------
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,28)
title.BackgroundTransparency = 1
title.Text = "MODE / SPEED / SPIN / ORBIT"
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextColor3 = Color3.fromRGB(0,200,255)

--------------------------------------------------
-- MODE 1–12
--------------------------------------------------
local modeFrame = Instance.new("Frame", main)
modeFrame.Position = UDim2.new(0,10,0,35)
modeFrame.Size = UDim2.new(1,-20,0,110)
modeFrame.BackgroundTransparency = 1

local grid = Instance.new("UIGridLayout", modeFrame)
grid.CellSize = UDim2.new(0,70,0,26)
grid.CellPadding = UDim2.new(0,6,0,6)

for i = 1,12 do
    local b = Instance.new("TextButton", modeFrame)
    b.Text = ".mode "..i
    b.Font = Enum.Font.Gotham
    b.TextSize = 11
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(45,45,60)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    b.MouseButton1Click:Connect(function()
        sendChat(".mode "..i)
    end)
end

--------------------------------------------------
-- ANNOY / UNANNOY
--------------------------------------------------
local annoy = Instance.new("TextButton", main)
annoy.Text = ".annoy"
annoy.Position = UDim2.new(0,10,0,150)
annoy.Size = UDim2.new(0,150,0,26)
annoy.BackgroundColor3 = Color3.fromRGB(200,80,80)
annoy.TextColor3 = Color3.new(1,1,1)
annoy.Font = Enum.Font.GothamBold
annoy.TextSize = 11
Instance.new("UICorner", annoy).CornerRadius = UDim.new(0,6)
annoy.MouseButton1Click:Connect(function()
    sendChat(".annoy")
end)

local unannoy = Instance.new("TextButton", main)
unannoy.Text = ".unannoy"
unannoy.Position = UDim2.new(0,170,0,150)
unannoy.Size = UDim2.new(0,150,0,26)
unannoy.BackgroundColor3 = Color3.fromRGB(80,200,120)
unannoy.TextColor3 = Color3.new(1,1,1)
unannoy.Font = Enum.Font.GothamBold
unannoy.TextSize = 11
Instance.new("UICorner", unannoy).CornerRadius = UDim.new(0,6)
unannoy.MouseButton1Click:Connect(function()
    sendChat(".unannoy")
end)

--------------------------------------------------
-- ORBIT ME (CHAT)
--------------------------------------------------
local orbitMe = Instance.new("TextButton", main)
orbitMe.Text = ".orbit me"
orbitMe.Position = UDim2.new(0,10,0,180)
orbitMe.Size = UDim2.new(1,-20,0,26)
orbitMe.BackgroundColor3 = Color3.fromRGB(120,90,200)
orbitMe.TextColor3 = Color3.new(1,1,1)
orbitMe.Font = Enum.Font.GothamBold
orbitMe.TextSize = 11
Instance.new("UICorner", orbitMe).CornerRadius = UDim.new(0,6)
orbitMe.MouseButton1Click:Connect(function()
    sendChat(".orbit me")
end)

--------------------------------------------------
-- SPEED
--------------------------------------------------
local speedBox = Instance.new("TextBox", main)
speedBox.PlaceholderText = "Speed"
speedBox.Position = UDim2.new(0,10,0,215)
speedBox.Size = UDim2.new(0,150,0,26)
speedBox.BackgroundColor3 = Color3.fromRGB(35,35,50)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 11
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0,6)

local speedGo = Instance.new("TextButton", main)
speedGo.Text = "Go"
speedGo.Position = UDim2.new(0,170,0,215)
speedGo.Size = UDim2.new(0,50,0,26)
speedGo.BackgroundColor3 = Color3.fromRGB(0,120,200)
speedGo.TextColor3 = Color3.new(1,1,1)
speedGo.Font = Enum.Font.GothamBold
speedGo.TextSize = 11
Instance.new("UICorner", speedGo).CornerRadius = UDim.new(0,6)
speedGo.MouseButton1Click:Connect(function()
    if tonumber(speedBox.Text) then
        sendChat(".speed "..speedBox.Text)
    end
end)

--------------------------------------------------
-- SPIN
--------------------------------------------------
local spinBox = Instance.new("TextBox", main)
spinBox.PlaceholderText = "Spin"
spinBox.Position = UDim2.new(0,10,0,250)
spinBox.Size = UDim2.new(0,150,0,26)
spinBox.BackgroundColor3 = Color3.fromRGB(35,35,50)
spinBox.TextColor3 = Color3.new(1,1,1)
spinBox.Font = Enum.Font.Gotham
spinBox.TextSize = 11
Instance.new("UICorner", spinBox).CornerRadius = UDim.new(0,6)

local spinConn
local function stopSpin()
    if spinConn then spinConn:Disconnect() spinConn=nil end
end
local function startSpin(v)
    stopSpin()
    spinConn = RunService.RenderStepped:Connect(function()
        local c = LocalPlayer.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            c.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(v), 0)
        end
    end)
end

local spinGo = Instance.new("TextButton", main)
spinGo.Text = "Go"
spinGo.Position = UDim2.new(0,170,0,250)
spinGo.Size = UDim2.new(0,50,0,26)
spinGo.BackgroundColor3 = Color3.fromRGB(0,200,120)
spinGo.TextColor3 = Color3.new(1,1,1)
spinGo.Font = Enum.Font.GothamBold
spinGo.TextSize = 11
Instance.new("UICorner", spinGo).CornerRadius = UDim.new(0,6)
spinGo.MouseButton1Click:Connect(function()
    local v = tonumber(spinBox.Text)
    if v then
        if v == 0 then stopSpin() else startSpin(v) end
    end
end)

local spinReset = Instance.new("TextButton", main)
spinReset.Text = "Reset"
spinReset.Position = UDim2.new(0,230,0,250)
spinReset.Size = UDim2.new(0,80,0,26)
spinReset.BackgroundColor3 = Color3.fromRGB(120,120,120)
spinReset.TextColor3 = Color3.new(1,1,1)
spinReset.Font = Enum.Font.GothamBold
spinReset.TextSize = 11
Instance.new("UICorner", spinReset).CornerRadius = UDim.new(0,6)

spinReset.MouseButton1Click:Connect(function()
    spinBox.Text = "0"
    stopSpin()
end)

local speedReset = Instance.new("TextButton", main)
speedReset.Text = "Reset"
speedReset.Position = UDim2.new(0,230,0,215)
speedReset.Size = UDim2.new(0,80,0,26)
speedReset.BackgroundColor3 = Color3.fromRGB(120,120,120)
speedReset.TextColor3 = Color3.new(1,1,1)
speedReset.Font = Enum.Font.GothamBold
speedReset.TextSize = 11
Instance.new("UICorner", speedReset).CornerRadius = UDim.new(0,6)

speedReset.MouseButton1Click:Connect(function()
    speedBox.Text = ""
    sendChat(".speed 1")
end)

--------------------------------------------------
-- ESP + CLICK ORBIT (TEK KİŞİ)
--------------------------------------------------
local currentHighlight
local function setESP(character)
    if currentHighlight then
        currentHighlight:Destroy()
        currentHighlight = nil
    end
    if character then
        local h = Instance.new("Highlight")
        h.FillTransparency = 1
        h.OutlineColor = Color3.fromRGB(0,255,120)
        h.Parent = character
        currentHighlight = h
    end
end

local mouse = LocalPlayer:GetMouse()
mouse.Button1Down:Connect(function()
    local target = mouse.Target
    if not target then return end
    local model = target:FindFirstAncestorOfClass("Model")
    local hum = model and model:FindFirstChildOfClass("Humanoid")
    local plr = hum and Players:GetPlayerFromCharacter(model)
    if plr and plr ~= LocalPlayer then
        sendChat(".orbit "..plr.Name)
        setESP(model)
    end
end)

--------------------------------------------------
-- SOUND TOGGLE BUTTON
--------------------------------------------------
local sound = Instance.new("Sound", SoundService)
sound.SoundId = "rbxassetid://82696338249251"
sound.Volume = 1
sound.Looped = true

local soundOn = false
local soundBtn = Instance.new("TextButton", main)
soundBtn.Text = "Sound OFF"
soundBtn.Position = UDim2.new(0,10,0,285)
soundBtn.Size = UDim2.new(0,150,0,26)
soundBtn.BackgroundColor3 = Color3.fromRGB(90,90,90)
soundBtn.TextColor3 = Color3.new(1,1,1)
soundBtn.Font = Enum.Font.GothamBold
soundBtn.TextSize = 11
Instance.new("UICorner", soundBtn).CornerRadius = UDim.new(0,6)

soundBtn.MouseButton1Click:Connect(function()
    soundOn = not soundOn
    if soundOn then
        sound:Play()
        soundBtn.Text = "Sound ON"
        soundBtn.BackgroundColor3 = Color3.fromRGB(0,180,120)
    else
        sound:Stop()
        soundBtn.Text = "Sound OFF"
        soundBtn.BackgroundColor3 = Color3.fromRGB(90,90,90)
    end
end) 
end)
y = y + 46
addFun("Orbit OP",
"https://rawscripts.net/raw/UP-Just-a-baseplate.-Crystal-Hat-Orbit-Modded-BY-NXRB1-75017")
end

addLeftButton("Main", 0, showMainCategory)
addLeftButton("Hub's", 50, showHubsCategory)
addLeftButton("Tower games", 100, showGamesCategory)
addLeftButton("System", 150, showSystemCategory)
addLeftButton("Animation,s", 200, showAnimCategory)
addLeftButton("Fun", 250, showFunCategory)

clearContent()
showMainCategory()

print("PASALP HUB Yüklendi ✅")
notify("PASALP HUB", "Yüklendi", 2)
