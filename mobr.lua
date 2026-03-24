package.path = "/mobr/?.lua;" .. package.path
local handler = require("handler")

local args = {...}
local command = args[1]

if command == "go" then
    local url = args[2]
    if not url then
        print("Url can not be empty")
        return
    end

    handler.go(url)
end

if command == "help" or command == "h" or command == "?" or not command then
    print('help:  shows this menu       "help"')
    print('go:    goes to selected url  "go [url]"')
end