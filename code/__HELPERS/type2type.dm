/*
 * Holds procs designed to change one type of value, into another.
 * Contains:
 *			hex2num & num2hex
 *			file2list
 *			angle2dir
 *			angle2text
 *			worldtime2text
 */

//Returns an integer given a hex input
/proc/hex2num(hex)
	if (!( istext(hex) ))
		return

	var/num = 0
	var/power = 0
	var/i = null
	i = length(hex)
	while(i > 0)
		var/char = copytext(hex, i, i + 1)
		switch(char)
			if("0")
				//Apparently, switch works with empty statements, yay! If that doesn't work, blame me, though. -- Urist
			if("9", "8", "7", "6", "5", "4", "3", "2", "1")
				num += text2num(char) * 16 ** power
			if("a", "A")
				num += 16 ** power * 10
			if("b", "B")
				num += 16 ** power * 11
			if("c", "C")
				num += 16 ** power * 12
			if("d", "D")
				num += 16 ** power * 13
			if("e", "E")
				num += 16 ** power * 14
			if("f", "F")
				num += 16 ** power * 15
			else
				return
		power++
		i--
	return num

//Returns the hex value of a number given a value assumed to be a base-ten value
/proc/num2hex(num, placeholder)

	if (placeholder == null)
		placeholder = 2
	if (!( isnum(num) ))
		return
	if (num == 0)
		var/final = ""
		for(var/i=1 to placeholder) final = "[final]0"
		return final
	var/hex = ""
	var/i = 0
	while(16 ** i < num)
		i++
	var/power = null
	power = i - 1
	while(power >= 0)
		var/val = round(num / 16 ** power)
		num -= val * 16 ** power
		switch(val)
			if(9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0, 0.0)
				hex += text("[]", val)
			if(10.0)
				hex += "A"
			if(11.0)
				hex += "B"
			if(12.0)
				hex += "C"
			if(13.0)
				hex += "D"
			if(14.0)
				hex += "E"
			if(15.0)
				hex += "F"
			else
		power--
	while(length(hex) < placeholder)
		hex = text("0[]", hex)
	return hex

//slower then list2text, but correctly processes associative lists.
proc/tg_list2text(list/list, glue=",")
	if(!istype(list) || !list.len)
		return
	var/output
	for(var/i=1 to list.len)
		output += (i!=1? glue : null)+(!isnull(list["[list[i]]"])?"[list["[list[i]]"]]":"[list[i]]")
	return output

//Splits the text of a file at seperator and returns them in a list.
/proc/file2list(filename, seperator="\n", trim = TRUE)
	if (trim)
		return splittext(trim(file2text(filename)),seperator)
	return splittext(file2text(filename),seperator)


//Turns a direction into text

/proc/num2dir(direction)
	switch(direction)
		if(1.0) return NORTH
		if(2.0) return SOUTH
		if(4.0) return EAST
		if(8.0) return WEST
		else
			world.log << "UNKNOWN DIRECTION: [direction]"



//Turns a direction into text
/proc/dir2text(direction)
	switch(direction)
		if(1.0)
			return "north"
		if(2.0)
			return "south"
		if(4.0)
			return "east"
		if(8.0)
			return "west"
		if(5.0)
			return "northeast"
		if(6.0)
			return "southeast"
		if(9.0)
			return "northwest"
		if(10.0)
			return "southwest"


//Turns a direction into text
/proc/dir2text_short(direction)
	switch(direction)
		if(1)
			return "N"
		if(2)
			return "S"
		if(4)
			return "E"
		if(8)
			return "W"
		if(5)
			return "NE"
		if(6)
			return "SE"
		if(9)
			return "NW"
		if(10)
			return "SW"



//Turns text into proper directions
/proc/text2dir(direction)
	switch(uppertext(direction))
		if("NORTH")
			return 1
		if("SOUTH")
			return 2
		if("EAST")
			return 4
		if("WEST")
			return 8
		if("NORTHEAST")
			return 5
		if("NORTHWEST")
			return 9
		if("SOUTHEAST")
			return 6
		if("SOUTHWEST")
			return 10
		else
	return

//Converts an angle (degrees) into an ss13 direction
/proc/angle2dir(var/degree)
	degree = ((degree+22.5)%365)
	if(degree < 45)		return NORTH
	if(degree < 90)		return NORTHEAST
	if(degree < 135)	return EAST
	if(degree < 180)	return SOUTHEAST
	if(degree < 225)	return SOUTH
	if(degree < 270)	return SOUTHWEST
	if(degree < 315)	return WEST
	return NORTHWEST

//returns the north-zero clockwise angle in degrees, given a direction

/proc/dir2angle(var/D)
	switch(D)
		if(NORTH)		return 0
		if(SOUTH)		return 180
		if(EAST)		return 90
		if(WEST)		return 270
		if(NORTHEAST)	return 45
		if(SOUTHEAST)	return 135
		if(NORTHWEST)	return 315
		if(SOUTHWEST)	return 225
		else			return null

//Returns the angle in english
/proc/angle2text(var/degree)
	return dir2text(angle2dir(degree))

//Converts a blend_mode constant to one acceptable to icon.Blend()
/proc/blendMode2iconMode(blend_mode)
	switch(blend_mode)
		if(BLEND_MULTIPLY) return ICON_MULTIPLY
		if(BLEND_ADD)      return ICON_ADD
		if(BLEND_SUBTRACT) return ICON_SUBTRACT
		else               return ICON_OVERLAY

//Converts a rights bitfield into a string
/proc/rights2text(rights,seperator="")
	if(rights & R_BUILDMODE)	. += "[seperator]+BUILDMODE"
	if(rights & R_ADMIN)		. += "[seperator]+ADMIN"
	if(rights & R_BAN)			. += "[seperator]+BAN"
	if(rights & R_FUN)			. += "[seperator]+FUN"
	if(rights & R_SERVER)		. += "[seperator]+SERVER"
	if(rights & R_DEBUG)		. += "[seperator]+DEBUG"
	if(rights & R_POSSESS)		. += "[seperator]+POSSESS"
	if(rights & R_PERMISSIONS)	. += "[seperator]+PERMISSIONS"
	if(rights & R_STEALTH)		. += "[seperator]+STEALTH"
	if(rights & R_REJUVINATE)	. += "[seperator]+REJUVINATE"
	if(rights & R_COLOR)		. += "[seperator]+COLOR"
	if(rights & R_VAREDIT)		. += "[seperator]+VAREDIT"
	if(rights & R_SOUNDS)		. += "[seperator]+SOUND"
	if(rights & R_SPAWN)		. += "[seperator]+SPAWN"
	if(rights & R_MOD)			. += "[seperator]+MODERATOR"
	if(rights & R_MENTOR)		. += "[seperator]+MENTOR"
	return .

//Shows all the direction represented by direction
/proc/alldir2text_short(direction)
	var/dirs = ""
	if(direction & NORTH)
		dirs += "N"
	if(direction & SOUTH)
		dirs += "S"
	if(direction & EAST)
		dirs += "E"
	if(direction & WEST)
		dirs += "W"
	return dirs

/// Return html to load a url.
/// for use inside of browse() calls to html assets that might be loaded on a cdn.
/proc/url2htmlloader(url)
	return {"<html><head><meta http-equiv="refresh" content="0;URL='[url]'"/></head><body onLoad="parent.location='[url]'"></body></html>"}

/proc/type2parent(child)
	var/string_type = "[child]"
	var/last_slash = findlasttext(string_type, "/")
	if(last_slash == 1)
		switch(child)
			if(/datum)
				return null
			if(/obj, /mob)
				return /atom/movable
			if(/area, /turf)
				return /atom
			else
				return /datum
	return text2path(copytext(string_type, 1, last_slash))
