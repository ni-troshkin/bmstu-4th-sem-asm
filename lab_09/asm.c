#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#define REPS 100000000

void asm_prod(void)
{
    printf("\n\n TIME FOR ASM:\n\n");
    struct timeval start, stop;

    float b = 1.00001f;
    float c = 1.00001f;
    gettimeofday(&start, NULL);

    for (size_t i = 0; i < REPS; i++)
    {
        __asm__ (
            ".intel_syntax noprefix\n\t"
            "fld %2\n\t"
            "fld %1\n\t"
            "fmulp\n\t"
            "fstp %0"
            : "=m" (c)
            : "m"(c), "m"(b)
        );
    }
    gettimeofday(&stop, NULL);

    printf("float multiply time: %.3lf us\n", ((stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec) / (double)REPS);
    printf("result = %.6f\n", c);

    c = 1.00001f;
    gettimeofday(&start, NULL);

    for (size_t i = 0; i < REPS; i++)
    {
        __asm__ (
            ".intel_syntax noprefix\n\t"
            "fld %2\n\t"
            "fld %1\n\t"
            "faddp\n\t"
            "fstp %0"
            : "=m" (c)
            : "m"(c), "m"(b)
        );
    }
    gettimeofday(&stop, NULL);

    printf("float sum time: %.3lf us\n", ((stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec) / (double)REPS);
    printf("result = %.6f\n", c);
    
    double db = 1.000000011111;
    double dc = 1.001111111111;

    gettimeofday(&start, NULL);
    for (size_t i = 0; i < REPS; i++)
    {
        __asm__ (
            ".intel_syntax noprefix\n\t"
            "fld %2\n\t"
            "fld %1\n\t"
            "fmulp\n\t"
            "fstp %0"
            : "=m"(dc)
            : "m"(dc), "m"(db)
        );
    }
    gettimeofday(&stop, NULL);
    printf("double multiply time: %.3lf us\n", ((stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec) / (double)REPS);
    printf("result = %.9lf\n", dc);

    dc = 1.001111111111;

    gettimeofday(&start, NULL);
    for (size_t i = 0; i < REPS; i++)
    {
        __asm__ (
            ".intel_syntax noprefix\n\t"
            "fld %2\n\t"
            "fld %1\n\t"
            "faddp\n\t"
            "fstp %0"
            : "=m"(dc)
            : "m"(dc), "m"(db)
        );
    }
    gettimeofday(&stop, NULL);
    printf("double sum time: %.3lf us\n", ((stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec) / (double)REPS);
    printf("result = %.9lf\n", dc);

    long double ldb = 1.0000000000111111L;
    long double ldc = 1.0000011111111111L;

    gettimeofday(&start, NULL);
    for (size_t i = 0; i < REPS; i++)
    {
        __asm__ (
            ".intel_syntax noprefix\n\t"
            "fld %2\n\t"
            "fld %1\n\t"
            "fmulp\n\t"
            "fstp %0"
            : "=m"(ldc)
            : "m"(ldc), "m"(ldb)
        );
    }
    gettimeofday(&stop, NULL);
    printf("long double multiply time: %.3lf us\n", ((stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec) / (double)REPS);
    printf("result = %.12Lf\n", ldc);

    ldc = 1.0000011111111111L;

    gettimeofday(&start, NULL);
    for (size_t i = 0; i < REPS; i++)
    {
        __asm__ (
            ".intel_syntax noprefix\n\t"
            "fld %2\n\t"
            "fld %1\n\t"
            "faddp\n\t"
            "fstp %0"
            : "=m"(ldc)
            : "m"(ldc), "m"(ldb)
        );
    }
    gettimeofday(&stop, NULL);
    printf("long double sum time: %.3lf us\n", ((stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec) / (double)REPS);
    printf("result = %.12Lf\n", ldc);
}