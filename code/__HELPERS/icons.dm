/*
IconProcs README

A BYOND library for manipulating icons and colors

by Lummox JR

version 1.0

The IconProcs library was made to make a lot of common icon operations much easier. BYOND's icon manipulation
routines are very capable but some of the advanced capabilities like using alpha transparency can be unintuitive to beginners.

CHANGING ICONS

Several new procs have been added to the /icon datum to simplify working with icons. To use them,
remember you first need to setup an /icon var like so:
	var/icon/my_icon = new('iconfile.dmi')

icon/ChangeOpacity(amount = 1)
	A very common operation in DM is to try to make an icon more or less transparent. Making an icon more
	transparent is usually much easier than making it less so, however. This proc basically is a frontend
	for MapColors() which can change opacity any way you like, in much the same way that SetIntensity()
	can make an icon lighter or darker. If amount is 0.5, the opacity of the icon will be cut in half.
	If amount is 2, opacity is doubled and anything more than half-opaque will become fully opaque.
icon/GrayScale()
	Converts the icon to grayscale instead of a fully colored icon. Alpha values are left intact.
icon/ColorTone(tone)
	Similar to GrayScale(), this proc converts the icon to a range of black -> tone -> white, where tone is an
	RGB color (its alpha is ignored). This can be used to create a sepia tone or similar effect.
	See also the global ColorTone() proc.
icon/MinColors(icon)
	The icon is blended with a second icon where the minimum of each RGB pixel is the result.
	Transparency may increase, as if the icons were blended with ICON_ADD. You may supply a color in place of an icon.
icon/MaxColors(icon)
	The icon is blended with a second icon where the maximum of each RGB pixel is the result.
	Opacity may increase, as if the icons were blended with ICON_OR. You may supply a color in place of an icon.
icon/Opaque(background = "#000000")
	All alpha values are set to 255 throughout the icon. Transparent pixels become black, or whatever background color you specify.
icon/BecomeAlphaMask()
	You can convert a simple grayscale icon into an alpha mask to use with other icons very easily with this proc.
	The black parts become transparent, the white parts stay white, and anything in between becomes a translucent shade of white.
icon/AddAlphaMask(mask)
	The alpha values of the mask icon will be blended with the current icon. Anywhere the mask is opaque,
	the current icon is untouched. Anywhere the mask is transparent, the current icon becomes transparent.
	Where the mask is translucent, the current icon becomes more transparent.
icon/UseAlphaMask(mask, mode)
	Sometimes you may want to take the alpha values from one icon and use them on a different icon.
	This proc will do that. Just supply the icon whose alpha mask you want to use, and src will change
	so it has the same colors as before but uses the mask for opacity.

COLOR MANAGEMENT AND HSV

RGB isn't the only way to represent color. Sometimes it's more useful to work with a model called HSV, which stands for hue, saturation, and value.

	* The hue of a color describes where it is along the color wheel. It goes from red to yellow to green to
	cyan to blue to magenta and back to red.
	* The saturation of a color is how much color is in it. A color with low saturation will be more gray,
	and with no saturation at all it is a shade of gray.
	* The value of a color determines how bright it is. A high-value color is vivid, moderate value is dark,
	and no value at all is black.

Just as BYOND uses "#rrggbb" to represent RGB values, a similar format is used for HSV: "#hhhssvv". The hue is three
hex digits because it ranges from 0 to 0x5FF.

	* 0 to 0xFF - red to yellow
	* 0x100 to 0x1FF - yellow to green
	* 0x200 to 0x2FF - green to cyan
	* 0x300 to 0x3FF - cyan to blue
	* 0x400 to 0x4FF - blue to magenta
	* 0x500 to 0x5FF - magenta to red

Knowing this, you can figure out that red is "#000ffff" in HSV format, which is hue 0 (red), saturation 255 (as colorful as possible),
value 255 (as bright as possible). Green is "#200ffff" and blue is "#400ffff".

More than one HSV color can match the same RGB color.

Here are some procs you can use for color management:

ReadRGB(rgb)
	Takes an RGB string like "#ffaa55" and converts it to a list such as list(255,170,85). If an RGBA format is used
	that includes alpha, the list will have a fourth item for the alpha value.
hsv(hue, sat, val, apha)
	Counterpart to rgb(), this takes the values you input and converts them to a string in "#hhhssvv" or "#hhhssvvaa"
	format. Alpha is not included in the result if null.
ReadHSV(rgb)
	Takes an HSV string like "#100FF80" and converts it to a list such as list(256,255,128). If an HSVA format is used that
	includes alpha, the list will have a fourth item for the alpha value.
RGBtoHSV(rgb)
	Takes an RGB or RGBA string like "#ffaa55" and converts it into an HSV or HSVA color such as "#080aaff".
HSVtoRGB(hsv)
	Takes an HSV or HSVA string like "#080aaff" and converts it into an RGB or RGBA color such as "#ff55aa".
BlendRGB(rgb1, rgb2, amount)
	Blends between two RGB or RGBA colors using regular RGB blending. If amount is 0, the first color is the result;
	if 1, the second color is the result. 0.5 produces an average of the two. Values outside the 0 to 1 range are allowed as well.
	The returned value is an RGB or RGBA color.
BlendHSV(hsv1, hsv2, amount)
	Blends between two HSV or HSVA colors using HSV blending, which tends to produce nicer results than regular RGB
	blending because the brightness of the color is left intact. If amount is 0, the first color is the result; if 1,
	the second color is the result. 0.5 produces an average of the two. Values outside the 0 to 1 range are allowed as well.
	The returned value is an HSV or HSVA color.
BlendRGBasHSV(rgb1, rgb2, amount)
	Like BlendHSV(), but the colors used and the return value are RGB or RGBA colors. The blending is done in HSV form.
HueToAngle(hue)
	Converts a hue to an angle range of 0 to 360. Angle 0 is red, 120 is green, and 240 is blue.
AngleToHue(hue)
	Converts an angle to a hue in the valid range.
RotateHue(hsv, angle)
	Takes an HSV or HSVA value and rotates the hue forward through red, green, and blue by an angle from 0 to 360.
	(Rotating red by 60� produces yellow.) The result is another HSV or HSVA color with the same saturation and value
	as the original, but a different hue.
GrayScale(rgb)
	Takes an RGB or RGBA color and converts it to grayscale. Returns an RGB or RGBA string.
ColorTone(rgb, tone)
	Similar to GrayScale(), this proc converts an RGB or RGBA color to a range of black -> tone -> white instead of
	using strict shades of gray. The tone value is an RGB color; any alpha value is ignored.
*/

/*
Get Flat Icon DEMO by DarkCampainger

This is a test for the get flat icon proc, modified approprietly for icons and their states.
Probably not a good idea to run this unless you want to see how the proc works in detail.
mob
	icon = 'old_or_unused.dmi'
	icon_state = "green"

	Login()
		// Testing image underlays
		underlays += image(icon='old_or_unused.dmi',icon_state="red")
		underlays += image(icon='old_or_unused.dmi',icon_state="red", pixel_x = 32)
		underlays += image(icon='old_or_unused.dmi',icon_state="red", pixel_x = -32)

		// Testing image overlays
		overlays += image(icon='old_or_unused.dmi',icon_state="green", pixel_x = 32, pixel_y = -32)
		overlays += image(icon='old_or_unused.dmi',icon_state="green", pixel_x = 32, pixel_y = 32)
		overlays += image(icon='old_or_unused.dmi',icon_state="green", pixel_x = -32, pixel_y = -32)

		// Testing icon file overlays (defaults to mob's state)
		overlays += '_flat_demoIcons2.dmi'

		// Testing icon_state overlays (defaults to mob's icon)
		overlays += "white"

		// Testing dynamic icon overlays
		var/icon/I = icon('old_or_unused.dmi', icon_state="aqua")
		I.Shift(NORTH,16,1)
		overlays+=I

		// Testing dynamic image overlays
		I=image(icon=I,pixel_x = -32, pixel_y = 32)
		overlays+=I

		// Testing object types (and layers)
		overlays+=/obj/effect/overlayTest

		forceMove(locate (10,10,1))
	verb
		Browse_Icon()
			set name = "1. Browse Icon"
			// Give it a name for the cache
			var/iconName = "[ckey(src.name)]_flattened.dmi"
			// Send the icon to src's local cache
			src<<browse_rsc(getFlatIcon(src), iconName)
			// Display the icon in their browser
			src<<browse("<body bgcolor='#000000'><p><img src='[iconName]'></p></body>")

		Output_Icon()
			set name = "2. Output Icon"
			src<<"Icon is: \icon[getFlatIcon(src)]"

		Label_Icon()
			set name = "3. Label Icon"
			// Give it a name for the cache
			var/iconName = "[ckey(src.name)]_flattened.dmi"
			// Copy the file to the rsc manually
			var/icon/I = fcopy_rsc(getFlatIcon(src))
			// Send the icon to src's local cache
			src<<browse_rsc(I, iconName)
			// Update the label to show it
			winset(src,"imageLabel","image='\ref[I]'");

		Add_Overlay()
			set name = "4. Add Overlay"
			overlays += image(icon='old_or_unused.dmi',icon_state="yellow",pixel_x = rand(-64,32), pixel_y = rand(-64,32))

		Stress_Test()
			set name = "5. Stress Test"
			for(var/i = 0 to 1000)
				// The third parameter forces it to generate a new one, even if it's already cached
				getFlatIcon(src,0,2)
				if(prob(5))
					Add_Overlay()
			Browse_Icon()

		Cache_Test()
			set name = "6. Cache Test"
			for(var/i = 0 to 1000)
				getFlatIcon(src)
			Browse_Icon()

/obj/effect/overlayTest
	icon = 'old_or_unused.dmi'
	icon_state = "blue"
	pixel_x = -24
	pixel_y = 24
	layer = TURF_LAYER // Should appear below the rest of the overlays

world
	view = "7x7"
	maxx = 20
	maxy = 20
	maxz = 1
*/

#define TO_HEX_DIGIT(n) ascii2text((n&15) + ((n&15)<10 ? 48 : 87))

/icon/proc/BecomeLying()
	Turn(90)
	Shift(SOUTH,6)
	Shift(EAST,1)

	// Multiply all alpha values by this float
/icon/proc/ChangeOpacity(opacity = 1.0)
	MapColors(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,opacity, 0,0,0,0)

	// Convert to grayscale
/icon/proc/GrayScale()
	MapColors(0.3,0.3,0.3, 0.59,0.59,0.59, 0.11,0.11,0.11, 0,0,0)

/icon/proc/ColorTone(tone)
	GrayScale()

	var/list/TONE = ReadRGB(tone)
	var/gray = round(TONE[1]*0.3 + TONE[2]*0.59 + TONE[3]*0.11, 1)

	var/icon/upper = (255-gray) ? new(src) : null

	if(gray)
		MapColors(255/gray,0,0, 0,255/gray,0, 0,0,255/gray, 0,0,0)
		Blend(tone, ICON_MULTIPLY)
	else SetIntensity(0)
	if(255-gray)
		upper.Blend(rgb(gray,gray,gray), ICON_SUBTRACT)
		upper.MapColors((255-TONE[1])/(255-gray),0,0,0, 0,(255-TONE[2])/(255-gray),0,0, 0,0,(255-TONE[3])/(255-gray),0, 0,0,0,0, 0,0,0,1)
		Blend(upper, ICON_ADD)

/icon/proc/AddAlphaMask(mask)
	var/icon/M = new(mask)
	M.Blend("#ffffff", ICON_SUBTRACT)
	// apply mask
	Blend(M, ICON_ADD)

/*
	HSV format is represented as "#hhhssvv" or "#hhhssvvaa"

	Hue ranges from 0 to 0x5ff (1535)

		0x000 = red
		0x100 = yellow
		0x200 = green
		0x300 = cyan
		0x400 = blue
		0x500 = magenta

	Saturation is from 0 to 0xff (255)

		More saturation = more color
		Less saturation = more gray

	Value ranges from 0 to 0xff (255)

		Higher value means brighter color
 */

/proc/ReadRGB(rgb)
	if(!rgb) return

	// interpret the HSV or HSVA value
	var/i=1,start=1
	if(text2ascii(rgb) == 35) ++start // skip opening #
	var/ch,which=0,r=0,g=0,b=0,alpha=0,usealpha
	var/digits=0
	for(i=start, i<=length(rgb), ++i)
		ch = text2ascii(rgb, i)
		if(ch < 48 || (ch > 57 && ch < 65) || (ch > 70 && ch < 97) || ch > 102) break
		++digits
		if(digits == 8) break

	var/single = digits < 6
	if(digits != 3 && digits != 4 && digits != 6 && digits != 8) return
	if(digits == 4 || digits == 8) usealpha = 1
	for(i=start, digits>0, ++i)
		ch = text2ascii(rgb, i)
		if(ch >= 48 && ch <= 57) ch -= 48
		else if(ch >= 65 && ch <= 70) ch -= 55
		else if(ch >= 97 && ch <= 102) ch -= 87
		else break
		--digits
		switch(which)
			if(0)
				r = (r << 4)|ch
				if(single)
					r |= r << 4
					++which
				else if(!(digits & 1)) ++which
			if(1)
				g = (g << 4)|ch
				if(single)
					g |= g << 4
					++which
				else if(!(digits & 1)) ++which
			if(2)
				b = (b << 4)|ch
				if(single)
					b |= b << 4
					++which
				else if(!(digits & 1)) ++which
			if(3)
				alpha = (alpha << 4)|ch
				if(single) alpha |= alpha << 4

	. = list(r, g, b)
	if(usealpha) . += alpha

/// Create a single [/icon] from a given [/atom] or [/image].
///
/// Very low-performance. Should usually only be used for HTML, where BYOND's
/// appearance system (overlays/underlays, etc.) is not available.
///
/// Only the first argument is required.
/// appearance_flags indicates whether appearance_flags should be respected (at the cost of about 10-20% perf)
/proc/getFlatIcon(image/appearance, defdir, deficon, defstate, defblend, start = TRUE, no_anim = FALSE, appearance_flags = FALSE)
	// Loop through the underlays, then overlays, sorting them into the layers list
	#define PROCESS_OVERLAYS_OR_UNDERLAYS(flat, process, base_layer) \
		for (var/i in 1 to length(process)) { \
			var/image/current = process[i]; \
			if (!current) { \
				continue; \
			} \
			if (current.plane != FLOAT_PLANE && current.plane != appearance.plane) { \
				continue; \
			} \
			var/current_layer = current.layer; \
			if (current_layer < 0) { \
				if (current_layer <= -1000) { \
					return flat; \
				} \
				current_layer = base_layer + appearance.layer + current_layer / 1000; \
			} \
			for (var/index_to_compare_to in 1 to length(layers)) { \
				var/compare_to = layers[index_to_compare_to]; \
				if (current_layer < layers[compare_to]) { \
					layers.Insert(index_to_compare_to, current); \
					break; \
				} \
			} \
			layers[current] = current_layer; \
		}

	var/static/icon/flat_template = icon('icons/effects/effects.dmi', "nothing")

	if(!appearance || appearance.alpha <= 0)
		return icon(flat_template)

	if(start)
		if(!defdir)
			defdir = appearance.dir
		if(!deficon)
			deficon = appearance.icon
		if(!defstate)
			defstate = appearance.icon_state
		if(!defblend)
			defblend = appearance.blend_mode

	var/curicon = appearance.icon || deficon
	var/curstate = appearance.icon_state || defstate
	var/curdir = (!appearance.dir || appearance.dir == SOUTH) ? defdir : appearance.dir

	var/render_icon = curicon

	if (render_icon)
		var/curstates = icon_states(curicon)
		if(!(curstate in curstates))
			if ("" in curstates)
				curstate = ""
			else
				render_icon = FALSE

	var/base_icon_dir //We'll use this to get the icon state to display if not null BUT NOT pass it to overlays as the dir we have

	//Try to remove/optimize this section ASAP, CPU hog.
	//Determines if there's directionals.
	if(render_icon && curdir != SOUTH)
		if (
			!length(icon_states(icon(curicon, curstate, NORTH))) \
			&& !length(icon_states(icon(curicon, curstate, EAST))) \
			&& !length(icon_states(icon(curicon, curstate, WEST))) \
		)
			base_icon_dir = SOUTH

	if(!base_icon_dir)
		base_icon_dir = curdir

	var/curblend = appearance.blend_mode || defblend

	if(length(appearance.overlays) || length(appearance.underlays))
		var/icon/flat = icon(flat_template)
		// Layers will be a sorted list of icons/overlays, based on the order in which they are displayed
		var/list/layers = list()
		var/image/copy
		// Add the atom's icon itself, without pixel_x/y offsets.
		if(render_icon)
			copy = image(icon=curicon, icon_state=curstate, layer=appearance.layer, dir=base_icon_dir)
			copy.color = appearance.color
			copy.alpha = appearance.alpha
			copy.blend_mode = curblend
			layers[copy] = appearance.layer

		PROCESS_OVERLAYS_OR_UNDERLAYS(flat, appearance.underlays, 0)
		PROCESS_OVERLAYS_OR_UNDERLAYS(flat, appearance.overlays, 1)

		var/icon/add // Icon of overlay being added

		var/flatX1 = 1
		var/flatX2 = flat.Width()
		var/flatY1 = 1
		var/flatY2 = flat.Height()

		var/addX1 = 0
		var/addX2 = 0
		var/addY1 = 0
		var/addY2 = 0

		for(var/image/layer_image as anything in layers)
			if(layer_image.alpha == 0)
				continue

			// variables only relevant when accounting for appearance_flags:
			var/apply_color = TRUE
			var/apply_alpha = TRUE

			if(layer_image == copy) // 'layer_image' is an /image based on the object being flattened.
				curblend = BLEND_OVERLAY
				add = icon(layer_image.icon, layer_image.icon_state, base_icon_dir)
			else // 'I' is an appearance object.
				var/image/layer_as_image = image(layer_image)
				if(appearance_flags)
					if(layer_as_image.appearance_flags & RESET_COLOR)
						apply_color = FALSE
					if(layer_as_image.appearance_flags & RESET_ALPHA)
						apply_alpha = FALSE
				add = getFlatIcon(layer_as_image, curdir, curicon, curstate, curblend, FALSE, no_anim, appearance_flags)
			if(!add)
				continue

			// Find the new dimensions of the flat icon to fit the added overlay
			addX1 = min(flatX1, layer_image.pixel_x + 1)
			addX2 = max(flatX2, layer_image.pixel_x + add.Width())
			addY1 = min(flatY1, layer_image.pixel_y + 1)
			addY2 = max(flatY2, layer_image.pixel_y + add.Height())

			if (
				addX1 != flatX1 \
				|| addX2 != flatX2 \
				|| addY1 != flatY1 \
				|| addY2 != flatY2 \
			)
				// Resize the flattened icon so the new icon fits
				flat.Crop(
					addX1 - flatX1 + 1,
					addY1 - flatY1 + 1,
					addX2 - flatX1 + 1,
					addY2 - flatY1 + 1
				)

				flatX1 = addX1
				flatX2 = addX2
				flatY1 = addY1
				flatY2 = addY2

			if(appearance_flags)
				// apply parent's color/alpha to the added layers if the layer didn't opt
				if(apply_color && appearance.color)
					if(islist(appearance.color))
						add.MapColors(arglist(appearance.color))
					else
						add.Blend(appearance.color, ICON_MULTIPLY)

				if(apply_alpha && appearance.alpha < 255)
					add.Blend(rgb(255, 255, 255, appearance.alpha), ICON_MULTIPLY)

			// Blend the overlay into the flattened icon
			flat.Blend(add, blendMode2iconMode(curblend), layer_image.pixel_x + 2 - flatX1, layer_image.pixel_y + 2 - flatY1)

		if(!appearance_flags)
			// If we didn't apply parent colors individually per layer respecting appearance_flags, then do it just the one time now
			if(appearance.color)
				if(islist(appearance.color))
					flat.MapColors(arglist(appearance.color))
				else
					flat.Blend(appearance.color, ICON_MULTIPLY)

			if(appearance.alpha < 255)
				flat.Blend(rgb(255, 255, 255, appearance.alpha), ICON_MULTIPLY)

		if(no_anim)
			//Clean up repeated frames
			var/icon/cleaned = new /icon()
			cleaned.Insert(flat, "", SOUTH, 1, 0)
			return cleaned
		else
			return icon(flat, "", SOUTH)
	else if (render_icon) // There's no overlays.
		var/icon/final_icon = icon(icon(curicon, curstate, base_icon_dir), "", SOUTH, no_anim ? TRUE : null)

		if (appearance.alpha < 255)
			final_icon.Blend(rgb(255,255,255, appearance.alpha), ICON_MULTIPLY)

		if (appearance.color)
			if (islist(appearance.color))
				final_icon.MapColors(arglist(appearance.color))
			else
				final_icon.Blend(appearance.color, ICON_MULTIPLY)

		return final_icon

	#undef PROCESS_OVERLAYS_OR_UNDERLAYS

/proc/getIconMask(atom/A)//By yours truly. Creates a dynamic mask for a mob/whatever. /N
	var/icon/alpha_mask = new(A.icon,A.icon_state)//So we want the default icon and icon state of A.
	for(var/I in A.overlays)//For every image in overlays. var/image/I will not work, don't try it.
		if(I:layer>A.layer) continue//If layer is greater than what we need, skip it.
		var/icon/image_overlay = new(I:icon,I:icon_state)//Blend only works with icon objects.
		//Also, icons cannot directly set icon_state. Slower than changing variables but whatever.
		alpha_mask.Blend(image_overlay,ICON_OR)//OR so they are lumped together in a nice overlay.
	return alpha_mask//And now return the mask.

/proc/getHologramIcon(icon/A, safety=1)//If safety is on, a new icon is not created.
	var/icon/flat_icon = safety ? A : new(A)//Has to be a new icon to not constantly change the same icon.
	flat_icon.ColorTone(rgb(125,180,225))//Let's make it bluish.
	flat_icon.ChangeOpacity(0.5)//Make it half transparent.
	var/icon/alpha_mask = new('icons/effects/effects.dmi', "scanline")//Scanline effect.
	flat_icon.AddAlphaMask(alpha_mask)//Finally, let's mix in a distortion effect.
	return flat_icon

/proc/adjust_brightness(color, value)
	if (!color) return "#FFFFFF"
	if (!value) return color

	var/list/RGB = ReadRGB(color)
	RGB[1] = clamp(RGB[1]+value,0,255)
	RGB[2] = clamp(RGB[2]+value,0,255)
	RGB[3] = clamp(RGB[3]+value,0,255)
	return rgb(RGB[1],RGB[2],RGB[3])

/proc/sort_atoms_by_layer(list/atoms)
	// Comb sort icons based on levels
	var/list/result = atoms.Copy()
	var/gap = length(result)
	var/swapped = 1
	while (gap > 1 || swapped)
		swapped = 0
		if(gap > 1)
			gap = floor(gap / 1.3) // 1.3 is the emperic comb sort coefficient
		if(gap < 1)
			gap = 1
		for(var/i = 1; gap + i <= length(result); i++)
			var/atom/l = result[i] //Fucking hate
			var/atom/r = result[gap+i] //how lists work here
			if(l.layer > r.layer) //no "result[i].layer" for me
				result.Swap(i, gap + i)
				swapped = 1
	return result


/image/proc/flick_overlay(atom/A, duration) //originally code related to goonPS. This isn't the original code, but has the same effect
	A.overlays.Add(src)
	addtimer(CALLBACK(src, PROC_REF(flick_remove_overlay), A), duration)

/image/proc/flick_remove_overlay(atom/A)
	if(A)
		A.overlays.Remove(src)

/mob/proc/flick_heal_overlay(time, color = "#00FF00") //used for warden and queen healing
	var/image/I = image('icons/mob/mob.dmi', src, "heal_overlay")
	switch(icon_size)
		if(48)
			I.pixel_x = 8
		if(64)
			I.pixel_x = 16
	I.layer = FLY_LAYER
	I.appearance_flags = RESET_COLOR

	I.color = color
	I.flick_overlay(src, time)

/// generates a filename for a given asset.
/// like generate_asset_name(), except returns the rsc reference and the rsc file hash as well as the asset name (sans extension)
/// used so that certain asset files dont have to be hashed twice
/proc/generate_and_hash_rsc_file(file, dmi_file_path)
	var/rsc_ref = fcopy_rsc(file)
	var/hash
	//if we have a valid dmi file path we can trust md5'ing the rsc file because we know it doesnt have the bug described in http://www.byond.com/forum/post/2611357
	if(dmi_file_path)
		hash = md5(rsc_ref)
	else //otherwise, we need to do the expensive fcopy() workaround
		hash = md5asfile(rsc_ref)

	return list(rsc_ref, hash, "asset.[hash]")

///given a text string, returns whether it is a valid dmi icons folder path
/proc/is_valid_dmi_file(icon_path)
	if(!istext(icon_path) || !length(icon_path))
		return FALSE

	var/is_in_icon_folder = findtextEx(icon_path, "icons/")
	var/is_dmi_file = findtextEx(icon_path, ".dmi")

	if(is_in_icon_folder && is_dmi_file)
		return TRUE
	return FALSE

/// given an icon object, dmi file path, or atom/image/mutable_appearance, attempts to find and return an associated dmi file path.
/// a weird quirk about dm is that /icon objects represent both compile-time or dynamic icons in the rsc,
/// but stringifying rsc references returns a dmi file path
/// ONLY if that icon represents a completely unchanged dmi file from when the game was compiled.
/// so if the given object is associated with an icon that was in the rsc when the game was compiled, this returns a path. otherwise it returns ""
/proc/get_icon_dmi_path(icon/icon)
	/// the dmi file path we attempt to return if the given object argument is associated with a stringifiable icon
	/// if successful, this looks like "icons/path/to/dmi_file.dmi"
	var/icon_path = ""

	if(isatom(icon) || istype(icon, /image) || istype(icon, /mutable_appearance))
		var/atom/atom_icon = icon
		icon = atom_icon.icon
		//atom icons compiled in from 'icons/path/to/dmi_file.dmi' are weird and not really icon objects that you generate with icon().
		//if theyre unchanged dmi's then they're stringifiable to "icons/path/to/dmi_file.dmi"

	if(isicon(icon) && isfile(icon))
		//icons compiled in from 'icons/path/to/dmi_file.dmi' at compile time are weird and arent really /icon objects,
		///but they pass both isicon() and isfile() checks. theyre the easiest case since stringifying them gives us the path we want
		var/icon_ref = text_ref(icon)
		var/locate_icon_string = "[locate(icon_ref)]"

		icon_path = locate_icon_string

	else if(isicon(icon) && "[icon]" == "/icon")
		// icon objects generated from icon() at runtime are icons, but they ARENT files themselves, they represent icon files.
		// if the files they represent are compile time dmi files in the rsc, then
		// the rsc reference returned by fcopy_rsc() will be stringifiable to "icons/path/to/dmi_file.dmi"
		var/rsc_ref = fcopy_rsc(icon)

		var/icon_ref = text_ref(rsc_ref)

		var/icon_path_string = "[locate(icon_ref)]"

		icon_path = icon_path_string

	else if(istext(icon))
		var/rsc_ref = fcopy_rsc(icon)
		//if its the text path of an existing dmi file, the rsc reference returned by fcopy_rsc() will be stringifiable to a dmi path

		var/rsc_ref_ref = text_ref(rsc_ref)
		var/rsc_ref_string = "[locate(rsc_ref_ref)]"

		icon_path = rsc_ref_string

	if(is_valid_dmi_file(icon_path))
		return icon_path

	return FALSE

/**
 * generate an asset for the given icon or the icon of the given appearance for [thing], and send it to any clients in target.
 * Arguments:
 * * thing - either a /icon object, or an object that has an appearance (atom, image, mutable_appearance).
 * * target - either a reference to or a list of references to /client's or mobs with clients
 * * icon_state - string to force a particular icon_state for the icon to be used
 * * dir - dir number to force a particular direction for the icon to be used
 * * frame - what frame of the icon_state's animation for the icon being used
 * * moving - whether or not to use a moving state for the given icon
 * * sourceonly - if TRUE, only generate the asset and send back the asset url, instead of tags that display the icon to players
 * * extra_clases - string of extra css classes to use when returning the icon string
 * * keyonly - if TRUE, only returns the asset key to use get_asset_url manually. Overrides sourceonly.
 */
/proc/icon2html(atom/thing, client/target, icon_state, dir = SOUTH, frame = 1, moving = FALSE, sourceonly = FALSE, extra_classes = null, keyonly = FALSE)
	if (!thing)
		return

	var/key
	var/icon/icon2collapse = thing

	if (!target)
		return
	if (target == world)
		target = GLOB.clients

	var/list/targets
	if (!islist(target))
		targets = list(target)
	else
		targets = target
	if(!length(targets))
		return

	//check if the given object is associated with a dmi file in the icons folder. if it is then we dont need to do a lot of work
	//for asset generation to get around byond limitations
	var/icon_path = get_icon_dmi_path(thing)

	if (!isicon(icon2collapse))
		if (isfile(thing)) //special snowflake
			var/name = SANITIZE_FILENAME("[generate_asset_name(thing)].png")
			if (!SSassets.cache[name])
				SSassets.transport.register_asset(name, thing)
			for (var/thing2 in targets)
				SSassets.transport.send_assets(thing2, name)
			if(keyonly)
				return name
			if(sourceonly)
				return SSassets.transport.get_asset_url(name)
			return "<img class='[extra_classes] icon icon-misc' src='[SSassets.transport.get_asset_url(name)]'>"

		//its either an atom, image, or mutable_appearance, we want its icon var
		icon2collapse = thing.icon

		if (isnull(icon_state))
			icon_state = thing.icon_state
			//Despite casting to atom, this code path supports mutable appearances, so let's be nice to them
			if(isnull(icon_state) || (isatom(thing) && thing.flags_atom & HTML_USE_INITAL_ICON))
				icon_state = initial(thing.icon_state)
				if (isnull(dir))
					dir = initial(thing.dir)

		if (isnull(dir))
			dir = thing.dir

		// Commented out because this is seemingly our source of bad icon operations
		/* if (ishuman(thing)) // Shitty workaround for a BYOND issue.
			var/icon/temp = icon2collapse
			icon2collapse = icon()
			icon2collapse.Insert(temp, dir = SOUTH)
			dir = SOUTH*/
	else
		if (isnull(dir))
			dir = SOUTH
		if (isnull(icon_state))
			icon_state = ""

	icon2collapse = icon(icon2collapse, icon_state, dir, frame, moving)

	var/list/name_and_ref = generate_and_hash_rsc_file(icon2collapse, icon_path)//pretend that tuples exist

	var/rsc_ref = name_and_ref[1] //weird object thats not even readable to the debugger, represents a reference to the icons rsc entry
	var/file_hash = name_and_ref[2]
	key = "[name_and_ref[3]].png"

	if(!SSassets.cache[key])
		SSassets.transport.register_asset(key, rsc_ref, file_hash, icon_path)
	for (var/client_target in targets)
		SSassets.transport.send_assets(client_target, key)
	if(keyonly)
		return key
	if(sourceonly)
		return SSassets.transport.get_asset_url(key)
	return "<img class='[extra_classes] icon icon-[icon_state]' src='[SSassets.transport.get_asset_url(key)]'>"

//Costlier version of icon2html() that uses getFlatIcon() to account for overlays, underlays, etc. Use with extreme moderation, ESPECIALLY on mobs.
/proc/costly_icon2html(thing, target, sourceonly = FALSE)
	SHOULD_NOT_SLEEP(TRUE) // Sanity, for purpose of debugging with REALTIMEOFDAY below only
	if (!thing)
		return

	var/start_time = REALTIMEOFDAY
	if (isicon(thing))
		. = icon2html(thing, target)
	else
		var/icon/I = getFlatIcon(thing)
		. = icon2html(I, target, sourceonly = sourceonly)

	/* Debugguing due to gamebreaking performance in the Blend calls made by getFlatIcon (think 200ms+ per icon) and overtimes */
	if(istype(thing, /atom))
		var/atom/D = thing
		log_debug("costly_icon2html called on ref=[REF(D)], instance=[D], type=[D.type], with [length(D.overlays)] overlays, finished in [(REALTIMEOFDAY-start_time) / 10]s")
	else if(isicon(thing))
		var/icon/D = thing
		log_debug("costly_icon2html called on icon ref=[REF(D)], instance=[D] finished in [(REALTIMEOFDAY-start_time) / 10]s")
	else
		var/datum/D = thing
		log_debug("costly_icon2html called on unknown ref=[REF(D)], instance=[D], type=[D.type]")

/// Generate a filename for this asset
/// The same asset will always lead to the same asset name
/// (Generated names do not include file extention.)
/proc/generate_asset_name(file)
	return "asset.[md5(fcopy_rsc(file))]"

///Checks if the given iconstate exists in the given file, caching the result. Setting scream to TRUE will print a stack trace ONCE.
/proc/icon_exists(file, state, scream)
	var/static/list/screams = list()
	var/static/list/icon_states_cache = list()
	if(isnull(file) || isnull(state))
		return FALSE //This is common enough that it shouldn't panic, imo.

	if(isnull(icon_states_cache[file]))
		icon_states_cache[file] = list()
		for(var/istate in icon_states(file))
			icon_states_cache[file][istate] = TRUE

	if(isnull(icon_states_cache[file][state]))
		if(isnull(screams[file]) && scream)
			screams[file] = TRUE
			stack_trace("State [state] in file [file] does not exist.")
		return FALSE
	else
		return TRUE

/proc/BlendRGB(rgb1, rgb2, amount)
	var/list/RGB1 = ReadRGB(rgb1)
	var/list/RGB2 = ReadRGB(rgb2)

	// add missing alpha if needed
	if(length(RGB1) < length(RGB2))
		RGB1 += 255
	else if(length(RGB2) < length(RGB1))
		RGB2 += 255
	var/usealpha = length(RGB1) > 3

	var/r = round(RGB1[1] + (RGB2[1] - RGB1[1]) * amount, 1)
	var/g = round(RGB1[2] + (RGB2[2] - RGB1[2]) * amount, 1)
	var/b = round(RGB1[3] + (RGB2[3] - RGB1[3]) * amount, 1)
	var/alpha = usealpha ? round(RGB1[4] + (RGB2[4] - RGB1[4]) * amount, 1) : null

	return isnull(alpha) ? rgb(r, g, b) : rgb(r, g, b, alpha)

/proc/icon2base64(icon/icon)
	if(!isicon(icon))
		return FALSE
	var/savefile/dummySave = new("tmp/dummySave.sav")
	dummySave["dummy"] << icon
	var/iconData = dummySave.ExportText("dummy")
	var/list/partial = splittext(iconData, "{")
	. = replacetext(copytext_char(partial[2], 3, -5), "\n", "")  //if cleanup fails we want to still return the correct base64
	dummySave.Unlock()
	dummySave = null
	fdel("tmp/dummySave.sav")  //if you get the idea to try and make this more optimized, make sure to still call unlock on the savefile after every write to unlock it.

/**
 * Center's an image.
 * Requires:
 * The Image
 * The x dimension of the icon file used in the image
 * The y dimension of the icon file used in the image
 * eg: center_image(image_to_center, 32,32)
 * eg2: center_image(image_to_center, 96,96)
**/
/proc/center_image(image/image_to_center, x_dimension = 32, y_dimension = 32)
	if(!image_to_center)
		return

	if(!x_dimension || !y_dimension)
		return

	if((x_dimension == world.icon_size) && (y_dimension == world.icon_size))
		return image_to_center

	//Offset the image so that it's bottom left corner is shifted this many pixels
	//This makes it infinitely easier to draw larger inhands/images larger than world.iconsize
	//but still use them in game
	var/x_offset = -((x_dimension / world.icon_size) - 1) * (world.icon_size * 0.5)
	var/y_offset = -((y_dimension / world.icon_size) - 1) * (world.icon_size * 0.5)

	//Correct values under world.icon_size
	if(x_dimension < world.icon_size)
		x_offset *= -1
	if(y_dimension < world.icon_size)
		y_offset *= -1

	image_to_center.pixel_x = x_offset
	image_to_center.pixel_y = y_offset

	return image_to_center

//For creating consistent icons for human looking simple animals
/proc/get_flat_human_icon(icon_id, equipment_preset_dresscode, datum/preferences/prefs, dummy_key, showDirs = GLOB.cardinals, outfit_override)
	var/static/list/humanoid_icon_cache = list()
	if(!icon_id || !humanoid_icon_cache[icon_id])
		var/mob/living/carbon/human/dummy/body = generate_or_wait_for_human_dummy(dummy_key)

		if(prefs)
			prefs.copy_all_to(body)
			body.update_body()
			body.update_hair()

		// Assumption: Is a list
		if(outfit_override)
			for(var/obj/item/cur_item as anything in outfit_override)
				body.equip_to_appropriate_slot(cur_item)

		// Assumption: Is a string or path
		if(equipment_preset_dresscode)
			arm_equipment(body, equipment_preset_dresscode)

		var/icon/out_icon = icon('icons/effects/effects.dmi', "nothing")
		for(var/dir in showDirs)
			body.setDir(dir)
			var/icon/partial = getFlatIcon(body)
			out_icon.Insert(partial, dir = dir)

		humanoid_icon_cache[icon_id] = out_icon
		dummy_key ? unset_busy_human_dummy(dummy_key) : qdel(body)
		return out_icon
	else
		return humanoid_icon_cache[icon_id]

/proc/get_flat_human_copy_icon(mob/living/carbon/human/original, equipment_preset_dresscode, showDirs = GLOB.cardinals, outfit_override)
	var/mob/living/carbon/human/dummy/body = generate_or_wait_for_human_dummy(null)

	if(original)
		// From /datum/preferences/proc/copy_appearance_to
		body.age = original.age
		body.gender = original.gender
		body.skin_color = original.skin_color
		body.body_type = original.body_type
		body.body_size = original.body_size

		body.r_eyes = original.r_eyes
		body.g_eyes = original.g_eyes
		body.b_eyes = original.b_eyes

		body.r_hair = original.r_hair
		body.g_hair = original.g_hair
		body.b_hair = original.b_hair

		body.r_gradient = original.r_gradient
		body.g_gradient = original.g_gradient
		body.b_gradient = original.b_gradient
		body.grad_style = original.grad_style

		body.r_facial = original.r_facial
		body.g_facial = original.g_facial
		body.b_facial = original.b_facial

		body.r_skin = original.r_skin
		body.g_skin = original.g_skin
		body.b_skin = original.b_skin

		body.h_style = original.h_style
		body.f_style = original.f_style

		body.underwear = original.underwear
		body.undershirt = original.undershirt

		body.update_body()
		body.update_hair()

	// Assumption: Is a list
	if(outfit_override)
		for(var/obj/item/cur_item as anything in outfit_override)
			body.equip_to_appropriate_slot(cur_item)

	// Assumption: Is a string or path
	if(equipment_preset_dresscode)
		arm_equipment(body, equipment_preset_dresscode)

	var/icon/out_icon = icon('icons/effects/effects.dmi', "nothing")
	for(var/dir in showDirs)
		body.setDir(dir)
		var/icon/partial = getFlatIcon(body)
		out_icon.Insert(partial, dir = dir)

	// log_debug("get_flat_human_copy_icon called on ref=[REF(original)], instance=[original], type=[original.type], with [length(original.overlays)] overlays reduced to [length(body.overlays)] overlays")

	qdel(body)
	return out_icon
