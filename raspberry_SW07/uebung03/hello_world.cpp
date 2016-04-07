#include <stdio.h>
class test
{
	public:
		test(int A, int B): a(A), b(B) {}
		~test(){}
		int a;
		int b;
};
main(const int argc, const char * argv[])
{
	test t(1,2);
	printf("hello C++ world\n");
	printf("class members are: a = %d, b = %d\n", t.a, t.b);
	return(0);
}
