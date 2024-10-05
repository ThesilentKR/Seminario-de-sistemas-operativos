@echo off
:: Crear un archivo de texto llamado mytext.txt y agregar "Hola Mundo"
echo Crea un archivo de texto llamado mytext.txt y le agrega Hola Mundo:
echo Hola Mundo > mytext.txt
pause

:: Desplegar/Imprimir en la terminal el contenido del archivo mytext.txt
echo Contenido del archivo mytext.txt:
type mytext.txt
pause

:: Crear un subdirectorio llamado backup
echo Creando el subdirectorio backup:
mkdir backup
pause

:: Copiar el archivo mytext.txt al subdirectorio backup
echo Copiando mytext.txt al subdirectorio backup:
copy mytext.txt backup
pause

:: Listar el contenido del subdirectorio backup
echo Listando el contenido del subdirectorio backup:
dir backup
pause

:: Eliminar el archivo mytext.txt del subdirectorio backup
echo Eliminando el archivo mytext.txt del subdirectorio backup:
del backup\mytext.txt
pause

:: Eliminar el subdirectorio backup
echo Eliminando el subdirectorio backup:
rmdir backup
pause
