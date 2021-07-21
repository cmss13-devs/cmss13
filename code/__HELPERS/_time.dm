#define MIDNIGHT_ROLLOVER		864000	//number of deciseconds in a day

#define SECONDS *10

#define MINUTES *600

#define HOURS *36000

#define MINUTES_TO_DECISECOND *600
#define MINUTES_TO_HOURS /60

#define DECISECONDS_TO_HOURS /36000

#define XENO_LEAVE_TIMER_LARVA 6 SECONDS
#define XENO_LEAVE_TIMER 30 SECONDS

var/midnight_rollovers = 0
var/rollovercheck_last_timeofday = 0

// Real time that is still reliable even when the round crosses over midnight time reset.
#define REALTIMEOFDAY (world.timeofday + (864000 * MIDNIGHT_ROLLOVER_CHECK))
#define MIDNIGHT_ROLLOVER_CHECK ( rollovercheck_last_timeofday != world.timeofday ? update_midnight_rollover() : midnight_rollovers )

/proc/update_midnight_rollover()
	if(world.timeofday < rollovercheck_last_timeofday)
		midnight_rollovers++

	rollovercheck_last_timeofday = world.timeofday
	return midnight_rollovers

//Returns the world time in english
/proc/worldtime2text(time = world.time)
	return gameTimestamp("hh:mm", time + 12 HOURS)

/proc/gameTimestamp(format = "hh:mm:ss", wtime=null)
	if(!wtime)
		wtime = world.time
	return time2text(wtime - GLOB.timezoneOffset, format)

/proc/time_stamp() // Shows current GMT time
	return time2text(world.timeofday, "hh:mm:ss")

/proc/duration2text(time = world.time) // Shows current time starting at 0:00
	return gameTimestamp("hh:mm", time)

/proc/duration2text_sec(time = world.time) // shows minutes:seconds
	return gameTimestamp("mm:ss", time)

/proc/time_left_until(target_time, current_time, time_unit)
	return CEILING(target_time - current_time, 1) / time_unit

/proc/text2duration(text = "00:00") // Attempts to convert time text back to time value
	var/split_text = splittext(text, ":")
	var/time_hours = text2num(split_text[1]) * 1 HOURS
	var/time_minutes = text2num(split_text[2]) * 1 MINUTES
	return time_hours + time_minutes

/* Preserving this so future generations can see how fucking retarded some people are
/proc/time_stamp()
	var/hh = text2num(time2text(world.timeofday, "hh")) // Set the hour
	var/mm = text2num(time2text(world.timeofday, "mm")) // Set the minute
	var/ss = text2num(time2text(world.timeofday, "ss")) // Set the second
	var/ph
	var/pm
	var/ps
	if(hh < 10) ph = "0"
	if(mm < 10) pm = "0"
	if(ss < 10) ps = "0"
	return"[ph][hh]:[pm][mm]:[ps][ss]"
*/

#define is_day(day) day == text2num(time2text(world.timeofday, "DD"))
#define is_month(month) month == text2num(time2text(world.timeofday, "MM"))

#define TICKS *world.tick_lag

#define DS2TICKS(DS) ((DS)/world.tick_lag)

#define TICKS2DS(T) ((T) TICKS)

//Takes a value of time in deciseconds.
//Returns a text value of that number in hours, minutes, or seconds.
/proc/DisplayTimeText(time_value, round_seconds_to = 0.1)
	var/second = FLOOR(time_value * 0.1, round_seconds_to)
	if(!second)
		return "right now"
	if(second < 60)
		return "[second] second[(second != 1)? "s":""]"
	var/minute = FLOOR(second / 60, 1)
	second = FLOOR(MODULUS(second, 60), round_seconds_to)
	var/secondT
	if(second)
		secondT = " and [second] second[(second != 1)? "s":""]"
	if(minute < 60)
		return "[minute] minute[(minute != 1)? "s":""][secondT]"
	var/hour = FLOOR(minute / 60, 1)
	minute = MODULUS(minute, 60)
	var/minuteT
	if(minute)
		minuteT = " and [minute] minute[(minute != 1)? "s":""]"
	if(hour < 24)
		return "[hour] hour[(hour != 1)? "s":""][minuteT][secondT]"
	var/day = FLOOR(hour / 24, 1)
	hour = MODULUS(hour, 24)
	var/hourT
	if(hour)
		hourT = " and [hour] hour[(hour != 1)? "s":""]"
	return "[day] day[(day != 1)? "s":""][hourT][minuteT][secondT]"
