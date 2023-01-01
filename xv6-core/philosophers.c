#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) 
{
    for (int i = 0 ; i < 6 ; i++)    // i=5 used for writes lock 
    { 
        sem_init(i,1); // Each spoon can be used by one person.
    }

    for (int i = 0 ; i < 5 ; i++)
    {
        int pid = fork();
        if (pid == 0)
        {
            char arg[1];
            arg[0] = i + 48; // Int to string.
            char *name = "philosopher";
            char *map[] = {name, arg, 0};
            exec("philosopher", map); 
        }
    }
    printf(1, "The Philosophers started dinner.\n");
    for (int i = 0 ; i < 5 ; i++) 
        wait();
    exit();
}
