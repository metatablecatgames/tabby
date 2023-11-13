-- Parses project module scripts
local Types = require(script.Parent.Types)
local Result = require(script.Parent.Result)
local ResultUnion = require(script.Parent.ResultUnion)

local PROJECT_RESULT_UNION = ResultUnion {
	"PROJECT_UNKNOWN",
	"PROJECT_INVALID_TYPE",
	"PROJECT_EMPTY_VALUE"
}

local PROJECT_SHAPE = {
	Name = "string",
	Fragments = "table",
	FragmentGroups = "table",
	ActiveGroup = "string"
}

local function typecheck(value: any, expected_type: string, key_name: string, result: Types.Result<any, Types.ResultUnion>): Types.Err<Types.ResultUnion>?
	local obj_type = typeof(value)

	if obj_type ~= expected_type then
		local msg = `Project.{key_name} expects type {expected_type}, got {obj_type}`
		return result:Err(PROJECT_RESULT_UNION:PROJECT_INVALID_TYPE(msg))
	end

	return nil
end

return function(projectModule: Types.Map<string, any>): Types.OkErr<Types.Project, Types.ResultUnion>
	local result: Types.Result<Types.Project, Types.ResultUnion> = Result {
		default = PROJECT_RESULT_UNION:PROJECT_UNKNOWN()
	}

	local name: string = projectModule.Name
	local fragments: Types.Map<string, Instance> = projectModule.Fragments
	local groups: Types.Map<string, {string}> = projectModule.FragmentGroups
	local active_group: string = projectModule.ActiveGroup

	for k, t in PROJECT_SHAPE do
		local v = projectModule[k]
		local e = typecheck(v, t, k, result)
		if e then return e end
	end
	
	local project = {}
	project.Name = name
	project.Fragments = fragments
	
	for groupName, fragmentNames in groups do
		for idx, fragmentName in fragmentNames do
			fragmentNames[idx] = fragments[fragmentName]
		end
	end
	
	project.FragmentGroups = groups
	project.ActiveGroup = groups[active_group]

	return result:Ok(project)
end