//****************************************************
// EXTERNAL ORGANS
//****************************************************/
/obj/limb
	name = "limb"
	appearance_flags = KEEP_TOGETHER | TILE_BOUND
	vis_flags = VIS_INHERIT_ID | VIS_INHERIT_DIR | VIS_INHERIT_PLANE
	var/icon_name = null
	var/body_part = null
	var/icon_position = 0
	var/damage_state = "=="
	var/brute_dam = 0
	var/burn_dam = 0
	var/max_damage = 0
	var/max_size = 0
	var/last_dam = -1
	var/knitting_time = -1
	var/time_to_knit = -1 // snowflake vars for doing self-bone healing, think preds and magic research chems

	var/display_name

	var/list/datum/wound/wounds = list()
	var/number_wounds = 0 // cache the number of wounds, which is NOT length(wounds)!

	var/tmp/perma_injury = 0

	var/min_broken_damage = 30

	var/list/datum/autopsy_data/autopsy_data = list()
	var/list/trace_chemicals = list() // traces of chemicals in the organ,
									  // links chemical IDs to number of ticks for which they'll stay in the blood

	var/obj/limb/parent
	var/list/obj/limb/children

	// Internal organs of this body part
	var/list/datum/internal_organ/internal_organs

	var/broken_description

	//Surgical vars
	///Name of bones encasing the limb.
	var/encased
	///Name of internal cavity.
	var/cavity
	///Surgically implanted item.
	var/obj/item/hidden = null
	///Embedded or implanter implanted items.
	var/list/implants = list()

	// how often wounds should be updated, a higher number means less often
	var/wound_update_accuracy = 1

	var/mob/living/carbon/human/owner = null
	var/vital //Lose a vital limb, die immediately.

	var/has_stump_icon = FALSE
	var/image/wound_overlay //Used to save time redefining it every wound update. Doesn't remember anything but the most recently used icon state.
	var/image/burn_overlay //Ditto but for burns.

	var/splint_icon_amount = 1
	var/bandage_icon_amount = 1

	var/icon/splinted_icon = null

	var/list/bleeding_effects_list = list()

	var/can_bleed_internally = TRUE

	var/destroyed = FALSE
	var/status = LIMB_ORGANIC
	var/processing = FALSE

	/// skin color of the owner, used for limb appearance, set in [/obj/limb/proc/update_limb()]
	var/skin_color = "Pale 2"

	/// body size of the owner, used for limb appearance, set in [/obj/limb/proc/update_limb()]
	var/body_size = "Average"

	/// body muscularity of the owner, used for limb appearance, set in [/obj/limb/proc/update_limb()]
	var/body_type = "Lean"

	/// species of the owner, used for limb appearance, set in [/obj/limb/proc/update_limb()]
	var/datum/species/species

	/// defines which sprite the limb should use if dimorphic, set in [/obj/limb/proc/update_limb()]
	var/limb_gender = MALE


/obj/limb/Initialize(mapload, obj/limb/P, mob/mob_owner)
	. = ..()
	if(P)
		parent = P
		if(!parent.children)
			parent.children = list()
		parent.children.Add(src)
	if(mob_owner)
		owner = mob_owner

	wound_overlay = image('icons/mob/humans/dam_human.dmi', "grayscale_0", -DAMAGE_LAYER)
	wound_overlay.color = owner?.species.blood_color

	burn_overlay = image('icons/mob/humans/dam_human.dmi', "burn_0", -DAMAGE_LAYER)

	if(owner)
		forceMove(owner)

/obj/limb/Destroy()
	if(parent)
		parent.children -= src
	parent = null
	if(children)
		for(var/obj/limb/L in children)
			L.parent = null
		children = null

	QDEL_NULL(hidden)
	QDEL_NULL_LIST(internal_organs)
	QDEL_NULL_LIST(implants)
	QDEL_LIST_ASSOC_VAL(autopsy_data)

	if(bleeding_effects_list)
		for(var/datum/effects/bleeding/B in bleeding_effects_list)
			qdel(B)
		bleeding_effects_list = null

	splinted_icon = null

	if(owner && owner.limbs)
		owner.limbs -= src
		owner.limbs_to_process -= src
		owner.update_body()
	owner = null

	QDEL_NULL_LIST(wounds)

	return ..()

//Autopsy stuff

//Handles chem traces
/mob/living/carbon/human/proc/handle_trace_chems()
	//New are added for reagents to random organs.
	for(var/datum/reagent/A in reagents.reagent_list)
		var/obj/limb/O = pick(limbs)
		O.trace_chemicals[A.name] = 100

//Adds autopsy data for used_weapon.
/obj/limb/proc/add_autopsy_data(used_weapon, damage)
	var/datum/autopsy_data/W = autopsy_data[used_weapon]
	if(!W)
		W = new()
		W.weapon = used_weapon
		autopsy_data[used_weapon] = W

	W.hits++
	W.damage += damage
	W.time_inflicted = world.time



/*
			DAMAGE PROCS
*/

/obj/limb/emp_act(severity)
	. = ..()
	if(!(status & (LIMB_ROBOT|LIMB_SYNTHSKIN))) //meatbags do not care about EMP
		return
	var/probability = 30
	var/damage = 15
	if(severity == 2)
		probability = 1
		damage = 3
	if(can_emp_delimb() && prob(probability))
		droplimb(0, 0, "EMP")
	else
		take_damage(damage, 0, 1, 1, used_weapon = "EMP")
		for(var/datum/internal_organ/internal_organ in internal_organs)
			if(internal_organ.robotic == FALSE)
				continue
			internal_organ.emp_act(severity)

/// If this limb can be dropped as a result of an EMP
/obj/limb/proc/can_emp_delimb()
	return TRUE

/obj/limb/proc/take_damage_organ_damage(brute, sharp)
	if(!owner)
		return

	var/armor = owner.getarmor_organ(src, ARMOR_INTERNALDAMAGE)
	if(owner.mind && owner.skills)
		armor += owner.skills.get_skill_level(SKILL_ENDURANCE)*5

	var/damage = armor_damage_reduction(GLOB.marine_organ_damage, brute, armor, sharp ? ARMOR_SHARP_INTERNAL_PENETRATION : 0, 0, 0, max_damage ? (100*(max_damage-brute_dam) / max_damage) : 100)

	if(internal_organs && prob(damage*DMG_ORGAN_DAM_PROB_MULT + brute_dam*BRUTE_ORGAN_DAM_PROB_MULT))
		//Damage an internal organ
		var/datum/internal_organ/I = pick(internal_organs)
		I.take_damage(brute / 2)
		return TRUE
	return FALSE

/obj/limb/proc/take_damage_bone_break(brute)
	if(!owner)
		return

	var/armor = owner.getarmor_organ(src, ARMOR_INTERNALDAMAGE)
	if(owner.mind && owner.skills)
		armor += owner.skills.get_skill_level(SKILL_ENDURANCE)*5

	var/damage = armor_damage_reduction(GLOB.marine_bone_break, brute*3, armor, 0, 0, 0, max_damage ? (100*(max_damage-brute_dam) / max_damage) : 100)

	if(brute_dam > min_broken_damage * CONFIG_GET(number/organ_health_multiplier) && prob(damage*2))
		fracture()
/**
 * Describes how limbs (body parts) of human mobs get damage applied.
 *
 * Any damage past the limb maximum health is transfered onto the next limb up the line, by
 * calling this proc recursively. When a hand is too damaged it is passed to the arm,
 * then to the chest and so on.
 *
 * Since parent limbs usually have more armor than their children, just passing the damage
 * directly would allow the attacker to effectively bypass all of that armor. A lurker
 * with 35 slash damage repeatedly slashing a hand protected by marine combat gloves
 * (20 armor) would do 20 damage to the hand, then would start doing the same 20 to
 * the arm, and then the chest. But if the lurker slashes the arm direclty it would only
 * do 16 damage, assuming the marine is wearing medium armor which has armor value of 30.
 *
 * Thus we have to apply armor damage reduction on each limb to which the damage is
 * transfered. When this proc is called recursively for the first damage transfer to the
 * parent, we set reduced_by variables to be the armor of the original limb hit. Then we
 * compare the parent limb armor with the applicable reduced_by and if it's higher we reduce
 * the damage by the difference between the two. Then we set reduced_by to
 * the current(parent) limb armor value.
 *
 * This generally works ok because our armor calculations are mostly distributive in
 * practice: reducing the damage by 20 and then by 10 would generally give the same result
 * as reducing by 30. But this is not strictly true, the lower the damage is, the more it
 * gets reduced. As an extreme example, a lurker doing his first 35 damage slash on a combat
 * gloves covered marine hand would do 30 damage to the hand, transfer 5 to the arm and
 * those 5 would get mitigated to 0 by the marine medium armor.
 *
 * One problem that still exists here, is that we currently don't have any code
 * that allows us to increase the damage when the parent limb armor is lower than the
 * initial child limb armor.
 * One practical example where this would happen is when a human is wearing a set of armor
 * that does not protect legs, like the UPP officer. If a xeno keeps slashing his foot,
 * the damage would eventually get transfered to the leg, which has 0 armor. But this damage
 * has been already reduced by the boot armor even before this proc got first called.
 * So, assuming 35 damage slash, the leg would only be damaged by 21 even though it has
 * 0 armor. Fixing this would require a new proc that would be able to unapply armor
 * from the damage.
 *
 * Organ damage and bone break have their own armor damage reduction calculations. Since
 * armor is already applied at least once outside of this proc, this means that damage is always
 * reduced twice, hence the formulas for those looks so weird.
 *
 * Currently all brute damage is reduced by ARMOR_MELEE and GLOB.marine_melee,
 * while burn damage is reduced by ARMOR_BIO and GLOB.marine_fire, which may not be correct
 * for all cases.
 */
/obj/limb/proc/take_damage(brute, burn, sharp, edge, used_weapon = null,\
							list/forbidden_limbs = list(),
							no_limb_loss, damage_source = create_cause_data("amputation"),\
							mob/attack_source = null,\
							brute_reduced_by = -1, burn_reduced_by = -1)
	if((brute > 0 || burn > 0) && owner && MODE_HAS_MODIFIER(/datum/gamemode_modifier/disable_attacking_corpses) && owner.stat == DEAD) //if they take positive damage (not healing) we prevent it
		return 0
	if((brute <= 0) && (burn <= 0))
		return 0

	if(burn > 0 && MODE_HAS_MODIFIER(/datum/gamemode_modifier/weaker_explosions_fire))
		burn /= 4 //reduce the flame dmg by 75% for HvH, it is still super strong

	if(status & LIMB_DESTROYED)
		return 0

	var/previous_brute = brute_dam
	var/previous_burn = burn_dam
	var/previous_bonebreak = (status & LIMB_BROKEN)

	var/is_ff = FALSE
	if(istype(attack_source) && attack_source.faction == owner.faction)
		is_ff = TRUE

	if((brute > 0) && (brute_reduced_by >= 0))
		var/brute_armor = owner.getarmor_organ(src, ARMOR_MELEE)
		if(brute_armor > brute_reduced_by)
			brute = armor_damage_reduction(GLOB.marine_melee, brute, brute_armor - brute_reduced_by)
			brute_reduced_by = brute_armor
	if((burn > 0) && (burn_reduced_by >= 0))
		var/burn_armor = owner.getarmor_organ(src, ARMOR_BIO)
		if(burn_armor > burn_reduced_by)
			burn = armor_damage_reduction(GLOB.marine_fire, brute, burn_armor - burn_reduced_by)
			burn_reduced_by = burn_armor

	//High brute damage or sharp objects may damage internal organs
	if(!is_ff && take_damage_organ_damage(brute, sharp))
		brute /= 2

	if(CONFIG_GET(flag/bones_can_break) && !(status & (LIMB_SYNTHSKIN)))
		take_damage_bone_break(brute)

	if(status & LIMB_BROKEN && prob(40) && brute > 10)
		if(owner.pain.feels_pain)
			INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob, emote), "scream") //Getting hit on broken hand hurts
	if(used_weapon)
		add_autopsy_data("[used_weapon]", brute + burn)

	var/can_cut = (prob(brute*2) || sharp) && !(status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
	// If the limbs can break, make sure we don't exceed the maximum damage a limb can take before breaking
	if((brute_dam + burn_dam + brute + burn) < max_damage || !CONFIG_GET(flag/limbs_can_break))
		if(brute)
			if(can_cut)
				createwound(CUT, brute, is_ff = is_ff)
			else
				createwound(BRUISE, brute, is_ff = is_ff)
		if(burn)
			createwound(BURN, burn, is_ff = is_ff)
	else
		//If we can't inflict the full amount of damage, spread the damage in other ways
		//How much damage can we actually cause?
		var/can_inflict = max_damage * CONFIG_GET(number/organ_health_multiplier) - (brute_dam + burn_dam)
		var/remain_brute = brute
		var/remain_burn = burn
		if(can_inflict)
			if(brute > 0)
				//Inflict all brute damage we can
				if(can_cut)
					createwound(CUT, min(brute, can_inflict), is_ff = is_ff)
				else
					createwound(BRUISE, min(brute, can_inflict), is_ff = is_ff)
				var/temp = can_inflict
				//How much more damage can we inflict
				can_inflict = max(0, can_inflict - brute)
				//How much brute damage is left to inflict
				remain_brute = max(0, brute - temp)

			if(burn > 0 && can_inflict)
				//Inflict all burn damage we can
				createwound(BURN, min(burn,can_inflict), is_ff = is_ff)
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
			if(length(forbidden_limbs))
				possible_points -= forbidden_limbs
			if(length(possible_points))
				//And pass the damage around, but not the chance to cut the limb off.
				var/obj/limb/target = pick(possible_points)
				if(brute_reduced_by == -1)
					brute_reduced_by = owner.getarmor_organ(src, ARMOR_MELEE)
				if(burn_reduced_by == -1)
					burn_reduced_by = owner.getarmor_organ(src, ARMOR_BIO)
				target.take_damage(remain_brute, remain_burn, sharp, edge, used_weapon,\
					forbidden_limbs + src, TRUE, attack_source = attack_source,\
					brute_reduced_by = brute_reduced_by, burn_reduced_by = burn_reduced_by)


	//Sync the organ's damage with its wounds
	src.update_damages()

	//If limb was damaged before and took enough damage, try to cut or tear it off
	var/no_perma_damage = owner.status_flags & NO_PERMANENT_DAMAGE
	var/no_bone_break = owner.chem_effect_flags & CHEM_EFFECT_RESIST_FRACTURE
	if(previous_brute > 0 && !is_ff && body_part != BODY_FLAG_CHEST && body_part != BODY_FLAG_GROIN && !no_limb_loss && !no_perma_damage && !no_bone_break)
		if(CONFIG_GET(flag/limbs_can_break) && brute_dam >= max_damage * CONFIG_GET(number/organ_health_multiplier) && (previous_bonebreak || (status & (LIMB_ROBOT|LIMB_SYNTHSKIN)))) //delimbable only if broken before this hit or we're a robot limb (synths do not fracture)
			var/cut_prob = brute/max_damage * 5
			if(prob(cut_prob))
				limb_delimb(damage_source)

	SEND_SIGNAL(src, COMSIG_LIMB_TAKEN_DAMAGE, is_ff, previous_brute, previous_burn)
	owner.updatehealth()
	owner.update_damage_overlays()
	start_processing()

///Special delimbs for different limbs
/obj/limb/proc/limb_delimb(damage_source)
	droplimb(0, 0, damage_source)

/obj/limb/proc/heal_damage(brute, burn, robo_repair = FALSE)
	if(status & (LIMB_ROBOT|LIMB_SYNTHSKIN) && !robo_repair)
		return

	//Heal damage on the individual wounds
	for(var/datum/wound/W in wounds)
		if(brute == 0 && burn == 0)
			break

		// heal brute damage
		if(W.damage_type == CUT || W.damage_type == BRUISE)
			var/old_brute = brute
			brute = W.heal_damage(brute)
			owner.pain.apply_pain(brute - old_brute, BRUTE)
		else if(W.damage_type == BURN)
			var/old_burn = burn
			burn = W.heal_damage(burn)
			owner.pain.apply_pain(burn - old_burn, BURN)

	//Sync the organ's damage with its wounds
	src.update_damages()
	owner.updatehealth()

	update_icon()

/*
This function completely restores a damaged organ to perfect condition.
*/
/obj/limb/proc/rejuvenate()
	damage_state = "=="
	if(status & LIMB_SYNTHSKIN)
		status = LIMB_SYNTHSKIN
	else if(status & LIMB_ROBOT) //Robotic organs stay robotic.  Fix because right click rejuvinate makes IPC's organs organic.
		status = LIMB_ROBOT
	else
		status = LIMB_ORGANIC
	perma_injury = 0
	brute_dam = 0
	burn_dam = 0
	wounds.Cut()
	number_wounds = 0

	// reset surgeries. Some duplication with general mob rejuvenate() but this also allows individual limbs to be rejuvenated, in theory.
	reset_limb_surgeries()

	// remove suture datum.
	SEND_SIGNAL(src, COMSIG_LIMB_REMOVE_SUTURES)

	// heal internal organs
	for(var/datum/internal_organ/current_organ in internal_organs)
		current_organ.rejuvenate()

	// remove embedded objects and drop them on the floor
	for(var/obj/implanted_object in implants)
		if(!istype(implanted_object,/obj/item/implant)) // We don't want to remove REAL implants. Just shrapnel etc.
			implanted_object.forceMove(owner.loc)
			implants -= implanted_object
			if(is_sharp(implanted_object) || istype(implanted_object, /obj/item/shard/shrapnel))
				owner.embedded_items -= implanted_object

	remove_all_bleeding(TRUE, TRUE)
	owner.pain.recalculate_pain()
	owner.updatehealth()
	owner.update_body()
	update_icon()

/obj/limb/proc/take_damage_internal_bleeding(damage)
	if(!owner)
		return

	var/armor = owner.getarmor_organ(src, ARMOR_INTERNALDAMAGE)
	if(owner.mind && owner.skills)
		armor += owner.skills.get_skill_level(SKILL_ENDURANCE)*5

	var/damage_ratio = armor_damage_reduction(GLOB.marine_organ_damage, 2*damage/3, armor, 0, 0, 0, max_damage ? (100*(max_damage - brute_dam) / max_damage) : 100)
	if(prob(damage_ratio) && damage > 10)
		var/datum/wound/internal_bleeding/I = new (0)
		add_bleeding(I, TRUE)
		wounds += I
		owner.custom_pain("You feel something rip in your [display_name]!", 1)

/obj/limb/proc/createwound(type = CUT, damage, is_ff = FALSE)
	if(!damage)
		return

	//moved this before the open_wound check so that having many small wounds for example doesn't somehow protect you from taking internal damage (because of the return)
	//Possibly trigger an internal wound, too.
	if(!is_ff && type != BURN && !(status & (LIMB_ROBOT|LIMB_SYNTHSKIN)))
		take_damage_internal_bleeding(damage)

	if(!(status & LIMB_SPLINTED_INDESTRUCTIBLE) && (status & LIMB_SPLINTED) && damage > 5 && prob(50 + damage * 2.5)) //If they have it splinted, the splint won't hold.
		status &= ~LIMB_SPLINTED
		playsound(get_turf(loc), 'sound/items/splintbreaks.ogg', 20)
		to_chat(owner, SPAN_HIGHDANGER("The splint on your [display_name] comes apart!"))
		owner.pain.apply_pain(PAIN_BONE_BREAK_SPLINTED)
		owner.update_med_icon()

	// first check whether we can widen an existing wound
	var/datum/wound/W
	if(length(wounds) > 0 && prob(max(50+(number_wounds-1)*10,90)))
		if((type == CUT || type == BRUISE) && damage >= 5)
			//we need to make sure that the wound we are going to worsen is compatible with the type of damage...
			var/compatible_wounds[] = new
			for(W in wounds)
				if(W.can_worsen(type, damage))
					compatible_wounds += W

			if(length(compatible_wounds))
				W = pick(compatible_wounds)
				W.open_wound(damage)
				if(type != BURN)
					add_bleeding(W)
					owner.add_splatter_floor(get_turf(loc))
				if(prob(25))
					//maybe have a separate message for BRUISE type damage?
					owner.visible_message(SPAN_WARNING("The wound on [owner.name]'s [display_name] widens with a nasty ripping noise."),
					SPAN_WARNING("The wound on your [display_name] widens with a nasty ripping noise."),
					SPAN_WARNING("You hear a nasty ripping noise, as if flesh is being torn apart."))
				return

	//Creating wound
	var/wound_type = get_wound_type(type, damage)

	if(wound_type)
		W = new wound_type(damage)
		if(damage >= 10 && type != BURN) //Only add bleeding when its over 10 damage
			add_bleeding(W)
			owner.add_splatter_floor(get_turf(loc))

		//Check whether we can add the wound to an existing wound
		for(var/datum/wound/other in wounds)
			if(other.can_merge(W))
				other.merge_wound(W)
				W = null // to signify that the wound was added
				break
		if(W)
			wounds += W

///Adds bleeding to the limb. Damage_amount lets you apply an amount worth of bleeding, otherwise it uses the given wound's damage.
/obj/limb/proc/add_bleeding(datum/wound/W, internal = FALSE, damage_amount)
	if(!(SSticker.current_state >= GAME_STATE_PLAYING)) //If the game hasnt started, don't add bleed. Hacky fix to avoid having 100 bleed effect from roundstart.
		return

	if(status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
		return

	if(internal && !can_bleed_internally)
		internal = FALSE
	if(internal && MODE_HAS_MODIFIER(/datum/gamemode_modifier/disable_ib))
		internal = FALSE


	if(length(bleeding_effects_list))
		if(!internal)
			for(var/datum/effects/bleeding/external/B in bleeding_effects_list)
				B.add_on(damage_amount ? damage_amount : W.damage)
				return
		else
			for(var/datum/effects/bleeding/internal/B in bleeding_effects_list)
				B.add_on(30)
				return

	var/datum/effects/bleeding/bleeding_status
	if(internal)
		bleeding_status = new /datum/effects/bleeding/internal(owner, src, 40)
	else
		bleeding_status = new /datum/effects/bleeding/external(owner, src, damage_amount ? damage_amount : W.damage)
	bleeding_effects_list += bleeding_status


/obj/limb/proc/remove_all_bleeding(external = FALSE, internal = FALSE)
	SEND_SIGNAL(src, COMSIG_LIMB_STOP_BLEEDING, external, internal)
	if(external)
		for(var/datum/effects/bleeding/external/B in bleeding_effects_list)
			qdel(B)

	if(internal)
		for(var/datum/effects/bleeding/internal/I in bleeding_effects_list)
			qdel(I)


///Checks if there's any external limb wounds, removes bleeding if there isn't.
/obj/limb/proc/remove_wound_bleeding()
	for(var/datum/wound/W as anything in wounds)
		if(!W.internal)
			return
	remove_all_bleeding(TRUE)

/*
			PROCESSING & UPDATING
*/

//Determines if we even need to process this organ.

/obj/limb/proc/need_process()
	if(status & LIMB_DESTROYED) //Missing limb is missing
		return FALSE
	if(status & LIMB_BROKEN) // Causes things to drop and may be healed by bonemending chem.
		return TRUE

	if(brute_dam || burn_dam)
		return TRUE
	if(knitting_time > 0)
		return TRUE
	update_wounds()
	return FALSE

/obj/limb/process()
	// Process wounds, doing healing etc. Only do this every few ticks to save processing power
	if(owner.life_tick % wound_update_accuracy == 0)
		update_wounds()

	//Chem traces slowly vanish
	if(owner.life_tick % 10 == 0)
		for(var/chemID in trace_chemicals)
			trace_chemicals[chemID] = trace_chemicals[chemID] - 1
			if(trace_chemicals[chemID] <= 0)
				trace_chemicals.Remove(chemID)

	//Bone fractures
	if(!(status & LIMB_BROKEN))
		perma_injury = 0
	if(knitting_time > 0)
		if(world.time > knitting_time)
			to_chat(owner, SPAN_WARNING("The bones in your [display_name] feel fully knitted."))
			owner.pain.apply_pain(-PAIN_BONE_BREAK)
			status &= ~LIMB_BROKEN //Let it be known that this code never unbroke the limb.
			knitting_time = -1

//Updating wounds. Handles wound natural I had some free spachealing, internal bleedings and infections
/obj/limb/proc/update_wounds()
	if((status & (LIMB_ROBOT|LIMB_SYNTHSKIN))) //Robotic limbs don't heal or get worse.
		return

	owner.recalculate_move_delay = TRUE

	var/wound_disappeared = FALSE
	for(var/datum/wound/W as anything in wounds)
		// we don't care about wounds after we heal them. We are not an antag simulator
		if(W.damage <= 0 && !W.internal)
			wounds -= W
			wound_disappeared = TRUE
			continue
			// let the GC handle the deletion of the wound

		// Internal wounds get worse over time. Low temperatures (cryo) stop them.
		if(W.internal)
			if(owner.bodytemperature < T0C && (owner.reagents.get_reagent_amount("cryoxadone") || owner.reagents.get_reagent_amount("clonexadone"))) // IB is healed in cryotubes
				if(W.created + 2 MINUTES <= world.time) // sped up healing due to cryo magics
					remove_all_bleeding(FALSE, TRUE)
					wounds -= W
					wound_disappeared = TRUE
					if(istype(owner.loc, /obj/structure/machinery/cryo_cell)) // check in case they cheesed the location
						var/obj/structure/machinery/cryo_cell/cell = owner.loc
						cell.display_message("internal bleeding is")
			if(owner.reagents.get_reagent_amount("thwei") >= 0.05)
				remove_all_bleeding(FALSE, TRUE)

		// slow healing
		var/heal_amt = 0

		// if damage >= 50 AFTER treatment then it's probably too severe to heal within the timeframe of a round.
		if (W.can_autoheal() && owner.health >= 0 && !W.is_treated() && owner.bodytemperature > owner.species.cold_level_1)
			heal_amt += 0.3 * 0.35 //They can't autoheal if in critical
		else if (W.is_treated())
			heal_amt += 0.5 * 0.75 //Treated wounds heal faster

		if(heal_amt)
			//we only update wounds once in [wound_update_accuracy] ticks so have to emulate realtime
			heal_amt = heal_amt * wound_update_accuracy
			//configurable regen speed woo, no-regen hardcore or instaheal hugbox, choose your destiny
			heal_amt = heal_amt * CONFIG_GET(number/organ_regeneration_multiplier)
			// amount of healing is spread over all the wounds
			heal_amt = heal_amt / (length(wounds) + 1)
			// making it look prettier on scanners
			heal_amt = round(heal_amt,0.1)

			if(W.damage_type == BRUISE || W.damage_type == CUT)
				owner.pain.apply_pain(-heal_amt, BRUTE)
			else if(W.damage_type == BURN)
				owner.pain.apply_pain(-heal_amt, BURN)
			else
				owner.pain.recalculate_pain()

			W.heal_damage(heal_amt)

	// sync the organ's damage with its wounds
	update_damages()
	owner.update_damage_overlays()
	if(wound_disappeared)
		owner.update_med_icon()
		remove_wound_bleeding()

//Updates brute_damn and burn_damn from wound damages.
/obj/limb/proc/update_damages()
	number_wounds = 0
	brute_dam = 0
	burn_dam = 0

	for(var/datum/wound/W as anything in wounds)
		if(W.damage_type == CUT || W.damage_type == BRUISE)
			brute_dam += W.damage
		else if(W.damage_type == BURN)
			burn_dam += W.damage

		number_wounds += W.amount

/// updates the various internal variables of the limb from the owner
/obj/limb/proc/update_limb()
	SHOULD_CALL_PARENT(TRUE)

	var/datum/skin_color/owner_skin_color = GLOB.skin_color_list[owner?.skin_color]

	if(owner_skin_color)
		skin_color = owner_skin_color.icon_name
	else
		skin_color = "pale2"

	var/datum/body_type/owner_body_type = GLOB.body_type_list[owner?.body_type]

	if(owner_body_type)
		body_type = owner_body_type.icon_name
	else
		body_type = "lean"

	var/datum/body_type/owner_body_size = GLOB.body_size_list[owner?.body_size]

	if(owner_body_size)
		body_size = owner_body_size.icon_name
	else
		body_size = "avg"

	if(isspeciesyautja(owner))
		skin_color = owner.skin_color
		body_type = owner.body_type

	species = owner?.species ? owner.species : GLOB.all_species[SPECIES_HUMAN]
	limb_gender = get_limb_gender()

/obj/limb/proc/get_limb_gender()
	return owner?.gender ? owner.gender : FEMALE

/obj/limb/chest/get_limb_gender()
	if(owner && owner.body_presentation)
		return owner.body_presentation

	return owner?.gender ? owner.gender : FEMALE

/// generates a list of overlays that should be applied to the owner
/obj/limb/proc/get_limb_icon()
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/list)

	. = list()

	if(parent?.status & LIMB_DESTROYED)
		return

	if(status & LIMB_DESTROYED)
		if(has_stump_icon && !(status & LIMB_AMPUTATED))
			. += image('icons/mob/humans/dam_human.dmi', "stump_[icon_name]_blood", -DAMAGE_LAYER)
		return

	var/image/limb = image(layer = -BODYPARTS_LAYER)

	if ((status & LIMB_ROBOT) && !(owner.species && owner.species.flags & IS_SYNTHETIC))
		limb.icon = 'icons/mob/robotic.dmi'
		limb.icon_state = "[icon_name]"
		. += limb
		return

	limb.icon = species.icobase
	limb.icon_state = "[get_limb_icon_name(species, body_size, body_type, limb_gender, icon_name, skin_color)]"

	. += limb

	return

/// generates a key for the purpose of caching the icon to avoid duplicate generations
/obj/limb/proc/get_limb_icon_key()
	SHOULD_CALL_PARENT(TRUE)

	return "[species.name]-[body_size]-[body_type]-[limb_gender]-[icon_name]-[skin_color]-[status]"

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
	owner.update_body()
	for(var/obj/limb/O as anything in children)
		O.setAmputatedTree()

/mob/living/carbon/human/proc/remove_random_limb(delete_limb = 0)
	var/list/limbs_to_remove = list()
	for(var/obj/limb/E in limbs)
		if(istype(E, /obj/limb/chest) || istype(E, /obj/limb/groin) || istype(E, /obj/limb/head))
			continue
		limbs_to_remove += E
	if(length(limbs_to_remove))
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
/obj/limb/proc/droplimb(amputation, delete_limb = 0, cause, surgery_in_progress)
	if(!owner)
		return
	if(status & LIMB_DESTROYED)
		return
	else
		if(body_part == BODY_FLAG_CHEST)
			return
		stop_processing()
		if(status & LIMB_SYNTHSKIN)
			status = LIMB_DESTROYED|LIMB_SYNTHSKIN
		else if(status & LIMB_ROBOT)
			status = LIMB_DESTROYED|LIMB_ROBOT
		else
			status = LIMB_DESTROYED|LIMB_ORGANIC
			owner.pain.apply_pain(PAIN_BONE_BREAK)
		if(amputation)
			status |= LIMB_AMPUTATED
		for(var/i in implants)
			implants -= i
			if(is_sharp(i) || istype(i, /obj/item/shard/shrapnel))
				owner.embedded_items -= i
			qdel(i)

		remove_all_bleeding(TRUE, TRUE)

		if(hidden)
			hidden.forceMove(owner.loc)
			hidden = null

		// If any organs are attached to this, destroy them
		for(var/obj/limb/O in children)
			O.droplimb(amputation, delete_limb, cause)

		//Replace all wounds on that arm with one wound on parent organ.
		wounds.Cut()
		if(parent && !amputation)
			var/datum/wound/W
			if(max_damage < 50)
				W = new/datum/wound/lost_limb/small(max_damage)
			else
				W = new/datum/wound/lost_limb(max_damage)

			parent.wounds += W
			parent.update_damages()
		update_damages()

		//Remove suture datum.
		SEND_SIGNAL(src, COMSIG_LIMB_REMOVE_SUTURES)

		//we reset the surgery related variables unless this was done as part of a surgery.
		if(!surgery_in_progress)
			reset_limb_surgeries()

		var/obj/organ //Dropped limb object
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
				owner.lip_style = null
				owner.update_hair()
				if(owner.species)
					owner.species.handle_head_loss(owner)
			if(BODY_FLAG_ARM_RIGHT)
				if(status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
					organ = new /obj/item/robot_parts/arm/r_arm(owner.loc)
				else
					organ = new /obj/item/limb/arm/r_arm(owner.loc, owner)
				if(owner.w_uniform && !amputation)
					var/obj/item/clothing/under/U = owner.w_uniform
					U.removed_parts |= body_part
					owner.update_inv_w_uniform()
			if(BODY_FLAG_ARM_LEFT)
				if(status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
					organ = new /obj/item/robot_parts/arm/l_arm(owner.loc)
				else
					organ = new /obj/item/limb/arm/l_arm(owner.loc, owner)
				if(owner.w_uniform && !amputation)
					var/obj/item/clothing/under/U = owner.w_uniform
					U.removed_parts |= body_part
					owner.update_inv_w_uniform()
			if(BODY_FLAG_LEG_RIGHT)
				if(status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
					organ = new /obj/item/robot_parts/leg/r_leg(owner.loc)
				else
					organ = new /obj/item/limb/leg/r_leg(owner.loc, owner)
				if(owner.w_uniform && !amputation)
					var/obj/item/clothing/under/U = owner.w_uniform
					U.removed_parts |= body_part
					owner.update_inv_w_uniform()
			if(BODY_FLAG_LEG_LEFT)
				if(status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
					organ = new /obj/item/robot_parts/leg/l_leg(owner.loc)
				else
					organ = new /obj/item/limb/leg/l_leg(owner.loc, owner)
				if(owner.w_uniform && !amputation)
					var/obj/item/clothing/under/U = owner.w_uniform
					U.removed_parts |= body_part
					owner.update_inv_w_uniform()
			if(BODY_FLAG_HAND_RIGHT)
				if(status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
					organ = new /obj/item/robot_parts/hand/r_hand(owner.loc)
				else
					organ = new /obj/item/limb/hand/r_hand(owner.loc, owner)
				owner.drop_inv_item_on_ground(owner.gloves, null, TRUE)
				owner.drop_inv_item_on_ground(owner.r_hand, null, TRUE)
			if(BODY_FLAG_HAND_LEFT)
				if(status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
					organ = new /obj/item/robot_parts/hand/l_hand(owner.loc)
				else
					organ = new /obj/item/limb/hand/l_hand(owner.loc, owner)
				owner.drop_inv_item_on_ground(owner.gloves, null, TRUE)
				owner.drop_inv_item_on_ground(owner.l_hand, null, TRUE)
			if(BODY_FLAG_FOOT_RIGHT)
				if(status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
					organ = new /obj/item/robot_parts/foot/r_foot(owner.loc)
				else
					organ = new /obj/item/limb/foot/r_foot(owner.loc, owner)
				owner.drop_inv_item_on_ground(owner.shoes, null, TRUE)
			if(BODY_FLAG_FOOT_LEFT)
				if(status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
					organ = new /obj/item/robot_parts/foot/l_foot(owner.loc)
				else
					organ = new /obj/item/limb/foot/l_foot(owner.loc, owner)
				owner.drop_inv_item_on_ground(owner.shoes, null, TRUE)

		if(delete_limb)
			qdel(organ)
		else
			owner.visible_message(SPAN_WARNING("[owner.name]'s [display_name] flies off in an arc!"),
			SPAN_HIGHDANGER("<b>Your [display_name] goes flying off!</b>"),
			SPAN_WARNING("You hear a terrible sound of ripping tendons and flesh!"), 3)

			// Checks if the mob can feel pain or if they have at least oxycodone level of painkiller
			if(body_part != BODY_FLAG_HEAD && owner.pain.feels_pain && owner.pain.reduction_pain < PAIN_REDUCTION_HEAVY)
				INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob, emote), pick("pain", "scream"))

			if(organ)
				//Throw organs around
				var/dir_to_throw = pick(GLOB.cardinals)
				step(organ,dir_to_throw)

		owner.update_body() //Among other things, this calls update_icon() and updates our visuals.
		owner.update_med_icon()

		// OK so maybe your limb just flew off, but if it was attached to a pair of cuffs then hooray! Freedom!
		release_restraints()

		if(vital)
			var/mob/caused_mob
			if(istype(cause, /mob))
				caused_mob = cause
			if(!istype(cause, /datum/cause_data))
				cause = create_cause_data("lost vital limb", caused_mob)
			owner.death(cause)

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
		owner.visible_message(
			"\The [owner.handcuffed.name] falls off of [owner.name].",
			"\The [owner.handcuffed.name] falls off you.")

		owner.drop_inv_item_on_ground(owner.handcuffed)

	if (owner.legcuffed && (body_part in list(BODY_FLAG_FOOT_LEFT, BODY_FLAG_FOOT_RIGHT, BODY_FLAG_LEG_LEFT, BODY_FLAG_LEG_RIGHT)))
		owner.visible_message(
			"\The [owner.legcuffed.name] falls off of [owner.name].",
			"\The [owner.legcuffed.name] falls off you.")

		owner.drop_inv_item_on_ground(owner.legcuffed)

/**bandages brute wounds and removes bleeding. Returns WOUNDS_BANDAGED if at least one wound was bandaged. Returns WOUNDS_ALREADY_TREATED
if a relevant wound exists but none were treated. Skips wounds that are already bandaged.
treat_sutured var tells it to apply to sutured but unbandaged wounds, for trauma kits that heal damage directly.**/
/obj/limb/proc/bandage(treat_sutured)
	remove_all_bleeding(TRUE)
	var/wounds_exist = FALSE
	var/applied_bandage = FALSE
	for(var/datum/wound/W as anything in wounds)
		if(W.internal || W.damage_type == BURN)
			continue
		wounds_exist = TRUE
		switch(W.bandaged & (WOUND_BANDAGED|WOUND_SUTURED))
			if(WOUND_BANDAGED, (WOUND_BANDAGED|WOUND_SUTURED))
				continue
			if(WOUND_SUTURED)
				if(!treat_sutured)
					continue
		applied_bandage = TRUE
		W.bandaged |= WOUND_BANDAGED
	owner.update_med_icon()
	if(applied_bandage)
		return WOUNDS_BANDAGED
	else if(wounds_exist)
		return WOUNDS_ALREADY_TREATED

///Checks for bandageable wounds (type = CUT or type = BRUISE). Returns TRUE if all are bandaged, FALSE if not.
/obj/limb/proc/is_bandaged()
	for(var/datum/wound/W as anything in wounds)
		if(W.internal || W.damage_type == BURN)
			continue
		if(W.bandaged)
			. = TRUE
		else
			return FALSE

/**salves burn wounds. Returns WOUNDS_BANDAGED if at least one wound was salved. Returns WOUNDS_ALREADY_TREATED if a relevant wound exists but none were treated.
Skips wounds that are already salved.
treat_grafted var tells it to apply to grafted but unsalved wounds, for burn kits that heal damage directly.**/
/obj/limb/proc/salve(treat_grafted)
	var/burns_exist = FALSE
	var/applied_salve = FALSE
	for(var/datum/wound/W as anything in wounds)
		if(W.internal || W.damage_type != BURN)
			continue
		burns_exist = TRUE
		switch(W.salved & (WOUND_BANDAGED|WOUND_SUTURED))
			if(WOUND_BANDAGED, (WOUND_BANDAGED|WOUND_SUTURED))
				continue
			if(WOUND_SUTURED)
				if(!treat_grafted)
					continue
		applied_salve = TRUE
		W.salved |= WOUND_BANDAGED
	if(applied_salve)
		return WOUNDS_BANDAGED
	else if(burns_exist)
		return WOUNDS_ALREADY_TREATED

///Checks for salveable wounds (type = BURN). Returns TRUE if all are salved, FALSE if not.
/obj/limb/proc/is_salved()
	for(var/datum/wound/W as anything in wounds)
		if(W.internal || W.damage_type != BURN)
			continue
		if(W.salved)
			. = TRUE
		else
			return FALSE

/obj/limb/proc/fracture(bonebreak_probability)
	if(status & (LIMB_BROKEN|LIMB_DESTROYED|LIMB_UNCALIBRATED_PROSTHETIC|LIMB_SYNTHSKIN))
		if (knitting_time != -1)
			knitting_time = -1
			to_chat(owner, SPAN_WARNING("You feel your [display_name] stop knitting together as it absorbs damage!"))
		return

	if(owner.status_flags & NO_PERMANENT_DAMAGE)
		owner.visible_message(
			SPAN_WARNING("[owner] withstands the blow!"),
			SPAN_WARNING("Your [display_name] withstands the blow!"))
		return

	//stops division by zero
	if(owner.chem_effect_flags & CHEM_EFFECT_RESIST_FRACTURE)
		bonebreak_probability = 0

	//If you have this special flag you are exempt from the endurance bone break check
	if(owner.species.flags & SPECIAL_BONEBREAK)
		bonebreak_probability = 100

	if(!owner.skills)
		bonebreak_probability = null

	//if the chance was not set by what called fracture(), the endurance check is done instead
	if(bonebreak_probability == null) //bone break chance is based on endurance, 25% for survivors, erts, 100% for most everyone else.
		bonebreak_probability = 100 / clamp(owner.skills?.get_skill_level(SKILL_ENDURANCE)-1,1,100) //can't be zero

	var/list/bonebreak_data = list("bonebreak_probability" = bonebreak_probability)
	SEND_SIGNAL(owner, COMSIG_HUMAN_BONEBREAK_PROBABILITY, bonebreak_data)
	bonebreak_probability = bonebreak_data["bonebreak_probability"]

	if(prob(bonebreak_probability))
		owner.recalculate_move_delay = TRUE
		if(status & (LIMB_ROBOT))
			owner.visible_message(
				SPAN_WARNING("You see sparks coming from [owner]'s [display_name]!"),
				SPAN_HIGHDANGER("Something feels like it broke in your [display_name] as it spits out sparks!"),
				SPAN_HIGHDANGER("You hear electrical sparking!"))
			var/datum/effect_system/spark_spread/spark_system = new()
			spark_system.set_up(5, 0, owner)
			spark_system.attach(owner)
			spark_system.start()
			QDEL_IN(spark_system, 1 SECONDS)
		else
			owner.visible_message(
				SPAN_WARNING("You hear a loud cracking sound coming from [owner]!"),
				SPAN_HIGHDANGER("Something feels like it shattered in your [display_name]!"),
				SPAN_HIGHDANGER("You hear a sickening crack!"))
			playsound(owner, "bone_break", 45, TRUE)
		start_processing()
		if(status & LIMB_ROBOT)
			status = LIMB_ROBOT|LIMB_UNCALIBRATED_PROSTHETIC
			if(parent)
				if(parent.status & LIMB_ROBOT)
					parent.status = LIMB_ROBOT|LIMB_UNCALIBRATED_PROSTHETIC
			for(var/obj/limb/l as anything in children)
				if(l.status & LIMB_ROBOT)
					l.status = LIMB_ROBOT|LIMB_UNCALIBRATED_PROSTHETIC
		else
			status |= LIMB_BROKEN
			owner.pain.apply_pain(PAIN_BONE_BREAK)
			broken_description = pick("broken","fracture","hairline fracture")
			perma_injury = min_broken_damage
	else
		owner.visible_message(
			SPAN_WARNING("[owner] seems to withstand the blow!"),
			SPAN_WARNING("Your [display_name] manages to withstand the blow!"))

/obj/limb/proc/robotize(surgery_in_progress, uncalibrated, synth_skin)
	if(synth_skin)
		status = LIMB_SYNTHSKIN
	else if(uncalibrated) //Newly-attached prosthetics need to be calibrated to function.
		status = LIMB_ROBOT|LIMB_UNCALIBRATED_PROSTHETIC
	else
		status = LIMB_ROBOT

	stop_processing()

	if(!surgery_in_progress) //So as to not interrupt an ongoing prosthetic-attaching operation.
		reset_limb_surgeries()

	perma_injury = 0
	for(var/obj/limb/T as anything in children)
		T.robotize(uncalibrated = uncalibrated, synth_skin = synth_skin)

	owner.update_body(TRUE)

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
	return max(brute_dam + burn_dam, perma_injury) //could use health?


/obj/limb/proc/is_usable()
	return !(status & (LIMB_DESTROYED|LIMB_MUTATED|LIMB_UNCALIBRATED_PROSTHETIC))

/obj/limb/proc/is_broken()
	return ((status & LIMB_BROKEN) && !(status & LIMB_SPLINTED))

/obj/limb/proc/is_malfunctioning()
	if(status & LIMB_ROBOT)
		return prob(brute_dam + burn_dam)
	else if(status & LIMB_SYNTHSKIN && (brute_dam + burn_dam) > 10)
		return prob(brute_dam + burn_dam)

//for arms and hands
/obj/limb/proc/process_grasp(obj/item/c_hand, hand_name)
	if (!c_hand)
		return

	if(is_broken())
		if(prob(15))
			owner.drop_inv_item_on_ground(c_hand)
			var/emote_scream = pick("screams in pain and", "lets out a sharp cry and", "cries out and")
			owner.emote("me", 1, "[(!owner.pain.feels_pain) ? "" : emote_scream ] drops what they were holding in their [hand_name]!")
	if(is_malfunctioning())
		if(prob(10))
			owner.drop_inv_item_on_ground(c_hand)
			owner.emote("me", 1, "drops what they were holding, their [hand_name] malfunctioning!")
			var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
			spark_system.set_up(5, 0, owner)
			spark_system.attach(owner)
			spark_system.start()
			QDEL_IN(spark_system, 1 SECONDS)

/obj/limb/proc/embed(obj/item/W, silent = 0)
	if(!W || QDELETED(W) || (W.flags_item & (NODROP|DELONDROP)) || W.embeddable == FALSE)
		return
	if(!silent)
		owner.visible_message(SPAN_DANGER("\The [W] sticks in the wound!"))
	implants += W
	start_processing()

	if(is_sharp(W) || istype(W, /obj/item/shard/shrapnel))
		W.embedded_organ = src
		owner.embedded_items += W
		if(is_sharp(W)) // Only add the verb if its not a shrapnel
			add_verb(owner, /mob/proc/yank_out_object)
	W.add_mob_blood(owner)

	if(ismob(W.loc))
		var/mob/living/H = W.loc
		H.drop_held_item()
	if(W)
		W.forceMove(owner)

/obj/limb/proc/apply_splints(obj/item/stack/medical/splint/splint, mob/living/user, mob/living/carbon/human/target, indestructible_splints = FALSE)
	if(!(status & LIMB_DESTROYED) && !(status & LIMB_SPLINTED))
		var/time_to_take = 5 SECONDS
		if (target == user)
			user.visible_message(SPAN_WARNING("[user] fumbles with [splint]"), SPAN_WARNING("You fumble with [splint]..."))
			time_to_take = 15 SECONDS

		if(do_after(user, time_to_take * user.get_skill_duration_multiplier(SKILL_MEDICAL), INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, target, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
			var/possessive = "[user == target ? "your" : "\the [target]'s"]"
			var/possessive_their = "[user == target ? user.gender == MALE ? "his" : "her" : "\the [target]'s"]"
			user.affected_message(target,
				SPAN_HELPFUL("You finish applying <b>[splint]</b> to [possessive] [display_name]."),
				SPAN_HELPFUL("[user] finishes applying <b>[splint]</b> to your [display_name]."),
				SPAN_NOTICE("[user] finishes applying [splint] to [possessive_their] [display_name]."))
			status |= LIMB_SPLINTED
			SEND_SIGNAL(src, COMSIG_LIVING_LIMB_SPLINTED, user)
			if(indestructible_splints)
				status |= LIMB_SPLINTED_INDESTRUCTIBLE

			if(status & LIMB_BROKEN)
				owner.pain.apply_pain(-PAIN_BONE_BREAK_SPLINTED)
			else
				owner.pain.apply_pain(PAIN_BONE_BREAK_SPLINTED)
			. = TRUE
			owner.update_med_icon()

///called when limb is removed or robotized, any ongoing surgery and related vars are reset unless set otherwise.
/obj/limb/proc/reset_limb_surgeries()
	owner.incision_depths[name] = SURGERY_DEPTH_SURFACE
	owner.active_surgeries[name] = null

/obj/limb/proc/get_damage_overlays()
	. = list()

	damage_state = damage_state_text()
	var/brutestate = copytext(damage_state, 1, 2)
	if(brutestate != "0")
		wound_overlay.icon_state = "grayscale_[icon_name]_[brutestate]"
		. += wound_overlay

	var/burnstate = copytext(damage_state, 2)
	if(burnstate != "0")
		burn_overlay.icon_state = "burn_[icon_name]_[burnstate]"
		. += wound_overlay

/*
			LIMB TYPES
*/

/obj/limb/chest
	name = "chest"
	icon_name = "torso"
	display_name = "chest"
	cavity = "thoracic cavity"
	max_damage = 200
	min_broken_damage = 30
	body_part = BODY_FLAG_CHEST
	vital = 1
	encased = "ribcage"
	splint_icon_amount = 4
	bandage_icon_amount = 4

/obj/limb/groin
	name = "groin"
	icon_name = "groin"
	display_name = "groin"
	cavity = "abdominal cavity"
	max_damage = 200
	min_broken_damage = 30
	body_part = BODY_FLAG_GROIN
	vital = 1
	splint_icon_amount = 1
	bandage_icon_amount = 2

/obj/limb/groin/can_emp_delimb()
	if(status & (LIMB_ROBOT | LIMB_SYNTHSKIN))
		return FALSE

	return TRUE

/obj/limb/leg
	name = "leg"
	display_name = "leg"
	max_damage = 35
	min_broken_damage = 20

/obj/limb/foot
	name = "foot"
	display_name = "foot"
	max_damage = 30
	min_broken_damage = 20
	can_bleed_internally = FALSE

/obj/limb/arm
	name = "arm"
	display_name = "arm"
	max_damage = 35
	min_broken_damage = 20

/obj/limb/hand
	name = "hand"
	display_name = "hand"
	max_damage = 30
	min_broken_damage = 20
	can_bleed_internally = FALSE

/obj/limb/arm/l_arm
	name = "l_arm"
	display_name = "left arm"
	icon_name = "l_arm"
	body_part = BODY_FLAG_ARM_LEFT
	has_stump_icon = TRUE

/obj/limb/arm/l_arm/process()
	..()
	process_grasp(owner.l_hand, "left hand")

/obj/limb/leg/l_leg
	name = "l_leg"
	display_name = "left leg"
	icon_name = "l_leg"
	body_part = BODY_FLAG_LEG_LEFT
	icon_position = LEFT
	has_stump_icon = TRUE

/obj/limb/arm/r_arm
	name = "r_arm"
	display_name = "right arm"
	icon_name = "r_arm"
	body_part = BODY_FLAG_ARM_RIGHT
	has_stump_icon = TRUE

/obj/limb/arm/r_arm/process()
	..()
	process_grasp(owner.r_hand, "right hand")

/obj/limb/leg/r_leg
	name = "r_leg"
	display_name = "right leg"
	icon_name = "r_leg"
	body_part = BODY_FLAG_LEG_RIGHT
	icon_position = RIGHT
	has_stump_icon = TRUE

/obj/limb/foot/l_foot
	name = "l_foot"
	display_name = "left foot"
	icon_name = "l_foot"
	body_part = BODY_FLAG_FOOT_LEFT
	icon_position = LEFT
	has_stump_icon = TRUE

/obj/limb/foot/r_foot
	name = "r_foot"
	display_name = "right foot"
	icon_name = "r_foot"
	body_part = BODY_FLAG_FOOT_RIGHT
	icon_position = RIGHT
	has_stump_icon = TRUE

/obj/limb/hand/r_hand
	name = "r_hand"
	display_name = "right hand"
	icon_name = "r_hand"
	body_part = BODY_FLAG_HAND_RIGHT
	has_stump_icon = TRUE

/obj/limb/hand/r_hand/process()
	..()
	process_grasp(owner.r_hand, "right hand")

/obj/limb/hand/l_hand
	name = "l_hand"
	display_name = "left hand"
	icon_name = "l_hand"
	body_part = BODY_FLAG_HAND_LEFT
	has_stump_icon = TRUE

/obj/limb/hand/l_hand/process()
	..()
	process_grasp(owner.l_hand, "left hand")

/obj/limb/head
	name = "head"
	icon_name = "head"
	display_name = "head"
	cavity = "cranial cavity"
	max_damage = 60
	min_broken_damage = 30
	body_part = BODY_FLAG_HEAD
	vital = 1
	encased = "skull"
	has_stump_icon = TRUE
	splint_icon_amount = 4
	bandage_icon_amount = 4

	var/eyes_r
	var/eyes_g
	var/eyes_b

	var/lip_style

/obj/limb/head/update_limb()
	. = ..()

	eyes_r = owner.r_eyes
	eyes_g = owner.g_eyes
	eyes_b = owner.b_eyes

	lip_style = owner.lip_style

/obj/limb/head/get_limb_icon()
	. = ..()

	var/image/eyes = image('icons/mob/humans/onmob/human_face.dmi', species.eyes, layer = -BODYPARTS_LAYER)
	eyes.color = list(null, null, null, null, rgb(owner.r_eyes, owner.g_eyes, owner.b_eyes))
	. += eyes

	if(HAS_TRAIT(owner, TRAIT_INTENT_EYES))
		. += emissive_appearance(icon = 'icons/mob/humans/onmob/human_face.dmi', icon_state = species.eyes)

	if(lip_style && (species && species.flags & HAS_LIPS))
		var/image/lips = image('icons/mob/humans/onmob/human_face.dmi', "paint_[lip_style]", layer = -BODYPARTS_LAYER)
		. += lips

/obj/limb/head/get_limb_icon_key()
	. = ..()

	return "[.]-[eyes_r]-[eyes_g]-[eyes_b]-[lip_style]"

/obj/limb/head/take_damage(brute, burn, sharp, edge, used_weapon = null,\
							list/forbidden_limbs = list(), no_limb_loss,\
							mob/attack_source = null,\
							brute_reduced_by = -1, burn_reduced_by = -1)
	. = ..()

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

/obj/limb/head/limb_delimb(damage_source)
	var/obj/item/clothing/head/helmet/owner_helmet = owner.head

	if(!istype(owner_helmet) || (issynth(owner) && !owner.allow_gun_usage))
		droplimb(0, 0, damage_source)
		return

	if(owner_helmet.flags_inventory & FULL_DECAP_PROTECTION)
		return

	owner.visible_message("[owner]'s [owner_helmet] goes flying off from the impact!", SPAN_USERDANGER("Your [owner_helmet] goes flying off from the impact!"))
	owner.drop_inv_item_on_ground(owner_helmet)
	INVOKE_ASYNC(owner_helmet, TYPE_PROC_REF(/atom/movable, throw_atom), pick(RANGE_TURFS(1, get_turf(owner))), 1, SPEED_FAST)
	playsound(owner, 'sound/effects/helmet_noise.ogg', 100)
