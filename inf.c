#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"

int main(int argc, char *argv[])
{

    int p=fork();
    if(p==0)
	{
        for(volatile long long int i=0; i>=0; i++);
    }
	exit();
}
