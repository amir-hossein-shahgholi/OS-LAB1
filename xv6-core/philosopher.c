#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]){   

    int phil_id = atoi(argv[1]); // string to int

    sem_acquire(5); //To prevent writing together
    printf(1, "Philosopher %d ready.\n", phil_id);
    sem_release(5);

    while (1)
    {
        if (phil_id % 2 == 0) // Lock spoons
        {
            sem_acquire(phil_id); 
            sem_acquire((phil_id+1)%5);
        } else 
        {
            sem_acquire((phil_id+1)%5);
            sem_acquire(phil_id);
        }

        sleep(200);
        sem_acquire(5);
        printf(1,"Philosopher %d started eating by spoons (%d, %d).\n",phil_id,phil_id,(phil_id+1)%5);
        sem_release(5);

        sem_release(((phil_id+1)%5));// Free spoons
        sem_release(phil_id); 

        sleep(100);
        sem_acquire(5);
        printf(1,"Philosopher %d is thinking.\n",phil_id);
        sem_release(5);
        
    }
    
    exit();
}
