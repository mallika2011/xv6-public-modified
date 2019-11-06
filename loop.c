#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"

int main(int argc, char *argv[])
{

    // for (volatile long long int j = 0; j < 3; j++)
    // {
    //     int p = fork();
    //     if (p == 0)
    //     {
    //         long long int x = 0;
    //         for (volatile long long int i = 0; i < 10000000; i++)
    //         {
    //             x++;
    //         }
    //     }
    // }
    int p=fork();
    if(p==0)
    {
            long long int x = 0;

        for (volatile long long int i = 0; i < 1000000*atoi(argv[1]); i++)
            {
                x++;
            }
        printf(1,"********************%d*****************************\n", atoi(argv[1]));
    }
    exit();
}
