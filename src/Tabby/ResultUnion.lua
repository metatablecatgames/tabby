-- Just a simple object that combines an ID with a string
-- Use for Result objects

local Types = require(script.Parent.Types)

type ResultUnion = typeof(setmetatable({}::{
	_keys: {[string]: boolean}
}, {}::{
	__index: (ResultUnion, key: string) -> (msg: string) -> Types.ResultUnion
}))

return function(validKeys: {string}): ResultUnion
	local shaped = {}
	for _, key in validKeys do
		shaped[key] = true
	end

	return setmetatable({_keys = shaped}, {
		__index = function(self, key)
			assert(self._keys[key], `Cannot emit ResultUnion {key}`)
			return function(msg)
				return {
					id = key,
					msg = msg
				}
			end
		end
	})
end
