-- Список файлов в указанной папке
-- WARNING: только для Linux

local function list_files_in_directory(directory)
	local files = {}
	local handle = io.popen("ls -p '" .. directory .. "' | grep -v /")
	if handle then
		for file in handle:lines() do
			table.insert(files, file)
		end
		handle:close()
	end
	return files
end

local directory = "." -- Путь к папке
local files = list_files_in_directory(directory)

if #files > 0 then
	print("Файлы в папке " .. directory .. ":")
	for _, file in ipairs(files) do
		print(file)
	end
else
	print("В папке нет файлов")
end
