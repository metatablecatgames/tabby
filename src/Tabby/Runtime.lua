-- RuntimeMain
-- Base Runtime service for Tabby

local SharedState = require(script.Parent.SharedState)
local Types = require(script.Parent.Types)
local Project = require(script.Parent.Project)
local Result = require(script.Parent.Result)
local ResultUnion = require(script.Parent.ResultUnion)

local FRAGMENT_RESULT_UNION = ResultUnion {
	"FRAGMENT_UNKNOWN_ERROR",
	"FRAGMENT_MODULE_YIELD",
	"FRAGMENT_FAIL_LOAD"
}

local function FragmentModule(self, module): Types.FragmentModule
	local fragmentModule = {}
	fragmentModule.Module = module
	fragmentModule.Runtime = self

	function fragmentModule:LoadNoYield()
		local generator = Result {
			default = FRAGMENT_RESULT_UNION:FRAGMENT_UNKNOWN_ERROR()
		}
		local couldLoadModule, moduleErr

		local thread = task.spawn(function()
			couldLoadModule, moduleErr = pcall(require, self.Module)
		end)

		if coroutine.status(thread) ~= "dead" then
			return generator:Err(FRAGMENT_RESULT_UNION:FRAGMENT_MODULE_YIELD("The module cannot yield"))
		end

		if not couldLoadModule then
			return generator:Err(FRAGMENT_RESULT_UNION:FRAGMENT_FAIL_LOAD("The module did not load"))
		end

		return generator:Ok(moduleErr)
	end

	return fragmentModule
end

return function(project_module: ModuleScript): Types.Runtime
	local rt = {}
	rt.Fragments = {}
	rt.FragmentGroup = {}
	rt._FragmentScriptSlots = {}
	rt._NestedFragmentCalls = {}

	local project = Project(require(project_module))
	if not project.IsOk then
		local err = project.Err
		error(`Failed to load Project: {err.id}:{err.msg}`)
	end

	local baseGroup = project.ActiveGroup
	if baseGroup == "" then
		error("Project.ActiveGroup cannot be an empty string")
	end

	for idx, module in baseGroup do
		local fragmentModule = FragmentModule(rt, module)
		rt._FragmentScriptSlots[module] = idx
		table.insert(rt.FragmentGroup, fragmentModule)
	end

	function rt:InvokeBaseLifecycleEvent(name: string, ...: any)
		for _, fragment in self.Fragments do
			fragment:INTERNAL_InvokeBaseLifecycleEvent(name, ...)
		end
	end

	function rt:RunFragmentGroup()
		for _, fragment: Types.FragmentModule in self.FragmentGroup do
			local moduleResult = fragment:LoadNoYield()

			if not moduleResult.IsOk then
				warn("Failed to load fragment " .. fragment.Module.Name)
			else
				for src, fragment in self._NestedFragmentCalls do
					local slot = self._FragmentScriptSlots[src]
					self.Fragments[slot] = fragment
				end
			end

			self._NestedFragmentCalls = {}
		end
	end
	
	SharedState.ActiveRuntimeSource = rt
	return rt
end