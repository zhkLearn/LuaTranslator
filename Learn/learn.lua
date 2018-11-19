-- single line comments

--[[ multi-line comments
asdfasf
asdf
--]]

local var_number = 20
local var_boolean = true
local var_nil = nil
local var_string =  [[How are "you"!]]
local var_table = {}
local var_userdata
local var_thread

print(type(var_number))
print(type(var_boolean))
print(type(var_nil))
print(type(var_string))
print(type(var_table))
print(type(var_userdata))
print(type(var_thread))

str1 = "hello"; str2 = "number"; str3 = str1.." "..str2.." "..tostring(2).."!"
print(str1, str2, str3)

all_string = {}
all_string[#all_string+1] = "hello"
all_string[#all_string+1] = " number"
print(table.concat(all_string))

a = {5}; b = a; b[1] = 6; print(a, b, a[1], b[1], b[2], type(a), type(b), tostring(a))

t = { ["a"] = 5, "first", "second", B = 7};
t[3] = 3
t[10] = 4
print(t.a, t["a"], t[0], t[1], t[2], t.B, t.b, t.c, #t)

for k, v in ipairs(t) do print(k, v) end ;
print("\n")

for k, v in pairs(t) do print(k, v) end ;

--for k, v in pairs(_G) do print(k, v) end
--for k, v in pairs(table) do print(k, v) end

function f(a, b) return a+b end; print(f, f(1,2), type(f))


case = {}
case[1] = function() print("Hello #1") end -- anonymous function
case[2] = function() print("Hello #2") end
value = 2        
if case[value] then
    case[value]()
else
    print("Unknown case value")
end

--[[
function Check5(val)
    if val == 5 then
        return true
    end
end

local a = 0
while a < 10 do
    a = a + 1 -- no increment operator
    if Check5 (a) then
    else
        print(a)
    end
end

for a = 1, 10, 2 do
    local temp = a * 2
    print(temp)
end
--]]

function GetNums() return 3, 4, 5, 6 end;
local _, num2 = GetNums()
--print(num2)
print(select(3, GetNums()))

function dostuff(...)
local n_args = select("#", ...)
print(n_args)
end
dostuff(1, 2, 3, 4, 5, 6)


Account = {balance = 1000}
function Account:new(o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)
    return o
end

function Account:withDraw(v)
    self.balance = self.balance - v
end

a = Account:new{balance = 500}
a:withDraw(100)
print(a.balance)


words = {}
for w in string.gmatch("This is a string.汉字的", "%a+") do
words[#words+1] = w
print(type(w), w)
end

--[[
Unicode符号范围                     UTF-8字节数	UTF-8编码方式（二进制）
0000 0000-0000 007F (0-127)         1       	0xxxxxxx
0000 0080-0000 07FF (128-2047)	    2	        110xxxxx 10xxxxxx
0000 0800-0000 FFFF (2048-65535)	3	        1110xxxx 10xxxxxx 10xxxxxx
0001 0000-0010 FFFF (65536-1050623)	4	        11110xxx 10xxxxxx 10xxxxxx 10xxxxxx

[ 0x0, 0xc0) 表示这个字符由1个字节构成  00000000 - 11000000
[0xc0, 0xe0) 表示这个字符由2个字节构成  11000000 - 11100000
[0xe0, 0xf0) 表示这个字符由3个字节构成  11100000 - 11110000
[0xf0, 0xff) 表示这个字符由4个字节构成  11110000 - 11111111
--]]
function Bytes4Character(theByte)
    local seperate = {0, 0xc0, 0xe0, 0xf0}
    for i = #seperate, 1, -1 do
        if theByte >= seperate[i] then print(theByte, i) return i end
    end
    return 1
end

function characters(utf8Str)
    local i = 1
    local characterSum = 0
    while (i <= #utf8Str) do
        local bytes4Character = Bytes4Character(string.byte(utf8Str, i))
        characterSum = characterSum + 1
        i = i + bytes4Character
    end

    return characterSum
end

local str = "汉字abcd汉字"
print(str, "\nlength: ", #str, "\nchars: ", characters(str), "\nbytes: ", str:byte(1, -1))
print(string.char(230,177,137))

local strNew = str:gsub("汉", "中")
print(strNew:gsub("字", "文"))


local in_source_data = "abc"
local in_dict_data = "a A\nb B\n"
for key, value in in_dict_data:gmatch("%s*(%a+)%s+(%a+)%s*\n") do
    in_source_data = in_source_data:gsub(key, value)
end
print(in_source_data)












