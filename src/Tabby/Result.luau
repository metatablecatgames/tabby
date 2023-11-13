local Types = require(script.Parent.Types)
type Ok<T> = Types.Ok<T>
type Err<T> = Types.Err<T>
type OkErr<O, E> = Types.OkErr<O, E>
type Result<O, E> = Types.Result<O, E>

type matches<E> = {
	default: E?,
	[string]: E
}

local function findFirstMatch<E>(msg: string, matches: matches<E>): E?
	-- finds the first match given a msg and table of matches
	-- matches = {[Pattern] = return}
	-- return the match's value
	
	-- iterate over matches
	for pattern, value in pairs(matches) do
		if string.match(msg, pattern) then
			return value
		end
	end
	
	return matches.default
end

local function result(isok, d): OkErr<any, any>
	return {
		IsOk = isok,
		Ok = if isok then d else nil,
		Err = if not isok then d else nil
	}
end

--[[
	`Result` is an error handling factory based on `Result` objects from Rust.

	It can be used to match Lua error strings to Enum values (see Code Example)

	### Code Example
	```lua
	local CatError = Result {
		["A cat was not found"] = "CAT_NOT_FOUND"
		["This cat has an invalid name"] = "CAT_INVALID_NAME",
		default = "CAT_UNKNOWN_ERR"
	}

	local function Cat(name)
		if type(name) ~= "string" then
			error("This cat has an invalid name")
		end

		return assert(Cats[name], "A cat was not found")
	end

	local catResult = Result:FromPcall(Cat, 0)
	if catResult.IsOk then
		...
	else
		if catResult.Err = "CAT_NOT_FOUND" then

		elseif catResult.Err = "CAT_INVALID_NAME" then

		end
	end
	```
]]
local function Result<O, E>(matches: matches<E>): Result<O, E>
	local gen = {}
	gen._errmatch = matches
	
	--[[
		Emits an `Ok` value on the Result
	]]
	function gen:Ok(ok: O): Ok<O>
		local r = result(true, ok)
		table.freeze(r)
		return r
	end
	
	--[[
		Emits an `Err` (Error) value on the Result
	]]
	function gen:Err(err: E): Err<E>
		local r = result(false, err)
		table.freeze(r)
		return r
	end
	
	--[[
		Generates an `Err` off a provided error mapping in the constructor
	]]
	function gen:FromLuaError(msg: string): Err<E>
		local matchedMsg = findFirstMatch(msg, self._errmatch)
		return self:Err(matchedMsg)
	end
	
	--[[
		Executes the passed function in a pcall then generates a `Result` based on
		the state of the pcall.
	]]
	function gen:FromPcall<A...>(f: (A...) -> O, ...:A...): OkErr<O, E>
		local s, e = pcall(f, ...)
		if not s then
			return self:FromLuaError(e)
		else
			return self:Ok(e)
		end
	end
	
	return gen
end

return Result