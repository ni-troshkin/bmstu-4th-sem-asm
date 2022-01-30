#include <stdio.h>
#include <sys/time.h>

#define REPEATS 10000000

float dot_product(float *a, float *b, size_t len)
{
    float product = 0;
    for (size_t i = 0; i < len; i++)
        product += a[i] * b[i];
    return product;
}

float asm_product(float *a, float *b, size_t len)
{
    float product;
    __asm__ (
        ".intel_syntax noprefix\n\t"
        "mov rax, %1\n\t"
        "mov rdx, %2\n\t"
        "mov r8, %3\n\t"
        "pxor xmm2, xmm2\n\t"  // обнуляем результат, будем накапливать сумму здесь
        
        "prod:\n\t"
        "movups xmm0, [rdx]\n\t"   // загружаем по 4 числа из массивов a, b
        "movups xmm1, [rax]\n\t"
        "mulps xmm0, xmm1\n\t"    // перемножаем пары
        "movaps xmm1, xmm0\n\t"   // копируем результат умножения в xmm1

        "mov rcx, 3\n\t"
        "shift_and_add:\n\t"
            "dec r8\n\t"             // в r8 лежит len, нужна проверка, что в массиве не закончились числа
            "cmp r8, 0\n\t"          // нужна проверка, что в массиве не закончились числа
            "jle quit\n\t"
            "shufps xmm1, xmm1, 0x39\n\t"    // если массив не кончился, сдвигаем числа в xmm1
            "addss xmm0, xmm1\n\t"           // и добавляем к младшему в xmm0
            "loop shift_and_add\n\t"

        "dec r8\n\t"                   // в итоге у нас в xmm0 в младшем двойном
        "addss xmm2, xmm0\n\t"         // слове лежит сумма четырех произведений, ее добавляем в xmm2
        "add rdx, 16\n\t"
        "add rax, 16\n\t"              // пропускаем 4 обработанных числа
        "cmp r8, 0\n\t"
        "jg prod\n\t"                  // не закончился массив - запускаем адскую машину еще раз
        "jmp return\n\t"

        "quit:\n\t"
        "addss xmm2, xmm0\n\t"
        "return:\n\t"
        "movss %0, xmm2\n\t"
        : "=x"(product)
        : "r"(a), "r"(b), "r"(len)
        : "rax", "rdx", "rcx", "r8", "xmm0", "xmm1", "xmm2"
    );
    return product;
}

int main(void)
{
    float a[] = {4, 2, 3, 4, 5, 6, 7};
    float b[] = {4, 2, 3, 4, 5, 6, 7};

    struct timeval start, stop;

    gettimeofday(&start, NULL);
    for (size_t i = 0; i < REPEATS; i++) {
        float prod = dot_product(a, b, 7);
    }
    gettimeofday(&stop, NULL);

    printf("c time: %.3lf us\n", ((stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec) / (double)REPEATS);

    // printf("%.3f ", prod);
    gettimeofday(&start, NULL);
    for (size_t i = 0; i < REPEATS; i++) {
        float prod = asm_product(a, b, 7);
    }
    gettimeofday(&stop, NULL);

    printf("asm time: %.3lf us\n", ((stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec) / (double)REPEATS);
    // printf("%.3f", prod);
    return 0;
}