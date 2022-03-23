#define DEBUG_INT_AMOUNT	TRUE
#define DEBUG_WOUNDS TRUE

//****************************************************
//				EXTERNAL ORGANS
//****************************************************/
/obj/limb
	name = "limb"
	appearance_flags = KEEP_TOGETHER | TILE_BOUND
	vis_flags = VIS_INHERIT_ID | VIS_INHERIT_DIR
	var/icon_name = null
	var/body_part = null
	var/icon_position = 0
	var/damage_state = "=="
	var/brute_dam = 0
	var/brute_multiplier = 1
	var/burn_dam = 0
	var/burn_multiplier = 1
	var/max_damage = 0
	var/max_size = 0
	var/last_dam = -1
	var/display_name

	var/list/datum/autopsy_data/autopsy_data = list()
	var/list/trace_chemicals = list() // traces of chemicals in the organ,
									  // links chemical IDs to number of ticks for which they'll stay in the blood

	var/obj/limb/parent
	var/list/obj/limb/children

	// Internal organs of this body part
	var/list/datum/internal_organ/internal_organs

	var/damage_msg = "<span class='danger'>You feel an intense pain</span>"

	//Surgical vars
	///Name of bones encasing the limb.
	var/encased
	///Name of internal cavity.
	var/cavity
	///Surgically implanted item.
	var/obj/item/hidden = null
	///Embedded or implanter implanted items.
	var/list/implants = list()
	var/artery_name = "artery"

	var/mob/living/carbon/human/owner = null
	var/vital //Lose a vital limb, die immediately.

	var/has_stump_icon = FALSE
	var/image/wound_overlay //Used to save time redefining it every wound update. Doesn't remember anything but the most recently used icon state.
	var/image/burn_overlay //Ditto but for burns.

	// Integrity mechanic vars
	var/list/bleeding_effects_list = list()
	var/integrity_level = 0

	var/brute_autoheal = 0.02 //per life tick
	var/burn_autoheal = 0.04
	var/integrity_autoheal = 0.1
	var/can_autoheal = TRUE
	var/integrity_damage = 0
	var/last_dam_time = 0

	var/limb_int_multiplier = 1 // less = better

	var/status = LIMB_ORGANIC
	var/list/limb_wounds = list()

	var/list/limb_inherent_traits = list()

	var/body_side


/obj/limb/Initialize(mapload, obj/limb/P, mob/mob_owner)
	. = ..()
	if(P)
		parent = P
		if(!parent.children)
			parent.children = list()
		parent.children.Add(src)
	if(mob_owner)
		owner = mob_owner

	for(var/trait in limb_inherent_traits)
		ADD_TRAIT(src, trait, TRAIT_SOURCE_LIMB)

	wound_overlay = image('icons/mob/humans/dam_human.dmi', "grayscale_0")
	wound_overlay.blend_mode = BLEND_INSET_OVERLAY
	wound_overlay.color = owner.species.blood_color

	burn_overlay = image('icons/mob/humans/dam_human.dmi', "burn_0")
	burn_overlay.blend_mode = BLEND_INSET_OVERLAY

	forceMove(mob_owner)

/*
/obj/limb/proc/get_icon(var/icon/race_icon, var/icon/deform_icon)
	return icon('icons/mob/human.dmi',"blank")
*/

/obj/limb/process()
		return 0

/obj/limb/Destroy()
	if(parent)
		parent.children -= src
	parent = null
	if(children)
		for(var/obj/limb/L in children)
			L.parent = null
		children = null

	if(hidden)
		qdel(hidden)
		hidden = null

	if(internal_organs)
		for(var/datum/internal_organ/IO in internal_organs)
			IO.owner = null
			qdel(IO)
		internal_organs = null

	if(implants)
		for(var/I in implants)
			qdel(I)
		implants = null

	if(bleeding_effects_list)
		for(var/datum/effects/bleeding/B in bleeding_effects_list)
			qdel(B)
		bleeding_effects_list = null

	if(owner && owner.limbs)
		owner.limbs -= src
		owner.limbs_to_process -= src
		owner.update_body()
	owner = null

	return ..()

//Autopsy stuff

//Handles chem traces
/mob/living/carbon/human/proc/handle_trace_chems()
	//New are added for reagents to random organs.
	for(var/datum/reagent/A in reagents.reagent_list)
		var/obj/limb/O = pick(limbs)
		O.trace_chemicals[A.name] = 100

//Adds autopsy data for used_weapon.
/obj/limb/proc/add_autopsy_data(var/used_weapon, var/damage)
	var/datum/autopsy_data/W = autopsy_data[used_weapon]
	if(!W)
		W = new()
		W.weapon = used_weapon
		autopsy_data[used_weapon] = W

	W.hits += 1
	W.damage += damage
	W.time_inflicted = world.time



/*
			DAMAGE PROCS
*/

/obj/limb/emp_act(severity)
	if(!(status & LIMB_ROBOT))	//meatbags do not care about EMP
		return
	var/probability = 30
	var/damage = 15
	if(severity == 2)
		probability = 1
		damage = 3
	if(prob(probability))
		droplimb(0, 0, "EMP")
	else
		take_damage(damage, 0, 1, 1, used_weapon = "EMP")

/*
	Describes how limbs (body parts) of human mobs get damage applied.
*/
/obj/limb/proc/take_damage(brute, burn, int_dmg_multiplier = 1, used_weapon = null, list/forbidden_limbs = list(), no_limb_loss, var/damage_source = "dismemberment", var/mob/attack_source = null)
	if((brute <= 0) && (burn <= 0))
		return 0

	if(status & LIMB_DESTROYED)
		return 0

	brute *= brute_multiplier
	burn *= burn_multiplier

	var/is_ff = FALSE //<- doesn't seem to do anything ATM. Should FF cause int damage, is this necessary? -Vanagandr
	if(istype(attack_source) && attack_source.faction == owner.faction)
		is_ff = TRUE

	if(used_weapon)
		add_autopsy_data("[used_weapon]", brute + burn)


	// If the limbs can break, make sure we don't exceed the maximum damage a limb can take before breaking
	if((brute_dam + burn_dam + brute + burn) <= max_damage || !CONFIG_GET(flag/limbs_can_break))
		if(brute)
			brute_dam += brute
		if(burn)
			burn_dam += burn

		if(owner.stat != DEAD)
			#if DEBUG_INT_AMOUNT
			var/skill_level = owner.skills ? owner.skills.get_skill_level(SKILL_ENDURANCE) : 0
			var/skill_armour = owner.skills ? owner.skills.get_skill_level(SKILL_ENDURANCE) * 5 : 25
			var/int_armour = owner.getarmor(name, ARMOR_INTERNALDAMAGE)
			var/final_int_dmg = brute * ((100 - max(owner.skills ? owner.skills.get_skill_level(SKILL_ENDURANCE) * 5 : 25, owner.getarmor(name, ARMOR_INTERNALDAMAGE))) * 0.01)\
				* int_dmg_multiplier * owner.int_dmg_malus * limb_int_multiplier
			message_staff("Taking internal damage to [display_name]. Brute: [brute]. Skill level: [skill_level], skill defence: [skill_armour]. Armour: [int_armour].")
			message_staff("[skill_armour > int_armour ? "Skills provide more protection than armour, using skill defence." : "Armour provides more protection than skills, using armour defence."]")
			message_staff("Attack integrity multiplier: [int_dmg_multiplier]x. Target int malus: [owner.int_dmg_malus]x. Limb int multiplier: [limb_int_multiplier]x.\nFinal int damage: [final_int_dmg] points.")
			#endif
			take_integrity_damage(brute *\
				((100 - max(owner.skills ? owner.skills.get_skill_level(SKILL_ENDURANCE) * 5 : 25, owner.getarmor(name, ARMOR_INTERNALDAMAGE))) * 0.01)\
				* int_dmg_multiplier * owner.int_dmg_malus * limb_int_multiplier)

	else
		//If we can't inflict the full amount of damage, spread the damage in other ways
		//How much damage can we actually cause?
		var/can_inflict = max_damage * CONFIG_GET(number/organ_health_multiplier) - (brute_dam + burn_dam)
		var/remain_brute = brute
		var/remain_burn = burn
		if(can_inflict)
			if(brute > 0)
				var/inflict_brute = min(brute, can_inflict)
				//Inflict all brute damage we can
				brute_dam += inflict_brute
				var/temp = can_inflict
				//How much more damage can we inflict
				can_inflict = max(0, can_inflict - brute)
				//How much brute damage is left to inflict
				remain_brute = max(0, brute - temp)

				if(owner.stat != DEAD)
					#if DEBUG_INT_AMOUNT
					var/skill_level = owner.skills ? owner.skills.get_skill_level(SKILL_ENDURANCE) : 0
					var/skill_armour = owner.skills ? owner.skills.get_skill_level(SKILL_ENDURANCE) * 5 : 25
					var/int_armour = owner.getarmor(name, ARMOR_INTERNALDAMAGE)
					var/final_int_dmg = inflict_brute * ((100 - max(owner.skills ? owner.skills.get_skill_level(SKILL_ENDURANCE) * 5 : 25, owner.getarmor(name, ARMOR_INTERNALDAMAGE))) * 0.01)\
						* int_dmg_multiplier * owner.int_dmg_malus * limb_int_multiplier
					message_staff("Taking internal damage to [display_name]. Brute: [inflict_brute]. Skill level: [skill_level], skill defence: [skill_armour]. Armour: [int_armour].")
					message_staff("[skill_armour > int_armour ? "Skills provide more protection than armour, using skill defence." : "Armour provides more protection than skills, using armour defence."]")
					message_staff("Attack integrity multiplier: [int_dmg_multiplier]x. Target int malus: [owner.int_dmg_malus]x. Limb int multiplier: [limb_int_multiplier]x.\nFinal int damage: [final_int_dmg] points.")
					#endif
					take_integrity_damage(inflict_brute *\
						((100 - max(owner.skills ? owner.skills.get_skill_level(SKILL_ENDURANCE) * 5 : 25, owner.getarmor(name, ARMOR_INTERNALDAMAGE))) * 0.01)\
						* int_dmg_multiplier * owner.int_dmg_malus * limb_int_multiplier)

			if(burn > 0 && can_inflict)
				//Inflict all burn damage we can
				burn_dam += min(burn,can_inflict)
				//How much burn damage is left to inflict
				remain_burn = max(0, burn - can_inflict)

		//If there are still hurties to dispense
		if(remain_burn || remain_brute)
			//List organs we can pass it to
			var/list/obj/limb/possible_points = list()
			if(parent)
				possible_points += parent
			if(children)
				possible_points += children
			if(forbidden_limbs.len)
				possible_points -= forbidden_limbs
			if(possible_points.len)
				//And pass the damage around, but not the chance to cut the limb off.
				var/obj/limb/target = pick(possible_points)
				target.take_damage(remain_brute, remain_burn, int_dmg_multiplier , used_weapon, forbidden_limbs + src, TRUE, attack_source = attack_source)

	SEND_SIGNAL(src, COMSIG_LIMB_TAKEN_DAMAGE, is_ff)


	/*
	//If limb was damaged before and took enough damage, try to cut or tear it off
	var/no_perma_damage = owner.status_flags & NO_PERMANENT_DAMAGE
	if(old_brute_dam > 0 && !is_ff && body_part != BODY_FLAG_CHEST && !no_limb_loss && !no_perma_damage)
		droplimb(0, 0, damage_source)
		return
	*/

	last_dam_time = world.time
	owner.updatehealth()
	update_icon()
	start_processing()

/obj/limb/proc/take_integrity_damage(amount)
	integrity_damage = clamp(integrity_damage + amount, 0, MAX_LIMB_INTEGRITY)
	recalculate_integrity_level()

///Recalcs wounds and int level.
/obj/limb/proc/recalculate_integrity()
	recalculate_health_effects()
	recalculate_integrity_level()
	start_processing()

/obj/limb/proc/recalculate_integrity_level()
	var/old_level = integrity_level
	switch(integrity_damage)
		if(LIMB_INTEGRITY_THRESHOLD_NONE to INFINITY)
			integrity_level = LIMB_INTEGRITY_NONE
		if(LIMB_INTEGRITY_THRESHOLD_CRITICAL to LIMB_INTEGRITY_THRESHOLD_NONE)
			integrity_level = LIMB_INTEGRITY_CRITICAL
		if(LIMB_INTEGRITY_THRESHOLD_SERIOUS to LIMB_INTEGRITY_THRESHOLD_CRITICAL)
			integrity_level = LIMB_INTEGRITY_SERIOUS
		if(LIMB_INTEGRITY_THRESHOLD_CONCERNING to LIMB_INTEGRITY_THRESHOLD_SERIOUS)
			integrity_level = LIMB_INTEGRITY_CONCERNING
		if(LIMB_INTEGRITY_THRESHOLD_OKAY to LIMB_INTEGRITY_THRESHOLD_CONCERNING)
			integrity_level = LIMB_INTEGRITY_OKAY
		if(LIMB_INTEGRITY_THRESHOLD_PERFECT to LIMB_INTEGRITY_THRESHOLD_OKAY)
			integrity_level = LIMB_INTEGRITY_PERFECT

	if(integrity_level == old_level)
		return
	if(integrity_level > old_level)
		on_integrity_tier_increased(old_level)
	else
		on_integrity_tier_lowered(old_level)

	SEND_SIGNAL(src, COMSIG_LIMB_INTEGRITY_CHANGED, old_level, integrity_level)

//Set damage to the desired level's threshold, so when the effects are recalculated
//the level is set
/obj/limb/proc/set_integrity_level(new_level)
	switch(new_level)
		if(LIMB_INTEGRITY_OKAY)
			integrity_damage = LIMB_INTEGRITY_THRESHOLD_OKAY
		if(LIMB_INTEGRITY_CONCERNING)
			integrity_damage = LIMB_INTEGRITY_THRESHOLD_CONCERNING
		if(LIMB_INTEGRITY_SERIOUS)
			integrity_damage = LIMB_INTEGRITY_THRESHOLD_SERIOUS
		if(LIMB_INTEGRITY_CRITICAL)
			integrity_damage = LIMB_INTEGRITY_THRESHOLD_CRITICAL
		if(LIMB_INTEGRITY_NONE)
			integrity_damage = LIMB_INTEGRITY_THRESHOLD_NONE
		else
			integrity_damage = LIMB_INTEGRITY_THRESHOLD_PERFECT
	recalculate_integrity()

//This proc handles what happens when integrity increase, including when limb wounds are added
/obj/limb/proc/on_integrity_tier_increased(old_level)
	switch(integrity_level)
		if(LIMB_INTEGRITY_OKAY)
			playsound(owner, 'sound/effects/bone_break2.ogg', 45, 1)
			to_chat(owner, SPAN_WARNING("Your [display_name] starts to ache, but it's nothing to worry about."))
		if(LIMB_INTEGRITY_CONCERNING)
			playsound(owner, 'sound/effects/bone_break4.ogg', 45, 1)
			to_chat(owner, SPAN_DANGER("Your [display_name] hurts badly from the wounds; but you can definitely continue fighting."))
		if(LIMB_INTEGRITY_SERIOUS)
			playsound(owner, 'sound/effects/bone_break6.ogg', 45, 1)
			to_chat(owner, SPAN_DANGER("Your [display_name] is in pain; all you can see is blood, cuts and rips littered all over it. The only thing stopping you is your resolve and hubris."))
		if(LIMB_INTEGRITY_CRITICAL)
			playsound(owner, 'sound/effects/bone_break1.ogg', 45, 1)
			to_chat(owner, SPAN_HIGHDANGER("Your [display_name] feels like hell, only hanging on by threads of flesh and sinew. You sure you want to continue fighting?"))
		if(LIMB_INTEGRITY_NONE)
			playsound(owner, 'sound/effects/limb_gore.ogg', 45, 1)
			to_chat(owner, SPAN_HIGHDANGER("You can't feel your [display_name]. It's gone, and all that's left is blood and gore."))

	#if DEBUG_WOUNDS
	message_staff("Integrity tier increase, old level = [old_level], new level = [integrity_level]")
	#endif

	if(!owner.species)
		return

	//Species-specific limb wounds

	var/list/wounds_by_level = owner.species.wounds_by_limb[name]
	var/list/wounds_to_pick
	var/list/wounds_by_id = list()
	var/picked_wound_id

	for(var/datum/limb_wound/W as anything in limb_wounds)
		wounds_by_id += W.id //Grab all ids

	for(var/I in old_level + 1 to integrity_level)

		#if DEBUG_WOUNDS
		message_staff("Adding Integrity Level [I] wounds\nPre-existing wound ids: [english_list(wounds_by_id)]")
		#endif

		wounds_to_pick = wounds_by_level[I] //A list of wound id -> wound type

		for(var/id in wounds_by_id) //Upgrade all already present wounds (if there's an upgrade avaiable)
			#if DEBUG_WOUNDS
			message_staff("Wound id \"[id]\": Upgrading [wounds_by_id[id]] -> [wounds_to_pick[id]]")
			#endif
			if(wounds_to_pick[id])
				wounds_by_id[id] = wounds_to_pick[id]

		wounds_to_pick -= wounds_by_id //Remove all wound ids already added to the list
		if(length(wounds_to_pick))
			picked_wound_id = pick(wounds_to_pick)
			wounds_by_id[picked_wound_id] = wounds_to_pick[picked_wound_id] //Add a new wound id
		#if DEBUG_WOUNDS
			message_staff("Adding new wound of id \"[picked_wound_id]\": [wounds_by_id[picked_wound_id]]")
		else
			message_staff("No additional wounds left to add")
		#endif

	for(var/id in wounds_by_id)
		add_limb_wound(wounds_by_id[id])

/obj/limb/proc/on_integrity_tier_lowered(old_level)

/obj/limb/proc/add_limb_wound(wound_type, silent)
	var/datum/limb_wound/added = new wound_type(owner, src, silent)
	for(var/datum/limb_wound/W as anything in limb_wounds)
		if(W.type == wound_type)
			qdel(added)
			break
		if(W.id == added.id)
			if(W.tier > added.tier)
				qdel(added)
			else
				qdel(W)
			break


///Resets autoheal amounts.
/obj/limb/proc/recalculate_health_effects()
	if(can_autoheal)
		brute_autoheal = initial(brute_autoheal)
		burn_autoheal = initial(burn_autoheal)
		integrity_autoheal = initial(integrity_autoheal)
	else
		brute_autoheal = 0
		burn_autoheal = 0
		integrity_autoheal = 0

/obj/limb/proc/heal_damage(brute, burn, internal = 0, robo_repair = 0)
	if(status & LIMB_ROBOT && !robo_repair)
		return

	if(brute)
		remove_all_bleeding(TRUE)

	if(internal)
		remove_all_bleeding(FALSE, TRUE)

	brute_dam = max(0, brute_dam - brute)
	burn_dam = max(0, burn_dam - burn)

	owner.pain.apply_pain(-brute)
	owner.pain.apply_pain(-burn)

	owner.updatehealth()

	update_icon()

/*
This function completely restores a damaged organ to perfect condition.
*/
/obj/limb/proc/rejuvenate()
	damage_state = "=="
	if(status & LIMB_ROBOT)	//Robotic organs stay robotic.  Fix because right click rejuvinate makes IPC's organs organic.
		status = LIMB_ROBOT
	else
		status = LIMB_ORGANIC
	brute_dam = 0
	burn_dam = 0

	// reset surgeries. Some duplication with general mob rejuvenate() but this also allows individual limbs to be rejuvenated, in theory.
	reset_limb_surgeries()

	// remove suture datum.
	SEND_SIGNAL(src, COMSIG_LIMB_REMOVE_SUTURES)

	// heal internal organs
	for(var/datum/internal_organ/current_organ in internal_organs)
		current_organ.rejuvenate()

	// remove embedded objects and drop them on the floor
	for(var/obj/implanted_object in implants)
		if(!istype(implanted_object, /obj/item/implant))	// We don't want to remove REAL implants. Just shrapnel etc.
			implanted_object.forceMove(owner.loc)
			implants -= implanted_object
			owner.embedded_items -= implanted_object //Remove it from embedded, if it's in that list.

	remove_all_bleeding(TRUE, TRUE)
	owner.pain.recalculate_pain()
	owner.updatehealth()
	owner.update_body()
	update_icon()

/obj/limb/proc/add_bleeding(var/W, var/internal = FALSE)
	if(!(SSticker.current_state >= GAME_STATE_PLAYING)) //If the game hasnt started, don't add bleed. Hacky fix to avoid having 100 bleed effect from roundstart.
		return

	if(status & LIMB_ROBOT)
		return

	if(length(bleeding_effects_list))
		if(!internal)
			for(var/datum/effects/bleeding/external/B in bleeding_effects_list)
				B.add_on(W)
				return
		else
			for(var/datum/effects/bleeding/internal/B in bleeding_effects_list)
				B.add_on(30)
				return

	var/datum/effects/bleeding/bleeding_status

	if(internal)
		bleeding_status = new /datum/effects/bleeding/internal(owner, src, (max(40, brute_dam)+ (0.15 * integrity_damage)))
	else
		bleeding_status = new /datum/effects/bleeding/external(owner, src, W)

	bleeding_effects_list += bleeding_status

/obj/limb/proc/remove_all_bleeding(var/external = FALSE, var/internal = FALSE)
	if(external)
		for(var/datum/effects/bleeding/external/B in bleeding_effects_list)
			qdel(B)
		for(var/datum/effects/bleeding/arterial/A in bleeding_effects_list)
			qdel(A)

	if(internal)
		for(var/datum/effects/bleeding/internal/I in bleeding_effects_list)
			qdel(I)

/* TODO: revisit this proc when fiddling with bleeding -Vanagandr.
///Checks if there's any external limb wounds, removes bleeding if there isn't.
/obj/limb/proc/remove_wound_bleeding()
	/*
	for(var/datum/wound/W as anything in wounds)
		if(!W.internal)
			return
	remove_all_bleeding(TRUE)
	*/

*/

/*
			PROCESSING & UPDATING
*/

//Determines if we even need to process this organ.

/obj/limb/proc/need_process()
	if(status & LIMB_DESTROYED)	//Missing limb is missing
		return FALSE
	if(brute_dam || burn_dam)
		return TRUE
	else if(integrity_damage && integrity_damage < LIMB_INTEGRITY_AUTOHEAL_THRESHOLD) //No brute/burn, but what about int?
		return TRUE
	return FALSE

/obj/limb/process()
	if(!brute_dam && !burn_dam && !integrity_damage)
		return
	if(world.time - last_dam_time < MINIMUM_AUTOHEAL_DAMAGE_INTERVAL)
		return
	/*if(healing_naturally)
		if(!can_autoheal)
			stop_processing()
			return
		if((brute_dam + burn_dam) > MINIMUM_AUTOHEAL_HEALTH || owner.stat == DEAD)
			return*/
	//Integrity autoheal
	if(integrity_autoheal && integrity_damage < LIMB_INTEGRITY_AUTOHEAL_THRESHOLD)
		take_integrity_damage(-integrity_autoheal)
	if(brute_autoheal || burn_autoheal)
		heal_damage(brute_autoheal, burn_autoheal, TRUE, TRUE)

	//Chem traces slowly vanish
	if(owner.life_tick % 10 == 0)
		for(var/chemID in trace_chemicals)
			trace_chemicals[chemID] = trace_chemicals[chemID] - 1
			if(trace_chemicals[chemID] <= 0)
				trace_chemicals.Remove(chemID)

/obj/limb/update_icon(forced = FALSE)
	if(parent && parent.status & LIMB_DESTROYED)
		icon_state = ""
		return

	if(status & LIMB_DESTROYED)
		if(has_stump_icon && !(status & LIMB_AMPUTATED))
			icon = 'icons/mob/humans/dam_human.dmi'
			if(owner.species?.flags & IS_SYNTHETIC)
				icon_state = "synth_stump_[icon_name]"
			else
				icon_state = "stump_[icon_name]"
		else
			icon_state = ""
		return

	var/race_icon = owner.species.icobase

	if (status & LIMB_ROBOT && !(owner.species && owner.species.flags & IS_SYNTHETIC))
		icon = 'icons/mob/robotic.dmi'
		icon_state = "[icon_name]"
		return

	var/datum/ethnicity/E = GLOB.ethnicities_list[owner.ethnicity]
	var/datum/body_type/B = GLOB.body_types_list[owner.body_type]

	var/e_icon
	var/b_icon

	if (!E)
		e_icon = "western"
	else
		e_icon = E.icon_name

	if (!B)
		b_icon = "mesomorphic"
	else
		b_icon = B.icon_name

	icon = race_icon
	icon_state = "[get_limb_icon_name(owner.species, b_icon, owner.gender, icon_name, e_icon)]"
	wound_overlay.color = owner.species.blood_color

	var/n_is = damage_state_text()
	if (forced || n_is != damage_state)
		overlays.Cut()
		damage_state = n_is
		update_overlays()


/obj/limb/proc/update_overlays()
	var/brutestate = copytext(damage_state, 1, 2)
	var/burnstate = copytext(damage_state, 2)
	if(brutestate != "0")
		wound_overlay.icon_state = "grayscale_[brutestate]"
		overlays += wound_overlay

	if(burnstate != "0")
		burn_overlay.icon_state = "burn_[burnstate]"
		overlays += burn_overlay

// new damage icon system
// returns just the brute/burn damage code
/obj/limb/proc/damage_state_text()
	if(status & LIMB_DESTROYED)
		return "--"

	var/tburn = 0
	var/tbrute = 0

	if(burn_dam == 0)
		tburn = 0
	else if (burn_dam < (max_damage * 0.1667)) //0.25 / 1.5
		tburn = 1
	else if (burn_dam < (max_damage * 0.5)) //0.75 / 1.5
		tburn = 2
	else
		tburn = 3

	if (brute_dam == 0)
		tbrute = 0
	else if (brute_dam < (max_damage * 0.1667))
		tbrute = 1
	else if (brute_dam < (max_damage * 0.5))
		tbrute = 2
	else
		tbrute = 3
	return "[tbrute][tburn]"

/*
			DISMEMBERMENT
*/

//Recursive setting of self and all child organs to amputated
/obj/limb/proc/setAmputatedTree()
	status |= LIMB_AMPUTATED
	update_icon()
	for(var/obj/limb/O as anything in children)
		O.setAmputatedTree()

/mob/living/carbon/human/proc/remove_random_limb(var/delete_limb = 0)
	var/list/limbs_to_remove = list()
	for(var/obj/limb/E in limbs)
		if(istype(E, /obj/limb/chest) || istype(E, /obj/limb/groin) || istype(E, /obj/limb/head))
			continue
		limbs_to_remove += E
	if(limbs_to_remove.len)
		var/obj/limb/L = pick(limbs_to_remove)
		var/limb_name = L.display_name
		L.droplimb(0, delete_limb)
		return limb_name
	return null

/obj/limb/proc/start_processing()
	if(!(src in owner.limbs_to_process))
		owner.limbs_to_process += src

/obj/limb/proc/stop_processing()
	owner.limbs_to_process -= src

//Handles dismemberment
/obj/limb/proc/droplimb(amputation, var/delete_limb = 0, var/cause, surgery_in_progress)
	if(!owner)
		return
	if(status & LIMB_DESTROYED)
		return
	else
		if(body_part == BODY_FLAG_CHEST)
			return
		stop_processing()
		if(status & LIMB_ROBOT)
			status = LIMB_DESTROYED|LIMB_ROBOT
		else
			status = LIMB_DESTROYED|LIMB_ORGANIC
			owner.pain.apply_pain(PAIN_BONE_BREAK)
		if(amputation)
			status |= LIMB_AMPUTATED
		for(var/i in implants)
			implants -= i
			owner.embedded_items -= i //Remove it from embedded, if it's in that list.
			qdel(i)

		remove_all_bleeding(TRUE, TRUE)

		if(hidden)
			hidden.forceMove(owner.loc)
			hidden = null

		// If any organs are attached to this, destroy them
		for(var/obj/limb/O in children)
			O.droplimb(amputation, delete_limb, cause)

		//we reset the surgery related variables unless this was done as part of a surgery.
		if(!surgery_in_progress)
			reset_limb_surgeries()

		var/obj/organ	//Dropped limb object
		switch(body_part)
			if(BODY_FLAG_HEAD)
				if(owner.species.flags & IS_SYNTHETIC) //special head for synth to allow brainmob to talk without an MMI
					organ= new /obj/item/limb/head/synth(owner.loc, owner)
				else
					organ= new /obj/item/limb/head(owner.loc, owner)
				owner.drop_inv_item_on_ground(owner.glasses, null, TRUE)
				owner.drop_inv_item_on_ground(owner.head, null, TRUE)
				owner.drop_inv_item_on_ground(owner.wear_l_ear, null, TRUE)
				owner.drop_inv_item_on_ground(owner.wear_r_ear, null, TRUE)
				owner.drop_inv_item_on_ground(owner.wear_mask, null, TRUE)
				owner.update_hair()
			if(BODY_FLAG_ARM_RIGHT)
				if(status & LIMB_ROBOT)
					organ = new /obj/item/robot_parts/r_arm(owner.loc)
				else
					organ = new /obj/item/limb/arm/r_arm(owner.loc, owner)
				if(owner.w_uniform && !amputation)
					var/obj/item/clothing/under/U = owner.w_uniform
					U.removed_parts |= body_part
					owner.update_inv_w_uniform()
			if(BODY_FLAG_ARM_LEFT)
				if(status & LIMB_ROBOT)
					organ = new /obj/item/robot_parts/l_arm(owner.loc)
				else
					organ = new /obj/item/limb/arm/l_arm(owner.loc, owner)
				if(owner.w_uniform && !amputation)
					var/obj/item/clothing/under/U = owner.w_uniform
					U.removed_parts |= body_part
					owner.update_inv_w_uniform()
			if(BODY_FLAG_LEG_RIGHT)
				if(status & LIMB_ROBOT)
					organ = new /obj/item/robot_parts/r_leg(owner.loc)
				else
					organ = new /obj/item/limb/leg/r_leg(owner.loc, owner)
				if(owner.w_uniform && !amputation)
					var/obj/item/clothing/under/U = owner.w_uniform
					U.removed_parts |= body_part
					owner.update_inv_w_uniform()
			if(BODY_FLAG_LEG_LEFT)
				if(status & LIMB_ROBOT)
					organ = new /obj/item/robot_parts/l_leg(owner.loc)
				else
					organ = new /obj/item/limb/leg/l_leg(owner.loc, owner)
				if(owner.w_uniform && !amputation)
					var/obj/item/clothing/under/U = owner.w_uniform
					U.removed_parts |= body_part
					owner.update_inv_w_uniform()
			if(BODY_FLAG_HAND_RIGHT)
				if(!(status & LIMB_ROBOT))
					organ= new /obj/item/limb/hand/r_hand(owner.loc, owner)
				owner.drop_inv_item_on_ground(owner.gloves, null, TRUE)
				owner.drop_inv_item_on_ground(owner.r_hand, null, TRUE)
			if(BODY_FLAG_HAND_LEFT)
				if(!(status & LIMB_ROBOT))
					organ= new /obj/item/limb/hand/l_hand(owner.loc, owner)
				owner.drop_inv_item_on_ground(owner.gloves, null, TRUE)
				owner.drop_inv_item_on_ground(owner.l_hand, null, TRUE)
			if(BODY_FLAG_FOOT_RIGHT)
				if(!(status & LIMB_ROBOT))
					organ= new /obj/item/limb/foot/r_foot/(owner.loc, owner)
				owner.drop_inv_item_on_ground(owner.shoes, null, TRUE)
			if(BODY_FLAG_FOOT_LEFT)
				if(!(status & LIMB_ROBOT))
					organ = new /obj/item/limb/foot/l_foot(owner.loc, owner)
				owner.drop_inv_item_on_ground(owner.shoes, null, TRUE)

		if(delete_limb)
			qdel(organ)
		else
			owner.visible_message(SPAN_WARNING("[owner.name]'s [display_name] flies off in an arc!"),
			SPAN_HIGHDANGER("<b>Your [display_name] goes flying off!</b>"),
			SPAN_WARNING("You hear a terrible sound of ripping tendons and flesh!"), 3)

			if(organ)
				//Throw organs around
				var/lol = pick(cardinal)
				step(organ,lol)

		overlays.Cut() //Severed limbs shouldn't have damage overlays. This prevents issues with permanently bloody robot replacement limbs and excessively bloody stumps.
		owner.update_body(1)
		owner.update_med_icon()

		owner.update_can_stand()

		// OK so maybe your limb just flew off, but if it was attached to a pair of cuffs then hooray! Freedom!
		release_restraints()

		if(vital) owner.death(cause)

/*
			HELPERS
*/

///Returns a description of opened incisions.
/obj/limb/proc/get_incision_depth()
	switch(owner.incision_depths[name])
		if(SURGERY_DEPTH_SHALLOW)
			return "a surgical incision"
		if(SURGERY_DEPTH_DEEP)
			return "a massive surgical incision"

///Returns a description of active surgeries.
/obj/limb/proc/get_active_limb_surgeries()
	if(owner.active_surgeries[name])
		return "an incomplete surgical operation"

/obj/limb/proc/release_restraints()
	if(!owner)
		return
	if (owner.handcuffed && (body_part in list(BODY_FLAG_ARM_LEFT, BODY_FLAG_ARM_RIGHT, BODY_FLAG_HAND_LEFT, BODY_FLAG_HAND_RIGHT)))
		owner.visible_message(\
			"\The [owner.handcuffed.name] falls off of [owner.name].",\
			"\The [owner.handcuffed.name] falls off you.")

		owner.drop_inv_item_on_ground(owner.handcuffed)

	if (owner.legcuffed && (body_part in list(BODY_FLAG_FOOT_LEFT, BODY_FLAG_FOOT_RIGHT, BODY_FLAG_LEG_LEFT, BODY_FLAG_LEG_RIGHT)))
		owner.visible_message(\
			"\The [owner.legcuffed.name] falls off of [owner.name].",\
			"\The [owner.legcuffed.name] falls off you.")

		owner.drop_inv_item_on_ground(owner.legcuffed)

/**bandages brute wounds and removes bleeding. Returns WOUNDS_BANDAGED if at least one wound was bandaged. Returns WOUNDS_ALREADY_TREATED
if a relevant wound exists but none were treated. Skips wounds that are already bandaged.
treat_sutured var tells it to apply to sutured but unbandaged wounds, for trauma kits that heal damage directly.**/
/obj/limb/proc/bandage(treat_sutured)
	remove_all_bleeding(TRUE)
	owner.update_med_icon()
	if(applied_bandage)
		return WOUNDS_BANDAGED
	else if(wounds_exist)
		return WOUNDS_ALREADY_TREATED

///Checks for bandageable wounds (type = CUT or type = BRUISE). Returns TRUE if all are bandaged, FALSE if not.
/obj/limb/proc/is_bandaged()
	var/not_bandaged = FALSE

	return !not_bandaged

/obj/limb/proc/salve()
	var/rval = 0

	return rval

/obj/limb/proc/is_salved()
	var/not_salved = FALSE

	return !not_salved

/*
/obj/limb/proc/handle_dislocated()
	owner.recalculate_move_delay = TRUE
	owner.visible_message(\
		SPAN_WARNING("You hear a loud crunching sound coming from [owner] as their [display_name] dislocates out of place!"),
		SPAN_HIGHDANGER("Something feels out of place in your [display_name], as you feel your bones shift!"),
		SPAN_HIGHDANGER("You see bones being shifted out of place!"))
	playsound(owner, "bone_break", 45, TRUE)
	start_processing()

	status |= LIMB_DISLOCATED
	owner.pain.apply_pain(PAIN_DISLOCATED_BREAK)
*/

/obj/limb/proc/robotize(surgery_in_progress, uncalibrated)
	if(uncalibrated) //Newly-attached prosthetics need to be calibrated to function.
		status = LIMB_ROBOT|LIMB_UNCALIBRATED_PROSTHETIC
	else
		status = LIMB_ROBOT

	stop_processing()

	if(!surgery_in_progress) //So as to not interrupt an ongoing prosthetic-attaching operation.
		reset_limb_surgeries()

	for(var/obj/limb/T as anything in children)
		T.robotize(uncalibrated = uncalibrated)

	update_icon()

/obj/limb/proc/calibrate_prosthesis()
	status &= ~LIMB_UNCALIBRATED_PROSTHETIC
	for(var/obj/limb/T as anything in children)
		T.calibrate_prosthesis()

/obj/limb/proc/mutate()
	status |= LIMB_MUTATED
	owner.update_body()

/obj/limb/proc/unmutate()
	status &= ~LIMB_MUTATED
	owner.update_body()

///Returns total damage, or, if broken, the minimum fracture threshold, whichever is higher.
/obj/limb/proc/get_damage()
	return max(brute_dam + burn_dam)	//could use health?

/obj/limb/proc/is_usable()
	return !(status & (LIMB_DESTROYED|LIMB_MUTATED|LIMB_UNCALIBRATED_PROSTHETIC))

/obj/limb/proc/is_malfunctioning()
	return ((status & LIMB_ROBOT) && prob(brute_dam + burn_dam))

//for arms and hands


/obj/limb/proc/embed(var/obj/item/W, var/silent = 0)
	if(!W || QDELETED(W) || (W.flags_item & (NODROP|DELONDROP)) || W.embeddable == FALSE)
		return
	if(!silent)
		owner.visible_message(SPAN_DANGER("\The [W] sticks in the wound!"))
	implants += W
	start_processing()

	W.embedded_organ = src
	owner.embedded_items += W
	if(!istype(W, /obj/item/shard/shrapnel)) // Only add the verb if its not a shrapnel
		add_verb(owner, /mob/proc/yank_out_object)

	W.add_mob_blood(owner)

	if(ismob(W.loc))
		var/mob/living/H = W.loc
		H.drop_held_item()
	if(W)
		W.forceMove(owner)

/obj/limb/proc/update_damage_icon_part()
	var/brutestate = copytext(damage_state, 1, 2)
	var/burnstate = copytext(damage_state, 2)
	if(brutestate != "0")
		wound_overlay.icon_state = "grayscale_[brutestate]"
		overlays += wound_overlay

	if(burnstate != "0")
		wound_overlay.icon_state = "burn_[burnstate]"
		overlays += wound_overlay

///called when limb is removed or robotized, any ongoing surgery and related vars are reset unless set otherwise.
/obj/limb/proc/reset_limb_surgeries()
	owner.incision_depths[name] = SURGERY_DEPTH_SURFACE
	owner.active_surgeries[name] = null

/*
			LIMB TYPES AND INTEGRITY EFFECTS
*/
/obj/limb/chest
	name = "chest"
	icon_name = "torso"
	display_name = "chest"
	cavity = "thoracic cavity"
	max_damage = 120
	body_part = BODY_FLAG_CHEST
	vital = 1
	encased = "ribcage"
	artery_name = "aorta"

/obj/limb/groin
	name = "groin"
	icon_name = "groin"
	display_name = "groin"
	cavity = "abdominal cavity"
	max_damage = 120
	body_part = BODY_FLAG_GROIN
	artery_name = "iliac artery"

/obj/limb/leg
	name = "leg"
	display_name = "leg"
	max_damage = 75
	artery_name = "femoral artery"
	limb_inherent_traits = list(TRAIT_LIMB_ALLOWS_STAND)

/obj/limb/foot
	name = "foot"
	display_name = "foot"
	max_damage = 45
	var/move_delay_mult = HUMAN_SLOWED_AMOUNT
	artery_name = "plantar artery"
	limb_inherent_traits = list(TRAIT_LIMB_ALLOWS_STAND)

/obj/limb/arm
	name = "arm"
	display_name = "arm"
	max_damage = 80
	artery_name = "basilic vein"
	limb_int_multiplier = 0.9
	var/work_delay_mult = 1

/obj/limb/arm/l_arm
	name = "l_arm"
	display_name = "left arm"
	icon_name = "l_arm"
	body_part = BODY_FLAG_ARM_LEFT
	has_stump_icon = TRUE
	body_side = LEFT

/obj/limb/arm/r_arm
	name = "r_arm"
	display_name = "right arm"
	icon_name = "r_arm"
	body_part = BODY_FLAG_ARM_RIGHT
	has_stump_icon = TRUE
	body_side = RIGHT

/obj/limb/hand
	name = "hand"
	display_name = "hand"
	max_damage = 50
	var/obj/item/c_hand
	var/hand_name = "ambidexterous hand"

/obj/limb/hand/proc/process_grasp(c_hand, hand_name)
	/*
	if (!c_hand)
		return

	var/drop_probability = 0.6 * ((brute_dam + burn_dam) + (integrity_damage * 0.5))
	if(is_broken())
		drop_probability *= 1.25 //25% bonus

	if(is_integrity_disabled())
		if(prob(drop_probability))
			owner.drop_inv_item_on_ground(c_hand)
			var/emote_scream = pick("screams in pain and", "lets out a sharp cry and", "cries out and")
			owner.emote("me", 1, "[(!owner.pain.feels_pain) ? "" : emote_scream ] drops what they were holding in their [hand_name]!")
	*/
	/* NEED TO THINK ON HOW TO REWORK THIS TO BE HONEST WITH YOU
	if(is_malfunctioning())
		if(prob(10))
			owner.drop_inv_item_on_ground(c_hand)
			owner.emote("me", 1, "drops what they were holding, their [hand_name] malfunctioning!")
			var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
			spark_system.set_up(5, 0, owner)
			spark_system.attach(owner)
			spark_system.start()
			QDEL_IN(spark_system, 1 SECONDS) */

/obj/limb/hand/r_hand
	name = "r_hand"
	display_name = "right hand"
	icon_name = "r_hand"
	body_part = BODY_FLAG_HAND_RIGHT
	has_stump_icon = TRUE
	hand_name = "right hand"
	body_side = RIGHT

/obj/limb/hand/l_hand
	name = "l_hand"
	display_name = "left hand"
	icon_name = "l_hand"
	body_part = BODY_FLAG_HAND_LEFT
	has_stump_icon = TRUE
	hand_name = "left hand"
	body_side = LEFT

/obj/limb/leg/l_leg
	name = "l_leg"
	display_name = "left leg"
	icon_name = "l_leg"
	body_part = BODY_FLAG_LEG_LEFT
	icon_position = LEFT
	has_stump_icon = TRUE
	limb_int_multiplier = 0.9
	body_side = LEFT

/obj/limb/leg/r_leg
	name = "r_leg"
	display_name = "right leg"
	icon_name = "r_leg"
	body_part = BODY_FLAG_LEG_RIGHT
	icon_position = RIGHT
	has_stump_icon = TRUE
	body_side = RIGHT

/obj/limb/foot/l_foot
	name = "l_foot"
	display_name = "left foot"
	icon_name = "l_foot"
	body_part = BODY_FLAG_FOOT_LEFT
	icon_position = LEFT
	has_stump_icon = TRUE
	body_side = LEFT

/obj/limb/foot/r_foot
	name = "r_foot"
	display_name = "right foot"
	icon_name = "r_foot"
	body_part = BODY_FLAG_FOOT_RIGHT
	icon_position = RIGHT
	has_stump_icon = TRUE
	body_side = RIGHT

/obj/limb/head
	name = "head"
	icon_name = "head"
	display_name = "head"
	cavity = "cranial cavity"
	max_damage = 70
	body_part = BODY_FLAG_HEAD
	vital = 1
	encased = "skull"
	has_stump_icon = TRUE
	var/disfigured = 0 //whether the head is disfigured.
	artery_name = "cartoid artery"
	limb_int_multiplier = 0.6

/obj/limb/head/update_overlays()
	..()

	var/image/eyes = new/image('icons/mob/humans/onmob/human_face.dmi', owner.species.eyes)
	eyes.color = list(null, null, null, null, rgb(owner.r_eyes, owner.g_eyes, owner.b_eyes))
	overlays += eyes

	if(owner.lip_style && (owner.species && owner.species.flags & HAS_LIPS))
		var/icon/lips = new /icon('icons/mob/humans/onmob/human_face.dmi', "paint_[owner.lip_style]")
		overlays += lips

/obj/limb/head/take_damage(brute, burn, int_dmg_multiplier = 1, used_weapon = null, list/forbidden_limbs = list(), no_limb_loss, var/mob/attack_source = null)
	. = ..()
	if (!disfigured)
		if (brute_dam > 50 || brute_dam > 40 && prob(50))
			disfigure("brute")
		if (burn_dam > 40)
			disfigure("burn")

/obj/limb/head/proc/disfigure(var/type = "brute")
	if (disfigured)
		return
	if(type == "brute")
		owner.visible_message(SPAN_DANGER("You hear a sickening cracking sound coming from \the [owner]'s face."),	\
		SPAN_DANGER("<b>Your face becomes an unrecognizible mangled mess!</b>"),	\
		SPAN_DANGER("You hear a sickening crack."))
	else
		owner.visible_message(SPAN_DANGER("[owner]'s face melts away, turning into a mangled mess!"),	\
		SPAN_DANGER("<b>Your face melts off!</b>"),	\
		SPAN_DANGER("You hear a sickening sizzle."))
	disfigured = 1
	owner.name = owner.get_visible_name()

/obj/limb/head/reset_limb_surgeries()
	for(var/zone in list("head", "eyes", "mouth"))
		owner.active_surgeries[zone] = null
		owner.incision_depths[zone] = SURGERY_DEPTH_SURFACE

/obj/limb/head/get_incision_depth() //Head limb includes eye/mouth locations.
	var/incisions

	for(var/zone in list("head", "eyes", "mouth"))
		switch(owner.incision_depths[zone])
			if(SURGERY_DEPTH_SHALLOW)
				incisions++
			if(SURGERY_DEPTH_DEEP) //Only the head itself can be cut this deeply.
				. = "a massive surgical incision"

	switch(incisions)
		if(1)
			if(.)
				. += " and a smaller incision"
			else
				. = "a surgical incision"
		if(2, 3)
			if(.) //3 locations tested, . means skull is opened deeply, therefore this is eye + mouth.
				. += " and two smaller incisions"
			else //2-3 open incisions. Not bothering to test exact number.
				. = "several surgical incisions"

/obj/limb/head/get_active_limb_surgeries()
	for(var/zone in list("head", "eyes", "mouth"))
		if(owner.active_surgeries[zone])
			.++

	switch(.)
		if(1)
			return "an incomplete surgical operation"
		if(2, 3)
			return "several incomplete surgical operations"
