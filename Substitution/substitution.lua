
-- formatted print statement
function printf(...)
    io.write(string.format(unpack(arg)))
end

-- simple test to see if the file exits or not
function FileExists(filename)
    local file = io.open(filename, "r")
    if (file == nil) then return false end
    io.close(file)
    return true
end

-------------------------------------------------------------------------------

function ReplaceText(source, find, replace, wholeword)
    if wholeword then
        find = '%f[%w]'..find..'%f[%W]'
    end
        
    return (source:gsub(find, replace))
end


function Literalize(str)
    return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c) return "%" .. c end)
end

function case_insensitive_pattern(pattern)

  -- find an optional '%' (group 1) followed by any character (group 2)
  local p = pattern:gsub("(%%?)(.)", function(percent, letter)

    if percent ~= "" or not letter:match("%a") then
      -- if the '%' matched, or `letter` is not a letter, return "as is"
      return percent .. letter
    else
      -- else, return a case-insensitive character class of the matched letter
      return string.format("[%s%s]", letter:lower(), letter:upper())
    end

  end)

  return p
end

-- Concat the contents of the parameter list,
-- separated by the string delimiter (just like in perl)
-- example: strjoin(", ", {"Anna", "Bob", "Charlie", "Dolores"})
function strJoin(delimiter, list)
   local len = getn(list)
   if len == 0 then
      return "" 
   end
   local string = list[1]
   for i = 2, len do 
      string = string .. delimiter .. list[i] 
   end
   return string
end

-- Split text into a list consisting of the strings in text,
-- separated by strings matching delimiter (which may be a pattern). 
-- example: strsplit(",%s*", "Anna, Bob, Charlie,Dolores")
function strSplit(delimiter, text)
	local list = {}
	local pos = 1
	if string.find("", delimiter, 1) then -- this would result in endless loops
	  error("delimiter matches empty string!")
	end
	while 1 do
		local first, last = string.find(text, delimiter, pos)
		if first then -- found?
			--table.insert(list, string.sub(text, pos, first-1))
			list[#list + 1] = string.sub(text, pos, first-1)
			pos = last+1
		else
			--table.insert(list, string.sub(text, pos))
			list[#list + 1] = string.sub(text, pos)
			break
		end
	end
	return list
end

function strTrim(s)
   return s:match('^%s*(.*%S)') or ''
end

function strTrimLeft(s)
   return s:match('^%s*(.*)') or ''
end

function strTrimRight(s)
   return s:match('(.*%S)') or ''
end

-- Print the Usage to the console
function Usage()
  print("使用方法: lua.exe substitution.lua in.txt dictionary.txt out.txt")
end


-- The main() program to run
function main()

--代码页     描述
--65001     UTF-8代码页
--950       繁体中文
--936       简体中文默认的GBK
--437       MS-DOS 美国英语
    os.execute("CHCP 65001")

    for k, v in pairs(arg) do
        print(k, v)
    end

    if not arg or (#arg ~= 3) then
        Usage()
        return
    end
	
    local in_source     = arg[1]
    local in_dictionary = arg[2]
    local out_dest      = arg[3]

    if not FileExists(in_source) then
        printf("原始文件 '%s' 不存在！运行结束。\n", in_source)
        return
    end

    if not FileExists(in_dictionary) then
        printf("字典文件 '%s' 不存在！运行结束。\n", in_dictionary)
        return
    end

    if FileExists(out_dest) then
        printf("输出文件 '%s' 已经存在！将被覆盖。\n", out_dest)
    end

    printf("处理中...\n")
	
    -- 读入原始文件
    local in_scource_handle = io.open(in_source, "rb")
    local in_source_data   = in_scource_handle:read("*a")
    local in_source_length = in_scource_handle:seek("end")
    io.close(in_scource_handle)
	printf("原始文件读入成功...\n")

    -- 读入字典文件
	local in_dict_handle = io.open(in_dictionary, "rb");
    local in_dict_data   = in_dict_handle:read("*a")
    io.close(in_dict_handle)
	printf("字典文件读入成功...\n")
	
	printf("处理中...\n")
    -- 替换
	for _, line in pairs(strSplit('\n', in_dict_data)) do
		local vects = strSplit('|', line)
		if #vects == 2 then
			local keyTrim = strTrim(vects[1])
			local valTrim = strTrim(vects[2])
			--print(vects[1], vects[2])
			if keyTrim:len() > 0 and valTrim:len() > 0 then
				in_source_data = in_source_data:gsub(case_insensitive_pattern(Literalize(vects[1])), vects[2])
			end
		end
		
	end

	--[[
    -- 读入字典文件
    -- 替换
	local in_dict_handle = io.open(in_dictionary);
	for line in in_dict_handle:lines() do
		local startPos = line:find('|')
		if startPos ~= nil then
			local key = line:sub(1, startPos - 1)
			local value = line:sub(startPos + 1, -1)
			--print(key, value)
			in_source_data = in_source_data:gsub(Literalize(key), value)
		end
    end
	io.close(in_dict_handle)
	]]--
	
    -- 输出
    local out_dest_handle = io.open(out_dest, "wb+")
    out_dest_handle:write(in_source_data)
    io.close(out_dest_handle)

    printf("完成")
end

main()
