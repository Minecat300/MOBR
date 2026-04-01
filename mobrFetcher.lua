local internet = require("internet")
local mobrUtils = require("mobrUtils")

local mobrFetcher = {}

function mobrFetcher.fetchFromUrl(url)
    local fixedUrl = url

    if (not mobrUtils.startsWith(url, "http://") and not mobrUtils.startsWith(url, "https://")) then
        fixedUrl = "https://" .. mobrUtils.stripProtocol(url)
    end

    local function fetch(u)
        local request = internet.request(u)
        if not request then return nil end

        local response = ""
        for chunk in request do
            response = response .. chunk
        end

        return response
    end

    local result = fetch(fixedUrl)

    if not result then
        local httpUrl = "http://" .. mobrUtils.stripProtocol(url)
        result = fetch(httpUrl)
    end

    if not result then
        print("Can not connect to " .. url)
        return
    end

    return result
end

return mobrFetcher