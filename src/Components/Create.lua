return function(className: string, props: {[string|number]: any})
	local inst = Instance.new(className)
	local parent = props.Parent
	if parent then
		props.Parent = nil
	end

	for i, v in pairs(props) do
		if type(i) == "number" then
			v.Parent = inst
		else
			inst[i] = v
		end
	end

	inst.Parent = parent
	return inst
end