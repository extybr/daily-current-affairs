// Поиск файла в текущей директории рекурсивно с указанием полного пути и размера
// g++ -std=c++17 -o find_file find_file_in_directory.cpp  // компиляция
// find ./ -name readme.md  // аналог поиска в Linux

#include <iostream>
#include <filesystem>
#include <string>
#include <vector>

namespace fs = std::filesystem;

// Функция поиска файла
std::vector<fs::path> findFiles(const std::string& filename, const fs::path& directory) {
    std::vector<fs::path> results;
    
    try {
        if (!fs::exists(directory) || !fs::is_directory(directory)) {
            std::cout << "Директория не существует!" << std::endl;
            return results;
        }
        
        for (const auto& entry : fs::recursive_directory_iterator(directory)) {
            if (fs::is_regular_file(entry.status())) {
                if (entry.path().filename() == filename) {
                    results.push_back(entry.path());
                }
            }
        }
    } catch (const std::exception& e) {
        std::cerr << "Ошибка: " << e.what() << std::endl;
    }
    
    return results;
}

int main() {
    std::cout << "=== ПОИСК ФАЙЛА В ТЕКУЩЕЙ ДИРЕКТОРИИ И ПОДПАПКАХ ===" << std::endl;
    
    // Запрашиваем имя файла
    std::string filename;
    std::cout << "Введите имя файла для поиска: ";
    std::getline(std::cin, filename);
    
    if (filename.empty()) {
        std::cout << "Имя файла не введено!" << std::endl;
        return 1;
    }
    
    // Получаем текущую директорию
    fs::path currentDir = fs::current_path();
    std::cout << "Текущая директория: " << currentDir << std::endl;
    
    // Выполняем поиск
    std::cout << "\nПоиск файла '" << filename << "'..." << std::endl;
    auto foundFiles = findFiles(filename, currentDir);
    
    // Выводим результаты
    if (foundFiles.empty()) {
        std::cout << "Файл не найден!" << std::endl;
    } else {
        std::cout << "Найдено " << foundFiles.size() << " файл(ов):" << std::endl;
        std::cout << "======================================" << std::endl;
        
        for (size_t i = 0; i < foundFiles.size(); ++i) {
            std::cout << i + 1 << ". " << foundFiles[i].filename() << std::endl;
            std::cout << "   Путь: " << fs::absolute(foundFiles[i]) << std::endl;
            
            try {
                auto size = fs::file_size(foundFiles[i]);
                std::cout << "   Размер: " << size << " байт";
                if (size > 1024) {
                    std::cout << " (" << size / 1024 << " KB)";
                }
                std::cout << std::endl;
            } catch (...) {
                std::cout << "   Размер: недоступен" << std::endl;
            }
            std::cout << std::endl;
        }
    }
    
    return 0;
}
