local mobrUtils = require("mobrUtils")
local mobrFetcher = require("mobrFetcher")

local mobrCacher = {}

function mobrCacher.cacheUrl(url, dirPath)
    local fileContent = mobrFetcher.fetchFromUrl(url)
    if fileContent then
        local filePath = mobrUtils.urlConcat(dirPath, mobrUtils.stripProtocol(url))
        print("caching " .. url .. " to " .. filePath)
        mobrUtils.writeTextFile(filePath, fileContent)
    end
    return fileContent
end

return mobrCacher