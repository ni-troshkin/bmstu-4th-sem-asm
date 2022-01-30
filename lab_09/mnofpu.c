#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#define REPS 100000000

void mnofpu(void)
{
    printf("\n\n TIME FOR -MNO-80387:\n\n");
    struct timeval start, stop;

    float b = 1.00001f;
    float c = 1.00001f;
    gettimeofday(&start, NULL);

    for (size_t i = 0; i < REPS; i++)
    {
        c = c * b;
    }
    gettimeofday(&stop, NULL);

    printf("float multiply time: %.3lf us\n", ((stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec) / (double)REPS);
    printf("result = %.6f\n", c);

    c = 1.00001f;
    gettimeofday(&start, NULL);

    for (size_t i = 0; i < REPS; i++)
    {
        c = c + b;
    }
    gettimeofday(&stop, NULL);

    printf("float sum time: %.3lf us\n", ((stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec) / (double)REPS);
    printf("result = %.6f\n", c);
    
    double db = 1.000000011111;
    double dc = 1.011111111111;

    gettimeofday(&start, NULL);
    for (size_t i = 0; i < REPS; i++)
    {
        dc = dc * db;
    }
    gettimeofday(&stop, NULL);
    printf("double multiply time: %.3lf us\n", ((stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec) / (double)REPS);
    printf("result = %.9lf\n", dc);

    dc = 1.011111111111;

    gettimeofday(&start, NULL);
    for (size_t i = 0; i < REPS; i++)
    {
        dc = dc + db;
    }
    gettimeofday(&stop, NULL);
    printf("double sum time: %.3lf us\n", ((stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec) / (double)REPS);
    printf("result = %.9lf\n", dc);

    // long double ldb = 1.0000000000111111L;
    // long double ldc = 1.0000111111111111L;

    // gettimeofday(&start, NULL);
    // for (size_t i = 0; i < REPS; i++)
    // {
    //     ldc = ldc * ldb;
    // }
    // gettimeofday(&stop, NULL);
    // printf("long double multiply time: %.3lf us\n", ((stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec) / (double)REPS);

    // ldc = 1.0000111111111111L;

    // gettimeofday(&start, NULL);
    // for (size_t i = 0; i < REPS; i++)
    // {
    //     ldc = ldc + ldb;
    // }
    // gettimeofday(&stop, NULL);
    // printf("long double sum time: %.3lf us\n", ((stop.tv_sec - start.tv_sec) * 1000000 + stop.tv_usec - start.tv_usec) / (double)REPS);
}