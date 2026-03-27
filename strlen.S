default rel

%ifdef APPLE
  %define SYM(x) _ %+ x
%else
  %define SYM(x) x
%endif

global SYM(strlen_rec)
global SYM(strlen)

section .text		; Déclaration code

SYM(strlen_rec):
  cmp byte [rdi], 0
	je	.nope		; JUMP (if zero) => .nope
	add rdi, 0x1
	call	SYM(strlen_rec)	; Call récursif
	add rax, 0x1 ; Return += 1
	ret
.nope:
	mov	rax, 0x0	; Return = 0
	ret

SYM(strlen):
	mov rax, 0
.recurse:
	cmp byte [rdi], 0
	je .end
	add rax, 1
	add rdi, 1
	jmp .recurse
.end:
	ret