
//CPU lag shit
#define calculateticks(x)	x * world.tick_lag // Converts your ticks to proper tenths.
#define tcheck(CPU,TOSLEEP)	if(world.cpu > CPU) sleep(calculateticks(TOSLEEP)) //Shorthand of checking and then sleeping a process based on world CPU

#define subtypesof(A) (typesof(A) - A)

#define addToListNoDupe(L, index) if(L) L[index] = null; else L = list(index)