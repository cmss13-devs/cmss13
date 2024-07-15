/datum/asset/spritesheet/medal
	name = "medal"

/datum/asset/spritesheet/medal/register()
	for(var/obj/item/clothing/accessory/medal/medal as anything in subtypesof(/obj/item/clothing/accessory/medal))
		var/icon/current_icon = icon(initial(medal.icon), initial(medal.icon_state), SOUTH)
		var/imgid = replacetext("[initial(medal.name)]", " ", "-")

		Insert(imgid, current_icon)
	return ..()
