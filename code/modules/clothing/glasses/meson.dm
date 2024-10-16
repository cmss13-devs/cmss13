
//meson goggles

/obj/item/clothing/glasses/meson
	name = "optical meson scanner"
	desc = "Used to shield the user's eyes from harmful electromagnetic emissions, also used as general safety goggles. Not adequate as welding protection."
	icon_state = "meson"
	item_state = "glasses"
	deactive_state = "degoggles"
	darkness_view = 0
	lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
	vision_flags = SEE_TURFS
	actions_types = list(/datum/action/item_action/toggle)
	toggleable = TRUE
	fullscreen_vision = /atom/movable/screen/fullscreen/meson
	req_skill = SKILL_ENGINEER
	req_skill_level = SKILL_ENGINEER_ENGI

/obj/item/clothing/glasses/meson/prescription
	name = "prescription optical meson scanner"
	desc = "Used for shield the user's eyes from harmful electromagnetic emissions, can also be used as safety googles. Contains prescription lenses."
	prescription = TRUE

/obj/item/clothing/glasses/meson/refurbished
	name = "refurbished meson scanner"
	desc = "Used to shield the user's eyes from harmful electromagnetic emissions, also used as general safety goggles. A special version with upgraded optics."
	icon_state = "refurb_meson"
	item_state = "glasses"
	darkness_view = 12
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	vision_flags = SEE_TURFS
	flags_inventory = COVEREYES
	flags_item = MOB_LOCK_ON_EQUIP
	fullscreen_vision = /atom/movable/screen/fullscreen/meson/refurb
