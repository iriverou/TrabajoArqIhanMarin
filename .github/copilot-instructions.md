
# Instrucciones del repositorio — Laboratorio MIPS en C

Este archivo contiene las prácticas recomendadas y comandos útiles que GitHub Copilot
debe tomar en cuenta al generar sugerencias para este proyecto. Todo el código está en español.

## Entorno de desarrollo

- **Sistema operativo**: Windows 11
- **Terminal**: PowerShell
- **Compilador C**: MinGW-w64 (gcc 13.2.0)
- **Simulador MIPS**: MARS 4.5
- **Java Runtime**: JRE 8+ (para ejecutar MARS)

## Objetivo para Copilot

- Priorizar soluciones seguras, simples y portables.
- Generar código C estándar (ISO C11) sin dependencias externas.
- Evitar caracteres Unicode/ASCII extendido en salidas (solo ASCII básico).
- Mantener simetría entre implementación C y MIPS (misma lógica, misma salida).
- Para snippets de compilación, usar comandos reproducibles en PowerShell.

## Comandos básicos (PowerShell)

### Compilar C
```powershell
# Release (optimizado)
gcc -std=c11 -O2 -Wall -Wextra -Wpedantic -Werror -o program.exe main.c

# Debug (con información de depuración)
gcc -std=c11 -g -O0 -Wall -Wextra -o program_debug.exe main.c

# Generar ensamblador x86-64 (referencia, no es MIPS)
gcc -S -masm=intel -fverbose-asm -O2 -o main_intel.asm main.c
```

### Ejecutar MIPS en MARS
```powershell
java -jar Mars4_5.jar
# Luego: File → Open → program.asm → F3 (ensamblar) → F5 (ejecutar)
```

## Buenas prácticas — C

- Seguir estándar ISO C11 estricto.
- Evitar funciones inseguras (`strcpy`, `strcat`, `gets`). Usar `snprintf`, verificar longitudes.
- Inicializar todas las variables antes de usarlas.
- Validar entradas del usuario y rangos de datos.
- No usar caracteres especiales en `printf` (evitar `┌─┐│└┘` y similares por compatibilidad MIPS).
- Mantener funciones cortas y con responsabilidad única.
- Comentar secciones críticas: validación, bucles, cálculos, subrutinas.
- Usar nombres descriptivos en variables y funciones.

## Notas y enlaces útiles

- CERT C Secure Coding: https://wiki.sei.cmu.edu/confluence/display/c/SEI+CERT+C+Coding+Standard
- MinGW-w64: https://www.mingw-w64.org/
- MARS MIPS Simulator: http://courses.missouristate.edu/kenvollmar/mars/

## Trabajo del ramo — Laboratorio Assembler MIPS (enunciado y rúbrica)

Resumen del enunciado (copiar fielmente al informe/presentación):

- Objetivo: A partir de la abstracción de un problema (inventado o real) generar una solución de programación que contenga un mínimo de estructuras de control de flujo y programación estructurada modular.
- Entregables mínimos: implementación en C + implementación en assembler MIPS (32 bits) usando el emulador MARS, más un informe y una presentación.
- Requisitos mínimos del algoritmo/implementación:
	- Usar sentencias declarativas, asignación, operaciones matemáticas, selecciones (if/branch), repeticiones (loops) y al menos una función invocada.
	- Mostrar el mapeo de instrucciones al Datapath y describir el uso de memoria, registros, ALU y control.

Ponderación y presentación:

- 20%: Desarrollo del algoritmo en C y la versión en MIPS en MARS. Incluir en la presentación un marco teórico que explique la solución y el mapeo de instrucciones.
- 20%: Presentación de 10 minutos con el desarrollo MIPS y su mapeo en la arquitectura del computador (detallar uso y relación de componentes).
- La actividad constituye la tercera y cuarta evaluación (total 40%).

Rúbrica (resumen para incluir en el informe):

- Desarrollo de un algoritmo que utilice componentes de la CPU (5/3/1): diseñar e integrar al menos seis componentes para máxima nota; cuatro para nota aceptable.
- Efectividad en la ejecución (5/3/1): el diseño opera correctamente y obtiene resultados esperados.
- Conocimiento y administración de la herramienta (5/3/1): dominio de MARS y sus funcionalidades.
- Comparación mapeo vs. marco teórico (5/3/1): presentar uso de componentes en coherencia con teoría.
- Calidad y coherencia del informe/presentación (5/3/1).
- Contribución colaborativa (5/3/1) — si es trabajo en equipo, documentar contribuciones por integrante.

Checklist de entregables (añadir a la entrega y al repo):

- Código C: `main.c` con comentarios y README de ejecución.
- Código MIPS: `program.asm` (archivo .asm compatible con MARS) con comentarios que indiquen bloques y subrutinas.
- Proyecto de simulador: capturas de pantalla de MARS que muestren registros, memoria y etapas relevantes durante la ejecución.
- Informe (PDF): descripción del problema, algoritmo C, código MIPS, mapeo al Datapath, decisiones de diseño, pruebas y resultados.
- Presentación (slides): 10 minutos, incluye: objetivo, C (resumen), MIPS (fragmentos clave), mapeo al datapath (diagramas) y conclusiones.

Consejos técnicos para el mapeo al Datapath (qué evidenciar):

- Señalar instrucciones MIPS clave y explicar: registros leídos, registro destino, operación ALU, accesos a memoria (load/store) y señales de control implicadas.
- Mostrar snapshots en MARS que evidencien cambios en registros ($t0..), memoria y el contador de programa (PC) durante casos de prueba.
- Si usas subrutinas, mostrar el uso de la pila y convenciones de llamada (jal, jr, stack frame).
- Para pruebas, proporcionar casos de entrada y salida con pequeñas tablas y explicar por qué validan la corretitud.

Notas para el repositorio y GitHub Copilot:

- Incluir en la raíz del repo un `README.md` que explique cómo ejecutar el programa C y cómo cargar el `.asm` en MARS.
- Incluir un `report.pdf` y `presentation.pdf` en una carpeta `deliverables/`.
- GitHub Copilot: generar código C simple y portable, evitando caracteres especiales en output (nada de tablas Unicode).

## Problema propuesto a resolverse

### Resumen ejecutivo

- Registrar las calificaciones de un estudiante en Matemáticas, Física, Programación y Arquitectura de Computadores.
- Validar que cada nota ingresada sea un entero entre 0 y 100 antes de continuar con el flujo.
- Calcular el promedio aritmético entero, clasificar el rendimiento y destacar la mejor nota con su asignatura.
- Emitir un mensaje de convalidación únicamente cuando la categoría final sea "Sobresaliente".

### Especificación formal del proyecto

1. **DESCRIPCIÓN DEL PROBLEMA**
	 1.1 **Contexto General**
	 - Desarrollar un sistema que registre calificaciones, valide sus rangos y genere un informe de clasificación académica con recomendaciones.
	 1.2 **Asignaturas Registradas**
	 - Matemáticas, Física, Programación y Arquitectura de Computadores.

2. **REQUISITOS FUNCIONALES**
	 - **Entrada de Datos**
		 - `RF-1.1`: Solicitar la nota de cada asignatura.
		 - `RF-1.2`: Aceptar solo enteros en el rango `[0, 100]`.
		 - `RF-1.3`: Repetir la solicitud y mostrar error si la nota queda fuera de rango.
		 - `RF-1.4`: Validar inmediatamente tras cada ingreso.
	 - **Cálculo del Promedio**
		 - `RF-2.1`: Calcular el promedio aritmético simple.
		 - `RF-2.2`: Realizar la operación con aritmética entera.
		 - `RF-2.3`: Reutilizar el resultado para las clasificaciones posteriores.
	 - **Clasificación del Rendimiento**
		 - `RF-3.1`: Clasificar según el promedio (>= 90 "Sobresaliente"; >= 70 "Aprobado"; >= 50 "Requiere reforzamiento"; < 50 "Reprobado").
		 - `RF-3.2`: Evaluar las condiciones de forma mutuamente excluyente y secuencial.
	 - **Identificación de la Mejor Calificación**
		 - `RF-4.1`: Detectar la nota máxima.
		 - `RF-4.2`: Registrar la asignatura asociada.
		 - `RF-4.3`: Resolver empates tomando la primera aparición en el orden Matemáticas → Física → Programación → Arquitectura.
	 - **Modularidad y Funciones**
		 - `RF-5.1`: HLL debe incluir al menos una función para promedio, clasificación o validación.
		 - `RF-5.2`: MIPS debe incluir al menos una subrutina (`jal`/`jr $ra`) con la misma lógica.
		 - `RF-5.3`: Las funciones/subrutinas deben recibir parámetros claros y ser reutilizables.
	 - **Estructuras de Control**
		 - `RF-6.1`: Incluir al menos un bucle para validar entradas y/o recorrer asignaturas.
		 - `RF-6.2`: Incluir decisiones condicionales para validar rangos y/o clasificar.
		 - `RF-6.3`: Asegurar que las estructuras de control aporten funcionalidad real.
	 - **Salida de Datos**
		 - `RF-7.1`: Mostrar el promedio entero final.
		 - `RF-7.2`: Mostrar la categoría textual.
		 - `RF-7.3`: Imprimir una tabla con asignatura, nota y marcador del máximo.
		 - `RF-7.4`: Mostrar "El estudiante puede rendir examen de convalidación." solo cuando la categoría sea "Sobresaliente".
		 - `RF-7.5`: Omitir el mensaje de convalidación en cualquier otro caso.

3. **REQUISITOS NO FUNCIONALES**
		- `RNF-1.1`: Tiempo de respuesta perceptible < 1 segundo.
		- `RNF-1.2`: Consumo de memoria ≤ 1 KB en C y ≤ 4 KB en MIPS (incluida la pila).
		- `RNF-2.1`: Manejar entradas válidas e inválidas sin excepciones.
		- `RNF-2.2`: Nunca terminar prematuramente ante entradas fuera de rango.
		- `RNF-3.1`: C compila sin advertencias con `gcc -Wall -Wextra`.
		- `RNF-4.1`: Código MIPS compatible con MARS.
		- `RNF-4.2`: Usar instrucciones de 32 bits.
		- `RNF-4.3`: Respetar las convenciones de llamada MIPS (`$a0-$a3`, `$v0-$v1`, `$ra`).
		- `RNF-5.1`: Incluir comentarios en secciones críticas.
		- `RNF-5.2`: Usar nombres descriptivos y consistentes.
		- `RNF-5.3`: Mantener modularidad clara.

4. **RESTRICCIONES Y LIMITACIONES**
	 - `LIM-1.1`: Solo enteros `[0, 100]`.
	 - `LIM-1.2`: Rechazar negativos, decimales o caracteres.
	 - `LIM-1.3`: Cantidad fija de 4 asignaturas.
	 - `LIM-2.1`: Promedio calculado por división entera (sin decimales).
	 - `LIM-2.2`: Evitar arreglos dinámicos en MIPS (usar registros o memoria estática).
	 - `LIM-2.3`: No usar librerías externas de cálculo.
	 - `LIM-3.1`: Tabla en el orden original de asignaturas.
	 - `LIM-3.2`: Marcar la nota máxima de forma inequívoca.
	 - `LIM-3.3`: Mantener la salida en español.
	 - `LIM-4.1`: No usar instrucciones de punto flotante.
	 - `LIM-4.2`: No usar macros MIPS (`.macro`).
	 - `LIM-4.3`: Preservar y restaurar registros en subrutinas.
	 - `LIM-4.4`: Respetar el uso del stack (`$sp`).

5. **DATOS DE SALIDA ESPERADOS**
	 - **Formato general**

		 ```text
		  Ingrese nota para Matematicas (0-100): [entrada usuario]
		  Ingrese nota para Fisica (0-100): [entrada usuario]
		  Ingrese nota para Programacion (0-100): [entrada usuario]
		  Ingrese nota para Arquitectura Computadores (0-100): [entrada usuario]
 
		  Promedio: [promedio entero]
		  Categoria: [clasificación]
 
		  Matematicas: [nota] [MARCADOR]
		  Fisica: [nota]
		  Programacion: [nota]
		  Arquitectura Computadores: [nota]

		 [Mensaje de convalidación, si aplica]
		 ```

	 - **Ejemplo (Sobresaliente)**

		 ```text
		  Ingrese nota para Matematicas (0-100): 95
		  Ingrese nota para Fisica (0-100): 92
		  Ingrese nota para Programacion (0-100): 88
		  Ingrese nota para Arquitectura Computadores (0-100): 91
 
		  Promedio: 91
		  Categoria: Sobresaliente
 
		  Matematicas: 95 *
		  Fisica: 92
		  Programacion: 88
		  Arquitectura Computadores: 91
 
		  Puede rendir examen de convalidacion.
		 ```

	 - **Ejemplo (Entrada inválida)**

		 ```text
		  Ingrese nota para Matematicas (0-100): 150
		 [ERROR] Nota fuera de rango. Ingrese un valor entre 0 y 100.
		  Ingrese nota para Matematicas (0-100): 85
		  Ingrese nota para Fisica (0-100): ...
		 ```

6. **COMPONENTES DE HARDWARE CPU A MAPEAR**
	 - Registros de propósito general (`$t0`, `$t1`, `$s0`, `$s1`, etc.).
	 - Registros de argumentos (`$a0-$a3`).
	 - Registros de retorno (`$v0-$v1`).
	 - ALU para operaciones aritméticas (suma, resta, división entera).
	 - Memoria de datos para variables y cadenas.
	 - Unidad de control para saltos y ramas (`beq`, `bne`, `j`, `jal`, `jr`).
	 - Unidad de E/S (syscalls).
	 - Pila (`stack`) para preservar registros en subrutinas.

7. **CRITERIOS DE ACEPTACIÓN**
		- **Implementación C**: Compila/ejecuta sin errores, valida entradas, calcula promedio y clasificación correctos, identifica máximo, usa al menos una función, incorpora bucle y decisiones.
		- **Implementación MIPS**: Corre en MARS, replica la lógica C, formatea salidas, incluye subrutina con `jal`/`jr $ra`, respeta convenciones de registros y pila.
		- **Presentación y Documentación**: Incluye marco teórico, mapeo C↔MIPS, capturas en MARS, casos válidos/invalidos y documentación clara.

8. **CONSIDERACIONES PARA LA IMPLEMENTACIÓN**
	 - Usar registros individuales o un arreglo para las cuatro notas.
	 - Encapsular la validación en `validar_nota()` (o equivalente) y el promedio en `calcular_promedio()`.
	 - Implementar `clasificar()` para determinar la categoría.
	 - Iterar sobre las asignaturas con un bucle.
	 - Mapear parámetros a `$a0-$a3`, resultados a `$v0-$v1` y temporales a `$t0-$t9`.

9. **ENTREGABLES**
		- Código fuente C y MIPS, ambos comentados y modulares.
		- Informe con descripción, diseño, mapeos C↔MIPS, capturas de MARS, casos de prueba y conclusiones.
	 - Ejecutable o script listo para correr cuando aplique.

### Sugerencias para el informe/presentación

- Documentar el diseño de la función/subrutina seleccionada y justificar el uso de registros en MIPS.
- Incluir capturas de MARS que muestren validación, cálculo del promedio y determinación de la nota máxima.
- Presentar tablas de casos de prueba válidos e inválidos que respalden la corretitud del diseño.


---
