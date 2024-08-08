#ifdef AUTOWIKI
	#define AUTOWIKI_SKIP(skip) autowiki_skip = skip
	#define IS_AUTOWIKI_SKIP(datum) datum.autowiki_skip
#else
	#define AUTOWIKI_SKIP(skip)
	#define IS_AUTOWIKI_SKIP(datum) UNLINT(FALSE)
#endif
