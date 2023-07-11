local Interface = require(script.Parent.Interface)
local Common = require(script.Parent.Parent.Common)
local Types = require(script.Parent.Parent.Types)
type self = Types.QtToolbar

local DEFAULT_ICON_ID = "rbxassetid://5570977826" -- This is a temporary icon until someone finds a better one (im sorry!)

type ButtonConfig = {
	ID: string,
	Name: string,
	Description: string,
	Icon: string?,
	ClickableWhenViewportHidden: boolean?,
	Callback: (PluginToolbarButton, self) -> ()?
}

return function(ID: string): self
	local handle = Interface(ID, "PluginToolbar")
	handle.Buttons = {}
	
	function handle.initialise(self: self, buttons)
		Common.InterfaceInit(self, function()
			local toolbar = Common.Plugin:CreateToolbar(self.ID)
			toolbar.Parent = Common.Plugin
			return toolbar
		end)
		
		return self
	end
	
	function handle.AddButton(self: self, config: ButtonConfig)
		local toolbar = self:GetMount()
		
		local id = config.ID
		local name = config.Name or id
		local description = config.Description or ""
		local icon = config.Icon or DEFAULT_ICON_ID
		local clickable = if config.ClickableWhenViewportHidden
			then config.ClickableWhenViewportHidden
			else false
		local callback = config.Callback

		local btn = toolbar:CreateButton(id, description, icon, name)
		btn.ClickableWhenViewportHidden = clickable

		if callback then
			btn.Click:Connect(function()
				callback(btn, self)
			end)
		end

		self.Buttons[id] = btn
		btn.Name = Common.FormatQtName("PluginButton", id)
		btn.Parent = toolbar
		
		return self
	end

	function handle.SetIcon(self: self, buttonID: string, icon: string?)
		local button = assert(self.Buttons[buttonID], "'" .. buttonID .. "' does not exist as a Button of '" .. self.ID .. "'")
		button.Icon = icon or DEFAULT_ICON_ID
	end
	
	return handle
end