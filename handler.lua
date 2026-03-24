local internet = require("internet")
local mobrUtils = require("mobrUtils")

local handler = {}

function handler.go(url)
    local fixedUrl = url
    if (not mobrUtils.startsWith(url, "http://") and not mobrUtils.startsWith(url, "https://")) then
        fixedUrl = "http://" .. mobrUtils.stripProtocol(url)
    end

    local handle = internet.request(fixedUrl)
    if not handle then
        fixedUrl = "https://" .. mobrUtils.stripProtocol(url)
        handle = internet.request(fixedUrl)
        if not handle then
            print("Can not connect to " .. url)
            return
        end
    end

    for chunk in handle do
        print(chunk)
    end

end

return handler