/proc/mix_color_from_reagents(list/reagent_list)
	if(!reagent_list || !length(reagent_list))
		return 0

	var/contents = length(reagent_list)
	var/list/weight = new /list(contents)
	var/list/redcolor = new /list(contents)
	var/list/greencolor = new /list(contents)
	var/list/bluecolor = new /list(contents)
	var/i

	//fill the list of weights
	for(i=1; i<=contents; i++)
		var/datum/reagent/re = reagent_list[i]
		var/reagentweight = re.volume
		if(istype(re, /datum/reagent/paint))
			reagentweight *= 20 //Paint colors a mixture twenty times as much
		weight[i] = max(reagentweight,1)


	//fill the lists of colors
	for(i=1; i<=contents; i++)
		var/datum/reagent/re = reagent_list[i]
		var/hue = re.color
		if(length(hue) != 7)
			return 0
		redcolor[i]=hex2num(copytext(hue,2,4))
		greencolor[i]=hex2num(copytext(hue,4,6))
		bluecolor[i]=hex2num(copytext(hue,6,8))

	//mix all the colors
	var/red = floor(mixOneColor(weight,redcolor))
	var/green = floor(mixOneColor(weight,greencolor))
	var/blue = floor(mixOneColor(weight,bluecolor))

	//assemble all the pieces
	var/finalcolor = rgb(red, green, blue)
	return finalcolor

/proc/mixOneColor(list/weight, list/color)
	if (!weight || !color || length(weight)!=length(color))
		return 0

	var/contents = length(weight)
	var/i

	//normalize weights
	var/listsum = 0
	for(i=1; i<=contents; i++)
		listsum += weight[i]
	for(i=1; i<=contents; i++)
		weight[i] /= listsum

	//mix them
	var/mixedcolor = 0
	for(i=1; i<=contents; i++)
		mixedcolor += weight[i]*color[i]

	//until someone writes a formal proof for this algorithm, let's keep this in
// if(mixedcolor<0x00 || mixedcolor>0xFF)
// return 0
	//that's not the kind of operation we are running here, nerd
	mixedcolor=min(max(mixedcolor,0),255)

	return mixedcolor

/proc/mix_burn_colors(list/reagent_list)
	var/contents = length(reagent_list)
	var/list/weight = new /list(contents)
	var/list/hue = new /list(contents)
	var/list/saturation = new /list(contents)

	for(var/i in 1 to contents)
		//fill the list of weights
		var/datum/reagent/reagent = reagent_list[i]
		weight[i] = max(reagent.volume, 1) * reagent.burncolormod

		var/hex_color = reagent.burncolor
		if (length(hex_color) != 7)
			return 0

		// Convert the rgb factors into hs
		// This prevents low-value flames (eg:darkflame and invisible flames)
		var/redfactor = hex2num(copytext(hex_color,2,4)) / 255.0
		var/greenfactor = hex2num(copytext(hex_color,4,6)) / 255.0
		var/bluefactor = hex2num(copytext(hex_color,6,8)) / 255.0

		var/cmax = max(redfactor, greenfactor, bluefactor)
		var/cmin = min(redfactor, greenfactor, bluefactor)
		var/delta = cmax - cmin

		if (delta == 0)
			hue[i] = 0
		else if (redfactor == cmax)
			hue[i] = (greenfactor - bluefactor)/delta
		else if (greenfactor == cmax)
			hue[i] = 2 + (bluefactor - redfactor)/delta
		else if (bluefactor == cmax)
			hue[i] = 4 + (redfactor - greenfactor)/delta
		else
			// Should be unreachable, but it doesn't hurt to catch this just in case
			hue[i] = 0
		hue[i] *= 60 // Converting to degrees

		if (cmax == 0)
			saturation[i] = 0
		else
			saturation[i] = delta / cmax

	// Saturation can be mixed normally
	var/final_saturation = mixOneColor(weight,saturation)

	// Mixing hues is a little more complicated, take the circular mean of the hues
	var/sinsum = 0
	var/cossum = 0
	for(var/i in 1 to contents)
		// Because it's on a circle, we don't need to worry about normalizing weights
		sinsum += sin(hue[i]) * saturation[i] * weight[i]
		cossum += cos(hue[i]) * saturation[i] * weight[i]
	var/final_hue = arctan(cossum, sinsum)
	if (final_hue < 0)
		final_hue += 360

	// Converting this hue average back into rgb format
	var/secondary = final_saturation * (1 - (abs(final_hue % 120 - 60) / 60))
	var/red_prime = 0
	var/green_prime = 0
	var/blue_prime = 0
	if (final_hue < 60)
		red_prime = final_saturation
		green_prime = secondary
	else if (final_hue < 120)
		red_prime = secondary
		green_prime = final_saturation
	else if (final_hue < 180)
		green_prime = final_saturation
		blue_prime = secondary
	else if (final_hue < 240)
		green_prime = secondary
		blue_prime = final_saturation
	else if (final_hue < 300)
		red_prime = final_saturation
		blue_prime = secondary

	var/red = (red_prime + 1 - final_saturation) * 255
	var/green = (green_prime + 1 - final_saturation) * 255
	var/blue = (blue_prime + 1 - final_saturation) * 255

	//assemble all the pieces
	var/finalcolor = rgb(red, green, blue)
	return finalcolor

