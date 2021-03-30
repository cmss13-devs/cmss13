// Holds props for helmet garb

/obj/item/prop/helmetgarb
	name = "Placeholder"
	desc = "placeholder"
	icon = 'icons/obj/items/helmet_garb.dmi'
	icon_state = "placeholder"
	w_class = SIZE_TINY
	garbage = TRUE

/obj/item/prop/helmetgarb/gunoil
	name = "gun oil"
	desc = "It is a bottle of oil, for your gun. Don't fall for the rumors, the M41A is NOT a self cleaning firearm."
	icon_state = "gunoil"

/obj/item/prop/helmetgarb/netting
	name = "combat netting"
	desc = "Probably combat netting for a helmet. Probably just an extra hairnet that got ordered for the phantom Almayer cooking staff. Probably useless."
	icon_state = "netting"

/obj/item/prop/helmetgarb/spent_buckshot
	name = "spent buckshot"
	desc = "Three spent rounds of good ol' buckshot. You know they used to paint these green? Strange times."
	icon_state = "spent_buckshot"

/obj/item/prop/helmetgarb/spent_slug
	name = "spent slugs"
	desc = "For when you need to knock your target down with superior stopping power. These three have already been fired."
	icon_state = "spent_slug"

/obj/item/prop/helmetgarb/spent_flech
	name = "spent flechette"
	desc = "The more you fire these, the more you're reminded that a fragmentation grenade is probably more effective at fulfilling the same purpose. Say, aren't these supposed to eject from your gun?"
	icon_state = "spent_flech"

/obj/item/prop/helmetgarb/prescription_bottle
	name = "perscription medication"
	desc = "Anti-anxiety meds? Amphetamines? The cure for Sudden Sleep Disorder? The label can't be read, leaving the now absent contents forever a mystery. The cap is screwed on tighter than any ID lock."
	icon_state = "prescription_bottle"

/obj/item/prop/helmetgarb/raincover
	name = "raincover"
	desc = "The standard M10 combat helmet is already water-resistant at depths of up to 10 meters. This makes the top potentially water-proof. At least its something."
	icon_state = "raincover"

/obj/item/prop/helmetgarb/rabbitsfoot
	name = "Rabbit's Foot"
	desc = "Lucky for you, but not the rabbit, didn't really do it much good."
	icon_state = "rabbitsfoot"

/obj/item/prop/helmetgarb/rosary
	name = "rosary"
	desc = "The Emperor Protects! I mean, Jesus Saves!"
	icon_state = "rosary"

/obj/item/prop/helmetgarb/lucky_feather
	name = "\improper Red Lucky Feather"
	desc = "It is a riotous red color, made of really crummy plastic and synthetic threading, you know, the same sort of material every every Corporate Liaison's spine is made of."
	icon_state = "lucky_feather"

/obj/item/prop/helmetgarb/lucky_feather/blue
	name = "\improper Blue Lucky Feather"
	desc = "It is a brilliant blue color. You think you might have seen a bluejay in a holo-theatre once."
	icon_state = "lucky_feather_blue"

/obj/item/prop/helmetgarb/lucky_feather/purple
	name = "\improper Purple Lucky Feather"
	desc = "It is a plucky purple color. Legend has it a station AI known as Shakespeare simulated 1000 monkeys typing gibberish in order to replicate the actual works of shakespeare. Art critics are on the fence if this is the first instance of true artificial abstract art."
	icon_state = "lucky_feather_purple"

/obj/item/prop/helmetgarb/lucky_feather/yellow
	name = "\improper Yellow Feather"
	desc = "It is an unyielding yellow color. They say the New Kansas colony produces more carpenters per capita than any other colony in all of UA controlled space."
	icon_state = "lucky_feather_yellow"

/obj/item/prop/helmetgarb/helmet_nvg
	name = "\improper old M2 night vision goggles"
	desc = "They've been out of batteries since two shoreleaves ago. But hey, they make you feel tacticool, and that's all that matters, right?"
	icon_state = "helmet_nvg"
	var/activated = FALSE
	var/active_icon_state = "helmet_nvg_down"
	var/inactive_icon_state = "helmet_nvg"

	var/datum/action/item_action/activation
	var/obj/item/attached_item
	garbage = FALSE

/obj/item/prop/helmetgarb/helmet_nvg/on_enter_storage(obj/item/storage/internal/S)
	if(!istype(S))
		return ..()

	remove_attached_item()

	attached_item = S.master_item
	RegisterSignal(attached_item, COMSIG_PARENT_QDELETING, .proc/remove_attached_item)
	activation = new /datum/action/item_action/toggle(src, S.master_item)

	if(ismob(S.master_item.loc))
		activation.give_to(S.master_item.loc)

/obj/item/prop/helmetgarb/helmet_nvg/on_exit_storage(obj/item/storage/S)
	remove_attached_item()
	return ..()

/obj/item/prop/helmetgarb/helmet_nvg/proc/remove_attached_item()
	SIGNAL_HANDLER
	if(!attached_item)
		return

	UnregisterSignal(attached_item, COMSIG_PARENT_QDELETING)
	qdel(activation)
	attached_item = null

/obj/item/prop/helmetgarb/helmet_nvg/ui_action_click(var/mob/owner, var/obj/item/holder)
	toggle_nods(owner)
	activation.update_button_icon()


/obj/item/prop/helmetgarb/helmet_nvg/proc/toggle_nods(var/mob/user)
	if(user.is_mob_incapacitated())
		return

	if(!attached_item)
		return

	activated = !activated
	if(activated)
		to_chat(user, SPAN_NOTICE("You flip the goggles down."))
		icon_state = active_icon_state
	else
		to_chat(user, SPAN_NOTICE("You push the goggles back up onto your helmet."))
		icon_state = inactive_icon_state

	attached_item.update_icon()

/obj/item/prop/helmetgarb/helmet_nvg/functional //for ERTs and admemes. Not available to marines by default.
	name = "\improper M2 night vision goggles"
	desc = "With a pack of triple As, nothing can stop you. Put them on your helmet and press the button and it's go-time."

	var/invisibility_level = SEE_INVISIBLE_MINIMUM
	var/mob/attached_mob

/obj/item/prop/helmetgarb/helmet_nvg/functional/toggle_nods(mob/living/carbon/human/user)
	. = ..()
	if(activated)
		RegisterSignal(attached_item, COMSIG_ITEM_EQUIPPED, .proc/toggle_check)
		RegisterSignal(attached_item, COMSIG_ITEM_DROPPED, .proc/remove_nvg)
		if(user.head == attached_item)
			enable_nvg(user)
	else
		UnregisterSignal(attached_item, list(
			COMSIG_ITEM_EQUIPPED,
			COMSIG_ITEM_DROPPED
		))
		remove_nvg()

/obj/item/prop/helmetgarb/helmet_nvg/functional/remove_attached_item()
	if(attached_item)
		UnregisterSignal(attached_item, list(
			COMSIG_ITEM_EQUIPPED,
			COMSIG_ITEM_DROPPED
		))

	remove_nvg()
	attached_mob = null
	return ..()

/obj/item/prop/helmetgarb/helmet_nvg/functional/proc/enable_nvg(var/mob/living/carbon/human/user)
	remove_nvg()

	RegisterSignal(user, COMSIG_HUMAN_POST_UPDATE_SIGHT, .proc/update_sight)
	attached_mob = user

/obj/item/prop/helmetgarb/helmet_nvg/functional/proc/update_sight(var/mob/M)
	SIGNAL_HANDLER
	M.see_invisible = invisibility_level

/obj/item/prop/helmetgarb/helmet_nvg/functional/proc/toggle_check(var/obj/item/I, var/mob/living/carbon/human/user, slot)
	SIGNAL_HANDLER

	if(slot == WEAR_HEAD)
		enable_nvg(user)
	else
		remove_nvg()

/obj/item/prop/helmetgarb/helmet_nvg/functional/proc/remove_nvg()
	SIGNAL_HANDLER
	if(!attached_mob)
		return

	UnregisterSignal(attached_mob, COMSIG_HUMAN_POST_UPDATE_SIGHT)
	attached_mob = null

/obj/item/prop/helmetgarb/flair_initech
	name = "\improper Initech flair"
	desc = "Flair for some weird tech company back on Earth. How did they get promotional material this far out in the rim?"
	icon_state = "flair_initech"

/obj/item/prop/helmetgarb/flair_io
	name = "\improper Io flair"
	desc = "The Arcturians might be our allies now, but Io is forever a stain on trans-species relations. Never forget those who gave their lives aboard the USS Doramin."
	icon_state = "flair_io"

/obj/item/prop/helmetgarb/flair_peace
	name = "\improper Peace flair"
	desc = "Doesn't matter when it's Arcturian, baby."
	icon_state = "flair_peace_smiley"

/obj/item/prop/helmetgarb/flair_uscm
	name = "\improper USCM flair"
	desc = "These pins get handed out like candy at enlistment offices. Wear it with pride marine."
	icon_state = "flair_uscm"

/obj/item/prop/helmetgarb/spacejam_tickets
	name = "\improper Tickets to Space Jam"
	desc = "Two original, crisp, orange, tickets to the one and only Space Jam of 2188. And what a jam it was."
	icon_state = "tickets_to_space_jam"

/obj/item/prop/helmetgarb/riot_shield
	name = "\improper RC6 riot shield"
	desc = "The complimentary, but sold separate face shield associated with the RC6 riot helmet."
	icon_state = "helmet_riot_shield"


/obj/item/prop/helmetgarb/helmet_gasmask
	name = "\improper M5 integrated gasmask"
	desc = "The USCM had its funding pulled for these when it became apparent that not every deployed enlisted was wearing a helmet 24/7; much to the bafflement of UA High Command."
	icon_state = "helmet_gasmask"

/obj/item/prop/helmetgarb/trimmed_wire
	name = "\improper trimmed barbed wire"
	desc = "It is a length of barbed wire that's had most of the sharp points filed down so that it is safe to handle."
	icon_state = "trimmed_wire"

/obj/item/prop/helmetgarb/bullet_pipe
	name = "10x99mm XM42B casing pipe"
	desc = "The XM42B was an experimental weapons platform briefly fielded by the USCM and W-Y PMC teams. It was manufactured by ARMAT systems at the Atlas weapons facility. Unfortunately the project had its funding pulled alongside the M5 integrated gasmask program. This spent casing has been converted into a pipe, but there is too much tar in the mouthpiece for it to be useable."
	icon_state = "bullet_pipe"
