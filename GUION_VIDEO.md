# GUION TÉCNICO PARA VIDEO - Calculadora de Fibonacci en Ensamblador 8086

---

## ESCENA 1: INTRODUCCIÓN PROFESIONAL

**[PANTALLA: Título profesional con logo del procesador 8086]**

**NARRADOR**:
Bienvenidos a esta presentación técnica sobre implementación de algoritmos en lenguaje ensamblador para el procesador Intel 8086.

Hoy analizaremos en profundidad una **Calculadora de Fibonacci** que implementa:

- Algoritmo iterativo optimizado
- Validación robusta de entrada
- Conversión ASCII ↔ Binario
- Gestión eficiente de memoria y registros
- Manejo de interrupciones DOS (INT 21h)

**[PANTALLA: Animación de la secuencia de Fibonacci con fórmula matemática]**

La secuencia de Fibonacci se define matemáticamente como:

```
F(0) = 0
F(1) = 1
F(n) = F(n-1) + F(n-2)  para n ≥ 2
```

Resultando en: **0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89...**

**[GRÁFICO: Crecimiento exponencial de Fibonacci]**

Esta secuencia tiene una tasa de crecimiento exponencial aproximada de **φ^n / √5**,
donde φ (phi) es el número áureo ≈ 1.618.

---

## ESCENA 2: DEMOSTRACIÓN TÉCNICA DEL PROGRAMA

**[PANTALLA: DOSBox con el programa ejecutándose]**

**NARRADOR**:
Antes de analizar el código, observemos el comportamiento del programa en ejecución...

**[EJECUTAR: Caso exitoso]**

```
==== CALCULADORA DE FIBONACCI ====
Ingrese el valor de n (0-24): 10
```

El programa utiliza **INT 21h con AH=01h** para capturar cada tecla presionada.
Los caracteres '1' y '0' (ASCII 49 y 48) se convierten a valor numérico 10.

**[PANTALLA: Mostrando conversión ASCII en tiempo real]**

```
'1' (ASCII 49) - '0' (ASCII 48) = 1
Acumulador: 1 * 10 = 10
'0' (ASCII 48) - '0' (ASCII 48) = 0
Resultado final: 10 + 0 = 10
```

**[RESULTADO EN PANTALLA]**

```
El numero Fibonacci es: 55
```

El algoritmo iterativo ejecuta **9 iteraciones** para calcular F(10):

```
Iteración 1: 0 + 1 = 1
Iteración 2: 1 + 1 = 2
Iteración 3: 1 + 2 = 3
Iteración 4: 2 + 3 = 5
Iteración 5: 3 + 5 = 8
Iteración 6: 5 + 8 = 13
Iteración 7: 8 + 13 = 21
Iteración 8: 13 + 21 = 34
Iteración 9: 21 + 34 = 55  ✓
```

**Complejidad temporal: O(n)**
**Complejidad espacial: O(1)** - solo usa registros, sin arrays

**[EJECUTAR: Caso de error]**

```
Ingrese el valor de n (0-24): 30
Error! El valor debe estar entre 0 y 24
```

La validación usa **CMP (Compare)** seguido de **JA (Jump if Above)**:

```assembly
CMP numeroN, 24    ; Compara con 24
JA ERROR_RANGO     ; Salta si > 24 (unsigned)
```

Esta instrucción establece las banderas del procesador:

- **ZF (Zero Flag)**: 1 si son iguales
- **CF (Carry Flag)**: 1 si numeroN < 24
- **SF (Sign Flag)**: estado del bit de signo

**JA** verifica que **CF=0 AND ZF=0** (mayor que, sin signo).

---

## ESCENA 3: ARQUITECTURA DEL PROCESADOR 8086

**[PANTALLA: Diagrama técnico del 8086]**

**NARRADOR**:
El Intel 8086 es un procesador de **16 bits** con arquitectura de memoria segmentada.

**[ANIMACIÓN: Estructura de registros]**

### Registros de Propósito General (16 bits):

```
AX (Accumulator):    AH | AL  - Aritmética y operaciones E/S
BX (Base):           BH | BL  - Direccionamiento base
CX (Counter):        CH | CL  - Contador de bucles
DX (Data):           DH | DL  - Multiplicación/División extendida
```

Cada registro puede dividirse en **High** (H) y **Low** (L) de 8 bits.

### Registros de Segmento (16 bits):

```
CS (Code Segment)    - Apunta al segmento de código
DS (Data Segment)    - Apunta al segmento de datos
SS (Stack Segment)   - Apunta al segmento de pila
ES (Extra Segment)   - Segmento adicional
```

### Registros de Puntero e Índice:

````
SP (Stack Pointer)   - Puntero al tope de la pila
BP (Base Pointer)    - Puntero base para marco de pila
SI (Source Index)    - Índice fuente para operaciones de cadena
DI (Dest Index)      - Índice destino para operaciones de cadena
IP (Instr Pointer)   - Puntero de instrucción (PC)

---

## ESCENA 4: PROCEDIMIENTO PRINCIPAL (MAIN)
**[PANTALLA: Procedimiento MAIN]**

**NARRADOR**:
El procedimiento MAIN es como el corazón del programa, aquí empieza todo...

**[HIGHLIGHT]**
```assembly
MOV AX, @DATA
MOV DS, AX
````

Estas dos lineas inicializan el segmento de datos. Es como decirle al procesador "oye, los datos están aquí".

Luego viene un ciclo que permite calcular varios números sin salir del programa...

**[HIGHLIGHT]**

```assembly
INICIO:
    LEA DX, msgBienvenida
    MOV AH, 09h
    INT 21h
```

`LEA` carga la dirección del mensaje, `MOV AH, 09h` prepara la función para imprimir, y `INT 21h` llama al sistema operativo DOS.

**[ANIMACIÓN: Flujo del programa]**

El flujo es así: mostramos el mensaje, leemos el número, validamos que esté en rango, calculamos Fibonacci, mostramos el resultado, y preguntamos si quiere continuar.

---

## ESCENA 5: LECTURA DE NÚMEROS

**[PANTALLA: Procedimiento LEER_NUMERO]**

**NARRADOR**:
Ahora lo interesante... ¿cómo leemos un número del teclado?

Bueno, en ensamblador no hay un "scanf" como en C. Tenemos que leer caracter por caracter.

**[HIGHLIGHT]**

```assembly
MOV AH, 01h
INT 21h
```

Esta interrupción lee UN caracter del teclado. Si el usuario escribe "15", primero leemos '1', luego '5'.

Pero esos caracteres vienen en ASCII. El caracter '5' es el número 53 en ASCII, no el número 5.

**[PANTALLA: Tabla ASCII mostrando '0'=48, '1'=49... '9'=57]**

Entonces hacemos esta conversión...

**[HIGHLIGHT]**

```assembly
SUB AL, '0'    ; convertimos ASCII a numero
```

Si restamos el ASCII de '0' (que es 48), obtenemos el valor numérico real. Por ejemplo: 53 - 48 = 5.

**[ANIMACIÓN: Mostrando 1 * 10 + 5 = 15]**

Para formar números de dos digitos, multiplicamos el primer dígito por 10 y sumamos el segundo. Así '15' se convierte en 15.

---

## ESCENA 6: VALIDACIÓN DE ENTRADA

**[PANTALLA: Código de validación]**

**NARRADOR**:
Una vez que tenemos el número, hay que validar que esté entre 0 y 24...

**[HIGHLIGHT]**

```assembly
CMP numeroN, 24
JA ERROR_RANGO
```

`CMP` compara numeroN con 24. Es como una resta pero sin guardar el resultado, solo afecta las banderas del procesador.

Y `JA` significa "Jump if Above", es decir, salta si es mayor. Si el usuario pone 30, salta al error.

**[PANTALLA: Mensaje de error en ejecución]**

Y ahí mostramos el mensaje de error y volvemos a pedir el número.

---

## ESCENA 7: ALGORITMO DE FIBONACCI - CASOS BASE

**[PANTALLA: Procedimiento CALCULAR_FIBONACCI]**

**NARRADOR**:
Aquí está la magia del programa. Primero manejamos los casos especiales...

**[HIGHLIGHT]**

```assembly
CMP AL, 0
JE CASO_CERO
CMP AL, 1
JE CASO_UNO
```

Si n es 0, Fibonacci(0) = 0. Si n es 1, Fibonacci(1) = 1. Estos son los casos base.

**[ANIMACIÓN: Mostrando Fib(0)=0, Fib(1)=1]**

Pero si n es 2 o mayor, ahí viene lo interesante...

---

## ESCENA 8: ALGORITMO ITERATIVO

**[PANTALLA: Código del bucle]**

**NARRADOR**:
Decidí usar un algoritmo iterativo en lugar de recursión. ¿Por qué?

Porque la recursión en ensamblador es compleja y consume mucha pila. El método iterativo es más rápido y eficiente.

**[ANIMACIÓN: Calculando Fib(5) paso a paso]**

Imaginen que queremos Fibonacci(5). Empezamos con dos variables:

**[TEXTO EN PANTALLA]**

```
BX = 0  (Fibonacci anterior-anterior)
DX = 1  (Fibonacci anterior)
```

En cada iteración hacemos esto...

**[HIGHLIGHT EN CÓDIGO]**

```assembly
MOV AX, BX      ; AX = Fib(i-2)
ADD AX, DX      ; AX = Fib(i-2) + Fib(i-1)
MOV BX, DX      ; actualizamos valores
MOV DX, AX      ; el nuevo resultado
```

**[ANIMACIÓN: Mostrando cada paso]**

```
Iteración 1: AX = 0 + 1 = 1  →  BX=1, DX=1
Iteración 2: AX = 1 + 1 = 2  →  BX=1, DX=2
Iteración 3: AX = 1 + 2 = 3  →  BX=2, DX=3
Iteración 4: AX = 2 + 3 = 5  →  BX=3, DX=5
```

Y al final, AX tiene el resultado: Fibonacci(5) = 5.

La instrucción `LOOP` es clave aquí...

**[HIGHLIGHT]**

```assembly
LOOP BUCLE_FIB
```

`LOOP` hace dos cosas automáticamente: resta 1 a CX, y si CX no es cero, salta de vuelta al bucle. Es super conveniente.

---

## ESCENA 9: CONVERTIR NÚMERO A TEXTO

**[PANTALLA: Procedimiento IMPRIMIR_NUMERO]**

**NARRADOR**:
Ahora tenemos el resultado en AX, pero está en binario. ¿Cómo lo mostramos en pantalla?

Tenemos que convertirlo a caracteres ASCII, dígito por dígito.

**[ANIMACIÓN: Convirtiendo 55 a '5' y '5']**

La estrategia es dividir el número entre 10 repetidamente...

**[HIGHLIGHT]**

```assembly
DIV BX    ; AX = AX / 10, DX = residuo
```

Por ejemplo, 55 ÷ 10 = 5 con residuo 5. El residuo es el último dígito.

Seguimos dividiendo: 5 ÷ 10 = 0 con residuo 5. Y ese es el primer dígito.

**[PANTALLA: Mostrando la pila]**

Pero hay un problema... los dígitos salen al revés. Primero obtenemos el 5 del final, luego el 5 del inicio.

Por eso usamos la pila. Guardamos cada dígito con `PUSH`...

**[ANIMACIÓN: Empujando valores a la pila]**

```
PUSH 5  (último dígito)
PUSH 5  (primer dígito)
```

Y luego los sacamos con `POP`. Como la pila es LIFO (Last In, First Out), salen en el orden correcto.

**[HIGHLIGHT]**

```assembly
POP DX          ; recuperamos el digito
ADD DL, '0'     ; convertimos a ASCII
MOV AH, 02h
INT 21h         ; imprimimos
```

Le sumamos '0' (48 en ASCII) para convertir 5 a '5' (53 en ASCII), y lo imprimimos.

---

## ESCENA 10: INTERRUPCIONES DE DOS

**[PANTALLA: Tabla de interrupciones]**

**NARRADOR**:
Hablemos un momento de las interrupciones. Son como llamadas al sistema operativo.

`INT 21h` es la interrupción principal de DOS, y tiene muchas funciones según el valor de AH...

**[TEXTO EN PANTALLA]**

```
AH = 01h  →  Lee un caracter del teclado
AH = 02h  →  Imprime un caracter en pantalla
AH = 09h  →  Imprime una cadena terminada en '$'
AH = 4Ch  →  Termina el programa
```

Estas son las que más uso en el programa.

---

## ESCENA 11: LA PILA (PUSH y POP)

**[PANTALLA: Diagrama de la pila]**

**NARRADOR**:
La pila es una estructura de datos muy importante en ensamblador.

**[ANIMACIÓN: Stack creciendo y decreciendo]**

Funciona como una pila de platos. El último que entra es el primero que sale.

Al inicio de cada procedimiento hago esto...

**[HIGHLIGHT]**

```assembly
PUSH AX
PUSH BX
PUSH CX
```

Guardo los registros que voy a usar, para no afectar al código que me llamó.

Y al final del procedimiento...

**[HIGHLIGHT]**

```assembly
POP CX
POP BX
POP AX
```

Los restauro en orden inverso. Muy importante: siempre en orden inverso.

---

## ESCENA 12: REGISTROS DEL 8086

**[PANTALLA: Diagrama del procesador]**

**NARRADOR**:
Ahora hablemos de los registros. El 8086 tiene varios registros de 16 bits...

**[ANIMACIÓN: Mostrando AX, BX, CX, DX]**

**AX** es el acumulador, se usa para operaciones aritméticas y para retornar valores.

**BX** es base, lo uso como acumulador secundario en el algoritmo.

**CX** es el contador, perfecto para bucles. La instrucción `LOOP` lo usa automáticamente.

**DX** es data, lo uso para direcciones en interrupciones y para guardar residuos en divisiones.

**[ANIMACIÓN: Mostrando AH y AL dentro de AX]**

Cada registro de 16 bits se puede dividir en dos de 8 bits. AX = AH (high) + AL (low).

---

## ESCENA 13: INSTRUCCIONES CLAVE

**[PANTALLA: Listado de instrucciones]**

**NARRADOR**:
Veamos las instrucciones más importantes que uso...

### MOV

`MOV destino, origen` copia datos de un lugar a otro.

**[EJEMPLO EN PANTALLA]**

```assembly
MOV AX, 5     ; AX ahora vale 5
MOV BX, AX    ; BX copia el valor de AX
```

### ADD y SUB

`ADD` suma, `SUB` resta. El resultado va al primer operando.

**[EJEMPLO]**

```assembly
ADD AX, BX    ; AX = AX + BX
SUB AL, '0'   ; AL = AL - 48
```

### MUL y DIV

`MUL` multiplica valores sin signo.

**[EJEMPLO]**

```assembly
MOV AX, 10
MOV BX, 5
MUL BX        ; AX = 10 * 5 = 50
```

`DIV` divide. El cociente va a AX, el residuo a DX.

**[EJEMPLO]**

```assembly
MOV AX, 55
MOV BX, 10
DIV BX        ; AX = 5, DX = 5
```

### CMP y saltos

`CMP` compara dos valores sin modificarlos, solo afecta las banderas.

**[EJEMPLO]**

```assembly
CMP AL, 24
JA ERROR      ; salta si AL > 24
JE IGUAL      ; salta si AL = 24
JL MENOR      ; salta si AL < 24
```

### LEA

`LEA` carga la dirección de una variable, no su valor.

**[EJEMPLO]**

```assembly
LEA DX, mensaje    ; DX apunta al mensaje
```

---

## ESCENA 14: PROCESO DE CONSTRUCCIÓN

**[PANTALLA: Mostrando notas y bocetos]**

**NARRADOR**:
Ahora les cuento cómo construí este programa...

Primero investigué la teoría de Fibonacci y vi varios algoritmos.

Decidí usar iteración porque es más eficiente que recursión en ensamblador.

**[PANTALLA: Diagrama de flujo]**

Hice un diagrama de flujo para visualizar la lógica del programa.

Luego investigué las interrupciones de DOS y cómo leer y escribir en pantalla.

Un problema que tuve fue la conversión de texto a número. Al principio no funcionaba bien.

**[PANTALLA: Código con bug]**

Olvidé multiplicar por 10 antes de sumar el siguiente dígito, entonces "15" se convertía en 6 en lugar de 15.

También batallé con el manejo de la pila. Al principio no restauraba los registros en orden inverso y el programa crasheaba.

Después de varios dias de prueba y error, finalmente funcionó perfecto.

---

## ESCENA 15: PRUEBAS Y VALIDACIÓN

**[PANTALLA: Ejecutando múltiples pruebas]**

**NARRADOR**:
Una vez terminado, hice pruebas exhaustivas...

**[MONTAJE DE PRUEBAS]**

```
n=0  → 0  ✓
n=1  → 1  ✓
n=5  → 5  ✓
n=10 → 55 ✓
n=24 → 46368 ✓
```

También probé casos límite: n=25 (debe dar error), n=0 (caso especial), números negativos...

Comparé todos los resultados con una tabla de Fibonacci para verificar que fueran correctos.

---

## ESCENA 16: COMPILACIÓN

**[PANTALLA: Terminal con comandos]**

**NARRADOR**:
Para compilar el programa uso Turbo Assembler...

**[ESCRIBIENDO EN TERMINAL]**

```
tasm fibonacci.asm
```

Esto genera el archivo objeto fibonacci.obj

**[ESCRIBIENDO]**

```
tlink fibonacci.obj
```

Y esto genera el ejecutable fibonacci.exe

**[EJECUTANDO]**

```
fibonacci.exe
```

Y listo, el programa corre perfectamente.

---

## ESCENA 17: ¿POR QUÉ HASTA 24?

**[PANTALLA: Tabla de límites]**

**NARRADOR**:
Una pregunta común: ¿por qué el límite es 24?

Porque uso registros de 16 bits que pueden guardar valores hasta 65535.

**[TEXTO EN PANTALLA]**

```
Fib(24) = 46368  ✓ cabe en 16 bits
Fib(25) = 75025  ✓ cabe en 16 bits
Fib(26) = 121393 ✗ NO cabe en 16 bits
```

Técnicamente podría llegar hasta Fibonacci(25), pero el enunciado del proyecto pedía hasta 24.

Si quisiera calcular números más grandes, necesitaría usar aritmética de 32 bits o más.

---

## ESCENA 18: VENTAJAS DEL MÉTODO ITERATIVO

**[PANTALLA: Comparación iterativo vs recursivo]**

**NARRADOR**:
Comparemos el método iterativo con la recursión...

**[ANIMACIÓN: Árbol de recursión vs ciclo]**

La recursión es elegante pero ineficiente. Para Fibonacci(5) hace 15 llamadas recursivas.

El método iterativo solo hace 4 iteraciones. Mucho más rápido.

**[GRÁFICA: Comparación de rendimiento]**

Y además la recursión usa mucha pila, que en ensamblador es limitada.

---

## ESCENA 19: LO QUE APRENDÍ

**[PANTALLA: Resumen visual]**

**NARRADOR**:
Este proyecto me enseñó muchas cosas...

Entendí cómo funciona la memoria a bajo nivel: segmentos, pila, registros...

Aprendí a trabajar con interrupciones del sistema operativo.

Comprendí mejor las conversiones entre ASCII y valores numéricos.

Y sobre todo, aprecié lo fácil que son los lenguajes de alto nivel comparados con ensamblador.

**[RISA]**

¡Definitivamente! Un simple printf() en C es como 20 líneas en ensamblador.

---

## ESCENA 20: CARACTERÍSTICAS FINALES

**[PANTALLA: Lista de features]**

**NARRADOR**:
El programa tiene varias características importantes...

**[CHECKMARKS APARECIENDO]**

```
✓ Valida el rango de entrada (0-24)
✓ Maneja errores gracefully
✓ Interfaz amigable con mensajes claros
✓ Permite calcular varios números sin reiniciar
✓ Algoritmo eficiente (iterativo)
✓ Código bien comentado
✓ Modular con procedimientos separados
```

Cada procedimiento tiene una responsabilidad clara: leer, calcular, imprimir...

Esto hace que el código sea más fácil de entender y mantener.

---

## ESCENA 21: POSIBLES MEJORAS

**[PANTALLA: Ideas futuras]**

**NARRADOR**:
Si tuviera más tiempo, podría agregar...

Aritmética de 32 bits para calcular números más grandes.

Una opción para mostrar toda la secuencia hasta n, no solo el n-ésimo número.

Guardar los resultados en un archivo de texto.

Pero para los requisitos del proyecto, esto es más que suficiente.

---

## ESCENA 22: CONCLUSIÓN

**[PANTALLA: Código completo en pantalla]**

**NARRADOR**:
En resumen, desarrollé un programa completo en ensamblador 8086 que calcula números de Fibonacci.

Cumple con todos los requisitos: rango de 0 a 24, validación de entrada, y resultados correctos.

Aprendí mucho sobre programación de bajo nivel y cómo funciona realmente una computadora.

**[PANTALLA: Ejecución final del programa]**

Y lo más importante: ¡funciona perfectamente!

Gracias por ver este video. ¡Hasta la próxima!

**[PANTALLA: Créditos]**

```
Proyecto: Calculadora de Fibonacci en Ensamblador 8086
Autor: [Tu nombre]
Fecha: 18 de noviembre de 2025

Código disponible en: [link si aplica]
```

---

## NOTAS PARA LA GRABACIÓN

### Tomas recomendadas:

- Close-ups del código mientras se explica
- Screen recording del programa ejecutándose
- Animaciones de los algoritmos
- Diagramas de flujo y memoria
- Tabla de Fibonacci
- Terminal compilando el código

### Recursos visuales necesarios:

- Diagrama del procesador 8086
- Tabla ASCII
- Estructura de la pila
- Diagrama de flujo del programa
- Tabla de interrupciones DOS
- Comparación iterativo vs recursivo

### Tips de edición:

- Usar transiciones suaves entre escenas
- Destacar código con zoom o resaltado
- Añadir música de fondo suave
- Sincronizar animaciones con las explicaciones
- Usar colores para diferenciar registros y variables

### Duración estimada: 15-20 minutos
