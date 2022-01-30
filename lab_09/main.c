void mfpu(void);
void mnofpu(void);
void asm_prod(void);
void countsin(void);

int main(void)
{
    mfpu();
    mnofpu();
    asm_prod();
    countsin();
    
    return 0;
}