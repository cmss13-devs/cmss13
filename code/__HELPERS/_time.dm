#define MIDNIGHT_ROLLOVER 864000 //number of deciseconds in a day

#define MILLISECONDS *0.01

#define DECISECONDS *1 //the base unit all of these defines are scaled by, because byond uses that as a unit of measurement for some fucking reason

#define SECONDS *10

#define MINUTES *600

#define HOURS *36000

#define MINUTES_TO_DECISECOND *600
#define MINUTES_TO_HOURS /60

#define DECISECONDS_TO_HOURS /36000

GLOBAL_VAR_INIT(midnight_rollovers, 0)
GLOBAL_VAR_INIT(rollovercheck_last_timeofday, 0)

// Real time that is still reliable even when the round crosses over midnight time reset.
#define REALTIMEOFDAY (world.timeofday + (864000 * MIDNIGHT_ROLLOVER_CHECK))
#define MIDNIGHT_ROLLOVER_CHECK ( GLOB.rollovercheck_last_timeofday != world.timeofday ? update_midnight_rollover() : GLOB.midnight_rollovers )

/proc/update_midnight_rollover()
	if(world.timeofday < GLOB.rollovercheck_last_timeofday)
		GLOB.midnight_rollovers++

	GLOB.rollovercheck_last_timeofday = world.timeofday
	return GLOB.midnight_rollovers

///Returns the world time in english. Do not use to get date information - starts at 0 + a random time offset from 10 minutes to 24 hours.
/proc/worldtime2text(format = "hh:mm", time = world.time)
	return gameTimestamp(format, time + GLOB.time_offset)

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
	return ceil(target_time - current_time) / time_unit

/proc/text2duration(text = "00:00") // Attempts to convert time text back to time value
	var/split_text = splittext(text, ":")
	var/time_hours = text2num(split_text[1]) * 1 HOURS
	var/time_minutes = text2num(split_text[2]) * 1 MINUTES
	return time_hours + time_minutes

#define is_day(day) day == text2num(time2text(world.timeofday, "DD"))
#define is_month(month) month == text2num(time2text(world.timeofday, "MM"))

#define TICKS *world.tick_lag

#define DS2TICKS(DS) ((DS)/world.tick_lag)

#define TICKS2DS(T) ((T) TICKS)

#define MS2DS(T) ((T) MILLISECONDS)

#define DS2MS(T) ((T) * 100)

//Takes a value of time in deciseconds.
//Returns a text value of that number in hours, minutes, or seconds.
/proc/DisplayTimeText(time_value, round_seconds_to = 0.1)
	var/second = FLOOR(time_value * 0.1, round_seconds_to)
	if(!second)
		return "right now"
	if(second < 60)
		return "[second] second[(second != 1)? "s":""]"
	var/minute = floor(second / 60)
	second = FLOOR(second %% 60, round_seconds_to)
	var/secondT
	if(second)
		secondT = " and [second] second[(second != 1)? "s":""]"
	if(minute < 60)
		return "[minute] minute[(minute != 1)? "s":""][secondT]"
	var/hour = floor(minute / 60)
	minute %%= 60
	var/minuteT
	if(minute)
		minuteT = " and [minute] minute[(minute != 1)? "s":""]"
	if(hour < 24)
		return "[hour] hour[(hour != 1)? "s":""][minuteT][secondT]"
	var/day = floor(hour / 24)
	hour %%= 24
	var/hourT
	if(hour)
		hourT = " and [hour] hour[(hour != 1)? "s":""]"
	return "[day] day[(day != 1)? "s":""][hourT][minuteT][secondT]"

/*

Days of the week to make it easier to reference them.

When using time2text(), please use "DDD" to find the weekday. Refrain from using "Day"

*/
#define MONDAY "Mon"
#define TUESDAY "Tue"
#define WEDNESDAY "Wed"
#define THURSDAY "Thu"
#define FRIDAY "Fri"
#define SATURDAY "Sat"
#define SUNDAY "Sun"

//Months

#define JANUARY 1
#define FEBRUARY 2
#define MARCH 3
#define APRIL 4
#define MAY 5
#define JUNE 6
#define JULY 7
#define AUGUST 8
#define SEPTEMBER 9
#define OCTOBER 10
#define NOVEMBER 11
#define DECEMBER 12

//Select holiday names -- If you test for a holiday in the code, make the holiday's name a define and test for that instead
#define NEW_YEAR "New Year"
#define VALENTINES "Valentine's Day"
#define APRIL_FOOLS "April Fool's Day"
#define ST_PATRICK "Saint Patrick's Day"

#define EASTER "Easter"
#define HALLOWEEN "Halloween"
#define CHRISTMAS "Christmas"
#define FESTIVE_SEASON "Festive Season"
#define HOTDOG_DAY "National Hot Dog Day"

/*Timezones*/

/// Line Islands Time
#define TIMEZONE_LINT 14

// Chatham Daylight Time
#define TIMEZONE_CHADT 13.75

/// Tokelau Time
#define TIMEZONE_TKT 13

/// Tonga Time
#define TIMEZONE_TOT 13

/// New Zealand Daylight Time
#define TIMEZONE_NZDT 13

/// New Zealand Standard Time
#define TIMEZONE_NZST 12

/// Norfolk Time
#define TIMEZONE_NFT 11

/// Lord Howe Standard Time
#define TIMEZONE_LHST 10.5

/// Australian Eastern Standard Time
#define TIMEZONE_AEST 10

/// Australian Central Standard Time
#define TIMEZONE_ACST 9.5

/// Australian Central Western Standard Time
#define TIMEZONE_ACWST 8.75

/// Australian Western Standard Time
#define TIMEZONE_AWST 8

/// Christmas Island Time
#define TIMEZONE_CXT 7

/// Cocos Islands Time
#define TIMEZONE_CCT 6.5

/// Central European Summer Time
#define TIMEZONE_CEST 2

/// Coordinated Universal Time
#define TIMEZONE_UTC 0

/// Eastern Daylight Time
#define TIMEZONE_EDT -4

/// Eastern Standard Time
#define TIMEZONE_EST -5

/// Central Daylight Time
#define TIMEZONE_CDT -5

/// Central Standard Time
#define TIMEZONE_CST -6

/// Mountain Daylight Time
#define TIMEZONE_MDT -6

/// Mountain Standard Time
#define TIMEZONE_MST -7

/// Pacific Daylight Time
#define TIMEZONE_PDT -7

/// Pacific Standard Time
#define TIMEZONE_PST -8

/// Alaska Daylight Time
#define TIMEZONE_AKDT -8

/// Alaska Standard Time
#define TIMEZONE_AKST -9

/// Hawaii-Aleutian Daylight Time
#define TIMEZONE_HDT -9

/// Hawaii Standard Time
#define TIMEZONE_HST -10

/// Cook Island Time
#define TIMEZONE_CKT -10

/// Niue Time
#define TIMEZONE_NUT -11

/// Anywhere on Earth
#define TIMEZONE_ANYWHERE_ON_EARTH -12
