# ==========================================================
# PROGRAMA: Transformación de un vector en MIPS
# OPERACIÓN: Y[i] = A * X[i] + B
# DESCRIPCIÓN:
# Recorre el vector X, aplica la operación matemática
# y guarda el resultado en el vector Y.
# ==========================================================

.data
    vector_x: .word 1, 2, 3, 4, 5, 6, 7, 8   # Vector de entrada X
    vector_y: .space 32                      # Espacio para 8 enteros (8 × 4 bytes)
    const_a:  .word 3                       # Constante A
    const_b:  .word 5                       # Constante B
    tamano:   .word 8                       # Número de elementos del vector

.text
.globl main

main:
    # ------------------------------------------------------
    # 1. INICIALIZACIÓN DE REGISTROS
    # ------------------------------------------------------

    la $s0, vector_x      # $s0 ← dirección base del vector X
    la $s1, vector_y      # $s1 ← dirección base del vector Y

    lw $t0, const_a       # $t0 ← valor de la constante A
    lw $t1, const_b       # $t1 ← valor de la constante B
    lw $t2, tamano        # $t2 ← tamaño del vector

    li $t3, 0             # $t3 ← índice i = 0 (contador del bucle)

loop:
    # ------------------------------------------------------
    # 2. CONDICIÓN DE TERMINACIÓN DEL BUCLE
    # ------------------------------------------------------

    beq $t3, $t2, fin     # Si i == tamaño → terminar programa

    # ------------------------------------------------------
    # 3. CÁLCULO DE DIRECCIÓN DE X[i]
    # Cada entero ocupa 4 bytes en memoria
    # ------------------------------------------------------

    sll $t4, $t3, 2       # $t4 ← i * 4 (desplazamiento en memoria)
    addu $t5, $s0, $t4    # $t5 ← dirección de X[i]

    # ------------------------------------------------------
    # 4. LECTURA DEL ELEMENTO X[i]
    # ------------------------------------------------------

    lw $t6, 0($t5)        # $t6 ← X[i]

    # ------------------------------------------------------
    # 5. OPERACIÓN MATEMÁTICA
    # Y[i] = A * X[i] + B
    # ------------------------------------------------------

    mul $t7, $t6, $t0     # $t7 ← X[i] * A
    addu $t8, $t7, $t1    # $t8 ← (X[i] * A) + B

    # ------------------------------------------------------
    # 6. GUARDAR RESULTADO EN Y[i]
    # ------------------------------------------------------

    addu $t9, $s1, $t4    # $t9 ← dirección de Y[i]
    sw $t8, 0($t9)        # Y[i] ← resultado calculado

    # ------------------------------------------------------
    # 7. ACTUALIZACIÓN DEL ÍNDICE Y REPETICIÓN DEL BUCLE
    # ------------------------------------------------------

    addi $t3, $t3, 1      # i ← i + 1
    j loop                # Volver al inicio del bucle

fin:
    # ------------------------------------------------------
    # 8. FINALIZACIÓN DEL PROGRAMA
    # ------------------------------------------------------

    li $v0, 10            # Código de sistema para terminar ejecución
    syscall               # Llamada al sistema operativo
