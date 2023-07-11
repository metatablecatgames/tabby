-- The default Tabby application, renders a welcome screen
local Root = script.Parent.Parent
local STUDIO_SETTINGS = settings().Studio
local DEBUGGING_ENABLED = STUDIO_SETTINGS.PluginDebuggingEnabled

-- Base imports that you will use a lot
local Tabby = require(Root.Tabby)
local Baselib = require(Root.Baselib)
local WelcomeScreenElement = require(Root.Components.WelcomeScreenBase)

local PLUGIN_NAME = Baselib.Plugin.Name

-- create the base fragment, this must link back to the script
local Me = Tabby.Fragment(script)

-- Set up the main listener event for the fragment
Me:Connect("Init", function()
	-- first of all, this plugin should be used with PluginDebuggingService, so if its off
	-- we enable it here
	if not DEBUGGING_ENABLED then
		print(`Setting Studio.PluginDebuggingEnabled was set to true by Plugin {PLUGIN_NAME}`)
		STUDIO_SETTINGS.PluginDebuggingEnabled = true
	end

	-- we'll create a Form, then a button to open said form
	local WelcomeForm = Baselib.Form "Welcome" {
		GuiInfo = DockWidgetPluginGuiInfo.new(
			Enum.InitialDockState.Float,
			false, false,
			600, 400,
			600, 400
		),

		Render = function()
			-- render the main content frame
			local mainContentFrame = Instance.new("Frame")
			mainContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			mainContentFrame.BorderSizePixel = 0
			mainContentFrame.Name = "MainContent"
			mainContentFrame.Size = UDim2.fromScale(1, 1)

			if not DEBUGGING_ENABLED then
				local noDebugLabel = Instance.new("TextLabel")
				noDebugLabel.AnchorPoint = Vector2.new(0.5, 0.5)
				noDebugLabel.AutomaticSize = Enum.AutomaticSize.Y
				noDebugLabel.BackgroundTransparency = 1
				noDebugLabel.Name = "PluginDebuggingDisabled"
				noDebugLabel.Position = UDim2.fromScale(0.5, 0.5)
				noDebugLabel.Size = UDim2.fromScale(1, 0)
				noDebugLabel.FontFace = Font.fromName("GothamSSm")
				noDebugLabel.Text = "Plugin Debugging wasn't enabled. It has been enabled, please restart Studio."
				noDebugLabel.TextColor3 = Color3.new(1,1,1)
				noDebugLabel.TextSize = 14
				noDebugLabel.TextWrapped = true
				noDebugLabel.Parent = mainContentFrame

				return mainContentFrame
			end

			WelcomeScreenElement().Parent = mainContentFrame
			return mainContentFrame
		end,

		Props = {
			Name = "form-tabby",
			Title = "Welcome to Tabby"
		}
	}

	-- create the open button
	Baselib.QtInterface:GetToolbar("Tabby")
		:initialise()
		:AddButton {
			ID = "btn-openform",
			Name = "Tabby",
			Description = "",
			Callback = function()
				WelcomeForm:Open()
			end
		}
end)

-- Fragments cant yield on startup, which means if this was uncommented, it would throw
-- task.wait(5)
-- This is because otherwise, properly tracking already initialised scripts could result
-- in breakage

-- You can return anything you want here, Tabby magically resolves imports between Fragments
-- since it is statically linked when you call Tabby.Fragment()
return {}