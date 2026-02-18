#!/data/data/com.termux/files/usr/bin/bash

#Author: Facu Salgado https://github.com/FacuSecX/
#instagram: @FacuSecX
#Telegram: https://t.me/facuSecX



#AVISOS:


#Script para encriptacion de todo tipo de archivos en Android de forma Segura, rapida e ilimitada.
#Podemos filtrar por tipos de archivo, videos, imagenes, audios, pdf,etc...
#Tambien podemos hacer una filtracion especifica de la galeria donde se almacenan las fotos, videos, separados por carpetas..
#Tamben podemos cifrar el telefono por completo, esto incluye, todo tipo de archivos, audios,videos,imagenes,documentos (todos combinados)
#Una funcion de eliminacion de metadatos de todas las imagenes por directorios, para ayudar a mantener los datos seguros.



#ADVERTENCIAS AL USAR ESTE PROGRAMA:

#El uso de este script queda bajo su responsabilidad, si encripta y no protege las claves de forma segura,  perdera sus archivos sin posibilidad de recuperacion.
#El autor de este programa no se hace responsable por perdidas de archivos, el uso queda bajo su responsabilidad..

#si el codigo esta mal optmizado pueden hacerle mejoras ustedes mismos, pero fue testeado y funciona sin prolemas.. en lo posible si lo modifican dejen creditos..




# Colores
COLOR_ROJO='\033[31m'
COLOR_CELESTE='\033[36m'
COLOR_VERDE='\033[32m'
COLOR_RESET='\033[0m'

azul='\033[0;34m'
verde='\033[0;32m'
rojo='\033[0;31m'
nc='\033[0m' # No Color
blanco="\033[1;37m"
violeta="\033[0;35m"
amarillo="\033[1;33m"
violeta2="\033[0;35m"
green="\033[1;32m"
blue="\033[1;34m"

#Logs

LOG_FILE="$HOME/.log_cifrados"



#Filtrar por tipo de archivos

EXT_IMAGENES=(".jpg" ".jpeg" ".png" ".bmp" ".webp" ".gif")
EXT_VIDEOS=(".mp4" ".avi" ".mkv" ".3gp" ".mov")
EXT_AUDIOS=(".mp3" ".wav" ".ogg" ".m4a" ".flac" )
EXT_OTROS=(".pdf" ".exe" ".txt" ".zip" ".rar" ".opus" ".csv" ".html" ".htm" ".vcf" ".log" ".bak" ".db" ".sqlite" ".xls" ".xlsx" ".doc" ".docx"  )


# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        echo -e "$blue($1)$nc Instalado [$green✓$nc]"
    else
        echo -e "$blue($1)$nc No instalado [$red✗$nc]"
        echo -e "Instalá escribiendo: pkg install $1 -y"
        exit 
    fi
}

# Verificar paquetes críticos
check_command openssl
check_command pv
check_command tar
check_command gzip
check_command awk
check_command gawk
check_command sed
check_command cowsay
check_command figlet
check_command mpv
check_command exiftool
check_command shred
check_command ruby
check_command gem







#Funciones

function ctrl_c() {
echo -e "$nc($azul*$nc)$verde Presionaste la tecla$rojo CTRL + C$verde Saliendo del Programa..${nc}"
sleep 2
exit 1
}


mostrar_mensaje() { echo -e "${COLOR_CELESTE}$1${COLOR_RESET}"; }
mostrar_error() { echo -e "${COLOR_ROJO}$1${COLOR_RESET}"; }
mostrar_ok() { echo -e "${COLOR_VERDE}$1${COLOR_RESET}"; }

# Función para guardar log
log_agregar() {
    echo "$1" >> "$LOG_FILE"
}

# Función para eliminar entradas de log relacionadas
log_eliminar() {
    tipo="$1"
    if [ -f "$LOG_FILE" ]; then
        grep -v "^$tipo:" "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"
    fi
}

# Mostrar logs
log_mostrar() {
    if [ ! -f "$LOG_FILE" ] || [ ! -s "$LOG_FILE" ]; then
        mostrar_mensaje "No hay registros de cifrados actuales."
        return
    fi
    mostrar_mensaje "Registros de cifrados actuales:"
    while IFS=: read -r tipo detalle; do
        case "$tipo" in
            individual) echo "- Cifrado individual en directorios: $detalle" ;;
            completo) echo "- Cifrado completo en rutas: $detalle" ;;
            tipo) echo "- Cifrado por tipo de archivo: $detalle" ;;
            *) echo "- $tipo: $detalle" ;;
        esac
    done < "$LOG_FILE"
}

cifrado_completo() {
    echo -e "${nc}(${verde}*${nc}) Este proceso cifrará todos los archivos de su celular..."
    sleep 1
    echo -e "${nc}(${verde}*${nc}) Incluyendo audios, fotos, videos y otros archivos"
    sleep 1
    echo -e "${nc}(${verde}*${nc}) Se recomienda guardar la contraseña"
    sleep 1
    echo -e "${nc}(${rojo}ADVERTENCIA${nc}) Si pierde esta contraseña sus archivos serán irrecuperables"
    sleep 1
    echo

    exec 3<&0
    read -s -p "(*) Escribí tu contraseña: " pass1 <&3
    echo
    read -s -p "(*) Repetí tu contraseña: " pass2 <&3
    echo
    exec 3<&-

    if [[ "$pass1" != "$pass2" ]]; then
        echo -e "${rojo}✖ Las contraseñas no coinciden.${nc}"
        unset pass1 pass2
        return 1
    fi

    pass_hash=$(echo -n "$pass2" | sha256sum | awk '{print $1}')
    unset pass1 pass2

    # --- Rutas Termux ---
    SDCARD="$HOME/storage/shared"
    CONTENEDOR="$SDCARD/vault.enc"
    TEMP_VAULT="$SDCARD/vault.tmp"
    TAR_GZ="$SDCARD/vault.tar.gz"
    LISTADO_TMP="$SDCARD/listado_archivos.tmp"
    LOCK_FILE="$SDCARD/.vault.lock"

    # 🔴 Verificar contenedor existente
    if [ -f "$CONTENEDOR" ]; then
        echo -e "${rojo}⚠ Ya existe un contenedor:${nc} $CONTENEDOR"
        unset pass_hash
        return 1
    fi

    # 🔴 Proceso previo incompleto
    if [ -f "$LOCK_FILE" ]; then
        echo -e "${rojo}⚠ Proceso previo incompleto detectado.${nc}"
        read -p "¿Eliminar temporales y continuar? (s/n): " resp
        if [[ "$resp" =~ ^[Ss]$ ]]; then
            rm -f "$LOCK_FILE" "$TEMP_VAULT" "$TAR_GZ" "$LISTADO_TMP"
        else
            unset pass_hash
            return 1
        fi
    fi

    touch "$LOCK_FILE"

    # 🔹 Extensiones a cifrar
    EXT_TODAS=("${EXT_IMAGENES[@]}" "${EXT_VIDEOS[@]}" "${EXT_AUDIOS[@]}" "${EXT_EXTRA[@]}")
    filtros_find=()
    for ext in "${EXT_TODAS[@]}"; do
        filtros_find+=( -iname "*${ext}" -o )
    done
    unset 'filtros_find[${#filtros_find[@]}-1]'

    echo -e "${nc}(${azul}*${nc}) Preparando contenedor...${nc}"

    # 🔹 Crear listado con exclusión de Android
    cd "$SDCARD" || return 1
    find . -type f \( "${filtros_find[@]}" \) -print0 > "$LISTADO_TMP"

    total_files=$(tr -cd '\0' < "$LISTADO_TMP" | wc -c)

    # 🔹 Crear tar.gz con progreso
    tar --null -T "$LISTADO_TMP" -cf - 2>/dev/null | pv -0 -s "$total_files" | gzip -c > "$TAR_GZ"

    echo -e "${nc}(${azul}*${nc}) Cifrando contenedor...${nc}"

    total_bytes=$(stat -c%s "$TAR_GZ")
    if ! pv -s "$total_bytes" "$TAR_GZ" | openssl enc -aes-256-cbc -pbkdf2 -salt -pass pass:"$pass_hash" -out "$TEMP_VAULT"; then
        echo -e "${rojo}✖ Error durante el cifrado${nc}"
        rm -f "$TEMP_VAULT" "$TAR_GZ" "$LISTADO_TMP" "$LOCK_FILE"
        unset pass_hash
        return 1
    fi

    mv "$TEMP_VAULT" "$CONTENEDOR"

    # 🔹 Eliminar archivos originales tras cifrado
    while IFS= read -r -d '' archivo; do
        rm -f "$SDCARD/$archivo"
    done < "$LISTADO_TMP"

    rm -f "$TAR_GZ" "$LISTADO_TMP" "$LOCK_FILE"
    unset pass_hash

    echo -e "${verde}✔ Contenedor creado correctamente: $CONTENEDOR${nc}"
    echo -e "${verde}✔ Cifrado completo finalizado.${nc}"
    sleep 1
    menu_principal
}














buscar_directorios_por_extension() {
    tipo="$1"
    declare -n EXTENSIONES="EXT_${tipo^^}"

    echo
    echo -e "${nc}Buscando archivos del tipo: ${amarillo}${tipo}${nc}..."
    sleep 8

    # ── 1. Construir una expresión OR para find ───────────────────────────
    find_expr=()
    for ext in "${EXTENSIONES[@]}"; do
        find_expr+=( -iname "*${ext}" -o )
    done
    unset 'find_expr[-1]'             # eliminar el último -o

    # ── 2. Obtener la lista de archivos (un solo find, -print0) ───────────
    mapfile -d '' -t ARCHIVOS_OBJETIVO < <(
        find /sdcard/ -type f \( "${find_expr[@]}" \) ! -iname "*.enc" -print0 2>/dev/null
    )

    total_archivos=${#ARCHIVOS_OBJETIVO[@]}

    if [ "$total_archivos" -eq 0 ]; then
        echo
        echo -e "${nc}No se encontraron archivos del tipo${amarillo} ${tipo} ${nc}"
        sleep 4
        menu_principal
    fi

    echo -e "${nc}Archivos encontrados:${amarillo} $total_archivos${nc}"
    sleep 4
    echo
    read -p $'\e[01;35m(*)\e[01;32m ¿Deseás cifrarlos? (s/n): \e[01;33m' confirm
    [[ "$confirm" != "s" ]] && echo -e "${rojo}Cancelado.${nc}" && menu_principal

    printf "\e[01;35m(*)\e[01;32m Ingresá tu contraseña:\e[01;33m "
    read -s pass1; echo
    printf "\e[01;35m(*)\e[01;32m Confirmá la contraseña:\e[01;33m "
    read -s pass2; echo
    [[ "$pass1" != "$pass2" ]] && echo -e "${nc} Contraseñas no coinciden.. Cancelando...${nc}" && return 1

    echo -e "${nc}(${azul}*${nc})${verde} comenzando cifrado...${nc}"
    sleep 5
    echo

    # ── 3. Cifrar archivo por archivo ─────────────────────────────────────
    for file in "${ARCHIVOS_OBJETIVO[@]}"; do
        echo -e "${nc}Cifrando:${amarillo} $(basename "$file")${nc}"
        if openssl enc -aes-256-cbc -pbkdf2 -salt -in "$file" -out "$file.enc" -pass pass:"$pass1"; then
            rm -f "$file"
        fi
    done

    echo
    echo -e "${nc}cifrado completo... volviendo al menu principal..."
    log_agregar "tipo:$tipo"
    sleep 6
    echo
    menu_principal
}









# Encriptar directorios individualmente en Galeria /sdcard/DCIM
encriptar() {

    echo
   echo -e "${amarillo}(${verde}✔${amarillo})${nc} Este proceso Cifrara su galeria"
    sleep 3
    echo
	echo -e "${amarillo}(${verde}✔${amarillo})${nc} Se recomienda Guardar la contraseña"
    sleep 3
	echo
	echo -e "${nc}${rojo}ATENCION:${nc} Si pierde esta contraseña sus archivos seran irrecuperables"
	sleep 4
	echo
	echo -e "${amarillo}(${verde}✔${amarillo})${nc} Detectando directorios.. aguarde...${amarillo}"
	sleep 4
	echo
    
    mapfile -t directorios_full < <(find /sdcard/DCIM -maxdepth 1 -type d)
    directorios_nombres=()
    for dir in "${directorios_full[@]}"; do
        directorios_nombres+=("$(basename "$dir")")
    done

    if [ ${#directorios_nombres[@]} -eq 0 ]; then
        mostrar_error "No se encontraron directorios en /sdcard/DCIM."
		sleep 1
		echo -e "(${verde}✔${nc}) ${verde}volviendo al menu principal${nc}"
		sleep 4
		menu_principal
       
    fi
    
directorios_coloreados=()
for dir in "${directorios_nombres[@]}"; do
    directorios_coloreados+=( "${verde}${dir}${reset}" )
done    

PS3=$'\e[01;35m(*)\e[01;32m Elige una Opcion: \e[01;33m'

select opcion in "${directorios_nombres[@]}"; do
    if [[ -n "$opcion" && "$REPLY" =~ ^[0-9]+$ ]]; then
        directorio="${directorios_full[$REPLY-1]}"
        echo -e "${verde}Seleccionaste el directorio:${amarillo} $directorio"
		sleep 3
        break
    else
        echo -e "$rojo(ERROR)$azul $REPLY $verde Opción no válida $nc"
    fi
done

    # Buscar archivos no cifrados para cifrar
    archivos_a_cifrar=()
    while IFS= read -r -d '' file; do
        archivos_a_cifrar+=("$file")
    done < <(find "$directorio" -maxdepth 1 -type f ! -name "*.enc" -print0)

    if [ ${#archivos_a_cifrar[@]} -eq 0 ]; then
        
		echo -e "${nc} No se encontraron archivos para cifrar en${amarillo} $directorio.${nc}"
		sleep 3
	  echo -e "${nc} es posible que el directorio ya contenga archivos cifrados."
	  sleep 2
	  echo
	   echo -e "${nc} en ese caso debe desencriptar antes de cifrar nuevamente."
	  sleep 3
	  echo -e "${nc} volviendo al menu principal..."
	  sleep 2
	  echo
	  
		menu_principal
		
        
    fi
    sleep 2
	echo
	echo -e "${amarillo}(${verde}✔${amarillo})${nc} Se detectaron${amarillo} ${#archivos_a_cifrar[@]} ${nc} archivos para cifrar en la carpeta${amarillo} $opcion"
	sleep 4
	echo
    

    # Verificar si ya existen archivos .enc en el directorio
    if compgen -G "$directorio/*.enc" > /dev/null; then
        mostrar_error "El directorio ya contiene archivos cifrados (.enc) proceso abortado"
		echo -e "(${rojo}✖${nc} El directorio ya contiene archivos cifrados (.enc) proceso abortado"
		sleep 1
		echo -e "(${verde}✔${nc}) ${verde}volviendo al menu principal${nc}"
		sleep 3
		menu_principal
    
    fi
   #Pedir contraseña
    printf "\e[01;35m(*)\e[01;32m Escribí tu contraseña:\e[01;33m "
    read -s password1; 
	echo
    
	
	#Confirmar contraseña
    printf "\e[01;35m(*)\e[01;32m Repetí tu contraseña:\e[01;33m "
	read -s password2; 
	echo
    
	
	#Verificar Contraseñas
	if [ "$password1" != "$password2" ]; then
          echo
		  printf "\e[01;35m(*)\e[01;32m Las contraseñas no coinciden. intenta de nuevo...\e[01;33m "
		 sleep 3
		menu_principal
    fi

    mostrar_mensaje "¿Confirmás cifrar los archivos en '$opcion'? (s/n):"
    read -r confirmacion
    [[ "$confirmacion" != "s" ]] && mostrar_error "Cancelado." && menu_principal

    # Verificar si shred está disponible
    if command -v shred >/dev/null 2>&1; then
        BORRADO_SEGURO="shred -u -n 3 -z"  #Sobrescribe el archivo original 3 veces antes de borrarlo, para evitar su recuperacion mediante tecnicas Forenses
    else
        BORRADO_SEGURO="rm -f"
        
		echo -e "${rojo}Waring(${nc} shred no encontrado. Se usará borrado normal.  "
    fi

    exitosos=0
    errores=0
    ERROR_LOG="encriptar_errores.log"
    > "$ERROR_LOG"

    for archivo in "${archivos_a_cifrar[@]}"; do
        destino="$archivo.enc"
        if [ -e "$destino" ]; then
            mostrar_error "Archivo cifrado ya existe, saltando: $(basename "$destino")"
			
			
            continue
        fi

        if openssl enc -aes-256-cbc -pbkdf2 -salt -in "$archivo" -out "$destino" -pass pass:"$password1"; then
            # Borrado seguro del archivo original
            if $BORRADO_SEGURO "$archivo"; then
               
				echo -e "${nc} Cifrado:${verde} $(basename "$archivo") ${nc}"
				
            else
                
				echo -e "${rojo}✘(${nc} Error borrando archivo:${nc} $(basename "$archivo") "
            fi
            ((exitosos++))
        else
           
			echo -e "${rojo}✘(${nc} Error al cifrar:${nc} $(basename "$archivo") "
            echo "$(date '+%Y-%m-%d %H:%M:%S') Error cifrando: $archivo" >> "$ERROR_LOG"
            ((errores++))
        fi
    done

   
	echo
	echo -e "${nc}Cifrados exitosos:${verde} $exitosos${nc} Errores:${rojo} $errores.${nc}"
	sleep 3
	
	

    if [ "$errores" -gt 0 ]; then
        
		echo -e "${nc}AVISO(${nc} Hubo errores. Revisa $ERROR_LOG para más detalles. "
		sleep 1
		
    fi

    log_agregar "individual:$directorio"
	sleep 1
	echo
	echo -e "(${verde}✔${nc}) ${nc}volviendo al menu principal${nc}"
	sleep 3
	menu_principal
}



# Desencriptar archivos individualmente

listar_directorios_enc() {
     echo
	 echo -e "${amarillo}(${verde}✔${amarillo})${nc} Analizando directorios... espere..."
	 sleep 4
    mapfile -t directorios_full < <(find /sdcard/DCIM -maxdepth 1 -type d -exec bash -c 'shopt -s nullglob; files=("$1"/*.enc); (( ${#files[@]} )) && echo "$1"' _ {} \;)
    
    if [ ${#directorios_full[@]} -eq 0 ]; then
        echo -e "${amarillo}(${verde}*${amarillo})${nc} No se encontraron directorios cifrados..."
		sleep 3
		echo -e "${amarillo}(${verde}✔${amarillo})${nc} volviendo al menu principal..."
        sleep 2
		menu_principal
    fi

    directorios_nombres=()
    for dir in "${directorios_full[@]}"; do
        directorios_nombres+=("$(basename "$dir")")
    done

     echo -e "${amarillo}(${verde}✔${amarillo})${nc} Directorios encriptados detectados:"
	 sleep 2
	 echo
    select opcion in "${directorios_nombres[@]}"; do
        if [ -n "$opcion" ]; then
            for i in "${!directorios_nombres[@]}"; do
                if [[ "${directorios_nombres[$i]}" == "$opcion" ]]; then
                    directorio="${directorios_full[$i]}"
                    sleep 1
					mostrar_mensaje "Seleccionaste: $directorio"
					sleep 2
					echo
					
                    break 2
                fi
            done
        else
            mostrar_error "Selección inválida."
        fi
    done
}




descifrado_por_tipo() {
    mostrar_mensaje "¿Qué tipo de archivos querés descifrar?"
    echo "1) Imágenes"
    echo "2) Videos"
    echo "3) Audios"
     echo "4) Otros"
    read -p "Opción: " opcion_tipo

    case $opcion_tipo in
        1) tipo="imagenes" ;;
        2) tipo="videos" ;;
        3) tipo="audios" ;;
        4) tipo="otros" ;;


        *) mostrar_error "Opción inválida." && return 1 ;;
    esac

    declare -n EXTENSIONES="EXT_${tipo^^}"

    filtros_find=()
    for ext in "${EXTENSIONES[@]}"; do
        filtros_find+=(-iname "*${ext}.enc" -o)
    done
    unset 'filtros_find[${#filtros_find[@]}-1]'  # Elimina el último -o

    mapfile -t DIRECTORIOS_ENC < <(
        find /sdcard/ -type f \( "${filtros_find[@]}" \) -printf '%h\n' 2>/dev/null | sort -u
    )

    if [ ${#DIRECTORIOS_ENC[@]} -eq 0 ]; then
        mostrar_error "No se encontraron archivos cifrados del tipo '$tipo'."
        return 1
    fi

    mostrar_mensaje "Se encontraron los siguientes directorios cifrados con archivos $tipo:"
    for dir in "${DIRECTORIOS_ENC[@]}"; do echo "- $dir"; done
    read -p "¿Deseás descifrar todos estos directorios? (s/n): " confirm
    [[ "$confirm" != "s" ]] && mostrar_error "Cancelado." && menu_principal

    mostrar_mensaje "Ingresa contraseña para descifrado:"; read -s pass; echo

    exito=0
    archivos_descifrados=()

    for dir in "${DIRECTORIOS_ENC[@]}"; do
        primer_enc=$(find "$dir" -maxdepth 1 \( "${filtros_find[@]}" \) | head -n 1)
        if ! openssl enc -d -aes-256-cbc -pbkdf2 -in "$primer_enc" -out /dev/null -pass pass:"$pass" 2>/dev/null; then
            mostrar_error "Contraseña incorrecta para $dir. Saltando."
            continue
        fi

        for enc_file in "$dir"/*.enc; do
            for ext in "${EXTENSIONES[@]}"; do
                if [[ "$enc_file" == *"$ext.enc" ]]; then
                    out="${enc_file%.enc}"
                    if openssl enc -d -aes-256-cbc -pbkdf2 -in "$enc_file" -out "$out" -pass pass:"$pass"; then
                        rm "$enc_file"
                        mostrar_ok "Descifrado: $(basename "$enc_file")"
                        archivos_descifrados+=("$out")
                        exito=1
                    else
                        mostrar_error "Error al descifrar: $(basename "$enc_file")"
                    fi
                    break
                fi
            done
        done
    done

    if [ "$exito" -eq 1 ]; then
        mostrar_ok "Descifrado por tipo completado."
		echo
		sleep 1
		 # Eliminar del log
        if [ -f "$LOG_FILE" ]; then
            echo "Eliminando línea del log: tipo:$tipo"
            sed -i "\|^tipo:$tipo\$|d" "$LOG_FILE"
        fi
		echo
		mostrar_mensaje "Actualizando sistema multimedia... aguarde.. este proceso puede demorar.."
		sleep 1

        # Refrescar todos los archivos descifrados en una sola llamada (más eficiente)
        for archivo in "${archivos_descifrados[@]}"; do
            am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d "file://$archivo" > /dev/null
        done
		

       
    else
        mostrar_error "Ningún archivo fue descifrado correctamente. El log no se modificó."
    fi
}



desencriptar() {
    listar_directorios_enc
    printf "\e[01;35m(*)\e[01;32m Ingresa la contraseña:\e[01;33m "
    read -s password
    echo

    # Verificar que el directorio tenga archivos .enc
    if ! compgen -G "$directorio/*.enc" > /dev/null; then
        mostrar_error "No se encontraron archivos cifrados en $directorio."
        return
    fi

    # Verificar la contraseña con el primer archivo
    primer_archivo_enc=$(find "$directorio" -maxdepth 1 -name "*.enc" | head -n 1)
    if ! openssl enc -d -aes-256-cbc -pbkdf2 -in "$primer_archivo_enc" -out /dev/null -pass pass:"$password" 2>/dev/null; then
        mostrar_error "Contraseña incorrecta.."
		sleep 3
		menu_principal
    fi

    echo
	echo -e "${nc}Contraseña correcta.. iniciando decifrado... aguarde.."
	sleep 4
	echo

    exito=0
    archivos_refrescados=()

    for archivo in "$directorio"/*.enc; do
        [ -f "$archivo" ] || continue
        output="${archivo%.enc}"
        if openssl enc -d -aes-256-cbc -pbkdf2 -in "$archivo" -out "$output" -pass pass:"$password"; then
            rm "$archivo"
            
			echo -e "${nc}Descifrado:${amarillo} $(basename "$archivo")"
            archivos_refrescados+=("$output")
            exito=1
        else
            mostrar_error "Error al descifrar: $(basename "$archivo")"
        fi
    done

    if [ "$exito" -eq 1 ]; then
        mostrar_mensaje "Actualizando sistema multimedia... aguarde.. este proceso puede demorar..."
		sleep 3
        for archivo in "${archivos_refrescados[@]}"; do
            am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d "file://$archivo" > /dev/null
			
        done
		echo
		
		echo -e "${nc}Descifrado individual completado en${amarillo} $directorio"
		sleep 3
		echo

        

        if [ -f "$LOG_FILE" ]; then
            dir_normalizado=$(echo "$directorio" | tr -d '\r')
            echo "Eliminando entradas que contengan exactamente: individual:$dir_normalizado"
            awk -v d="individual:$dir_normalizado" '$0 != d' "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"
			echo -e "${nc}volviendo al menu principal.."
			sleep 3
			menu_principal
        fi
    else
       
		echo -e "${nc}no se logró descifrar ningún archivo. volviendo al menu principal.."
		sleep 3
		menu_principal
	
    fi
}



descifrado_completo() {
    echo -e "${nc}(${verde}*${nc}) Ingresá la contraseña para descifrar todo..."
    sleep 1

    exec 3<&0
    read -s -p "(*) Escribí tu contraseña: " pass <&3
    echo
    exec 3<&-

    pass_hash=$(echo -n "$pass" | sha256sum | awk '{print $1}')
    unset pass

    SDCARD="$HOME/storage/shared"
    CONTENEDOR="$SDCARD/vault.enc"
    TEMP_VAULT="$SDCARD/vault.tmp"
    TAR_TMP="$SDCARD/vault.tar"

    if [ ! -f "$CONTENEDOR" ]; then
        echo -e "${rojo}✖ No se encontró el contenedor: $CONTENEDOR${nc}"
        return 1
    fi

    echo -e "${nc}(${azul}*${nc}) Preparando extracción... esto puede tardar un momento${nc}"

    total_bytes=$(stat -c%s "$CONTENEDOR")
    if ! pv -s "$total_bytes" "$CONTENEDOR" | openssl enc -d -aes-256-cbc -pbkdf2 -pass pass:"$pass_hash" -out "$TEMP_VAULT"; then
        echo -e "${rojo}✖ Contraseña incorrecta o contenedor corrupto.${nc}"
        rm -f "$TEMP_VAULT"
        unset pass_hash
        return 1
    fi

    echo -e "${nc}(${azul}*${nc}) Descomprimiendo contenedor...${nc}"
    total_bytes=$(stat -c%s "$TEMP_VAULT")
    if ! pv -s "$total_bytes" "$TEMP_VAULT" | gzip -d -c > "$TAR_TMP"; then
        echo -e "${rojo}✖ Error al descomprimir el contenedor${nc}"
        rm -f "$TEMP_VAULT" "$TAR_TMP"
        unset pass_hash
        return 1
    fi

    echo -e "${nc}(${azul}*${nc}) Restaurando archivos a sus ubicaciones originales...${nc}"
    cd "$SDCARD" || return 1
    if ! tar --null -xf "$TAR_TMP" -C "$SDCARD"; then
        echo -e "${rojo}✖ Error al extraer archivos del contenedor${nc}"
        rm -f "$TEMP_VAULT" "$TAR_TMP"
        unset pass_hash
        return 1
    fi

    rm -f "$TEMP_VAULT" "$TAR_TMP" "$CONTENEDOR"
    unset pass_hash

    echo -e "${verde}✔ Descifrado completo finalizado correctamente.${nc}"
    echo -e "${verde}✔ Contenedor eliminado tras descifrado exitoso.${nc}"
    sleep 1
    menu_principal
}







 



camuflar_nombres() {
    read -rp "Introduce la ruta absoluta del directorio a camuflar: " original_dir

    if [ ! -d "$original_dir" ]; then
        mostrar_error "La ruta ingresada no es un directorio válido."
        return 1
    fi

    parent_dir=$(dirname "$original_dir")
    folder_name=$(basename "$original_dir")

    cd "$original_dir" || { mostrar_error "No se pudo acceder al directorio."; return 1; }
    mostrar_mensaje "Renombrando archivos dentro de '$original_dir'..."

    for file in *; do
        if [ -f "$file" ]; then
            ext="${file##*.}"
            if [[ "$file" == "$ext" ]]; then
                ext=""
            else
                ext=".$ext"
            fi
            new_name=$(tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 10)
            while [ -e "$new_name$ext" ]; do
                new_name=$(tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 10)
            done
            mv "$file" "$new_name$ext"
            mostrar_ok "$file → $new_name$ext"
        fi
    done

    cd "$parent_dir" || { mostrar_error "No se pudo acceder al directorio padre."; return 1; }
    random_number=$((RANDOM * RANDOM))
    new_folder_name="$random_number"
    while [ -e "$new_folder_name" ]; do
        random_number=$((RANDOM * RANDOM))
        new_folder_name="$random_number"
    done

    mv "$folder_name" "$new_folder_name"
    mostrar_ok "Carpeta '$folder_name' renombrada a '$new_folder_name'"
    mostrar_ok "Proceso de camuflado completado."
}




eliminar_metadatos_completo() {
    for ruta in "${RUTAS_COMPLETAS[@]}"; do
        find "$ruta" -type f \( -iname ".jpg" -o -iname ".jpeg" -o -iname "*.png" \) | while read -r img; do
            exiftool -all= -overwrite_original "$img" && mostrar_ok "Metadatos borrados: $(basename "$img")"
        done
    done
    mostrar_ok "Eliminación de metadatos completa."
}












#MENU PRINCIPAL
function menu_principal(){
echo



    local a=$'\e[1;35mEncriptar Galería (borrado seguro)\e[01;32m'
    local b=$'\e[1;35mDesencriptar Galería\e[01;32m'
    local c=$'\e[1;35mCifrado completo\e[01;32m'
    local d=$'\e[1;35mDescifrado completo\e[01;32m'
    local e=$'\e[1;35mEliminar metadatos (completo)\e[01;32m'
    local f=$'\e[1;35mCifrado por tipo de archivo\e[01;32m'
    local g=$'\e[1;35mDescifrado por tipo de archivo\e[01;32m'
    local h=$'\e[1;35mConsultar cifrados actuales\e[01;32m'
    local i=$'\e[1;35mCamuflar nombres de archivos\e[01;32m'
    local j=$'\e[1;35mSalir\e[01;32m'
    
	local options=(
        "$a"
        "$b"
        "$c"
        "$d"
        "$e"
        "$f"
        "$g"
        "$h"
        "$i"
        "$j"
    )
	echo
	export PS3=$'\e[01;35m(*)\e[01;32m Elige una Opcion:\e[01;33m '
    
    while true; do
        echo -e "\n\e[1;36m--- Menú Principal: ---\e[0m"
		echo
        select opcion in "${options[@]}"; do
            case $REPLY in
                1) encriptar ;;
                2) desencriptar ;;
                3) cifrado_completo ;;
                4) descifrado_completo ;;
                5) eliminar_metadatos_completo ;;
                6)
                    sleep 2
					echo
					echo -e "${nc} Seleccioná tipo de archivo para cifrar:"
					sleep 2
					echo
                    echo -e "${nc}1) ${amarillo}Imágenes${nc} (jpg,jpeg,png,bmp,webp,gif)"
                    echo -e "${nc}2) ${amarillo}Videos${nc}   (mp4,avi,mkv,3gp,mov)"
                    echo -e "${nc}3) ${amarillo}Audios${nc}   (mp3,wav,ogg,m4a,flac)"
                    echo -e "${nc}4) ${amarillo}Otros${nc}    (pdf,exe,txt,zip,rar,apk,opus)"
					echo
                    printf "\e[01;35m(*)\e[01;32m Elige el tipo:\e[01;33m "
					read tipo
					
                    case $tipo in
                        1) buscar_directorios_por_extension "imagenes" ;;
                        2) buscar_directorios_por_extension "videos" ;;
                        3) buscar_directorios_por_extension "audios" ;;
                        4) buscar_directorios_por_extension "otros" ;;
                        *) mostrar_error "Opción inválida." ;;
                    esac
					break
                    ;;
                7) descifrado_por_tipo ;;
                8) log_mostrar ;;
                9) camuflar_nombres ;;
                10) echo -e "\e[1;31mSaliendo...\e[0m"; exit 0 ;;
                *) 
				
				
				mostrar_error "Opción inválida."
				 
				
		;;
            esac
           
        done
    done
}



#mensaje y logo bienvenida
clear
toilet --filter border Fil Lock | lolcat
echo
echo -e "$violeta2(*)$azul Fil Lock$rojo v1.0$azul"
sleep 2
echo -e "$violeta2(*)$azul Script creado por$rojo Facu Salgado"
sleep 2
echo -e "$violeta2(*)$azul Regalanos una estrella en github$verde"
sleep 2
menu_principal
