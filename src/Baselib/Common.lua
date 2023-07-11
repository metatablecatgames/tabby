-- Misc functions
local Common = {}
local SINGLETON_STORE = {}

function Common.IsLikelyInterfaceObject(interfaceObject): (boolean, string?)
	if typeof(interfaceObject) ~= "table" then
		return false
	end
	
	local getType = interfaceObject.Type
	if getType then
		return true, getType
	end
	
	return false
end

function Common.InterfaceInit(self, hookCallback)
	if Common.GetClassSingleton(self.Type, self.ID) then
		error(self.ID .. " can only exist once!")
	end

	local obj = hookCallback()
	self.Mount = obj
	Common.AddClassSingleton(self.Type, self.ID, self)
	obj.Name = Common.FormatQtName(self.Type, self.ID)
	return obj
end

function Common.FormatQtName(qtype, name)
	return string.format("%s [%s]", qtype, name)
end

function Common.FindEnumItemFromValue(enum: Enum, number)
	for _, v in enum:GetEnumItems() do
		if v.Value == number then
			return v
		end
	end

	return nil
end

function Common.GetKeyCodeEnumFromChar(k)
	local byte = string.byte(k)
	local keyCode = Common.FindEnumItemFromValue(Enum.KeyCode, byte)
	return keyCode
end

function Common.AddClassSingleton(className: string, objectName: string, object: string)
	-- classable singleton
	local findRoot = SINGLETON_STORE[className]
	if not findRoot then
		findRoot = {}
		SINGLETON_STORE[className] = findRoot
	end

	findRoot[objectName] = object
end

function Common.AddFloatingSingleton(name: string, any)
	-- classless singleton
	SINGLETON_STORE[name] = any
end

function Common.GetClassSingleton(className: string, name: string)
	local findRoot = SINGLETON_STORE[className] or {}
	return findRoot[name]
end

function Common.GetFloatingSingleton(name: string)
	return SINGLETON_STORE[name]
end

function Common.ClearClassSingletons(className: string)
	-- hook for testing, do not use in production code
	SINGLETON_STORE[className] = {}
end

Common.Plugin = nil
Common.Extension = nil
return Common