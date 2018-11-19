local str = "汉字 中文 this is a test 中文English English中文"
--local str = "汉字 this is a test 中文English English中文"

--string.find(s, pattern[, init[, plain]])
--print(str:find("中文"))
--print(string.byte('a'))

function isByteAnEmptyChar(char)
    return char == string.byte(' ') or char == string.byte('\t')
end

local result = ""
local strLen = str:len()
local lastStartPos = 1
local startPos = 1
local endPos = -1

while startPos ~= nil do

    startPos, endPos = str:find("中文", lastStartPos)
    if startPos == nil then
        result = result .. str:sub(lastStartPos, -1)
        print("1", result, startPos, endPos)
        break
    end

    if (startPos > 1 and not isByteAnEmptyChar(str:byte(startPos - 1))) then
        -- not valid word
        result = result .. str:sub(lastStartPos, endPos)
        lastStartPos = endPos + 1
        print("2", result, startPos, endPos)
    elseif (endPos ~= strLen and not isByteAnEmptyChar(str:byte(endPos + 1))) then
        -- not valid word
        result = result .. str:sub(lastStartPos, endPos)
        lastStartPos = endPos + 1
        print("3", result, startPos, endPos)
    else
        if startPos > lastStartPos then
            print("5", lastStartPos, startPos, endPos)
            result = result .. str:sub(lastStartPos, startPos - 1)
        end

        result = result .. "Chinese"
        print("4", result, startPos, endPos)
        
        if lastStartPos ~= strLen then
            lastStartPos = endPos + 1
        else
            break
        end
    end

end
print(result)

