local Create = require(script.Parent.Create)
local Baselib = require(script.Parent.Parent.Baselib)
local PluginName = Baselib.Plugin.Name

local function WelcomeScreen()
	return Create("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 1,
		Name = "GradientFrame",
		Size = UDim2.fromScale(1, 1),

		Create("UIGradient", {
			Color = ColorSequence.new(
				Color3.fromRGB(255, 106, 0),
				Color3.fromRGB(0, 255, 144)
			),

			Rotation = -90,
			Transparency = NumberSequence.new {
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(0.5, 1),
				NumberSequenceKeypoint.new(1, 0),
			}
		}),

		Create("UIPadding", {
			PaddingBottom = UDim.new(0, 20),
			PaddingLeft = UDim.new(0, 20),
			PaddingRight = UDim.new(0, 20),
			PaddingTop = UDim.new(0, 20)
		}),

		Create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Name = "ContentCenter",
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 0),

			Create("UIListLayout", {
				Padding = UDim.new(0, 20),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),

			Create("TextLabel", {
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				FontFace = Font.fromName("GothamSSm", Enum.FontWeight.Bold),
				LayoutOrder = 0,
				Text = "Welcome to Tabby!",
				TextSize = 40,
				TextColor3 = Color3.new(1, 1, 1),
				TextWrapped = true
			}),

			Create("TextLabel", {
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				FontFace = Font.fromName("GothamSSm"),
				LayoutOrder = 1,
				Text = `Everything has initialised properly! Check PluginDebugService for the plugin {PluginName}, then check the documentation for the next steps.`,
				TextSize = 18,
				TextColor3 = Color3.new(1, 1, 1),
				TextWrapped = true
			})
		})
	})
end

return WelcomeScreen