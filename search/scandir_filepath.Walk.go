package main

import (
	"fmt"
	"os"
	"path/filepath"
)

func walkDir(root string) error {
	// Используем filepath.Walk для обхода директорий
	err := filepath.Walk(root, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err // Возвращаем ошибку, если не удалось получить информацию о файле
		}

		// Выводим полный путь и тип объекта (директория или файл)
		if info.IsDir() {
			fmt.Printf("    \033[37mПапка:\033[0m %s\n", path)
		} else {
			fmt.Printf("\033[36mФайл:\033[0m %s\n", path)
		}
		return nil
	})

	if err != nil {
		return fmt.Errorf("Ошибка обхода директории %q: %v", root, err)
	}
	return nil
}

func main() {
    var root string 
    fmt.Print("Укажите путь к директории, которую хотите сканировать: ")
	fmt.Scan(&root)
	err := walkDir(root)
	if err != nil {
		fmt.Printf("\033[31mОшибка:\033[0m %v\n", err)
	}
}

