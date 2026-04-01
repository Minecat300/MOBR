local seri = require("serialization")
local fs = require("filesystem")
local io = require("io")

local mobrUtils = {}

function mobrUtils.startsWith(str, start)
    return str:sub(1, #start) == start
end

function mobrUtils.stripProtocol(url)
    return url:gsub("^https?://", "")
end

function mobrUtils.readObjectFile(filePath)
    local file = io.open(filePath, "r")
    local data = {}

    if file then
        local fileContent = file:read("*all")
        file:close()

        data = seri.unserialize(fileContent)
        if not data then
            print("Error: failed to unserialize the file content")
            data = {}
        end
    else
        file = io.open(filePath, "w")
        if file then
            file:close()
        else
            print("Error: unable to create file")
        end
    end
    return data
end

function mobrUtils.writeObjectFile(filePath, data)
    local serializedData = seri.serialize(data)
    local file = io.open(filePath, "w")
    if file then
        file:write(serializedData)
        file:close()
    else
        print("Error: Failed to open file for writing")
    end
end

function mobrUtils.readTextFile(filePath)
    local file = io.open(filePath, "r")
    local data = ""

    if file then
        data = file:read("*all")
        file:close()
    else
        file = io.open(filePath, "w")
        if file then
            file:close()
        else
            print("Error: unable to create file")
        end
    end
    return data
end

function mobrUtils.writeTextFile(filePath, data)
    local file = io.open(filePath, "w")
    if file then
        file:write(data)
        file:close()
    else
        print("Error: Failed to open file for writing")
    end
end

function mobrUtils.urlConcat(...)
    local parts = {...}
    local result = ""

    for i, part in ipairs(parts) do
        if i == 1 then
            result = part
        else
            result = result:gsub("/+$", "")
            part = part:gsub("^/+", "")
            result = result .. "/" .. part
        end
    end

    return result
end

function mobrUtils.ensureDirs(path)
    if fs.exists(path) then return end

    local targetPath = path

    if not path:match("/$") then
        targetPath = fs.path(path) or "/"
    end

    local parts = {}
    for part in string.gmatch(targetPath, "[^/]+") do
        table.insert(parts, part)
    end

    local current = "/"
    for i = 1, #parts do
        current = fs.concat(current, parts[i])
        if not fs.exists(current) then
            fs.makeDirectory(current)
        end
    end
end

return mobrUtils