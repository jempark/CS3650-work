#include <stdio.h>
#include <stdlib.h> 

long 
calculate(long x, char y, long z)
{
	if (y == '+')
       	{
	    return x + z;
	}
	else if (y == '-')
	{
	    return x - z;
	}
	else if (y == '*')
	{
	    return x * z; 
	}
	else
	{
	    return x / z;
	}
}

int 
main(int argc, char* argv[]) 
{
	if (argc != 4) {
        printf("Usage:\n %s N op N\n", argv[0]);
	    return 1;
	}

    long x = atol(argv[1]);
    long z = atol(argv[3]);
    char y = argv[2][0]; 

    if (y != '+' && y != '-' && y != '*' && y != '/') 
    {
        printf("Usage:\n %s N op N\n", argv[0]);  
        return 1;       
    }

	long result = calculate(x, y, z); 

	printf("%ld %c %ld = %ld\n", x, y, z, result);
	return 0;
}
