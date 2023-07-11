
local Action = require(script.Parent.PluginAction)
local Interface = require(script.Parent.Interface)
local Common = require(script.Parent.Parent.Common)
local Types = require(script.Parent.Parent.Types)
type self = Types.QtMenu

local function TreeGetRecursive(menu, treeVal)
	for _, v in menu.Children do
		table.insert(treeVal, v)
		if v:IsA("PluginMenu") then
			TreeGetRecursive(v, treeVal)
		end
	end
end

local function RemoveTemporaryAction(action: Types.QtAction)
	if action.IsTemporaryAction then
		action:GetMount():Destroy()
	end
end

return function(ID: string): self
	local handle = Interface(ID, "PluginMenu")
	
	function handle.initialise(self: self, title, icon)
		Common.InterfaceInit(self, function()
			local newMenu = Common.Plugin:CreatePluginMenu(self.ID, title, icon)
			
			self.Children = {}
			self.ChildActions = {}
			self.ChildMenus = {}
			return newMenu
		end)
		
		return self
	end	
	
	function handle.Clear(self: self)
		local menu = self:GetMount()
		menu:Clear()

		table.clear(self.Children)
		table.clear(self.ChildMenus)

		for _, Action in self.ChildActions do
			RemoveTemporaryAction(Action)
		end

		table.clear(self.ChildActions)
	end

	function handle.ShowAsync(self: self)
		self:GetMount():ShowAsync()
	end
	
	function handle.AddMenu(self: self, menu: self): self
		self:GetMount():AddMenu(menu:GetMount())
		self.ChildMenus[menu.ID] = menu

		table.insert(self.Children, menu)
		return self
	end
	
	function handle.AddAction(self: self, action: Types.QtAction): self
		self:GetMount():AddAction(action:GetMount())
		self.ChildActions[action.ID] = action

		table.insert(self.Children, action)
		return self
	end
	
	function handle.AddNewAction(self: self, id: string, title: string, icon: string?, callback: () -> ()?): self
		-- TODO: Find a cleaner way of implementing temporary actions
		-- This shouldn't memory leak (hopefully lol)
		local act = self:GetMount():AddNewAction(id, title, icon)
		local mountableAction = Action(id)
		mountableAction.Mount = act
		mountableAction.IsTemporaryAction = true

		if callback then
			act.Triggered:Connect(callback)
		end
		
		self.ChildActions[id] = mountableAction
		table.insert(self.Children, mountableAction)
		return self
	end

	function handle.GetFullTree(self: self): {self|Types.QtAction}
		local out = {}
		TreeGetRecursive(self, out)
		return out
	end
	
	function handle.SetActionIcon(self: self, actionID: string, icon: string)
		local action = self.ChildActions[actionID]
		if not action then
			error("Action '" .. actionID .. "' is not a member of Menu '" .. self.ID .. "'.")
		end

		action:SetIcon(icon)
	end

	function handle.SetIcon(self: self, icon: string)
		self:GetMount().Icon = icon
	end
		
	return handle
end