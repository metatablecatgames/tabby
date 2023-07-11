--!strict
-- TabbyForm
local Types = require(script.Parent.Types)
type Form<O..., C...> = Types.Form<O..., C...>

local Common = require(script.Parent.Common)
local PluginHandle = Common.Plugin

type TabbyFormConstruct = {
	GuiInfo: DockWidgetPluginGuiInfo?,
	Render: (() -> Instance)?,
	Props: Types.DockWidgetPluginGuiBindings?
}

return function(formName: string)
	return function<O..., C...>(params: TabbyFormConstruct): Form<O..., C...>
		local guiInfo = params.GuiInfo or DockWidgetPluginGuiInfo.new()
		local dockWidget = PluginHandle:CreateDockWidgetPluginGui(formName, guiInfo)
		local renderFunc = params.Render
		local props = params.Props

		if props then
			for propName, propVal in props do
				dockWidget[propName] = propVal
			end
		end

		if renderFunc then
			local handle = renderFunc()
			handle.Parent = dockWidget
		end

		local Form: Form<O..., C...> = {
			Name = formName,
			DockWidget = dockWidget,
			IsLoaded = false,

			Open = function(self: Form<O..., C...>, ...: O...)
				if not self.IsLoaded then
					local findLoading = self.Loading
					if findLoading then
						findLoading(self)
					end

					self.IsLoaded = true
				end

				local findOpening = self.Opening
				if findOpening then
					findOpening(self, ...)
				end

				self.DockWidget.Enabled = true
			end,

			Close = function(self: Form<O..., C...>, ...: C...)
				local findClosing = self.Closing
				if findClosing then
					findClosing(self, ...)
				end

				self.DockWidget.Enabled = false
			end
		}

		return Form
	end
end