#include <stdio.h>

/*
  Sistema de evaluación académica.
  Requisitos:
    - Solicita 4 notas enteras (0-100) para: Matemáticas, Física, Programación, Arquitectura de Computadores.
    - Valida rango de cada nota (reintenta hasta válido).
    - Calcula promedio entero.
    - Clasifica: >=90 Sobresaliente; >=70 Aprobado; >=50 Requiere reforzamiento; <50 Reprobado.
    - Identifica nota máxima (primer empate según orden de entrada).
    - Imprime tabla y mensaje de convalidación solo si categoría = Sobresaliente.
  Compilar (MinGW):
    gcc -std=c11 -O2 -Wall -Wextra -Wpedantic -Werror -o program main.c
*/

#define NUM_ASIGNATURAS 4

static const char *ASIGNATURAS[NUM_ASIGNATURAS] = {
    "Matematicas",
    "Fisica",
    "Programacion",
    "Arquitectura Computadores"
};

int solicitar_nota(const char *asignatura) {
    int nota;
    for (;;) {
        printf("Ingrese nota para %s (0-100): ", asignatura);
        int input_result = scanf("%d", &nota);
        if (input_result != 1) {
            // Limpiar buffer ante entrada no numérica
            int ch;
            while ((ch = getchar()) != '\n' && ch != EOF) { }
            printf("[ERROR] Entrada invalida. Ingrese un entero.\n");
            continue;
        }
        if (nota < 0 || nota > 100) {
            printf("[ERROR] Nota fuera de rango. Ingrese un valor entre 0 y 100.\n");
            continue;
        }
        return nota;
    }
}

int calcular_promedio(const int notas[], int n) {
    int suma = 0;
    for (int i = 0; i < n; ++i) {
        suma += notas[i];
    }
    return suma / n; // División entera según especificación
}

const char *clasificar(int promedio) {
    if (promedio >= 90) return "Sobresaliente";
    if (promedio >= 70) return "Aprobado";
    if (promedio >= 50) return "Requiere reforzamiento";
    return "Reprobado";
}

int indice_max(const int notas[], int n) {
    int idx = 0;
    int maxv = notas[0];
    for (int i = 1; i < n; ++i) {
        if (notas[i] > maxv) {
            maxv = notas[i];
            idx = i;
        }
        /* Empates: no se cambia idx, preservando primero en orden */
    }
    return idx;
}

int main(void) {
    int notas[NUM_ASIGNATURAS];

    /* === FASE 1: Entrada de notas === */
    for (int i = 0; i < NUM_ASIGNATURAS; ++i) {
        notas[i] = solicitar_nota(ASIGNATURAS[i]);
    }

    /* === FASE 2: Cálculos === */
    int promedio = calcular_promedio(notas, NUM_ASIGNATURAS);
    const char *categoria = clasificar(promedio);
    int idx_max = indice_max(notas, NUM_ASIGNATURAS);

    /* === FASE 3: Salida de resultados === */
    printf("\nPromedio: %d\n", promedio);
    printf("Categoria: %s\n\n", categoria);

    for (int i = 0; i < NUM_ASIGNATURAS; ++i) {
        printf("%s: %d",
               ASIGNATURAS[i],
               notas[i]);
        if (i == idx_max) {
            printf(" *");
        }
        printf("\n");
    }

    if (promedio >= 90) {
        printf("\nPuede rendir examen de convalidacion.\n");
    }

    return 0;
}