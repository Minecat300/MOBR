local internet = require("internet")
local mobrUtils = require("mobrUtils")

local handler = {}

local function printHeaders(url)
    internet.request(url, nil, function(_, response)
        if response then
            print("Status:", response.status)

            if response.headers then
                for k, v in pairs(response.headers) do
                    print(k .. ":", v)
                end
            else
                print("No headers received")
            end
        end
    end)
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