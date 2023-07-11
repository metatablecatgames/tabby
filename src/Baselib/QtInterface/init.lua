-- Storage container for singletons
-- To learn more about QtInterface and the .tabby folder: https://https://github.io/tabby/qtInterface
local Common = require(script.Parent.Common)
local Types = require(script.Parent.Types)

local function classGetQuick(key, name, provider)
	local get = Common.GetClassSingleton(key, name)
	if not get then
		get = provider(name)
	end
	
	return get
end

local QtInterface = {}

local Action = require(script.PluginAction)
local Menu = require(script.Menu)
local Toolbar = require(script.Toolbar)

function QtInterface:GetAction(actionName: string): Types.QtAction
	return classGetQuick("PluginAction", actionName, Action)
end

function QtInterface:GetMenu(menuName: string): Types.QtMenu
	return classGetQuick("PluginMenu", menuName, Menu)
end

function QtInterface:GetToolbar(toolbarName: string): Types.QtToolbar
	return classGetQuick("PluginToolbar", toolbarName, Toolbar)
end

return QtInterface