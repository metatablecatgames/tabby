local SharedState = require(script.Parent.SharedState)

return function(extCreator: string, extName: string)
	local ext = {}
	ext.Name = extName
	ext.Creator = extCreator
	ext.FullName = `{extCreator}.{extName}`
	ext.Plugin = SharedState.Plugin

	function ext:Invoke(lifecycle: string, ...)
		local runtime = SharedState.ActiveRuntimeSource

		for _, fragment in runtime.Fragments do
			fragment:INTERNAL_InvokeExternalLifecycleEvent(self.FullName, lifecycle, ...)
		end
	end

	return ext
end