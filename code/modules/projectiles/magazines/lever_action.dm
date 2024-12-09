/*
Lever-action bullet handfuls!
Similar to shotguns.dm but not exactly.
*/

/obj/item/ammo_magazine/lever_action
	name = "box of 45-70 rounds"
	desc = "A box filled with handfuls of 45-70 Govt. rounds, for the old-timed."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony/marksman_rifles.dmi'
	icon_state = "45-70-box"
	item_state = "45-70-box"
	default_ammo = /datum/ammo/bullet/lever_action
	caliber = "45-70"
	gun_type = /obj/item/weapon/gun/lever_action
	max_rounds = 90
	w_class = SIZE_LARGE
	flags_magazine = AMMUNITION_REFILLABLE|AMMUNITION_HANDFUL_BOX
	handful_state = "lever_action_bullet"
	transfer_handful_amount = 9


/obj/item/ammo_magazine/lever_action/training
	name = "box of 45-70 blanks"
	desc = "A box filled with training lever action 45-70 rounds that aren't very damaging... unless you fire them point-blank or something."
	icon_state = "45-70-training-box"
	item_state = "45-70-training-box"
	default_ammo = /datum/ammo/bullet/lever_action/training
	handful_state = "training_lever_action_bullet"

//unused
/obj/item/ammo_magazine/lever_action/marksman
	name = "box of marksman 45-70 rounds"
	desc = "A box filled with marksman lever action 45-70 rounds, which have a lower-density, more precise bullet package."
	icon_state = "45-70-marksman-box"
	item_state = "45-70-marksman-box"
	default_ammo = /datum/ammo/bullet/lever_action/marksman
	handful_state = "marksman_lever_action_bullet"

//unused
/obj/item/ammo_magazine/lever_action/tracker
	name = "box of tracker 45-70 rounds"
	desc = "A box filled with tracker lever action 45-70 rounds, which replace some of the bullet package with an electronic tracking chip."
	icon_state = "45-70-tracker-box"
	item_state = "45-70-tracker-box"
	default_ammo = /datum/ammo/bullet/lever_action/tracker
	handful_state = "tracking_lever_action_bullet"

/obj/item/ammo_magazine/lever_action/xm88
	name = "box of .458 SOCOM rounds"
	desc = "A box filled with handfuls of .458 SOCOM rounds, designed for use with the XM88 heavy rifle."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/marksman_rifles.dmi'
	icon_state = "458-box"
	item_state = "458-box"
	default_ammo = /datum/ammo/bullet/lever_action/xm88
	max_rounds = 100
	caliber = ".458"
	gun_type = /obj/item/weapon/gun/lever_action/xm88
	handful_state = "boomslang_bullet"

//-------------------------------------------------------

/obj/item/ammo_magazine/internal/lever_action
	name = "lever action tube"
	desc = "An internal magazine. It is not supposed to be seen or removed."
	default_ammo = /datum/ammo/bullet/lever_action
	caliber = "45-70"
	max_rounds = 9
	chamber_closed = 0

/obj/item/ammo_magazine/internal/lever_action/xm88
	name = "\improper XM88 heavy rifle tube"
	desc = "An internal magazine. It is not supposed to be seen or removed."
	default_ammo = /datum/ammo/bullet/lever_action/xm88
	caliber = ".458"
	max_rounds = 9
	chamber_closed = 0

//-------------------------------------------------------

/*
Handfuls of lever_action rounds. For spawning directly on mobs in roundstart, ERTs, etc
*/

/obj/item/ammo_magazine/handful/lever_action
	name = "handful of rounds (45-70)"
	desc = "A handful of standard 45-70 Govt. rounds."
	icon_state = "lever_action_bullet_9"
	default_ammo = /datum/ammo/bullet/lever_action
	caliber = "45-70"
	max_rounds = 9
	current_rounds = 9
	gun_type = /obj/item/weapon/gun/lever_action
	handful_state = "lever_action_bullet"
	transfer_handful_amount = 9

/obj/item/ammo_magazine/handful/lever_action/training
	name = "handful of blanks (45-70)"
	desc = "A handful of blank 45-70 Govt. rounds. These rounds are blanks, which are mostly harmless.... just don't shoot them at point-blank range."
	icon_state = "training_lever_action_bullet_9"
	default_ammo = /datum/ammo/bullet/lever_action/training
	handful_state = "training_lever_action_bullet"

//unused
/obj/item/ammo_magazine/handful/lever_action/tracker
	name = "handful of tracker 45-70 rounds (45-70)"
	desc = "A handful of tracker 45-70 Govt. rounds. Some of their bullet package's been replaced with a chip that when fired can be picked up by Motion Detectors."
	icon_state = "tracking_lever_action_bullet_9"
	default_ammo = /datum/ammo/bullet/lever_action/tracker
	handful_state = "tracking_lever_action_bullet"

//unused
/obj/item/ammo_magazine/handful/lever_action/marksman
	name = "handful of marksman 45-70 rounds (45-70)"
	desc = "A handful of marksman 45-70 Govt. rounds. Their small bullet package reduces damage, but increases penetration and bullet velocity."
	icon_state = "marksman_lever_action_bullet_9"
	default_ammo = /datum/ammo/bullet/lever_action/marksman
	handful_state = "marksman_lever_action_bullet"

/obj/item/ammo_magazine/handful/lever_action/xm88
	name = "handful of .458 SOCOM rounds (.458)"
	desc = "A handful of .458 SOCOM rounds, chambered for the XM88 heavy rifle."
	caliber = ".458"
	icon_state = "marksman_lever_action_bullet_9"
	default_ammo = /datum/ammo/bullet/lever_action/xm88
	handful_state = "boomslang_bullet"
