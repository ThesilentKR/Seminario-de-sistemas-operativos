#!/bin/bash
# Colores para resaltar texto
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
PURPURA='\033[0;35m'
SIN_COLOR='\033[0m'

# Verificar si VBoxManage esta disponible
if ! command -v VBoxManage &> /dev/null; then
    echo -e "${ROJO}Error: VBoxManage no esta instalado. Instala VirtualBox.${SIN_COLOR}"
    exit 1
fi

# Funcion para solicitar los parametros de configuracion
function configurar_maquina() {
    clear
    echo -e "${PURPURA}=======================================================${SIN_COLOR}"
    echo -e "${VERDE}      Bienvenido al Script de automatizacion de VM      ${SIN_COLOR}"
    echo -e "${PURPURA}=======================================================${SIN_COLOR}"
    sleep 1

    echo -e "${AMARILLO}Introduce los datos de la maquina virtual:${SIN_COLOR}"
    
    # Nombre de la maquina y sistema operativo
    read -p "Nombre de la maquina virtual: " NOMBRE_VM
    read -p "Tipo de sistema operativo (ej. Linux_64): " TIPO_SO

    # Validar y configurar CPU, RAM y VRAM
    while : ; do
        read -p "Numero de CPUs [por defecto: 2]: " CPUS
        CPUS=${CPUS:-2}
        if [[ "$CPUS" =~ ^[0-9]+$ ]]; then
            break
        else
            echo -e "${ROJO}Introduce un numero valido de CPUs.${SIN_COLOR}"
        fi
    done

    # Configuracion de RAM en GB convertida a MB
    while : ; do
        read -p "Tamaño de RAM en GB [por defecto: 2GB]: " RAM_GB
        RAM_GB=${RAM_GB:-2}
        if [[ "$RAM_GB" =~ ^[0-9]+$ ]]; then
            RAM_MB=$((RAM_GB * 1024))
            break
        else
            echo -e "${ROJO}Introduce un valor numerico valido para la RAM.${SIN_COLOR}"
        fi
    done

    # Configuracion de VRAM
    while : ; do
        read -p "Tamaño de VRAM en MB [por defecto: 64MB]: " VRAM
        VRAM=${VRAM:-64}
        if [[ "$VRAM" =~ ^[0-9]+$ ]]; then
            break
        else
            echo -e "${ROJO}Introduce un valor numerico valido para la VRAM.${SIN_COLOR}"
        fi
    done

    # Configuracion de disco en GB convertida a MB
    while : ; do
        read -p "Tamaño del disco duro en GB [por defecto: 10GB]: " DISCO_GB
        DISCO_GB=${DISCO_GB:-10}
        if [[ "$DISCO_GB" =~ ^[0-9]+$ ]]; then
            DISCO_MB=$((DISCO_GB * 1024))
            break
        else
            echo -e "${ROJO}Introduce un valor numerico valido para el disco.${SIN_COLOR}"
        fi
    done

    # Controladores
    read -p "Nombre del controlador SATA: " CONTROLADOR_SATA
    read -p "Nombre del controlador IDE: " CONTROLADOR_IDE

    # Mostrar un resumen para confirmacion
    echo -e "${PURPURA}===========================================================${SIN_COLOR}"
    echo -e "${VERDE} Resumen de configuracion:${SIN_COLOR}"
    echo -e "${AMARILLO} Nombre de la maquina: ${SIN_COLOR}$NOMBRE_VM"
    echo -e "${AMARILLO} Tipo de SO: ${SIN_COLOR}$TIPO_SO"
    echo -e "${AMARILLO} CPUs: ${SIN_COLOR}$CPUS"
    echo -e "${AMARILLO} RAM: ${SIN_COLOR}${RAM_GB}GB ($RAM_MB MB)"
    echo -e "${AMARILLO} VRAM: ${SIN_COLOR}${VRAM}MB"
    echo -e "${AMARILLO} Disco: ${SIN_COLOR}${DISCO_GB}GB ($DISCO_MB MB)"
    echo -e "${AMARILLO} Controlador SATA: ${SIN_COLOR}$CONTROLADOR_SATA"
    echo -e "${AMARILLO} Controlador IDE: ${SIN_COLOR}$CONTROLADOR_IDE"
    echo -e "${PURPURA}===========================================================${SIN_COLOR}"

    # Confirmacion del usuario
    while true; do
        read -p "¿Es correcta la configuracion? (s/n): " CONFIRMACION
        case $CONFIRMACION in
            [sS]* ) break;;
            [nN]* ) echo -e "${ROJO}Por favor reinicia el proceso de configuracion.${SIN_COLOR}"; exit 1;;
            * ) echo -e "${ROJO}Por favor responde con 's' para si o 'n' para no.${SIN_COLOR}";;
        esac
    done
}

# Crear maquina virtual y aplicar configuraciones
function crear_y_configurar_vm() {
    echo -e "${AMARILLO}Creando maquina virtual...${SIN_COLOR}"
    VBoxManage createvm --name "$NOMBRE_VM" --ostype "$TIPO_SO" --register

    echo -e "${AMARILLO}Configurando CPU, RAM y VRAM...${SIN_COLOR}"
    VBoxManage modifyvm "$NOMBRE_VM" --cpus "$CPUS" --memory "$RAM_MB" --vram "$VRAM"

    # Crear disco virtual y asociar al controlador SATA
    RUTA_DISCO="$HOME/VirtualBox VMs/$NOMBRE_VM/${NOMBRE_VM}_disk.vdi"
    echo -e "${AMARILLO}Creando disco virtual...${SIN_COLOR}"
    VBoxManage createhd --filename "$RUTA_DISCO" --size "$DISCO_MB"
    
    echo -e "${AMARILLO}Añadiendo controlador SATA y conectando disco...${SIN_COLOR}"
    VBoxManage storagectl "$NOMBRE_VM" --name "$CONTROLADOR_SATA" --add sata --controller IntelAhci
    VBoxManage storageattach "$NOMBRE_VM" --storagectl "$CONTROLADOR_SATA" --port 0 --device 0 --type hdd --medium "$RUTA_DISCO"

    # Configurar controlador IDE para CD/DVD
    echo -e "${AMARILLO}Añadiendo controlador IDE...${SIN_COLOR}"
    VBoxManage storagectl "$NOMBRE_VM" --name "$CONTROLADOR_IDE" --add ide
    VBoxManage storageattach "$NOMBRE_VM" --storagectl "$CONTROLADOR_IDE" --port 1 --device 0 --type dvddrive --medium emptydrive
}

# Mostrar configuracion final de la maquina
function mostrar_resumen() {
    echo -e "${PURPURA}===========================================================${SIN_COLOR}"
    echo -e "${VERDE}      Configuracion de la maquina virtual '${NOMBRE_VM}'      ${SIN_COLOR}"
    echo -e "${PURPURA}===========================================================${SIN_COLOR}"
    VBoxManage showvminfo "$NOMBRE_VM" | grep -E "Name:|Memory size|Number of CPUs|VRAM size|SATA Controller|IDE Controller"
}

# Funcion principal
function ejecutar_script() {
    configurar_maquina
    crear_y_configurar_vm
    mostrar_resumen
}

# Ejecutar script principal
ejecutar_script