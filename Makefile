# --- CONFIG ---
ASM      = nasm
# ASMFLAGS = -f elf64        # change to -f macho64 on macOS
ASMFLAGS = -f macho64 -DAPPLE
CC       = gcc
CFLAGS   = -Wall -Wextra -O2 -g  -arch x86_64
# --- FILES ---
ASM_SRC  = substr.s
ASM_OBJ  = substr.o
C_TEST   = asm_test.c
TEST_BIN = asm_test

# --- DEFAULT ---
all: test

# --- BUILD TEST HARNESS ---
test: $(TEST_BIN)
	arch -x86_64 ./$(TEST_BIN)

$(TEST_BIN): $(ASM_OBJ) $(C_TEST)
	$(CC) $(CFLAGS) $(C_TEST) $(ASM_OBJ) -o $(TEST_BIN)

$(ASM_OBJ): $(ASM_SRC)
	$(ASM) $(ASMFLAGS) $(ASM_SRC) -o $(ASM_OBJ)

# --- CLEAN ---
clean:
	rm -f $(TEST_BIN) $(ASM_OBJ)

.PHONY: all clean test