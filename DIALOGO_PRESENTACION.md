# Diálogo de Presentación - Calculadora de Fibonacci en Ensamblador 8086

## Presentación del Equipo

**Estudiante 1**: Buenos días profesor, somos el equipo [nombre del equipo] y presentaremos nuestra Calculadora de Fibonacci desarrollada en lenguaje ensamblador para el procesador Intel 8086.

**Profesor**: Excelente, adelante. Cuéntenme sobre la arquitectura y el enfoque que utilizaron.

**Estudiante 2**: Con gusto profesor. Nuestro programa implementa un algoritmo iterativo eficiente que calcula la secuencia de Fibonacci para valores de n entre 0 y 24, con validación de entrada, manejo de errores y una interfaz interactiva para el usuario.

**Profesor**: Interesante. Explíquenme la estructura técnica del programa.

---

## Parte 1: Arquitectura y Modelo de Memoria

**Estudiante 3**: Profesor, comenzamos con las directivas fundamentales del ensamblador:

```assembly
.MODEL SMALL
.STACK 100h
```

**Estudiante 1**: `.MODEL SMALL` define el modelo de memoria que utilizaremos. Este modelo es óptimo para programas pequeños, asignando:

- **64 KB para el segmento de código (.CODE)**
- **64 KB para el segmento de datos (.DATA)**
- **Punteros cercanos (near pointers)** de 16 bits

**Profesor**: ¿Y por qué eligieron específicamente el modelo SMALL?

**Estudiante 2**: Por tres razones técnicas:

1. Nuestro programa es pequeño (aproximadamente 250 líneas)
2. Los datos que manejamos son mínimos (mensajes y variables pequeñas)
3. Los punteros near de 16 bits son más eficientes que los far pointers de 32 bits del modelo LARGE

**Estudiante 3**: La directiva `.STACK 100h` reserva 256 bytes (100h en hexadecimal) para la pila. Esto es suficiente porque:

- No usamos recursión (que consumiría mucha pila)
- Nuestras llamadas a procedimientos son simples y poco profundas
- Cada PUSH guarda 2 bytes, y nuestro máximo de PUSHes anidados es bajo

**Profesor**: Bien fundamentado. ¿Y qué contiene la sección de datos?

---

## Parte 2: Segmento de Datos y Gestión de Memoria

**Estudiante 1**: En la sección `.DATA` definimos estratégicamente nuestras estructuras de datos:

```assembly
.DATA
    msgBienvenida   DB 13,10,'==== CALCULADORA DE FIBONACCI ====',13,10,'$'
    msgPedir        DB 13,10,'Ingrese el valor de n (0-24): $'
    msgResultado    DB 13,10,'El numero Fibonacci es: $'
    msgError        DB 13,10,'Error! El valor debe estar entre 0 y 24',13,10,'$'
    msgOtraVez      DB 13,10,13,10,'Desea calcular otro? (S/N): $'

    numeroN         DB ?
    resultado       DW ?
    buffer          DB 6 DUP('$')
    temp            DW ?
```

**Estudiante 2**: Permítame explicar cada tipo de dato:

### DB (Define Byte) - 8 bits:

**Estudiante 3**: `numeroN DB ?` es un byte sin inicializar. Elegimos 8 bits porque:

- El rango es 0-24, que cabe perfectamente en un byte (0-255)
- Ocupa menos memoria que una palabra (DW)
- Las operaciones con bytes son más rápidas

Los mensajes también usan DB. Los códigos **13,10** son:

- **13 (0Dh)**: Carriage Return (CR) - mueve el cursor al inicio de la línea
- **10 (0Ah)**: Line Feed (LF) - mueve el cursor a la siguiente línea
- **'$'**: Terminador de cadena para la interrupción INT 21h, función 09h

**Profesor**: Interesante. ¿Y el DW?

### DW (Define Word) - 16 bits:

**Estudiante 1**: `resultado DW ?` es una palabra de 16 bits porque:

- Fibonacci(24) = **46,368**, que requiere 16 bits
- Un byte solo almacena hasta 255 (8 bits)
- 16 bits nos dan rango de 0 a 65,535

Analicemos el crecimiento:

```
Fib(7)  = 13     → cabe en 8 bits (< 255)
Fib(12) = 144    → necesita 8 bits
Fib(13) = 233    → necesita 8 bits
Fib(14) = 377    → NECESITA 16 bits (> 255)
Fib(24) = 46,368 → necesita 16 bits
```

### DUP (Duplicar):

**Estudiante 2**: `buffer DB 6 DUP('$')` crea un array de 6 bytes, todos inicializados con '$':

```
buffer[0] = '$'
buffer[1] = '$'
buffer[2] = '$'
buffer[3] = '$'
buffer[4] = '$'
buffer[5] = '$'
```

¿Por qué 6? Porque el número más grande (46,368) tiene 5 dígitos + 1 terminador '$'.

**Profesor**: Excelente análisis. Ahora explíquenme el flujo principal del programa.

---

## Parte 3: Procedimiento Principal (MAIN)

**Estudiante 1**: El procedimiento MAIN es como el main() de C. Aquí empieza todo.

```assembly
MOV AX, @DATA
MOV DS, AX
```

**Estudiante 3**: Estas dos instrucciones inicializan el segmento de datos. `@DATA` es la dirección del segmento de datos y la movemos a DS.

**Estudiante 2**: Luego tenemos un ciclo con la etiqueta `INICIO:` que permite al usuario calcular varios números de fibonacci sin salir del programa.

**Profesor**: ¿Cómo validan el rango de entrada?

**Estudiante 1**: Usamos la instrucción `CMP numeroN, 24` que compara el valor ingresado con 24, y luego `JA ERROR_RANGO` que salta si es mayor.

**Estudiante 3**: JA significa "Jump if Above" (saltar si es mayor), es perfecta para comparaciones sin signo.

---

## Parte 4: Lectura de Número (LEER_NUMERO)

**Estudiante 2**: Este procedimiento lee el número que el usuario escribe, dígito por dígito.

**Estudiante 1**: Primero guardamos los registros con PUSH para no perder información:

```assembly
PUSH AX
PUSH BX
PUSH CX
```

**Estudiante 3**: Usamos la interrupción `INT 21h` con `AH = 01h` para leer un caracter del teclado.

**Profesor**: ¿Y cómo convierten el caracter a número?

**Estudiante 2**: Cuando leemos un caracter, viene en código ASCII. Si escriben '5', el valor ASCII es 53. Entonces restamos '0' (que es 48 en ASCII):

```assembly
SUB AL, '0'    ; 53 - 48 = 5
```

**Estudiante 1**: Luego multiplicamos el acumulador por 10 y sumamos el nuevo dígito. Por ejemplo, si escriben "15", primero leemos '1' (valor 1), luego '5'. Hacemos: 1 × 10 + 5 = 15.

---

## Parte 5: Cálculo de Fibonacci (CALCULAR_FIBONACCI)

**Estudiante 3**: Esta es la parte más importante. Decidimos usar un método iterativo en vez de recursivo.

**Profesor**: ¿Por qué iterativo?

**Estudiante 2**: La recursión en ensamblador consume mucha pila y es más lenta. Con iteración es más eficiente.

**Estudiante 1**: Primero manejamos los casos base:

```assembly
CMP AL, 0
JE CASO_CERO    ; Si n=0, retornamos 0
CMP AL, 1
JE CASO_UNO     ; Si n=1, retornamos 1
```

**Estudiante 3**: Para n >= 2, usamos un bucle. Inicializamos:

- BX = 0 (Fibonacci anterior anterior)
- DX = 1 (Fibonacci anterior)
- CL = n-1 (contador)

**Estudiante 2**: En cada iteración calculamos:

```assembly
MOV AX, BX      ; AX = Fib(i-2)
ADD AX, DX      ; AX = Fib(i-2) + Fib(i-1)
MOV BX, DX      ; actualizamos valores
MOV DX, AX
```

**Estudiante 1**: Y repetimos con `LOOP BUCLE_FIB` que decrementa CX automáticamente y salta si CX no es cero.

---

## Parte 6: Impresión del Resultado (IMPRIMIR_NUMERO)

**Estudiante 3**: Para imprimir el número, tenemos que convertirlo de binario a decimal.

**Estudiante 2**: Dividimos el número entre 10 repetidamente:

```assembly
DIV BX    ; AX = AX / 10, DX = residuo
```

**Estudiante 1**: Los residuos son los dígitos, pero en orden inverso. Por eso los guardamos en la pila con PUSH.

**Profesor**: ¿Y luego?

**Estudiante 3**: Sacamos los dígitos de la pila con POP, les sumamos '0' para convertirlos a ASCII, y los imprimimos con `INT 21h` (AH=02h).

**Estudiante 2**: La pila funciona como LIFO (Last In, First Out), así que los dígitos salen en el orden correcto.

---

## Parte 7: Proceso de Construcción

**Estudiante 1**: Al construir el programa, primero investigamos sobre las interrupciones de DOS.

**Estudiante 3**: Encontramos que `INT 21h` tiene muchas funciones:

- **AH=01h**: Lee un caracter
- **AH=02h**: Imprime un caracter
- **AH=09h**: Imprime una cadena terminada en '$'
- **AH=4Ch**: Termina el programa

**Estudiante 2**: También tuvimos que entender las instrucciones de comparación y salto:

- **CMP**: Compara dos valores
- **JE**: Salta si son iguales (Jump if Equal)
- **JA**: Salta si es mayor (Jump if Above)
- **JL**: Salta si es menor (Jump if Less)

**Estudiante 1**: Una cosa que nos costó fue manejar la conversión de números. Al principio intentamos leer todo de golpe, pero no funcionaba bien.

**Estudiante 3**: Entonces decidimos leer dígito por dígito y hacer la conversión manual con multiplicaciones por 10.

---

## Parte 8: Instrucciones Importantes Usadas

**Estudiante 2**: Déjeme explicar algunas instrucciones clave que usamos:

### MOV (Move)

**Estudiante 1**: Copia datos de un lugar a otro. Por ejemplo:

```assembly
MOV AX, 5    ; Mueve el valor 5 al registro AX
MOV BX, AX   ; Copia el valor de AX a BX
```

### ADD y SUB

**Estudiante 3**: ADD suma, SUB resta:

```assembly
ADD AX, BX   ; AX = AX + BX
SUB AL, '0'  ; AL = AL - 48
```

### MUL y DIV

**Estudiante 2**: MUL multiplica (sin signo), DIV divide:

```assembly
MUL BX       ; AX = AX * BX
DIV BX       ; AX = AX / BX, DX = residuo
```

### PUSH y POP

**Estudiante 1**: Guardan y recuperan valores de la pila:

```assembly
PUSH AX      ; guarda AX en la pila
POP AX       ; recupera AX de la pila
```

### LOOP

**Estudiante 3**: Decrementa CX y salta si CX != 0:

```assembly
LOOP etiqueta   ; CX--, si CX != 0 salta
```

### LEA (Load Effective Address)

**Estudiante 2**: Carga la dirección de una variable:

```assembly
LEA DX, mensaje   ; DX apunta al mensaje
```

### INT (Interrupt)

**Estudiante 1**: Llama a servicios del sistema operativo:

```assembly
INT 21h      ; Interrupción de DOS
```

---

## Parte 9: Dificultades y Soluciones

**Estudiante 3**: Al principio el programa no validaba bien los números mayores a 24.

**Estudiante 2**: El problema era que leíamos hasta 3 dígitos. Lo solucionamos limitando a 2 dígitos máximo.

**Estudiante 1**: También tuvimos un bug al imprimir el número 0. No entraba al bucle y no imprimía nada.

**Estudiante 3**: Lo arreglamos agregando un caso especial:

```assembly
CMP AX, 0
JNE CONVERTIR_LOOP
MOV DL, '0'
INT 21h
```

---

## Parte 10: Compilación y Pruebas

**Estudiante 2**: Para compilar usamos Turbo Assembler:

```
tasm fibonacci.asm
tlink fibonacci.obj
```

**Estudiante 1**: Lo probamos con todos los valores del 0 al 24 y comparamos con una tabla de Fibonacci que encontramos.

**Estudiante 3**: También probamos valores fuera de rango para verificar que mostrara el error correctamente.

---

## Conclusión

**Estudiante 1**: En resumen, nuestro programa cumple con todos los requisitos: calcula Fibonacci de 0 a 24, valida la entrada, y tiene una interfaz amigable.

**Estudiante 2**: Aprendimos mucho sobre manejo de memoria, conversión de datos, y interrupciones del sistema.

**Estudiante 3**: Y entendimos mejor cómo funciona la computadora a bajo nivel, sin abstracciones de lenguajes de alto nivel.

**Profesor**: Excelente trabajo. Se nota que entendieron bien el código.

---

## Preguntas Frecuentes del Profesor

### P1: ¿Por qué usan el registro AL para pasar n a CALCULAR_FIBONACCI?

**R**: Porque n es un valor pequeño (0-24) que cabe en 8 bits. AL es perfecto para esto y es más eficiente que usar AX completo.

### P2: ¿Qué pasaría si n fuera mayor a 24?

**R**: El programa muestra un mensaje de error y pide otro número. Pero si lo calculáramos, Fib(25) = 75025, que todavía cabe en 16 bits. El límite real es Fib(46) antes de desbordar 16 bits.

### P3: ¿Por qué guardan registros con PUSH al inicio de cada procedimiento?

**R**: Para preservar el estado de los registros. Si no lo hacemos, podríamos sobrescribir valores que el procedimiento llamador necesita.

### P4: ¿Pueden explicar cómo funciona LOOP exactamente?

**R**: LOOP hace dos cosas: decrementa CX en 1, y si CX no es cero, salta a la etiqueta indicada. Es como un "for" en C pero más compacto.

### P5: ¿Por qué usan '$' para terminar las cadenas?

**R**: Es la convención de DOS. La interrupción INT 21h con AH=09h imprime caracteres hasta encontrar un '$'.
