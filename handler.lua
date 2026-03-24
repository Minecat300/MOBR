local internet = require("internet")
local mobrUtils = require("mobrUtils")

local handler = {}

local function printHeaders(url)
    local handle = internet.request(url)

    if not handle then
        print("Request failed")
        return
    end

    handle.read()
    local headers = handle.response()

    if headers then
        print("Status:", headers.code)

        for k, v in pairs(headers.headers or {}) do
            print(k .. ":", v)
        end
    else
        print("No headers received")
    end
end

function handler.go(url)
    if (not mobrUtils.startsWith(url, "http://") and not mobrUtils.startsWith(url, "https://")) then
        url = "http://" .. url
    end

    return printHeaders(url)

    -- local handle = internet.request(url)

    -- for chunk in handle do
    --     print(chunk)
    -- end

end

return handler