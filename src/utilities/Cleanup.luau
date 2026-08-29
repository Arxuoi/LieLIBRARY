local Cleanup = {}

function Cleanup.create()
	local tasks = {}
	local alive = true
	local handle = {}

	function handle:Add(task)
		if not alive then
			if typeof(task) == "Instance" then task:Destroy() elseif typeof(task) == "RBXScriptConnection" then task:Disconnect() end
			return task
		end
		table.insert(tasks, task)
		return task
	end

	function handle:Clean()
		if not alive then return end
		alive = false
		for index = #tasks, 1, -1 do
			local task = tasks[index]
			if typeof(task) == "RBXScriptConnection" then task:Disconnect()
			elseif typeof(task) == "Instance" then task:Destroy()
			elseif type(task) == "function" then task()
			elseif type(task) == "table" then
				if task.Destroy then task:Destroy() elseif task.Clean then task:Clean() elseif task.Disconnect then task:Disconnect() end
			end
			tasks[index] = nil
		end
	end

	handle.Destroy = handle.Clean
	return handle
end

return Cleanup
