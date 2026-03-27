// test_substr.c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include "asm.h"

static void expect_substr(
  const char *label,
  const char *src,
  int start,
  int length,
  const char *expected,
  int expect_null
) {
  char *out = substr(src, start, length);

  if (expect_null) {
    if (out != NULL) {
      printf("[FAIL] %s: expected NULL, got \"%s\"\n", label, out);
      free(out);
      exit(1);
    }
    printf("[OK]   %s: got NULL as expected\n", label);
    return;
  }

  if (out == NULL) {
    printf("[FAIL] %s: expected \"%s\", got NULL\n", label, expected);
    exit(1);
  }

  if (strcmp(out, expected) != 0) {
    printf("[FAIL] %s: expected \"%s\", got \"%s\"\n", label, expected, out);
    free(out);
    exit(1);
  }

  printf("[OK]   %s: \"%s\"\n", label, out);
  free(out);
}

int main(void) {
  printf("Getting started\n");
  // Normal cases
  expect_substr("middle slice",      "bistromathique", 3, 5, "troma", 0);
  expect_substr("from start",        "hello",          0, 2, "he",    0);
  expect_substr("tail exact",        "hello",          3, 2, "lo",    0);

  // Clamping (start + length > src_len)
  expect_substr("clamp long",        "hello",          1, 100, "ello", 0);
  expect_substr("clamp whole string","abc",            0, 100, "abc",  0);

  // Error / NULL cases
  expect_substr("neg start",         "abc",           -1,  2,  NULL,   1);
  expect_substr("zero length",       "abc",            1,  0,  NULL,   1);
  expect_substr("neg length",        "abc",            1, -5,  NULL,   1);
  expect_substr("start == len",      "abc",            3,  1,  NULL,   1);
  expect_substr("empty src",         "",               0,  1,  NULL,   1);

  printf("\nAll tests passed ✅\n");
  return 0;
}
