-- Common object for initialising interfaces
type QtInterface = {
	ID: string,
	Type: string,
	Mount: nil,
	GetMount: (QtInterface) -> ()
}

local function Interface(id: string, classType: string): QtInterface
	local interface = {}
	interface.ID = id
	interface.Type = classType
	interface.Mount = nil :: any
	
	function interface:GetMount()
		return assert(self.Mount, "QtObject not initialised")
	end

	function interface:IsA(Type: string): boolean
		return self.Type == Type
	end

	return interface
end

return Interface