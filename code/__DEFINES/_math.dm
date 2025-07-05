/**
 * Get the turf that `A` resides in, regardless of any containers.
 *
 * Use in favor of `A.loc` or `src.loc` so that things work correctly when
 * stored inside an inventory, locker, or other container.
 */
#define get_turf(A) (get_step(A, 0))

#define CARDINAL_DIRS list(1,2,4,8)
#define CARDINAL_ALL_DIRS list(1,2,4,5,6,8,9,10)

#define LEFT 1
#define RIGHT 2

#define CEILING(x, y) ( ceil((x) / (y)) * (y) )

// round() acts like floor(x, 1) by default but can't handle other values
#define FLOOR(x, y) ( floor((x) / (y)) * (y) )

// Returns true if val is from min to max, inclusive.
#define ISINRANGE(val, min, max) ((min) <= (val) && (val) <= (max))

// Same as above, exclusive.
#define ISINRANGE_EX(val, min, max) ((min) < (val) && (val) < (max))

/// Gets the sign of x, returns -1 if negative, 0 if 0, 1 if positive
#define SIGN(x) ( ((x) > 0) - ((x) < 0) )

/// Performs a linear interpolation between a and b. Note that amount=0 returns a, amount=1 returns b, and amount=0.5 returns the mean of a and b.
#define LERP(a, b, amount) ( (amount) ? ((a) + ((b) - (a)) * (amount)) : (a) )

/// Converts a probability/second chance to probability/delta_time chance


/// For example, if you want an event to happen with a 10% per second chance, but your proc only runs every 5 seconds, do `if(prob(100*DT_PROB_RATE(0.1, 5)))`


#define DT_PROB_RATE(prob_per_second, delta_time) (1 - (1 - (prob_per_second)) ** (delta_time))





/// Like DT_PROB_RATE but easier to use, simply put `if(DT_PROB(10, 5))`


#define DT_PROB(prob_per_second_percent, delta_time) (prob(100*DT_PROB_RATE((prob_per_second_percent)/100, (delta_time))))
