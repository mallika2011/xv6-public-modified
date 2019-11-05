
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"

int main(int argc, char *argv[])
{

	int pid;
	int status = 0, a, b;
	if (argc < 3)
	{
		printf(1, "Usage: set_priority <pid> <priority>\n");
		exit();
	}
	else
	{
        if(set_priority(atoi(argv[1]),atoi(argv[2]))<0)
            printf(1,"Error: No such process\n");
	}

	exit();
}
