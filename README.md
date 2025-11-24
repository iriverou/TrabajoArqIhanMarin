# TrabajoArqIhanMarin

Sistema de Evaluación Académica implementado en C y MIPS Assembly para el curso de Arquitectura de Computadores.

## Descripción

Programa que solicita 4 calificaciones (Matemáticas, Física, Programación, Arquitectura de Computadores), valida rangos, calcula promedio entero, clasifica rendimiento y muestra un reporte con la nota máxima marcada.

## Estructura del Proyecto

- `main.c` - Implementación en C (ISO C11)
- `main_mips.asm` - Implementación en MIPS Assembly (MARS 4.5)
- `main.exe` - Ejecutable compilado
- `Mars4_5.jar` - Simulador MIPS
- `.github/copilot-instructions.md` - Instrucciones del proyecto

## Compilación y Ejecución

### C (MinGW-w64)
```powershell
gcc -std=c11 -O2 -Wall -Wextra -Wpedantic -Werror -o main.exe main.c
.\main.exe
```

### MIPS (MARS)
```powershell
java -jar Mars4_5.jar nc pa main_mips.asm
```

O abrir `Mars4_5.jar` en GUI, cargar `main_mips.asm`, ensamblar (F3) y ejecutar (F5).

## Requisitos

- Solicitar 4 notas validadas en rango [0-100]
- Calcular promedio aritmético entero
- Clasificar: Sobresaliente (≥90), Aprobado (≥70), Requiere reforzamiento (≥50), Reprobado (<50)
- Identificar y marcar la nota máxima
- Mostrar mensaje de convalidación solo cuando categoría = "Sobresaliente"

## Autores

Ihan & Martín
