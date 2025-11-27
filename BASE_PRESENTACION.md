# 📊 Base de Presentación - Sistema de Evaluación Académica
## Arquitectura de Computadores | Duración: 15 minutos

---

## 🎯 Estructura General

| Sección | Tiempo | Responsable |
|---------|--------|-------------|
| 1. Introducción y código C | 2 min | |
| 2. Proceso C → ASM x86 → MIPS | 3 min | |
| 3. Demo código MIPS en MARS | 3 min | |
| 4. Datapath función 1: `calcular_promedio` | 3 min | |
| 5. Datapath función 2: `clasificar` | 2.5 min | |
| 6. Conclusiones y preguntas | 1.5 min | |

---

## 📌 Sección 1: Introducción y Código C (2 min)

### Qué decir:
> "Nuestro proyecto es un Sistema de Evaluación Académica que solicita 4 notas, las valida, calcula el promedio y clasifica el rendimiento."

### Puntos clave del código C (`main.c`):
- **Entrada**: 4 notas (Matemáticas, Física, Programación, Arquitectura)
- **Validación**: Rango 0-100 con loop de reintento
- **Cálculo**: Promedio entero (suma/4)
- **Clasificación**:
  - ≥90 → Sobresaliente
  - ≥70 → Aprobado  
  - ≥50 → Requiere reforzamiento
  - <50 → Reprobado
- **Extra**: Marca nota máxima con `*`, mensaje de convalidación si Sobresaliente

### Código a mostrar:
```c
// Función clave en C
int calcular_promedio(int notas[], int n) {
    int suma = 0;
    for (int i = 0; i < n; i++) {
        suma += notas[i];
    }
    return suma / n;
}
```

---

## 📌 Sección 2: Proceso C → ASM x86 → MIPS (3 min)

### Qué decir:
> "Para escribir el código MIPS, primero compilamos el C a ensamblador x86-64 con GCC y estudiamos su estructura. Esto nos dio una referencia de cómo el compilador organiza loops, branches y llamadas a funciones."

### Flujo de trabajo:
```
┌─────────┐     gcc -S      ┌──────────────┐    análisis    ┌───────────┐
│ main.c  │ ───────────────►│ main_x86.asm │ ──────────────►│ main_mips │
└─────────┘                 └──────────────┘                └───────────┘
```

### Comparación de estructuras:

| Concepto | x86-64 | MIPS |
|----------|--------|------|
| Loop counter | `mov ecx, 4` | `addiu $s2, $zero, 4` |
| Comparación | `cmp / jl` | `slt + bne` |
| Llamada función | `call func` | `jal func` |
| Retorno | `ret` | `jr $ra` |
| División | `div` | `div + mflo` |

### Decisión importante:
> "Eliminamos las pseudo-instrucciones de MIPS para poder mapear el código directamente al datapath."

---

## 📌 Sección 3: Demo MIPS en MARS (3 min)

### Preparación previa:
1. Abrir MARS con `mips_pruebas.asm` ya cargado
2. Tener breakpoints en `calcular_promedio` y `clasificar`
3. Preparar inputs: `85, 92, 78, 88` (promedio = 85, Aprobado)

### Script de demo:
1. **Ensamblar** (F3) - Mostrar que no hay errores
2. **Ejecutar paso a paso** (F7) en la entrada de notas
3. **Mostrar registros** cambiando en tiempo real
4. **Resultado final**: Promedio 85, categoría "Aprobado", nota máxima marcada

### Inputs de prueba sugeridos:
| Caso | Notas | Promedio | Categoría |
|------|-------|----------|-----------|
| Normal | 85, 92, 78, 88 | 85 | Aprobado |
| Sobresaliente | 95, 92, 98, 91 | 94 | Sobresaliente + mensaje |
| Reprobado | 30, 45, 20, 35 | 32 | Reprobado |

---

## 📌 Sección 4: Datapath - `calcular_promedio` (3 min)

### Código de la función:
```asm
calcular_promedio:
    addu  $t0, $zero, $zero    # suma = 0
    addu  $t1, $zero, $zero    # i = 0
calc_loop:
    beq   $t1, $a1, calc_done  # if (i == n) goto done
    sll   $t2, $t1, 2          # offset = i * 4
    addu  $t3, $a0, $t2        # addr = base + offset
    lw    $t4, 0($t3)          # nota = mem[addr]
    addu  $t0, $t0, $t4        # suma += nota
    addiu $t1, $t1, 1          # i++
    j     calc_loop
calc_done:
    div   $t0, $a1             # suma / n
    mflo  $v0                  # resultado en $v0
    jr    $ra
```

### Mapeo al Datapath (instrucción por instrucción):

#### 1. `addu $t0, $zero, $zero` (R-type)
```
┌────────────┐
│ IF: Fetch  │ PC → Mem[PC] → IR = 000000_00000_00000_01000_00000_100001
└─────┬──────┘
      ▼
┌────────────┐
│ ID: Decode │ rs=$zero, rt=$zero, rd=$t0, funct=ADDU
└─────┬──────┘
      ▼
┌────────────┐
│ EX: Execute│ ALU: 0 + 0 = 0
└─────┬──────┘
      ▼
┌────────────┐
│ WB: Write  │ RegFile[$t0] ← 0
└────────────┘
```

#### 2. `beq $t1, $a1, calc_done` (I-type Branch)
```
┌────────────┐
│ IF: Fetch  │ PC → IR = 000100_01001_00101_offset
└─────┬──────┘
      ▼
┌────────────┐
│ ID: Decode │ rs=$t1, rt=$a1, offset=calc_done
│            │ Lee RegFile[$t1] y RegFile[$a1]
└─────┬──────┘
      ▼
┌────────────┐
│ EX: Execute│ ALU: $t1 - $a1 → Zero flag
│            │ Branch target = PC + 4 + (offset << 2)
└─────┬──────┘
      ▼
┌────────────┐
│ MEM/WB     │ Si Zero=1: PC ← branch_target
│            │ Si Zero=0: PC ← PC + 4
└────────────┘
```

#### 3. `lw $t4, 0($t3)` (I-type Load)
```
┌────────────┐
│ IF: Fetch  │ IR = 100011_01011_01100_0000000000000000
└─────┬──────┘
      ▼
┌────────────┐
│ ID: Decode │ rs=$t3, rt=$t4, offset=0
└─────┬──────┘
      ▼
┌────────────┐
│ EX: Execute│ ALU: $t3 + 0 = dirección efectiva
└─────┬──────┘
      ▼
┌────────────┐
│ MEM: Memory│ DataMem[dirección] → dato
└─────┬──────┘
      ▼
┌────────────┐
│ WB: Write  │ RegFile[$t4] ← dato
└────────────┘
```

#### 4. `div $t0, $a1` + `mflo $v0`
```
DIV: $t0 / $a1
├── Cociente  → registro LO
└── Residuo   → registro HI

MFLO: LO → $v0 (Move From LO)
```

### Señales de control activas:

| Instrucción | RegDst | ALUSrc | MemtoReg | RegWrite | MemRead | Branch | ALUOp |
|-------------|--------|--------|----------|----------|---------|--------|-------|
| `addu` | 1 | 0 | 0 | 1 | 0 | 0 | 10 |
| `beq` | X | 0 | X | 0 | 0 | 1 | 01 |
| `lw` | 0 | 1 | 1 | 1 | 1 | 0 | 00 |

---

## 📌 Sección 5: Datapath - `clasificar` (2.5 min)

### Código de la función:
```asm
clasificar:
    ori   $t0, $zero, 90       # umbral = 90
    slt   $at, $a0, $t0        # $at = (promedio < 90)
    bne   $at, $zero, check_70 # if $at != 0, no es sobresaliente
    
    lui   $v0, %hi(str_sobresaliente)
    ori   $v0, $v0, %lo(str_sobresaliente)
    jr    $ra

check_70:
    ori   $t0, $zero, 70
    slt   $at, $a0, $t0
    bne   $at, $zero, check_50
    # ... continúa
```

### Expansión de pseudo-instrucción `blt`:
```
Pseudo:  blt $a0, $t0, check_70

Real:    slt $at, $a0, $t0    # $at = 1 si $a0 < $t0
         bne $at, $zero, check_70
```

### Flujo en el Datapath:

#### `slt $at, $a0, $t0` (R-type)
```
┌──────────────────────────────────────────────────────────┐
│  RegFile[$a0]=85  RegFile[$t0]=90                        │
│         ↓              ↓                                 │
│       ┌────────────────────────┐                         │
│       │   ALU: comparación     │                         │
│       │   85 < 90? → SÍ → 1    │                         │
│       └──────────┬─────────────┘                         │
│                  ↓                                       │
│          RegFile[$at] ← 1                                │
└──────────────────────────────────────────────────────────┘
```

#### `bne $at, $zero, check_70` (I-type)
```
┌──────────────────────────────────────────────────────────┐
│  RegFile[$at]=1   RegFile[$zero]=0                       │
│         ↓              ↓                                 │
│       ┌────────────────────────┐                         │
│       │   ALU: resta           │                         │
│       │   1 - 0 = 1 ≠ 0        │                         │
│       │   Zero flag = 0        │                         │
│       └──────────┬─────────────┘                         │
│                  ↓                                       │
│   Branch taken! PC ← check_70                            │
└──────────────────────────────────────────────────────────┘
```

### Tabla de decisión completa:

| Promedio | slt resultado | bne resultado | Categoría |
|----------|---------------|---------------|-----------|
| 95 | $at=0 (95≮90) | No salta | Sobresaliente |
| 85 | $at=1 (85<90) | Salta a check_70 | Aprobado |
| 55 | $at=1 → $at=1 | Salta a check_50 | Reforzamiento |
| 40 | $at=1 → $at=1 → $at=1 | Reprobado | Reprobado |

---

## 📌 Sección 6: Conclusiones (1 min)

### Puntos a mencionar:

1. **Aprendizaje del proceso de traducción**:
   > "Usar el ASM de x86 como referencia nos ayudó a entender cómo estructurar el código MIPS"

2. **Pseudo-instrucciones vs instrucciones reales**:
   > "Eliminamos las pseudo-instrucciones para poder mapear directamente al datapath. Por ejemplo, `blt` se expande a `slt` + `bne`"

3. **Componentes del datapath utilizados**:
   - PC y memoria de instrucciones
   - Banco de registros (RegFile)
   - ALU (suma, resta, comparación, shift)
   - Memoria de datos (load/store)
   - Unidad de control

4. **Desafíos encontrados**:
   - Manejo del stack para llamadas anidadas
   - Convención de registros `$s` vs `$t`
   - Branch delay slots (agregamos `nop`)

---

## 🔥 Preguntas Frecuentes Anticipadas

### P: ¿Por qué usaron `la` si es pseudo-instrucción?
> "La instrucción `la` se expande a `lui` + `ori`, pero la mantuvimos para legibilidad porque su función es solo cargar direcciones, no afecta la lógica del programa. En el datapath se interpreta como dos instrucciones separadas."

### P: ¿Qué pasa con el branch delay slot?
> "En MIPS real, la instrucción después de un branch siempre se ejecuta. Por eso agregamos `nop` después de cada branch y jump para evitar comportamiento inesperado."

### P: ¿Por qué `addu` en lugar de `add`?
> "Usamos `addu` (unsigned) para evitar excepciones de overflow. En este programa los números son pequeños, pero es buena práctica."

### P: ¿Cómo funciona `div` + `mflo`?
> "La instrucción `div` divide dos registros y guarda el cociente en LO y el residuo en HI. `mflo` (Move From LO) copia el cociente al registro destino."

---

## 📁 Archivos del Proyecto

| Archivo | Descripción |
|---------|-------------|
| `main.c` | Implementación en C |
| `main_intel_x86-64.asm` | ASM generado por GCC (referencia) |
| `main_mips.asm` | Versión MIPS con pseudo-instrucciones |
| `mips_pruebas.asm` | Versión MIPS SIN pseudo-instrucciones ✓ |
| `Mars4_5.jar` | Simulador MIPS |

---

## ✅ Checklist Pre-Presentación

- [ ] MARS instalado y funcionando
- [ ] `mips_pruebas.asm` cargado sin errores
- [ ] Inputs de prueba preparados (85, 92, 78, 88)
- [ ] Diagramas de datapath impresos o en pantalla
- [ ] Cronómetro para controlar tiempos
- [ ] Backup del código en USB

---

*Documento creado: 27 de noviembre de 2025*
*Autores: Ihan & Martín*
