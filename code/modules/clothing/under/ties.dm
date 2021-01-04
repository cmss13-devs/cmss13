/obj/item/clothing/accessory
	name = "tie"
	desc = "A neosilk clip-on tie."
	icon = 'icons/obj/items/clothing/ties.dmi'
	icon_state = "bluetie"
	w_class = SIZE_SMALL
	var/image/inv_overlay = null	//overlay used when attached to clothing.
	var/obj/item/clothing/has_suit = null		//the suit the tie may be attached to
	var/slot = ACCESSORY_SLOT_DECOR
	var/list/mob_overlay = list()
	var/overlay_state = null
	var/list/accessory_icons = list(WEAR_BODY = 'icons/mob/humans/onmob/ties.dmi', WEAR_JACKET = 'icons/mob/humans/onmob/ties.dmi')
	var/list/on_rolled = list()	//used when uniform sleevels are rolled ("rolled" entry). Set to "none" to hide in this state.
	var/high_visibility	//if it should appear on examine without detailed view
	var/removable = TRUE
	flags_equip_slot = SLOT_ACCESSORY
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/ties_monkey.dmi')

/obj/item/clothing/accessory/Initialize()
	. = ..()
	inv_overlay = image("icon" = 'icons/obj/items/clothing/ties_overlay.dmi', "icon_state" = "[item_state? "[item_state]" : "[icon_state]"]")

/obj/item/clothing/accessory/Destroy()
	if(has_suit)
		has_suit.remove_accessory()
	QDEL_NULL(inv_overlay)
	. = ..()

/obj/item/clothing/accessory/proc/can_attach_to(var/mob/user, var/obj/item/clothing/C)
	return TRUE

//when user attached an accessory to S
/obj/item/clothing/accessory/proc/on_attached(obj/item/clothing/S, mob/living/user)
	if(!istype(S))
		return
	has_suit = S
	forceMove(has_suit)
	has_suit.overlays += get_inv_overlay()

	if(user)
		to_chat(user, SPAN_NOTICE("You attach \the [src] to \the [has_suit]."))
		src.add_fingerprint(user)

/obj/item/clothing/accessory/proc/on_removed(mob/living/user, obj/item/clothing/C)
	if(!has_suit)
		return
	has_suit.overlays -= get_inv_overlay()
	has_suit = null
	if(usr)
		usr.put_in_hands(src)
		src.add_fingerprint(usr)
	else
		src.forceMove(get_turf(src))

//default attackby behaviour
/obj/item/clothing/accessory/attackby(obj/item/I, mob/user)
	..()

//default attack_hand behaviour
/obj/item/clothing/accessory/attack_hand(mob/user as mob)
	if(has_suit)
		return	//we aren't an object on the ground so don't call parent
	..()

/obj/item/clothing/accessory/blue
	name = "blue tie"
	icon_state = "bluetie"

/obj/item/clothing/accessory/red
	name = "red tie"
	icon_state = "redtie"

/obj/item/clothing/accessory/horrible
	name = "horrible tie"
	desc = "A neosilk clip-on tie. This one is disgusting."
	icon_state = "horribletie"

/obj/item/clothing/accessory/stethoscope
	name = "stethoscope"
	desc = "An outdated medical apparatus for listening to the sounds of the human body. It also makes you look like you know what you're doing."
	icon_state = "stethoscope"

/obj/item/clothing/accessory/stethoscope/attack(mob/living/carbon/human/M, mob/living/user)
	if(ishuman(M) && isliving(user))
		if(user.a_intent == INTENT_HELP)
			var/body_part = parse_zone(user.zone_selected)
			if(body_part)
				var/their = "their"
				switch(M.gender)
					if(MALE)	their = "his"
					if(FEMALE)	their = "her"

				var/sound = "pulse"
				var/sound_strength

				if(M.stat == DEAD || (M.status_flags&FAKEDEATH))
					sound_strength = "cannot hear"
					sound = "anything"
				else
					sound_strength = "hear a weak"
					switch(body_part)
						if("chest")
							if(M.oxyloss < 50)
								sound_strength = "hear a healthy"
							sound = "pulse and respiration"
						if("eyes","mouth")
							sound_strength = "cannot hear"
							sound = "anything"
						else
							sound_strength = "hear a weak"

				user.visible_message("[user] places [src] against [M]'s [body_part] and listens attentively.", "You place [src] against [their] [body_part]. You [sound_strength] [sound].")
				return
	return ..(M,user)


//Medals
/obj/item/clothing/accessory/medal
	name = "medal"
	desc = "A medal."
	icon_state = "bronze"
	var/recipient_name //name of the person this is awarded to.
	var/recipient_rank
	var/medal_citation
	slot = ACCESSORY_SLOT_MEDAL
	high_visibility = TRUE

/obj/item/clothing/accessory/medal/on_attached(obj/item/clothing/S, mob/living/user)
	. = ..()
	RegisterSignal(S, COMSIG_ITEM_PICKUP, .proc/remove_medal)

/obj/item/clothing/accessory/medal/proc/remove_medal(var/obj/item/clothing/C, var/mob/user)
	SIGNAL_HANDLER
	if(user.real_name != recipient_name)
		C.remove_accessory(user, src)
		user.drop_held_item(src)

/obj/item/clothing/accessory/medal/on_removed(mob/living/user, obj/item/clothing/C)
	. = ..()
	UnregisterSignal(C, COMSIG_ITEM_PICKUP)

/obj/item/clothing/accessory/medal/attack(mob/living/carbon/human/H, mob/living/carbon/human/user)
	if(istype(H) && istype(user) && user.a_intent == INTENT_HELP)
		if(H.w_uniform)
			var/obj/item/clothing/under/U = H.w_uniform
			if(recipient_name != H.real_name)
				to_chat(user, SPAN_WARNING("[src] isn't awarded to [H]."))
				return
			if(user != H)
				user.visible_message("[user] starts pinning [src] on [H]'s [U.name].", \
				SPAN_NOTICE("You start pinning [src] on [H]'s [U.name]."))
				if(user.action_busy)
					return
				if(!do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, H))
					return
				user.drop_held_item()
				U.attach_accessory(user, src)
				H.update_inv_w_uniform()
				if(user == H)
					user.visible_message(SPAN_NOTICE("[user] pins [src] to \his [U.name]."),
					SPAN_NOTICE("You pin [src] to your [U.name]."))
				else
					user.visible_message("[user] pins [src] on [H]'s [U.name].", \
					SPAN_NOTICE("You pin [src] on [H]'s [U.name]."))
		else
			to_chat(user, SPAN_WARNING("[src] needs a uniform to be pinned to."))
	else
		return ..()

/obj/item/clothing/accessory/medal/can_attach_to(mob/user, obj/item/clothing/C)
	if(user.real_name != recipient_name)
		return FALSE

	return TRUE


/obj/item/clothing/accessory/medal/examine(mob/user)
	..()

	var/citation_to_read = ""
	if(medal_citation)
		citation_to_read = "The citation reads \'[medal_citation]\'."

	to_chat(user, "Awarded to: \'[recipient_rank] [recipient_name]\'. [citation_to_read]")

/obj/item/clothing/accessory/medal/bronze
	name = "bronze medal"
	desc = "A bronze medal."

/obj/item/clothing/accessory/medal/bronze/conduct
	name = "distinguished conduct medal"
	desc = "A bronze medal awarded for distinguished conduct. Whilst a great honor, this is the most basic award given by the USCM"

/obj/item/clothing/accessory/medal/bronze/heart
	name = "bronze heart medal"
	desc = "A bronze heart-shaped medal awarded for sacrifice. It is often awarded posthumously or for severe injury in the line of duty."
	icon_state = "bronze_heart"

/obj/item/clothing/accessory/medal/bronze/science
	name = "nobel sciences award"
	desc = "A bronze medal which represents significant contributions to the field of science or engineering."

/obj/item/clothing/accessory/medal/silver
	name = "silver medal"
	desc = "A silver medal."
	icon_state = "silver"

/obj/item/clothing/accessory/medal/silver/valor
	name = "medal of valor"
	desc = "A silver medal awarded for acts of exceptional valor."

/obj/item/clothing/accessory/medal/silver/security
	name = "robust security award"
	desc = "An award for distinguished combat and sacrifice in defence of W-Y's commercial interests. Often awarded to security staff."

/obj/item/clothing/accessory/medal/gold
	name = "gold medal"
	desc = "A prestigious golden medal."
	icon_state = "gold"

/obj/item/clothing/accessory/medal/gold/captain
	name = "medal of captaincy"
	desc = "A golden medal awarded exclusively to those promoted to the rank of captain. It signifies the codified responsibilities of a captain to W-Y, and their undisputable authority over their crew."

/obj/item/clothing/accessory/medal/gold/heroism
	name = "medal of exceptional heroism"
	desc = "An extremely rare golden medal awarded only by the USCM. To recieve such a medal is the highest honor and as such, very few exist."

/obj/item/clothing/accessory/medal/platinum
	name = "platinum medal"
	desc = "A very prestigious platinum medal, only able to be handed out by admirals due to special circumstances."
	icon_state = "platinum"

/obj/item/clothing/accessory/medal/bronze/service
	name = "bronze service medal"
	desc = "A bronze medal awarded for a marine's service within the USCM. It is a very common medal, and is typically the first medal a marine would receive."

/obj/item/clothing/accessory/medal/silver/service
	name = "silver service medal"
	desc = "A shiny silver medal awarded for a marine's service within the USCM. It is a somewhat common medal which signifies the amount of time a marine has spent in the line of duty."

/obj/item/clothing/accessory/medal/gold/service
	name = "gold service medal"
	desc = "A prestigious gold medal awarded for a marine's service within the USCM. It is a rare medal which signifies the amount of time a marine has spent in the line of duty."

/obj/item/clothing/accessory/medal/platinum/service
	name = "platinum service medal"
	desc = "The highest service medal that can be awarded to a marine; such medals are hand-given by USCM Admirals to a marine. It signifies the sheer amount of time a marine has spent in the line of duty."

//Armbands
/obj/item/clothing/accessory/armband
	name = "red armband"
	desc = "A fancy red armband!"
	icon_state = "red"
	slot = ACCESSORY_SLOT_ARMBAND

/obj/item/clothing/accessory/armband/cargo
	name = "cargo armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is brown."
	icon_state = "cargo"

/obj/item/clothing/accessory/armband/engine
	name = "engineering armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is orange with a reflective strip!"
	icon_state = "engie"

/obj/item/clothing/accessory/armband/science
	name = "science armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is purple."
	icon_state = "rnd"

/obj/item/clothing/accessory/armband/hydro
	name = "hydroponics armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is green and blue."
	icon_state = "hydro"

/obj/item/clothing/accessory/armband/med
	name = "medical armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is white."
	icon_state = "med"

/obj/item/clothing/accessory/armband/medgreen
	name = "EMT armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is white and green."
	icon_state = "medgreen"

//patches
/obj/item/clothing/accessory/patch
	name = "\improper USCM patch"
	desc = "A fire resistant shoulder patch, worn by the men and women of the United States Colonial Marines."
	icon_state = "uscmpatch"
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/patch/falcon
	name = "\improper Falling Falcons patch"
	desc = "A fire resistant shoulder patch, worn by the men and women of the Falling Falcons, the 2nd battalion of the 4th brigade of the USCM."
	icon_state = "fallingfalconspatch"

//ranks
/obj/item/clothing/accessory/ranks
	name = "rank pins"
	desc = "A set of rank pins, used to denote the paygrade of someone within the military."
	icon_state = "ranks_enlisted"
	var/rank = "Private"
	var/rank_short = "E1"
	slot = ACCESSORY_SLOT_RANK
	high_visibility = TRUE
	gender = PLURAL

/obj/item/clothing/accessory/ranks/New()
	..()
	name = "[initial(name)] ([rank_short])"
	desc = "[initial(desc)] This one is for the rank <b>[get_paygrades(rank_short, 1)]</b>"

/obj/item/clothing/accessory/ranks/e2
	rank_short = "E2"

/obj/item/clothing/accessory/ranks/e3
	rank_short = "E3"

/obj/item/clothing/accessory/ranks/e4
	rank_short = "E4"
	icon_state = "ranks_nco"

/obj/item/clothing/accessory/ranks/e5
	rank_short = "E5"
	icon_state = "ranks_nco"

/obj/item/clothing/accessory/ranks/e6
	rank_short = "E6"
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/e7
	rank_short = "E7"
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/e8
	rank_short = "E8"
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/e9
	rank_short = "E9"
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/e9e
	rank_short = "E9E"
	icon_state = "ranks_snco"

/obj/item/clothing/accessory/ranks/o1
	name = "rank boards"
	rank_short = "O1"
	icon_state = "ranks_officer"

/obj/item/clothing/accessory/ranks/o2
	name = "rank boards"
	rank_short = "O2"
	icon_state = "ranks_officer"

/obj/item/clothing/accessory/ranks/o3
	name = "rank boards"
	rank_short = "O3"
	icon_state = "ranks_officer"

/obj/item/clothing/accessory/ranks/o4
	name = "rank boards"
	rank_short = "O4"
	icon_state = "ranks_seniorofficer"

/obj/item/clothing/accessory/ranks/o5
	name = "rank boards"
	rank_short = "O5"
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/o5e
	name = "rank boards"
	rank_short = "O5E"
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/o6
	name = "rank boards"
	rank_short = "O6"
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/o7
	name = "rank boards"
	rank_short = "O7"
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/o8
	name = "rank boards"
	rank_short = "O8"
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/o9
	name = "rank boards"
	rank_short = "O9"
	icon_state = "ranks_flagofficer"

/obj/item/clothing/accessory/ranks/o9e
	name = "rank boards"
	rank_short = "O9E"
	icon_state = "ranks_flagofficer"

//holsters
/obj/item/clothing/accessory/holster
	name = "shoulder holster"
	desc = "A handgun holster."
	icon_state = "holster"
	var/obj/item/weapon/gun/holstered = null
	slot = ACCESSORY_SLOT_UTILITY
	high_visibility = TRUE

/obj/item/clothing/accessory/holster/Destroy()
	QDEL_NULL(holstered)
	. = ..()

//subtypes can override this to specify what can be holstered
/obj/item/clothing/accessory/holster/proc/can_holster(obj/item/weapon/gun/W)
	if(!istype(W))
		return 0 //Only for guns
	if(W.w_class <= SIZE_MEDIUM) return 1
	return 0

/obj/item/clothing/accessory/holster/proc/holster(obj/item/I, mob/user as mob)
	if(holstered)
		to_chat(user, SPAN_DANGER("There is already a [holstered] holstered here!"))
		return

	if (!istype(I, /obj/item/weapon/gun))
		to_chat(user, SPAN_DANGER("Only guns can be holstered!"))
		return

	var/obj/item/weapon/gun/W = I
	if (!can_holster(W))
		to_chat(user, SPAN_DANGER("This [W] won't fit in the [src]!"))
		return

	holstered = W
	user.drop_inv_item_to_loc(holstered, src)
	holstered.add_fingerprint(user)
	user.visible_message(SPAN_NOTICE("[user] holsters the [holstered]."), "You holster the [holstered].")

/obj/item/clothing/accessory/holster/proc/unholster(mob/user as mob)
	if(!holstered)
		return

	if(user.get_active_hand() && user.get_inactive_hand())
		to_chat(user, SPAN_WARNING("You need an empty hand to draw the [holstered]!"))
	else
		if(user.a_intent == INTENT_HARM)
			usr.visible_message(SPAN_DANGER("[user] draws the [holstered], ready to shoot!"), \
			SPAN_DANGER("You draw [holstered], ready to shoot!"))
		else
			user.visible_message(SPAN_NOTICE("[user] draws the [holstered], pointing it at the ground."), \
			SPAN_NOTICE("You draw the [holstered], pointing it at the ground."))
		user.put_in_hands(holstered)
		holstered.add_fingerprint(user)
		holstered = null

/obj/item/clothing/accessory/holster/attack_hand(mob/user as mob)
	if (has_suit)	//if we are part of a suit
		if (holstered)
			unholster(user)
		return

	..(user)

/obj/item/clothing/accessory/holster/attackby(obj/item/W as obj, mob/user as mob)
	holster(W, user)

/obj/item/clothing/accessory/holster/emp_act(severity)
	if (holstered)
		holstered.emp_act(severity)
	..()

/obj/item/clothing/accessory/holster/examine(mob/user)
	..()
	if (holstered)
		to_chat(user, "A [holstered] is holstered here.")
	else
		to_chat(user, "It is empty.")

/obj/item/clothing/accessory/holster/armpit
	name = "shoulder holster"
	desc = "A worn-out handgun holster. Perfect for concealed carry"
	icon_state = "holster"

/obj/item/clothing/accessory/holster/waist
	name = "shoulder holster"
	desc = "A handgun holster. Made of expensive leather."
	icon_state = "holster"
	item_state = "holster_low"





//Ties that can store stuff

/obj/item/clothing/accessory/storage
	name = "load bearing equipment"
	desc = "Used to hold things when you don't have enough hands."
	icon_state = "webbing"
	w_class = SIZE_LARGE //too big to store in other pouches
	var/slots = 3
	var/obj/item/storage/internal/hold
	slot = ACCESSORY_SLOT_UTILITY
	high_visibility = TRUE

/obj/item/clothing/accessory/storage/New()
	..()
	hold = new/obj/item/storage/internal(src)
	hold.storage_slots = slots

/obj/item/clothing/accessory/storage/Destroy()
	QDEL_NULL(hold)
	return ..()

/obj/item/clothing/accessory/storage/attack_hand(mob/user as mob)
	if (!isnull(hold) && hold.handle_attack_hand(user))
		..(user)

/obj/item/clothing/accessory/storage/MouseDrop(obj/over_object as obj)
	if (has_suit || hold)
		return

	if (hold.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/clothing/accessory/storage/attackby(obj/item/W as obj, mob/user as mob)
	return hold.attackby(W, user)

/obj/item/clothing/accessory/storage/emp_act(severity)
	hold.emp_act(severity)
	..()

/obj/item/clothing/accessory/storage/hear_talk(mob/M, var/msg)
	hold.hear_talk(M, msg)
	..()

/obj/item/clothing/accessory/storage/attack_self(mob/user as mob)
	to_chat(user, SPAN_NOTICE("You empty [src]."))
	var/turf/T = get_turf(src)
	hold.hide_from(usr)
	for(var/obj/item/I in hold.contents)
		hold.remove_from_storage(I, T)
	src.add_fingerprint(user)

/obj/item/clothing/accessory/storage/on_attached(obj/item/clothing/C, mob/living/user)
	..()
	verbs += /obj/item/clothing/suit/storage/verb/toggle_draw_mode

/obj/item/clothing/accessory/storage/on_removed(mob/living/user, obj/item/clothing/C)
	..()
	verbs -= /obj/item/clothing/suit/storage/verb/toggle_draw_mode

/obj/item/clothing/accessory/storage/webbing
	name = "webbing"
	desc = "A sturdy mess of synthcotton belts and buckles, ready to share your burden."
	icon_state = "webbing"
	slots = 3

/obj/item/clothing/accessory/storage/webbing/New()
	..()
	hold.bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/sniper,
	)

/obj/item/clothing/accessory/storage/black_vest
	name = "black webbing vest"
	desc = "Robust black synthcotton vest with lots of pockets to hold whatever you need, but cannot hold in hands."
	icon_state = "vest_black"
	slots = 5

/obj/item/clothing/accessory/storage/black_vest/attackby(obj/item/B, mob/living/user)
	if(iswirecutter(B) && skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		var/components = 0
		var/obj/item/reagent_container/glass/beaker/vial
		var/obj/item/cell/battery
		for(var/obj/item in hold.contents)
			if(istype(item, /obj/item/device/radio) || istype(item, /obj/item/stack/cable_coil) || istype(item, /obj/item/device/healthanalyzer))
				components++
			else if(istype(item, /obj/item/reagent_container/hypospray) && !istype(item, /obj/item/reagent_container/hypospray/autoinjector))
				var/obj/item/reagent_container/hypospray/H = item
				if(H.mag)
					vial = H.mag
				components++
			else if(istype(item, /obj/item/cell))
				battery = item
				components++
			else
				components--
		if(components == 5)
			var/obj/item/clothing/accessory/storage/black_vest/acid_harness/AH
			if(istype(src, /obj/item/clothing/accessory/storage/black_vest/brown_vest))
				AH = new /obj/item/clothing/accessory/storage/black_vest/acid_harness/brown(get_turf(loc))
			else
				AH = new /obj/item/clothing/accessory/storage/black_vest/acid_harness(get_turf(loc))
			if(vial)
				AH.vial = vial
				AH.hold.handle_item_insertion(vial)
			AH.battery = battery
			AH.hold.handle_item_insertion(battery)
			qdel(src)
			return
	. = ..()

/obj/item/clothing/accessory/storage/black_vest/brown_vest
	name = "brown webbing vest"
	desc = "Worn brownish synthcotton vest with lots of pockets to unload your hands."
	icon_state = "vest_brown"
	slots = 5


/obj/item/clothing/accessory/storage/knifeharness
	name = "decorated harness"
	desc = "A heavily decorated harness of sinew and leather with two knife-loops."
	icon_state = "unathiharness2"
	slots = 2

/obj/item/clothing/accessory/storage/knifeharness/New()
	..()
	hold.max_storage_space = 4
	hold.can_hold = list(
		/obj/item/weapon/melee/unathiknife,
		/obj/item/tool/kitchen/utensil/knife,
		/obj/item/tool/kitchen/utensil/pknife,
		/obj/item/tool/kitchen/knife,
	)

	new /obj/item/weapon/melee/unathiknife(hold)
	new /obj/item/weapon/melee/unathiknife(hold)









/*
	Holobadges are worn on the belt or neck, and can be used to show that the holder is an authorized
	Security agent - the user details can be imprinted on the badge with a Security-access ID card,
	or they can be emagged to accept any ID for use in disguises.
*/

/obj/item/clothing/accessory/holobadge

	name = "holobadge"
	desc = "This glowing blue badge marks the holder as THE LAW."
	icon_state = "holobadge"
	flags_equip_slot = SLOT_WAIST

	var/stored_name = null

/obj/item/clothing/accessory/holobadge/cord
	icon_state = "holobadge-cord"
	flags_equip_slot = SLOT_FACE

/obj/item/clothing/accessory/holobadge/attack_self(mob/user as mob)
	if(!stored_name)
		to_chat(user, "Waving around a badge before swiping an ID would be pretty pointless.")
		return
	if(isliving(user))
		user.visible_message(SPAN_DANGER("[user] displays their W-Y Internal Security Legal Authorization Badge.\nIt reads: [stored_name], W-Y Security."),SPAN_DANGER("You display your W-Y Internal Security Legal Authorization Badge.\nIt reads: [stored_name], W-Y Security."))

/obj/item/clothing/accessory/holobadge/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/card/id))

		var/obj/item/card/id/id_card = null

		if(istype(O, /obj/item/card/id))
			id_card = O

		if(ACCESS_MARINE_BRIG in id_card.access)
			to_chat(user, "You imprint your ID details onto the badge.")
			stored_name = id_card.registered_name
			name = "holobadge ([stored_name])"
			desc = "This glowing blue badge marks [stored_name] as THE LAW."
		else
			to_chat(user, "[src] rejects your insufficient access rights.")
		return
	..()

/obj/item/clothing/accessory/holobadge/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message(SPAN_DANGER("[user] invades [M]'s personal space, thrusting [src] into their face insistently."),SPAN_DANGER("You invade [M]'s personal space, thrusting [src] into their face insistently. You are the law."))

/obj/item/storage/box/holobadge
	name = "holobadge box"
	desc = "A box claiming to contain holobadges."
	New()
		new /obj/item/clothing/accessory/holobadge(src)
		new /obj/item/clothing/accessory/holobadge(src)
		new /obj/item/clothing/accessory/holobadge(src)
		new /obj/item/clothing/accessory/holobadge(src)
		new /obj/item/clothing/accessory/holobadge/cord(src)
		new /obj/item/clothing/accessory/holobadge/cord(src)
		..()
		return
