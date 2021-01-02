/*
 * Backpack
 */

/obj/item/storage/backpack
	name = "backpack"
	desc = "You wear this on your back and put items into it."
	icon = 'icons/obj/items/clothing/backpacks.dmi'
	icon_state = "backpack"
	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK	//ERROOOOO
	max_w_class = SIZE_MEDIUM
	storage_slots = null
	max_storage_space = 21
	var/worn_accessible = FALSE //whether you can access its content while worn on the back
	var/obj/item/card/id/locking_id = null
	var/is_id_lockable = FALSE
	var/lock_overridable = TRUE

/obj/item/storage/backpack/attack_hand(mob/user)
	if(!is_accessible_by(user))
		return
	..()

/obj/item/storage/backpack/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id/) && is_id_lockable && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/card/id/card = W
		toggle_lock(card, H)
		return

	if (use_sound)
		playsound(src.loc, src.use_sound, 15, 1, 6)
	..()

/obj/item/storage/backpack/proc/toggle_lock(obj/item/card/id/card, mob/living/carbon/human/H)
	if(QDELETED(locking_id))
		to_chat(H, SPAN_NOTICE("You lock the [src]!"))
		locking_id = card
	else
		if(locking_id.registered_name == card.registered_name || (lock_overridable && (ACCESS_MARINE_COMMANDER in card.access)))
			to_chat(H, SPAN_NOTICE("You unlock the [src]!"))
			locking_id = null
		else
			to_chat(H, SPAN_NOTICE("The ID lock rejects your ID"))
	update_icon()

/obj/item/storage/backpack/mob_can_equip(M as mob, slot)
	if (!..())
		return 0

	if (!uniform_restricted)
		return 1

	if (!ishuman(M))
		return 0

	var/mob/living/carbon/human/H = M
	var/list/equipment = list(H.wear_suit, H.w_uniform, H.shoes, H.belt, H.gloves, H.glasses, H.head, H.wear_ear, H.wear_id, H.r_store, H.l_store, H.s_store)

	for (var/type in uniform_restricted)
		if (!(locate(type) in equipment))
			to_chat(H, SPAN_WARNING("You must be wearing [initial(type:name)] to equip [name]!"))
			return 0
	return 1

/obj/item/storage/backpack/equipped(mob/user, slot)
	if(slot == WEAR_BACK)
		mouse_opacity = 2 //so it's easier to click when properly equipped.
		if(use_sound)
			playsound(loc, use_sound, 15, 1, 6)
		if(!worn_accessible && user.s_active == src) //currently looking into the backpack
			close(user)
	..()

/obj/item/storage/backpack/dropped(mob/user)
	mouse_opacity = initial(mouse_opacity)
	..()


/obj/item/storage/backpack/open(mob/user)
	if(!is_accessible_by(user))
		return
	..()

/obj/item/storage/backpack/proc/is_accessible_by(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!worn_accessible)
			if(H.back == src)
				to_chat(H, SPAN_NOTICE("You can't look in [src] while it's on your back."))
				return FALSE

		if(!QDELETED(locking_id))
			var/obj/item/card/id/card = H.wear_id
			if(!card || locking_id.registered_name != card.registered_name)
				to_chat(H, SPAN_NOTICE("[src] is locked by [locking_id.registered_name]'s ID! You decide to leave it alone."))
				return FALSE
	return TRUE

obj/item/storage/backpack/empty(mob/user, turf/T)
	if(!is_accessible_by(user))
		return
	..()

/obj/item/storage/backpack/update_icon()
	overlays.Cut()
	var/sum_storage_cost = 0
	if(locking_id) // if it's locked, we expect the casing to be shut.
		overlays += "+[icon_state]_full"
		overlays += "+[icon_state]_locked"
		return
	else if(is_id_lockable)
		overlays += "+[icon_state]_unlocked"

	for(var/obj/item/I in contents)
		sum_storage_cost += I.get_storage_cost()
	if(!sum_storage_cost)
		return

	else if(sum_storage_cost <= max_storage_space * 0.5)
		overlays += "+[icon_state]_half"
	else
		overlays += "+[icon_state]_full"

/obj/item/storage/backpack/examine(mob/user)
	..()
	if(is_id_lockable)
		to_chat(user, "Features an ID lock. Swipe your ID card to lock or unlock it.")
		if(lock_overridable)
			to_chat(user, "This lock can be overridden with command-level access.")

/*
 * Backpack Types
 */

/obj/item/storage/backpack/holding
	name = "bag of holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	icon_state = "holdingpack"
	max_w_class = SIZE_LARGE
	max_storage_space = 28

	attackby(obj/item/W as obj, mob/user as mob)
		if(crit_fail)
			to_chat(user, SPAN_DANGER("The Bluespace generator isn't working."))
			return
		if(istype(W, /obj/item/storage/backpack/holding) && !W.crit_fail)
			to_chat(user, SPAN_DANGER("The Bluespace interfaces of the two devices conflict and malfunction."))
			qdel(W)
			return
		..()

	proc/failcheck(mob/user as mob)
		if (prob(src.reliability)) return 1 //No failure
		if (prob(src.reliability))
			to_chat(user, SPAN_DANGER("The Bluespace portal resists your attempt to add another item.")) //light failure
		else
			to_chat(user, SPAN_DANGER("The Bluespace generator malfunctions!"))
			for (var/obj/O in src.contents) //it broke, delete what was in it
				qdel(O)
			crit_fail = 1
			icon_state = "brokenpack"


//==========================//JOKE PACKS\\================================\\

/obj/item/storage/backpack/santabag
	name = "Santa's Gift Bag"
	desc = "Space Santa uses this to deliver toys to all the nice children in space in Christmas! Wow, it's pretty big!"
	icon_state = "giftbag0"
	item_state = "giftbag"
	w_class = SIZE_LARGE
	storage_slots = null
	max_w_class = SIZE_MEDIUM
	max_storage_space = 400 // can store a ton of shit!


/obj/item/storage/backpack/cultpack
	name = "trophy rack"
	desc = "It's useful for both carrying extra gear and proudly declaring your insanity."
	icon_state = "cultpack"

/obj/item/storage/backpack/clown
	name = "Giggles von Honkerton"
	desc = "This, this thing. It fills you with the dread of a bygone age. A land of grey coveralls and mentally unstable crewmen. Of traitors and hooligans. Thank god you're in the marines now."
	icon_state = "clownpack"

//==========================//COLONY/CIVILIAN PACKS\\================================\\

/obj/item/storage/backpack/medic
	name = "medical backpack"
	desc = "It's a backpack especially designed for use in a sterile environment."
	icon_state = "medicalpack"

/obj/item/storage/backpack/security //Universal between USCM MPs & Colony, should be split at some point.
	name = "security backpack"
	desc = "It's a very robust backpack."
	icon_state = "securitypack"

/obj/item/storage/backpack/industrial
	name = "industrial backpack"
	desc = "It's a tough backpack lookin' backpack used by engineers and the like."
	icon_state = "engiepack"
	item_state = "engiepack"

/obj/item/storage/backpack/toxins
	name = "laboratory backpack"
	desc = "It's a light backpack modeled for use in laboratories and other scientific institutions."
	icon_state = "toxpack"

/obj/item/storage/backpack/hydroponics
	name = "herbalist's backpack"
	desc = "It's a green backpack with many pockets to store plants and tools in."
	icon_state = "hydpack"

/obj/item/storage/backpack/genetics
	name = "geneticist backpack"
	desc = "It's a backpack fitted with slots for diskettes and other workplace tools."
	icon_state = "genpack"

/obj/item/storage/backpack/virology
	name = "sterile backpack"
	desc = "It's a sterile backpack able to withstand different pathogens from entering its fabric."
	icon_state = "viropack"

/obj/item/storage/backpack/chemistry
	name = "chemistry backpack"
	desc = "It's an orange backpack which was designed to hold beakers, pill bottles and bottles."
	icon_state = "chempack"

/*
 * Satchel Types
 */

/obj/item/storage/backpack/satchel
	name = "leather satchel"
	desc = "A very fancy satchel made of fine leather. Looks pretty pricey."
	icon_state = "satchel"
	worn_accessible = TRUE
	storage_slots = null
	max_storage_space = 15

/obj/item/storage/backpack/satchel/withwallet

/obj/item/storage/backpack/satchel/withwallet/fill_preset_inventory()
	new /obj/item/storage/wallet/random( src )

/obj/item/storage/backpack/satchel/lockable
	is_id_lockable = TRUE

/obj/item/storage/backpack/satchel/lockable/liaison
	lock_overridable = FALSE

/obj/item/storage/backpack/satchel/norm
	name = "satchel"
	desc = "A trendy looking satchel."
	icon_state = "satchel-norm"

/obj/item/storage/backpack/satchel/eng
	name = "industrial satchel"
	desc = "A tough satchel with extra pockets."
	icon_state = "satchel-eng"

/obj/item/storage/backpack/satchel/med
	name = "medical satchel"
	desc = "A sterile satchel used in medical departments."
	icon_state = "satchel-med"

/obj/item/storage/backpack/satchel/vir
	name = "virologist satchel"
	desc = "A sterile satchel with virologist colours."
	icon_state = "satchel-vir"

/obj/item/storage/backpack/satchel/chem
	name = "chemist satchel"
	desc = "A sterile satchel with chemist colours."
	icon_state = "satchel-chem"

/obj/item/storage/backpack/satchel/gen
	name = "geneticist satchel"
	desc = "A sterile satchel with geneticist colours."
	icon_state = "satchel-gen"

/obj/item/storage/backpack/satchel/tox
	name = "scientist satchel"
	desc = "Useful for holding research materials."
	icon_state = "satchel-tox"

/obj/item/storage/backpack/satchel/sec //Universal between USCM MPs & Colony, should be split at some point.
	name = "security satchel"
	desc = "A robust satchel composed of two drop pouches, and a large internal pocket. Made of a stiff fabric. It isn't very comfy to wear."
	icon_state = "satchel-sec"

/obj/item/storage/backpack/satchel/hyd
	name = "hydroponics satchel"
	desc = "A green satchel for plant related work."
	icon_state = "satchel_hyd"

//==========================// MARINE BACKPACKS\\================================\\
//=======================================================================\\

/obj/item/storage/backpack/marine
	name = "\improper lightweight IMP backpack"
	desc = "The standard-issue pack of the USCM forces. Designed to lug gear into the battlefield."
	icon_state = "marinepack"
	item_state = "marinepack"
	var/has_gamemode_skin = TRUE //replace this with the atom_flag NO_SNOW_TYPE at some point, just rename it to like, NO_MAP_VARIANT_SKIN

/obj/item/storage/backpack/marine/Initialize()
	. = ..()
	if(has_gamemode_skin)
		select_gamemode_skin(type)

/obj/item/storage/backpack/marine/medic
	name = "\improper USCM medic backpack"
	desc = "A standard-issue backpack worn by USCM medics."
	icon_state = "marinepack_medic"
	item_state = "marinepack_medic"

/obj/item/storage/backpack/marine/tech
	name = "\improper USCM technician backpack"
	desc = "A standard-issue backpack worn by USCM technicians."
	icon_state = "marinepack_techi"
	item_state = "marinepack_techi"

/obj/item/storage/backpack/marine/satchel
	name = "\improper USCM satchel"
	desc = "A heavy-duty satchel carried by some USCM soldiers and support personnel."
	icon_state = "marinesatch"
	worn_accessible = TRUE
	storage_slots = null
	max_storage_space = 15


/obj/item/storage/backpack/marine/satchel/medic
	name = "\improper USCM medic satchel"
	desc = "A heavy-duty satchel used by USCM medics. It sacrifices capacity for usability. A small patch is sown to the top flap."
	icon_state = "marinesatch_medic"

/obj/item/storage/backpack/marine/satchel/tech
	name = "\improper USCM technician chestrig"
	desc = "A heavy-duty chestrig used by some USCM technicians."
	icon_state = "marinesatch_techi"

/obj/item/storage/backpack/marine/satchel/intel
	name = "\improper USCM lightweight expedition pack"
	desc = "A heavy-duty IMP based backpack that can be slung around the front or to the side, and can quickly be accessed with only one hand. Usually issued to USCM intelligence officers."
	icon_state = "marinesatch_io"
	max_storage_space = 20

/obj/item/storage/backpack/marine/smock
	name = "\improper M3 sniper's smock"
	desc = "A specially designed smock with pockets for all your sniper needs."
	icon_state = "smock"
	worn_accessible = TRUE

/obj/item/storage/backpack/marine/rocketpack
	name = "\improper USCM IMP M22 rocket bags"
	desc = "A specially designed backpack that fits to the IMP mounting frame on standard USCM pattern M3 armors. It's made of two water proofed reinforced tubes and one smaller satchel slung at the bottom. The two silos are for rockets, but no one is stopping you from cramming other things in there."
	icon_state = "rocketpack"
	worn_accessible = TRUE
	has_gamemode_skin = FALSE //monkeysfist101 never sprited a snowtype but included duplicate icons. Why?? Recolor and touch up sprite at a later date.

/obj/item/storage/backpack/marine/grenadepack
	name = "\improper USCM IMP M63A1 Grenade Satchel"
	desc = "A satchel with dedicated grenades pouches meant to minimize risks of secondary ignition."
	icon_state = "grenadierpack"
	overlays = list("+grenadierpack_unlocked")
	worn_accessible = TRUE
	max_storage_space = 36 //12 grenades
	storage_slots = 12
	can_hold = list(/obj/item/explosive/grenade)
	is_id_lockable = TRUE
	has_gamemode_skin = FALSE

/obj/item/storage/backpack/marine/grenadepack/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/storage/box/nade_box) || istype(W, /obj/item/storage/backpack/marine/grenadepack) || istype(W, /obj/item/storage/belt/grenade))
		dump_into(W,user)
	else
		return ..()

/obj/item/storage/backpack/marine/mortarpack
	name = "\improper USCM mortar shell backpack"
	desc = "A backpack specifically designed to hold ammunition for the M402 mortar."
	icon_state = "mortarpack"
	max_w_class = SIZE_HUGE
	storage_slots = 8
	can_hold = list(/obj/item/mortar_shell)

// Scout Cloak
/obj/item/storage/backpack/marine/satchel/scout_cloak
	name = "\improper M68 Thermal Cloak"
	desc = "The lightweight thermal dampeners and optical camouflage provided by this cloak are weaker than those found in standard USCM ghillie suits. In exchange, the cloak can be worn over combat armor and offers the wearer high manueverability and adaptability to many environments."
	icon_state = "scout_cloak"
	uniform_restricted = list(/obj/item/clothing/suit/storage/marine/M3S, /obj/item/clothing/head/helmet/marine/scout) //Need to wear Scout armor and helmet to equip this.
	has_gamemode_skin = FALSE //same sprite for all gamemode.
	var/camo_active = FALSE
	var/camo_alpha = 10
	var/allow_gun_usage = FALSE

	actions_types = list(/datum/action/item_action/specialist/toggle_cloak)

/obj/item/storage/backpack/marine/satchel/scout_cloak/dropped(mob/user)
	if(ishuman(user) && !isSynth(user))
		deactivate_camouflage(user, FALSE)

	. = ..()

/obj/item/storage/backpack/marine/satchel/scout_cloak/attack_self(mob/user)
	camouflage()

/obj/item/storage/backpack/marine/satchel/scout_cloak/verb/camouflage()
	set name = "Activate Cloak"
	set desc = "Activate your cloak's camouflage."
	set category = "Scout"
	set src in usr
	if(!usr || usr.is_mob_incapacitated(TRUE))
		return

	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	if(!skillcheck(H, SKILL_SPEC_WEAPONS, SKILL_SPEC_TRAINED) && H.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_SCOUT)
		to_chat(H, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return

	if(H.back != src)
		to_chat(H, SPAN_WARNING("You must be wearing the cloak to activate it!"))
		return

	if(camo_active)
		deactivate_camouflage(H)
		return

	RegisterSignal(H, COMSIG_GRENADE_PRE_PRIME, .proc/cloak_grenade_callback)

	camo_active = TRUE
	H.visible_message(SPAN_DANGER("[H] vanishes into thin air!"), SPAN_NOTICE("You activate your cloak's camouflage."), max_distance = 4)
	playsound(H.loc,'sound/effects/cloak_scout_on.ogg', 15, 1)
	H.unset_interaction()

	H.alpha = camo_alpha
	H.FF_hit_evade = 1000
	H.allow_gun_usage = allow_gun_usage

	var/datum/mob_hud/security/advanced/SA = huds[MOB_HUD_SECURITY_ADVANCED]
	SA.remove_from_hud(H)
	var/datum/mob_hud/xeno_infection/XI = huds[MOB_HUD_XENO_INFECTION]
	XI.remove_from_hud(H)

	anim(H.loc, H, 'icons/mob/mob.dmi', null, "cloak", null, H.dir)


/obj/item/storage/backpack/marine/satchel/scout_cloak/proc/deactivate_camouflage(var/mob/living/carbon/human/H, var/anim = TRUE)
	if(!istype(H))
		return FALSE

	UnregisterSignal(H, COMSIG_GRENADE_PRE_PRIME)

	camo_active = FALSE
	H.visible_message(SPAN_DANGER("[H] shimmers into existence!"), SPAN_WARNING("Your cloak's camouflage has deactivated!"), max_distance = 4)
	playsound(H.loc,'sound/effects/cloak_scout_off.ogg', 15, 1)

	H.alpha = initial(H.alpha)
	H.FF_hit_evade = initial(H.FF_hit_evade)

	var/datum/mob_hud/security/advanced/SA = huds[MOB_HUD_SECURITY_ADVANCED]
	SA.add_to_hud(H)
	var/datum/mob_hud/xeno_infection/XI = huds[MOB_HUD_XENO_INFECTION]
	XI.add_to_hud(H)

	if(anim)
		anim(H.loc, H,'icons/mob/mob.dmi', null, "uncloak", null, H.dir)

	addtimer(CALLBACK(src, .proc/allow_shooting, H), 5)

// This proc is to cancel priming grenades in /obj/item/explosive/grenade/attack_self()
/obj/item/storage/backpack/marine/satchel/scout_cloak/proc/cloak_grenade_callback(mob/user)
	SIGNAL_HANDLER

	to_chat(user, SPAN_WARNING("Your cloak prevents you from priming the grenade!"))

	return COMPONENT_GRENADE_PRIME_CANCEL

/obj/item/storage/backpack/marine/satchel/scout_cloak/proc/allow_shooting(var/mob/living/carbon/human/H)
	if(camo_active && !allow_gun_usage)
		return
	H.allow_gun_usage = TRUE

/datum/action/item_action/specialist/toggle_cloak
	ability_primacy = SPEC_PRIMARY_ACTION_1

/datum/action/item_action/specialist/toggle_cloak/New(var/mob/living/user, var/obj/item/holder)
	..()
	name = "Toggle Cloak"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/obj/items/clothing/backpacks.dmi', button, "scout_cloak")
	button.overlays += IMG

/datum/action/item_action/specialist/toggle_cloak/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && !H.is_mob_incapacitated() && !H.lying && holder_item == H.back)
		return TRUE

/datum/action/item_action/specialist/toggle_cloak/action_activate()
	var/obj/item/storage/backpack/marine/satchel/scout_cloak/SC = holder_item
	SC.camouflage()

// Welder Backpacks //

/obj/item/storage/backpack/marine/engineerpack
	name = "\improper USCM technician welderpack"
	desc = "A specialized backpack worn by USCM technicians. It carries a fueltank for quick welder refueling and use."
	icon_state = "welderbackpack"
	item_state = "welderbackpack"
	var/max_fuel = 260
	var/fuel_type = "fuel"
	max_storage_space = 15
	storage_slots = null
	has_gamemode_skin = TRUE


/obj/item/storage/backpack/marine/engineerpack/Initialize()
	. = ..()
	create_reagents(max_fuel) //Lotsa refills
	reagents.add_reagent(fuel_type, max_fuel)


/obj/item/storage/backpack/marine/engineerpack/attackby(obj/item/W, mob/living/user)
	if(reagents.total_volume)
		if(istype(W, /obj/item/tool/weldingtool))
			var/obj/item/tool/weldingtool/T = W
			if(T.welding)
				to_chat(user, SPAN_WARNING("That was close! However you realized you had the welder on and prevented disaster."))
				return
			if(!(T.get_fuel()==T.max_fuel) && reagents.total_volume)
				reagents.trans_to(W, T.max_fuel)
				to_chat(user, SPAN_NOTICE("Welder refilled!"))
				playsound(loc, 'sound/effects/refill.ogg', 25, 1, 3)
				return
		else if(istype(W, /obj/item/ammo_magazine/flamer_tank))
			var/obj/item/ammo_magazine/flamer_tank/FT = W
			if(!FT.current_rounds && reagents.total_volume)
				var/fuel_available = reagents.total_volume < FT.max_rounds ? reagents.total_volume : FT.max_rounds
				reagents.remove_reagent("fuel", fuel_available)
				FT.current_rounds = fuel_available
				playsound(loc, 'sound/effects/refill.ogg', 25, 1, 3)
				FT.caliber = "Fuel"
				to_chat(user, SPAN_NOTICE("You refill [FT] with [lowertext(FT.caliber)]."))
				FT.update_icon()
				return
		else if(istype(W, /obj/item/weapon/gun))
			var/obj/item/weapon/gun/G = W
			for(var/slot in G.attachments)
				if(istype(G.attachments[slot], /obj/item/attachable/attached_gun/flamer))
					var/obj/item/attachable/attached_gun/flamer/F = G.attachments[slot]
					if(F.current_rounds < F.max_rounds)
						var/to_transfer = F.max_rounds - F.current_rounds
						if(to_transfer > reagents.total_volume)
							to_transfer = reagents.total_volume
						reagents.remove_reagent("fuel", to_transfer)
						F.current_rounds += to_transfer
						playsound(loc, 'sound/effects/refill.ogg', 25, 1, 3)
						to_chat(user, SPAN_NOTICE("You refill [F] with Fuel."))
					else
						to_chat(user, SPAN_WARNING("[F] is full."))
					return
	. = ..()

/obj/item/storage/backpack/marine/engineerpack/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!proximity) // this replaces and improves the get_dist(src,O) <= 1 checks used previously
		return
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && src.reagents.total_volume < max_fuel)
		O.reagents.trans_to(src, max_fuel)
		to_chat(user, SPAN_NOTICE(" You crack the cap off the top of the pack and fill it back up again from the tank."))
		playsound(src.loc, 'sound/effects/refill.ogg', 25, 1, 3)
		return
	else if (istype(O, /obj/structure/reagent_dispensers/fueltank) && src.reagents.total_volume == max_fuel)
		to_chat(user, SPAN_NOTICE(" The pack is already full!"))
		return
	..()

/obj/item/storage/backpack/marine/engineerpack/examine(mob/user)
	..()
	to_chat(user, "[reagents.total_volume] units of fuel left!")

// Pyrotechnician Spec backpack fuel tank
/obj/item/storage/backpack/marine/engineerpack/flamethrower
	name = "\improper USCM Pyrotechnician G6-2 fueltank"
	desc = "A specialized fueltank worn by USCM Pyrotechnicians for use with the M240-T incinerator unit. A small general storage compartment is installed."
	icon_state = "flamethrower_tank"
	max_fuel = 500
	fuel_type = "utnapthal"
	has_gamemode_skin = TRUE

/obj/item/storage/backpack/marine/engineerpack/flamethrower/attackby(obj/item/W, mob/living/user)
	if (istype(W, /obj/item/ammo_magazine/flamer_tank))
		var/obj/item/ammo_magazine/flamer_tank/FTL = W
		var/missing_volume = FTL.max_rounds - FTL.current_rounds

		//Fuel has to be standard napalm OR tank needs to be empty. We need to have a non-full tank and our backpack be dry
		if (((FTL.caliber == "UT-Napthal Fuel") || (!FTL.current_rounds)) && missing_volume && reagents.total_volume)
			var/fuel_available = reagents.total_volume < missing_volume ? reagents.total_volume : missing_volume
			reagents.remove_reagent("fuel", fuel_available)
			FTL.current_rounds = FTL.current_rounds + fuel_available
			playsound(loc, 'sound/effects/refill.ogg', 25, 1, 3)
			FTL.caliber = "UT-Napthal Fuel"
			to_chat(user, SPAN_NOTICE("You refill [FTL] with [FTL.caliber]."))
			FTL.update_icon()
	. = ..()

/obj/item/storage/backpack/marine/engineerpack/flamethrower/kit
	name = "\improper USCM Pyrotechnician G4-1 fueltank"
	desc = "A much older generation back rig that holds fuel in two tanks. A small regulator sits between the two. Has a few straps for holding up to three of the actual flamer tanks you'll be refilling."
	icon_state = "flamethrower_backpack"
	item_state = "flamethrower_backpack"
	max_fuel = 350
	has_gamemode_skin = FALSE
	max_storage_space = 15
	storage_slots = 3
	worn_accessible = TRUE
	can_hold = list(/obj/item/ammo_magazine/flamer_tank, /obj/item/tool/extinguisher)
	storage_flags = STORAGE_FLAGS_DEFAULT|STORAGE_ALLOW_DRAWING_METHOD_TOGGLE

//----------OTHER FACTIONS AND ERTS----------

/obj/item/storage/backpack/lightpack
	name = "\improper lightweight combat pack"
	desc = "A small lightweight pack for expeditions and short-range operations."
	icon_state = "ERT_satchel"
	worn_accessible = TRUE

/obj/item/storage/backpack/marine/engineerpack/ert
	name = "\improper lightweight technician welderpack"
	desc = "A small lightweight pack for expeditions and short-range operations. Features small fueltank for quick blowtorch refueling."
	icon_state = "ERT_satchel_welder"
	has_gamemode_skin = FALSE
	worn_accessible = TRUE
	max_fuel = 180

/obj/item/storage/backpack/commando
	name = "commando bag"
	desc = "A heavy-duty bag carried by Weston-Yamada commandos."
	icon_state = "commandopack"
	worn_accessible = TRUE

/obj/item/storage/backpack/mcommander
	name = "marine commanding officer backpack"
	desc = "The contents of this backpack are top secret."
	icon_state = "marinepack"
	storage_slots = null
	max_storage_space = 30

/obj/item/storage/backpack/ivan
	name = "The Armory"
	desc = "From the formless void, there springs an entity - More primordial than the elements themselves. In it's wake, there will follow a storm."
	icon_state = "ivan_bag"
	storage_slots = null
	max_storage_space = 30

/obj/item/storage/backpack/souto
	name = "\improper back mounted Suoto vending machine"
	max_storage_space = 30
	desc = "The loading mechanism for the Souto Slinger Supremo. And a portable souto vendor."
	icon_state = "supremo_pack"
	storage_slots = null
	flags_item = NODROP|DELONDROP
	flags_inventory = CANTSTRIP
	unacidable = TRUE
	var/internal_mag = new /obj/item/ammo_magazine/internal/souto
	worn_accessible = TRUE


//----------UPP SECTION----------

/obj/item/storage/backpack/lightpack/upp
	name = "\improper UCP3 combat pack"
	desc = "A UPP military standard-issue Union Combat Pack MK3."
	icon_state = "satchel_upp"
	worn_accessible = TRUE

//UPP engineer welderpack
/obj/item/storage/backpack/marine/engineerpack/upp
	name = "\improper UCP3-E technician welderpack"
	desc = "A special version of Union Combat Pack MK3 featuring small fueltank for quick blowtorch refueling. Used by UPP combat engineers in expeditions and short-range operations."
	icon_state = "satchel_upp_welder"
	has_gamemode_skin = FALSE
	worn_accessible = TRUE
	max_fuel = 180

/obj/item/storage/backpack/marine/satchel/scout_cloak/upp
	name = "\improper V86 Thermal Cloak"
	desc = "A thermo-optic camoflage cloak commonly used by UPP commando units"
	uniform_restricted = list(/obj/item/clothing/suit/storage/marine/faction/UPP/commando) //Need to wear UPP commando armor to equip this.

	max_storage_space = 21
	camo_alpha = 10
