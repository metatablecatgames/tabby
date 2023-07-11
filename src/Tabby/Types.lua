-- Common
export type Map<K, V> = {[K]: V}

--/Fragment.lua
export type Fragment = {
	Script: Script,
	Connect: (Fragment, name: string, func: (self: Fragment, ...any) -> ()) -> ()
}

--/Project.lua
export type Project = {
	Name: string,
	Fragments: Map<string, Instance>,
	FragmentGroups: Map<string, {Instance}>,
	ActiveGroup: {Instance}
}

--/Result.lua
export type Ok<T> = {
	IsOk: true,
	Ok: T,
}

export type Err<T> = {
	IsOk: false,
	Err: T
}

export type OkErr<O, E> = Ok<O>|Err<E>

export type Result<O, E> = {
	Ok: (Result<O, E>, ok: O) -> Ok<O>,
	Err: (Result<O, E>, err: E) -> Err<E>,
	FromLuaError: (Result<O, E>, msg: string) -> Err<E>,
	FromPcall: <A...>(
		Result<O, E>,
		f: (A...) -> O,
		A...
	) -> OkErr<O, E>
}

--/ResultUnion.lua
export type ResultUnion = {
	id: string,
	msg: string
}

--/Runtime.lua
export type FragmentModule = {
	Module: ModuleScript,
	Runtime: any,
	LoadNoYield: (FragmentModule) -> OkErr<any, ResultUnion>
}

export type Runtime = {
	Fragments: {Fragment},
	FragmentGroup: {FragmentModule},
	InvokeBaseLifecycleEvent: (Runtime, name: string, ...any) -> (),
	RunFragmentGroup: (Runtime) -> ()
}

return nil