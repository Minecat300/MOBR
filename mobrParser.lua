local mobrUtils = require("mobrUtils")

local mobrParser = {}

-- List of standard void (self-closing) HTML elements
local voidElements = {
    area = true, base = true, br = true, col = true, embed = true, hr = true,
    img = true, input = true, link = true, meta = true, param = true,
    source = true, track = true, wbr = true
}

function mobrParser.segmentHtml(html)
    local main = { text = "", children = {} }

    local isTag = false
    local isElement = false
    local str = ""
    local skipContent = nil  -- tag name to skip inside (script/style)
    local textBuffer = ""

    local currentElementChildren = { main.children }
    local currentElement = { main }

    for i = 1, #html do
        local char = html:sub(i,i)

        -- Flush text if tag starts
        if char == "<" then
            if #textBuffer > 0 and #currentElement > 0 then
                currentElement[#currentElement].text = currentElement[#currentElement].text .. textBuffer
                textBuffer = ""
            end
            isTag = true
            str = ""

        elseif char == ">" and isTag then
            isTag = false
            local tagContent = str
            str = ""

            -- skip content inside script/style
            if skipContent then
                if tagContent:sub(1,1) == "/" and tagContent:sub(2):lower() == skipContent then
                    skipContent = nil
                end
            else
                local isClosing = tagContent:sub(1,1) == "/"
                local cleanContent = isClosing and tagContent:sub(2) or tagContent

                -- Extract tag name safely (first word before space)
                local tagName = cleanContent:match("^%s*(%S+)")
                tagName = tagName and tagName:lower() or ""

                -- Skip comments
                if tagName == "!--" then
                    -- find closing --> and skip
                    local commentEnd = html:find("-->", i)
                    if commentEnd then
                        i = commentEnd + 2
                    end
                else
                    if isClosing then
                        -- closing tag
                        if #currentElementChildren > 1 then
                            table.remove(currentElementChildren, #currentElementChildren)
                            table.remove(currentElement, #currentElement)
                        end
                    else
                        -- opening tag
                        local selfClosing = tagContent:sub(-1) == "/" or voidElements[tagName]
                        -- build element
                        local element = {
                            type = tagName,
                            params = {},  -- attrs can be parsed later
                            children = {},
                            text = ""
                        }

                        table.insert(currentElementChildren[#currentElementChildren], element)

                        if not selfClosing then
                            table.insert(currentElementChildren, element.children)
                            table.insert(currentElement, element)
                        end

                        -- skip content for script/style
                        if tagName == "script" or tagName == "style" then
                            skipContent = tagName
                        end
                    end
                end
            end

        elseif isTag then
            str = str .. char
        else
            -- normal text outside tags
            textBuffer = textBuffer .. char
        end
    end

    -- flush remaining text
    if #textBuffer > 0 and #currentElement > 0 then
        currentElement[#currentElement].text = currentElement[#currentElement].text .. textBuffer
    end

    return main
end

function mobrParser.splitHtml(html)
    local lowerHtml = html:lower()

    local headStart, headEnd = string.find(lowerHtml, "<head>")
    local headCloseStart, headCloseEnd = string.find(lowerHtml, "</head>")

    local head = ""
    if headStart and headCloseStart then
        head = html:sub(headEnd + 1, headCloseStart - 1)
    end

    local bodyStart, bodyEnd = string.find(lowerHtml, "<body>")
    local bodyCloseStart, bodyCloseEnd = string.find(lowerHtml, "</body>")

    local body = ""
    if bodyStart and bodyCloseStart then
        body = html:sub(bodyEnd + 1, bodyCloseStart - 1)
    end

    return head, body
end

return mobrParser