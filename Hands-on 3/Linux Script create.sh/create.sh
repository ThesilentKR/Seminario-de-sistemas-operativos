#!/bin/bash
# Crear un archivo de texto llamado mytext y agregar "Hola Mundo"
echo "Crea un archivo de texto llamado mytext y le agrega Hola Mundo:"
echo "Hola Mundo" > mytext

# Desplegar/Imprimir en la terminal el contenido del archivo mytext
echo "Contenido del archivo mytext:"
cat mytext

# Crear un fichero llamado backup
echo "Creando el fichero backup:"
mkdir backup

# Mover el archivo mytext al fichero backup
echo "Moviendo mytext al fichero backup:"
mv mytext backup/

# Listar el contenido del fichero backup
echo "Listando el contenido del fichero backup:"
ls backup

# Eliminar el archivo mytext del fichero backup
echo "Eliminando el archivo mytext del fichero backup:"
rm backup/mytext

# Eliminar el fichero backup
echo "Eliminando el fichero backup:"
rmdir backup

read -p "Presiona una tecla para continuar..."