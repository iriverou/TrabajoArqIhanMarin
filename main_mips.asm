.eqv NUM_ASIGNATURAS, 4
.data
notes_array:       .space 16
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
main:
    addiu $sp, $sp, -36
    sw    $ra, 32($sp)
    sw    $s0, 28($sp)
    sw    $s1, 24($sp)
    sw    $s2, 20($sp)
    sw    $s3, 16($sp)
    sw    $s4, 12($sp)
    la    $s0, notes_array
    la    $s1, subjects_table
    ori   $s2, $zero, NUM_ASIGNATURAS
    addu  $s3, $zero, $zero
input_loop:
    slt   $t9, $s3, $s2
    beq   $t9, $zero, input_done
    nop
    sll   $t1, $s3, 2
    addu  $t2, $s1, $t1
    lw    $a0, 0($t2)
    jal   solicitar_nota
    nop
    sll   $t3, $s3, 2
    addu  $t4, $s0, $t3
    sw    $v0, 0($t4)
    addiu $s3, $s3, 1
    j     input_loop
    nop
input_done:
    addu  $a0, $s0, $zero
    addu  $a1, $s2, $zero
    jal   calcular_promedio
    nop
    addu  $s3, $v0, $zero
    addu  $a0, $s3, $zero
    jal   clasificar
    nop
    addu  $s4, $v0, $zero
    addu  $a0, $s0, $zero
    addu  $a1, $s2, $zero
    jal   indice_max
    nop
    addu  $t6, $v0, $zero
    ori   $v0, $zero, 4
    la    $a0, str_promedio
    syscall
    ori   $v0, $zero, 1
    addu  $a0, $s3, $zero
    syscall
    ori   $v0, $zero, 4
    la    $a0, str_categoria
    syscall
    ori   $v0, $zero, 4
    addu  $a0, $s4, $zero
    syscall
    ori   $v0, $zero, 4
    la    $a0, str_blank_line
    syscall
    addu  $t0, $zero, $zero
print_loop:
    slt   $t9, $t0, $s2
    beq   $t9, $zero, print_done
    nop
    sll   $t1, $t0, 2
    addu  $t2, $s1, $t1
    lw    $a0, 0($t2)
    ori   $v0, $zero, 4
    syscall
    ori   $v0, $zero, 4
    la    $a0, str_colon_space
    syscall
    sll   $t3, $t0, 2
    addu  $t4, $s0, $t3
    lw    $a0, 0($t4)
    ori   $v0, $zero, 1
    syscall
    bne   $t0, $t6, skip_star
    nop
    ori   $v0, $zero, 4
    la    $a0, str_star
    syscall
skip_star:
    ori   $v0, $zero, 4
    la    $a0, str_newline
    syscall
    addiu $t0, $t0, 1
    j     print_loop
    nop
print_done:
    ori   $t0, $zero, 90
    slt   $t9, $s3, $t0
    bne   $t9, $zero, finish
    nop
    ori   $v0, $zero, 4
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
    ori   $v0, $zero, 10
    syscall
solicitar_nota:
    addiu $sp, $sp, -16
    sw    $ra, 12($sp)
    sw    $s0, 8($sp)
    addu  $s0, $a0, $zero
read_note_loop:
    ori   $v0, $zero, 4
    la    $a0, str_prompt_prefix
    syscall
    ori   $v0, $zero, 4
    addu  $a0, $s0, $zero
    syscall
    ori   $v0, $zero, 4
    la    $a0, str_prompt_suffix
    syscall
    ori   $v0, $zero, 5
    syscall
    addu  $t0, $v0, $zero
    bltz  $t0, print_range_error
    nop
    ori   $t1, $zero, 100
    slt   $t9, $t1, $t0
    bne   $t9, $zero, print_range_error
    nop
    addu  $v0, $t0, $zero
    lw    $ra, 12($sp)
    lw    $s0, 8($sp)
    addiu $sp, $sp, 16
    jr    $ra
    nop
print_range_error:
    ori   $v0, $zero, 4
    la    $a0, str_error_range
    syscall
    j     read_note_loop
    nop
calcular_promedio:
    addu  $t0, $zero, $zero
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
clasificar:
    ori   $t0, $zero, 90
    slt   $t9, $a0, $t0
    bne   $t9, $zero, check_70
    nop
    la    $v0, str_sobresaliente
    jr    $ra
    nop
check_70:
    ori   $t0, $zero, 70
    slt   $t9, $a0, $t0
    bne   $t9, $zero, check_50
    nop
    la    $v0, str_aprobado
    jr    $ra
    nop
check_50:
    ori   $t0, $zero, 50
    slt   $t9, $a0, $t0
    bne   $t9, $zero, category_reprobado
    nop
    la    $v0, str_refuerzo
    jr    $ra
    nop
category_reprobado:
    la    $v0, str_reprobado
    jr    $ra
    nop
indice_max:
    lw    $t0, 0($a0)
    addu  $t1, $zero, $zero
    ori   $t2, $zero, 1
max_loop:
    beq   $t2, $a1, max_done
    nop
    sll   $t3, $t2, 2
    addu  $t4, $a0, $t3
    lw    $t5, 0($t4)
    slt   $t9, $t0, $t5
    beq   $t9, $zero, skip_update
    nop
    addu  $t0, $t5, $zero
    addu  $t1, $t2, $zero
skip_update:
    addiu $t2, $t2, 1
    j     max_loop
    nop
max_done:
    addu  $v0, $t1, $zero
    jr    $ra
    nop
