local Kavo = {}

local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")

local Utility = {}
local Objects = {}

function Kavo:DraggingEnabled(frame, parent)
    parent = parent or frame
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(inputObj)
        if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = inputObj.Position
            framePos = parent.Position
            
            inputObj.Changed:Connect(function()
                if inputObj.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(inputObj)
        if inputObj.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = inputObj
        end
    end)

    input.InputChanged:Connect(function(inputObj)
        if inputObj == dragInput and dragging then
            local delta = inputObj.Position - mousePos
            parent.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

function Utility:TweenObject(obj, properties, duration, ...)
    tween:Create(obj, tweeninfo(duration, ...), properties):Play()
end

local M3Light = {
    SchemeColor = Color3.fromRGB(103, 80, 164),
    Background = Color3.fromRGB(255, 251, 254),
    Header = Color3.fromRGB(245, 240, 249), 
    TextColor = Color3.fromRGB(28, 27, 31),
    ElementColor = Color3.fromRGB(234, 221, 255),
    ElementHoverColor = Color3.fromRGB(220, 205, 245),
    OnElementColor = Color3.fromRGB(70, 50, 130),

    colorPrimary = Color3.fromRGB(103, 80, 164),
    colorOnPrimary = Color3.fromRGB(255, 255, 255),
    colorPrimaryContainer = Color3.fromRGB(234, 221, 255),
    colorOnPrimaryContainer = Color3.fromRGB(70, 50, 130),

    colorSecondary = Color3.fromRGB(98, 91, 113),
    colorOnSecondary = Color3.fromRGB(255, 255, 255),

    colorTertiaryContainer = Color3.fromRGB(255, 218, 228),
    colorOnTertiaryContainer = Color3.fromRGB(55, 11, 30),

    colorSurface = Color3.fromRGB(255, 251, 254),
    colorOnSurface = Color3.fromRGB(28, 27, 31),
    colorSurfaceVariant = Color3.fromRGB(231, 224, 236),
    colorOnSurfaceVariant = Color3.fromRGB(73, 69, 79),
    colorOutline = Color3.fromRGB(121, 116, 126),
    colorScrim = Color3.fromRGB(0,0,0)
}

local M3Dark = {
    SchemeColor = Color3.fromRGB(208, 188, 255),
    Background = Color3.fromRGB(28, 27, 31),
    Header = Color3.fromRGB(50, 47, 55), 
    TextColor = Color3.fromRGB(230, 225, 229),
    ElementColor = Color3.fromRGB(79, 55, 139),
    ElementHoverColor = Color3.fromRGB(95, 70, 155),
    OnElementColor = Color3.fromRGB(234, 221, 255),

    colorPrimary = Color3.fromRGB(208, 188, 255),
    colorOnPrimary = Color3.fromRGB(56, 30, 114),
    colorPrimaryContainer = Color3.fromRGB(79, 55, 139),
    colorOnPrimaryContainer = Color3.fromRGB(234, 221, 255),

    colorSecondary = Color3.fromRGB(204, 194, 220),
    colorOnSecondary = Color3.fromRGB(51, 43, 65),

    colorTertiaryContainer = Color3.fromRGB(99, 59, 72),
    colorOnTertiaryContainer = Color3.fromRGB(255, 218, 228),

    colorSurface = Color3.fromRGB(28, 27, 31),
    colorOnSurface = Color3.fromRGB(230, 225, 229),
    colorSurfaceVariant = Color3.fromRGB(73, 69, 79),
    colorOnSurfaceVariant = Color3.fromRGB(202, 196, 208),
    colorOutline = Color3.fromRGB(147, 143, 153),
    colorScrim = Color3.fromRGB(0,0,0)
}

local themes = {
    Default = M3Light,
    MaterialLightTheme = M3Light,
    MaterialDarkTheme = M3Dark
}

local SettingsT = {}
local Name = "KavoConfig_M3.JSON"

pcall(function()
    if not pcall(function() readfile(Name) end) then
        writefile(Name, game:GetService('HttpService'):JSONEncode(SettingsT))
    end
    Settings = game:GetService('HttpService'):JSONDecode(readfile(Name))
end)

local LibName = "KavoLib_M3_" .. tostring(math.random(1, 10000))

function Kavo:ToggleUI()
    if game.CoreGui:FindFirstChild(LibName) then
        game.CoreGui[LibName].Enabled = not game.CoreGui[LibName].Enabled
    end
end

function Kavo.CreateLib(kavName, themeChoice)
    local themeList
    if type(themeChoice) == "string" and themes[themeChoice] then
        themeList = themes[themeChoice]
    elseif type(themeChoice) == "table" then
        themeList = themeChoice 
    else
        themeList = themes.Default
    end

    kavName = kavName or "Library"
    
    if game.CoreGui:FindFirstChild(LibName) then
        game.CoreGui[LibName]:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner")
    local MainHeader = Instance.new("Frame")
    local title = Instance.new("TextLabel")
    local close = Instance.new("ImageButton")
    local MainSide = Instance.new("Frame")
    local tabFrames = Instance.new("Frame")
    local tabListing = Instance.new("UIListLayout")
    local pages = Instance.new("Frame")
    local Pages = Instance.new("Folder")
    local infoContainer = Instance.new("Frame")
    local blurFrame = Instance.new("Frame")

    Kavo:DraggingEnabled(MainHeader, Main)

    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = LibName
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = themeList.Background
    Main.ClipsDescendants = true
    Main.Position = UDim2.new(0.5, -287, 0.5, -180) 
    Main.Size = UDim2.new(0, 575, 0, 360) 
    Main.BorderSizePixel = 1
    Main.BorderColor3 = themeList.colorOutline

    MainCorner.CornerRadius = UDim.new(0, 28)
    MainCorner.Parent = Main

    MainHeader.Name = "MainHeader"
    MainHeader.Parent = Main
    MainHeader.BackgroundColor3 = themeList.Header
    MainHeader.Size = UDim2.new(1, 0, 0, 40)
    MainHeader.BorderSizePixel = 0

    title.Name = "title"
    title.Parent = MainHeader
    title.BackgroundTransparency = 1.000
    title.Position = UDim2.new(0.03, 0, 0, 0)
    title.Size = UDim2.new(0.8, 0, 1, 0)
    title.Font = Enum.Font.GothamBold
    title.Text = kavName
    title.TextColor3 = themeList.colorOnSurfaceVariant
    title.TextSize = 18.000
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Center

    close.Name = "close"
    close.Parent = MainHeader
    close.BackgroundTransparency = 1.000
    close.Position = UDim2.new(1, -35, 0.5, -12)
    close.Size = UDim2.new(0, 24, 0, 24)
    close.ZIndex = 2
    close.Image = "rbxassetid://3926305904" 
    close.ImageColor3 = themeList.colorOnSurfaceVariant
    close.ImageRectOffset = Vector2.new(284, 4)
    close.ImageRectSize = Vector2.new(24, 24)
    close.MouseButton1Click:Connect(function()
        Utility:TweenObject(Main, {Size = UDim2.new(0,0,0,0), Position = Main.Position + UDim2.fromOffset(Main.AbsoluteSize.X / 2, Main.AbsoluteSize.Y / 2), Transparency = 1}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        task.wait(0.2)
        ScreenGui:Destroy()
    end)

    MainSide.Name = "MainSide"
    MainSide.Parent = Main
    MainSide.BackgroundColor3 = themeList.Header
    MainSide.Position = UDim2.new(0, 0, 0, 40)
    MainSide.Size = UDim2.new(0, 160, 1, -40)
    MainSide.BorderSizePixel = 0
    
    local SideRightBorder = Instance.new("Frame")
    SideRightBorder.Parent = MainSide
    SideRightBorder.BackgroundColor3 = themeList.colorOutline
    SideRightBorder.BorderSizePixel = 0
    SideRightBorder.Position = UDim2.new(1, -1, 0, 0)
    SideRightBorder.Size = UDim2.new(0, 1, 1, 0)


    tabFrames.Name = "tabFrames"
    tabFrames.Parent = MainSide
    tabFrames.BackgroundTransparency = 1.000
    tabFrames.Position = UDim2.new(0, 8, 0, 8)
    tabFrames.Size = UDim2.new(1, -16, 1, -16)

    tabListing.Name = "tabListing"
    tabListing.Parent = tabFrames
    tabListing.SortOrder = Enum.SortOrder.LayoutOrder
    tabListing.Padding = UDim.new(0, 6)

    pages.Name = "pages"
    pages.Parent = Main
    pages.BackgroundTransparency = 1.000
    pages.BorderSizePixel = 0
    pages.Position = UDim2.new(0, 160, 0, 40)
    pages.Size = UDim2.new(1, -160, 1, -40 - 40) 

    Pages.Name = "Pages"
    Pages.Parent = pages
    
    blurFrame.Name = "blurFrame"
    blurFrame.Parent = ScreenGui 
    blurFrame.BackgroundColor3 = themeList.colorScrim
    blurFrame.BackgroundTransparency = 1 
    blurFrame.BorderSizePixel = 0
    blurFrame.Size = UDim2.new(1,0,1,0)
    blurFrame.ZIndex = Main.ZIndex - 1 
    blurFrame.Visible = false


    infoContainer.Name = "infoContainer"
    infoContainer.Parent = Main
    infoContainer.BackgroundTransparency = 1.000
    infoContainer.ClipsDescendants = true
    infoContainer.Position = UDim2.new(0, 160, 1, -40) 
    infoContainer.Size = UDim2.new(1, -160, 0, 40)
    infoContainer.ZIndex = Main.ZIndex + 10

    local InfoContainerBottomBorder = Instance.new("Frame")
    InfoContainerBottomBorder.Parent = infoContainer
    InfoContainerBottomBorder.BackgroundColor3 = themeList.colorOutline
    InfoContainerBottomBorder.BorderSizePixel = 0
    InfoContainerBottomBorder.Position = UDim2.new(0,0,0,0)
    InfoContainerBottomBorder.Size = UDim2.new(1,0,0,1)


    coroutine.wrap(function()
        while task.wait() do
            if not ScreenGui or not ScreenGui.Parent then break end
            Main.BackgroundColor3 = themeList.Background
            Main.BorderColor3 = themeList.colorOutline
            MainHeader.BackgroundColor3 = themeList.Header
            title.TextColor3 = themeList.colorOnSurfaceVariant
            close.ImageColor3 = themeList.colorOnSurfaceVariant
            MainSide.BackgroundColor3 = themeList.Header
            SideRightBorder.BackgroundColor3 = themeList.colorOutline
            InfoContainerBottomBorder.BackgroundColor3 = themeList.colorOutline
            blurFrame.BackgroundColor3 = themeList.colorScrim
        end
    end)()

    function Kavo:ChangeColor(propName, color)
        if themeList[propName] then
            themeList[propName] = color
        else
            warn("Kavo UI: Property " .. propName .. " not found in current theme.")
        end
    end
    
    local Tabs = {}
    local firstTab = true

    function Tabs:NewTab(tabName)
        tabName = tabName or "Tab"
        local tabButton = Instance.new("TextButton")
        local UICorner = Instance.new("UICorner")
        local page = Instance.new("ScrollingFrame")
        local pageListing = Instance.new("UIListLayout")
        local UIPadding = Instance.new("UIPadding")

        page.Name = "Page"
        page.Parent = Pages
        page.Active = true
        page.BackgroundColor3 = themeList.Background
        page.BorderSizePixel = 0
        page.Size = UDim2.new(1, 0, 1, 0)
        page.ScrollBarThickness = 8
        page.ScrollBarImageColor3 = themeList.colorOutline
        page.Visible = false
        page.ClipsDescendants = true

        UIPadding.Parent = page
        UIPadding.PaddingTop = UDim.new(0,8)
        UIPadding.PaddingBottom = UDim.new(0,8)
        UIPadding.PaddingLeft = UDim.new(0,12)
        UIPadding.PaddingRight = UDim.new(0,12)

        pageListing.Name = "pageListing"
        pageListing.Parent = page
        pageListing.SortOrder = Enum.SortOrder.LayoutOrder
        pageListing.Padding = UDim.new(0, 8)
        pageListing.FillDirection = Enum.FillDirection.Vertical
        pageListing.HorizontalAlignment = Enum.HorizontalAlignment.Left 

        local function UpdateCanvasSize()
            local contentHeight = pageListing.AbsoluteContentSize.Y
            page.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
        end
        
        page.ChildAdded:Connect(UpdateCanvasSize)
        page.ChildRemoved:Connect(UpdateCanvasSize)
        pageListing:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvasSize)


        tabButton.Name = tabName.."TabButton"
        tabButton.Parent = tabFrames
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.AutoButtonColor = false
        tabButton.Font = Enum.Font.GothamMedium
        tabButton.Text = tabName
        tabButton.TextSize = 14.000
        
        UICorner.CornerRadius = UDim.new(0, 20) 
        UICorner.Parent = tabButton
        table.insert(Tabs, tabName)

        local function SetActiveTabStyle()
            tabButton.BackgroundColor3 = themeList.colorPrimaryContainer
            tabButton.TextColor3 = themeList.colorOnPrimaryContainer
            page.Visible = true
            UpdateCanvasSize()
        end

        local function SetInactiveTabStyle()
            tabButton.BackgroundColor3 = Color3.new(0,0,0) 
            tabButton.BackgroundTransparency = 1
            tabButton.TextColor3 = themeList.colorOnSurfaceVariant
            page.Visible = false
        end

        if firstTab then
            firstTab = false
            SetActiveTabStyle()
        else
            SetInactiveTabStyle()
        end
        
        tabButton.MouseButton1Click:Connect(function()
            for i,v in next, Pages:GetChildren() do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            for i,v in next, tabFrames:GetChildren() do
                if v:IsA("TextButton") and v.Name:match("TabButton") then
                    Utility:TweenObject(v, { BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 1, TextColor3 = themeList.colorOnSurfaceVariant }, 0.2)
                end
            end
            Utility:TweenObject(tabButton, { BackgroundColor3 = themeList.colorPrimaryContainer, BackgroundTransparency = 0, TextColor3 = themeList.colorOnPrimaryContainer }, 0.2)
            page.Visible = true
            UpdateCanvasSize()
        end)

        coroutine.wrap(function()
            while task.wait() do
                if not ScreenGui or not ScreenGui.Parent then break end
                if not tabButton or not tabButton.Parent then break end
                
                page.BackgroundColor3 = themeList.Background
                page.ScrollBarImageColor3 = themeList.colorOutline
                
                if page.Visible then
                    tabButton.BackgroundColor3 = themeList.colorPrimaryContainer
                    tabButton.TextColor3 = themeList.colorOnPrimaryContainer
                    tabButton.BackgroundTransparency = 0
                else
                    tabButton.BackgroundColor3 = Color3.new(0,0,0)
                    tabButton.TextColor3 = themeList.colorOnSurfaceVariant
                    tabButton.BackgroundTransparency = 1
                end
            end
        end)()
    
        local Sections = {}
        local focusing = false
        local viewDe = false

        function Sections:NewSection(secName, hidden)
            secName = secName or "Section"
            local sectionFunctions = {}
            hidden = hidden or false
            
            local sectionFrame = Instance.new("Frame")
            local sectionListLayout = Instance.new("UIListLayout")
            local sectionHead = Instance.new("Frame")
            local sectionName = Instance.new("TextLabel")
            local sectionInners = Instance.new("Frame")
            local sectionElListing = Instance.new("UIListLayout")
            local sHeadCorner = Instance.new("UICorner")
            local sInnersCorner = Instance.new("UICorner")
            local sFramePadding = Instance.new("UIPadding")

            sectionFrame.Name = "sectionFrame"
            sectionFrame.Parent = page
            sectionFrame.BackgroundTransparency = 1
            sectionFrame.Size = UDim2.new(1,0,0,0) 
            sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            
            sectionListLayout.Parent = sectionFrame
            sectionListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionListLayout.Padding = UDim.new(0, 0) 
            sectionListLayout.FillDirection = Enum.FillDirection.Vertical
            sectionListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Stretch

            sectionHead.Name = "sectionHead"
            sectionHead.Parent = sectionFrame
            sectionHead.BackgroundColor3 = themeList.colorSurfaceVariant 
            sectionHead.Size = UDim2.new(1, 0, 0, 36)
            sectionHead.Visible = not hidden
            
            sHeadCorner.CornerRadius = UDim.new(0,12)
            sHeadCorner.Parent = sectionHead

            sectionName.Name = "sectionName"
            sectionName.Parent = sectionHead
            sectionName.BackgroundTransparency = 1.000
            sectionName.Position = UDim2.new(0, 12, 0, 0)
            sectionName.Size = UDim2.new(1, -24, 1, 0)
            sectionName.Font = Enum.Font.GothamMedium
            sectionName.Text = secName
            sectionName.TextColor3 = themeList.colorOnSurfaceVariant
            sectionName.TextSize = 15.000
            sectionName.TextXAlignment = Enum.TextXAlignment.Left
            sectionName.TextYAlignment = Enum.TextYAlignment.Center
               
            sectionInners.Name = "sectionInners"
            sectionInners.Parent = sectionFrame
            sectionInners.BackgroundColor3 = themeList.colorSurfaceVariant 
            sectionInners.BackgroundTransparency = 0 
            sectionInners.Size = UDim2.new(1,0,0,0) 
            sectionInners.AutomaticSize = Enum.AutomaticSize.Y
            
            sInnersCorner.CornerRadius = UDim.new(0,12)
            sInnersCorner.Parent = sectionInners

            sectionElListing.Name = "sectionElListing"
            sectionElListing.Parent = sectionInners
            sectionElListing.SortOrder = Enum.SortOrder.LayoutOrder
            sectionElListing.Padding = UDim.new(0, 6)
            sectionElListing.FillDirection = Enum.FillDirection.Vertical
            sectionElListing.HorizontalAlignment = Enum.HorizontalAlignment.Stretch
            
            sFramePadding.Parent = sectionElListing
            sFramePadding.PaddingTop = UDim.new(0,8)
            sFramePadding.PaddingBottom = UDim.new(0,8)
            sFramePadding.PaddingLeft = UDim.new(0,8)
            sFramePadding.PaddingRight = UDim.new(0,8)
            
            if hidden then
                 sectionInners.Position = UDim2.new(0,0,0,0)
                 sectionListLayout.Padding = UDim.new(0, 8) 
            else
                 sectionInners.Position = UDim2.new(0,0,0,0) 
                 sectionListLayout.Padding = UDim.new(0, 0) 
                 sFramePadding.PaddingTop = UDim.new(0,0) 
                 sectionHead.LayoutOrder = 1
                 sectionInners.LayoutOrder = 2
                 local headBottomMargin = Instance.new("Frame")
                 headBottomMargin.Name = "HeadBottomMargin"
                 headBottomMargin.Parent = sectionFrame
                 headBottomMargin.BackgroundTransparency = 1
                 headBottomMargin.Size = UDim2.new(1,0,0,8)
                 headBottomMargin.LayoutOrder = 1 
            end


            coroutine.wrap(function()
                while task.wait() do
                    if not ScreenGui or not ScreenGui.Parent then break end
                    if not sectionFrame or not sectionFrame.Parent then break end
                    sectionHead.BackgroundColor3 = themeList.colorSurfaceVariant
                    sectionName.TextColor3 = themeList.colorOnSurfaceVariant
                    sectionInners.BackgroundColor3 = themeList.colorSurfaceVariant
                end
            end)()
            
            UpdateCanvasSize()
            local Elements = {}
            function Elements:NewButton(bname,tipINf, callback)
                local ButtonFunction = {}
                tipINf = tipINf or "Button tip"
                bname = bname or "Click Me!"
                callback = callback or function() end

                local buttonElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local btnInfo = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local rippleFrame = Instance.new("Frame")
                local rippleCorner = Instance.new("UICorner")

                buttonElement.Name = bname
                buttonElement.Parent = sectionElListing
                buttonElement.BackgroundColor3 = themeList.colorPrimary
                buttonElement.ClipsDescendants = true
                buttonElement.Size = UDim2.new(1, 0, 0, 40)
                buttonElement.AutoButtonColor = false
                buttonElement.Text = ""
                
                UICorner.CornerRadius = UDim.new(0, 20) 
                UICorner.Parent = buttonElement

                btnInfo.Name = "btnInfo"
                btnInfo.Parent = buttonElement
                btnInfo.BackgroundTransparency = 1.000
                btnInfo.Size = UDim2.new(1, -40, 1, 0) 
                btnInfo.Position = UDim2.new(0,0,0,0)
                btnInfo.Font = Enum.Font.GothamMedium
                btnInfo.Text = bname
                btnInfo.TextColor3 = themeList.colorOnPrimary
                btnInfo.TextSize = 14.000
                btnInfo.TextXAlignment = Enum.TextXAlignment.Center
                btnInfo.TextYAlignment = Enum.TextYAlignment.Center
                
                viewInfo.Name = "viewInfo"
                viewInfo.Parent = buttonElement
                viewInfo.BackgroundTransparency = 1.000
                viewInfo.Position = UDim2.new(1, -32, 0.5, -11)
                viewInfo.Size = UDim2.new(0, 22, 0, 22)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://3926305904" 
                viewInfo.ImageColor3 = themeList.colorOnPrimary
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)

                rippleFrame.Name = "rippleFrame"
                rippleFrame.Parent = buttonElement
                rippleFrame.BackgroundTransparency = 1
                rippleFrame.BackgroundColor3 = themeList.colorOnPrimary 
                rippleFrame.Size = UDim2.new(0,0,0,0)
                rippleFrame.Position = UDim2.new(0.5,0,0.5,0)
                rippleFrame.AnchorPoint = Vector2.new(0.5,0.5)
                rippleFrame.ZIndex = buttonElement.ZIndex - 1
                rippleFrame.ClipsDescendants = true
                rippleCorner.CornerRadius = UDim.new(1,0)
                rippleCorner.Parent = rippleFrame

                local moreInfo = Instance.new("TextLabel")
                local tipCorner = Instance.new("UICorner")

                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = themeList.colorTertiaryContainer
                moreInfo.Position = UDim2.new(0.02, 0, 0.5, -16.5) 
                moreInfo.Size = UDim2.new(0.96, 0, 0, 33)
                moreInfo.Visible = false
                moreInfo.ZIndex = 999
                moreInfo.Font = Enum.Font.Gotham
                moreInfo.Text = "  "..tipINf
                moreInfo.TextColor3 = themeList.colorOnTertiaryContainer
                moreInfo.TextSize = 13.000
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                moreInfo.TextYAlignment = Enum.TextYAlignment.Center
                moreInfo.ClipsDescendants = true
                tipCorner.CornerRadius = UDim.new(0, 8)
                tipCorner.Parent = moreInfo

                UpdateCanvasSize()

                local hovering = false
                buttonElement.MouseEnter:Connect(function()
                    hovering = true
                    Utility:TweenObject(buttonElement, { BackgroundColor3 = themeList.ElementHoverColor }, 0.15)
                end)
                buttonElement.MouseLeave:Connect(function()
                    hovering = false
                    if not focusing then
                         Utility:TweenObject(buttonElement, { BackgroundColor3 = themeList.colorPrimary }, 0.15)
                    end
                end)
                
                buttonElement.MouseButton1Click:Connect(function()
                    if focusing then
                        for i,v in next, infoContainer:GetChildren() do
                            if v.Name == "TipMore" then v.Visible = false end
                        end
                        blurFrame.Visible = false
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        focusing = false
                        return
                    end

                    callback()
                    rippleFrame.Size = UDim2.new(0,0,0,0)
                    rippleFrame.BackgroundTransparency = 0.7
                    local mouseLocation = buttonElement.AbsolutePosition - input:GetMouseLocation()
                    rippleFrame.Position = UDim2.fromOffset(-mouseLocation.X, -mouseLocation.Y)
                    
                    local targetSize = math.max(buttonElement.AbsoluteSize.X, buttonElement.AbsoluteSize.Y) * 2
                    Utility:TweenObject(rippleFrame, {Size = UDim2.new(0,targetSize,0,targetSize), BackgroundTransparency = 1}, 0.4, Enum.EasingStyle.Linear)
                end)

                viewInfo.MouseButton1Click:Connect(function()
                    if viewDe then return end
                    viewDe = true
                    focusing = true
                    for i,v in next, infoContainer:GetChildren() do
                        if v.Name == "TipMore" and v ~= moreInfo then v.Visible = false end
                    end
                    moreInfo.Visible = true
                    blurFrame.Visible = true
                    Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                    Utility:TweenObject(buttonElement, { BackgroundColor3 = themeList.ElementHoverColor }, 0.15)
                    
                    task.delay(2, function()
                        if focusing and moreInfo.Visible then
                            moreInfo.Visible = false
                            blurFrame.Visible = false
                            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                            Utility:TweenObject(buttonElement, { BackgroundColor3 = themeList.colorPrimary }, 0.15)
                            focusing = false
                        end
                        viewDe = false
                    end)
                end)
                
                coroutine.wrap(function()
                    while task.wait() do
                        if not ScreenGui or not ScreenGui.Parent then break end
                        if not buttonElement or not buttonElement.Parent then break end
                        if not hovering and not focusing then
                            buttonElement.BackgroundColor3 = themeList.colorPrimary
                        elseif hovering and not focusing then
                             buttonElement.BackgroundColor3 = themeList.ElementHoverColor
                        end
                        btnInfo.TextColor3 = themeList.colorOnPrimary
                        viewInfo.ImageColor3 = themeList.colorOnPrimary
                        rippleFrame.BackgroundColor3 = themeList.colorOnPrimary
                        moreInfo.BackgroundColor3 = themeList.colorTertiaryContainer
                        moreInfo.TextColor3 = themeList.colorOnTertiaryContainer
                    end
                end)()
                
                function ButtonFunction:UpdateButton(newTitle)
                    btnInfo.Text = newTitle
                end
                return ButtonFunction
            end

            function Elements:NewTextBox(tname, tTip, defaultText, callback)
                tname = tname or "Textbox"
                tTip = tTip or "Input text here"
                callback = callback or function() end
                defaultText = defaultText or ""

                local textboxContainer = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local TextBox = Instance.new("TextBox")
                local boxCorner = Instance.new("UICorner")
                local textLabel = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")

                textboxContainer.Name = "textboxContainer"
                textboxContainer.Parent = sectionElListing
                textboxContainer.BackgroundColor3 = themeList.colorSurface
                textboxContainer.Size = UDim2.new(1, 0, 0, 56) 
                textboxContainer.ClipsDescendants = true
                
                UICorner.CornerRadius = UDim.new(0, 8)
                UICorner.Parent = textboxContainer
                
                textLabel.Name = "textLabel"
                textLabel.Parent = textboxContainer
                textLabel.BackgroundTransparency = 1
                textLabel.Font = Enum.Font.Gotham
                textLabel.Text = tname
                textLabel.TextColor3 = themeList.colorOnSurfaceVariant
                textLabel.TextSize = 12
                textLabel.TextXAlignment = Enum.TextXAlignment.Left
                textLabel.Position = UDim2.new(0, 12, 0, 6)
                textLabel.Size = UDim2.new(1, -48, 0, 16)

                TextBox.Name = "InputBox"
                TextBox.Parent = textboxContainer
                TextBox.BackgroundColor3 = themeList.colorSurface 
                TextBox.BorderSizePixel = 1
                TextBox.BorderColor3 = themeList.colorOutline
                TextBox.Position = UDim2.new(0, 12, 0, 24)
                TextBox.Size = UDim2.new(1, -56, 0, 28) 
                TextBox.Font = Enum.Font.Gotham
                TextBox.Text = defaultText
                TextBox.PlaceholderText = "Type here..."
                TextBox.PlaceholderColor3 = themeList.colorOnSurfaceVariant
                TextBox.TextColor3 = themeList.colorOnSurface
                TextBox.TextSize = 14.000
                TextBox.ClearTextOnFocus = false
                TextBox.ClipsDescendants = true

                boxCorner.CornerRadius = UDim.new(0,4)
                boxCorner.Parent = TextBox
                
                viewInfo.Name = "viewInfo"
                viewInfo.Parent = textboxContainer
                viewInfo.BackgroundTransparency = 1.000
                viewInfo.Position = UDim2.new(1, -32, 0.5, -11)
                viewInfo.Size = UDim2.new(0, 22, 0, 22)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.colorSecondary
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)

                local moreInfo = Instance.new("TextLabel")
                local tipCorner = Instance.new("UICorner")

                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = themeList.colorTertiaryContainer
                moreInfo.Position = UDim2.new(0.02, 0, 0.5, -16.5)
                moreInfo.Size = UDim2.new(0.96, 0, 0, 33)
                moreInfo.Visible = false
                moreInfo.ZIndex = 999
                moreInfo.Font = Enum.Font.Gotham
                moreInfo.Text = "  "..tTip
                moreInfo.TextColor3 = themeList.colorOnTertiaryContainer
                moreInfo.TextSize = 13.000
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                moreInfo.TextYAlignment = Enum.TextYAlignment.Center
                moreInfo.ClipsDescendants = true
                tipCorner.CornerRadius = UDim.new(0, 8)
                tipCorner.Parent = moreInfo

                UpdateCanvasSize()
            
                TextBox.FocusGained:Connect(function()
                    Utility:TweenObject(TextBox, { BorderColor3 = themeList.colorPrimary }, 0.15)
                    Utility:TweenObject(textLabel, { TextColor3 = themeList.colorPrimary, Position = UDim2.new(0,10,0,-8), FontSize = 10}, 0.15)
                end)

                TextBox.FocusLost:Connect(function(enterPressed)
                    Utility:TweenObject(TextBox, { BorderColor3 = themeList.colorOutline }, 0.15)
                    if TextBox.Text == "" then
                         Utility:TweenObject(textLabel, { TextColor3 = themeList.colorOnSurfaceVariant, Position = UDim2.new(0,12,0,6), FontSize = 12}, 0.15)
                    else
                        Utility:TweenObject(textLabel, { TextColor3 = themeList.colorOnSurfaceVariant, Position = UDim2.new(0,10,0,-8), FontSize = 10}, 0.15)
                    end

                    if focusing then
                        for i,v in next, infoContainer:GetChildren() do
                            if v.Name == "TipMore" then v.Visible = false end
                        end
                        blurFrame.Visible = false
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        focusing = false
                    end
                    if enterPressed then
                        callback(TextBox.Text)
                    end
                end)
                
                TextBox.Changed:Connect(function(property)
                    if property == "Text" then
                        if TextBox.Text ~= "" and textLabel.TextSize == 12 then
                             Utility:TweenObject(textLabel, { TextColor3 = themeList.colorPrimary, Position = UDim2.new(0,10,0,-8), FontSize = 10}, 0.15)
                        end
                    end
                end)


                viewInfo.MouseButton1Click:Connect(function()
                    if viewDe then return end
                    viewDe = true
                    focusing = true
                    for i,v in next, infoContainer:GetChildren() do
                       if v.Name == "TipMore" and v ~= moreInfo then v.Visible = false end
                    end
                    moreInfo.Visible = true
                    blurFrame.Visible = true
                    Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                    
                    task.delay(2, function()
                        if focusing and moreInfo.Visible then
                            moreInfo.Visible = false
                            blurFrame.Visible = false
                            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                            focusing = false
                        end
                        viewDe = false
                    end)
                end)

                coroutine.wrap(function()
                    while task.wait() do
                        if not ScreenGui or not ScreenGui.Parent then break end
                        if not textboxContainer or not textboxContainer.Parent then break end
                        textboxContainer.BackgroundColor3 = themeList.colorSurface
                        TextBox.BackgroundColor3 = themeList.colorSurface
                        if not TextBox:IsFocused() then TextBox.BorderColor3 = themeList.colorOutline end
                        TextBox.PlaceholderColor3 = themeList.colorOnSurfaceVariant
                        TextBox.TextColor3 = themeList.colorOnSurface
                        if not TextBox:IsFocused() and TextBox.Text == "" then
                            textLabel.TextColor3 = themeList.colorOnSurfaceVariant
                        elseif not TextBox:IsFocused() and TextBox.Text ~= "" then
                             textLabel.TextColor3 = themeList.colorOnSurfaceVariant
                        end
                        viewInfo.ImageColor3 = themeList.colorSecondary
                        moreInfo.BackgroundColor3 = themeList.colorTertiaryContainer
                        moreInfo.TextColor3 = themeList.colorOnTertiaryContainer
                    end
                end)()
                return TextBox
            end 

            function Elements:NewToggle(tname, nTip, defaultValue, callback)
                local TogFunction = {}
                tname = tname or "Toggle"
                nTip = nTip or "Toggle on or off"
                defaultValue = defaultValue or false
                callback = callback or function() end
                local toggled = defaultValue

                local toggleElement = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local switchTrack = Instance.new("Frame")
                local trackCorner = Instance.new("UICorner")
                local switchThumb = Instance.new("ImageLabel")
                local thumbCorner = Instance.new("UICorner")
                local togName = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local clickDetector = Instance.new("TextButton")

                toggleElement.Name = "toggleElement"
                toggleElement.Parent = sectionElListing
                toggleElement.BackgroundColor3 = themeList.colorSurface
                toggleElement.Size = UDim2.new(1, 0, 0, 48)
                toggleElement.ClipsDescendants = true
                
                UICorner.CornerRadius = UDim.new(0,8)
                UICorner.Parent = toggleElement

                togName.Name = "togName"
                togName.Parent = toggleElement
                togName.BackgroundTransparency = 1.000
                togName.Position = UDim2.new(0, 12, 0, 0)
                togName.Size = UDim2.new(1, -80, 1, 0) 
                togName.Font = Enum.Font.GothamMedium
                togName.Text = tname
                togName.TextColor3 = themeList.colorOnSurface
                togName.TextSize = 14.000
                togName.TextXAlignment = Enum.TextXAlignment.Left
                togName.TextYAlignment = Enum.TextYAlignment.Center

                switchTrack.Name = "SwitchTrack"
                switchTrack.Parent = toggleElement
                switchTrack.Size = UDim2.new(0, 52, 0, 32)
                switchTrack.Position = UDim2.new(1, -64, 0.5, -16)
                switchTrack.ClipsDescendants = true
                trackCorner.CornerRadius = UDim.new(0,16)
                trackCorner.Parent = switchTrack
                
                switchThumb.Name = "SwitchThumb"
                switchThumb.Parent = switchTrack
                switchThumb.Size = UDim2.new(0, 24, 0, 24)
                switchThumb.BackgroundTransparency = 1
                switchThumb.Image = "rbxassetid://3926309567" 
                switchThumb.ImageRectOffset = Vector2.new(628,420) 
                switchThumb.ImageRectSize = Vector2.new(48,48)
                thumbCorner.CornerRadius = UDim.new(0,12)
                thumbCorner.Parent = switchThumb
                
                clickDetector.Name = "ClickDetector"
                clickDetector.Parent = toggleElement
                clickDetector.Size = UDim2.new(1,0,1,0)
                clickDetector.BackgroundTransparency = 1
                clickDetector.Text = ""


                local function UpdateToggleVisuals(isInstant)
                    local duration = isInstant and 0 or 0.15
                    if toggled then
                        Utility:TweenObject(switchTrack, { BackgroundColor3 = themeList.colorPrimary }, duration)
                        Utility:TweenObject(switchThumb, { Position = UDim2.new(1, -28, 0.5, -12), ImageColor3 = themeList.colorOnPrimary }, duration)
                    else
                        Utility:TweenObject(switchTrack, { BackgroundColor3 = themeList.colorOutline }, duration)
                        Utility:TweenObject(switchThumb, { Position = UDim2.new(0, 4, 0.5, -12), ImageColor3 = themeList.colorSurfaceVariant }, duration)
                    end
                end
                UpdateToggleVisuals(true)


                viewInfo.Name = "viewInfo"
                viewInfo.Parent = toggleElement
                viewInfo.BackgroundTransparency = 1.000
                viewInfo.Position = UDim2.new(1, -82, 0.5, -11) 
                viewInfo.Size = UDim2.new(0, 22, 0, 22)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.colorSecondary
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)

                local moreInfo = Instance.new("TextLabel")
                local tipCorner = Instance.new("UICorner")
    
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = themeList.colorTertiaryContainer
                moreInfo.Position = UDim2.new(0.02, 0, 0.5, -16.5)
                moreInfo.Size = UDim2.new(0.96, 0, 0, 33)
                moreInfo.Visible = false
                moreInfo.ZIndex = 999
                moreInfo.Font = Enum.Font.Gotham
                moreInfo.Text = "  "..nTip
                moreInfo.TextColor3 = themeList.colorOnTertiaryContainer
                moreInfo.TextSize = 13.000
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                moreInfo.TextYAlignment = Enum.TextYAlignment.Center
                moreInfo.ClipsDescendants = true
                tipCorner.CornerRadius = UDim.new(0, 8)
                tipCorner.Parent = moreInfo

                UpdateCanvasSize()

                clickDetector.MouseButton1Click:Connect(function()
                    if focusing then
                        for i,v in next, infoContainer:GetChildren() do
                            if v.Name == "TipMore" then v.Visible = false end
                        end
                        blurFrame.Visible = false
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        focusing = false
                        return
                    end
                    toggled = not toggled
                    UpdateToggleVisuals(false)
                    pcall(callback, toggled)
                end)
                
                coroutine.wrap(function()
                    while task.wait() do
                        if not ScreenGui or not ScreenGui.Parent then break end
                        if not toggleElement or not toggleElement.Parent then break end
                        toggleElement.BackgroundColor3 = themeList.colorSurface
                        togName.TextColor3 = themeList.colorOnSurface
                        viewInfo.ImageColor3 = themeList.colorSecondary
                        moreInfo.BackgroundColor3 = themeList.colorTertiaryContainer
                        moreInfo.TextColor3 = themeList.colorOnTertiaryContainer
                        
                        if toggled then
                            switchTrack.BackgroundColor3 = themeList.colorPrimary
                            switchThumb.ImageColor3 = themeList.colorOnPrimary
                        else
                            switchTrack.BackgroundColor3 = themeList.colorOutline
                            switchThumb.ImageColor3 = themeList.colorSurfaceVariant
                        end
                    end
                end)()

                viewInfo.MouseButton1Click:Connect(function()
                    if viewDe then return end
                    viewDe = true
                    focusing = true
                    for i,v in next, infoContainer:GetChildren() do
                        if v.Name == "TipMore" and v ~= moreInfo then v.Visible = false end
                    end
                    moreInfo.Visible = true
                    blurFrame.Visible = true
                    Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                    
                    task.delay(2, function()
                        if focusing and moreInfo.Visible then
                            moreInfo.Visible = false
                            blurFrame.Visible = false
                            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                            focusing = false
                        end
                        viewDe = false
                    end)
                end)

                function TogFunction:UpdateToggle(newText, isTogOn)
                    if newText ~= nil then 
                        togName.Text = newText
                    end
                    if type(isTogOn) == "boolean" and isTogOn ~= toggled then
                        toggled = isTogOn
                        UpdateToggleVisuals(false) 
                        pcall(callback, toggled)
                    end
                end
                return TogFunction
            end

            function Elements:NewSlider(slidInf, slidTip, minvalue, maxvalue, startVal, callback)
                slidInf = slidInf or "Slider"
                slidTip = slidTip or "Adjust the value"
                minvalue = minvalue or 0
                maxvalue = maxvalue or 100
                startVal = startVal or minvalue
                callback = callback or function() end

                local sliderElement = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local togName = Instance.new("TextLabel")
                local valueLabel = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                
                local trackBase = Instance.new("Frame")
                local baseCorner = Instance.new("UICorner")
                local trackFill = Instance.new("Frame")
                local fillCorner = Instance.new("UICorner")
                local thumb = Instance.new("Frame")
                local thumbCorner = Instance.new("UICorner")
                
                local currentValue = math.clamp(startVal, minvalue, maxvalue)

                sliderElement.Name = "sliderElement"
                sliderElement.Parent = sectionElListing
                sliderElement.BackgroundColor3 = themeList.colorSurface
                sliderElement.Size = UDim2.new(1, 0, 0, 60) 
                sliderElement.ClipsDescendants = true
                UICorner.CornerRadius = UDim.new(0,8)
                UICorner.Parent = sliderElement

                togName.Name = "togName"
                togName.Parent = sliderElement
                togName.BackgroundTransparency = 1.000
                togName.Position = UDim2.new(0, 12, 0, 8)
                togName.Size = UDim2.new(1, -80, 0, 16)
                togName.Font = Enum.Font.GothamMedium
                togName.Text = slidInf
                togName.TextColor3 = themeList.colorOnSurface
                togName.TextSize = 14.000
                togName.TextXAlignment = Enum.TextXAlignment.Left

                valueLabel.Name = "valueLabel"
                valueLabel.Parent = sliderElement
                valueLabel.BackgroundTransparency = 1
                valueLabel.Position = UDim2.new(1, -60, 0, 8)
                valueLabel.Size = UDim2.new(0, 48, 0, 16)
                valueLabel.Font = Enum.Font.Gotham
                valueLabel.Text = tostring(math.floor(currentValue))
                valueLabel.TextColor3 = themeList.colorOnSurfaceVariant
                valueLabel.TextSize = 13
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                
                trackBase.Name = "TrackBase"
                trackBase.Parent = sliderElement
                trackBase.BackgroundColor3 = themeList.colorSurfaceVariant 
                trackBase.Position = UDim2.new(0, 12, 0, 32)
                trackBase.Size = UDim2.new(1, -24, 0, 6) 
                baseCorner.CornerRadius = UDim.new(0,3)
                baseCorner.Parent = trackBase

                trackFill.Name = "TrackFill"
                trackFill.Parent = trackBase
                trackFill.BackgroundColor3 = themeList.colorPrimary
                trackFill.BorderSizePixel = 0
                fillCorner.CornerRadius = UDim.new(0,3)
                fillCorner.Parent = trackFill
                
                thumb.Name = "Thumb"
                thumb.Parent = trackBase 
                thumb.BackgroundColor3 = themeList.colorPrimary
                thumb.Size = UDim2.new(0, 18, 0, 18) 
                thumb.ZIndex = 2
                thumbCorner.CornerRadius = UDim.new(0,9)
                thumbCorner.Parent = thumb

                local function UpdateSliderVisuals(value)
                    local percentage = (value - minvalue) / (maxvalue - minvalue)
                    percentage = math.clamp(percentage, 0, 1)
                    trackFill.Size = UDim2.new(percentage, 0, 1, 0)
                    thumb.Position = UDim2.new(percentage, -thumb.AbsoluteSize.X * percentage, 0.5, -thumb.AbsoluteSize.Y / 2)
                    valueLabel.Text = tostring(math.floor(value))
                end
                UpdateSliderVisuals(currentValue)
                
                viewInfo.Name = "viewInfo"
                viewInfo.Parent = sliderElement
                viewInfo.BackgroundTransparency = 1.000
                viewInfo.Position = UDim2.new(1, -32, 0, 6) 
                viewInfo.Size = UDim2.new(0, 22, 0, 22)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.colorSecondary
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)

                local moreInfo = Instance.new("TextLabel")
                local tipCorner = Instance.new("UICorner")

                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = themeList.colorTertiaryContainer
                moreInfo.Position = UDim2.new(0.02, 0, 0.5, -16.5)
                moreInfo.Size = UDim2.new(0.96, 0, 0, 33)
                moreInfo.Visible = false
                moreInfo.ZIndex = 999
                moreInfo.Font = Enum.Font.Gotham
                moreInfo.Text = "  "..slidTip
                moreInfo.TextColor3 = themeList.colorOnTertiaryContainer
                moreInfo.TextSize = 13.000
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                moreInfo.TextYAlignment = Enum.TextYAlignment.Center
                moreInfo.ClipsDescendants = true
                tipCorner.CornerRadius = UDim.new(0, 8)
                tipCorner.Parent = moreInfo

                UpdateCanvasSize()
                
                local dragging = false
                thumb.InputBegan:Connect(function(inputObj)
                    if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        Utility:TweenObject(thumb, {Size = UDim2.new(0,22,0,22), BackgroundColor3 = themeList.colorPrimaryContainer}, 0.1)
                         thumbCorner.CornerRadius = UDim.new(0,11)
                    end
                end)
                
                input.InputChanged:Connect(function(inputObj)
                    if dragging and inputObj.UserInputType == Enum.UserInputType.MouseMovement then
                        local mouseX = inputObj.Position.X
                        local trackStartX = trackBase.AbsolutePosition.X
                        local trackWidth = trackBase.AbsoluteSize.X
                        
                        local percentage = (mouseX - trackStartX) / trackWidth
                        percentage = math.clamp(percentage, 0, 1)
                        
                        currentValue = minvalue + (maxvalue - minvalue) * percentage
                        UpdateSliderVisuals(currentValue)
                        pcall(callback, currentValue)
                    end
                end)

                input.InputEnded:Connect(function(inputObj)
                    if dragging and inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                        Utility:TweenObject(thumb, {Size = UDim2.new(0,18,0,18), BackgroundColor3 = themeList.colorPrimary}, 0.1)
                        thumbCorner.CornerRadius = UDim.new(0,9)
                        if focusing then
                            for i,v in next, infoContainer:GetChildren() do
                                if v.Name == "TipMore" then v.Visible = false end
                            end
                            blurFrame.Visible = false
                            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                            focusing = false
                        end
                    end
                end)
                
                viewInfo.MouseButton1Click:Connect(function()
                    if viewDe then return end
                    viewDe = true
                    focusing = true
                    for i,v in next, infoContainer:GetChildren() do
                        if v.Name == "TipMore" and v ~= moreInfo then v.Visible = false end
                    end
                    moreInfo.Visible = true
                    blurFrame.Visible = true
                    Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                    
                    task.delay(2, function()
                        if focusing and moreInfo.Visible then
                            moreInfo.Visible = false
                            blurFrame.Visible = false
                            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                            focusing = false
                        end
                        viewDe = false
                    end)
                end)

                coroutine.wrap(function()
                    while task.wait() do
                        if not ScreenGui or not ScreenGui.Parent then break end
                        if not sliderElement or not sliderElement.Parent then break end
                        sliderElement.BackgroundColor3 = themeList.colorSurface
                        togName.TextColor3 = themeList.colorOnSurface
                        valueLabel.TextColor3 = themeList.colorOnSurfaceVariant
                        trackBase.BackgroundColor3 = themeList.colorSurfaceVariant
                        trackFill.BackgroundColor3 = themeList.colorPrimary
                        if not dragging then thumb.BackgroundColor3 = themeList.colorPrimary end
                        viewInfo.ImageColor3 = themeList.colorSecondary
                        moreInfo.BackgroundColor3 = themeList.colorTertiaryContainer
                        moreInfo.TextColor3 = themeList.colorOnTertiaryContainer
                    end
                end)()
                return sliderElement 
            end

            function Elements:NewDropdown(dropname, dropinf, list, callback)
                local DropFunction = {}
                dropname = dropname or "Dropdown"
                list = list or {}
                dropinf = dropinf or "Select an option"
                callback = callback or function() end   

                local opened = false
                local currentSelection = list[1] or dropname

                local dropContainer = Instance.new("Frame")
                local dropUICorner = Instance.new("UICorner")
                local dropButton = Instance.new("TextButton")
                local buttonCorner = Instance.new("UICorner")
                local itemTextLabel = Instance.new("TextLabel")
                local arrowIcon = Instance.new("ImageLabel")
                local viewInfo = Instance.new("ImageButton")
                
                local dropdownListFrame = Instance.new("ScrollingFrame")
                local listCorner = Instance.new("UICorner")
                local listLayout = Instance.new("UIListLayout")
                local listPadding = Instance.new("UIPadding")

                dropContainer.Name = "dropContainer"
                dropContainer.Parent = sectionElListing
                dropContainer.BackgroundColor3 = themeList.colorSurface
                dropContainer.Size = UDim2.new(1, 0, 0, 56) 
                dropContainer.ClipsDescendants = false 
                dropContainer.ZIndex = 2 
                dropUICorner.CornerRadius = UDim.new(0,8)
                dropUICorner.Parent = dropContainer

                dropButton.Name = "dropButton"
                dropButton.Parent = dropContainer
                dropButton.BackgroundColor3 = themeList.colorSurface
                dropButton.BorderSizePixel = 1
                dropButton.BorderColor3 = themeList.colorOutline
                dropButton.Size = UDim2.new(1,0,1,0)
                dropButton.Text = ""
                dropButton.AutoButtonColor = false
                buttonCorner.CornerRadius = UDim.new(0,8)
                buttonCorner.Parent = dropButton

                itemTextLabel.Name = "itemTextLabel"
                itemTextLabel.Parent = dropButton
                itemTextLabel.BackgroundTransparency = 1
                itemTextLabel.Size = UDim2.new(1, -48, 1, 0)
                itemTextLabel.Position = UDim2.new(0, 12, 0, 0)
                itemTextLabel.Font = Enum.Font.Gotham
                itemTextLabel.Text = currentSelection
                itemTextLabel.TextColor3 = themeList.colorOnSurface
                itemTextLabel.TextSize = 14
                itemTextLabel.TextXAlignment = Enum.TextXAlignment.Left
                itemTextLabel.TextYAlignment = Enum.TextYAlignment.Center

                arrowIcon.Name = "arrowIcon"
                arrowIcon.Parent = dropButton
                arrowIcon.BackgroundTransparency = 1
                arrowIcon.Image = "rbxassetid://3926305904" 
                arrowIcon.ImageColor3 = themeList.colorOnSurfaceVariant
                arrowIcon.ImageRectOffset = Vector2.new(324,364) 
                arrowIcon.ImageRectSize = Vector2.new(36,36)
                arrowIcon.Position = UDim2.new(1,-36,0.5,-12)
                arrowIcon.Size = UDim2.new(0,24,0,24)
                arrowIcon.Rotation = 0

                viewInfo.Name = "viewInfo"
                viewInfo.Parent = dropButton 
                viewInfo.BackgroundTransparency = 1.000
                viewInfo.Position = UDim2.new(1, -68, 0.5, -11)
                viewInfo.Size = UDim2.new(0, 22, 0, 22)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.colorSecondary
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)

                dropdownListFrame.Name = "dropdownListFrame"
                dropdownListFrame.Parent = dropContainer 
                dropdownListFrame.BackgroundColor3 = themeList.colorSurfaceVariant
                dropdownListFrame.BorderSizePixel = 1
                dropdownListFrame.BorderColor3 = themeList.colorOutline
                dropdownListFrame.Size = UDim2.new(1,0,0,0) 
                dropdownListFrame.Position = UDim2.new(0,0,1,4) 
                dropdownListFrame.Visible = false
                dropdownListFrame.ClipsDescendants = true
                dropdownListFrame.ScrollBarThickness = 6
                dropdownListFrame.ZIndex = 3 
                listCorner.CornerRadius = UDim.new(0,8)
                listCorner.Parent = dropdownListFrame
                
                listLayout.Parent = dropdownListFrame
                listLayout.SortOrder = Enum.SortOrder.LayoutOrder
                listLayout.Padding = UDim.new(0,0)
                
                listPadding.Parent = dropdownListFrame
                listPadding.PaddingTop = UDim.new(0,4)
                listPadding.PaddingBottom = UDim.new(0,4)


                local moreInfo = Instance.new("TextLabel")
                local tipCorner = Instance.new("UICorner")

                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = themeList.colorTertiaryContainer
                moreInfo.Position = UDim2.new(0.02, 0, 0.5, -16.5)
                moreInfo.Size = UDim2.new(0.96, 0, 0, 33)
                moreInfo.Visible = false
                moreInfo.ZIndex = 999
                moreInfo.Font = Enum.Font.Gotham
                moreInfo.Text = "  "..dropinf
                moreInfo.TextColor3 = themeList.colorOnTertiaryContainer
                moreInfo.TextSize = 13.000
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                moreInfo.TextYAlignment = Enum.TextYAlignment.Center
                moreInfo.ClipsDescendants = true
                tipCorner.CornerRadius = UDim.new(0, 8)
                tipCorner.Parent = moreInfo

                local function CreateOptionButton(optionText)
                    local optionButton = Instance.new("TextButton")
                    optionButton.Name = optionText
                    optionButton.Parent = listLayout
                    optionButton.BackgroundColor3 = themeList.colorSurfaceVariant
                    optionButton.Size = UDim2.new(1,0,0,40)
                    optionButton.Text = "  " .. optionText
                    optionButton.Font = Enum.Font.Gotham
                    optionButton.TextColor3 = themeList.colorOnSurfaceVariant
                    optionButton.TextSize = 14
                    optionButton.TextXAlignment = Enum.TextXAlignment.Left
                    optionButton.AutoButtonColor = false

                    optionButton.MouseEnter:Connect(function() Utility:TweenObject(optionButton, {BackgroundColor3 = themeList.ElementHoverColor}, 0.1) end)
                    optionButton.MouseLeave:Connect(function() Utility:TweenObject(optionButton, {BackgroundColor3 = themeList.colorSurfaceVariant}, 0.1) end)
                    
                    optionButton.MouseButton1Click:Connect(function()
                        currentSelection = optionText
                        itemTextLabel.Text = currentSelection
                        opened = false
                        Utility:TweenObject(arrowIcon, {Rotation = 0}, 0.2)
                        Utility:TweenObject(dropdownListFrame, {Size = UDim2.new(1,0,0,0)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function() dropdownListFrame.Visible = false end)
                        dropContainer.ClipsDescendants = false
                        dropContainer.ZIndex = 2
                        callback(currentSelection)
                        if focusing then
                            for i,v_ in next, infoContainer:GetChildren() do
                                if v_.Name == "TipMore" then v_.Visible = false end
                            end
                            blurFrame.Visible = false
                            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                            focusing = false
                        end
                    end)
                    return optionButton
                end
                
                local function PopulateDropdown(itemList)
                    for _, child in ipairs(listLayout:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end
                    local totalHeight = 0
                    for _, item in ipairs(itemList) do
                        CreateOptionButton(item)
                        totalHeight = totalHeight + 40 
                    end
                    dropdownListFrame.CanvasSize = UDim2.new(0,0,0, totalHeight + listPadding.PaddingTop.Offset + listPadding.PaddingBottom.Offset)
                end
                PopulateDropdown(list)

                dropButton.MouseButton1Click:Connect(function()
                    if focusing then
                        for i,v in next, infoContainer:GetChildren() do
                            if v.Name == "TipMore" then v.Visible = false end
                        end
                        blurFrame.Visible = false
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        focusing = false
                        return
                    end
                    opened = not opened
                    if opened then
                        dropContainer.ClipsDescendants = false 
                        dropContainer.ZIndex = 10 
                        dropdownListFrame.Visible = true
                        local listHeight = math.min(dropdownListFrame.CanvasSize.Y.Offset, 160) 
                        Utility:TweenObject(arrowIcon, {Rotation = 180}, 0.2)
                        Utility:TweenObject(dropdownListFrame, {Size = UDim2.new(1,0,0,listHeight)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    else
                        Utility:TweenObject(arrowIcon, {Rotation = 0}, 0.2)
                        Utility:TweenObject(dropdownListFrame, {Size = UDim2.new(1,0,0,0)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function() 
                            dropdownListFrame.Visible = false 
                            dropContainer.ClipsDescendants = false 
                            dropContainer.ZIndex = 2
                        end)
                    end
                end)
                UpdateCanvasSize()
                
                viewInfo.MouseButton1Click:Connect(function()
                    if viewDe then return end
                    viewDe = true
                    focusing = true
                    for i,v in next, infoContainer:GetChildren() do
                        if v.Name == "TipMore" and v ~= moreInfo then v.Visible = false end
                    end
                    moreInfo.Visible = true
                    blurFrame.Visible = true
                    Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                    
                    task.delay(2, function()
                        if focusing and moreInfo.Visible then
                            moreInfo.Visible = false
                            blurFrame.Visible = false
                            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                            focusing = false
                        end
                        viewDe = false
                    end)
                end)

                coroutine.wrap(function()
                    while task.wait() do
                        if not ScreenGui or not ScreenGui.Parent then break end
                        if not dropContainer or not dropContainer.Parent then break end
                        dropContainer.BackgroundColor3 = themeList.colorSurface
                        dropButton.BackgroundColor3 = themeList.colorSurface
                        dropButton.BorderColor3 = themeList.colorOutline
                        itemTextLabel.TextColor3 = themeList.colorOnSurface
                        arrowIcon.ImageColor3 = themeList.colorOnSurfaceVariant
                        viewInfo.ImageColor3 = themeList.colorSecondary
                        dropdownListFrame.BackgroundColor3 = themeList.colorSurfaceVariant
                        dropdownListFrame.BorderColor3 = themeList.colorOutline
                        moreInfo.BackgroundColor3 = themeList.colorTertiaryContainer
                        moreInfo.TextColor3 = themeList.colorOnTertiaryContainer
                        for _, child in ipairs(listLayout:GetChildren()) do
                            if child:IsA("TextButton") then
                                child.TextColor3 = themeList.colorOnSurfaceVariant
                                if child.BackgroundColor3 ~= themeList.ElementHoverColor then 
                                    child.BackgroundColor3 = themeList.colorSurfaceVariant
                                end
                            end
                        end
                    end
                end)()

                function DropFunction:Refresh(newList)
                    list = newList or {}
                    PopulateDropdown(list)
                    if opened then 
                        local listHeight = math.min(dropdownListFrame.CanvasSize.Y.Offset, 160)
                        dropdownListFrame.Size = UDim2.new(1,0,0,listHeight)
                    end
                end
                return DropFunction
            end
            
            function Elements:NewKeybind(keytext, keyinf, firstKey, callback)
                keytext = keytext or "Keybind"
                keyinf = keyinf or "Press to set key"
                callback = callback or function() end
                local currentKey = firstKey or Enum.KeyCode.Unknown

                local keybindElement = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local keyLabel = Instance.new("TextLabel")
                local keyButton = Instance.new("TextButton")
                local buttonCorner = Instance.new("UICorner")
                local viewInfo = Instance.new("ImageButton")
                
                local isBinding = false

                keybindElement.Name = "keybindElement"
                keybindElement.Parent = sectionElListing
                keybindElement.BackgroundColor3 = themeList.colorSurface
                keybindElement.Size = UDim2.new(1, 0, 0, 48)
                keybindElement.ClipsDescendants = true
                UICorner.CornerRadius = UDim.new(0,8)
                UICorner.Parent = keybindElement

                keyLabel.Name = "keyLabel"
                keyLabel.Parent = keybindElement
                keyLabel.BackgroundTransparency = 1
                keyLabel.Position = UDim2.new(0,12,0,0)
                keyLabel.Size = UDim2.new(0.6, -12, 1,0)
                keyLabel.Font = Enum.Font.GothamMedium
                keyLabel.Text = keytext
                keyLabel.TextColor3 = themeList.colorOnSurface
                keyLabel.TextSize = 14
                keyLabel.TextXAlignment = Enum.TextXAlignment.Left
                keyLabel.TextYAlignment = Enum.TextYAlignment.Center

                keyButton.Name = "keyButton"
                keyButton.Parent = keybindElement
                keyButton.BackgroundColor3 = themeList.colorSurfaceVariant
                keyButton.Position = UDim2.new(1, -120, 0.5, -16) 
                keyButton.Size = UDim2.new(0, 80, 0, 32)
                keyButton.Font = Enum.Font.GothamBold
                keyButton.Text = currentKey.Name
                keyButton.TextColor3 = themeList.colorOnSurfaceVariant
                keyButton.TextSize = 13
                keyButton.AutoButtonColor = false
                buttonCorner.CornerRadius = UDim.new(0,8)
                buttonCorner.Parent = keyButton
                
                viewInfo.Name = "viewInfo"
                viewInfo.Parent = keybindElement
                viewInfo.BackgroundTransparency = 1.000
                viewInfo.Position = UDim2.new(1, -148, 0.5, -11) 
                viewInfo.Size = UDim2.new(0, 22, 0, 22)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.colorSecondary
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)

                local moreInfo = Instance.new("TextLabel")
                local tipCorner = Instance.new("UICorner")

                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = themeList.colorTertiaryContainer
                moreInfo.Position = UDim2.new(0.02, 0, 0.5, -16.5)
                moreInfo.Size = UDim2.new(0.96, 0, 0, 33)
                moreInfo.Visible = false
                moreInfo.ZIndex = 999
                moreInfo.Font = Enum.Font.Gotham
                moreInfo.Text = "  "..keyinf
                moreInfo.TextColor3 = themeList.colorOnTertiaryContainer
                moreInfo.TextSize = 13.000
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                moreInfo.TextYAlignment = Enum.TextYAlignment.Center
                moreInfo.ClipsDescendants = true
                tipCorner.CornerRadius = UDim.new(0, 8)
                tipCorner.Parent = moreInfo
                UpdateCanvasSize()

                keyButton.MouseButton1Click:Connect(function()
                    if focusing then
                        for i,v in next, infoContainer:GetChildren() do
                           if v.Name == "TipMore" then v.Visible = false end
                        end
                        blurFrame.Visible = false
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        focusing = false
                        return
                    end
                    isBinding = true
                    keyButton.Text = ". . ."
                    Utility:TweenObject(keyButton, {BackgroundColor3 = themeList.colorPrimaryContainer, TextColor3 = themeList.colorOnPrimaryContainer}, 0.1)
                    
                    local connection
                    connection = input.InputBegan:Connect(function(inputObj)
                        if isBinding then
                            if inputObj.UserInputType == Enum.UserInputType.Keyboard then
                                currentKey = inputObj.KeyCode
                                keyButton.Text = currentKey.Name
                                isBinding = false
                                Utility:TweenObject(keyButton, {BackgroundColor3 = themeList.colorSurfaceVariant, TextColor3 = themeList.colorOnSurfaceVariant}, 0.1)
                                if connection then connection:Disconnect() end
                            elseif inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.MouseButton2 or inputObj.UserInputType == Enum.UserInputType.MouseButton3 then
                                currentKey = inputObj.UserInputType -- Store as UserInputType for mouse
                                keyButton.Text = currentKey.Name
                                isBinding = false
                                Utility:TweenObject(keyButton, {BackgroundColor3 = themeList.colorSurfaceVariant, TextColor3 = themeList.colorOnSurfaceVariant}, 0.1)
                                if connection then connection:Disconnect() end
                            end
                        end
                    end)
                end)
        
                input.InputBegan:Connect(function(inputObj, gameProcessedEvent) 
                    if gameProcessedEvent then return end
                    if not isBinding then
                        if inputObj.UserInputType == Enum.UserInputType.Keyboard and inputObj.KeyCode == currentKey then
                            callback()
                        elseif inputObj.UserInputType == currentKey then -- Check for mouse UserInputType
                             callback()
                        end
                    end
                end)
                
                viewInfo.MouseButton1Click:Connect(function()
                    if viewDe then return end
                    viewDe = true
                    focusing = true
                    for i,v in next, infoContainer:GetChildren() do
                        if v.Name == "TipMore" and v ~= moreInfo then v.Visible = false end
                    end
                    moreInfo.Visible = true
                    blurFrame.Visible = true
                    Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                    
                    task.delay(2, function()
                        if focusing and moreInfo.Visible then
                            moreInfo.Visible = false
                            blurFrame.Visible = false
                            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                            focusing = false
                        end
                        viewDe = false
                    end)
                end)  

                coroutine.wrap(function()
                    while task.wait() do
                        if not ScreenGui or not ScreenGui.Parent then break end
                        if not keybindElement or not keybindElement.Parent then break end
                        keybindElement.BackgroundColor3 = themeList.colorSurface
                        keyLabel.TextColor3 = themeList.colorOnSurface
                        if not isBinding then
                            keyButton.BackgroundColor3 = themeList.colorSurfaceVariant
                            keyButton.TextColor3 = themeList.colorOnSurfaceVariant
                        end
                        viewInfo.ImageColor3 = themeList.colorSecondary
                        moreInfo.BackgroundColor3 = themeList.colorTertiaryContainer
                        moreInfo.TextColor3 = themeList.colorOnTertiaryContainer
                    end
                end)()
            end

            function Elements:NewColorPicker(colText, colInf, defaultColor, callback)
                colText = colText or "Color Picker"
                colInf = colInf or "Select a color"
                defaultColor = defaultColor or Color3.fromRGB(255,0,0)
                callback = callback or function() end
                
                local h, s, v = Color3.toHSV(defaultColor)
                local currentColor = defaultColor
                local isRainbow = false

                local cpElement = Instance.new("Frame")
                local cpCorner = Instance.new("UICorner")
                local headerFrame = Instance.new("TextButton") 
                local headerCorner = Instance.new("UICorner")
                local colorLabel = Instance.new("TextLabel")
                local colorPreview = Instance.new("Frame")
                local previewCorner = Instance.new("UICorner")
                local viewInfo = Instance.new("ImageButton")
                
                local pickerFrame = Instance.new("Frame")
                local pickerFrameCorner = Instance.new("UICorner")
                local saturationValuePicker = Instance.new("ImageLabel")
                local svCorner = Instance.new("UICorner")
                local svThumb = Instance.new("Frame") 
                local svThumbCorner = Instance.new("UICorner")
                local hueSlider = Instance.new("ImageLabel")
                local hueCorner = Instance.new("UICorner")
                local hueThumb = Instance.new("Frame")
                local hueThumbCorner = Instance.new("UICorner")
                
                local rainbowToggleFrame = Instance.new("Frame")
                local rainbowLabel = Instance.new("TextLabel")
                local rainbowSwitch = Kavo.CreateLib("Temp", themeList).NewTab("Temp").NewSection("Temp", true):NewToggle("Rainbow", "", false, function(state)
                    isRainbow = state
                    if not isRainbow then
                        callback(currentColor)
                    end
                end)
                rainbowSwitch:UpdateToggle(nil, false)


                cpElement.Name = "ColorPickerElement"
                cpElement.Parent = sectionElListing
                cpElement.BackgroundColor3 = themeList.colorSurface
                cpElement.Size = UDim2.new(1,0,0,48) 
                cpElement.ClipsDescendants = true 
                cpCorner.CornerRadius = UDim.new(0,8)
                cpCorner.Parent = cpElement

                headerFrame.Name = "HeaderFrame"
                headerFrame.Parent = cpElement
                headerFrame.BackgroundColor3 = themeList.colorSurface
                headerFrame.Size = UDim2.new(1,0,1,0)
                headerFrame.Text = ""
                headerFrame.AutoButtonColor = false
                headerCorner.CornerRadius = UDim.new(0,8)
                headerCorner.Parent = headerFrame

                colorLabel.Name = "ColorLabel"
                colorLabel.Parent = headerFrame
                colorLabel.BackgroundTransparency = 1
                colorLabel.Position = UDim2.new(0,12,0,0)
                colorLabel.Size = UDim2.new(1, -100, 1,0)
                colorLabel.Font = Enum.Font.GothamMedium
                colorLabel.Text = colText
                colorLabel.TextColor3 = themeList.colorOnSurface
                colorLabel.TextSize = 14
                colorLabel.TextXAlignment = Enum.TextXAlignment.Left
                colorLabel.TextYAlignment = Enum.TextYAlignment.Center

                colorPreview.Name = "ColorPreview"
                colorPreview.Parent = headerFrame
                colorPreview.BackgroundColor3 = currentColor
                colorPreview.Position = UDim2.new(1, -80, 0.5, -12)
                colorPreview.Size = UDim2.new(0,24,0,24)
                colorPreview.BorderSizePixel = 1
                colorPreview.BorderColor3 = themeList.colorOutline
                previewCorner.CornerRadius = UDim.new(0,6)
                previewCorner.Parent = colorPreview
                
                viewInfo.Name = "viewInfo"
                viewInfo.Parent = headerFrame
                viewInfo.BackgroundTransparency = 1.000
                viewInfo.Position = UDim2.new(1, -44, 0.5, -11)
                viewInfo.Size = UDim2.new(0, 22, 0, 22)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.colorSecondary
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)
                
                pickerFrame.Name = "PickerFrame"
                pickerFrame.Parent = cpElement
                pickerFrame.BackgroundColor3 = themeList.colorSurfaceVariant
                pickerFrame.Size = UDim2.new(1,0,0,0) 
                pickerFrame.Position = UDim2.new(0,0,1,0) 
                pickerFrame.Visible = false
                pickerFrame.ClipsDescendants = true
                pickerFrameCorner.CornerRadius = UDim.new(0,8)
                pickerFrameCorner.Parent = pickerFrame
                
                local pickerPadding = Instance.new("UIPadding")
                pickerPadding.Parent = pickerFrame
                pickerPadding.PaddingLeft = UDim.new(0,12)
                pickerPadding.PaddingRight = UDim.new(0,12)
                pickerPadding.PaddingTop = UDim.new(0,12)
                pickerPadding.PaddingBottom = UDim.new(0,12)
                
                local pickerLayout = Instance.new("UIListLayout")
                pickerLayout.Parent = pickerFrame
                pickerLayout.FillDirection = Enum.FillDirection.Vertical
                pickerLayout.SortOrder = Enum.SortOrder.LayoutOrder
                pickerLayout.Padding = UDim.new(0,8)

                saturationValuePicker.Name = "SaturationValuePicker"
                saturationValuePicker.Parent = pickerFrame
                saturationValuePicker.BackgroundColor3 = Color3.fromHSV(h,1,1) 
                saturationValuePicker.Image = "rbxassetid://6523286724" 
                saturationValuePicker.Size = UDim2.new(1,0,0,130)
                svCorner.CornerRadius = UDim.new(0,6)
                svCorner.Parent = saturationValuePicker
                
                svThumb.Name = "SVThumb"
                svThumb.Parent = saturationValuePicker
                svThumb.BackgroundColor3 = Color3.fromRGB(255,255,255)
                svThumb.Size = UDim2.new(0,12,0,12)
                svThumb.AnchorPoint = Vector2.new(0.5,0.5)
                svThumb.BorderSizePixel = 2
                svThumb.BorderColor3 = Color3.fromRGB(255,255,255)
                svThumbCorner.CornerRadius = UDim.new(0,6)
                svThumbCorner.Parent = svThumb
                
                hueSlider.Name = "HueSlider"
                hueSlider.Parent = pickerFrame
                hueSlider.Image = "rbxassetid://6650041393" 
                hueSlider.Size = UDim2.new(1,0,0,16)
                hueCorner.CornerRadius = UDim.new(0,8)
                hueCorner.Parent = hueSlider

                hueThumb.Name = "HueThumb"
                hueThumb.Parent = hueSlider
                hueThumb.BackgroundColor3 = Color3.fromRGB(255,255,255)
                hueThumb.Size = UDim2.new(0,6,0,20) 
                hueThumb.Position = UDim2.new(h, -3, 0.5, -10)
                hueThumb.AnchorPoint = Vector2.new(0.5,0.5)
                hueThumb.BorderSizePixel = 2
                hueThumb.BorderColor3 = Color3.fromRGB(200,200,200)
                hueThumbCorner.CornerRadius = UDim.new(0,3)
                hueThumbCorner.Parent = hueThumb
                
                rainbowToggleFrame.Name = "RainbowToggleFrame"
                rainbowToggleFrame.Parent = pickerFrame
                rainbowToggleFrame.BackgroundTransparency = 1
                rainbowToggleFrame.Size = UDim2.new(1,0,0,32)
                
                if rainbowSwitch and rainbowSwitch.Parent then
                    rainbowSwitch.Parent = rainbowToggleFrame
                    rainbowSwitch.Position = UDim2.new(1,-60,0.5,-16)
                    rainbowSwitch.Size = UDim2.new(0,52,0,32)
                end

                rainbowLabel.Name = "RainbowLabel"
                rainbowLabel.Parent = rainbowToggleFrame
                rainbowLabel.BackgroundTransparency = 1
                rainbowLabel.Font = Enum.Font.Gotham
                rainbowLabel.Text = "Rainbow Mode"
                rainbowLabel.TextColor3 = themeList.colorOnSurfaceVariant
                rainbowLabel.TextSize = 13
                rainbowLabel.Position = UDim2.new(0,0,0,0)
                rainbowLabel.Size = UDim2.new(1,-70,1,0)
                rainbowLabel.TextXAlignment = Enum.TextXAlignment.Left
                rainbowLabel.TextYAlignment = Enum.TextYAlignment.Center

                local moreInfo = Instance.new("TextLabel")
                local tipCorner = Instance.new("UICorner")

                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = themeList.colorTertiaryContainer
                moreInfo.Position = UDim2.new(0.02, 0, 0.5, -16.5)
                moreInfo.Size = UDim2.new(0.96, 0, 0, 33)
                moreInfo.Visible = false
                moreInfo.ZIndex = 999
                moreInfo.Font = Enum.Font.Gotham
                moreInfo.Text = "  "..colInf
                moreInfo.TextColor3 = themeList.colorOnTertiaryContainer
                moreInfo.TextSize = 13.000
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                moreInfo.TextYAlignment = Enum.TextYAlignment.Center
                moreInfo.ClipsDescendants = true
                tipCorner.CornerRadius = UDim.new(0, 8)
                tipCorner.Parent = moreInfo

                local function UpdateSVThumbPosition()
                    svThumb.Position = UDim2.new(s,0, 1-v,0)
                end
                UpdateSVThumbPosition()
                
                local expandedHeight = 48 + 12 + 130 + 8 + 16 + 8 + 32 + 12 
                local collapsedHeight = 48

                local isPickerOpen = false
                headerFrame.MouseButton1Click:Connect(function()
                    isPickerOpen = not isPickerOpen
                    pickerFrame.Visible = isPickerOpen
                    if isPickerOpen then
                        Utility:TweenObject(cpElement, {Size = UDim2.new(1,0,0,expandedHeight)}, 0.2)
                        cpElement.ClipsDescendants = false
                        cpElement.ZIndex = 5
                    else
                        Utility:TweenObject(cpElement, {Size = UDim2.new(1,0,0,collapsedHeight)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
                            cpElement.ClipsDescendants = true
                            cpElement.ZIndex = 1
                        end)
                    end
                    UpdateCanvasSize()
                    if focusing then
                        for i,v_ in next, infoContainer:GetChildren() do
                           if v_.Name == "TipMore" then v_.Visible = false end
                        end
                        blurFrame.Visible = false
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        focusing = false
                    end
                end)
                
                local function HandleColorChange()
                    currentColor = Color3.fromHSV(h,s,v)
                    colorPreview.BackgroundColor3 = currentColor
                    saturationValuePicker.BackgroundColor3 = Color3.fromHSV(h,1,1)
                    if not isRainbow then
                        callback(currentColor)
                    end
                end

                local svDragging = false
                saturationValuePicker.InputBegan:Connect(function(io) if io.UserInputType == Enum.UserInputType.MouseButton1 then svDragging = true end end)
                saturationValuePicker.InputEnded:Connect(function(io) if io.UserInputType == Enum.UserInputType.MouseButton1 then svDragging = false end end)
                saturationValuePicker.InputChanged:Connect(function(io)
                    if svDragging and io.UserInputType == Enum.UserInputType.MouseMovement then
                        local localPos = saturationValuePicker.AbsolutePosition
                        local mousePos = io.Position
                        s = math.clamp((mousePos.X - localPos.X) / saturationValuePicker.AbsoluteSize.X, 0, 1)
                        v = math.clamp(1 - (mousePos.Y - localPos.Y) / saturationValuePicker.AbsoluteSize.Y, 0, 1)
                        UpdateSVThumbPosition()
                        HandleColorChange()
                    end
                end)
                
                local hueDragging = false
                hueSlider.InputBegan:Connect(function(io) if io.UserInputType == Enum.UserInputType.MouseButton1 then hueDragging = true end end)
                hueSlider.InputEnded:Connect(function(io) if io.UserInputType == Enum.UserInputType.MouseButton1 then hueDragging = false end end)
                hueSlider.InputChanged:Connect(function(io)
                     if hueDragging and io.UserInputType == Enum.UserInputType.MouseMovement then
                        local localPos = hueSlider.AbsolutePosition
                        local mousePos = io.Position
                        h = math.clamp((mousePos.X - localPos.X) / hueSlider.AbsoluteSize.X, 0, 1)
                        hueThumb.Position = UDim2.new(h, -3, 0.5, -10)
                        HandleColorChange()
                    end
                end)
                UpdateCanvasSize()
                
                viewInfo.MouseButton1Click:Connect(function()
                    if viewDe then return end
                    viewDe = true
                    focusing = true
                    for i,v_ in next, infoContainer:GetChildren() do
                        if v_.Name == "TipMore" and v_ ~= moreInfo then v_.Visible = false end
                    end
                    moreInfo.Visible = true
                    blurFrame.Visible = true
                    Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                    
                    task.delay(2, function()
                        if focusing and moreInfo.Visible then
                            moreInfo.Visible = false
                            blurFrame.Visible = false
                            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                            focusing = false
                        end
                        viewDe = false
                    end)
                end)

                local rainbowConnection
                coroutine.wrap(function()
                    while task.wait() do
                        if not ScreenGui or not ScreenGui.Parent then break end
                        if not cpElement or not cpElement.Parent then break end
                        
                        cpElement.BackgroundColor3 = themeList.colorSurface
                        headerFrame.BackgroundColor3 = themeList.colorSurface
                        colorLabel.TextColor3 = themeList.colorOnSurface
                        colorPreview.BorderColor3 = themeList.colorOutline
                        viewInfo.ImageColor3 = themeList.colorSecondary
                        pickerFrame.BackgroundColor3 = themeList.colorSurfaceVariant
                        moreInfo.BackgroundColor3 = themeList.colorTertiaryContainer
                        moreInfo.TextColor3 = themeList.colorOnTertiaryContainer
                        rainbowLabel.TextColor3 = themeList.colorOnSurfaceVariant

                        if isRainbow then
                            h = (h + 0.005) % 1
                            HandleColorChange()
                            hueThumb.Position = UDim2.new(h, -3, 0.5, -10)
                            callback(currentColor) 
                        end
                    end
                end)()
            end
            
            function Elements:NewLabel(title, size)
            	local labelFunctions = {}
            	local label = Instance.new("TextLabel")
            	local UICorner = Instance.new("UICorner")
                size = size or "Medium" 

            	label.Name = "label"
            	label.Parent = sectionElListing
            	label.BackgroundTransparency = 1
            	label.BorderSizePixel = 0
				label.ClipsDescendants = true
            	label.Text = title
           		label.Size = UDim2.new(1, 0, 0, 33)
	            label.Font = Enum.Font.Gotham
	            label.RichText = true
	            label.TextColor3 = themeList.colorOnSurfaceVariant
	            label.TextXAlignment = Enum.TextXAlignment.Left
                label.TextYAlignment = Enum.TextYAlignment.Center

                if size == "Large" then
                    label.TextSize = 18.000
                    label.Font = Enum.Font.GothamMedium
                elseif size == "Small" then
                    label.TextSize = 12.000
                else 
	                label.TextSize = 14.000
                end
	            
	           	UICorner.CornerRadius = UDim.new(0, 8)
                UICorner.Parent = label
            	
		        coroutine.wrap(function()
		            while task.wait() do
                        if not ScreenGui or not ScreenGui.Parent then break end
                        if not label or not label.Parent then break end
		                label.TextColor3 = themeList.colorOnSurfaceVariant
		            end
		        end)()
                UpdateCanvasSize()
                function labelFunctions:UpdateLabel(newText)
                	if label.Text ~= newText then
                		label.Text = newText
                	end
                end	
                return labelFunctions
            end	
            return Elements
        end
        return Sections
    end  
    return Tabs
end
return Kavo
