/obj/item/organ
	name = "organ"
	desc = "It looks like it probably just plopped out."
	icon = 'icons/obj/items/organs.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/organs_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/organs_righthand.dmi',
	)
	icon_state = "appendix"

	/// Process() ticks before death.
	health = 100
	/// Squirts of blood left in it.
	var/fresh = 3
	/// Icon used when the organ dies.
	var/dead_icon
	/// Is the limb prosthetic?
	var/robotic
	/// What slot does it go in?
	var/organ_tag
	/// Used to spawn the relevant organ data when produced via a machine or spawn().
	var/organ_type = /datum/internal_organ
	/// Stores info when removed.
	var/datum/internal_organ/organ_data
	black_market_value = 25

/obj/item/organ/attack_self(mob/user)
	..()

	// Convert it to an edible form, yum yum.
	if(!robotic && user.a_intent == INTENT_HELP && user.zone_selected == "mouth")
		bitten(user)
		return

/obj/item/organ/Initialize(mapload, organ_datum)
	. = ..()
	create_reagents(5)
	if(organ_datum)
		organ_data = organ_datum
	else
		organ_data = new organ_type()
	if(!robotic)
		START_PROCESSING(SSobj, src)


/obj/item/organ/Destroy()
	QDEL_NULL(organ_data)
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/organ/process()

	if(robotic)
		STOP_PROCESSING(SSobj, src)
		return

	// Don't process if we're in a freezer, an MMI or a stasis bag. //TODO: ambient temperature?
	if(istype(loc,/obj/item/device/mmi) || istype(loc,/obj/item/bodybag/cryobag) || istype(loc,/obj/structure/closet/crate/freezer))
		return

	if(fresh && prob(40))
		fresh--
		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in reagents.reagent_list
		if(B)
			var/turf/TU = get_turf(src)
			TU.add_blood(B.color)
		//blood_splatter(src,B,1)

	health -= rand(0,1)
	if(health <= 0)
		die()

/obj/item/organ/proc/die()
	name = "dead [initial(name)]"
	if(dead_icon)
		icon_state = dead_icon
	health = 0
	STOP_PROCESSING(SSobj, src)
	//TODO: Grey out the icon state.
	//TODO: Inject an organ with peridaxon to make it alive again.


// Brain is defined in brain_item.dm.
/obj/item/organ/heart
	name = "heart"
	icon_state = "heart-on"
	item_state = "heart"
	organ_tag = "heart"
	fresh = 6 // Juicy.
	dead_icon = "heart-off"
	organ_type = /datum/internal_organ/heart
	black_market_value = 35

/obj/item/organ/lungs
	name = "lungs"
	icon_state = "lungs"
	item_state = "lungs"
	gender = PLURAL
	organ_tag = "lungs"
	organ_type = /datum/internal_organ/lungs

/obj/item/organ/kidneys
	name = "kidneys"
	icon_state = "kidneys"
	item_state = "kidney"
	gender = PLURAL
	organ_tag = "kidneys"
	organ_type = /datum/internal_organ/kidneys
	black_market_value = 35

/obj/item/organ/eyes
	name = "eyeballs"
	icon_state = "eyes"
	gender = PLURAL
	organ_tag = "eyes"
	organ_type = /datum/internal_organ/eyes
	var/eyes_color

/obj/item/organ/liver
	name = "liver"
	icon_state = "liver"
	item_state = "liver"
	organ_tag = "liver"
	organ_type = /datum/internal_organ/liver

/obj/item/organ/xeno
	name = "acidic heart"
	desc = "Acidic heart removed from a xenomorph. It spews droplets of acid every so often."
	icon_state = "heart_t1"
	item_state = "heart_t1"
	organ_tag = "heart"
	black_market_value = 60
	flags_item = NOBLUDGEON
	///value of the organ in the recycler, heavily varies from size and tier
	var/research_value = 1 //depending on the size and tier
	///the caste in a string, which is used in a xenoanalyzer
	var/caste_origin // used for desc in xenoanalyzer
	///xeno organ flags, used in xenobotany
	var/xeno_organ_flags = NONE
	///hivenumber of the organ heart
	var/hivenumber = XENO_HIVE_NORMAL

	var/constructing = FALSE

/obj/item/organ/xeno/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag)
		return

	var/mob/living/carbon/human/planter = user
	if(!istype(planter) || planter.skills.get_skill_level(SKILL_RESEARCH) < SKILL_RESEARCH_TRAINED)
		to_chat(user, SPAN_WARNING("You're unsure what to do with [src]."))
		return

	var/turf/plant_target = get_turf(target)
	if(plant_target.weeds)
		if(constructing)
			return
		constructing = TRUE
		handle_organ_planting(plant_target, user)
		constructing = FALSE
		return

	// Royal organs being used to make weeds is overkill
	// This prevents researchers from accidentally wasting a queen organ
	if(xeno_organ_flags & XENO_ORGAN_ROYAL)
		return

	if(!isturf(target) || plant_target.is_weedable == NOT_WEEDABLE || plant_target.density || user.action_busy)
		return

	if(!can_build_gland(target, user))
		return

	user.visible_message(SPAN_NOTICE("[user] starts planting [src]."), SPAN_NOTICE("You start planting [src]."))
	if(!do_after(user, 3 SECONDS, show_busy_icon = TRUE, target = target))
		return

	if(!can_build_gland(target, user))
		return

	playsound(plant_target, "alien_resin_build", 25)
	new /obj/effect/alien/weeds/node(plant_target, null, null, GLOB.hive_datum[hivenumber])
	qdel(src)

/obj/item/organ/xeno/proc/can_build_gland(turf/target, mob/user)
	if(target.is_weedable == NOT_WEEDABLE || target.density)
		to_chat(user, SPAN_WARNING("Bad spot for [src]."))
		return FALSE

	for(var/atom/object as anything in target.contents)
		if(istype(object, /obj/effect/alien/resin))
			to_chat(user, SPAN_WARNING("This space is already occupied."))
			return FALSE
		if(istype(object, /obj/effect/alien/egg))
			to_chat(user, SPAN_WARNING("This space is already occupied."))
			return FALSE

	if(!istype(target, /turf/open/floor/almayer/research/containment))
		to_chat(user, SPAN_WARNING("It would be unwise to plant this out here."))
		return FALSE

	return TRUE

/obj/item/organ/xeno/proc/handle_organ_planting(turf/target, mob/user)
	if(!can_build_gland(target, user))
		return

	var/list/buildables = list()
	var/strong_organ = (xeno_organ_flags & (XENO_ORGAN_STRONG))
	if(strong_organ)
		buildables += /obj/effect/alien/resin/chem_producer/advanced
	else
		buildables += /obj/effect/alien/resin/chem_producer/basic

	if(xeno_organ_flags & XENO_ORGAN_SUPPORT)
		buildables += /obj/effect/alien/resin/chem_producer/plasma
		if(strong_organ)
			buildables += /obj/effect/alien/resin/chem_producer/nutrient
	if(xeno_organ_flags & XENO_ORGAN_TACHYCARDIA)
		buildables += /obj/effect/alien/resin/chem_producer/catecholamine
		if(strong_organ)
			buildables += /obj/effect/alien/resin/chem_producer/adrenal
	if(xeno_organ_flags & XENO_ORGAN_HARDENED)
		buildables += /obj/effect/alien/resin/chem_producer/chitin
		if(strong_organ)
			buildables += /obj/effect/alien/resin/chem_producer/reinforced_chitin
	if(xeno_organ_flags & XENO_ORGAN_ACID)
		buildables += /obj/effect/alien/resin/chem_producer/neurotoxin
		if(strong_organ)
			buildables += /obj/effect/alien/resin/chem_producer/acid


	// To prevent misusing a queen organ
	if(xeno_organ_flags & XENO_ORGAN_ROYAL)
		buildables = list(/obj/effect/alien/resin/chem_producer/royal)

	var/to_construct
	var/client/user_client = user.client
	if(!user_client)
		return

	if(user_client.prefs && user_client.prefs.no_radials_preference)
		var/list/buildables_list = list()
		for(var/obj/effect/alien/resin/chem_producer/producer as anything in buildables)
			buildables_list[initial(producer.name)] = producer
		to_construct = tgui_input_list(user, "Construct a gland", "Construct", buildables_list)
	else
		var/list/buildables_list = list()
		var/list/buildables_map = list()
		for(var/obj/effect/alien/resin/chem_producer/producer as anything in buildables)
			var/icon = initial(producer.icon)
			var/icon_state = initial(producer.icon_state)
			buildables_list[initial(producer.name)] = mutable_appearance(icon, icon_state)
			buildables_map[initial(producer.name)] = producer
		to_construct = show_radial_menu(user, user_client.get_eye(), buildables_list)
		if(to_construct)
			to_construct = buildables_map[to_construct]

	if(!to_construct)
		return
	if(!user.is_holding(src) || user.action_busy)
		return

	user.visible_message(SPAN_NOTICE("[user] starts planting [src]"), SPAN_NOTICE("You start planting [src]"))
	if(!do_after(user, 3 SECONDS, show_busy_icon = TRUE, target = target))
		return

	if(!can_build_gland(target, user))
		return
	playsound(target, "alien_resin_build", 25)
	var/obj/effect/alien/resin/chem_producer/producer = new to_construct(target)
	if(xeno_organ_flags & XENO_ORGAN_FRESH)
		producer.name = "enhanced [producer.name]"
		producer.production_amt *= 2
	qdel(src)

//These are here so they can be printed out via the fabricator.
/obj/item/organ/heart/prosthetic
	name = "circulatory pump"
	icon_state = "heart-prosthetic"
	robotic = ORGAN_ROBOT
	organ_type = /datum/internal_organ/heart/prosthetic
	black_market_value = 0

/obj/item/organ/lungs/prosthetic
	robotic = ORGAN_ROBOT
	name = "gas exchange system"
	icon_state = "lungs-prosthetic"
	organ_type = /datum/internal_organ/lungs/prosthetic
	black_market_value = 0

/obj/item/organ/kidneys/prosthetic
	robotic = ORGAN_ROBOT
	name = "prosthetic kidneys"
	icon_state = "kidneys-prosthetic"
	organ_type = /datum/internal_organ/kidneys/prosthetic
	black_market_value = 0

/obj/item/organ/eyes/prosthetic
	robotic = ORGAN_ROBOT
	name = "visual prosthesis"
	icon_state = "eyes-prosthetic"
	organ_type = /datum/internal_organ/eyes/prosthetic
	black_market_value = 0

/obj/item/organ/liver/prosthetic
	robotic = ORGAN_ROBOT
	name = "toxin filter"
	icon_state = "liver-prosthetic"
	organ_type = /datum/internal_organ/liver/prosthetic
	black_market_value = 0

/obj/item/organ/brain/prosthetic
	robotic = ORGAN_ROBOT
	name = "cyberbrain"
	icon_state = "brain-prosthetic"
	organ_type = /datum/internal_organ/brain/prosthetic


/obj/item/organ/proc/removed(mob/living/target, mob/living/user, cause = "organ harvesting")

	if(!target || !user)
		return

	if(organ_data.vital)
		user.attack_log += "\[[time_stamp()]\]<font color='red'> removed a vital organ ([src]) from [target.name] ([target.ckey]) (INTENT: [uppertext(intent_text(user.a_intent))])</font>"
		target.attack_log += "\[[time_stamp()]\]<font color='orange'> had a vital organ ([src]) removed by [user.name] ([user.ckey]) (INTENT: [uppertext(intent_text(user.a_intent))])</font>"
		msg_admin_attack("[user.name] ([user.ckey]) removed a vital organ ([src]) from [target.name] ([target.ckey]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
		target.death(cause)

/obj/item/organ/eyes/removed(mob/living/target, mob/living/user)

	if(!eyes_color)
		eyes_color = list(0,0,0)

	..() //Make sure target is set so we can steal their eye color for later.
	var/mob/living/carbon/human/H = target
	if(istype(H))
		eyes_color = list(
			H.r_eyes ? H.r_eyes : 0,
			H.g_eyes ? H.g_eyes : 0,
			H.b_eyes ? H.b_eyes : 0
			)

		// Leave bloody red pits behind!
		H.r_eyes = 128
		H.g_eyes = 0
		H.b_eyes = 0
		H.update_body()

/obj/item/organ/proc/replaced(mob/living/target)
	return

/obj/item/organ/eyes/replaced(mob/living/target)

	// Apply our eye color to the target.
	var/mob/living/carbon/human/H = target
	if(istype(H) && eyes_color)
		H.r_eyes = eyes_color[1]
		H.g_eyes = eyes_color[2]
		H.b_eyes = eyes_color[3]
		H.update_body()

/obj/item/organ/proc/bitten(mob/user)

	if(robotic)
		return

	to_chat(user, SPAN_NOTICE("You take an experimental bite out of \the [src]."))
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in reagents.reagent_list
	if(B)
		var/turf/TU = get_turf(src)
		TU.add_blood(B.color)


	user.temp_drop_inv_item(src)
	var/obj/item/reagent_container/food/snacks/organ/O = new(get_turf(src))
	O.name = name
	O.icon_state = dead_icon ? dead_icon : icon_state

	// Pass over the blood.
	reagents.trans_to(O, reagents.total_volume)

	if(fingerprintshidden)
		O.fingerprintshidden = fingerprintshidden.Copy()
	if(fingerprintslast)
		O.fingerprintslast = fingerprintslast

	user.put_in_active_hand(O)
	qdel(src)
