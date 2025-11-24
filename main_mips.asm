
################################################################################
# PROGRAMA : Sistema de Evaluacion Academica
# LENGUAJE : MIPS32 (MARS 4.5)
# DESCRIPCION:
#   Solicita 4 notas (Matematicas, Fisica, Programacion, Arquitectura)
#   Valida rango 0-100, calcula promedio entero, clasifica y marca la mejor nota
#   Imprime mensaje de convalidacion solo cuando la categoria es "Sobresaliente"
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

	la    $s0, notes_array        # base del arreglo de notas
	la    $s1, subjects_table     # base de la tabla de nombres
	li    $s2, NUM_ASIGNATURAS    # cantidad de asignaturas

	# === Fase 1: Entrada de notas ===
	li    $s3, 0                  # indice = 0 (usar $s3 temporalmente)
input_loop:
	bge   $s3, $s2, input_done
	sll   $t1, $s3, 2
	add   $t2, $s1, $t1
	lw    $a0, 0($t2)             # puntero al nombre
	jal   solicitar_nota

	sll   $t3, $s3, 2
	add   $t4, $s0, $t3
	sw    $v0, 0($t4)

	addiu $s3, $s3, 1
	j     input_loop

input_done:
	# === Fase 2: Calculos (promedio + categoria + mejor nota) ===
	move  $a0, $s0
	move  $a1, $s2
	jal   calcular_promedio
	move  $s3, $v0                # promedio (reutilizar $s3)

	move  $a0, $s3
	jal   clasificar
	move  $s4, $v0                # puntero a categoria (usar $s4)

	move  $a0, $s0
	move  $a1, $s2
	jal   indice_max
	move  $t6, $v0                # indice de la mejor nota

	# === Fase 3: Salida resumen ===
	li    $v0, 4
	la    $a0, str_promedio
	syscall

	li    $v0, 1
	move  $a0, $s3
	syscall

	li    $v0, 4
	la    $a0, str_categoria
	syscall

	li    $v0, 4
	move  $a0, $s4
	syscall

	li    $v0, 4
	la    $a0, str_blank_line
	syscall

	# === Fase 4: Detalle por asignatura ===
	li    $t0, 0
print_loop:
	bge   $t0, $s2, print_done
	sll   $t1, $t0, 2
	add   $t2, $s1, $t1
	lw    $a0, 0($t2)
	li    $v0, 4
	syscall                      # nombre asignatura

	li    $v0, 4
	la    $a0, str_colon_space
	syscall

	sll   $t3, $t0, 2
	add   $t4, $s0, $t3
	lw    $a0, 0($t4)
	li    $v0, 1
	syscall

	bne   $t0, $t6, skip_star
	li    $v0, 4
	la    $a0, str_star
	syscall
skip_star:
	li    $v0, 4
	la    $a0, str_newline
	syscall

	addiu $t0, $t0, 1
	j     print_loop

print_done:
	# === Fase 5: Mensaje de convalidacion opcional ===
	li    $t0, 90
	blt   $s3, $t0, finish

	li    $v0, 4
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

	li    $v0, 10
	syscall

# ---------------------------------------------------------------------------
# solicitar_nota(const char *asignatura)
# Retorna en $v0 una nota valida (0-100).
# ---------------------------------------------------------------------------
solicitar_nota:
	addiu $sp, $sp, -16
	sw    $ra, 12($sp)
	sw    $s0, 8($sp)
	move  $s0, $a0

read_note_loop:
	li    $v0, 4
	la    $a0, str_prompt_prefix
	syscall

	li    $v0, 4
	move  $a0, $s0
	syscall

	li    $v0, 4
	la    $a0, str_prompt_suffix
	syscall

	li    $v0, 5
	syscall
	move  $t0, $v0

	bltz  $t0, print_range_error
	li    $t1, 100
	bgt   $t0, $t1, print_range_error

	move  $v0, $t0
	lw    $ra, 12($sp)
	lw    $s0, 8($sp)
	addiu $sp, $sp, 16
	jr    $ra

print_range_error:
	li    $v0, 4
	la    $a0, str_error_range
	syscall
	j     read_note_loop

# ---------------------------------------------------------------------------
# calcular_promedio(int *notas, int cantidad)
# Retorna el promedio entero en $v0.
# ---------------------------------------------------------------------------
calcular_promedio:
	move  $t0, $zero          # suma
	move  $t1, $zero          # indice

calc_loop:
	beq   $t1, $a1, calc_done
	sll   $t2, $t1, 2
	add   $t3, $a0, $t2
	lw    $t4, 0($t3)
	add   $t0, $t0, $t4
	addiu $t1, $t1, 1
	j     calc_loop

calc_done:
	div   $t0, $a1
	mflo  $v0
	jr    $ra

# ---------------------------------------------------------------------------
# clasificar(int promedio)
# Retorna puntero a cadena con la categoria.
# ---------------------------------------------------------------------------
clasificar:
	li    $t0, 90
	blt   $a0, $t0, check_70
	la    $v0, str_sobresaliente
	jr    $ra

check_70:
	li    $t0, 70
	blt   $a0, $t0, check_50
	la    $v0, str_aprobado
	jr    $ra

check_50:
	li    $t0, 50
	blt   $a0, $t0, category_reprobado
	la    $v0, str_refuerzo
	jr    $ra

category_reprobado:
	la    $v0, str_reprobado
	jr    $ra

# ---------------------------------------------------------------------------
# indice_max(int *notas, int cantidad)
# Retorna el indice de la nota maxima (primer empate).
# ---------------------------------------------------------------------------
indice_max:
	lw    $t0, 0($a0)        # max actual
	li    $t1, 0             # indice max
	li    $t2, 1             # i = 1

max_loop:
	beq   $t2, $a1, max_done
	sll   $t3, $t2, 2
	add   $t4, $a0, $t3
	lw    $t5, 0($t4)
	ble   $t5, $t0, skip_update
	move  $t0, $t5
	move  $t1, $t2
skip_update:
	addiu $t2, $t2, 1
	j     max_loop

max_done:
	move  $v0, $t1
	jr    $ra
