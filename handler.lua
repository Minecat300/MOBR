local internet = require("internet")
local mobrUtils = require("mobrUtils")

local handler = {}

function handler.go(url)
    local fixedUrl = url
    if (not mobrUtils.startsWith(url, "http://") and not mobrUtils.startsWith(url, "https://")) then
        fixedUrl = "http://" .. url
    end

    local handle = internet.request(fixedUrl)

    for chunk in handle do
        print(chunk)
    end
end

return handler