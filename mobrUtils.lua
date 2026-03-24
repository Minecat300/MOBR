local mobrUtils = {}

function mobrUtils.startsWith(str, start)
    return str:sub(1, #start) == start
end

function mobrUtils.stripProtocol(url)
    return url:gsub("^https?://", "")
end

return mobrUtils