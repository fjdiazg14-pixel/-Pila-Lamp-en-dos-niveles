# -Pila-Lamp-en-dos-niveles

Francisco Javier Díaz Garrón  
22/11/2026  
ASIR 2º  

## Descripción / Introducción de la practica  

En esta práctica se ha desplegado una aplicación web de gestión de usuarios sobre una arquitectura de dos niveles utilizando Vagrant y VirtualBox con imágenes de Debian 12, en esta ella se han creado dos máquinas virtuales, una web con internet para ofrecer la página al usuario y una de base de datos para almacenar los registros y no tiene internet:  

1. **Nivel 1 - Servidor Web (`FranciscoJavierDiazGarronApache`):**  
   * **IP Privada:** 192.168.56.21
   * **Acceso a Internet:** Sí (Interfaz NAT que pone Vagrant por defecto).
   * **Acceso desde el anfitrión:** Mediante Port Forwarding del puerto 80 de la máquina virtual al puerto 8080 del equipo anfitrión (`http://localhost:8080`).
2. **Nivel 2 - Servidor de Base de Datos (`FranciscoJavierDiazGarronMysql`):**
   * **IP Privada:** 192.168.56.20
   * **Acceso a Internet:** No. Tras instalar los paquetes necesarios, se elimina la ruta por defecto (`default gateway`) y se crea un servicio en `systemd` para mantenerla aislada ante reinicios.
  
## 2. Scripts de Aprovisionamiento  

### Script del Servidor Web

`#!/bin/bash`  --> Esta linea del script indica al sistema que el archivo debe ejecutarse utilizando el intérprete de comandos Bash   

`export DEBIAN_FRONTEND=noninteractive`  --> Esta linea del script permite que la instalación sea no interactiva, haciendo que no se detenga esperando la respuesta del usuario y sea todo automatico  

`apt-get update -y`  --> Esta linea del script sirve para actualizar la lista de paquetes y versiones del sistema  

`apt-get install -y apache2 php libapache2-mod-php php-mysql git` --> Esta linea del script sirve para instalar sin pedir confirmación el servidor web Apache2, el lenguaje PHP, el módulo de integración entre Apache y PHP (`libapache2-mod-php`) para que se puedan entender, el controlador de PHP para conectarse a bases de datos MySQL/MariaDB (`php-mysql`) y la herramienta Git para poder utilizar la aplicación del repositorio  

`rm -rf /var/www/html/*` --> Esta linea del script sirve para eliminar todo lo que contenga la raiz de apahce asi como tambien las subcarpetas que haya, ya que sino apache mostraria la pagina por defecto que tiene y no la aplicación git  

`git clone https://github.com/josejuansanchez/iaw-practica-lamp /tmp/app` --> Esta linea del script sirve para clonar el repositorio de github que tiene la aplicación, dentro de una carpeta temporal  

`cp -r /tmp/app/src/* /var/www/html/` --> Esta linea del script sirve para copiar todos los archivos que tiene la aplicación, al directorio público de apache para que use la aplicación del repositorio y la muestre  

`rm -rf /tmp/app` --> Esta linea del script sirve para borrar la carpeta temporal creada en el script despues de ya haber pasado toda la aplicación al directorio de apache  

`sed -i "s/localhost/192.168.56.20/g" /var/www/html/config.php` --> Esta linea del script sirve para edita directamente el archivo config.php de la aplicación para sustituir la ruta por defecto del servidor de base de datos la cual es localhost por la dirección IP del servidor de la base de datos que es la otra máquina virtual  

`sed -i "s/database_name_here/lamp_db/g" /var/www/html/config.php` --> Esta linea del script sirve para sustituir en config.php el nombre de la base de datos por el nombre que pusimos al crear la base de datos en el aprovisionamiento del servidor de base de datos  

`sed -i "s/username_here/javier-lamp/g" /var/www/html/config.php` --> Esta linea del script sirve para sustituir en config.php el nombre del usuario de la base de datos por el que pusimos en el aprovisionamiento del servidor de la base de datos  

`sed -i "s/password_here/1234/g" /var/www/html/config.php` --> Esta linea del script sirve para sustituir en config.php la contraseña del usuario por la contraseña que indicamos en el aprovisionamiento del servidor de la base de datos  

`chown -R www-data:www-data /var/www/html/`  --> Esta linea del script sirve para cambiar recursivamente el propietario y grupo de todos los archivos de la aplicación por el usuario www-data el cual es el usuario que utiliza debian para ejecutar apache, para que no haya problemas de permisos  

`systemctl restart apache2` --> Esta linea del script sirve para reiniciar el servicio de apache para que utilice todos los nuevos datos de todos los cambios que hemos hecho  

`systemctl enable apache2` --> >Esta linea del script sirve para habilitar a que se inicie el servicio apache automaticamente cada vez que se encienda o reinicie la máquina virtual  
