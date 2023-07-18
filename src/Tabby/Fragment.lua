local SharedState = require(script.Parent.SharedState)
local Types = require(script.Parent.Types)
local FragmentScriptLinks = {}

return function(scriptLinker: Script): Types.Fragment
	if not scriptLinker or typeof(scriptLinker) ~= "Instance" or not scriptLinker:IsA("LuaSourceContainer") then
		error("A Script linker is required!")
	end

	local ActiveRuntimeSource = SharedState.ActiveRuntimeSource
	if not ActiveRuntimeSource then
		error("Internal Error: No RuntimeSource in Active shared state. Please report this")
	end

	if FragmentScriptLinks[scriptLinker] then
		error("Only one Fragment/Script pair can exist!")
	end

	local Fragment = {}
	Fragment.Plugin = SharedState.Plugin
	Fragment.Script = scriptLinker
	Fragment._lifecycles = {}
	Fragment._extLifecycles = {}
	Fragment._extImports = {}

	function Fragment:Connect(lifecycle: string, func: (...any) -> ())
		local is_ext = string.sub(lifecycle, 1, 1) == "@"
		if is_ext then
			local extension_pos = string.find(lifecycle, ":", 0, true)
			if not extension_pos then
				error("Invalid Lifecycle Hook Format!")
			end

			local ext_src = string.sub(lifecycle, 2, extension_pos - 1)
			local lifecycle_name = string.sub(lifecycle, extension_pos + 1)
			local ext = self._extLifecycles[ext_src]
			if not ext then
				ext = {}
				self._extLifecycles[ext_src] = ext
			end

			ext[lifecycle_name] = func
		else
			self._lifecycles[lifecycle] = func
		end
	end

	function Fragment:INTERNAL_InvokeBaseLifecycleEvent(lifecycle: string, ...)
		local f = self._lifecycles[lifecycle]
		if f then
			task.spawn(f, self, ...)
		end
	end

	function Fragment:INTERNAL_InvokeExternalLifecycleEvent(ext: string, lifecycle: string, ...)
		local ext_lifecycles = self._extLifecycles[ext]

		if ext_lifecycles then
			local f = ext_lifecycles[lifecycle]
			if f then
				task.spawn(f, self, ...)
			end
		end
	end
	
	print("DEBUG: Create fragment from " .. scriptLinker.Name)
	ActiveRuntimeSource._NestedFragmentCalls[scriptLinker] = Fragment
	return Fragment
end