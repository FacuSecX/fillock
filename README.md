
<p align="center">
<a href="https://github.com/FacuSecX"><img title="Autor" src="https://img.shields.io/badge/Author-Facu%20-blue?style=for-the-badge&logo=github"></a>
<a href=""><img title="Version" src="https://img.shields.io/badge/Version-2.0-red?style=for-the-badge&logo="></a>
</p>

<p align="center">
<a href=""><img title="System" src="https://img.shields.io/badge/Supported%20OS-Linux-orange?style=for-the-badge&logo=linux"></a>
<a href="https://paypal.me/FacuSecX"><img title="Paypal" src="https://img.shields.io/badge/Donate-PayPal-green.svg?style=for-the-badge&logo=paypal"></a>
</p>

<p align="center">
<a href="mailto:facusex@gmail.com"><img title="Correo" src="https://img.shields.io/badge/Correo-facusecX@gmail.com-blueviolet?style=for-the-badge&logo=gmai"></a>
<a href="https://t.me/FacuSecX"><img title="Chat" src="https://img.shields.io/badge/CHAT-TELEGRAM-blue?style=for-thjlje-badge&logo=telegram"></a>
</p>

**Fillock** es un simple script para Android que sirve para encriptar archivos mediante OpenSSL. Funciona básicamente como una aplicación, pero de manera ilimitada. El script puede utilizarse en cualquier emulador como Termux y permite cifrar archivos por extensiones: audios, videos, documentos o imágenes… o realizar un cifrado completo.

## ⚠️ AVISO IMPORTANTE:

Usar este programa es bajo su responsabilidad, ya que también puede utilizarse de forma incorrecta y podría funcionar como ransomware. Tenga en cuenta que, al momento de encriptar cualquier tipo de archivo, la clave o contraseña utilizada debe ser respaldada. Si pierde esta contraseña, los archivos serán irrecuperables.

## 🎯 Objetivo:

**Fillock** está orientado a la protección real de datos mediante cifrado seguro y automatizado de archivos personales. Aunque en Android existen múltiples aplicaciones que prometen proteger fotos o documentos mediante patrones o contraseñas, muchas dependen de sistemas cerrados, funciones limitadas o modelos de suscripción, y no siempre aplican un cifrado real sobre los archivos.

Este proyecto nace con la idea de ofrecer un método transparente y controlado por el usuario, basado en herramientas de criptografía estándar, permitiendo cifrar grandes volúmenes de archivos en un único contenedor seguro.

Si bien Android incluye mecanismos generales de bloqueo del dispositivo, una vez comprometida la contraseña o patrón del sistema, los archivos almacenados quedan accesibles. Fillock busca añadir una capa extra de protección, permitiendo cifrar archivos de forma independiente del sistema, manteniendo la integridad y la estructura original de los datos.


## V2.0:

* Se corrigieron errores críticos de seguridad en las funciones de Cifrado y decifrado completo.
* Se implementó cifrado en contenedor único.
* se eliminó el cifrado archivo por archivo para mejorar estabilidad y rendimiento.
* Se implementó verificación de integridad para asegurar la validez del contenedor cifrado.
* Se añadió verificación para evitar sobrescribir contenedores existentes.
* Se implementó sistema de lock file y limpieza automática de temporales.
* Se optimizó el manejo de contraseñas y variables sensibles en memoria.
* Se agregaron barras de progreso reales usando pv
* se optimizó el flujo con tar + gzip antes del cifrado.
* se restauran automáticamente los archivos a sus rutas originales al descifrar.
* Se mejoró la detección de errores y la experiencia general del usuario.
* Se mejoró el sistema de cifrado aumentando la seguridad del flujo y la derivación de clave mediante PBKDF2.

## 🚀 Resultado V2:

Una versión más segura, estable y rápida, con cifrado completo en contenedor, restauración automática y progreso visual durante todo el proceso.

## 🛠️ Proxima update V3.0

En próximas actualizaciones se incorporarán todas las mejoras de seguridad al resto de funciones del script.


## Funciones automatizadas incluidas:

| Funcion        |   Informacion                                                                                                                      |
|---------------|------------------------------------------------------------------------------------------------------------------------------------ |                                                                                
| Galeria Lock:                            | Cifra toda la galeria de /sdcard/                                                                        |
| Cifrado Completo                         | Cifra todo tipo de archivos del directorio raiz pueden agregar extensiones si desean                     |
| Filtrar cifrado por extensiones          | Filtra y cifra todos los archivos de la raiz por extensiones (videos, imagenes, audios o documentos)     |
| Eliminar Metadatos                       | Elimina cualquier metadato de imagenes con exiftool                                                      |
| Cambiar nombres aleatorios a archivos    | renombra los archivos a nombres aleatorios para dificultar su identificacion                             |



## Compatible con

| OS |   Estado      |
|--------------|---------------| 
| Android      | Compatible    |


El script está pensado para Android, no para iOS, aunque también podría funcionar perfectamente si se realizan las modificaciones correspondientes en el código. 


# Dependencias:

| Dependencias nesesarias | 
|-------------------------|
| openssl                 | 
| awk                     | 
| gawk                    | 
| sed                     |
| toilet                  | 
| figlet                  | 
| shred                   |
| exiftool                |



## Instalacion 🔧

* git clone https://github.com/FacuSecX/fillock
* cd fillock
* chmod +x install.sh
* ./install.sh

## Creditos:

* Facu (FacuSecX)
* Script en construccion, cualquier error, reportarlo.
* Regalanos una estrella en el repositorio, gracias.
  
