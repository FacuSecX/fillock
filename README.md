
<p align="center">
<a href="https://github.com/FacuSecX"><img title="Autor" src="https://img.shields.io/badge/Author-Facu%20-blue?style=for-the-badge&logo=github"></a>
<a href=""><img title="Version" src="https://img.shields.io/badge/Version-1.0-red?style=for-the-badge&logo="></a>
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

## AVISO IMPORTANTE:

Usar este programa es bajo su responsabilidad, ya que también puede utilizarse de forma incorrecta y podría funcionar como ransomware. Tenga en cuenta que, al momento de encriptar cualquier tipo de archivo, la clave o contraseña utilizada debe ser respaldada. Si pierde esta contraseña, los archivos serán irrecuperables.

## Objetivo:

**Fillock** tiene como prioridad la seguridad y el cifrado automático e ilimitado de tus archivos. Si bien en Android existe una gran variedad de aplicaciones para proteger fotos mediante patrones o contraseñas, la mayoría no son realmente confiables o requieren membresías costosas.
Considero que la criptografía y la protección adicional de archivos deberían venir incorporadas de forma nativa en Android; sin embargo, si alguien conoce nuestro patrón o contraseña del sistema, todos nuestros datos quedan totalmente expuestos, y el sistema no ofrece funciones internas de cifrado individual para archivos.

## Como funciona:

al utilizar cualquier opcion de cifrado, el archivo original se elimina y se encripta añadiendo la extensión .enc mediante OpenSSL. Además, se aplica un borrado seguro sobrescribiendo el archivo original con shred tres veces, lo que dificulta la recuperación mediante técnicas forenses.

## Informacion Adicional: 

Cuando encripte cualquier tipo de archivo, estos dejarán de ser visibles en sus aplicaciones, como la galería o el reproductor de música. Una vez haya desencriptado los archivos, es posible que aún no aparezcan en las aplicaciones que gestionan esos tipos de contenido. Por este motivo, el programa incluye una función de actualización multimedia que realiza un "refresh" para que sus archivos vuelvan a ser detectados y visibles nuevamente.

Este proceso puede demorar dependiendo de la cantidad de archivos que fueron cifrados. Sin embargo, puede acceder a ellos de forma más rápida mediante el gestor de archivos de su teléfono. Si prefiere no esperar el proceso de actualización, también puede reiniciar su dispositivo; al encenderlo, todos sus archivos volverán a mostrarse correctamente en la galería, el reproductor de música o cualquier aplicación que utilice para gestionar distintos tipos de archivos.

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
  
