/*
 * Ref: book/04_prog/03_tools/04_GNU_compiler/refcard.pdf
 */

int f() {
    int *a = 0;
    return 0;
}

int g() {
    // with error. try to use gdb to catch it.
    int *b = 0;
    int c = *b;
    return c;
}

int main() {

    f();
    g();
}
