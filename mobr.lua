package.path = "/mobr/?.lua;" .. package.path

local mobrFetcher = require("mobrFetcher")
local mobrUtils = require("mobrUtils")
local mobrCacher = require("mobrCacher")

local cachePath = "/mobr/cache/"
mobrUtils.ensureDirs(cachePath)

local args = {...}
local command = args[1]

if command == "go" then
    local url = args[2]
    if not url then
        print("Url can not be empty")
        return
    end

    print(mobrCacher.cacheUrl(cachePath, url))
end

if command == "help" or command == "h" or command == "?" or not command then
    print('help:  shows this menu       "help"')
    print('go:    goes to selected url  "go [url]"')
end