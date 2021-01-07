
/*
CONTAINS:
CANDLES
MATCHES
CIGARETTES
CIGARS
SMOKING PIPES
CHEAP LIGHTERS
ZIPPO

CIGARETTE PACKETS ARE IN FANCY.DM
*/




/*
	candle, match, lighter
*/


/obj/item/tool/candle
	name = "red candle"
	desc = "a candle"
	icon = 'icons/obj/items/candle.dmi'
	icon_state = "candle1"
	item_state = "candle1"
	w_class = SIZE_TINY

	var/wax = 800

/obj/item/tool/candle/update_icon()
	var/i
	if(wax>150)
		i = 1
	else if(wax>80)
		i = 2
	else i = 3
	icon_state = "candle[i][heat_source ? "_lit" : ""]"

/obj/item/tool/candle/Destroy()
	if(heat_source)
		STOP_PROCESSING(SSobj, src)
	if(ismob(src.loc))
		src.loc.SetLuminosity(-CANDLE_LUM)
	else
		SetLuminosity(0)
	. = ..()

/obj/item/tool/candle/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.isOn()) //Badasses dont get blinded by lighting their candle with a blowtorch
			light(SPAN_NOTICE("[user] casually lights [src] with [W]."))
	else if(W.heat_source > 400)
		light()
	else
		return ..()

/obj/item/tool/candle/proc/light(flavor_text)
	if(!heat_source)
		heat_source = 1000
		if(!flavor_text)
			flavor_text = SPAN_NOTICE("[usr] lights [src].")
		for(var/mob/O in viewers(usr, null))
			O.show_message(flavor_text, 1)
		SetLuminosity(CANDLE_LUM)
		update_icon()
		START_PROCESSING(SSobj, src)

/obj/item/tool/candle/process()
	if(!heat_source)
		STOP_PROCESSING(SSobj, src)
		return
	wax--
	if(!wax)
		new/obj/item/trash/candle(src.loc)
		qdel(src)
		return
	update_icon()



/obj/item/tool/candle/attack_self(mob/user as mob)
	if(heat_source)
		heat_source = 0
		update_icon()
		SetLuminosity(0)
		user.SetLuminosity(-CANDLE_LUM)
		STOP_PROCESSING(SSobj, src)


/obj/item/tool/candle/pickup(mob/user)
	. = ..()
	if(heat_source && src.loc != user)
		SetLuminosity(0)
		user.SetLuminosity(CANDLE_LUM)


/obj/item/tool/candle/dropped(mob/user)
	..()
	if(heat_source && src.loc != user)
		user.SetLuminosity(-CANDLE_LUM)
		SetLuminosity(CANDLE_LUM)



///////////
//MATCHES//
///////////
/obj/item/tool/match
	name = "match"
	desc = "A simple match stick, used for lighting fine smokables."
	icon = 'icons/obj/items/cigarettes.dmi'
	icon_state = "match_unlit"
	var/burnt = 0
	var/smoketime = 10 SECONDS
	w_class = SIZE_TINY

	attack_verb = list("burnt", "singed")

/obj/item/tool/match/process(delta_time)
	smoketime -= delta_time SECONDS
	if(smoketime < 1)
		burn_out()
		return



/obj/item/tool/match/Destroy()
	if(heat_source)
		STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/tool/match/dropped(mob/user)
	if(heat_source)
		burn_out(user)
	return ..()

/obj/item/tool/match/proc/light_match()
	if(heat_source) return
	heat_source = 1000
	playsound(src.loc,"match",15, 1, 3)
	damtype = "burn"
	icon_state = "match_lit"
	if(ismob(loc))
		loc.SetLuminosity(2)
	else
		SetLuminosity(2)
	START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/tool/match/proc/burn_out(mob/user)
	heat_source = 0
	burnt = 1
	damtype = "brute"
	icon_state = "match_burnt"
	item_state = "cigoff"
	if(user && loc != user)
		user.SetLuminosity(-2)
	SetLuminosity(0)
	name = "burnt match"
	desc = "A match. This one has seen better days."
	STOP_PROCESSING(SSobj, src)

/obj/item/tool/lighter/dropped(mob/user)
	if(heat_source && src.loc != user)
		user.SetLuminosity(-2)
		SetLuminosity(2)
	return ..()
//////////////////
//FINE SMOKABLES//
//////////////////
/obj/item/clothing/mask/cigarette
	name = "cigarette"
	desc = "A roll of tobacco and fillers, wrapped in paper with a filter at the end. Apparently, inhaling the smoke makes you feel happier."
	icon_state = "cigoff"
	throw_speed = SPEED_AVERAGE
	item_state = "cigoff"
	w_class = SIZE_TINY
	flags_armor_protection = 0
	flags_atom = CAN_BE_SYRINGED
	attack_verb = list("burnt", "singed")
	blood_overlay_type = ""
	var/icon_on = "cigon"  //Note - these are in masks.dmi not in cigarette.dmi
	var/icon_off = "cigoff"
	var/type_butt = /obj/item/trash/cigbutt
	var/lastHolder = null
	var/smoketime = 10 MINUTES
	var/chem_volume = 15

/obj/item/clothing/mask/cigarette/Initialize()
	. = ..()
	flags_atom |= NOREACT // so it doesn't react until you light it
	create_reagents(chem_volume) // making the cigarrete a chemical holder with a maximum volume of 15
	reagents.add_reagent("nicotine",10)

/obj/item/clothing/mask/cigarette/attackby(obj/item/W, mob/user)
	..()
	if(istype(W, /obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.isOn())//Badasses dont get blinded while lighting their cig with a blowtorch
			light(SPAN_NOTICE("[user] casually lights the [name] with [W]."))

	else if(istype(W, /obj/item/tool/lighter/zippo))
		var/obj/item/tool/lighter/zippo/Z = W
		if(Z.heat_source)
			light("<span class='rose'>With a flick of their wrist, [user] lights their [name] with [W].</span>")

	else if(istype(W, /obj/item/device/flashlight/flare))
		var/obj/item/device/flashlight/flare/FL = W
		if(FL.heat_source)
			light(SPAN_NOTICE("[user] lights their [name] with [W]."))

	else if(istype(W, /obj/item/tool/lighter))
		var/obj/item/tool/lighter/L = W
		if(L.heat_source)
			light(SPAN_NOTICE("[user] manages to light their [name] with [W]."))

	else if(istype(W, /obj/item/tool/match))
		var/obj/item/tool/match/M = W
		if(M.heat_source)
			light(SPAN_NOTICE("[user] lights their [name] with their [W]."))

	else if(istype(W, /obj/item/weapon/melee/energy/sword))
		var/obj/item/weapon/melee/energy/sword/S = W
		if(S.active)
			light(SPAN_WARNING("[user] swings their [W], barely missing their nose. They light their [name] in the process."))

	else if(istype(W, /obj/item/device/assembly/igniter))
		light(SPAN_NOTICE("[user] fiddles with [W], and manages to light their [name]."))

	else if(istype(W, /obj/item/attachable/attached_gun/flamer))
		light(SPAN_NOTICE("[user] lights their [src] with the [W]."))

	else if(istype(W, /obj/item/weapon/gun/flamer))
		var/obj/item/weapon/gun/flamer/F = W
		if(!(F.flags_gun_features & GUN_TRIGGER_SAFETY))
			light(SPAN_NOTICE("[user] lights their [src] with the pilot light of the [F]."))
		else
			to_chat(user, SPAN_WARNING("Turn on the pilot light first!"))

	else if(istype(W, /obj/item/weapon/gun))
		var/obj/item/weapon/gun/G = W
		for(var/slot in G.attachments)
			if(istype(G.attachments[slot], /obj/item/attachable/attached_gun/flamer))
				light(SPAN_NOTICE("[user] lights their [src] with [G.attachments[slot]]."))
				break


	else if(istype(W, /obj/item/tool/surgery/cautery))
		light(SPAN_NOTICE("[user] lights their [src] with the [W]."))

	else if(istype(W, /obj/item/clothing/mask/cigarette))
		var/obj/item/clothing/mask/cigarette/C = W
		if(C.item_state == icon_on)
			light(SPAN_NOTICE("[user] lights their [src] with the [C] after a few attempts."))

	else if(istype(W, /obj/item/tool/candle))
		if(W.heat_source > 200)
			light(SPAN_NOTICE("[user] lights their [src] with the [W] after a few attempts."))

	return


/obj/item/clothing/mask/cigarette/afterattack(atom/target, mob/living/user, proximity)
	..()
	if(!proximity) return
	if(istype(target, /obj/item/reagent_container/glass))	//you can dip cigarettes into beakers
		var/obj/item/reagent_container/glass/glass = target
		var/transfered = glass.reagents.trans_to(src, chem_volume)
		if(transfered)	//if reagents were transfered, show the message
			to_chat(user, SPAN_NOTICE("You dip \the [src] into \the [glass]."))
		else			//if not, either the beaker was empty, or the cigarette was full
			if(!glass.reagents.total_volume)
				to_chat(user, SPAN_NOTICE("[glass] is empty."))
			else
				to_chat(user, SPAN_NOTICE("[src] is full."))

	else if(isturf(target))
		var/turf/T = target
		if(locate(/obj/flamer_fire) in T.contents)
			light(SPAN_NOTICE("[user] lights their [src] with the burning ground."))

	else if(isliving(target))
		var/mob/living/M = target
		if(M.on_fire)
			if(user == M)
				light(SPAN_NOTICE("[user] lights their [src] from their own burning body, that's crazy!"))
			else
				light(SPAN_NOTICE("[user] lights their [src] from the burning body of [M], that's stone cold."))

	else if(istype(target, /obj/structure/machinery/light))
		var/obj/structure/machinery/light/fixture = target
		if(fixture.is_broken())
			light(SPAN_NOTICE("[user] lights their [src] from the broken light."))

/obj/item/clothing/mask/cigarette/proc/light(flavor_text)
	if(!heat_source)
		heat_source = 1000
		damtype = "fire"
		if(reagents.get_reagent_amount("phoron")) // the phoron explodes when exposed to fire
			var/datum/effect_system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("phoron") / 2.5, 1), get_turf(src), 0, 0)
			e.start()
			qdel(src)
			return
		if(reagents.get_reagent_amount("fuel")) // the fuel explodes, too, but much less violently
			var/datum/effect_system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("fuel") / 5, 1), get_turf(src), 0, 0)
			e.start()
			qdel(src)
			return
		flags_atom &= ~NOREACT // allowing reagents to react after being lit
		reagents.handle_reactions()
		icon_state = icon_on
		item_state = icon_on
		if(iscarbon(loc))
			var/mob/living/carbon/C = loc
			if(C.r_hand == src)
				C.update_inv_r_hand()
			else if(C.l_hand == src)
				C.update_inv_l_hand()
			else if(ishuman(loc))
				var/mob/living/carbon/human/H = loc
				if(H.wear_mask == src)
					H.update_inv_wear_mask()
		if(flavor_text)
			var/turf/T = get_turf(src)
			T.visible_message(flavor_text)
		START_PROCESSING(SSobj, src)

/obj/item/clothing/mask/cigarette/process(delta_time)
	var/mob/living/M = loc
	if(isliving(loc))
		M.IgniteMob()
	smoketime -= delta_time SECONDS
	if(smoketime < 1)
		die()
		return

	if(reagents && reagents.total_volume)	//	check if it has any reagents at all
		if(iscarbon(loc) && (src == loc:wear_mask)) // if it's in the human/monkey mouth, transfer reagents to the mob
			if(istype(loc, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = loc
				if(H.species.flags & IS_SYNTHETIC)
					return
			var/mob/living/carbon/C = loc

			if(prob(15)) // so it's not an instarape in case of acid
				reagents.reaction(C, INGEST)
			reagents.trans_to(C, REAGENTS_METABOLISM)
		else // else just remove some of the reagents
			reagents.remove_any(REAGENTS_METABOLISM)
	return


/obj/item/clothing/mask/cigarette/attack_self(mob/user)
	if(heat_source)
		user.visible_message(SPAN_NOTICE("[user] calmly drops and treads on the lit [src], putting it out instantly."))
		die()
	return ..()


/obj/item/clothing/mask/cigarette/proc/die()
	var/turf/T = get_turf(src)
	var/obj/item/butt = new type_butt(T)
	transfer_fingerprints_to(butt)
	if(ismob(loc))
		var/mob/living/M = loc
		to_chat(M, SPAN_NOTICE("Your [name] goes out."))
		M.temp_drop_inv_item(src)	//un-equip it so the overlays can update
		M.update_inv_wear_mask()
	STOP_PROCESSING(SSobj, src)
	qdel(src)

/obj/item/clothing/mask/cigarette/ucigarette
	icon_on = "ucigon"
	icon_off = "ucigoff"
	type_butt = /obj/item/trash/ucigbutt
	name = "cigarette"
	desc = "An unfiltered roll of tobacco and nicotine. Smoking this releases even more tar and soot into your mouth."
	item_state = "cigoff"
	icon_state = "ucigoff"

/obj/item/clothing/mask/cigarette/bcigarette
	icon_on = "bcigon"
	icon_off = "bcigoff"
	type_butt = /obj/item/trash/bcigbutt
	name = "cigarette"
	desc = "A roll of tobacco, nicotine, and some phosphor, in a fancy black package. The phosphor makes the tip glow blue when lit."
	item_state = "bcigoff"
	icon_state = "bcigoff"

////////////
//  WEED  //
////////////
/obj/item/clothing/mask/cigarette/weed
	name = "weed joint"
	desc = "A rolled up package of ambrosia vulgaris, aka space weed, in some smooth paper; you sure this is legal dude?"
	chem_volume = 39
	smoketime = 20 MINUTES

/obj/item/clothing/mask/cigarette/weed/Initialize()
	. = ..()
	reagents.add_reagent("space_drugs",15)
	reagents.add_reagent("bicaridine", 8)
	reagents.add_reagent("kelotane", 1)

////////////
// CIGARS //
////////////
/obj/item/clothing/mask/cigarette/cigar
	name = "premium cigar"
	desc = "A huge, brown roll of tobacco and some other stuff that you're meant to smoke. Makes you feel like a true USCM sergeant."
	icon_state = "cigar_off"
	icon_on = "cigar_on"
	icon_off = "cigar_off"
	type_butt = /obj/item/trash/cigbutt/cigarbutt
	throw_speed = SPEED_VERY_FAST
	item_state = "cigar_off"
	smoketime = 50 MINUTES
	chem_volume = 20

/obj/item/clothing/mask/cigarette/cigar/Initialize()
	. = ..()
	reagents.add_reagent("nicotine",10)

/obj/item/clothing/mask/cigarette/cigar/cohiba
	name = "\improper Cohiba Robusto cigar"
	desc = "There's little more you could want from a cigar."

/obj/item/clothing/mask/cigarette/cigar/havana
	name = "premium Havanian cigar"
	desc = "A cigar fit for only the best of the best."
	smoketime = 7200
	chem_volume = 30


/obj/item/clothing/mask/cigarette/cigar/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.isOn())
			light(SPAN_NOTICE("[user] insults [name] by lighting it with [W]."))

	else if(istype(W, /obj/item/tool/lighter/zippo))
		var/obj/item/tool/lighter/zippo/Z = W
		if(Z.heat_source)
			light("<span class='rose'>With a flick of their wrist, [user] lights their [name] with their [W].</span>")

	else if(istype(W, /obj/item/device/flashlight/flare))
		var/obj/item/device/flashlight/flare/FL = W
		if(FL.heat_source)
			light(SPAN_NOTICE("[user] lights their [name] with [W]."))

	else if(istype(W, /obj/item/tool/lighter))
		var/obj/item/tool/lighter/L = W
		if(L.heat_source)
			light(SPAN_NOTICE("[user] manages to offend their [name] by lighting it with [W]."))

	else if(istype(W, /obj/item/tool/match))
		var/obj/item/tool/match/M = W
		if(M.heat_source)
			light(SPAN_NOTICE("[user] lights their [name] with their [W]."))

	else if(istype(W, /obj/item/weapon/melee/energy/sword))
		var/obj/item/weapon/melee/energy/sword/S = W
		if(S.active)
			light(SPAN_WARNING("[user] swings their [W], barely missing their nose. They light their [name] in the process."))

	else if(istype(W, /obj/item/device/assembly/igniter))
		light(SPAN_NOTICE("[user] fiddles with [W], and manages to light their [name] with the power of science."))

	else if(istype(W, /obj/item/attachable/attached_gun/flamer))
		light(SPAN_NOTICE("[user] lights their [src] with the [W], bet that would have looked cooler if it was attached to something first!"))

	else if(istype(W, /obj/item/weapon/gun/flamer))
		var/obj/item/weapon/gun/flamer/F = W
		if(!(F.flags_gun_features & GUN_TRIGGER_SAFETY))
			light(SPAN_NOTICE("[user] lights their [src] with the pilot light of the [F], the glint of pyromania in their eye."))
		else
			to_chat(user, SPAN_WARNING("Turn on the pilot light first!"))

	else if(istype(W, /obj/item/weapon/gun))
		var/obj/item/weapon/gun/G = W
		for(var/slot in G.attachments)
			if(istype(G.attachments[slot], /obj/item/attachable/attached_gun/flamer))
				light(SPAN_NOTICE("[user] lights their [src] with [G.attachments[slot]] like a complete badass."))
				break

	else if(istype(W, /obj/item/tool/surgery/cautery))
		light(SPAN_NOTICE("[user] lights their [src] with the [W], that can't be sterile!."))

	else if(istype(W, /obj/item/clothing/mask/cigarette))
		var/obj/item/clothing/mask/cigarette/C = W
		if(C.item_state == icon_on)
			light(SPAN_NOTICE("[user] lights their [src] with the [C] after a few attempts."))

	else if(istype(W, /obj/item/tool/candle))
		if(W.heat_source > 200)
			light(SPAN_NOTICE("[user] lights their [src] with the [W] after a few attempts."))

/////////////////
//SMOKING PIPES//
/////////////////
/obj/item/clothing/mask/cigarette/pipe
	name = "smoking pipe"
	desc = "A pipe, for smoking. Probably made of meershaum or something."
	icon_state = "pipeoff"
	item_state = "pipeoff"
	icon_on = "pipeon"  //Note - these are in masks.dmi
	icon_off = "pipeoff"
	smoketime = 200 SECONDS

/obj/item/clothing/mask/cigarette/pipe/process(delta_time)
	var/turf/location = get_turf(src)
	smoketime -= delta_time SECONDS
	if(smoketime < 1)
		new /obj/effect/decal/cleanable/ash(location)
		if(ismob(loc))
			var/mob/living/M = loc
			to_chat(M, SPAN_NOTICE("Your [name] goes out, and you empty the ash."))
			heat_source = 0
			icon_state = icon_off
			item_state = icon_off
			M.update_inv_wear_mask(0)
		STOP_PROCESSING(SSobj, src)
		return

/obj/item/clothing/mask/cigarette/pipe/attack_self(mob/user as mob) //Refills the pipe. Can be changed to an attackby later, if loose tobacco is added to vendors or something.
	if(heat_source)
		user.visible_message(SPAN_NOTICE("[user] puts out [src]."))
		heat_source = 0
		icon_state = icon_off
		item_state = icon_off
		STOP_PROCESSING(SSobj, src)
		return
	if(smoketime <= 0)
		to_chat(user, SPAN_NOTICE("You refill the pipe with tobacco."))
		smoketime = initial(smoketime)
	return

/obj/item/clothing/mask/cigarette/pipe/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.isOn())//
			light(SPAN_NOTICE("[user] recklessly lights [name] with [W]."))

	else if(istype(W, /obj/item/tool/lighter/zippo))
		var/obj/item/tool/lighter/zippo/Z = W
		if(Z.heat_source)
			light("<span class='rose'>With much care, [user] lights their [name] with their [W].</span>")

	else if(istype(W, /obj/item/device/flashlight/flare))
		var/obj/item/device/flashlight/flare/FL = W
		if(FL.heat_source)
			light(SPAN_NOTICE("[user] lights their [name] with [W]."))

	else if(istype(W, /obj/item/tool/lighter))
		var/obj/item/tool/lighter/L = W
		if(L.heat_source)
			light(SPAN_NOTICE("[user] manages to light their [name] with [W]."))

	else if(istype(W, /obj/item/tool/match))
		var/obj/item/tool/match/M = W
		if(M.heat_source)
			light(SPAN_NOTICE("[user] lights their [name] with their [W]."))

	else if(istype(W, /obj/item/device/assembly/igniter))
		light(SPAN_NOTICE("[user] fiddles with [W], and manages to light their [name] with the power of science."))

/obj/item/clothing/mask/cigarette/pipe/cobpipe
	name = "corn cob pipe"
	desc = "A nicotine delivery system popularized by folksy backwoodsmen, kept popular in the modern age and beyond by space hipsters."
	icon_state = "cobpipeoff"
	item_state = "cobpipeoff"
	icon_on = "cobpipeon"  //Note - these are in masks.dmi
	icon_off = "cobpipeoff"
	smoketime = 800 SECONDS



/////////
//ZIPPO//
/////////
/obj/item/tool/lighter
	name = "cheap lighter"
	desc = "A cheap-as-free lighter."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "lighter_g"
	item_state = "lighter_g"
	var/icon_on = "lighter_g_on"
	var/icon_off = "lighter_g"
	var/clr = "g"
	w_class = SIZE_TINY
	throwforce = 4
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	attack_verb = list("burnt", "singed")

/obj/item/tool/lighter/zippo
	name = "\improper Zippo lighter"
	desc = "A fancy steel Zippo lighter. Ignite in style."
	icon_state = "zippo"
	item_state = "zippo"
	icon_on = "zippoon"
	icon_off = "zippo"

/obj/item/tool/lighter/random

/obj/item/tool/lighter/random/Initialize()
		. = ..()
		clr = pick("r","c","y","g")
		icon_on = "lighter_[clr]_on"
		icon_off = "lighter_[clr]"
		icon_state = icon_off

/obj/item/tool/lighter/Destroy()
	if(ismob(src.loc))
		src.loc.SetLuminosity(-2)
	else
		SetLuminosity(0)
	. = ..()

/obj/item/tool/lighter/attack_self(mob/living/user)
	if(user.r_hand == src || user.l_hand == src)
		if(!heat_source)
			heat_source = 1500
			icon_state = icon_on
			item_state = icon_on
			if(istype(src, /obj/item/tool/lighter/zippo) )
				user.visible_message("<span class='rose'>Without even breaking stride, [user] flips open and lights [src] in one smooth movement.</span>")
				playsound(src.loc,"zippo_open",10, 1, 3)
			else
				playsound(src.loc,"lighter",10, 1, 3)
				if(prob(95))
					user.visible_message(SPAN_NOTICE("After a few attempts, [user] manages to light the [src]."))

				else
					to_chat(user, SPAN_WARNING("You burn yourself while lighting the lighter."))
					if (user.l_hand == src)
						user.apply_damage(2,BURN,"l_hand")
					else
						user.apply_damage(2,BURN,"r_hand")
					user.visible_message(SPAN_NOTICE("After a few attempts, [user] manages to light the [src], they however burn their finger in the process."))

			user.SetLuminosity(2)
			START_PROCESSING(SSobj, src)
		else
			turn_off(user, 0)
	else
		return ..()
	return

/obj/item/tool/lighter/proc/turn_off(mob/living/bearer, var/silent = 1)
	if(heat_source)
		heat_source = 0
		icon_state = icon_off
		item_state = icon_off
		if(!silent)
			if(istype(src, /obj/item/tool/lighter/zippo) )
				bearer.visible_message("<span class='rose'>You hear a quiet click, as [bearer] shuts off [src] without even looking at what they're doing.")
				playsound(src.loc,"zippo_close",10, 1, 3)
			else
				bearer.visible_message(SPAN_NOTICE("[bearer] quietly shuts off the [src]."))

		bearer.SetLuminosity(-2)
		STOP_PROCESSING(SSobj, src)
		return 1
	return 0

/obj/item/tool/lighter/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!isliving(M))
		return
	M.IgniteMob()
	if(!istype(M, /mob))
		return

	if(istype(M.wear_mask, /obj/item/clothing/mask/cigarette) && user.zone_selected == "mouth" && heat_source)
		var/obj/item/clothing/mask/cigarette/cig = M.wear_mask
		if(M == user)
			cig.attackby(src, user)
		else
			if(istype(src, /obj/item/tool/lighter/zippo))
				cig.light("<span class='rose'>[user] whips the [name] out and holds it for [M].</span>")
			else
				cig.light(SPAN_NOTICE("[user] holds the [name] out for [M], and lights the [cig.name]."))
	else
		..()

/obj/item/tool/lighter/process()


/obj/item/tool/lighter/pickup(mob/user)
	. = ..()
	if(heat_source && src.loc != user)
		SetLuminosity(0)
		user.SetLuminosity(2)


/obj/item/tool/lighter/dropped(mob/user)
	if(heat_source && src.loc != user)
		user.SetLuminosity(-2)
		SetLuminosity(2)
	return ..()
