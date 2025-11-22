; Programa: Calculadora de Fibonacci
; Descripcion: Este programa calcula el numero de fibonacci correspondiente
;              a un valor n ingresado por el usuario (rango: 0 a 24)
; Autor: Ivan Acuña
; Fecha: 18 de noviembre de 2025

.MODEL SMALL
.STACK 100h

.DATA
    ; --- Mensajes para interactuar con el usuario ---
    msgBienvenida   DB 13,10,'==== CALCULADORA DE FIBONACCI ====',13,10,'$'
    msgPedir        DB 13,10,'Ingrese el valor de n (0-24): $'
    msgResultado    DB 13,10,'El numero Fibonacci es: $'
    msgError        DB 13,10,'Error! El valor debe estar entre 0 y 24',13,10,'$'
    msgOtraVez      DB 13,10,13,10,'Desea calcular otro? (S/N): $'
    
    ; --- Variables para los calculos ---
    numeroN         DB ?        ; almacena el valor de n ingresado
    resultado       DW ?        ; guarda el resultado de fibonacci
    buffer          DB 6 DUP('$')  ; buffer para convertir numero a cadena
    temp            DW ?        ; variable temporal para calculos

.CODE
MAIN PROC
    ; inicializamos el segmento de datos
    MOV AX, @DATA
    MOV DS, AX
    
INICIO:
    ; mostramos el mensaje de bienvenida
    LEA DX, msgBienvenida
    MOV AH, 09h
    INT 21h
    
    ; pedimos al usuario que ingrese n
    LEA DX, msgPedir
    MOV AH, 09h
    INT 21h
    
    ; leemos el numero ingresado
    CALL LEER_NUMERO
    
    ; verificamos que este en el rango valido (0-24)
    CMP numeroN, 24
    JA ERROR_RANGO              ; si es mayor a 24, mostramos error
    
    ; calculamos el fibonacci del numero ingresado
    MOV AL, numeroN
    CALL CALCULAR_FIBONACCI
    
    ; mostramos el resultado
    LEA DX, msgResultado
    MOV AH, 09h
    INT 21h
    
    MOV AX, resultado
    CALL IMPRIMIR_NUMERO
    
    ; preguntamos si quiere calcular otro
    LEA DX, msgOtraVez
    MOV AH, 09h
    INT 21h
    
    ; leemos la respuesta
    MOV AH, 01h
    INT 21h
    
    ; verificamos si quiere continuar
    CMP AL, 'S'
    JE INICIO
    CMP AL, 's'
    JE INICIO
    
    ; si no quiere continuar, terminamos el programa
    JMP SALIR

ERROR_RANGO:
    ; mostramos mensaje de error
    LEA DX, msgError
    MOV AH, 09h
    INT 21h
    JMP INICIO                  ; volvemos a pedir el numero

SALIR:
    ; terminamos el programa y regresamos al DOS
    MOV AH, 4Ch
    INT 21h

MAIN ENDP

; Procedimiento: LEER_NUMERO
; Descripcion: Lee un numero de hasta 2 digitos ingresado por el usuario
;              y lo convierte a valor numerico
; Entrada: Ninguna
; Salida: numeroN contiene el valor leido
LEER_NUMERO PROC
    PUSH AX
    PUSH BX
    PUSH CX
    
    MOV BX, 0                   ; inicializamos el acumulador en 0
    MOV CX, 0                   ; contador de digitos

LEER_DIGITO:
    ; leemos un caracter
    MOV AH, 01h
    INT 21h
    
    ; verificamos si es Enter (fin de entrada)
    CMP AL, 13
    JE FIN_LECTURA
    
    ; verificamos que sea un digito valido (0-9)
    CMP AL, '0'
    JB LEER_DIGITO              ; si es menor que '0', ignoramos
    CMP AL, '9'
    JA LEER_DIGITO              ; si es mayor que '9', ignoramos
    
    ; convertimos el caracter a numero
    SUB AL, '0'                 ; restamos el codigo ASCII de '0'
    
    ; multiplicamos el acumulador por 10 y sumamos el nuevo digito
    MOV temp, AX                ; guardamos el digito temporalmente
    MOV AX, BX
    MOV BX, 10
    MUL BX                      ; AX = AX * 10
    MOV BX, AX
    ADD BX, temp                ; BX = BX + digito
    
    INC CX                      ; incrementamos contador de digitos
    CMP CX, 2                   ; maximo 2 digitos
    JL LEER_DIGITO

FIN_LECTURA:
    MOV numeroN, BL             ; guardamos el resultado
    
    POP CX
    POP BX
    POP AX
    RET
LEER_NUMERO ENDP

; Procedimiento: CALCULAR_FIBONACCI
; Descripcion: Calcula el n-esimo numero de Fibonacci usando iteracion
;              Fib(0) = 0, Fib(1) = 1
;              Fib(n) = Fib(n-1) + Fib(n-2) para n >= 2
; Entrada: AL = valor de n
; Salida: resultado contiene el numero de Fibonacci
CALCULAR_FIBONACCI PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    ; casos base: si n = 0 o n = 1
    CMP AL, 0
    JE CASO_CERO
    CMP AL, 1
    JE CASO_UNO
    
    ; para n >= 2, usamos metodo iterativo
    MOV CL, AL                  ; CL = n (contador)
    MOV BX, 0                   ; BX = Fib(0) = 0
    MOV DX, 1                   ; DX = Fib(1) = 1
    MOV CX, 0
    MOV CL, AL
    SUB CL, 1                   ; restamos 1 porque ya tenemos Fib(1)

BUCLE_FIB:
    ; calculamos Fib(i) = Fib(i-1) + Fib(i-2)
    MOV AX, BX                  ; AX = Fib(i-2)
    ADD AX, DX                  ; AX = Fib(i-2) + Fib(i-1)
    MOV BX, DX                  ; actualizamos Fib(i-2) = Fib(i-1)
    MOV DX, AX                  ; actualizamos Fib(i-1) = Fib(i)
    
    LOOP BUCLE_FIB              ; repetimos n-1 veces
    
    MOV resultado, AX           ; guardamos el resultado final
    JMP FIN_FIBONACCI

CASO_CERO:
    MOV resultado, 0
    JMP FIN_FIBONACCI

CASO_UNO:
    MOV resultado, 1

FIN_FIBONACCI:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
CALCULAR_FIBONACCI ENDP

; Procedimiento: IMPRIMIR_NUMERO
; Descripcion: Convierte un numero binario a decimal y lo imprime en pantalla
; Entrada: AX = numero a imprimir
; Salida: Muestra el numero en pantalla
IMPRIMIR_NUMERO PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    ; inicializamos el buffer
    MOV CX, 0                   ; contador de digitos
    MOV BX, 10                  ; divisor

    ; caso especial: si el numero es 0
    CMP AX, 0
    JNE CONVERTIR_LOOP
    MOV DL, '0'
    MOV AH, 02h
    INT 21h
    JMP FIN_IMPRIMIR

CONVERTIR_LOOP:
    ; dividimos el numero entre 10 repetidamente
    CMP AX, 0
    JE IMPRIMIR_DIGITOS         ; cuando llegamos a 0, imprimimos
    
    MOV DX, 0                   ; preparamos para la division
    DIV BX                      ; AX = AX / 10, DX = residuo
    
    PUSH DX                     ; guardamos el digito en la pila
    INC CX                      ; incrementamos contador
    
    JMP CONVERTIR_LOOP

IMPRIMIR_DIGITOS:
    ; sacamos los digitos de la pila y los imprimimos
    CMP CX, 0
    JE FIN_IMPRIMIR
    
    POP DX                      ; recuperamos el digito
    ADD DL, '0'                 ; convertimos a ASCII
    MOV AH, 02h                 ; funcion para imprimir caracter
    INT 21h
    
    DEC CX                      ; decrementamos contador
    JMP IMPRIMIR_DIGITOS

FIN_IMPRIMIR:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
IMPRIMIR_NUMERO ENDP

END MAIN
