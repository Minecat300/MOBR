# For Open Computers

local internet = require("internet")

local handle = internet.request("https://google.com")

print(handle.readAll())