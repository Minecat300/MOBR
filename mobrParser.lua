local mobrUtils = require("mobrUtils")

local mobrParser = {}

function mobrParser.segmentHtml(html)
    local main = {
        text = "",
        children = {}
    }

    local isTag = false
    local isElement = false
    local str = ""

    local currentElementChildren = {
        main.children
    }

    local currentElement = {
        main
    }

    for i = 1, #html do
        local char = string.sub(html, i, i)
        if char == "<" then
            isTag = true
        elseif char == ">" and isTag then
            isTag = false
            if (str:sub(1, 1) == "/") then
                isElement = false
                table.remove(currentElementChildren, #currentElementChildren)
                table.remove(currentElement, #currentElement)
            else
                isElement = true
                local params = mobrUtils.splitBySpace(str)

                local element = {
                    type = table.remove(params, 1),
                    params = params,
                    children = {},
                    text = ""
                }

                table.insert(currentElementChildren[#currentElementChildren], element)
                table.insert(currentElementChildren, element.children)
                table.insert(currentElement, element)
            end
            str = ""
        elseif isTag then
            str = str .. char
        elseif not isTag and isElement and #currentElement > 0 then
            currentElement[#currentElement].text = currentElement[#currentElement].text .. char
        end
    end

    return main
end

function mobrParser.splitHtml(html)
    local headStart, headEnd = string.find(html:lower(), "<head>")
    local headCloseStart, headCloseEnd = string.find(html:lower(), "</head>")

    local head = ""
    if headStart and headCloseStart then
        head = string.sub(html, headEnd + 1, headCloseStart - 1)
    end

    local bodyStart, bodyEnd = string.find(html:lower(), "<body>")
    local bodyCloseStart, bodyCloseEnd = string.find(html:lower(), "</body>")

    local body = ""
    if bodyStart and bodyCloseStart then
        body = string.sub(html, bodyEnd + 1, bodyCloseStart - 1)
    end

    return head, body
end

return mobrParser