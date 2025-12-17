-- Определяет существует ли файл или папка
-- WARNING: только для Linux

local function is_directory(path)
	local handle = io.popen("[ -d '" .. path .. "' ] && echo yes || echo no")
	local result = handle:read("*a"):gsub("\n", "")
	handle:close()
	return result == "yes"
end

local function is_file(path)
	local handle = io.popen("[ -f '" .. path .. "' ] && echo yes || echo no")
	local result = handle:read("*a"):gsub("\n", "")
	handle:close()
	return result == "yes"
end

local name = "test" -- Название файла или папки

if is_file(name) then
	print("Файл существует")
elseif is_directory(name) then
	print("Папка существует")
else
	print("Файл или папка не найдены")
end
