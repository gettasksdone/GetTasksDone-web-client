#!/bin/bash

#!/bin/bash

function build_image() {
    echo "Construyendo imagen Docker..."
    docker build -t gettaskdone-client -f Dockerfile.prod .
    if [ $? -eq 0 ]; then
        echo "Imagen construida exitosamente."
    else
        echo "Error al construir la imagen."
        exit 1
    fi
}

function run_container() {
    echo "Ejecutando contenedor..."
    # Detener el contenedor
    docker stop gettaskdone-client
    # Eliminar el contenedor
    docker rm gettaskdone-client

    docker run -it -p 8080:80 --name gettaskdone-client gettaskdone-client /bin/bash

}

function cleanup() {
    echo "Eliminando contenedores..."
    docker rm -f $(docker ps -a -q)
    echo "Eliminando imágenes..."
    docker rmi $(docker images -q)
}


function createzip(){
    echo "Creamos zip del build de fluter..."
    docker stop gettaskdone-client
    # Eliminar el contenedor
    docker rm gettaskdone-client

    # Ejecución en segundo plano
    docker run -d -p 8080:80 --name gettaskdone-client gettaskdone-client

    #Copiar el fichero de build
    docker cp gettaskdone-client:/home/developer/app/zipBuild.zip ./zipBuild.zip

    docker stop gettaskdone-client && docker rm gettaskdone-client


}

function show_menu() {
    echo "Selecciona una opción:"
    echo "0) Salir"
    echo "1) Construir imagen Docker"
    echo "2) Ejecutar contenedor"
    echo "3) Crear zip BUILD flutter"
    echo "4) Limpiar imágenes y contenedores"
    read -p "Introduce tu elección [0-4]: " choice
    case $choice in
        0) exit 0 ;;
        1) build_image ;;
        2) run_container ;;
        3) createzip ;;
        4) cleanup ;;
        *) echo "Opción no válida: $choice" ;;
    esac
}

while true; do
    show_menu
done

