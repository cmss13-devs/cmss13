// Holds props for helmet garb

/obj/item/prop/helmetgarb
	icon = 'icons/obj/items/clothing/helmet_garb.dmi'
	icon_state = null
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/misc.dmi',
		)
	w_class = SIZE_TINY
	garbage = TRUE

/obj/item/prop/helmetgarb/Initialize(mapload, ...)
	. = ..()
	if(garbage)
		flags_obj |= OBJ_IS_HELMET_GARB

/obj/item/prop/helmetgarb/gunoil
	name = "gun oil"
	desc = "It is a bottle of oil, for your gun. Don't fall for the rumors, the M41A is NOT a self-cleaning firearm."
	icon_state = "gunoil"

/obj/item/prop/helmetgarb/netting
	name = "combat netting"
	desc = "Probably combat netting for a helmet. Probably just an extra hairnet that got ordered for the phantom Almayer cooking staff. Probably useless."
	icon_state = "netting"
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/helmet_covers.dmi',
		)

/obj/item/prop/helmetgarb/netting/desert
	name = "desert combat netting"
	icon_state = "netting_desert"

/obj/item/prop/helmetgarb/netting/jungle
	name = "jungle combat netting"
	icon_state = "netting_jungle"

/obj/item/prop/helmetgarb/netting/urban
	name = "urban combat netting"
	icon_state = "netting_urban"

/obj/item/prop/helmetgarb/spent_buckshot
	name = "spent buckshot"
	desc = "Three spent rounds of good ol' buckshot. You know they used to paint these green? Strange times."
	icon_state = "spent_buckshot"
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/ammo.dmi',
		)

/obj/item/prop/helmetgarb/spent_slug
	name = "spent slugs"
	gender = PLURAL
	desc = "For when you need to knock your target down with superior stopping power. These three have already been fired."
	icon_state = "spent_slug"
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/ammo.dmi',
		)

/obj/item/prop/helmetgarb/spent_flech
	name = "spent flechette"
	desc = "The more you fire these, the more you're reminded that a fragmentation grenade is probably more effective at fulfilling the same purpose. Say, aren't these supposed to eject from your gun?"
	icon_state = "spent_flech"
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/ammo.dmi',
		)

/obj/item/prop/helmetgarb/cartridge
	name = "cartridge"
	desc = "This is the bullet from a Type 71 Pulse Rifle. It is deformed from impact against an armored surface. It's been reduced to a lucky keepsake now."
	icon_state = "cartridge"
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/ammo.dmi',
	)
	item_state_slots = list(WEAR_AS_GARB = "bullet")

/obj/item/prop/helmetgarb/prescription_bottle
	name = "prescription medication"
	desc = "Anti-anxiety meds? Amphetamines? The cure for Sudden Sleep Disorder? The label can't be read, leaving the now absent contents forever a mystery. The cap is screwed on tighter than any ID lock."
	icon_state = "prescription_bottle"
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/medical.dmi',
	)

/obj/item/prop/helmetgarb/raincover
	name = "raincover"
	desc = "The standard M10 combat helmet is already water-resistant at depths of up to 10 meters. This makes the top potentially water-proof. At least it's something."
	icon_state = "raincover"
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/helmet_covers.dmi',
	)

/obj/item/prop/helmetgarb/raincover/jungle
	name = "jungle raincover"
	icon_state = "raincover_jungle"

/obj/item/prop/helmetgarb/raincover/desert
	name = "desert raincover"
	icon_state = "raincover_desert"

/obj/item/prop/helmetgarb/raincover/urban
	name = "urban raincover"
	icon_state = "raincover_urban"

/obj/item/prop/helmetgarb/rabbitsfoot
	name = "Rabbit's Foot"
	desc = "Lucky for you, but not the rabbit, didn't really do it much good."
	icon_state = "rabbitsfoot"

/obj/item/prop/helmetgarb/rosary
	name = "rosary"
	desc = "Jesus Saves Lives!"
	icon_state = "rosary"
	item_state_slots = list(WEAR_AS_GARB = "rosary")

/obj/item/prop/helmetgarb/lucky_feather
	name = "\improper Red Lucky Feather"
	desc = "It is a riotous red color, made of really crummy plastic and synthetic threading, you know, the same sort of material every Corporate Liaison's spine is made of."
	icon_state = "lucky_feather"
	item_state_slots = list(WEAR_AS_GARB = "lucky_feather")
	color = "red"

/obj/item/prop/helmetgarb/lucky_feather/blue
	name = "\improper Blue Lucky Feather"
	desc = "It is a brilliant blue color. You think you might have seen a bluejay in a holo-theatre once."
	item_state_slots = list(WEAR_AS_GARB = "lucky_feather_blue")
	color = "blue"

/obj/item/prop/helmetgarb/lucky_feather/purple
	name = "\improper Purple Lucky Feather"
	desc = "It is a plucky purple color. Legend has it a station AI known as Shakespeare simulated 1000 monkeys typing gibberish in order to replicate the actual works of Shakespeare. Art critics are on the fence if this is the first instance of true artificial abstract art."
	item_state_slots = list(WEAR_AS_GARB = "lucky_feather_purple")
	color = "purple"

/obj/item/prop/helmetgarb/lucky_feather/yellow
	name = "\improper Yellow Lucky Feather"
	desc = "It is an unyielding yellow color. They say the New Kansas colony produces more carpenters per capita than any other colony in all of UA controlled space."
	item_state_slots = list(WEAR_AS_GARB = "lucky_feather_yellow")
	color = "yellow"

#define NVG_SHAPE_COSMETIC 1
#define NVG_SHAPE_BROKEN 2
#define NVG_SHAPE_PATCHED 3
#define NVG_SHAPE_FINE 4

/obj/item/prop/helmetgarb/helmet_nvg
	name = "\improper M2 night vision goggles"
	desc = "USCM standard M2 Night vision goggles for military operations. Requires a battery in order to work"
	icon_state = "nvg"
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/goggles.dmi',
	)
	gender = PLURAL
	garbage = FALSE
	w_class = SIZE_MEDIUM

	var/nvg_maxhealth = 125
	var/nvg_health = 125

	/// How much charge the cell should have at most. -1 is infinite
	var/cell_max_charge = 2500

	var/activated = FALSE
	var/nightvision = FALSE
	var/shape = NVG_SHAPE_FINE

	var/active_powered_icon_state = "nvg_down_powered"
	var/active_icon_state = "nvg_down"
	var/inactive_icon_state = "nvg"

	var/datum/action/item_action/activation
	var/obj/item/clothing/head/attached_item
	var/mob/living/attached_mob
	var/lighting_alpha = 100
	var/matrix_color = NV_COLOR_GREEN

/obj/item/prop/helmetgarb/helmet_nvg/Initialize(mapload, ...)
	. = ..()
	if(shape != NVG_SHAPE_COSMETIC)
		AddComponent(/datum/component/cell, cell_max_charge, TRUE, charge_drain = 8)
		RegisterSignal(src, COMSIG_CELL_TRY_RECHARGING, PROC_REF(cell_try_recharge))
		RegisterSignal(src, COMSIG_CELL_OUT_OF_CHARGE, PROC_REF(on_power_out))

/obj/item/prop/helmetgarb/helmet_nvg/on_enter_storage(obj/item/storage/internal/S)
	..()

	if(!istype(S))
		return

	remove_attached_item()

	var/obj/item/MO = S.master_object
	if(!istype(MO, /obj/item/clothing/head/helmet/marine) && !istype(MO, /obj/item/clothing/head/cmcap)) // Do not bother if it's not a helmet or at least a hat
		return

	attached_item = MO

	RegisterSignal(attached_item, COMSIG_PARENT_QDELETING, PROC_REF(remove_attached_item))
	RegisterSignal(attached_item, COMSIG_ITEM_EQUIPPED, PROC_REF(toggle_check))

	if(ismob(attached_item.loc))
		set_attached_mob(attached_item.loc)


/obj/item/prop/helmetgarb/helmet_nvg/attackby(obj/item/A as obj, mob/user as mob)
	if(HAS_TRAIT(A, TRAIT_TOOL_SCREWDRIVER))
		repair(user)

	else
		..()

/obj/item/prop/helmetgarb/helmet_nvg/proc/cell_try_recharge(datum/source, mob/living/user)
	SIGNAL_HANDLER

	if(user.action_busy)
		return COMPONENT_CELL_NO_RECHARGE

	if(src != user.get_inactive_hand())
		to_chat(user, SPAN_WARNING("You need to hold [src] in hand in order to recharge them."))
		return COMPONENT_CELL_NO_RECHARGE

	if(shape == NVG_SHAPE_COSMETIC)
		to_chat(user, SPAN_WARNING("There is no connector for the power cell inside [src]."))
		return COMPONENT_CELL_NO_RECHARGE

	if(shape == NVG_SHAPE_BROKEN)
		to_chat(user, SPAN_WARNING("You need to repair [src] first."))
		return COMPONENT_CELL_NO_RECHARGE


/obj/item/prop/helmetgarb/helmet_nvg/proc/repair(mob/user as mob)
	if(user.action_busy)

		return
	if(src != user.get_inactive_hand())
		to_chat(user, SPAN_WARNING("You need to hold \the [src] in hand in order to repair them."))
		return
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE)) // level 2 is enough to repair damaged NVG
		to_chat(user, SPAN_WARNING("You are not trained to repair electronics..."))
		return

	if(shape == NVG_SHAPE_BROKEN)
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED)) // level 3 is needed to repair broken NVG
			to_chat(user, SPAN_WARNING("Repair of this complexity is too difficult for you, find someone more trained."))
			return

		to_chat(user, "You begin to repair \the [src].")
		if(!do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD, src))
			to_chat(user, SPAN_WARNING("You were interrupted."))
			return
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
		color = "#bebebe"
		shape = NVG_SHAPE_PATCHED
		to_chat(user, "You successfully patch \the [src].")
		nvg_maxhealth = 65
		nvg_health = 65
		return

	else if(nvg_health == nvg_maxhealth)
		if(shape == NVG_SHAPE_PATCHED)
			to_chat(user, SPAN_WARNING("Already repaired, nothing more you can do."))
		else if(shape == NVG_SHAPE_FINE)
			to_chat(user, SPAN_WARNING("Nothing to fix."))
		else if(shape == NVG_SHAPE_COSMETIC)

			to_chat(user, SPAN_WARNING("It's nothing but a husk of what it used to be."))

	else
		to_chat(user, "You begin to repair \the [src].")
		if(do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD, src))
			to_chat(user, "You successfully repair \the [src].")
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
			nvg_health = nvg_maxhealth
		else
			to_chat(user, SPAN_WARNING("You were interrupted."))


/obj/item/prop/helmetgarb/helmet_nvg/get_examine_text(mob/user)
	. = ..()

	if(shape == NVG_SHAPE_BROKEN)
		. += "They appear to be broken. Maybe someone competent can fix them."
	else

		if(shape == NVG_SHAPE_PATCHED)
			. += "They are covered in scratches and have traces of a recent repair."

		var/nvg_health_procent = nvg_health / nvg_maxhealth * 100
		if(nvg_health_procent > 70)
			. += "They appear to be in good shape."
		else if(nvg_health_procent > 50)
			. += "They are visibly damaged."
		else if(nvg_health_procent > 30)
			. += "It's unlikely they can sustain more damage."
		else if(nvg_health_procent >= 0)
			. += "They are falling apart."

/obj/item/prop/helmetgarb/helmet_nvg/on_exit_storage(obj/item/storage/S)
	remove_attached_item()
	return ..()


/obj/item/prop/helmetgarb/helmet_nvg/proc/set_attached_mob(mob/User)
	attached_mob = User
	activation = new /datum/action/item_action/toggle(src, attached_item)
	activation.give_to(attached_mob)
	add_verb(attached_mob, /obj/item/prop/helmetgarb/helmet_nvg/proc/toggle)
	RegisterSignal(attached_mob, COMSIG_HUMAN_XENO_ATTACK, PROC_REF(break_nvg))
	RegisterSignal(attached_item, COMSIG_ITEM_DROPPED, PROC_REF(remove_attached_mob))

/obj/item/prop/helmetgarb/helmet_nvg/proc/remove_attached_item()
	SIGNAL_HANDLER

	if(!attached_item)
		return
	UnregisterSignal(attached_item, list(
		COMSIG_PARENT_QDELETING,
		COMSIG_ITEM_EQUIPPED
	))

	if(activated)
		activated = FALSE
		icon_state = inactive_icon_state

	remove_attached_mob()
	attached_item = null

/obj/item/prop/helmetgarb/helmet_nvg/proc/remove_attached_mob()
	UnregisterSignal(attached_item, COMSIG_ITEM_DROPPED)
	qdel(activation)
	if(!attached_mob)
		return
	UnregisterSignal(attached_mob, list(
		COMSIG_HUMAN_XENO_ATTACK,
		COMSIG_MOB_CHANGE_VIEW
	))
	remove_verb(attached_mob, /obj/item/prop/helmetgarb/helmet_nvg/proc/toggle)
	remove_nvg()
	attached_mob = null

/obj/item/prop/helmetgarb/helmet_nvg/proc/toggle_check(obj/item/I, mob/living/carbon/human/user, slot)
	SIGNAL_HANDLER

	if(attached_mob != user && slot == WEAR_HEAD)
		set_attached_mob(user)

	if(slot == WEAR_HEAD && !nightvision && activated && !SEND_SIGNAL(src, COMSIG_CELL_CHECK_CHARGE) && shape > NVG_SHAPE_BROKEN)
		enable_nvg(user)
	else
		remove_nvg()


/obj/item/prop/helmetgarb/helmet_nvg/proc/enable_nvg(mob/living/carbon/human/user)
	if(nightvision)
		remove_nvg()

	RegisterSignal(user, COMSIG_HUMAN_POST_UPDATE_SIGHT, PROC_REF(update_sight))

	if(user.client?.prefs?.night_vision_preference)
		matrix_color = user.client.prefs.nv_color_list[user.client.prefs.night_vision_preference]
	user.add_client_color_matrix("nvg", 99, color_matrix_multiply(color_matrix_saturation(0), color_matrix_from_string(matrix_color)))
	user.overlay_fullscreen("nvg", /atom/movable/screen/fullscreen/flash/noise/nvg)
	user.overlay_fullscreen("nvg_blur", /atom/movable/screen/fullscreen/brute/nvg, 3)
	playsound(user, 'sound/handling/toggle_nv1.ogg', 25)
	nightvision = TRUE
	user.update_sight()

	icon_state = active_powered_icon_state
	attached_item.update_icon()
	activation.update_button_icon()

	SEND_SIGNAL(src, COMSIG_CELL_START_TICK_DRAIN)


/obj/item/prop/helmetgarb/helmet_nvg/proc/update_sight(mob/M)
	SIGNAL_HANDLER

	if(lighting_alpha < 255)
		M.see_in_dark = 12
	M.lighting_alpha = lighting_alpha
	M.sync_lighting_plane_alpha()


/obj/item/prop/helmetgarb/helmet_nvg/proc/remove_nvg()
	SIGNAL_HANDLER

	if(!attached_mob)
		return

	if(nightvision)
		attached_mob.remove_client_color_matrix("nvg", 1 SECONDS)
		attached_mob.clear_fullscreen("nvg", 0.5 SECONDS)
		attached_mob.clear_fullscreen("nvg_blur", 0.5 SECONDS)
		playsound(attached_mob, 'sound/handling/toggle_nv2.ogg', 25)
		nightvision = FALSE

		UnregisterSignal(attached_mob, COMSIG_HUMAN_POST_UPDATE_SIGHT)

		if(activated)
			icon_state = active_icon_state
			attached_item.update_icon()
			activation.update_button_icon()

		attached_mob.update_sight()

		SEND_SIGNAL(src, COMSIG_CELL_STOP_TICK_DRAIN)


/obj/item/prop/helmetgarb/helmet_nvg/process(delta_time)
	if(!attached_mob)
		return PROCESS_KILL

	if(!activated || !attached_item || attached_mob.is_dead())
		on_power_out()
		return

	if(!attached_item.has_garb_overlay())
		to_chat(attached_mob, SPAN_WARNING("You cannot use \the [src] when they are hidden."))
		remove_nvg()
		return


/obj/item/prop/helmetgarb/helmet_nvg/proc/on_power_out(datum/source)
	SIGNAL_HANDLER

	if(activated && !attached_mob.is_dead())
		to_chat(attached_mob, SPAN_WARNING("[src] emit a low power warning and immediately shut down!"))
	remove_nvg()

/obj/item/prop/helmetgarb/helmet_nvg/ui_action_click(mob/owner, obj/item/holder)
	toggle_nods(owner)


/obj/item/prop/helmetgarb/helmet_nvg/proc/toggle()
	set category = "Object"
	set name = "Toggle M2 night vision goggles"

	var/obj/item/clothing/head/helmet/marine/H = usr.get_item_by_slot(WEAR_HEAD)
	if(istype(H))
		for(var/obj/item/prop/helmetgarb/helmet_nvg/G in H.pockets.contents)
			G.toggle_nods(usr)
			break


/obj/item/prop/helmetgarb/helmet_nvg/proc/toggle_nods(mob/living/carbon/human/user)
	if(user.is_mob_incapacitated())
		return

	if(!attached_item)
		return

	if(!attached_item.has_garb_overlay())
		to_chat(user, SPAN_WARNING("You cannot use \the [src] when they are hidden."))
		return

	if(user.client.view > 7 && shape != NVG_SHAPE_COSMETIC)
		to_chat(user, SPAN_WARNING("You cannot use \the [src] while using optics."))
		return

	activated = !activated

	if(activated)
		to_chat(user, SPAN_NOTICE("You flip the goggles down."))
		icon_state = active_icon_state
		if(!SEND_SIGNAL(src, COMSIG_CELL_CHECK_CHARGE) && user.head == attached_item && shape > NVG_SHAPE_BROKEN)
			enable_nvg(user)
		else
			icon_state = active_icon_state
			attached_item.update_icon()
			activation.update_button_icon()

		if(shape != NVG_SHAPE_COSMETIC)
			RegisterSignal(user, COMSIG_MOB_CHANGE_VIEW, PROC_REF(change_view)) // will flip non-cosmetic nvgs back up when zoomed

	else
		to_chat(user, SPAN_NOTICE("You push \the [src] back up onto your helmet."))

		icon_state = inactive_icon_state
		attached_item.update_icon()
		activation.update_button_icon()

		remove_nvg()
		UnregisterSignal(user, COMSIG_MOB_CHANGE_VIEW)

/obj/item/prop/helmetgarb/helmet_nvg/proc/change_view(mob/M, new_size)
	SIGNAL_HANDLER

	if(new_size > 7) // cannot use binos with NVG
		toggle_nods(M)

/obj/item/prop/helmetgarb/helmet_nvg/proc/break_nvg(mob/living/carbon/human/user, list/slashdata, mob/living/carbon/xenomorph/Xeno) //xenos can break NVG if aim head
	SIGNAL_HANDLER

	if(check_zone(Xeno.zone_selected) == "head" && user == attached_mob)
		nvg_health -= slashdata["n_damage"] // damage can be adjusted here
	if(nvg_health <= 0)
		nvg_health = 0
		user.visible_message(SPAN_WARNING("\The [src] on [user]'s head break with a crinkling noise."),
			SPAN_WARNING("Your [src.name] break with a crinkling noise."),
			SPAN_WARNING("You hear a crinkling noise, as if something was broken in your helmet."))
		playsound(user, "bone_break", 30, TRUE)
		src.color = "#4e4e4e"
		if(shape != NVG_SHAPE_COSMETIC)
			shape = NVG_SHAPE_BROKEN
		var/obj/item/clothing/head/helmet/marine/H = attached_item
		H.pockets.remove_from_storage(src, get_turf(H))

/obj/item/prop/helmetgarb/helmet_nvg/cosmetic //for "custom loadout", purely cosmetic
	name = "old M2 night vision goggles"
	desc = "This pair has been gutted of all electronics and therefore not working. But hey, they make you feel tacticool, and that's all that matters, right?"
	shape = NVG_SHAPE_COSMETIC
	garbage = TRUE

/obj/item/prop/helmetgarb/helmet_nvg/cosmetic/break_nvg(mob/living/carbon/human/user, list/slashdata, mob/living/carbon/xenomorph/Xeno)
	return

/obj/item/prop/helmetgarb/helmet_nvg/marsoc //for Marine Raiders
	name = "\improper Tactical M3 night vision goggles"
	desc = "With an integrated self-recharging battery, nothing can stop you. Put them on your helmet and press the button and it's go-time."
	cell_max_charge = -1

#undef NVG_SHAPE_COSMETIC
#undef NVG_SHAPE_BROKEN
#undef NVG_SHAPE_PATCHED
#undef NVG_SHAPE_FINE

/obj/item/prop/helmetgarb/flair_initech
	name = "\improper Initech flair"
	desc = "Flair for some weird tech company back on Earth. How did they get promotional material this far out in the rim?"
	icon_state = "flair_initech"
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/patches_flairs.dmi',
	)

/obj/item/prop/helmetgarb/flair_io
	name = "\improper Io flair"
	desc = "The Arcturians might be our allies now, but Io is forever a stain on trans-species relations. Never forget those who gave their lives aboard the USS Doramin."
	icon_state = "flair_io"
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/patches_flairs.dmi',
	)

/obj/item/prop/helmetgarb/flair_peace
	name = "\improper Peace flair"
	desc = "Doesn't matter when it's Arcturian, baby."
	icon_state = "flair_peace_smiley"
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/patches_flairs.dmi',
	)

/obj/item/prop/helmetgarb/flair_uscm
	name = "\improper USCM flair"
	desc = "These pins get handed out like candy at enlistment offices. Wear it with pride marine."
	icon_state = "flair_uscm"
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/patches_flairs.dmi',
	)

/obj/item/prop/helmetgarb/spacejam_tickets
	name = "\improper Tickets to Space Jam"
	desc = "Two original, crisp, orange, tickets to the one and only Space Jam of 2181. And what a jam it was."
	icon_state = "tickets_to_space_jam"

/obj/item/prop/helmetgarb/riot_shield
	name = "\improper RC6 riot shield"
	desc = "The complimentary, but sold separate face shield associated with the RC6 riot helmet."
	icon_state = "riot_shield"
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/visors.dmi',
	)

/obj/item/prop/helmetgarb/helmet_gasmask
	name = "\improper M5 integrated gasmask"
	desc = "The USCM had its funding pulled for these when it became apparent that not every deployed enlisted was wearing a helmet 24/7; much to the bafflement of UA High Command."
	icon_state = "gasmask"
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/visors.dmi',
	)

/obj/item/prop/helmetgarb/helmet_gasmask/on_enter_storage(obj/item/storage/internal/helmet_internal_inventory)
	..()
	if(!istype(helmet_internal_inventory))
		return
	var/obj/item/clothing/head/helmet/helmet_item = helmet_internal_inventory.master_object

	if(!istype(helmet_item))
		return

	helmet_item.flags_inventory |= BLOCKGASEFFECT
	helmet_item.flags_inv_hide |= HIDEFACE

/obj/item/prop/helmetgarb/helmet_gasmask/on_exit_storage(obj/item/storage/internal/helmet_internal_inventory)
	..()
	if(!istype(helmet_internal_inventory))
		return
	var/obj/item/clothing/head/helmet/helmet_item = helmet_internal_inventory.master_object

	if(!istype(helmet_item))
		return

	helmet_item.flags_inventory &= ~(BLOCKGASEFFECT)
	helmet_item.flags_inv_hide &= ~(HIDEFACE)

/obj/item/prop/helmetgarb/trimmed_wire
	name = "trimmed barbed wire"
	desc = "It is a length of barbed wire that's had most of the sharp points filed down so that it is safe to handle."
	icon_state = "trimmed_wire"

/obj/item/prop/helmetgarb/bullet_pipe
	name = "10x99mm XM43E1 casing pipe"
	desc = "The XM43E1 was an experimental weapons platform briefly fielded by the USCM and Wey-Yu PMC teams. It was manufactured by ARMAT systems at the Atlas weapons facility. Unfortunately the project had its funding pulled alongside the M5 integrated gasmask program. This spent casing has been converted into a pipe, but there is too much tar in the mouthpiece for it to be useable."
	icon_state = "bullet_pipe"
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/ammo.dmi',
	)

/obj/item/prop/helmetgarb/chaplain_patch
	name = "\improper USCM chaplain helmet patch"
	desc = "This patch is all that remains of the Chaplaincy of the USS Almayer, along with the Chaplains themselves. Both no longer exist as a result of losses suffered during Operation Tychon Tackle."
	icon_state = "chaplain_patch"
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/patches_flairs.dmi',
		)
	flags_obj = OBJ_NO_HELMET_BAND

/obj/item/prop/helmetgarb/family_photo
	name = "family photo"
	desc = ""
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "photo_item"
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/misc.dmi',
	)
	item_state_slots = list(WEAR_AS_GARB = "paper") //PLACEHOLDER
	///The human who spawns with the photo
	var/datum/weakref/owner
	///The belonging human name
	var/owner_name
	///The belonging human faction
	var/owner_faction
	///Text written on the back
	var/scribble

/obj/item/prop/helmetgarb/family_photo/pickup(mob/user, silent)
	. = ..()
	if(!owner)
		RegisterSignal(user, COMSIG_POST_SPAWN_UPDATE, PROC_REF(set_owner), override = TRUE)


///Sets the owner of the family photo to the human it spawns with, needs var/source for signals
/obj/item/prop/helmetgarb/family_photo/proc/set_owner(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_POST_SPAWN_UPDATE)
	var/mob/living/carbon/human/user = source
	owner = WEAKREF(user)
	owner_name = user.name
	owner_faction = user.faction

/obj/item/prop/helmetgarb/family_photo/get_examine_text(mob/user)
	. = ..()
	if(scribble)
		. += "\"[scribble]\" is written on the back of the photo."
	if(user.weak_reference == owner)
		. += "A photo of you and your family."
		return
	if(user.faction == owner_faction)
		. += "A photo of [owner_name] and their family."
		return
	. += "A photo of a family you do not know."

/obj/item/prop/helmetgarb/family_photo/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	if(HAS_TRAIT(attacking_item, TRAIT_TOOL_PEN) || istype(attacking_item, /obj/item/toy/crayon))
		if(scribble)
			to_chat(user, SPAN_NOTICE("[src] has already been written on."))
			return
		var/new_text = copytext(strip_html(tgui_input_text(user, "What would you like to write on the back of [src]?", "Photo Writing")), 1, 128)

		if(!loc == user)
			to_chat(user, SPAN_NOTICE("You need to be holding [src] to write on it."))
			return
		if(!user.stat == CONSCIOUS)
			to_chat(user, SPAN_NOTICE("You cannot write on [src] in this state."))
			return
		scribble = new_text
		playsound(src, "paper_writing", 15, TRUE)
	return TRUE

/obj/item/prop/helmetgarb/compass
	name = "compass"
	desc = "It always faces north. Are you sure it is not broken?"
	icon = 'icons/obj/items/tools.dmi'
	icon_state = "compass"
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/misc.dmi',
	)
	item_state_slots = list(WEAR_AS_GARB = "paper") //PLACEHOLDER
	w_class = SIZE_SMALL

/obj/item/prop/helmetgarb/compass/get_examine_text(mob/user)
	. = ..()
	if(is_ground_level(user.z) && !SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_IN_SPACE])
		. += SPAN_NOTICE("It seems you are facing [dir2text(user.dir)].")
		return
	. += SPAN_NOTICE("The needle is not moving.")

/obj/item/prop/helmetgarb/bug_spray
	name = "insect repellent"
	desc = "A store-brand insect repellent, to keep any variety of pest or mosquito away from you."
	icon = 'icons/obj/items/spray.dmi'
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/misc.dmi',
	)
	icon_state = "pestspray"
	item_state_slots = list(WEAR_AS_GARB = "canteen") //PLACEHOLDER
	w_class = SIZE_SMALL
