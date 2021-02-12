ORG 100h 
include 'emu8086.inc'   ;Para funciones de print_num, pthis
.model small            ;por defecto 
.stack
.data                   ;las variables, mensajes, dato     



;Menu principal
msgPrincipal1 db "-----------------Taller Arquitectura----------------$"
msgPrincipal2 db "----------Desarrollado por Rodrigo Dominguez--------$" 
msgPrincipal3 db "--------------------Menu Principal------------------$"
opt1 db "1) Generar 3 vectores Aleatorios. $"                                                                    
opt2 db "2) Imprimir los 3 Vectores generados. $"
opt3 db "3) Ordenar los 3 Vectores. $"   
opt4 db "4) Salir. $"
msgPedirOpt db "Ingrese un valor en decimal: $"

;Variables y mensajes utilizados en la Opcion 1
Vector DW 25 DUP(0)                     ;espacio reservado para almacenar los 3 vectores
lengthVector DW 0                       ;Largo del vector
random DW 0                             ;Variable que almacena el un valor aleatorio
msgVectorLlenado db "Los 3 vectores han sido llenados$"

;Variables y mensajes utilizados en la Opcion 2
msgVector1 db "Vector 1: $"                      
msgVector2 db "Vector 2: $"
msgVector3 db "Vector 3: $"

                                

;Variables y mensajes Opcion 3
sumaVector1 DW 0                        ;Variable que almacena la suma del vector 1
sumaVector2 DW 0                        ;Variable que almacena la suma del vector 2
sumaVector3 DW 0                        ;Variable que almacena la suma del vector 3
msgOrdenando db "Ordenando Vectores... $"
msgOrdenado db "Vectores Ordenados con exito!$"
msgSumaVector1 db "Suma del vector 1: $"
msgSumaVector2 db "Suma del vector 2: $"
msgSumaVector3 db "Suma del vector 3: $"
msgVectorVacio db "Los vectores estan vacios, debe ingresar valores con la Opcion 1.$"
                             

saltoLinea db 10,13,'$' 
 
 
opt db '$' 
 
 
.code                                   ;Inicio del codigo
mov ax,@data        
mov ds,ax 

call principal                          ;llamada a la funcion principal
call exit

;Funcion de codigo inicial
principal:
    call desplegarMenuPrincipal
    call selectOpt
    ret


;Funcion que despliega el menu principal 
desplegarMenuPrincipal:
 
    mov ah,09h                          ;Interrupcion para imprimir
    mov dx,offset msgPrincipal1 
    int 21h 
    
    call salto
    
    mov ah,09h                          ;Interrupcion para imprimir
    mov dx,offset msgPrincipal2
    int 21h 
    
    call salto 
    
    mov ah,09h                          ;Interrupcion para imprimir
    mov dx,offset msgPrincipal3
    int 21h 
    
    call salto
    
    mov ah,09h
    mov dx,offset opt1
    int 21h  
    
    call salto
      
    mov ah,09h
    mov dx,offset opt2
    int 21h 
    
    call salto   
    
    mov ah,09h
    mov dx,offset opt3
    int 21h 
    
    call salto
    
    mov ah,09h
    mov dx,offset opt4
    int 21h 
    
    call salto
    
    ret    


;Funcion que verifica el numero ingresado en pantalla e ingresa a la opcion solicitada
selectOpt:
    
    mov ah,09h
    mov dx,offset msgPedirOpt
    int 21h

    mov ah,01h                          ;interrupcion para pedir caracter por teclado
    int 21h
    mov bh,al
    
    call salto
    
    cmp bh,31h
    je  realizarOpcionUno               ;opcion para llenar 3 vectores
    
    cmp bh,32h
    je  realizarOpcionDos               ;opcion de mostrar datos
    
    cmp bh,33h
    je  realizarOpcionTres              ;opcion de sumar los dos primeros
    
    cmp bh,34h
    je  realizarOpcionCuatro            ;terminar ejecucion
    
    jmp selectOpt

;Funcion que llena los 3 vectores
realizarOpcionUno:
    mov SI,0                            ;Deja registro indice en 0
    mov lengthVector,21                 ;Establece el largo del vector en 21
    mov AX,0                            ;Set AX=0
    jmp llenarVector                    ;Llamado a la funcion que llena el vector
    

;Funcion que va ingresando valores a las posiciones del vector    
llenarVector: 
    call Aleatorio                      ;set random = valor aleatorio
    mov AX, random                      ;mueve el valor aleatorio al AX
    mov Vector[SI], AX                  ;deja el valor aleatorio en la posision SI del vector
    inc SI                              ;incrementa el SI
    cmp SI, lengthVector                ;verifica que se lleno las 21 posiciones del vector
    jl llenarVector                     ;si aun no se llena vuelve a ejecutar la funcion llenarVector
    
    mov ah,09h
    mov dx,offset msgVectorLlenado
    int 21h
    
    call salto
    call salto
    
    jmp principal                       ;Salto al menu Principal
 

;Funcion que imprime los 3 vectores    
realizarOpcionDos: 
    mov SI,0                            ;set registro indice = 0
    
    mov ah,09h
    mov dx,offset msgVector1
    int 21h
    
    mov ah,02h                          ;Imprime "["
    mov dl,5bh
    int 21h
    
    call imprimirVector1                ;Llamada a imprimir vector 1
    
    mov ah,02h
    mov dl,5dh                          ;Imprime "]"
    int 21h
    
    call salto
    
    mov ah,09h
    mov dx,offset msgVector2
    int 21h
    
    mov ah,02h                          ;Imprime "["
    mov dl,5bh
    int 21h
    
    call imprimirVector2                ;Llamada a imprimir el vector 2
    
    mov ah,02h
    mov dl,5dh                          ;Imprime "]"
    int 21h
    
    call salto
    
    mov ah,09h
    mov dx,offset msgVector3
    int 21h
                                        ;Imprime "["
    mov ah,02h
    mov dl,5bh
    int 21h
    
    call imprimirVector3                ;Llamada a imprimir el vector 3
    
    mov ah,02h
    mov dl,5dh                          ;Imprime "]"
    int 21h
    
    call salto

    jmp principal                       ;Retorno al menu principal
    
    
;Funcion que imprime el vector 1    
imprimirVector1:
    mov AX, Vector[SI]                  ;Pasa al AX los valores desde el Vector en la posicion 0 a la 6
    mov AH, 0                           ;Elimina la parte AH para que solo quede la parte AL que contiene el numero aleatorio
    call PRINT_NUM                      ;Imprime el numero que se almacena en AX
    
    mov ah,02h
    mov dl,2ch                          ;Imprime ","
    int 21h
    
    mov ah,02h
    mov dl,20h                          ;Imprime " "
    int 21h
    
    inc SI                              ;Incrementa el registro Indice
    
    cmp SI, 7                           ;compara el registro indice si es < 7
    jl imprimirVector1                  ;si SI < 7 vuelve a realizar la funcion
    ret    
    
;Funcion que imprime el vector 2    
imprimirVector2:
    mov AX, Vector[SI]                  ;Pasa al AX los valores desde el Vector en la posicion 7 a la 13
    mov AH, 0                           ;Elimina la parte AH para que solo quede la parte AL que contiene el numero aleatorio
    call PRINT_NUM                      ;Imprime el numero que se almacena en AX
    
    mov ah,02h
    mov dl,2ch                          ;Imprime ","
    int 21h
    
    mov ah,02h                          ;Imprime " "
    mov dl,20h
    int 21h
    
    inc SI                              ;Incrementa el registro Indice
    
    cmp SI, 14                          ;compara el registro indice si es < 14
    jl imprimirVector2                  ;si SI < 14 vuelve a realizar la funcion
    ret                                 ;retorno a la funcion OpcionTres
    

;Funcion que imprime el vector 3    
imprimirVector3:
    mov AX, Vector[SI]                  ;Pasa al AX los valores desde el Vector en la posicion 14 a la 20
    mov AH, 0                           ;Elimina la parte AH para que solo quede la parte AL que contiene el numero aleatorio
    call PRINT_NUM                      ;Imprime el numero que se almacena en AX
    
    mov ah,02h                          ;Imprime ","
    mov dl,2ch
    int 21h
    
    mov ah,02h                          ;Imprime " "
    mov dl,20h
    int 21h
    
    inc SI                              ;Incrementa el registro Indice
    
    cmp SI, 21                          ;compara el registro indice si es < 21
    jl imprimirVector3                  ;;si SI < 21 vuelve a realizar la funcion
    ret                                 ;retorno a la funcion OpcionTres

  
;Funcion que ordena los 3 vectores de acuerdo al algoritmo indicado en el taller
realizarOpcionTres:
    mov SI, 0                           ;Set Indice = 0
    mov sumaVector1, SI                 ;Set sumaVector1 = 0
    mov sumaVector2, SI                 ;Set sumaVector2 = 0
    mov sumaVector3, SI                 ;Set sumaVector3 = 0
    
    call SumarVector1                   ;Llamado a la funcion que suma el primer vector
    call SumarVector2                   ;Llamado a la funcion que suma el segundo vector
    call SumarVector3                   ;Llamado a la funcion que suma el tercer vector
    
    cmp sumaVector1, 0                  ;Verifica que la suma del vector1 no sea 0 ya que esto indicaria que no hay valores en el vector 1
    Je VectorVacio
    
    cmp sumaVector2, 0                  ;Verifica que la suma del vector2 no sea 0 ya que esto indicaria que no hay valores en el vector 2
    Je VectorVacio
    
    cmp sumaVector3, 0                  ;Verifica que la suma del vector3 no sea 0 ya que esto indicaria que no hay valores en el vector 3
    Je VectorVacio
    
    mov lengthVector, 20                ;Set LengthVector = 20
    mov SI, lengthVector                ;Set Registro Indice = 20
    
    mov AX, sumaVector1                 ;Set AX = suma del vector 1
    cmp AX, sumaVector2                 ;Compara la suma del vector 1 con la suma del vector 2
    jge Reordenar                       ;Si sumaVector1 > sumaVector2 salta a la funcion Reordenar
    
    mov AX, sumaVector2                 ;Set AX = suma del vector 2
    cmp AX, sumaVector3                 ;Compara la suma del vector 2 con la suma del vector 3
    jge Reordenar                       ;Si sumaVector2 > sumaVector3 salta a la funcion Reordenar
    
    call salto
    mov ah,09h
    mov dx,offset msgOrdenado
    int 21h
    call salto
    
    mov ah,09h
    mov dx,offset msgSumaVector1
    int 21h
    
    mov AX,sumaVector1
    call PRINT_NUM  
    call salto
    
    mov ah,09h
    mov dx,offset msgSumaVector2
    int 21h
    
    mov AX,sumaVector2
    call PRINT_NUM  
    call salto
    
    mov ah,09h
    mov dx,offset msgSumaVector3
    int 21h
    
    mov AX,sumaVector3
    call PRINT_NUM  
    call salto

    call principal


;Funcion que va sumando cada posicion del vector 1 desde la 0 a la 6 y la coloca en la variable sumaVector1    
SumarVector1:
    mov AX, Vector[SI]                  ;coloca el valor del vector en la posicion SI en el AX
    mov AH, 0                           ;borra el AH para dejar el valor solo del AL
    add sumaVector1,AX                  ;suma el contenido del AX a la variable sumaVector1
    inc SI                              ;incrementa el SI
    cmp SI, 7                           ;verifica que el SI sea menor a 7
    jl SumarVector1                     ;Si es menor se vuelve a ejecutar la funcion
    ret                                 
    
;Funcion que va sumando cada posicion del vector 2 desde la 7 a la 13 y la coloca en la variable sumaVector2        
SumarVector2:
    mov AX, Vector[SI]                  ;coloca el valor del vector en la posicion SI en el AX
    mov AH, 0                           ;borra el AH para dejar el valor solo del AL
    add sumaVector2,AX                  ;suma el contenido del AX a la variable sumaVector2
    inc SI                              ;incrementa el SI
    cmp SI, 14                          ;verifica que el SI sea menor a 14
    jl SumarVector2                     ;Si es menor se vuelve a ejecutar la funcion
    ret
    
;Funcion que va sumando cada posicion del vector 3 desde la 14 a la 20 y la coloca en la variable sumaVector3    
SumarVector3:    
    mov AX, Vector[SI]                  ;coloca el valor del vector en la posicion SI en el AX
    mov AH, 0                           ;borra el AH para dejar el valor solo del AL
    add sumaVector3,AX                  ;suma el contenido del AX a la variable sumaVector2
    inc SI                              ;incrementa el SI
    cmp SI, 21                          ;verifica que el SI sea menor a 14
    jl SumarVector3                     ;Si es menor se vuelve a ejecutar la funcion
    ret
    
;Algoritmo que mueve las posiciones del vector una posicion mas adelante y pasa el ultimo valor al primero.
Reordenar:  
    mov AX, Vector[SI]                  ;Mueve el valor en ultima posicion del vector al AX
    mov Vector[SI+1], AX                ;Mueve el AX a la posision siguiente del vector
    
    dec SI                              ;decrementa el SI
    
    jne Reordenar                       ;si SI es != 0 vuelve a ejecutar el corrimiento de valores
    
    mov ah,09h
    mov dx,offset msgOrdenando
    int 21h
    
    call salto
    
    mov AX, Vector[21]                  ;Copia la ultima posision del vector al AX
    mov Vector[0], AX                   ;Copia en la primera posision del vector el valor de AX
    
    jmp realizarOpcionTres              ;retorno a la opcionTres
    

;Funcion que finaliza el programa    
realizarOpcionCuatro:
    call exit
       

;Funcion que entrega un mensaje de vector vacio
VectorVacio:
    mov ah,09h
    mov dx,offset msgVectorVacio
    int 21h
    
    call salto
    
    jmp principal

;Funcion que salta una linea        
salto: 

    mov ah,09h
    mov dx,offset saltoLinea
    int 21h  
    
    ret

;Funcion que genera un numero aleatorio
Aleatorio:
    mov ah,2Ch                      ; Funcion del sistema operativo (lectura Tiempo del Sistema)
    int 21h
    cmp dl,100                      ; Compara DL = 100
    je Aleatorio                    ; Si DL = 100 vuelve a ejecutar la funcion   
    mov al,dl                       ; En DL se encuentran las centesimas de segundos y se mueven a AL
    cbw                             ; Funcion transforma AL de 8 bit a WORD de 16 Bit AX
    mov random , AX                 ; el numero aleatorio del AX a la variable Aleatorio
    ret                             ; Retorno al sistema

;Salida al sistema
exit: 
    mov ah,4ch
    int 21h
    


;Llamadas a funciones Print_num y Pthis
FIN():
    DEFINE_SCAN_NUM
    DEFINE_PRINT_NUM  
    DEFINE_PRINT_NUM_UNS
    DEFINE_PTHIS       
    
END    