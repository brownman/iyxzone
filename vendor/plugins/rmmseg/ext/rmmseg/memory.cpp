#include "memory.h"

#define PRE_ALLOC_SIZE 2097152 /* 2MB */

namespace rmmseg
{
		int pool_mem_usage = 2097152;
    char *_pool_base = static_cast<char *>(std::malloc(PRE_ALLOC_SIZE));
    int   _pool_size = PRE_ALLOC_SIZE;
}