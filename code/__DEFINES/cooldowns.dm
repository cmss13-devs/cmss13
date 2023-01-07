#define COOLDOWN_MOB_AUDIO "mob_audio_cooldown"

//TIMER COOLDOWN MACROS

#define COMSIG_CD_STOP(cd_index) "cooldown_[cd_index]"
#define COMSIG_CD_RESET(cd_index) "cd_reset_[cd_index]"

#define TIMER_COOLDOWN_START(cd_source, cd_index, cd_time) LAZYSET(cd_source.cooldowns, cd_index, addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(end_cooldown), cd_source, cd_index), cd_time))

#define TIMER_COOLDOWN_CHECK(cd_source, cd_index) LAZYACCESS(cd_source.cooldowns, cd_index)

#define TIMER_COOLDOWN_END(cd_source, cd_index) LAZYREMOVE(cd_source.cooldowns, cd_index)

/*
 * Stoppable timer cooldowns.
 * Use indexes the same as the regular tiemr cooldowns.
 * They make use of the TIMER_COOLDOWN_CHECK() and TIMER_COOLDOWN_END() macros the same, just not the TIMER_COOLDOWN_START() one.
 * A bit more expensive than the regular timers, but can be reset before they end and the time left can be checked.
*/

#define S_TIMER_COOLDOWN_START(cd_source, cd_index, cd_time) LAZYSET(cd_source.cooldowns, cd_index, addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(end_cooldown), cd_source, cd_index), cd_time, TIMER_STOPPABLE))

#define S_TIMER_COOLDOWN_RESET(cd_source, cd_index) reset_cooldown(cd_source, cd_index)

#define S_TIMER_COOLDOWN_TIMELEFT(cd_source, cd_index) (timeleft(TIMER_COOLDOWN_CHECK(cd_source, cd_index)))

/*
 * Cooldown system based on storing world.time on a variable, plus the cooldown time.
 * Better performance over timer cooldowns, lower control. Same functionality.
*/

#define COOLDOWN_DECLARE(cd_index) var/##cd_index = 0

#define COOLDOWN_START(cd_source, cd_index, cd_time) (cd_source.cd_index = world.time + (cd_time))

//Returns true if the cooldown has run its course, false otherwise
#define COOLDOWN_FINISHED(cd_source, cd_index) (cd_source.cd_index < world.time)

#define COOLDOWN_RESET(cd_source, cd_index) cd_source.cd_index = 0

#define COOLDOWN_TIMELEFT(cd_source, cd_index) (max(0, cd_source.cd_index - world.time))

/// just pre-divides the result by 10 to give an output in seconds
#define COOLDOWN_SECONDSLEFT(cd_source, cd_index) ((max(0, cd_source.cd_index - world.time))/10)

//cooldowns themselves as defines
#define COOLDOWN_ORBIT_CHANGE "cooldown_orbit_change"
