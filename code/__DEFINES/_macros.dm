
//CPU lag shit

/// Converts your ticks to proper tenths.
#define calculateticks(x) x * world.tick_lag
/// Shorthand of checking and then sleeping a process based on world CPU.
#define tcheck(CPU,TOSLEEP) if(world.cpu > CPU) sleep(calculateticks(TOSLEEP))

#define subtypesof(A) (typesof(A) - A)

/// Takes a datum as input, returns its ref string
#define text_ref(datum) ref(datum)

#define addToListNoDupe(L, index) if(L) L[index] = null; else L = list(index)

#define protected_by_pylon(protection, T) (T.get_pylon_protection_level() >= protection)

#define CAN_PICKUP(M, A) (ishuman(M) && A.Adjacent(M) && !M.is_mob_incapacitated() && M.stat == CONSCIOUS)
