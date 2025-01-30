/datum/skin_color
	var/name
	var/icon_name

	var/color

/datum/skin_color/New()
	. = ..()

	var/icon/icon_to_use = icon(/datum/species::icobase, "[icon_name]_torso_[/datum/body_size/thin::icon_name]_[/datum/body_type/nomuscle::icon_name]_[get_gender_name(FEMALE)]")
	color = icon_to_use.GetPixel(icon_to_use.Width() / 2, icon_to_use.Height() / 2)

/datum/skin_color/cmplayer
	name = "Extra Pale"
	icon_name = "pale0"

/datum/skin_color/pale1
	name = "Pale 1"
	icon_name = "pale1"

/datum/skin_color/pale2
	name = "Pale 2"
	icon_name = "pale2"

/datum/skin_color/pale3
	name = "Pale 3"
	icon_name = "pale3"

/datum/skin_color/tan1
	name = "Tan 1"
	icon_name = "tan1"

/datum/skin_color/tan2
	name = "Tan 2"
	icon_name = "tan2"

/datum/skin_color/tan3
	name = "Tan 3"
	icon_name = "tan3"

/datum/skin_color/dark1
	name = "Dark 1"
	icon_name = "dark1"

/datum/skin_color/dark2
	name = "Dark 2"
	icon_name = "dark2"

/datum/skin_color/dark3
	name = "Dark 3"
	icon_name = "dark3"

/datum/skin_color/melanated
	name = "Melanated"
	icon_name = "dark4"
