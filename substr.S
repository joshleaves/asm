default rel

%ifdef APPLE
  %define SYM(x) _ %+ x
%else
  %define SYM(x) x
%endif

extern SYM(malloc)
global SYM(substr)

section .text

%define SRC_PTR  rbx
%define OUT_PTR  rax

%define START    r12
%define STARTD   r12d
%define LENGTH   r13
%define LENGTHD  r13d

%define SRC_LEN  ecx
%define SRC_LENR rcx

; char *substr(const char *src, int start, int length) {
SYM(substr):
  ; - KEEP
  ; RDI = RBX = src
  ; ESI = R12d = start
  ; EDX = R13 = length
  ; -  TMP
  ; ECX = counter
  ; RAX = ptr
  push SRC_PTR
  push START
  push LENGTH

  mov SRC_PTR, rdi
  mov STARTD, esi
  mov LENGTHD, edx

  test SRC_PTR, SRC_PTR
  jz .return_null

  ; int src_len = strlen(src);
  xor SRC_LEN, SRC_LEN
  .strlen_loop:
  cmp byte [SRC_PTR + SRC_LENR], 0
  je  .strlen_done
  inc SRC_LEN
  jmp .strlen_loop
  .strlen_done:

  ; if (start < 0) return NULL;
  ; if (length <= 0) return NULL;
  ; if (start >= src_len) return NULL;
  test STARTD, STARTD
  jl  .return_null
  test LENGTHD, LENGTHD
  jle .return_null
  cmp STARTD, SRC_LEN
  jge .return_null

  ; eax = src_len - start
  ; if (start + length > src_len)
  ;   length = src_len - start;
  mov eax, SRC_LEN
  sub eax, STARTD
  cmp LENGTHD, eax
  jle .recalc_length_done
  mov LENGTHD, eax
  .recalc_length_done:

  ; char *out = malloc(length + 1);
  ; if (!out) return NULL;
  mov edi, LENGTHD
  inc edi
  call SYM(malloc)
  test OUT_PTR, OUT_PTR
  jz .return_null

  lea rsi, [SRC_PTR + START]
  xor SRC_LEN, SRC_LEN
  .copy_loop:
  cmp SRC_LEN, LENGTHD
  jge .copy_done
  mov dl, [rsi + SRC_LENR]
  mov [OUT_PTR + SRC_LENR], dl
  inc SRC_LEN
  jmp .copy_loop
  .copy_done:
  mov byte [OUT_PTR + SRC_LENR], 0

  .exit_substr:
  pop LENGTH
  pop START
  pop SRC_PTR
  ret

  .return_null:
  xor OUT_PTR, OUT_PTR
  jmp .exit_substr
