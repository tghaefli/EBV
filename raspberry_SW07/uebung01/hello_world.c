#include <stdio.h>
main(const int argc, const char * argv[])
{
	int i;
	printf("hello C-world\n");
	for(i = 0; i < argc; i++) {
		printf("the %d-th argument is %s\n", i, argv[i]);
	}
	return(0);
}
