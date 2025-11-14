
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

**AVISO IMPORTANTE:** Usar este programa es bajo su responsabilidad, ya que también puede utilizarse de forma incorrecta y podría funcionar como ransomware. Tenga en cuenta que, al momento de encriptar cualquier tipo de archivo, la clave o contraseña utilizada debe ser respaldada. Si pierde esta contraseña, los archivos serán irrecuperables.

## Como funciona:

al utilizar cualquier opcion de cifrado, el archivo original se elimina y se encripta añadiendo la extensión .enc mediante OpenSSL. Además, se aplica un borrado seguro sobrescribiendo el archivo original con shred tres veces, lo que dificulta la recuperación mediante técnicas forenses.
Por eso es fundamental mantener la clave bien protegida: si la pierdes, no habrá ninguna posibilidad de recuperar los archivos.

## Funciones automatizadas incluidas:

| Funcion        |   Informacion                                                                                                                      |
|---------------|------------------------------------------------------------------------------------------------------------------------------------ |                                                                                
| Galeria Lock:                            | Cifra toda la galeria de /sdcard/                                                                        |
| Cifrado Completo                         | Cifra todo tipo de archivos del directorio raiz pueden agregar extensiones si desean                     |
| Filtrar cifrado por extensiones          | Filtra y cifra todos los archivos de la raiz por extensiones (videos, imagenes, audios o documentos)     |
| Eliminar Metadatos                       | Elimina cualquier metadato de archivos                                                                   |
| Cambiar nombres aleatorios a archivos    | renombra los archivos a nombres aleatorios para dificultar su identificacion                             |



## Compatible con

| OS |   Estado      |
|--------------|---------------| 
| Android      | Compatible    |


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



## Instalacion 🔧

* git clone https://github.com/FacuSecX/fillock
* cd fillock
* chmod +x install.sh
* ./install.sh

## Creditos:

* Facu (FacuSecX)
* Script en construccion, cualquier error, reportarlo.
* Regalanos una estrella en el repositorio, gracias.
  
