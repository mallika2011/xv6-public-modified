#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"

int main(int argc, char *argv[])
{

	int pid;
	int status = 0, a, b;
	if (argc < 2)
	{
		printf(1, "Usage: time <process>\n");
		exit();
	}
	else
	{
		pid = fork();
		if (pid == 0)
		{
			exec(argv[1], argv);
			printf(1, "Exec %s Failed\n", argv[1]);
			exit();
		}
		else
		{
			status = waitx(&a, &b);
			printf(1, "Wait Time = %d\nRun Time = %d with Status %d \n", a, b, status);
		}
	}

	exit();
}
