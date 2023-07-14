local Tabby = require(script.Parent.Parent.Tabby)
local Me = Tabby.Fragment(script)

Me:Connect("Init", function()
	print("Hello World!")
end)

return {}