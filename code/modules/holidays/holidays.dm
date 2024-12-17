/datum/holiday
	///Name of the holiday itself. Visible to players.
	var/name = "If you see this the holiday calendar code is broken"

	///What day of begin_month does the holiday begin on?
	var/begin_day = 1
	///What month does the holiday begin on?
	var/begin_month = 0
	/// What day of end_month does the holiday end? Default of 0 means the holiday lasts a single.
	var/end_day = 0
	/// What month does the holiday end on?
	var/end_month = 0
	/// for christmas neverending, or testing. Forces a holiday to be celebrated.
	var/always_celebrate = FALSE
	/// Held variable to better calculate when certain holidays may fall on, like easter.
	var/current_year = 0
	/// How many years are you offsetting your calculations for begin_day and end_day on. Used for holidays like easter.
	var/year_offset = 0
	///Timezones this holiday is celebrated in (defaults to three timezones spanning a 50 hour window covering all timezones)
	var/list/timezones = list(TIMEZONE_LINT, TIMEZONE_UTC, TIMEZONE_ANYWHERE_ON_EARTH)
	///Custom text of greet message
	var/greet_text
	///Faction specific holidays
	var/holiday_faction

// When the round starts, this proc is ran to get a text message to display to everyone to wish them a happy holiday
/datum/holiday/proc/greet()
	if(!greet_text)
		return "Have a happy [name]!"
	else
		return greet_text

// Return 1 if this holidy should be celebrated today
/datum/holiday/proc/shouldCelebrate(dd, mm, yyyy, ddd)
	if(always_celebrate)
		return TRUE

	if(!end_day)
		end_day = begin_day
	if(!end_month)
		end_month = begin_month
	if(end_month > begin_month) //holiday spans multiple months in one year
		if(mm == end_month) //in final month
			if(dd <= end_day)
				return TRUE

		else if(mm == begin_month)//in first month
			if(dd >= begin_day)
				return TRUE

		else if(mm in begin_month to end_month) //holiday spans 3+ months and we're in the middle, day doesn't matter at all
			return TRUE

	else if(end_month == begin_month) // starts and stops in same month, simplest case
		if(mm == begin_month && (dd in begin_day to end_day))
			return TRUE

	else // starts in one year, ends in the next
		if(mm >= begin_month && dd >= begin_day) // Holiday ends next year
			return TRUE
		if(mm <= end_month && dd <= end_day) // Holiday started last year
			return TRUE

	return FALSE


// The actual holidays

// JANUARY

/datum/holiday/eastern_xmas
	name = "Orthodox Christmas"
	begin_day = 5
	begin_month = JANUARY
	greet_text = "Have a merry Christmas!"
	end_day = 9
	holiday_faction = FACTION_UPP

/datum/holiday/pharma
	name = "Pharmacist Day"
	begin_day = 12
	begin_month = JANUARY
	holiday_faction = FACTION_WY
	greet_text = "Celebrate a medicine producer who saves lives with their work!"

/datum/holiday/cleandesk
	name = "Clean Your Desk Day"
	begin_day = 13
	begin_month = JANUARY
	holiday_faction = FACTION_WY
	greet_text = "On this day, we must remember the importance of a clean working environment!"

/datum/holiday/australia
	name = "Australia Day"
	begin_day = 26
	begin_month = JANUARY
	holiday_faction = FACTION_TWE
	greet_text = "On this day, in the year of 1788, the First Fleet of the Royal Navy landed on the Australian soil and planted the Union flag, thus marking the establishment of Australian colony."

// FEBRUARY

/datum/holiday/legal
	name = "Employee Legal Awareness Day"
	begin_day = 16
	begin_month = FEBRUARY
	holiday_faction = FACTION_WY
	greet_text = "On this day, we must remember the importance of clear labor laws and transparent bureaucracy!"

/datum/holiday/innovation
	name = "Innovation Day"
	begin_day = 16
	begin_month = FEBRUARY
	holiday_faction = FACTION_WY
	greet_text = "On this day, we celebrate the importance of numerous innovations that we've made and will make in the future!"

/datum/holiday/japan
	name = "National Science Day"
	begin_day = 28
	begin_month = FEBRUARY
	holiday_faction = FACTION_WY
	greet_text = "Celebrated in Japanese parts of the TWE, marking the day of foundation of Japanese nation."

/datum/holiday/valentines
	name = VALENTINES
	begin_day = 13
	end_day = 15
	begin_month = FEBRUARY

/datum/holiday/armyday
	name = "Defender of the Fatherland Day"
	begin_day = 23
	greet_text = "Was originally the day celebrating Soviet Army in USSR, but later morphed into more generalized Men's Day in Russia, and later all across UPP."
	begin_month = FEBRUARY
	holiday_faction = FACTION_UPP

// MARCH

/datum/holiday/employee
	name = "Employee Appreciation Day"
	begin_day = 7
	begin_month = MARCH
	greet_text = "On this day, we must remember to respect and value our dear employees and workers!"
	holiday_faction = FACTION_WY

/datum/holiday/commonwealthday
	name = "Day of the Empire"
	begin_day = 10
	begin_month = MARCH
	greet_text = "Was originally celebrated as the Commonwealth Day, but was later reformed after foundation of the Three World Empire"
	holiday_faction = FACTION_TWE

/datum/holiday/holi
	name = "Holi"
	begin_day = 14
	begin_month = MARCH
	greet_text = "Holiday celebrated in Hindu parts of the TWE. Holi also known as Festival of Colours, the holiday celebrates the eternal and divine love of the deities Radha and Krishna."
	holiday_faction = FACTION_TWE

/datum/holiday/no_this_is_patrick
	name = "St. Patrick's Day"
	begin_day = 17
	begin_month = MARCH

// APRIL

/datum/holiday/april_fools
	name = APRIL_FOOLS
	begin_month = APRIL
	begin_day = 1
	end_day = 2


/datum/holiday/spess
	name = "Cosmonautics Day"
	begin_day = 12
	begin_month = APRIL
	greet_text = "On this day over 600 years ago, Comrade Yuri Gagarin first ventured into space!"

//Information itself is from the combat manual but the date was never stated, i chose the date of when the first CM server was established - 2013, Jun 29
/datum/holiday/uscm_day
	name = "Day of the Colonial Marines"
	begin_day = 20
	begin_month = APRIL
	greet_text = "On this day in the year of 2101 the National Security Act was signed, and the United States Colonial Marine Corps were established."
	holiday_faction = FACTION_MARINE

/datum/holiday/tea
	name = "National Tea Day"
	begin_day = 21
	begin_month = APRIL
	holiday_faction = FACTION_TWE

/datum/holiday/earth
	name = "Earth Day"
	begin_day = 22
	begin_month = APRIL

/datum/holiday/anzac
	name = "Anzac Day"
	begin_day = 25
	begin_month = APRIL
	begin_month = "TWE holiday celebrated by people from british part of Oceania. Holiday is dedicated to remembrance of the Anzacs at Gallipoli"
	holiday_faction = FACTION_TWE

/datum/holiday/showa
	name = "Showa Day"
	begin_day = 29
	begin_month = APRIL
	greet_text = "Public holiday in the ethnically Japanese parts of the TWE, honoring the birthday of emperor Hirohito, and historical period associated with him."
	holiday_faction = FACTION_TWE

// MAY

/datum/holiday/labor
	name = "Labor Day"
	begin_day = 1
	begin_month = MAY

/datum/holiday/firefighter
	name = "Firefighter's Day"
	begin_day = 4
	begin_month = MAY

// JUNE

/datum/holiday/summersolstice
	name = "Summer Solstice"
	begin_day = 21
	begin_month = JUNE

// JULY

/datum/holiday/doctor
	name = "Doctor's Day"
	begin_day = 1
	begin_month = JULY

/datum/holiday/ufo
	name = "UFO Day"
	begin_day = 2
	begin_month = JULY

/datum/holiday/usa
	name = "US Independence Day"
	timezones = list(TIMEZONE_EDT, TIMEZONE_CDT, TIMEZONE_MDT, TIMEZONE_MST, TIMEZONE_PDT, TIMEZONE_AKDT, TIMEZONE_HDT, TIMEZONE_HST)
	begin_day = 4
	begin_month = JULY
	greet_text = "On this day in the year of 1776, the USA declared independance from the Great Britain, the holiday is celebrated across UA."
	holiday_faction = FACTION_MARINE

/datum/holiday/writer
	name = "Writer's Day"
	begin_day = 8
	begin_month = JULY

/datum/holiday/hotdogday
	name = HOTDOG_DAY
	begin_day = 17
	begin_month = JULY
	greet_text = "Happy National Hot Dog Day!"

/datum/holiday/friendship
	name = "Friendship Day"
	begin_day = 30
	begin_month = JULY

/datum/holiday/friendship/greet()
	return "Have a magical [name]!"

// AUGUST

/datum/holiday/vdvday
	name = "Paratrooper's Day"
	begin_day = 2
	begin_month = AUGUST
	greet_text = "Originally celebrating USSR and post Soviet VDV forces, this holiday celebrates UPP KVD paratroopers in their heroic and hazardous job."
	holiday_faction = FACTION_UPP


/datum/holiday/monarchday
	name = "Empress Birthday"
	begin_day = 7
	begin_month = AUGUST
	greet_text = "Today is 39th birthday of the Three World Empire monarch, her majesty empress Fiona II Kōshitsu-Windsor."
	holiday_faction = FACTION_TWE

// SEPTEMBER

/datum/holiday/equinox
	name = "Autumnal Equinox Day"
	begin_day = 23
	begin_month = SEPTEMBER
	greet_text = "TWE holiday associated with Shinto, on this day people reconnect with their families and ancestors."
	holiday_faction = FACTION_TWE

// OCTOBER

/datum/holiday/animal
	name = "Animal's Day"
	begin_day = 4
	begin_month = OCTOBER

/datum/holiday/smile
	name = "Smiling Day"
	begin_day = 7
	begin_month = OCTOBER

/datum/holiday/halloween
	name = HALLOWEEN
	begin_day = 29
	begin_month = OCTOBER
	end_day = 2
	end_month = NOVEMBER
	greet_text = "Have a spooky Halloween!"

// NOVEMBER

/datum/holiday/jculture
	name = "Culture Day"
	begin_day = 3
	begin_month = NOVEMBER
	greet_text = "TWE holiday founded in Japan, the day dedicated to promoting arts, culture and other forms of artistic expression."
	holiday_faction = FACTION_TWE

/datum/holiday/remembrance_day
	name = "Remembrance Day"
	begin_month = NOVEMBER
	begin_day = 11
	greet_text = "Lest we forget."

/datum/holiday/lifeday
	name = "Life Day"
	begin_day = 17
	begin_month = NOVEMBER

// DECEMBER

/datum/holiday/festive_season
	name = FESTIVE_SEASON
	begin_day = 1
	begin_month = DECEMBER
	end_day = 31

/datum/holiday/festive_season/greet()
	return "Have a nice festive season!"

/datum/holiday/human_rights
	name = "Human-Rights Day"
	begin_day = 10
	begin_month = DECEMBER

/datum/holiday/doomsday
	name = "Mayan Doomsday Anniversary"
	begin_day = 21
	begin_month = DECEMBER

/datum/holiday/xmas
	name = CHRISTMAS
	begin_day = 23
	begin_month = DECEMBER
	end_day = 27

/datum/holiday/xmas/greet()
	return "Have a merry Christmas!"

/datum/holiday/boxing
	name = "Boxing Day"
	begin_day = 26
	begin_month = DECEMBER

/datum/holiday/new_year
	name = NEW_YEAR
	begin_day = 31
	begin_month = DECEMBER
	end_day = 2
	end_month = JANUARY

/datum/holiday/new_year/greet()
	return "Have a happy New Year!"

// MOVING DATES

/datum/holiday/friday_thirteenth
	name = "Friday the 13th"

/datum/holiday/friday_thirteenth/shouldCelebrate(dd, mm, yyyy, ddd)
	if(dd == 13 && ddd == FRIDAY)
		return TRUE
	return FALSE


// EASTER (this having it's own spot should be understandable)

/datum/holiday/easter
	name = EASTER
	var/const/days_early = 1 //to make editing the holiday easier
	var/const/days_extra = 1

/datum/holiday/easter/shouldCelebrate(dd, mm, yyyy, ddd)
	if(!begin_month)
		current_year = text2num(time2text(world.timeofday, "YYYY"))
		var/list/easterResults = EasterDate(current_year+year_offset)

		begin_day = easterResults["day"]
		begin_month = easterResults["month"]

		end_day = begin_day + days_extra
		end_month = begin_month
		if(end_day >= 32 && end_month == MARCH) //begins in march, ends in april
			end_day -= 31
			end_month++
		if(end_day >= 31 && end_month == APRIL) //begins in april, ends in june
			end_day -= 30
			end_month++

		begin_day -= days_early
		if(begin_day <= 0)
			if(begin_month == APRIL)
				begin_day += 31
				begin_month-- //begins in march, ends in april

	return ..()

