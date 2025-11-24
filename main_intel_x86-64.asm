	.file	"main.c"
	.intel_syntax noprefix
 # GNU C17 (x86_64-posix-seh-rev0, Built by MinGW-Builds project) version 13.2.0 (x86_64-w64-mingw32)
 #	compiled by GNU C version 13.2.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.25-GMP
 # Codigo de referencia para crear el MIPS

 # GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
 # options passed: -masm=intel -mtune=core2 -march=nocona -O2
	.text
	.section .rdata,"dr"
	.align 8
.LC0:
	.ascii "Ingrese nota para %s (0-100): \0"
.LC1:
	.ascii "%d\0"
	.align 8
.LC2:
	.ascii "[ERROR] Entrada invalida. Ingrese un entero.\0"
	.align 8
.LC3:
	.ascii "[ERROR] Nota fuera de rango. Ingrese un valor entre 0 y 100.\0"
	.text
	.p2align 4
	.globl	solicitar_nota
	.def	solicitar_nota;	.scl	2;	.type	32;	.endef
	.seh_proc	solicitar_nota
solicitar_nota:
	push	rbp	 #
	.seh_pushreg	rbp
	push	rdi	 #
	.seh_pushreg	rdi
	push	rsi	 #
	.seh_pushreg	rsi
	push	rbx	 #
	.seh_pushreg	rbx
	sub	rsp, 56	 #,
	.seh_stackalloc	56
	.seh_endprologue
	lea	rbp, .LC0[rip]	 # tmp100,
	lea	rsi, .LC1[rip]	 # tmp101,
	lea	rdi, 44[rsp]	 # tmp102,
 # main.c:25: int solicitar_nota(const char *asignatura) {
	mov	rbx, rcx	 # asignatura, tmp103
.L2:
 # main.c:28:         printf("Ingrese nota para %s (0-100): ", asignatura);
	mov	rdx, rbx	 #, asignatura
	mov	rcx, rbp	 #, tmp100
	call	printf	 #
 # main.c:29:         int input_result = scanf("%d", &nota);
	mov	rdx, rdi	 #, tmp102
	mov	rcx, rsi	 #, tmp101
	call	scanf	 #
 # main.c:30:         if (input_result != 1) {
	cmp	eax, 1	 # tmp104,
	jne	.L4	 #,
 # main.c:37:         if (nota < 0 || nota > 100) {
	mov	eax, DWORD PTR 44[rsp]	 # <retval>, nota
 # main.c:37:         if (nota < 0 || nota > 100) {
	cmp	eax, 100	 # <retval>,
	ja	.L14	 #,
 # main.c:43: }
	add	rsp, 56	 #,
	pop	rbx	 #
	pop	rsi	 #
	pop	rdi	 #
	pop	rbp	 #
	ret	
	.p2align 4,,10
	.p2align 3
.L15:
 # main.c:33:             while ((ch = getchar()) != '\n' && ch != EOF) { }
	cmp	eax, 10	 # ch,
	je	.L8	 #,
.L4:
 # main.c:33:             while ((ch = getchar()) != '\n' && ch != EOF) { }
	call	getchar	 #
 # main.c:33:             while ((ch = getchar()) != '\n' && ch != EOF) { }
	cmp	eax, -1	 # ch,
	jne	.L15	 #,
.L8:
 # main.c:34:             printf("[ERROR] Entrada invalida. Ingrese un entero.\n");
	lea	rcx, .LC2[rip]	 # tmp97,
	call	puts	 #
 # main.c:35:             continue;
	jmp	.L2	 #
	.p2align 4,,10
	.p2align 3
.L14:
 # main.c:38:             printf("[ERROR] Nota fuera de rango. Ingrese un valor entre 0 y 100.\n");
	lea	rcx, .LC3[rip]	 # tmp98,
	call	puts	 #
 # main.c:39:             continue;
	jmp	.L2	 #
	.seh_endproc
	.p2align 4
	.globl	calcular_promedio
	.def	calcular_promedio;	.scl	2;	.type	32;	.endef
	.seh_proc	calcular_promedio
calcular_promedio:
	.seh_endprologue
 # main.c:47:     for (int i = 0; i < n; ++i) {
	test	edx, edx	 # n
 # main.c:45: int calcular_promedio(const int notas[], int n) {
	mov	r9d, edx	 # n, tmp101
 # main.c:47:     for (int i = 0; i < n; ++i) {
	jle	.L19	 #,
	movsx	rax, edx	 # n, n
	lea	r8, [rcx+rax*4]	 # _22,
 # main.c:46:     int suma = 0;
	xor	eax, eax	 # suma
	.p2align 4,,10
	.p2align 3
.L18:
 # main.c:48:         suma += notas[i];
	add	eax, DWORD PTR [rcx]	 # suma, MEM[(const int *)_7]
 # main.c:47:     for (int i = 0; i < n; ++i) {
	add	rcx, 4	 # ivtmp.16,
	cmp	rcx, r8	 # ivtmp.16, _22
	jne	.L18	 #,
 # main.c:50:     return suma / n; // División entera según especificación
	cdq
	idiv	r9d	 # n
 # main.c:51: }
	ret	
	.p2align 4,,10
	.p2align 3
.L19:
 # main.c:47:     for (int i = 0; i < n; ++i) {
	xor	eax, eax	 # <retval>
 # main.c:51: }
	ret	
	.seh_endproc
	.section .rdata,"dr"
.LC4:
	.ascii "Sobresaliente\0"
.LC5:
	.ascii "Reprobado\0"
.LC6:
	.ascii "Aprobado\0"
.LC7:
	.ascii "Requiere reforzamiento\0"
	.text
	.p2align 4
	.globl	clasificar
	.def	clasificar;	.scl	2;	.type	32;	.endef
	.seh_proc	clasificar
clasificar:
	.seh_endprologue
 # main.c:54:     if (promedio >= 90) return "Sobresaliente";
	lea	rax, .LC4[rip]	 # <retval>,
 # main.c:54:     if (promedio >= 90) return "Sobresaliente";
	cmp	ecx, 89	 # promedio,
	jg	.L21	 #,
 # main.c:55:     if (promedio >= 70) return "Aprobado";
	lea	rax, .LC6[rip]	 # <retval>,
 # main.c:55:     if (promedio >= 70) return "Aprobado";
	cmp	ecx, 69	 # promedio,
	jg	.L21	 #,
 # main.c:57:     return "Reprobado";
	lea	rax, .LC7[rip]	 # tmp85,
	cmp	ecx, 49	 # promedio,
	lea	rdx, .LC5[rip]	 # tmp86,
	cmovle	rax, rdx	 # tmp85,, <retval>, tmp86
.L21:
 # main.c:58: }
	ret	
	.seh_endproc
	.p2align 4
	.globl	indice_max
	.def	indice_max;	.scl	2;	.type	32;	.endef
	.seh_proc	indice_max
indice_max:
	.seh_endprologue
 # main.c:62:     int maxv = notas[0];
	mov	r8d, DWORD PTR [rcx]	 # maxv, *notas_12(D)
 # main.c:63:     for (int i = 1; i < n; ++i) {
	cmp	edx, 1	 # n,
	jle	.L30	 #,
	mov	edx, edx	 # _3, n
	mov	eax, 1	 # ivtmp.29,
 # main.c:61:     int idx = 0;
	xor	r10d, r10d	 # <retval>
	.p2align 4,,10
	.p2align 3
.L29:
 # main.c:64:         if (notas[i] > maxv) {
	mov	r9d, DWORD PTR [rcx+rax*4]	 # _26, MEM[(const int *)notas_12(D) + ivtmp.29_7 * 4]
 # main.c:64:         if (notas[i] > maxv) {
	cmp	r8d, r9d	 # maxv, _26
 # main.c:65:             maxv = notas[i];
	cmovl	r10d, eax	 # <retval>,, <retval>, ivtmp.29
	cmovl	r8d, r9d	 # maxv,, maxv, _26
 # main.c:63:     for (int i = 1; i < n; ++i) {
	add	rax, 1	 # ivtmp.29,
	cmp	rdx, rax	 # _3, ivtmp.29
	jne	.L29	 #,
 # main.c:71: }
	mov	eax, r10d	 #, <retval>
	ret	
	.p2align 4,,10
	.p2align 3
.L30:
 # main.c:61:     int idx = 0;
	xor	r10d, r10d	 # <retval>
 # main.c:71: }
	mov	eax, r10d	 #, <retval>
	ret	
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
.LC8:
	.ascii "Matematicas\0"
.LC9:
	.ascii "Fisica\0"
.LC10:
	.ascii "Programacion\0"
.LC11:
	.ascii "Arquitectura Computadores\0"
.LC12:
	.ascii "\12Promedio: %d\12\0"
.LC13:
	.ascii "Categoria: %s\12\12\0"
.LC14:
	.ascii "%s: %d\0"
.LC15:
	.ascii " *\0"
	.align 8
.LC16:
	.ascii "\12Puede rendir examen de convalidacion.\0"
	.section	.text.startup,"x"
	.p2align 4
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	push	r13	 #
	.seh_pushreg	r13
	push	r12	 #
	.seh_pushreg	r12
	push	rbp	 #
	.seh_pushreg	rbp
	push	rdi	 #
	.seh_pushreg	rdi
	push	rsi	 #
	.seh_pushreg	rsi
	push	rbx	 #
	.seh_pushreg	rbx
	sub	rsp, 56	 #,
	.seh_stackalloc	56
	.seh_endprologue
 # main.c:54:     if (promedio >= 90) return "Sobresaliente";
	lea	r13, .LC4[rip]	 # _37,
 # main.c:73: int main(void) {
	call	__main	 #
 # main.c:78:         notas[i] = solicitar_nota(ASIGNATURAS[i]);
	lea	rcx, .LC8[rip]	 # tmp100,
	call	solicitar_nota	 #
	lea	rcx, .LC9[rip]	 # tmp101,
	mov	r12d, eax	 # _41, tmp142
 # main.c:78:         notas[i] = solicitar_nota(ASIGNATURAS[i]);
	mov	DWORD PTR 32[rsp], eax	 # notas[0], _41
 # main.c:78:         notas[i] = solicitar_nota(ASIGNATURAS[i]);
	call	solicitar_nota	 #
	lea	rcx, .LC10[rip]	 # tmp102,
	mov	ebx, eax	 # _48, tmp143
 # main.c:78:         notas[i] = solicitar_nota(ASIGNATURAS[i]);
	mov	DWORD PTR 36[rsp], eax	 # notas[1], _48
 # main.c:78:         notas[i] = solicitar_nota(ASIGNATURAS[i]);
	call	solicitar_nota	 #
	lea	rcx, .LC11[rip]	 # tmp103,
	mov	ebp, eax	 # maxv, tmp144
 # main.c:78:         notas[i] = solicitar_nota(ASIGNATURAS[i]);
	mov	DWORD PTR 40[rsp], eax	 # notas[2], maxv
 # main.c:78:         notas[i] = solicitar_nota(ASIGNATURAS[i]);
	call	solicitar_nota	 #
 # main.c:78:         notas[i] = solicitar_nota(ASIGNATURAS[i]);
	mov	DWORD PTR 44[rsp], eax	 # notas[3], _2
 # main.c:48:         suma += notas[i];
	movdqa	xmm0, XMMWORD PTR 32[rsp]	 # vect__42.45, MEM <const vector(4) int> [(const int *)&notas]
	movdqa	xmm1, xmm0	 # tmp105, vect__42.45
	psrldq	xmm1, 8	 # tmp105,
	paddd	xmm0, xmm1	 # _68, tmp105
	movdqa	xmm1, xmm0	 # tmp107, _68
	psrldq	xmm1, 4	 # tmp107,
	paddd	xmm0, xmm1	 # tmp108, tmp107
	movd	esi, xmm0	 # stmp_suma_44.47, tmp108
 # main.c:50:     return suma / n; // División entera según especificación
	lea	edx, 3[rsi]	 # tmp110,
	test	esi, esi	 # stmp_suma_44.47
	cmovns	edx, esi	 # tmp110,, stmp_suma_44.47, stmp_suma_44.47
	sar	edx, 2	 # tmp111,
 # main.c:54:     if (promedio >= 90) return "Sobresaliente";
	cmp	esi, 359	 # stmp_suma_44.47,
	jg	.L33	 #,
 # main.c:55:     if (promedio >= 70) return "Aprobado";
	lea	r13, .LC6[rip]	 # _37,
 # main.c:55:     if (promedio >= 70) return "Aprobado";
	cmp	esi, 279	 # stmp_suma_44.47,
	jg	.L33	 #,
 # main.c:57:     return "Reprobado";
	lea	r13, .LC7[rip]	 # tmp129,
	cmp	esi, 199	 # stmp_suma_44.47,
	lea	rcx, .LC5[rip]	 # tmp130,
	cmovle	r13, rcx	 # tmp129,, _37, tmp130
.L33:
 # main.c:64:         if (notas[i] > maxv) {
	cmp	r12d, ebx	 # _41, _48
 # main.c:66:             idx = i;
	mov	edi, 1	 # idx,
 # main.c:64:         if (notas[i] > maxv) {
	jl	.L34	 #,
 # main.c:62:     int maxv = notas[0];
	mov	ebx, r12d	 # _48, _41
 # main.c:61:     int idx = 0;
	xor	edi, edi	 # idx
.L34:
 # main.c:64:         if (notas[i] > maxv) {
	cmp	ebx, ebp	 # _48, maxv
	jl	.L44	 #,
	mov	ebp, ebx	 # maxv, _48
.L35:
 # main.c:87:     printf("\nPromedio: %d\n", promedio);
	lea	rcx, .LC12[rip]	 # tmp112,
 # main.c:66:             idx = i;
	cmp	eax, ebp	 # _2, maxv
	mov	eax, 3	 # tmp131,
	cmovg	edi, eax	 # idx,, idx, tmp131
 # main.c:88:     printf("Categoria: %s\n\n", categoria);
	xor	ebx, ebx	 # ivtmp.51
 # main.c:87:     printf("\nPromedio: %d\n", promedio);
	call	printf	 #
 # main.c:88:     printf("Categoria: %s\n\n", categoria);
	mov	rdx, r13	 #, _37
	lea	rcx, .LC13[rip]	 # tmp113,
	call	printf	 #
	lea	r13, 32[rsp]	 # tmp122,
	lea	r12, ASIGNATURAS[rip]	 # tmp124,
	lea	rbp, .LC14[rip]	 # tmp123,
.L38:
 # main.c:91:         printf("%s: %d",
	mov	rdx, QWORD PTR [r12+rbx*8]	 # MEM[(const char * *)&ASIGNATURAS + ivtmp.51_39 * 8], MEM[(const char * *)&ASIGNATURAS + ivtmp.51_39 * 8]
	mov	rcx, rbp	 #, tmp123
	mov	r8d, DWORD PTR 0[r13+rbx*4]	 #, MEM[(int *)&notas + ivtmp.51_39 * 4]
	call	printf	 #
 # main.c:94:         if (i == idx_max) {
	cmp	edi, ebx	 # idx, ivtmp.51
	je	.L47	 #,
.L37:
 # main.c:97:         printf("\n");
	mov	ecx, 10	 #,
 # main.c:90:     for (int i = 0; i < NUM_ASIGNATURAS; ++i) {
	add	rbx, 1	 # ivtmp.51,
 # main.c:97:         printf("\n");
	call	putchar	 #
 # main.c:90:     for (int i = 0; i < NUM_ASIGNATURAS; ++i) {
	cmp	rbx, 4	 # ivtmp.51,
	jne	.L38	 #,
 # main.c:100:     if (promedio >= 90) {
	cmp	esi, 359	 # stmp_suma_44.47,
	jg	.L48	 #,
.L39:
 # main.c:105: }
	xor	eax, eax	 #
	add	rsp, 56	 #,
	pop	rbx	 #
	pop	rsi	 #
	pop	rdi	 #
	pop	rbp	 #
	pop	r12	 #
	pop	r13	 #
	ret	
.L44:
 # main.c:66:             idx = i;
	mov	edi, 2	 # idx,
	jmp	.L35	 #
.L47:
 # main.c:95:             printf(" *");
	lea	rcx, .LC15[rip]	 # tmp119,
	call	printf	 #
	jmp	.L37	 #
.L48:
 # main.c:101:         printf("\nPuede rendir examen de convalidacion.\n");
	lea	rcx, .LC16[rip]	 # tmp120,
	call	puts	 #
	jmp	.L39	 #
	.seh_endproc
	.section .rdata,"dr"
	.align 32
ASIGNATURAS:
	.quad	.LC8
	.quad	.LC9
	.quad	.LC10
	.quad	.LC11
	.ident	"GCC: (x86_64-posix-seh-rev0, Built by MinGW-Builds project) 13.2.0"
	.def	printf;	.scl	2;	.type	32;	.endef
	.def	scanf;	.scl	2;	.type	32;	.endef
	.def	getchar;	.scl	2;	.type	32;	.endef
	.def	puts;	.scl	2;	.type	32;	.endef
	.def	putchar;	.scl	2;	.type	32;	.endef
