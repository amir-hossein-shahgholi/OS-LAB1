#include "types.h"
#include "stat.h"
#include "user.h"
#include "syscall.h"

int main(int argc, char *argv[])
{
    int typical_count = 3;
    int arr[] = {SYS_write, SYS_fork, SYS_wait};
    char *p[] = {"SYS_write", "SYS_fork", "SYS_wait"};
    int i;
    for(i = 0; i < typical_count; i++){
        printf(1, "syscall %d %s\n", arr[i], p[i]);
        int reg_for_restore;
        asm volatile(
            "movl %%ebx, %0;"
            "movl %1, %%ebx;"
            : "=r" (reg_for_restore)
            : "r" (arr[i])
        );
        get_callers();
        asm("movl %0, %%ebx;" : : "r" (reg_for_restore));
    }
    exit();
}