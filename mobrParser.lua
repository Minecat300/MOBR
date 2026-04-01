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
    local headStart = string.find(html, "<head>")
    local headEnd = string.find(html, "</head>")
    local head = string.sub(html, headStart + 1, headEnd - 1)

    local bodyStart = string.find(html, "<body>")
    local bodyEnd = string.find(html, "</body>")
    local body = string.sub(html, bodyStart + 1, bodyEnd - 1)

    return head, body
end

return mobrParser