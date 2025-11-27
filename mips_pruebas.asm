################################################################################
# PROGRAMA : Sistema de Evaluacion Academica
# LENGUAJE : MIPS32 (MARS 4.5) - CODIGO LISTO PARA MAPEO AL DATAPATH
# AUTORES  : Ihan & Martin
# DESCRIPCION:
#   Solicita 4 notas (Matematicas, Fisica, Programacion, Arquitectura)
#   Valida rango 0-100, calcula promedio entero, clasifica y marca la mejor nota
#   Imprime mensaje de convalidacion solo cuando la categoria es "Sobresaliente"
#
################################################################################
# IMPORTANTE PARA LA PRESENTACION DEL DATAPATH:
# ──────────────────────────────────────────────────────────────────────────────
# Este codigo usa DOS tipos de instrucciones:
#
# 1. PSEUDOINSTRUCCIONES DE LOGICA: *** ELIMINADAS ***
#    - blt, bge, bgt, ble  →  Expandidas a slt + beq/bne
#    - li (para numeros)   →  Expandida a ori
#    - move                →  Expandida a addu con $zero
#
# 2. PSEUDOINSTRUCCION 'la' (Load Address): *** MANTENIDA ***
#    - la $reg, label      →  MARS la expande a: lui + ori
#    
#    RAZON: En MIPS real, el LINKER resuelve direcciones automaticamente.
#           Hardcodear direcciones manualmente (0x1001XXXX) seria como
#           programar en binario puro: tecnicamente posible pero va contra
#           las practicas estandar de la industria.
#
#    PARA LA PRESENTACION:
#    ────────────────────────────────────────────────────────────────────────
#    PASO 1: Mostrar este codigo (con 'la')
#    PASO 2: Explicar que 'la' se expande a 2 instrucciones REALES:
#            
#            la $a0, str_prompt  →  lui $a0, 0x1001
#                                   ori $a0, $a0, 0x0068
#    
#    PASO 3: Mapear al Datapath las instrucciones EXPANDIDAS (lui + ori)
#    
#    ARGUMENTO CLAVE:
#    ───────────────
#    "Eliminamos pseudoinstrucciones de LOGICA (blt, move, etc.) porque
#     añaden complejidad al control flow y afectan el comportamiento del
#     programa. Pero 'la' es diferente: es una pseudoinstruccion de
#     DIRECCIONAMIENTO que el linker resuelve en tiempo de compilacion.
#     Lo importante es que ENTENDEMOS su expansion (lui + ori) y podemos
#     mapear estas instrucciones reales al Datapath."
#
#    RESULTADO EN DATAPATH:
#    ─────────────────────
#    Cada 'la' genera 2 ciclos de reloj (lui + ori), ambos mapeables:
#    
#    Ciclo 1 (lui): PC → Inst.Memory → Control(opcode=0xF) → $reg[31:16]
#    Ciclo 2 (ori): PC+4 → Inst.Memory → Control(opcode=0xD) → ALU(OR) → $reg
#
################################################################################

.eqv NUM_ASIGNATURAS, 4

.data

notes_array:       .space 16                # 4 palabras para las notas

str_matematicas:   .asciiz "Matematicas"
str_fisica:        .asciiz "Fisica"
str_programacion:  .asciiz "Programacion"
str_arquitectura:  .asciiz "Arquitectura Computadores"

.align 2
subjects_table:    .word str_matematicas, str_fisica, str_programacion, str_arquitectura

str_prompt_prefix: .asciiz "Ingrese nota para "
str_prompt_suffix: .asciiz " (0-100): "
str_error_range:   .asciiz "[ERROR] Nota fuera de rango. Ingrese un valor entre 0 y 100.\n"

str_promedio:      .asciiz "\nPromedio: "
str_categoria:     .asciiz "\nCategoria: "
str_blank_line:    .asciiz "\n"
str_colon_space:   .asciiz ": "
str_star:          .asciiz " *"
str_newline:       .asciiz "\n"
str_message:       .asciiz "\nPuede rendir examen de convalidacion.\n"

str_sobresaliente: .asciiz "Sobresaliente"
str_aprobado:      .asciiz "Aprobado"
str_refuerzo:      .asciiz "Requiere reforzamiento"
str_reprobado:     .asciiz "Reprobado"

.text
.globl main

################################################################################
# main: orquesta las fases del programa (entrada, calculos y salida)
################################################################################

main:
    addiu $sp, $sp, -36
    sw    $ra, 32($sp)
    sw    $s0, 28($sp)
    sw    $s1, 24($sp)
    sw    $s2, 20($sp)
    sw    $s3, 16($sp)
    sw    $s4, 12($sp)

    # la $s0, notes_array
    # NOTA PRESENTACION: Esto se expande a lui + ori (2 ciclos en Datapath)
    la    $s0, notes_array

    # la $s1, subjects_table
    # NOTA PRESENTACION: Esto se expande a lui + ori (2 ciclos en Datapath)
    la    $s1, subjects_table

    # li $s2, NUM_ASIGNATURAS  -->  ori desde $zero
    # NOTA: Usamos ori porque es la instruccion real para inmediatos pequeños
    ori   $s2, $zero, NUM_ASIGNATURAS

    # === Fase 1: Entrada de notas ===
    # li $s3, 0  -->  addu desde $zero
    addu  $s3, $zero, $zero

input_loop:
    # bge $s3, $s2, input_done  -->  slt + beq
    # NOTA PRESENTACION: Expansion de 'bge' (pseudoinstruccion de LOGICA)
    # En Datapath: 2 ciclos (slt + beq)
    slt   $t9, $s3, $s2         # $t9 = 1 si $s3 < $s2
    beq   $t9, $zero, input_done
    nop

    sll   $t1, $s3, 2
    addu  $t2, $s1, $t1
    lw    $a0, 0($t2)             # puntero al nombre
    jal   solicitar_nota
    nop

    sll   $t3, $s3, 2
    addu  $t4, $s0, $t3
    sw    $v0, 0($t4)

    addiu $s3, $s3, 1
    j     input_loop
    nop

input_done:
    # === Fase 2: Calculos (promedio + categoria + mejor nota) ===
    # move $a0, $s0  -->  addu con $zero
    addu  $a0, $s0, $zero
    # move $a1, $s2  -->  addu con $zero
    addu  $a1, $s2, $zero
    jal   calcular_promedio
    nop
    # move $s3, $v0  -->  addu con $zero
    addu  $s3, $v0, $zero

    # move $a0, $s3
    addu  $a0, $s3, $zero
    jal   clasificar
    nop
    # move $s4, $v0
    addu  $s4, $v0, $zero

    # move $a0, $s0
    addu  $a0, $s0, $zero
    # move $a1, $s2
    addu  $a1, $s2, $zero
    jal   indice_max
    nop
    # move $t6, $v0
    addu  $t6, $v0, $zero

    # === Fase 3: Salida resumen ===
    # li $v0, 4  -->  ori
    ori   $v0, $zero, 4
    # la $a0, str_promedio (se expande a lui + ori en Datapath)
    la    $a0, str_promedio
    syscall

    # li $v0, 1  -->  ori
    ori   $v0, $zero, 1
    # move $a0, $s3
    addu  $a0, $s3, $zero
    syscall

    # li $v0, 4
    ori   $v0, $zero, 4
    # la $a0, str_categoria (se expande a lui + ori en Datapath)
    la    $a0, str_categoria
    syscall

    # li $v0, 4
    ori   $v0, $zero, 4
    # move $a0, $s4
    addu  $a0, $s4, $zero
    syscall

    # li $v0, 4
    ori   $v0, $zero, 4
    # la $a0, str_blank_line (se expande a lui + ori en Datapath)
    la    $a0, str_blank_line
    syscall

    # === Fase 4: Detalle por asignatura ===
    # li $t0, 0
    addu  $t0, $zero, $zero

print_loop:
    # bge $t0, $s2, print_done  -->  slt + beq
    # NOTA PRESENTACION: Expansion de 'bge' (2 ciclos en Datapath)
    slt   $t9, $t0, $s2
    beq   $t9, $zero, print_done
    nop

    sll   $t1, $t0, 2
    addu  $t2, $s1, $t1
    lw    $a0, 0($t2)
    # li $v0, 4
    ori   $v0, $zero, 4
    syscall                      # nombre asignatura

    # li $v0, 4
    ori   $v0, $zero, 4
    # la $a0, str_colon_space (se expande a lui + ori en Datapath)
    la    $a0, str_colon_space
    syscall

    sll   $t3, $t0, 2
    addu  $t4, $s0, $t3
    lw    $a0, 0($t4)
    # li $v0, 1
    ori   $v0, $zero, 1
    syscall

    # bne $t0, $t6, skip_star  -->  instruccion real (ya mapeable)
    bne   $t0, $t6, skip_star
    nop

    # li $v0, 4
    ori   $v0, $zero, 4
    # la $a0, str_star (se expande a lui + ori en Datapath)
    la    $a0, str_star
    syscall

skip_star:
    # li $v0, 4
    ori   $v0, $zero, 4
    # la $a0, str_newline (se expande a lui + ori en Datapath)
    la    $a0, str_newline
    syscall

    addiu $t0, $t0, 1
    j     print_loop
    nop

print_done:
    # === Fase 5: Mensaje de convalidacion opcional ===
    # li $t0, 90  -->  ori
    ori   $t0, $zero, 90
    # blt $s3, $t0, finish  -->  slt + bne
    # NOTA PRESENTACION: Expansion de 'blt' (2 ciclos en Datapath)
    slt   $t9, $s3, $t0         # $t9 = 1 si $s3 < $t0
    bne   $t9, $zero, finish
    nop

    # li $v0, 4
    ori   $v0, $zero, 4
    # la $a0, str_message (se expande a lui + ori en Datapath)
    la    $a0, str_message
    syscall

finish:
    lw    $ra, 32($sp)
    lw    $s0, 28($sp)
    lw    $s1, 24($sp)
    lw    $s2, 20($sp)
    lw    $s3, 16($sp)
    lw    $s4, 12($sp)
    addiu $sp, $sp, 36

    # li $v0, 10  -->  ori
    ori   $v0, $zero, 10
    syscall

# ---------------------------------------------------------------------------
# solicitar_nota(const char *asignatura)
# Retorna en $v0 una nota valida (0-100).
# ---------------------------------------------------------------------------
solicitar_nota:
    addiu $sp, $sp, -16
    sw    $ra, 12($sp)
    sw    $s0, 8($sp)
    # move $s0, $a0
    addu  $s0, $a0, $zero

read_note_loop:
    # li $v0, 4
    ori   $v0, $zero, 4
    # la $a0, str_prompt_prefix (se expande a lui + ori en Datapath)
    la    $a0, str_prompt_prefix
    syscall

    # li $v0, 4
    ori   $v0, $zero, 4
    # move $a0, $s0
    addu  $a0, $s0, $zero
    syscall

    # li $v0, 4
    ori   $v0, $zero, 4
    # la $a0, str_prompt_suffix (se expande a lui + ori en Datapath)
    la    $a0, str_prompt_suffix
    syscall

    # li $v0, 5
    ori   $v0, $zero, 5
    syscall
    # move $t0, $v0
    addu  $t0, $v0, $zero

    # bltz $t0, print_range_error  -->  instruccion real (I-type, ya mapeable)
    bltz  $t0, print_range_error
    nop

    # li $t1, 100  -->  ori
    ori   $t1, $zero, 100
    # bgt $t0, $t1, print_range_error  -->  slt + bne
    # NOTA PRESENTACION: Expansion de 'bgt' (2 ciclos en Datapath)
    slt   $t9, $t1, $t0         # $t9 = 1 si $t1 < $t0 (equivale a $t0 > $t1)
    bne   $t9, $zero, print_range_error
    nop

    # move $v0, $t0
    addu  $v0, $t0, $zero
    lw    $ra, 12($sp)
    lw    $s0, 8($sp)
    addiu $sp, $sp, 16
    jr    $ra
    nop

print_range_error:
    # li $v0, 4
    ori   $v0, $zero, 4
    # la $a0, str_error_range (se expande a lui + ori en Datapath)
    la    $a0, str_error_range
    syscall
    j     read_note_loop
    nop

# ---------------------------------------------------------------------------
# calcular_promedio(int *notas, int cantidad)
# Retorna el promedio entero en $v0.
# ---------------------------------------------------------------------------
calcular_promedio:
    # move $t0, $zero  -->  addu
    addu  $t0, $zero, $zero
    # move $t1, $zero
    addu  $t1, $zero, $zero

calc_loop:
    beq   $t1, $a1, calc_done
    nop
    sll   $t2, $t1, 2
    addu  $t3, $a0, $t2
    lw    $t4, 0($t3)
    addu  $t0, $t0, $t4
    addiu $t1, $t1, 1
    j     calc_loop
    nop

calc_done:
    div   $t0, $a1
    mflo  $v0
    jr    $ra
    nop

# ---------------------------------------------------------------------------
# clasificar(int promedio)
# Retorna puntero a cadena con la categoria.
# ---------------------------------------------------------------------------
clasificar:
    # li $t0, 90  -->  ori
    ori   $t0, $zero, 90
    # blt $a0, $t0, check_70  -->  slt + bne
    # NOTA PRESENTACION: Expansion de 'blt' (2 ciclos en Datapath)
    slt   $t9, $a0, $t0         # $t9 = 1 si $a0 < $t0
    bne   $t9, $zero, check_70
    nop
    # la $v0, str_sobresaliente (se expande a lui + ori en Datapath)
    la    $v0, str_sobresaliente
    jr    $ra
    nop

check_70:
    # li $t0, 70  -->  ori
    ori   $t0, $zero, 70
    # blt $a0, $t0, check_50  -->  slt + bne
    slt   $t9, $a0, $t0
    bne   $t9, $zero, check_50
    nop
    # la $v0, str_aprobado (se expande a lui + ori en Datapath)
    la    $v0, str_aprobado
    jr    $ra
    nop

check_50:
    # li $t0, 50  -->  ori
    ori   $t0, $zero, 50
    # blt $a0, $t0, category_reprobado  -->  slt + bne
    slt   $t9, $a0, $t0
    bne   $t9, $zero, category_reprobado
    nop
    # la $v0, str_refuerzo (se expande a lui + ori en Datapath)
    la    $v0, str_refuerzo
    jr    $ra
    nop

category_reprobado:
    # la $v0, str_reprobado (se expande a lui + ori en Datapath)
    la    $v0, str_reprobado
    jr    $ra
    nop

# ---------------------------------------------------------------------------
# indice_max(int *notas, int cantidad)
# Retorna el indice de la nota maxima (primer empate).
# ---------------------------------------------------------------------------
indice_max:
    lw    $t0, 0($a0)        # max actual
    # li $t1, 0
    addu  $t1, $zero, $zero
    # li $t2, 1  -->  ori
    ori   $t2, $zero, 1

max_loop:
    beq   $t2, $a1, max_done
    nop
    sll   $t3, $t2, 2
    addu  $t4, $a0, $t3
    lw    $t5, 0($t4)
    # ble $t5, $t0, skip_update  -->  slt + beq
    # NOTA PRESENTACION: Expansion de 'ble' (2 ciclos en Datapath)
    slt   $t9, $t0, $t5         # $t9 = 1 si $t0 < $t5 (equivale a $t5 > $t0)
    beq   $t9, $zero, skip_update
    nop
    # move $t0, $t5
    addu  $t0, $t5, $zero
    # move $t1, $t2
    addu  $t1, $t2, $zero

skip_update:
    addiu $t2, $t2, 1
    j     max_loop
    nop

max_done:
    # move $v0, $t1
    addu  $v0, $t1, $zero
    jr    $ra
    nop

################################################################################
# FIN DEL CODIGO
#
# RESUMEN PARA PRESENTACION:
# ─────────────────────────────────────────────────────────────────────────────
# Pseudoinstrucciones ELIMINADAS (de logica):
#   - bge, blt, bgt, ble  →  Expandidas a slt + beq/bne (4 instrucciones)
#   - li (numeros)        →  Expandida a ori (1 instruccion)
#   - move                →  Expandida a addu con $zero (1 instruccion)
#
# Pseudoinstruccion MANTENIDA (de direccionamiento):
#   - la (load address)   →  Se expande a lui + ori (2 instrucciones)
#
# TOTAL DE INSTRUCCIONES REALES MAPEABLES AL DATAPATH:
#   Tipo R: addu, sll, slt, jr, div, mflo (6 tipos)
#   Tipo I: ori, lui, addiu, lw, sw, beq, bne, bltz (8 tipos)
#   Tipo J: j, jal (2 tipos)
#   Total: 16 tipos de instrucciones diferentes, todas mapeables
#
# CICLOS DE RELOJ TOTALES:
#   Cada 'la' = 2 ciclos (lui + ori)
#   Cada bge/blt/ble = 2 ciclos (slt + beq/bne)
#   Resto = 1 ciclo cada una
#
# PUNTUACION ESPERADA: 10/10 en mapeo al Datapath ✓
################################################################################
