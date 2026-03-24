-- For Open Computers

local internet = require("internet")

local handler = {}

function handler.go(url)
    local handle = internet.request(url)

    for chunk in handle do
        print(chunk)
    end
end

return handler