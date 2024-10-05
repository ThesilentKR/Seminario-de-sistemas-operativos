#!/bin/bash
while true; do
    echo "=============================="
    echo "        Menu de Servicios"
    echo "=============================="
    echo "1. Listar el contenido de un fichero (carpeta)"
    echo "2. Crear un archivo de texto con una línea de texto"
    echo "3. Comparar dos archivos de texto"
    echo "4. Mostrar ejemplos de uso del comando awk"
    echo "5. Mostrar ejemplos de uso del comando grep"
    echo "6. Salir"
    echo "=============================="
    read -p "Elija una opcion: " option

    case $option in
        1)
            read -p "Ingrese la ruta absoluta del fichero (carpeta): " dir_path
            if [ -d "$dir_path" ]; then
                echo "Contenido del directorio $dir_path:"
                ls "$dir_path"
            else
                echo "El directorio no existe."
            fi
            ;;
        2)
            read -p "Ingrese la cadena de texto para almacenar: " text
            read -p "Ingrese el nombre del archivo (sin extensión): " file_name
            echo "$text" > "${file_name}.txt"
            echo "El archivo ${file_name}.txt ha sido creado con el contenido: $text"
            ;;
        3)
            read -p "Ingrese la ruta del primer archivo: " file1
            read -p "Ingrese la ruta del segundo archivo: " file2
            if [ -f "$file1" ] && [ -f "$file2" ]; then
                if diff "$file1" "$file2" > /dev/null; then
                    echo "Los archivos son iguales."
                else
                    echo "Los archivos son diferentes."
                    echo "Aquí estan las diferencias:"
                    diff "$file1" "$file2"
                fi
            else
                echo "Uno o ambos archivos no existen."
            fi
            ;;
        4)
            echo "Ejemplo de uso del comando awk:"
            echo "Mostrando la primera columna de un archivo de texto:"
            read -p "Ingrese la ruta de un archivo de texto: " awk_file
            if [ -f "$awk_file" ]; then
                awk '{print $1}' "$awk_file"
            else
                echo "El archivo no existe."
            fi
            ;;
        5)
            echo "Ejemplo de uso del comando grep:"
            echo "Buscar una palabra en un archivo de texto:"
            read -p "Ingrese la palabra a buscar: " search_term
            read -p "Ingrese la ruta de un archivo de texto: " grep_file
            if [ -f "$grep_file" ]; then
                grep "$search_term" "$grep_file"
            else
                echo "El archivo no existe."
            fi
            ;;
        6)
            echo "Saliendo del menu..."
            exit 0
            ;;
        *)
            echo "Opcion no valida, intente de nuevo."
            ;;
    esac
    echo ""
done
