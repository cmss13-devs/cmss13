/datum/picture
	var/picture_name = "picture"
	var/picture_desc = "This is a picture."
	/// List of weakrefs pointing at mobs that appear in this photo
	var/list/mobs_seen = list()
	/// List of weakrefs pointing at dead mobs that appear in this photo
	var/list/dead_seen = list()
	/// List of strings of face-visible humans in this photo
	var/list/names_seen = list()
	var/caption
	var/icon/picture_image
	var/icon/picture_icon
	var/psize_x = 96
	var/psize_y = 96

/datum/picture/New(name, desc, mobs_spotted, dead_spotted, names, image, icon, size_x, size_y, caption_, autogenerate_icon)
	if(!isnull(name))
		picture_name = name
	if(!isnull(desc))
		picture_desc = desc
	if(!isnull(mobs_spotted))
		for(var/mob/seen as anything in mobs_spotted)
			mobs_seen += WEAKREF(seen)
	if(!isnull(dead_spotted))
		for(var/mob/seen as anything in dead_spotted)
			dead_seen += WEAKREF(seen)
	if(!isnull(names))
		for(var/seen in names)
			names_seen += seen
	if(!isnull(image))
		picture_image = image
	if(!isnull(icon))
		picture_icon = icon
	if(!isnull(psize_x))
		psize_x = size_x
	if(!isnull(psize_y))
		psize_y = size_y
	if(!isnull(caption_))
		caption = caption_
	if(autogenerate_icon && !picture_icon && picture_image)
		regenerate_small_icon()

/datum/picture/proc/get_small_icon(iconstate)
	if(!picture_icon)
		regenerate_small_icon(iconstate)
	return picture_icon

/datum/picture/proc/regenerate_small_icon(iconstate)
	if(!picture_image)
		return
	var/icon/small_img = icon(picture_image)
	var/icon/ic = icon('icons/obj/items/paper.dmi', iconstate ? iconstate :"photo")
	small_img.Scale(8, 8)
	ic.Blend(small_img,ICON_OVERLAY, 13, 13)
	picture_icon = ic

/datum/picture/proc/Copy(greyscale = FALSE, cropx = 0, cropy = 0)
	var/datum/picture/P = new
	P.picture_name = picture_name
	P.picture_desc = picture_desc
	if(picture_image)
		P.picture_image = icon(picture_image) //Copy, not reference.
	if(picture_icon)
		P.picture_icon = icon(picture_icon)
	P.psize_x = psize_x - cropx * 2
	P.psize_y = psize_y - cropy * 2
	if(greyscale)
		if(picture_image)
			P.picture_image.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
		if(picture_icon)
			P.picture_icon.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
	if(cropx || cropy)
		if(picture_image)
			P.picture_image.Crop(cropx, cropy, psize_x - cropx, psize_y - cropy)
		P.regenerate_small_icon()
	return P
