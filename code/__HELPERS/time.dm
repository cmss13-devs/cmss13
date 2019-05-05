#define SECOND *10
#define SECONDS *10

#define MINUTE *600
#define MINUTES *600

#define SECONDS_1 		10
#define SECONDS_2 		20
#define SECONDS_4 		40
#define SECONDS_5 		50
#define SECONDS_7 		70
#define SECONDS_10 		100
#define SECONDS_15 		150
#define SECONDS_20      200
#define SECONDS_30 		300
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
#define MINUTES_10 		6000
#define MINUTES_15 		9000
#define MINUTES_20 		12000
#define MINUTES_25 		15000
#define MINUTES_30 		18000
#define MINUTES_35 		21000
#define MINUTES_40 		24000
#define MINUTES_45 		27000
#define HOURS_1 		36000


proc/worldtime2text(time = world.time) // Shows current time starting at noon 12:00 (station time)
	return "[round(time / HOURS_1)+12]:[(time / MINUTES_1 % 60) < 10 ? add_zero(time / MINUTES_1 % 60, 1) : time / MINUTES_1 % 60]"

proc/time_stamp() // Shows current GMT time
	return time2text(world.timeofday, "hh:mm:ss")

proc/duration2text(time = world.time) // Shows current time starting at 0:00
	return "[round(time / HOURS_1)]:[(time / MINUTES_1 % 60) < 10 ? add_zero(time / MINUTES_1 % 60, 1) : time / MINUTES_1 % 60]"

/* Preserving this so future generations can see how fucking retarded some people are
proc/time_stamp()
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

/* Returns 1 if it is the selected month and day */
proc/isDay(var/month, var/day)
	if(isnum(month) && isnum(day))
		var/MM = text2num(time2text(world.timeofday, "MM")) // get the current month
		var/DD = text2num(time2text(world.timeofday, "DD")) // get the current day
		if(month == MM && day == DD)
			return 1

		// Uncomment this out when debugging!
		//else
			//return 1
