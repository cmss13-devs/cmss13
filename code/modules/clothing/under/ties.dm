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
	///Jumpsuit flags that cause the accessory to be hidden. format: "x" OR "(x|y|z)" (w/o quote marks).
	var/jumpsuit_hide_states
	var/high_visibility	//if it should appear on examine without detailed view
	var/removable = TRUE
	flags_equip_slot = SLOT_ACCESSORY
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/ties_monkey.dmi')

/obj/item/clothing/accessory/Initialize()
	. = ..()
	inv_overlay = image("icon" = 'icons/obj/items/clothing/ties_overlay.dmi', "icon_state" = "[item_state? "[item_state]" : "[icon_state]"]")
	flags_atom |= USES_HEARING

/obj/item/clothing/accessory/Destroy()
	if(has_suit)
		has_suit.remove_accessory()
	inv_overlay = null
	. = ..()

/obj/item/clothing/accessory/proc/can_attach_to(var/mob/user, var/obj/item/clothing/C)
	return TRUE

//when user attached an accessory to S
/obj/item/clothing/accessory/proc/on_attached(obj/item/clothing/S, mob/living/user, silent)
	if(!istype(S))
		return
	has_suit = S
	forceMove(has_suit)
	has_suit.overlays += get_inv_overlay()

	if(user)
		if(!silent)
			to_chat(user, SPAN_NOTICE("You attach \the [src] to \the [has_suit]."))
		src.add_fingerprint(user)
	return TRUE

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
	return TRUE

//default attackby behaviour
/obj/item/clothing/accessory/attackby(obj/item/I, mob/user)
	..()

//default attack_hand behaviour
/obj/item/clothing/accessory/attack_hand(mob/user as mob)
	if(has_suit)
		return	//we aren't an object on the ground so don't call parent. If overriding to give special functions to a host item, return TRUE so that the host doesn't continue its own attack_hand.
	..()

///Extra text to append when attached to another clothing item and the host clothing is examined.
/obj/item/clothing/accessory/proc/additional_examine_text()
	return "."

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
	jumpsuit_hide_states = UNIFORM_JACKET_REMOVED

/obj/item/clothing/accessory/medal/on_attached(obj/item/clothing/S, mob/living/user, silent)
	. = ..()
	if(.)
		RegisterSignal(S, COMSIG_ITEM_PICKUP, .proc/remove_medal)

/obj/item/clothing/accessory/medal/proc/remove_medal(var/obj/item/clothing/C, var/mob/user)
	SIGNAL_HANDLER
	if(user.real_name != recipient_name)
		C.remove_accessory(user, src)
		user.drop_held_item(src)

/obj/item/clothing/accessory/medal/on_removed(mob/living/user, obj/item/clothing/C)
	. = ..()
	if(.)
		UnregisterSignal(C, COMSIG_ITEM_PICKUP)

/obj/item/clothing/accessory/medal/attack(mob/living/carbon/human/H, mob/living/carbon/human/user)
	if(!(istype(H) && istype(user)))
		return ..()
	if(recipient_name != H.real_name)
		to_chat(user, SPAN_WARNING("[src] wasn't awarded to [H]."))
		return

	var/obj/item/clothing/U
	if(H.wear_suit && H.wear_suit.can_attach_accessory(src)) //Prioritises topmost garment, IE service jackets, if possible.
		U = H.wear_suit
	else
		U = H.w_uniform //Will be null if no uniform. That this allows medal ceremonies in which the hero is wearing no pants is correct and just.
	if(!U)
		if(user == H)
			to_chat(user, SPAN_WARNING("You aren't wearing anything you can pin [src] to."))
		else
			to_chat(user, SPAN_WARNING("[H] isn't wearing anything you can pin [src] to."))
		return

	if(user == H)
		user.visible_message(SPAN_NOTICE("[user] pins [src] to \his [U.name]."),
		SPAN_NOTICE("You pin [src] to your [U.name]."))

	else
		if(user.action_busy)
			return
		if(user.a_intent != INTENT_HARM)
			user.affected_message(H,
			SPAN_NOTICE("You start to pin [src] onto [H]."),
			SPAN_NOTICE("[user] starts to pin [src] onto you."),
			SPAN_NOTICE("[user] starts to pin [src] onto [H]."))
			if(!do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, H))
				return
			if(!(U == H.w_uniform || U == H.wear_suit))
				to_chat(user, SPAN_WARNING("[H] took off \his [U.name] before you could finish pinning [src] to it."))
				return
			user.affected_message(H,
			SPAN_NOTICE("You pin [src] to [H]'s [U.name]."),
			SPAN_NOTICE("[user] pins [src] to your [U.name]."),
			SPAN_NOTICE("[user] pins [src] to [H]'s [U.name]."))

		else
			user.affected_message(H,
			SPAN_ALERT("You start to pin [src] to [H]."),
			SPAN_ALERT("[user] starts to pin [src] to you."),
			SPAN_ALERT("[user] starts to pin [src] to [H]."))
			if(!do_after(user, 10, INTERRUPT_ALL, BUSY_ICON_HOSTILE, H))
				return
			if(!(U == H.w_uniform || U == H.wear_suit))
				to_chat(user, SPAN_WARNING("[H] took off \his [U.name] before you could finish pinning [src] to \him."))
				return
			user.affected_message(H,
			SPAN_DANGER("You slam the [src.name]'s pin through [H]'s [U.name] and into \his chest."),
			SPAN_DANGER("[user] slams the [src.name]'s pin through your [U.name] and into your chest!"),
			SPAN_DANGER("[user] slams the [src.name]'s pin through [H]'s [U.name] and into \his chest."))

			/*Some duplication from punch code due to attack message and damage stats.
			This does cut damage and awarding multiple medals like this to the same person will cause bleeding.*/
			H.last_damage_data = create_cause_data("macho bullshit", user)
			user.animation_attack_on(H)
			user.flick_attack_overlay(H, "punch")
			playsound(user.loc, "punch", 25, 1)
			H.apply_damage(5, BRUTE, "chest", 1)

			if(!H.stat && H.pain.feels_pain)
				if(prob(35))
					INVOKE_ASYNC(H, /mob.proc/emote, "pain")
				else
					INVOKE_ASYNC(H, /mob.proc/emote, "me", 1, "winces.")

	if(U.can_attach_accessory(src) && user.drop_held_item())
		U.attach_accessory(H, src, TRUE)

/obj/item/clothing/accessory/medal/can_attach_to(mob/user, obj/item/clothing/C)
	if(user.real_name != recipient_name)
		return FALSE
	return TRUE

/obj/item/clothing/accessory/medal/get_examine_text(mob/user)
	. = ..()

	var/citation_to_read = ""
	if(medal_citation)
		citation_to_read = "The citation reads \'[medal_citation]\'."

	. += "Awarded to: \'[recipient_rank] [recipient_name]\'. [citation_to_read]"

/obj/item/clothing/accessory/medal/bronze
	name = "bronze medal"
	desc = "A bronze medal."

/obj/item/clothing/accessory/medal/bronze/conduct
	name = MARINE_CONDUCT_MEDAL
	desc = "A bronze medal awarded for distinguished conduct. Whilst a great honor, this is the most basic award given by the USCM"
	icon_state = "bronze_b"

/obj/item/clothing/accessory/medal/bronze/heart
	name = MARINE_BRONZE_HEART_MEDAL
	desc = "A bronze heart-shaped medal awarded for sacrifice. It is often awarded posthumously or for severe injury in the line of duty."
	icon_state = "bronze_heart"

/obj/item/clothing/accessory/medal/bronze/science
	name = "nobel sciences award"
	desc = "A bronze medal which represents significant contributions to the field of science or engineering."

/obj/item/clothing/accessory/medal/silver
	name = "silver medal"
	desc = "A silver medal."
	icon_state = "silver_b"

/obj/item/clothing/accessory/medal/silver/valor
	name = MARINE_VALOR_MEDAL
	desc = "A silver medal awarded for acts of exceptional valor."

/obj/item/clothing/accessory/medal/silver/security
	name = "robust security award"
	desc = "An award for distinguished combat and sacrifice in defence of Wey-Yu's commercial interests. Often awarded to security staff."

/obj/item/clothing/accessory/medal/gold
	name = "gold medal"
	desc = "A prestigious golden medal."
	icon_state = "gold_b"

/obj/item/clothing/accessory/medal/gold/captain
	name = "medal of captaincy"
	desc = "A golden medal awarded exclusively to those promoted to the rank of captain. It signifies the codified responsibilities of a captain to Wey-Yu, and their undisputable authority over their crew."

/obj/item/clothing/accessory/medal/gold/heroism
	name = MARINE_HEROISM_MEDAL
	desc = "An extremely rare golden medal awarded only by the USCM. To receive such a medal is the highest honor and as such, very few exist."

/obj/item/clothing/accessory/medal/platinum
	name = "platinum medal"
	desc = "A very prestigious platinum medal, only able to be handed out by generals due to special circumstances."
	icon_state = "platinum_b"

/obj/item/clothing/accessory/medal/bronze/service
	name = "bronze service medal"
	desc = "A bronze medal awarded for a marine's service within the USCM. It is a very common medal, and is typically the first medal a marine would receive."
	icon_state = "bronze"

/obj/item/clothing/accessory/medal/silver/service
	name = "silver service medal"
	desc = "A shiny silver medal awarded for a marine's service within the USCM. It is a somewhat common medal which signifies the amount of time a marine has spent in the line of duty."
	icon_state = "silver"
/obj/item/clothing/accessory/medal/gold/service
	name = "gold service medal"
	desc = "A prestigious gold medal awarded for a marine's service within the USCM. It is a rare medal which signifies the amount of time a marine has spent in the line of duty."
	icon_state = "gold"
/obj/item/clothing/accessory/medal/platinum/service
	name = "platinum service medal"
	desc = "The highest service medal that can be awarded to a marine; such medals are hand-given by USCM Generals to a marine. It signifies the sheer amount of time a marine has spent in the line of duty."
	icon_state = "platinum"
//Armbands
/obj/item/clothing/accessory/armband
	name = "red armband"
	desc = "A fancy red armband!"
	icon_state = "red"
	slot = ACCESSORY_SLOT_ARMBAND
	jumpsuit_hide_states = (UNIFORM_SLEEVE_CUT|UNIFORM_JACKET_REMOVED)

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
	desc = "A fire-resistant shoulder patch, worn by the men and women of the United States Colonial Marines."
	icon_state = "uscmpatch"
	jumpsuit_hide_states = (UNIFORM_SLEEVE_ROLLED|UNIFORM_SLEEVE_CUT|UNIFORM_JACKET_REMOVED)

/obj/item/clothing/accessory/patch/falcon
	name = "\improper Falling Falcons patch"
	desc = "A fire-resistant shoulder patch, worn by the men and women of the Falling Falcons, the 2nd battalion of the 4th brigade of the USCM."
	icon_state = "fallingfalconspatch"

/obj/item/clothing/accessory/poncho
	name = "USCM Poncho"
	desc = "The standard USCM poncho has variations for every climate. Custom fitted to be attached to standard USCM armor variants it is comfortable, warming or cooling as needed, and well-fit. A marine couldn't ask for more. Affectionately referred to as a \"woobie\"."
	icon_state = "poncho"
	slot = ACCESSORY_SLOT_PONCHO

/obj/item/clothing/accessory/poncho/Initialize()
	. = ..()
	select_gamemode_skin(type)
	inv_overlay = image("icon" = 'icons/obj/items/clothing/ties_overlay.dmi', "icon_state" = "[icon_state]")
	update_icon()

//Ties that can store stuff

/obj/item/storage/internal/accessory
	storage_slots = 3

/obj/item/clothing/accessory/storage
	name = "load bearing equipment"
	desc = "Used to hold things when you don't have enough hands."
	icon_state = "webbing"
	w_class = SIZE_LARGE //too big to store in other pouches
	var/obj/item/storage/internal/hold = /obj/item/storage/internal/accessory
	slot = ACCESSORY_SLOT_UTILITY
	high_visibility = TRUE

/obj/item/clothing/accessory/storage/Initialize()
	. = ..()
	hold = new hold(src)

/obj/item/clothing/accessory/storage/Destroy()
	QDEL_NULL(hold)
	return ..()

/obj/item/clothing/accessory/storage/clicked(var/mob/user, var/list/mods)
	if(mods["alt"] && !isnull(hold) && loc == user && !user.get_active_hand()) //To pass quick-draw attempts to storage. See storage.dm for explanation.
		return
	. = ..()

/obj/item/clothing/accessory/storage/attack_hand(mob/user as mob, mods)
	if (!isnull(hold) && hold.handle_attack_hand(user, mods))
		..(user)
	return TRUE

/obj/item/clothing/accessory/storage/MouseDrop(obj/over_object as obj)
	if (has_suit || hold)
		return

	if (hold.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/clothing/accessory/storage/attackby(obj/item/W, mob/user)
	return hold.attackby(W, user)

/obj/item/clothing/accessory/storage/emp_act(severity)
	hold.emp_act(severity)
	..()

/obj/item/clothing/accessory/storage/hear_talk(mob/M, var/msg)
	hold.hear_talk(M, msg)
	..()

/obj/item/clothing/accessory/storage/attack_self(mob/user)
	..()
	to_chat(user, SPAN_NOTICE("You empty [src]."))
	var/turf/T = get_turf(src)
	hold.storage_close(usr)
	for(var/obj/item/I in hold.contents)
		hold.remove_from_storage(I, T)
	src.add_fingerprint(user)

/obj/item/clothing/accessory/storage/on_attached(obj/item/clothing/C, mob/living/user, silent)
	. = ..()
	if(.)
		C.w_class = w_class //To prevent monkey business.
		C.verbs += /obj/item/clothing/suit/storage/verb/toggle_draw_mode

/obj/item/clothing/accessory/storage/on_removed(mob/living/user, obj/item/clothing/C)
	. = ..()
	if(.)
		C.w_class = initial(C.w_class)
		C.verbs -= /obj/item/clothing/suit/storage/verb/toggle_draw_mode

/obj/item/storage/internal/accessory/webbing
	bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/sniper,
	)

/obj/item/clothing/accessory/storage/webbing
	name = "webbing"
	desc = "A sturdy mess of synthcotton belts and buckles, ready to share your burden."
	icon_state = "webbing"
	hold = /obj/item/storage/internal/accessory/webbing

/obj/item/clothing/accessory/storage/webbing/five_slots
	hold = /obj/item/storage/internal/accessory/webbing/five_slots

/obj/item/storage/internal/accessory/webbing/five_slots
	storage_slots = 5

/obj/item/storage/internal/accessory/black_vest
	storage_slots = 5

/obj/item/clothing/accessory/storage/black_vest
	name = "black webbing vest"
	desc = "Robust black synthcotton vest with lots of pockets to hold whatever you need, but cannot hold in hands."
	icon_state = "vest_black"
	hold = /obj/item/storage/internal/accessory/black_vest

/obj/item/clothing/accessory/storage/black_vest/attackby(obj/item/W, mob/living/user)
	if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS) && skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
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

/obj/item/clothing/accessory/storage/black_vest/waistcoat
	name = "tactical waistcoat"
	desc = "A stylish black waistcoat with plenty of discreet pouches, to be both utilitarian and fashionable without compromising looks."
	icon_state = "waistcoat"

/obj/item/clothing/accessory/storage/black_vest/tool_webbing
	hold = /obj/item/storage/internal/accessory/black_vest/tool_webbing

/obj/item/storage/internal/accessory/black_vest/tool_webbing
	storage_slots = 7

/obj/item/storage/internal/accessory/black_vest/tool_webbing/fill_preset_inventory()
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/stack/cable_coil(src)
	new /obj/item/device/multitool(src)

/obj/item/storage/internal/accessory/surg_vest
	storage_slots = 13
	can_hold = list(
		/obj/item/tool/surgery,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/nanopaste
	)

/obj/item/storage/internal/accessory/surg_vest/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/storage/surgical_tray))
		var/obj/item/storage/surgical_tray/ST = W
		if(!length(ST.contents))
			return
		if(length(contents) >= storage_slots)
			to_chat(user, SPAN_WARNING("The surgical webbing vest is already full."))
			return
		if(!do_after(user, 5 SECONDS * user.get_skill_duration_multiplier(SKILL_MEDICAL), INTERRUPT_ALL, BUSY_ICON_GENERIC))
			return
		for(var/obj/item/I in ST)
			if(length(contents) >= storage_slots)
				break
			ST.remove_from_storage(I)
			attempt_item_insertion(I, TRUE, user)
		user.visible_message("[user] transfers the tools from \the [ST] to the surgical webbing vest.", SPAN_NOTICE("You transfer the tools from \the [ST] to the surgical webbing vest."), max_distance = 3)
		return
	return ..()

/obj/item/storage/internal/accessory/surg_vest/equipped/fill_preset_inventory()
	new /obj/item/tool/surgery/scalpel/pict_system(src)
	new /obj/item/tool/surgery/scalpel(src)
	new /obj/item/tool/surgery/hemostat(src)
	new /obj/item/tool/surgery/retractor(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/tool/surgery/cautery(src)
	new /obj/item/tool/surgery/circular_saw(src)
	new /obj/item/tool/surgery/surgicaldrill(src)
	new /obj/item/tool/surgery/bonegel(src)
	new /obj/item/tool/surgery/bonesetter(src)
	new /obj/item/tool/surgery/FixOVein(src)
	new /obj/item/stack/nanopaste(src)
	new /obj/item/tool/surgery/surgical_line(src)

/obj/item/clothing/accessory/storage/surg_vest
	name = "surgical webbing vest"
	desc = "Greenish synthcotton vest purpose-made for holding surgical tools."
	icon_state = "vest_surg"
	hold = /obj/item/storage/internal/accessory/surg_vest

/obj/item/clothing/accessory/storage/surg_vest/equipped
	hold = /obj/item/storage/internal/accessory/surg_vest/equipped

/obj/item/clothing/accessory/storage/surg_vest/blue
	name = "blue surgical webbing vest"
	desc = "A matte blue synthcotton vest purpose-made for holding surgical tools."
	icon_state = "vest_blue"

/obj/item/clothing/accessory/storage/knifeharness
	name = "M272 pattern knife vest"
	desc = "An older generation M272 pattern knife vest once employed by the USCM. Can hold up to 5 knives. It is made of synthcotton."
	icon_state = "vest_knives"
	hold = /obj/item/storage/internal/accessory/knifeharness

/obj/item/storage/internal/accessory/knifeharness
	storage_slots = 5
	max_storage_space = 5
	can_hold = list(
		/obj/item/tool/kitchen/utensil/knife,
		/obj/item/tool/kitchen/utensil/pknife,
		/obj/item/tool/kitchen/knife,
		/obj/item/attachable/bayonet,
		/obj/item/weapon/melee/throwing_knife,
	)

/obj/item/clothing/accessory/storage/knifeharness/duelling
	name = "decorated harness"
	desc = "A heavily decorated harness of sinew and leather with two knife-loops."
	icon_state = "unathiharness2"
	hold = /obj/item/storage/internal/accessory/knifeharness/duelling

obj/item/storage/internal/accessory/knifeharness/duelling
	storage_slots = 2
	max_storage_space = 2
	can_hold = list(
		/obj/item/weapon/melee/unathiknife,
	)

/obj/item/storage/internal/accessory/knifeharness/duelling/fill_preset_inventory()
	new /obj/item/weapon/melee/unathiknife(src)
	new /obj/item/weapon/melee/unathiknife(src)

/obj/item/clothing/accessory/storage/droppouch
	name = "drop pouch"
	desc = "A convenient pouch to carry loose items around."
	icon_state = "drop_pouch"

	hold = /obj/item/storage/internal/accessory/drop_pouch

/obj/item/storage/internal/accessory/drop_pouch
	w_class = SIZE_LARGE	//Allow storage containers that's medium or below
	storage_slots = null
	max_w_class = SIZE_MEDIUM
	max_storage_space = 6	//weight system like backpacks, hold enough for 2 medium (normal) size items, or 3 small items, or 6 tiny items
	cant_hold = list(	//Prevent inventory powergame
		/obj/item/storage/firstaid,
		/obj/item/storage/bible,
		)
	storage_flags = NONE	//no verb, no quick draw, no tile gathering

/obj/item/clothing/accessory/storage/holster
	name = "shoulder holster"
	desc = "A handgun holster with an attached pouch, allowing two magazines or speedloaders to be stored along with it."
	icon_state = "holster"
	slot = ACCESSORY_SLOT_UTILITY
	high_visibility = TRUE
	hold = /obj/item/storage/internal/accessory/holster

/obj/item/storage/internal/accessory/holster
	w_class = SIZE_LARGE
	max_w_class = SIZE_MEDIUM
	var/obj/item/weapon/gun/current_gun
	var/sheatheSound = 'sound/weapons/gun_pistol_sheathe.ogg'
	var/drawSound = 'sound/weapons/gun_pistol_draw.ogg'
	storage_flags = STORAGE_ALLOW_QUICKDRAW|STORAGE_FLAGS_POUCH
	can_hold = list(

//Can hold variety of pistols and revolvers together with ammo for them. Can also hold the flare pistol and signal/illumination flares.
	/obj/item/weapon/gun/pistol,
	/obj/item/weapon/gun/energy/taser,
	/obj/item/weapon/gun/revolver,
	/obj/item/ammo_magazine/pistol,
	/obj/item/ammo_magazine/revolver,
	/obj/item/weapon/gun/flare,
	/obj/item/device/flashlight/flare

	 )

/obj/item/storage/internal/accessory/holster/on_stored_atom_del(atom/movable/AM)
	if(AM == current_gun)
		current_gun = null

/obj/item/clothing/accessory/storage/holster/attack_hand(mob/user, mods)
	var/obj/item/storage/internal/accessory/holster/H = hold
	if(H.current_gun && ishuman(user) && (loc == user || has_suit))
		if(mods && mods["alt"] && length(H.contents) > 1) //Withdraw the most recently inserted magazine, if possible.
			var/obj/item/I = H.contents[length(H.contents)]
			if(isgun(I))
				I = H.contents[length(H.contents) - 1]
			I.attack_hand(user)
		else
			H.current_gun.attack_hand(user)
		return

	..()

/obj/item/storage/internal/accessory/holster/can_be_inserted(obj/item/W, stop_messages)
	if( ..() ) //If the parent did their thing, this should be fine. It pretty much handles all the checks.
		if(isgun(W))
			if(current_gun)
				if(!stop_messages)
					to_chat(usr, SPAN_WARNING("[src] already holds \a [W]."))
				return
		else //Must be ammo.
			var/ammo_slots = storage_slots - 1 //We have a slot reserved for the gun
			var/ammo_stored = length(contents)
			if(current_gun)
				ammo_stored--
			if(ammo_stored >= ammo_slots)
				if(!stop_messages)
					to_chat(usr, SPAN_WARNING("[src] can't hold any more magazines."))
				return
		return 1

/obj/item/storage/internal/accessory/holster/_item_insertion(obj/item/W)
	if(isgun(W))
		current_gun = W //If there's no active gun, we want to make this our gun
		playsound(src, sheatheSound, 15, TRUE)
	. = ..()

/obj/item/storage/internal/accessory/holster/_item_removal(obj/item/W)
	if(isgun(W))
		current_gun = null
		playsound(src, drawSound, 15, TRUE)
	. = ..()

/obj/item/clothing/accessory/storage/holster/armpit
	name = "shoulder holster"
	desc = "A worn-out handgun holster. Perfect for concealed carry"
	icon_state = "holster"

/obj/item/clothing/accessory/storage/holster/waist
	name = "shoulder holster"
	desc = "A handgun holster. Made of expensive leather."
	icon_state = "holster"
	item_state = "holster_low"

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
	jumpsuit_hide_states = UNIFORM_JACKET_REMOVED

	var/stored_name = null

/obj/item/clothing/accessory/holobadge/cord
	icon_state = "holobadge-cord"
	flags_equip_slot = SLOT_FACE

/obj/item/clothing/accessory/holobadge/attack_self(mob/user)
	..()

	if(!stored_name)
		to_chat(user, "Waving around a badge before swiping an ID would be pretty pointless.")
		return
	if(isliving(user))
		user.visible_message(SPAN_DANGER("[user] displays their Wey-Yu Internal Security Legal Authorization Badge.\nIt reads: [stored_name], Wey-Yu Security."),SPAN_DANGER("You display your Wey-Yu Internal Security Legal Authorization Badge.\nIt reads: [stored_name], Wey-Yu Security."))

/obj/item/clothing/accessory/holobadge/attackby(var/obj/item/O, var/mob/user)
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
