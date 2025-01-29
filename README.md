![](media/logo.png)

[![GitHub release (latest by date)](https://img.shields.io/github/v/tag/insality/defold-event?style=for-the-badge&label=Release)](https://github.com/Insality/defold-event/tags)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/insality/defold-event/ci_workflow.yml?style=for-the-badge)](https://github.com/Insality/defold-event/actions)
[![codecov](https://img.shields.io/codecov/c/github/Insality/defold-event?style=for-the-badge)](https://codecov.io/gh/Insality/defold-event)

[![Github-sponsors](https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#EA4AAA)](https://github.com/sponsors/insality) [![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/insality) [![BuyMeACoffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/insality)


# Event

**Event** - is a single file Lua module for the [Defold](https://defold.com/) game engine. It provides a simple and efficient way to manage events and callbacks in your game.


## Features

- **Event Management**: Create, subscribe, unsubscribe, and trigger events.
- **Cross-Context**: You can subscribe to events from different scripts.
- **Callback Management**: Attach callbacks to events with optional data.
- **Global Events**: Create and subscribe global events that can be triggered from anywhere in your game.
- **Logging**: Set a logger to log event activities.
- **Memory Allocations Tracker**: Detects if an event callback causes a huge memory allocations.


## Setup

### [Dependency](https://www.defold.com/manuals/libraries/)

Open your `game.project` file and add the following line to the dependencies field under the project section:

**[Defold Event](https://github.com/Insality/defold-event/archive/refs/tags/10.zip)**

```
https://github.com/Insality/defold-event/archive/refs/tags/10.zip
```

### Library Size

> **Note:** The library size is calculated based on the build report per platform

| Platform         | Library Size |
| ---------------- | ------------ |
| HTML5            | **2.07 KB**  |
| Desktop / Mobile | **3.54 KB**  |


### Memory Allocation Tracking

**Enabling in `game.project`**

To monitor memory allocations for event callbacks, add to your `game.project`:

```ini
[event]
memory_threshold_warning = 50
```

- `memory_threshold_warning`: Threshold in kilobytes for logging warnings about memory allocations. `0` disables tracking.

The event memory tracking is not 100% accurate and is used to check unexpected huge leaks in the event callbacks. The memory tracking applied additional memory allocations for tracking purposes.

Memory allocation tracking is turned off in release builds, regardless of the `game.project` settings.


## API Reference

### Quick API Reference

```lua
local event = require("event.event")
event.set_logger(logger)
event.set_memory_threshold(threshold)

local event_instance = event.create(callback, [callback_context])
event_instance:subscribe(callback, [callback_context])
event_instance:unsubscribe(callback, [callback_context])
event_instance:is_subscribed(callback, [callback_context])
event_instance:trigger(...)
event_instance:is_empty()
event_instance:clear()

local events = require("event.events")
events.subscribe(name, callback, [callback_context])
events.unsubscribe(name, callback, [callback_context])
events.is_subscribed(name, callback, [callback_context])
events.trigger(name, ...)
events.is_empty(name)
events.clear(name)
events.clear_all()
```

### Setup and Initialization

To start using the Event module in your project, you first need to import it. This can be done with the following line of code:

```lua
local event = require("event.event")
```

### Core Functions

**event.create**
---
```lua
event.create(callback, [callback_context])
```
Generate a new event instance. This instance can then be used to subscribe to and trigger events. The `callback` function will be called when the event is triggered. The `callback_context` parameter is optional and will be passed as the first parameter to the callback function. Usually, it is used to pass the `self` instance. Allocate `64` bytes per instance.

- **Parameters:**
  - `callback`: The function to be called when the event is triggered. Or the event instance to subscribe.
  - `callback_context` (optional): The first parameter to be passed to the callback function.

- **Return Value:** A new event instance.

- **Usage Example:**

```lua
local function callback(self)
	print("clicked!")
end

function init(self)
	self.on_click_event = event.create(callback, self)
end
```

### Event Instance Methods

Once an event instance is created, you can interact with it using the following methods:

**event:subscribe**
---
```lua
event:subscribe(callback, [callback_context])
```
Subscribe a callback to the event or other event. The callback will be invoked whenever the event is triggered. The `callback_context` parameter is optional and will be passed as the first parameter to the callback function. If the callback with context is already subscribed, the warning will be logged. Allocate `160` bytes per first subscription and `104` bytes per next subscriptions.

- **Parameters:**
  - `callback`: The function to be executed when the event occurs, or another event instance.
  - `callback_context` (optional): The first parameter to be passed to the callback function. Not used for event instance.

- **Return Value:** `true` if the subscription was successful, `false` otherwise.

- **Usage Example:**

```lua
on_click_event:subscribe(callback, self)
```

You can subscribe an other event instance to be triggered by the event. Example:
```lua
event_1 = event.create(callback)
event_2 = event.create()
event_2:subscribe(event_1) -- Now event2 will trigger event1
event_2:trigger() -- callback from event1 will be called
```

**event:unsubscribe**
---
```lua
event:unsubscribe(callback, [callback_context])
```
Remove a previously subscribed callback from the event. The `callback_context` should be the same as the one used when subscribing the callback. If there is no `callback_context` provided, all callbacks with the same function will be unsubscribed.

- **Parameters:**
  - `callback`: The callback function to unsubscribe, or the event instance to unsubscribe.
  - `callback_context` (optional): The first parameter to be passed to the callback function. If not provided, will unsubscribe all callbacks with the same function. Not used for event instances.

- **Return Value:** `true` if the unsubscription was successful, `false` otherwise.

- **Usage Example:**

```lua
on_click_event:unsubscribe(callback, self)
```

**event:is_subscribed**
---
```lua
event:is_subscribed(callback, [callback_context])
```
Determine if a specific callback is currently subscribed to the event. The `callback_context` should be the same as the one used when subscribing the callback.

- **Parameters:**
  - `callback`: The callback function in question. Or the event instance to check.
  - `callback_context` (optional): The first parameter to be passed to the callback function.

- **Return Value:** `true` if the callback is subscribed to the event, `false` otherwise.

- **Usage Example:**

```lua
local is_subscribed = on_click_event:is_subscribed(callback, self)
```

**event:trigger**
---
```lua
event:trigger(...)
```
Trigger the event, causing all subscribed callbacks to be executed. Any parameters passed to `trigger` will be forwarded to the callbacks. The return value of the last executed callback is returned. The `event:trigger(...)` can be called as `event(...)`.

- **Parameters:** Any number of parameters to be passed to the subscribed callbacks.

- **Return Value:** The return value of the last callback executed.

- **Usage Example:**

```lua
on_click_event:trigger("arg1", "arg2")

-- The event can be triggered as a function
on_click_event("arg1", "arg2")
```

**event:is_empty**
---
```lua
event:is_empty()
```
Check if the event has no subscribed callbacks.

- **Return Value:** `true` if the event has no subscribed callbacks, `false` otherwise.

- **Usage Example:**

```lua
local is_empty = on_click_event:is_empty()
```

**event:clear**
---
```lua
event:clear()
```
Remove all callbacks subscribed to the event, effectively resetting it.

- **Usage Example:**

```lua
on_click_event:clear()
```


### Configuration Functions

**event.set_logger**
---
Customize the logging mechanism used by Event module. You can use **Defold Log** library or provide a custom logger. By default, the module uses the `pprint` logger.

```lua
event.set_logger([logger_instance])
```

- **Parameters:**
  - `logger_instance` (optional): A logger object that follows the specified logging interface, including methods for `trace`, `debug`, `info`, `warn`, `error`. Pass `nil` to remove the default logger.

- **Usage Example:**

Using the [Defold Log](https://github.com/Insality/defold-log) module:
```lua
-- Use defold-log module
local log = require("log.log")
local event = require("event.event")

event.set_logger(log.get_logger("event"))
```

Creating a custom user logger:
```lua
-- Create a custom logger
local logger = {
    trace = function(_, message, context) end,
    debug = function(_, message, context) end,
    info = function(_, message, context) end,
    warn = function(_, message, context) end,
    error = function(_, message, context) end
}
event.set_logger(logger)
```

Remove the default logger:
```lua
event.set_logger(nil)
```

**event.set_memory_threshold**
---
Set the threshold for logging warnings about memory allocations in event callbacks. Works only in debug builds. The threshold is in kilobytes. If the callback causes a memory allocation greater than the threshold, a warning will be logged.

```lua
event.set_memory_threshold(threshold)
```

- **Parameters:**
  - `threshold`: Threshold in kilobytes for logging warnings about memory allocations. `0` disables tracking.

- **Usage Example:**

```lua
event.set_memory_threshold(50)
event.set_memory_threshold(0) -- Disable tracking
```


### Global Events Module

The Event library comes with a global events module that allows you to create and manage global events that can be triggered from anywhere in your game. This is particularly useful for events that need to be handled by multiple scripts or systems.

To start using the **Events** module in your project, you first need to import it. This can be done with the following line of code:

Global events module requires careful management of subscriptions and unsubscriptions to prevent errors.


```lua
local events = require("event.events")
```

**events.subscribe**
---
```lua
events.subscribe(name, callback, [callback_context])
```
Subscribe a callback to the specified global event.

- **Parameters:**
  - `name`: The name of the global event to subscribe to.
  - `callback`: The function to be executed when the global event occurs.
  - `callback_context` (optional): The first parameter to be passed to the callback function.

- **Usage Example:**

```lua
function init(self)
	events.subscribe("on_game_over", callback, self)
end
```

**events.unsubscribe**
---
```lua
events.unsubscribe(name, callback, [callback_context])
```
Remove a previously subscribed callback from the specified global event. The `callback_context` should be the same as the one used when subscribing the callback. If there is no `callback_context` provided, all callbacks with the same function will be unsubscribed.

- **Parameters:**
  - `name`: The name of the global event to unsubscribe from.
  - `callback`: The callback function to unsubscribe.
  - `callback_context` (optional): The first parameter to be passed to the callback function. If not provided, will unsubscribe all callbacks with the same function.

- **Usage Example:**

```lua
function final(self)
	events.unsubscribe("on_game_over", callback, self)
end
```

**events.is_subscribed**
---
```lua
events.is_subscribed(name, callback, [callback_context])
```
Determine if a specific callback is currently subscribed to the specified global event.

- **Parameters:**
  - `name`: The name of the global event in question.
  - `callback`: The callback function in question.
  - `callback_context` (optional): The first parameter to be passed to the callback function.

- **Return Value:** `true` if the callback is subscribed to the global event, `false` otherwise.

- **Usage Example:**

```lua
local is_subscribed = events.is_subscribed("on_game_over", callback, self)
```

**events.trigger**
---
```lua
events.trigger(name, ...)
```
Throw a global event with the specified name. All subscribed callbacks will be executed. Any parameters passed to `trigger` will be forwarded to the callbacks. The return value of the last executed callback is returned.

- **Parameters:**
  - `name`: The name of the global event to trigger.
  - `...`: Any number of parameters to be passed to the subscribed callbacks.

- **Usage Example:**

```lua
events.trigger("on_game_over", "arg1", "arg2")
```

**events.is_empty**
---
```lua
events.is_empty(name)
```
Check if the specified global event has no subscribed callbacks.

- **Parameters:**
  - `name`: The name of the global event to check.

- **Return Value:** `true` if the global event has no subscribed callbacks, `false` otherwise.

- **Usage Example:**

```lua
local is_empty = events.is_empty("on_game_over")
```

**events.clear**
---
```lua
events.clear(name)
```
Remove all callbacks subscribed to the specified global event.

- **Parameters:**
  - `name`: The name of the global event to clear.

- **Usage Example:**

```lua
events.clear("on_game_over")
```

**events.clear_all**
---
```lua
events.clear_all()
```
Remove all callbacks subscribed to all global events.

- **Usage Example:**

```lua
events.clear_all()
```

The **Events** module provides a powerful and flexible way to manage global events in your Defold projects. Use it to create modular and extensible systems that can respond to events from anywhere in your game.


## Use Cases

Read the [Use Cases](USE_CASES.md) file to see several examples of how to use the Event module in your Defold game development projects.


## License

This project is licensed under the MIT License - see the LICENSE file for details.

Used libraries:
- [Lua Script Instance](https://github.com/DanEngelbrecht/LuaScriptInstance/)


## Issues and suggestions

If you have any issues, questions or suggestions please [create an issue](https://github.com/Insality/defold-event/issues).


## 👏 Contributors

<a href="https://github.com/Insality/defold-event/graphs/contributors">
  <img src="https://contributors-img.web.app/image?repo=insality/defold-event"/>
</a>


## Changelog

<details>

### **V1**
	- Initial release

### **V2**
	- Add global events module
	- The `event:subscribe` and `event:unsubscribe` now return boolean value of success

### **V3**
	- Event Trigger now returns value of last executed callback
	- Add `events.is_empty(name)` function
	- Add tests for Event and Global Events modules


### **V4**
	- Rename `lua_script_instance` to `event_context_manager` to escape conflicts with `lua_script_instance` library
	- Fix validate context in `event_context_manager.set`
	- Better error messages in case of invalid context
	- Refactor `event_context_manager`
	- Add tests for event_context_manager
	- Add `event.set_memory_threshold` function. Works only in debug builds.

### **V5**
	- The `event:trigger(...)` can be called as `event(...)` via `__call` metamethod
	- Add default pprint logger. Remove or replace it with `event.set_logger()`
	- Add tests for context changing

### **V6**
	- Optimize memory allocations per event instance
	- Localize functions in the event module for better performance

### **V7**
	- Optimize memory allocations per event instance
	- Default logger now empty except for errors

### **V8**
	- Optimize memory allocations per subscription (~35% less)

### **V9**
	- Better error tracebacks in case of error in subscription callback
	- Update annotations

### **V10**
	- The `event:unsubscribe` now removes all subscriptions with the same function if `callback_context` is not provided
	- You can use events instead callbacks in `event:subscribe` and `event:unsubscribe`. The subcribed event will be triggered by the parent event trigger.
	- Update docs and API reference
</details>

## ❤️ Support project ❤️

Your donation helps me stay engaged in creating valuable projects for **Defold**. If you appreciate what I'm doing, please consider supporting me!

[![Github-sponsors](https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#EA4AAA)](https://github.com/sponsors/insality) [![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/insality) [![BuyMeACoffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/insality)
