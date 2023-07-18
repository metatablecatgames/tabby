-- Tabby Runtime API
-- You should be using this for Fragments

local SharedState = require(script.SharedState)
local Plugin = script:FindFirstAncestorOfClass("Plugin")
SharedState.Plugin = Plugin

local Tabby = {}
Tabby.Fragment = require(script.Fragment)
Tabby.Runtime = require(script.Runtime)
Tabby.Plugin = Plugin

-- TODO: Insert Corelib globally

return Tabby