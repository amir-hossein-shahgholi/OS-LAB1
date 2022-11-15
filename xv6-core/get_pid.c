#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

void get_pid(int argc, char *argv[])
{
    int pid = getpid();
    printf(1, "Pid = %d\n", pid);
    exit();
}
