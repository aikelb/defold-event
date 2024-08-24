---@class event
---@field create fun(callback: function|nil, callback_context: any|nil): event
---@field subscribe fun(self: event, callback: function, callback_context: any|nil): boolean
---@field unsubscribe fun(self: event, callback: function, callback_context: any|nil): boolean
---@field is_subscribed fun(self: event, callback: function, callback_context: any|nil): boolean
---@field trigger fun(self: event, a: any, b: any, c: any, d: any, e: any, f: any, g: any, h: any, i: any, j: any): nil
---@field clear fun(self: event): nil
---@field is_empty fun(self: event): boolean

---@class events
---@field subscribe fun(event_name: string, callback: function, callback_context: any|nil): boolean
---@field unsubscribe fun(event_name: string, callback: function, callback_context: any|nil): boolean
---@field is_subscribed fun(event_name: string, callback: function, callback_context: any|nil): boolean
---@field trigger fun(event_name: string, ...: any): any @Result of the last callback
---@field clear fun(name: string): nil
---@field clear_all fun(): nil
---@field is_empty fun(name: string): boolean

---@class event.callback_data
---@field script_context any
---@field callback fun()
---@field callback_context any

---@class event.logger
---@field trace fun(logger: event.logger, message: string, data: any|nil)
---@field debug fun(logger: event.logger, message: string, data: any|nil)
---@field info fun(logger: event.logger, message: string, data: any|nil)
---@field warn fun(logger: event.logger, message: string, data: any|nil)
---@field error fun(logger: event.logger, message: string, data: any|nil)
