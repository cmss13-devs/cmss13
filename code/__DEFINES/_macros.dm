
//CPU lag shit

/// Converts your ticks to proper tenths.
#define calculateticks(x) x * world.tick_lag
/// Shorthand of checking and then sleeping a process based on world CPU.
#define tcheck(CPU,TOSLEEP) if(world.cpu > CPU) sleep(calculateticks(TOSLEEP))

#define subtypesof(A) (typesof(A) - A)

/// Takes a datum as input, returns its ref string, or a cached version of it
/// This allows us to cache \ref creation, which ensures it'll only ever happen once per datum, saving string tree time
/// It is slightly less optimal then a []'d datum, but the cost is massively outweighed by the potential savings
/// It will only work for datums mind, for datum reasons
/// : because of the embedded typecheck
#define text_ref(datum) (isdatum(datum) ? (datum:cached_ref ||= "\ref[datum]") : ("\ref[datum]"))

#define addToListNoDupe(L, index) if(L) L[index] = null; else L = list(index)

#define protected_by_pylon(protection, T) (T.get_pylon_protection_level() >= protection)

#define CAN_PICKUP(M, A) (ishuman(M) && A.Adjacent(M) && !M.is_mob_incapacitated() && M.stat == CONSCIOUS)
