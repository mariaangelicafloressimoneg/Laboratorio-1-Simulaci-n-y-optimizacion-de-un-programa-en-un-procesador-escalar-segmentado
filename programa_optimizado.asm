# ==========================================================
# PROGRAMA OPTIMIZADO: Transformación de un vector en MIPS
# OPERACIÓN: Y[i] = A * X[i] + B
# OPTIMIZACIÓN: Reordenación de instrucciones para eliminar
# el riesgo Load-Use y mejorar el rendimiento del pipeline.
# ==========================================================

.data
    vector_x: .word 1, 2, 3, 4, 5, 6, 7, 8   # Vector de entrada X
    vector_y: .space 32                      # Espacio para 8 enteros (8 × 4 bytes)
    const_a:  .word 3                        # Constante multiplicativa A
    const_b:  .word 5                        # Constante aditiva B
    tamano:   .word 8                        # Número de elementos del vector

.text
.globl main

main:
    # ---------- Inicialización de direcciones base ----------
    la $s0, vector_x      # $s0 ← dirección base del vector X
    la $s1, vector_y      # $s1 ← dirección base del vector Y

    # ---------- Carga de constantes ----------
    lw $t0, const_a       # $t0 ← A
    lw $t1, const_b       # $t1 ← B
    lw $t2, tamano        # $t2 ← tamaño del vector

    li $t3, 0             # $t3 ← índice i = 0

loop:
    # ---------- Condición de terminación ----------
    beq $t3, $t2, fin     # Si i == tamaño → finalizar

    # ---------- Cálculo de dirección de X[i] ----------
    sll $t4, $t3, 2       # $t4 ← i × 4 (desplazamiento en bytes)
    addu $t5, $s0, $t4    # $t5 ← dirección de X[i]

    # ---------- Carga de dato ----------
    lw $t6, 0($t5)        # $t6 ← X[i]

    # ---------- Instrucción reordenada ----------
    # Rellena el hueco del Load-Use hazard
    addu $t9, $s1, $t4    # $t9 ← dirección de Y[i]

    # ---------- Operación aritmética ----------
    mul $t7, $t6, $t0     # $t7 ← X[i] × A

    # ---------- Separación de dependencia RAW ----------
    addi $t3, $t3, 1      # i ← i + 1

    addu $t8, $t7, $t1    # $t8 ← (X[i] × A) + B

    # ---------- Almacenamiento del resultado ----------
    sw $t8, 0($t9)        # Y[i] ← resultado

    # ---------- Repetición del bucle ----------
    j loop

fin:
    # ---------- Finalización del programa ----------
    li $v0, 10            # Código de servicio para terminar ejecución
    syscall               # Llamada al sistema