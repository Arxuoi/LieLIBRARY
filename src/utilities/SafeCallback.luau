return function(context, callback, ...)
	if type(callback) ~= "function" then return true end
	local ok, result = xpcall(callback, debug.traceback, ...)
	if not ok then warn(("[Breeze] Callback failed (%s): %s"):format(context, tostring(result))) end
	return ok, result
end
