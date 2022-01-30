#include <stdio.h>
#include <math.h>

#define PI 3.14
#define D_PI 3.141596

void countsin(void)
{
    printf("\n\nPI = 3.14: sin(PI) = %.9lf, sin(PI/2) = %.9lf\n", sin(PI), sin(PI/2));
    printf("PI = 3.141596: sin(PI) = %.9lf, sin(PI/2) = %.9lf\n", sin(D_PI), sin(D_PI/2));
    double fpu_pi;
    __asm__ (
        ".intel_syntax noprefix\n\t"
        "fldpi\n\t"
        "fstp %0"
        : "=m" (fpu_pi)
    );
    printf("PI = FPU_VALUE: sin(PI) = %.9lf, sin(PI/2) = %.9lf\n", sin(fpu_pi), sin(fpu_pi/2));
}