local internet = require("internet")
local mobrUtils = require("mobrUtils")

local handler = {}

function handler.go(url)
    if (not mobrUtils.startsWith(url, "http://") and not mobrUtils.startsWith(url, "https://")) then
        url = "http://" .. url
    end

    local handle = internet.request(url)

    for chunk in handle do
        print(chunk)
    end
end

return handler