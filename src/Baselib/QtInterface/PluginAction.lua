local Interface = require(script.Parent.Interface)
local Common = require(script.Parent.Parent.Common)
local Types = require(script.Parent.Parent.Types)
type self = Types.QtAction

return function(ID: string): self
	local handle = Interface(ID, "PluginAction")
	
	function handle.initialise(self: self, name, description, icon, allowBinding, callback)
		Common.InterfaceInit(self, function()
			local newAction = Common.Plugin:CreatePluginAction(self.ID, name, description, icon, allowBinding)
			newAction.Name = self.ID
			newAction.IsTemporaryAction = false
			
			if callback then
				newAction.Triggered:Connect(callback)
			end

			return newAction
		end)
	end

	function handle.SetIcon(self: self, icon: string)
		error("Unimplemented!")
	end

	return handle
end