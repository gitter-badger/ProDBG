#include "file.h"
#include <stdio.h>
#include <stdlib.h>

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void* File_loadToMemory(const char* filename, size_t* size, size_t padAllocSize)
{
	FILE* f = fopen(filename, "rb");
	void* data;
	size_t s;

	*size = 0; 

	if (!f)
		return 0;

	// TODO: Use fstat here?

	fseek(f, 0, SEEK_END); // seek to end of file
	s = (size_t)ftell(f); // get current file pointer
	fseek(f, 0, SEEK_SET); // seek back to beginning of file

	data = malloc(s + padAllocSize);

	if (!data)
		return 0;

	fread(data, s, 1, f);

	*size = s;

	fclose(f);

	return data;
}


