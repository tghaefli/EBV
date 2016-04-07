#include <stdio.h>
#include <stdlib.h>
#include "func.h"
main(const int argc, const char * argv[])
{
	double i1 = 1.1;
	double i2 = 3.4;
	if(argc > 1)
	{
		i2 = atof(argv[1]);
	}
	printf("hello C-world\n");
	printf("sum of %2.3f, %2.3f is %2.3f\n", i1, i2, add_d(i1, i2));
	printf("product of %2.3f, %2.3f is %2.3f \n", i1, i2, mul_d(i1, i2));
	return(0);
}
