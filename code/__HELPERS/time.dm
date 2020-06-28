#define SECOND *10
#define SECONDS *10

#define MINUTE *600
#define MINUTES *600

#define HOURS *36000

#define SECONDS_1 		10
#define SECONDS_2 		20
#define SECONDS_3 		30
#define SECONDS_4 		40
#define SECONDS_5 		50
#define SECONDS_6 		60
#define SECONDS_7 		70
#define SECONDS_8 		80
#define SECONDS_10 		100
#define SECONDS_12 		120
#define SECONDS_15 		150
#define SECONDS_20      200
#define SECONDS_30 		300
#define SECONDS_40 		400
#define SECONDS_45      450
#define SECONDS_50      500
#define SECONDS_55 		550
#define SECONDS_60 		600
#define SECONDS_90 		900
#define SECONDS_100 	1000
#define SECONDS_150 	1500
#define SECONDS_200 	2000
#define MINUTES_1 		600
#define MINUTES_2 		1200
#define MINUTES_3 		1800
#define MINUTES_4 		2400
#define MINUTES_5 		3000
#define MINUTES_6 		3600
#define MINUTES_8		4800
#define MINUTES_10 		6000
#define MINUTES_15 		9000
#define MINUTES_20 		12000
#define MINUTES_25 		15000
#define MINUTES_30 		18000
#define MINUTES_35 		21000
#define MINUTES_40 		24000
#define MINUTES_45 		27000
#define HOURS_1 		36000
#define HOURS_2 		72000
#define HOURS_3 		108000
#define HOURS_6 		216000
#define HOURS_9 		324000

// Real time that is still reliable even when the round crosses over midnight time reset.
#define REALTIMEOFDAY (world.timeofday + (864000 * MIDNIGHT_ROLLOVER_CHECK))
#define MIDNIGHT_ROLLOVER_CHECK ( rollovercheck_last_timeofday != world.timeofday ? update_midnight_rollover() : midnight_rollovers )

var/midnight_rollovers = 0
var/rollovercheck_last_timeofday = 0

/proc/update_midnight_rollover()
	if(world.timeofday < rollovercheck_last_timeofday) //TIME IS GOING BACKWARDS!
		return midnight_rollovers++
	return midnight_rollovers


/proc/worldtime2text(time = world.time) // Shows current time starting at noon 12:00 (station time)
	return "[round(time / HOURS_1)+12]:[(time / MINUTES_1 % 60) < 10 ? add_zero(time / MINUTES_1 % 60, 1) : time / MINUTES_1 % 60]"

/proc/time_stamp() // Shows current GMT time
	return time2text(world.timeofday, "hh:mm:ss")

/proc/duration2text(time = world.time) // Shows current time starting at 0:00
	return "[round(time / HOURS_1)]:[(time / MINUTES_1 % 60) < 10 ? add_zero(time / MINUTES_1 % 60, 1) : time / MINUTES_1 % 60]"

/proc/duration2text_sec(time = world.time) // shows minutes:seconds
	return "[(time / MINUTES_1 % 60) < 10 ? add_zero(time / MINUTES_1 % 60, 1) : time / MINUTES_1 % 60]:[(time / SECONDS_1 % 60) < 10 ? add_zero(time / SECONDS_1 % 60, 1) : time / SECONDS_1 % 60]"


/proc/text2duration(text = "00:00") // Attempts to convert time text back to time value
	var/split_text = splittext(text, ":")
	var/time_hours = text2num(split_text[1]) * HOURS_1
	var/time_minutes = text2num(split_text[2]) * MINUTES_1
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
