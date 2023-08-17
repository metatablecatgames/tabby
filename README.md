# Tabby 🐈

The Cat plugin framework.

## Installation
Copy the `src` folder then add a Fragments folder and a `Project.lua` file

Your `Project.lua` file should have this shape:
```lua
return {
	Name = "Tabby Project",

	Fragments = {
		main = script.Parent.Fragments.main
	},

	FragmentGroups = {
		main = {"main"}
	},

	ActiveGroup = "main"
}
```

Create a Fragment called `main` and place this code in the `Fragments` folder
```lua
local Tabby = require(script.Parent.Parent.Tabby)
local Me = Tabby.Fragment(script)

Me:Connect("Init", function()
	print("Hello World!")
end)

return {}
```

Refer to Documentation for more info on how to use Tabby!

# Special Thanks
[Support me for £3+ here](https://github.com/sponsors/metatablecat) and I'll add your profile picture here and in release builds
