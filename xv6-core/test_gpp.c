#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
    int p0, p1, p2;
    p0 = fork();
    p1 = fork();
    if (p1 && p0 == 0)
        printf(1,"parent=%d\n", get_parent_pid());

    p2 = fork();
    if (p2 && p1 == 0 && p0 == 0)
        printf(1, "parent=%d\n", get_parent_pid());
        
    while(wait() != -1);
    exit();

}