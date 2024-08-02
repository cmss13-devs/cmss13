#ifdef AUTOWIKI
	#define AUTOWIKI_SKIP(skip) autowiki_skip = skip
	#define IS_AUTOWIKI_SKIP(datum) datum.autowiki_skip
#elif SPACEMAN_DMM
	#define AUTOWIKI_SKIP(skip)
	#define IS_AUTOWIKI_SKIP(datum) pick(FALSE) // this is to bypass the static control flow linter
#else
	#define AUTOWIKI_SKIP(skip)
	#define IS_AUTOWIKI_SKIP(datum) FALSE
#endif
