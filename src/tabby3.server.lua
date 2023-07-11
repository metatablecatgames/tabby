-- Tabby3 base Runscript
-- Debug mode script
local RunService = game:GetService("RunService")
local Tabby = require(script.Parent.Tabby)
local Project = script.Parent:FindFirstChild("Project")

if not Project then
	error("Failed to find Project file.")
end

local Runtime = Tabby.Runtime(Project)
Runtime:RunFragmentGroup()
Runtime:InvokeBaseLifecycleEvent("Init")

RunService.Heartbeat:Connect(function(dt)
	Runtime:InvokeBaseLifecycleEvent("Update", dt)
end)

plugin.Unloading:Connect(function()
	Runtime:InvokeBaseLifecycleEvent("Unloading")
end)