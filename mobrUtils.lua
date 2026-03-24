local mobrUtils = {}

function mobrUtils.startsWith(str, start)
    return str:sub(1, #start) == start
end

return mobrUtils