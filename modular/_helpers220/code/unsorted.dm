#define DECISECONDS_TO_DAYS /864000

/proc/text2time(datetime_str)
	var/list/date_time = splittext(datetime_str, " ")
	if(date_time.len != 2) return FALSE

	var/list/date_components = splittext(date_time[1], "-")
	if(date_components.len != 3) return FALSE
	var/year = text2num(date_components[1])
	var/month = text2num(date_components[2])
	var/day = text2num(date_components[3])

	var/list/time_components = splittext(date_time[2], ":")
	if(time_components.len != 3) return FALSE
	var/hour = text2num(time_components[1])
	var/minute = text2num(time_components[2])
	var/second = text2num(time_components[3])

	var/total_days = 0

	for(var/y = 2000 to year - 1)
		total_days += 365
		if(is_leap_year(y)) total_days++

	var/days_in_month = list(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
	if(is_leap_year(year)) days_in_month[2] = 29

	for(var/m = 1 to month - 1)
		total_days += days_in_month[m]

	total_days += day - 1

	var/total_seconds = total_days * 86400 + hour * 3600 + minute * 60 + second

	return total_seconds * 10

/proc/is_leap_year(y)
	return ((y % 4 == 0 && y % 100 != 0) || (y % 400 == 0))

/proc/days_from_time(time)
	var/delta_time = world.realtime - time
	return delta_time DECISECONDS_TO_DAYS

#undef DECISECONDS_TO_DAYS
