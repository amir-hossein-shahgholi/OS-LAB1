#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
    int reg_for_restore;
    int num = atoi(argv[1]);
    asm volatile(
        "movl %%ebx, %0;"
        "movl %1, %%ebx;"
        : "=r" (reg_for_restore)
        : "r" (num)
    );
    printf(1, "count: %d\n", get_callers());
    asm("movl %0, %%ebx;" : : "r" (reg_for_restore));
    exit();
}