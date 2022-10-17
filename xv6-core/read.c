#include "types.h"
#include "user.h"
#include "fcntl.h"
#include "stat.h"
#include "read.h"
void read_file(char *buffer)
{
    char *FILE_NAME = "cmd_history.txt";
    int fd = open(FILE_NAME,  O_CREATE | O_RDWR);
    read(fd, buffer, sizeof(buffer));
    close(fd);
}