#include <iostream>
#include <fstream>

int main()
{
	std::ofstream ostr("test.chr");

	for(int ii=0;ii<8196;++ii)
		ostr<<(char)0x00;

	ostr.close();

	return 0;
}