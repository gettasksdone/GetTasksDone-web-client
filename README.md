# Get Tasks Done Desktop/Web Client
## Flujo de instalación del contenedor de desarrollo
1. Tener instalados **VSCode** y **Docker** en el sistema.
2. Instalar la extensión de **Dev Containers** en VSCode.
3. Clonar el repositorio en el sistema.
4. Abrir el repositorio en VSCode, debería salir en la esquina inferior derecha un pop-up con "abrir en contenedor de desarrollo" o algo así, presionarlo.
5. Se creará un contenedor de desarrollo para el repositorio y se abrirá en VSCode, la creación de la imagen Docker puede tardar varios minutos.
6. Una vez se haya inicializado el contenedor de desarrollo, hay que inicializar el proyecto de Flutter.
7. Empezar por abriendo una terminal y corriendo **dart pub get**.
8. Finalmente correr en la terminal **flutter pub upgrade**.
9. El contenedor de desarrollo debería estar listo para trabajar.
