-- Extension
-- Linker for the "Internal" export of the Tabby runtime package
local TabbyRuntime = require(script.Parent.Tabby)
local Types = require(script.Types)

local Common = require(script.Common)
Common.Plugin = TabbyRuntime.Plugin
local Tabby = {}

-- Exports (please keep these ordered)
Tabby.Action = require(script.Action)
Tabby.Base64 = require(script.Base64)
Tabby.Event = require(script.Event)
Tabby.Form = require(script.Form)
Tabby.Input = require(script.Input)
Tabby.Plugin = Common.Plugin::Plugin
Tabby.QtInterface = require(script.QtInterface)
Tabby.Result = require(script.Result)

-- Types
export type Action<A..., R...> = Types.Action<A..., R...>
export type Event<A...> = Types.Event<A...>
export type Form<O..., C...> = Types.Form<O..., C...>
export type QtAction = Types.QtAction
export type QtMenu = Types.QtMenu
export type QtToolbar = Types.QtToolbar
export type TabbyInputObject = Types.TabbyInputObject

export type Ok<O> = Types.Ok<O>
export type Err<E> = Types.Err<E>
export type OkErr<O, E> = Types.OkErr<O, E>
export type Result<O, E> = Types.Result<O, E>

return Tabby