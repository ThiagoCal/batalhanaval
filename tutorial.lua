unction f(a, b)
	local x = 10
	return a + b + x
end

---------------------------------------------------

-- sobre vetores

function dumparray(array) -- sinônimo de print_array
	io.write("array => ")
	for i, v in ipairs(array) do
		io.write(v .. " ")
	end
	print()
end

local array = {10, 20, 30, 40, 50}
print(array)

print(array[1])
print(#array)
print(array[#array])

local t = array
t[#t + 1] = 60
table.insert(t, 70)

dumparray(t)

t[1] = 80

dumparray(t)

function prepend(array, v)
	for i = #array, 1, -1 do
		array[i + 1] = array[i]
	end
	array[1] = v
end

t[1] = 10
prepend(t, 80)
dumparray(t)

---------------------------------------------------

-- sobre dicionários

local dict = {
	d = "dinamite",
	e = "everest",
}
dict["a"] = "aleluia"
dict.b = "bola"
dict["c"] = "célula"

print(dict)
print(dict["a"])

function dumpdict(dict)
	print("dictionary => ")
	for k, v in pairs(dict) do
		print("[" .. k .. "]" .. " = " .. v)
	end
end

dumpdict(dict)

print("deletando")

dict["a"] = nil
dumpdict(dict)

print("é tudo tabela")

local t = dict

t[1] = 100
t[2] = 200
t[3] = 300
t[5] = 500

dumpdict(t)
dumparray(t)

---------------------------------------------------

-- sobre orientação a objetos

local animal = {}
animal.__index = animal

function animal.new(name)
	local obj = { name = name }
	setmetatable(obj, animal)
	return obj
end

local dog = animal.new("dog")
print(dog)
print(dog.name)
print(dog["name"])

-- function animal.new(name) ... end
-- animal.new = function(name) ... end
-- animal["new"] = function(name) ... end

function animal:saymyname()
	print("My animal name is " .. self.name)
end

-- function animal.saymyname() ... end
-- animal.saymyname = function(self) ... end

dog:saymyname()

-- dog:saymyname()
-- dog.saymyname(dog)

local cat = animal.new("cat")
cat:saymyname()

---------------------------------------------------

-- exemplo de classe para conjuntos

local set = {}
set.__index = set

function set.new()
	local t = {}
	setmetatable(t, set)
	return t
end

function set:add(e)
	self[e] = true
end

function set:delete(e)
	self[e] = nil
end

function set:contains(e)
	return self[e] == true
end

function set:show()
	io.write("Set => {")
	for k, _ in pairs(self) do
		io.write(k .. " ")
	end
	print("}")
end

-- operação de união de conjuntos
function set.__add(s1, s2)
	local u = set.new()
	for k, _ in pairs(s1) do
		u:add(k)
	end
	for k, _ in pairs(s2) do
		u:add(k)
	end
	return u
end

function set.__tostring(s)
	local str = "Set => {"
	for k, _ in pairs(s) do
		str = str .. k .. " "
	end
	return str .. "}"
end


local A = set.new()
A:add(1)
A:add(2)
A:add(3)

local B = set.new()
B:add(3)
B:add(4)
B:add(5)

A:show()
B:show()

A:delete(3)
A:show()

local AB = A + B
print(AB)
