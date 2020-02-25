#include <stdio.h>
#include <stdlib.h>

long
fib(long x) 
{
	if (x <= 1) {
	    return x;
	}
	
	return fib(x - 1) + fib(x - 2);
}


int
main(int argc, char* argv[])
{

    if (argc != 2) {
        printf("Usage:\n %s N, where N >= 0\n", argv[0]);
        return 1;
    }

    long x = atol(argv[1]);

    if (x < 0) {
	printf("Usage:\n %s N, where N >= 0\n", argv[0]);
	return 1;
    }

    printf("fib(%ld) = %ld\n", atol(argv[1]), fib(x));
    return 0;
}
