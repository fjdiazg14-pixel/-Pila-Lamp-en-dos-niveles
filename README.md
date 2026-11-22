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

