-- For Open Computers

local internet = require("internet")

local handle = internet.request("https://google.com")

for chunk in handle do
    print(chunk)
end