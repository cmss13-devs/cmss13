
//CPU lag shit
#define calculateticks(x)	x * world.tick_lag // Converts your ticks to proper tenths.
#define tcheck(CPU,TOSLEEP)	if(world.cpu > CPU) sleep(calculateticks(TOSLEEP)) //Shorthand of checking and then sleeping a process based on world CPU

#define subtypesof(A) (typesof(A) - A)

#define FOR_DVIEW(type, range, center, invis_flags) \
	dview_mob.loc = center;           \
	dview_mob.see_invisible = invis_flags; \
	for(type in view(range, dview_mob))

#define CLAMP01(x) (Clamp(x, 0, 1))
