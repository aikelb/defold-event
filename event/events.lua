local Event = require("event.event")

---@class events @Global events object.
local M = {}

---@type table<string, event>
M.events = {}


---Throw a global event with the specified name. All subscribed callbacks will be executed.
---@param event_name string The name of the global event to trigger.
---@vararg any Any number of parameters to be passed to the subscribed callbacks.
---@return any result Result of the last triggered callback
function M.trigger(event_name, ...)
	local event = M.events[event_name]
	if event then
		return event:trigger(...)
	end
end


---Remove all callbacks subscribed to the specified global event.
---@param name string The name of the global event to clear.
function M.clear(name)
	M.events[name] = nil
end


---Remove all callbacks subscribed to all global events.
function M.clear_all()
	M.events = {}
end


---Subscribe a callback to the specified global event.
---@param event_name string The name of the global event to subscribe to.
---@param callback function The callback function to be executed when the global event occurs.
---@param callback_context any|nil The first parameter to be passed to the callback function.
---@return boolean is_subscribed True if event is subscribed (Will return false if callback is already subscribed)
function M.subscribe(event_name, callback, callback_context)
	M.events[event_name] = M.events[event_name] or Event.create()
	local is_subscribed = M.events[event_name]:subscribe(callback, callback_context)
	return is_subscribed
end


---Remove a previously subscribed callback from the specified global event.
---@param event_name string The name of the global event to unsubscribe from.
---@param callback function The callback function to unsubscribe.
---@param callback_context any|nil The first parameter to be passed to the callback function. If not provided, all callbacks with the same function will be unsubscribed.
---@return boolean is_unsubscribed True if event is unsubscribed
function M.unsubscribe(event_name, callback, callback_context)
	if not M.events[event_name] then
		return false
	end

	return M.events[event_name]:unsubscribe(callback, callback_context)
end


---Determine if a specific callback is currently subscribed to the specified global event.
---@param event_name string The name of the global event in question.
---@param callback function The callback function in question.
---@param callback_context any|nil The first parameter to be passed to the callback function.
---@return boolean is_subscribed True if the callback is subscribed to the global event
---@return number|nil index Index of callback in event if subscribed
function M.is_subscribed(event_name, callback, callback_context)
	if not M.events[event_name] then
		return false
	end

	return M.events[event_name]:is_subscribed(callback, callback_context)
end


---Check if the specified global event has no subscribed callbacks.
---@param event_name string The name of the global event to check.
---@return boolean is_empty True if the global event has no subscribed callbacks
function M.is_empty(event_name)
	if not M.events[event_name] then
		return true
	end

	return M.events[event_name]:is_empty()
end


return M
