
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

    printf("处理中...")

    -- 读入原始文件
    local in_scource_handle = io.open(in_source, "rb")
    local in_source_data   = in_scource_handle:read("*a")
    local in_source_length = in_scource_handle:seek("end")
    io.close(in_scource_handle)
	
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
	
    -- 输出
    local out_dest_handle = io.open(out_dest, "wb+")
    out_dest_handle:write(in_source_data)
    io.close(out_dest_handle)

    printf("完成")
end

main()
