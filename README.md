# Calculadora de Fibonacci en Ensamblador 8086

## Descripción
Programa en lenguaje ensamblador 8086 (Turbo Assembler) que calcula el n-ésimo número de la secuencia de Fibonacci.

### Especificaciones
- **Rango válido**: n = 0 a 24 (decimal)
- **Fórmula**: 
  - Fib(0) = 0
  - Fib(1) = 1
  - Fib(n) = Fib(n-1) + Fib(n-2) para n ≥ 2

## Estructura del Programa

### Módulo Principal: `fibonacci.asm`

El programa está organizado en los siguientes componentes:

1. **Procedimiento MAIN**: Controla el flujo principal del programa
2. **Procedimiento LEER_NUMERO**: Lee y valida la entrada del usuario
3. **Procedimiento CALCULAR_FIBONACCI**: Calcula el número de Fibonacci usando método iterativo
4. **Procedimiento IMPRIMIR_NUMERO**: Convierte y muestra el resultado en formato decimal

## Compilación y Ejecución

### Usando Turbo Assembler (TASM):
```batch
tasm fibonacci.asm
tlink fibonacci.obj
fibonacci.exe
```

### Usando MASM:
```batch
masm fibonacci.asm;
link fibonacci.obj;
fibonacci.exe
```

### Usando DOSBox:
1. Montar la carpeta con el programa
2. Compilar con TASM o MASM
3. Ejecutar el archivo .exe generado

## Ejemplos de Uso

### Ejemplo 1:
```
==== CALCULADORA DE FIBONACCI ====
Ingrese el valor de n (0-24): 5
El numero Fibonacci es: 5
```

### Ejemplo 2:
```
==== CALCULADORA DE FIBONACCI ====
Ingrese el valor de n (0-24): 10
El numero Fibonacci es: 55
```

### Ejemplo 3:
```
==== CALCULADORA DE FIBONACCI ====
Ingrese el valor de n (0-24): 24
El numero Fibonacci es: 46368
```

## Tabla de Referencia: Números de Fibonacci (0-24)

| n  | Fib(n) |
|----|--------|
| 0  | 0      |
| 1  | 1      |
| 2  | 1      |
| 3  | 2      |
| 4  | 3      |
| 5  | 5      |
| 6  | 8      |
| 7  | 13     |
| 8  | 21     |
| 9  | 34     |
| 10 | 55     |
| 11 | 89     |
| 12 | 144    |
| 13 | 233    |
| 14 | 377    |
| 15 | 610    |
| 16 | 987    |
| 17 | 1597   |
| 18 | 2584   |
| 19 | 4181   |
| 20 | 6765   |
| 21 | 10946  |
| 22 | 17711  |
| 23 | 28657  |
| 24 | 46368  |

## Características del Código

- **Validación de entrada**: Verifica que n esté en el rango 0-24
- **Manejo de errores**: Muestra mensaje si el valor está fuera del rango
- **Interfaz interactiva**: Permite calcular múltiples valores sin reiniciar
- **Comentarios detallados**: Todo el código está documentado para facilitar su comprensión
- **Método iterativo**: Más eficiente que la recursión para este caso

## Notas Técnicas

- El programa usa el modelo de memoria SMALL
- Stack de 100h bytes
- Algoritmo iterativo para optimizar rendimiento
- Manejo de interrupciones DOS 21h para entrada/salida
- Compatible con procesadores 8086/8088
