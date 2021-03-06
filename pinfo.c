#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"
#include "mmu.h"
#include "param.h"
#include "proc.h"

int main(int argc, char *argv[])
{

    int pid;
    struct proc_stat p;

    if (argc < 2)
    {
        printf(1, "Usage: getpinfo <PID>\n");
        exit();
    }
    else
    {
        pid = atoi(argv[1]);
        if (getpinfo(&p, pid) ==-1)
        {
            printf(1, "Error: No such process\n");
            exit();
        }
        else if(getpinfo(&p, pid) ==-2)
        {
            printf(1,"Invalid priority\n");
            exit();
        }
        printf(1, "\033[01;33mProcess Details :\n\033[0m");
        printf(1, "\033[01;33mpid = %d\nnum_run = %d\ncurrent queue = %d\nruntime = %d\n\033[0m", p.pid, p.num_run, p.current_queue, p.runtime);
        for(int i=0; i<5; i++)
        {
            printf(1,"ticks[%d]=%d \t",i,p.ticks[i]);
        }
        printf(1,"\n");
        exit();
    }
}
