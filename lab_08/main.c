#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void copyStr(char *str, char *str1, size_t size);

int main()
{
    char str[255];
    fgets(str, 255, stdin);
    // str[0] = '\0';
    printf("C strlen: %zu\n", strlen(str));

    size_t len = 0;
    __asm__ ( ".intel_syntax noprefix\n\t"
        "mov rdi, %1\n\t"
        "mov al, 0\n\t"
        "mov ecx, 255\n\t"
        "repnz\n\t"
        "scasb\n\t"
        "mov rax, 255\n\t"
        "sub eax, ecx\n\t"
        "dec eax\n\t"
        "mov %0, rax\n\t"
        : "=r" (len)
        : "r" (str)
        : "ecx", "rax", "al", "rdi"
    );

    printf("ASM strlen: %zu\n", len);

    printf("\nstr = %s\n", str);

    char str1[255];
    copyStr(str1, str, len);
    printf("copied str to str1: str1 = %s\n", str1);
    
    str1[0] = 'F';
    printf("changed str1[0]: str1 = %s\n", str1);

    copyStr(str, str1, len);
    printf("copied str1 to str: str = %s\n", str);

    char str2[255];
    strcpy(str2, "abrakadabrabumbarabum");
    printf("str2 = %s\n", str2);

    copyStr(str, str2, 21);
    printf("copied str2 to str (less size): str = %s\n", str);

    char str3[255];
    strcpy(str3, "");

    copyStr(str1, str3, 0);
    printf("copied str3 to str1 (bigger size): str1 = %s\n", str1);

    copyStr(str3, str2, 21);
    printf("copied str2 to str3 (less size): str3 = %s\n", str3);

    copyStr(str2, str1, 0);
    printf("copied str1 to str2 (bigger size): str2 = %s\n", str2);

    copyStr(str, str + 4, 17);
    printf("copied str + 4 to str: str = %s\n", str);

    copyStr(str + 4, str, 17);
    printf("copied str to str+4: str = %s\n", str);

    copyStr(str, str, 21);
    printf("copy to itself: str = %s\n", str);

    str[10] = '\0';
    copyStr(str + 11, str, 10);
    str[10] = ' ';
    printf("copy to the next part of memory: str = %s\n", str);

    return 0;
}