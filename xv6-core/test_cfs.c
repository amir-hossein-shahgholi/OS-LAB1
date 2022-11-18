#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]){
    change_file_size(argv[1], atoi(argv[2]));
    exit();
}