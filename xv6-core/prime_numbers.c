#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

void prime_numbers(int argc, char *argv[])
{
    char* FILE_NAME = "prime_numbers.txt";
    int fd = open(FILE_NAME, O_CREATE | O_WRONLY);
    for (int i=atoi(argv[1]); i<=atoi(argv[2]); i++)
        {
        int flag=0;
        for (int j=2; j<i; j++)
            if (i%j == 0)
            {
                flag =1;
                break;
            }
        if (flag==0)
        {
            printf(fd, "%d\n", i);
        }
        }
        close(fd);
    exit();
}
