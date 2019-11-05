#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"

int main(int argc, char *argv[])
{

    if (argc > 1)
    {
        printf(1, "Usage: ps\n");
    }
    else
    {
        ps();
    }

    exit();
}
