/* Gameplay Phases */
#define TUTORIAL_HM_PHASE_PREP 0	//! Prep time upon joining, time for players to gear up
#define TUTORIAL_HM_PHASE_MAIN 1	//! Regular round, locks the prep room, spawns up to 5 patients with injuries of any severity
#define TUTORIAL_HM_PHASE_RESUPPLY 2	//! Pauses gameplay, opens the prep room, and allows resupply time, happens at random
#define TUTORIAL_HM_PHASE_NIGHTMARE 3	//! Simulates a Mass-Casualty event, 3-5 patients with severe damage levels

/// How quickly HM tutorial sandbox difficulty increases over time (and how likely a Mass-Cas becomes)
#define TUTORIAL_HM_DIFFICULTY_INCREASE (1/2)

/* Injury Severity Levels */
#define TUTORIAL_HM_INJURY_SEVERITY_BOOBOO 1.5	//! Boo-boos that take less than 5 seconds to fix
#define TUTORIAL_HM_INJURY_SEVERITY_MINOR 3
#define TUTORIAL_HM_INJURY_SEVERITY_ROUTINE 4	//! Routine treatments, occasional IB, 1-2 fractures, moderate damage less than 200, minor ODs, eye damage ONLY
#define TUTORIAL_HM_INJURY_SEVERITY_SEVERE 5	//! Life-threatening injuries, organ damage, missing limbs, up to 250 damage, multiple fracs, low blood
#define TUTORIAL_HM_INJURY_SEVERITY_FATAL 6	//! Life-threatening injuries, organ damage, missing limbs, up to 300 damage, multiple fracs, low blood
#define TUTORIAL_HM_INJURY_SEVERITY_EXTREME 9	//! Fatal injuries, organ damage, missing limbs, up to 450 damage, multiple fracs, low blood
#define TUTORIAL_HM_INJURY_SEVERITY_MAXIMUM 12	//! No limit on injury types, damage ranging from 500-600, extremely rare outside of Mass-Cas events

/* Tiers of patients to be encountered in harder difficulties, and their types of damage */
#define PATIENT_TYPE_MUNDANE 1
#define PATIENT_TYPE_ORGAN 2
#define PATIENT_TYPE_TOXIN 3

/* Defines for the health_tasks_handler proc, tracking remaining complex injuries to be treated in a patient */
#define INTERNAL_BLEEDING "IB"
#define SUTURE "suture"
#define FRACTURE "fracture"

/datum/tutorial/marine/hospital_corpsman_sandbox
	name = "Marine - Hospital Corpsman (Sandbox)"
	desc = "Test your medical skills against an endless wave of wounded Marines!"
	tutorial_id = "marine_hm_3"
	required_tutorial = "marine_basic_1"
	icon_state = "medic"
	tutorial_template = /datum/map_template/tutorial/s15x10/hm

	/// holder for the CMO NPC
	var/mob/living/carbon/human/CMO_npc
	/// Current step of the tutorial we're at
	var/stage = TUTORIAL_HM_PHASE_PREP
	/// List of patient NPCs. Stored in relation to their end destination turf
	var/list/mob/living/carbon/human/realistic_dummy/agents = list()
	/// List of active dragging NPCs. Mobs on this list are ACTIVELY dragging a wounded marine
	var/list/mob/living/carbon/human/dragging_agents = list()
	/// List of ACTIVELY MOVING patient NPCs
	var/list/mob/living/carbon/human/realistic_dummy/active_agents = list()
	/// List of NPC inventory items that needs to be removed when they asked to leave
	var/list/obj/item/clothing/suit/storage/marine/medium/cleanup = list()
	/// Ref to any patient NPC actively moving
	var/mob/living/carbon/human/realistic_dummy/active_agent
	/// Ref to late-spawned patient NPC that has a chance to appear during a treatment phase
	var/mob/living/carbon/human/realistic_dummy/booboo_agent
	/// Ref to any dragging NPC, bringing a patient to the player
	var/mob/living/carbon/human/dragging_agent
	/// Spawn point for all NPCs except the CMO
	var/turf/agent_spawn_location
	/// List of injury severity levels in sequence
	var/static/list/difficulties = list(
		TUTORIAL_HM_INJURY_SEVERITY_BOOBOO,
		TUTORIAL_HM_INJURY_SEVERITY_MINOR,
		TUTORIAL_HM_INJURY_SEVERITY_ROUTINE,
		TUTORIAL_HM_INJURY_SEVERITY_SEVERE,
		TUTORIAL_HM_INJURY_SEVERITY_FATAL,
		TUTORIAL_HM_INJURY_SEVERITY_EXTREME,
		TUTORIAL_HM_INJURY_SEVERITY_MAXIMUM
	)
	/// Max amount of patient NPCs per survival wave (NOT including booboo NPCs)
	var/max_survival_agents = 3
	/// Min amount of patient NPCs per survival wave (NOT including booboo NPCs)
	var/min_survival_agents = 1
	/// Current survival wave
	var/survival_wave = 0
	/// Current survival wave difficulty (in terms of injury severity)
	var/survival_difficulty = TUTORIAL_HM_INJURY_SEVERITY_BOOBOO
	/// Holds a random timer per survival wave for a booboo agent to spawn
	var/booboo_timer
	/// Holds a timer which forces agents to stop processing movement, in case they are misbehaving
	var/terminate_movement_timer
	/// List of injuries on patient NPCs that must be treated before fully healed. Is only tested AFTER they pass 65% health
	var/list/mob/living/carbon/human/realistic_dummy/agent_healing_tasks = list()
	/// Wave number when the last resupply phase triggered. Will wait 3 waves before rolling again
	var/last_resupply_round = 1
	/// Wave number when the last mass-casualty (nightmare) phase triggered. Will wait 3 waves before rolling again
	var/last_masscas_round = 1
	/// Lists possible chemicals that can appear pre-medicated in patient NPCs in harder difficulties
	var/static/list/datum/reagent/medical/premeds = list(
		/datum/reagent/medical/tramadol,
		/datum/reagent/medical/bicaridine,
		/datum/reagent/medical/kelotane,
		/datum/reagent/medical/oxycodone
	)
	/// List of supply room vendors to be restocked before a supply phase
	var/list/supply_vendors = list()

/datum/tutorial/marine/hospital_corpsman_sandbox/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	START_PROCESSING(SSfastobj, src)
	init_mob()
	init_npcs()
	message_to_player("Welcome to the Hospital Corpsman tutorial sandbox mode!")
	message_to_player("Gear up in your preferred HM kit, then press the orange 'Ready Up' arrow at the top of your HUD to begin the first round!")

/datum/tutorial/marine/hospital_corpsman_sandbox/proc/handle_round_progression()

	var/difficulty_upgrade_warning = null

	if(booboo_timer)
		deltimer(booboo_timer)
		booboo_timer = null
	if(terminate_movement_timer)
		deltimer(terminate_movement_timer)
		terminate_movement_timer = null
	// clears refs to old friends, since passed
	agent_healing_tasks = list()
	agents = list()
	dragging_agents = list()
	active_agents = list()

	switch(stage)
		if(TUTORIAL_HM_PHASE_RESUPPLY)
			return // sometimes it double-calls handle_round_progression()
		// Ensures that a resupply always follows a mass-cas, disregarding minimum rounds between
		// Lowers difficulty close to, if not slightly below baseline
		if(TUTORIAL_HM_PHASE_NIGHTMARE)
			stage = TUTORIAL_HM_PHASE_RESUPPLY
			survival_wave++
			survival_difficulty = pick(TUTORIAL_HM_INJURY_SEVERITY_MINOR, TUTORIAL_HM_INJURY_SEVERITY_ROUTINE)
			min_survival_agents = 1
			max_survival_agents = 3
			begin_supply_phase()
			return
	// 1 in 5 chance per round to trigger a resupply phase
	// Will only roll beyond wave 3, and 5 waves after the previous resupply phase.
	if(prob(20) && (survival_wave >= (last_resupply_round + 5)))
		begin_supply_phase()
		return
	survival_wave++
	// 1 in 5 chance per round to trigger a mass-cas (NIGHTMARE) phase
	// Will only roll beyond wave 3, and 5 waves after the previous mass-cas phase.
	if(prob(20) && (survival_wave >= (last_masscas_round + 5)))
		stage = TUTORIAL_HM_PHASE_NIGHTMARE
		// increases difficulty by 2 levels, but not beyond the max.
		for(var/i in 1 to 2)
			var/current_difficulty = survival_difficulty
			if(current_difficulty != TUTORIAL_HM_INJURY_SEVERITY_MAXIMUM)
				survival_difficulty = next_in_list(current_difficulty, difficulties)
		// heightened patient NPC spawn rates, from 4-6
		min_survival_agents = 4
		max_survival_agents = 6
		playsound(tutorial_mob.loc, 'sound/effects/siren.ogg', 50)
		message_to_player("Warning! Mass-Casualty event detected!")
		last_masscas_round = survival_wave
	// 50% chance per wave of increasing difficulty by one step
	// two round grace period from start
	else if(prob(TUTORIAL_HM_DIFFICULTY_INCREASE * 100) && !(survival_wave <= 2))
		var/current_difficulty = survival_difficulty
		if(current_difficulty != TUTORIAL_HM_INJURY_SEVERITY_MAXIMUM)
			survival_difficulty = next_in_list(current_difficulty, difficulties)
			difficulty_upgrade_warning = " Difficulty has increased, watch out!!"

	CMO_npc.say("Now entering round [survival_wave]![difficulty_upgrade_warning]")

	addtimer(CALLBACK(src, PROC_REF(spawn_agents)), 2 SECONDS)
	terminate_movement_timer = addtimer(CALLBACK(src, PROC_REF(terminate_agent_processing)), 15 SECONDS, TIMER_STOPPABLE)

/datum/tutorial/marine/hospital_corpsman_sandbox/proc/end_supply_phase()

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor, prep_door)
	var/turf/boundry = get_turf(loc_from_corner(4, 1))
	if(tutorial_mob.x <= boundry.x)
		message_to_player("Please exit the preparations room before progressing into the next round!")
		return
	prep_door.close(TRUE)
	prep_door.lock(TRUE)
	stage = TUTORIAL_HM_PHASE_MAIN
	remove_action(tutorial_mob, /datum/action/hm_tutorial/sandbox/ready_up)
	handle_round_progression()

/datum/tutorial/marine/hospital_corpsman_sandbox/proc/begin_supply_phase()

	restock_supply_room()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor, prep_door)
	prep_door.unlock(TRUE)
	prep_door.open()
	stage = TUTORIAL_HM_PHASE_MAIN // just in case it wasnt already

	if(last_resupply_round == 1)
		message_to_player("Phew! We have entered a resupply phase of the tutorial!")
		message_to_player("Use this rare opportunity to refill, restock, and resupply yourself for future rounds.")
		message_to_player("Remember, on the field, immediate resupply will not always be possible! You won't know for certain when your next chance will arrive, so stock up while you can!")
		message_to_player("When you are ready, leave the supply room, then click the 'Ready Up' action on the top left of your screen to begin your next round.")
	else
		message_to_player("Now enterering a resupply phase. Stock up while you can!")

	last_resupply_round = survival_wave
	give_action(tutorial_mob, /datum/action/hm_tutorial/sandbox/ready_up, null, null, src)

/datum/tutorial/marine/hospital_corpsman_sandbox/proc/restock_supply_room()

	for(var/obj/structure/machinery/cm_vending/sorted/medical/supply_vendor in supply_vendors)
		supply_vendor.populate_product_list(1.2)

/datum/tutorial/marine/hospital_corpsman_sandbox/proc/spawn_agents()
	SIGNAL_HANDLER

	for(var/i in 1 to (rand(min_survival_agents, max_survival_agents)))
		var/mob/living/carbon/human/realistic_dummy/active_agent = new(agent_spawn_location)
		arm_equipment(active_agent, /datum/equipment_preset/uscm/tutorial_rifleman)
		var/turf/dropoff_point = loc_from_corner(rand(6, 8), rand(1, 3))	// Picks a random turf to move the NPC to
		agents[active_agent] = dropoff_point
		active_agent.a_intent = INTENT_DISARM
		simulate_condition(active_agent)
		var/obj/item/clothing/suit/storage/marine/medium/armor = active_agent.get_item_by_slot(WEAR_JACKET)
		RegisterSignal(armor, COMSIG_ITEM_UNEQUIPPED, PROC_REF(item_cleanup))

	addtimer(CALLBACK(src, PROC_REF(eval_agent_status)), 3 SECONDS)	// Gives time for NPCs to pass out or die, if their condition is severe enough
	if((survival_difficulty >= TUTORIAL_HM_INJURY_SEVERITY_FATAL) && prob(75))	// If above difficulty FATAL, starts a random timer to spawn a booboo agent
		booboo_timer = addtimer(CALLBACK(src, PROC_REF(eval_booboo_agent)), (rand(15,25)) SECONDS, TIMER_STOPPABLE)

/datum/tutorial/marine/hospital_corpsman_sandbox/proc/simulate_condition(mob/living/carbon/human/target)
	SIGNAL_HANDLER

	// Simulates patient NPC injuries

	var/damage_amount_split = ((rand(1, 100)) / 100)	// How damage should be split between brute and burn
	var/list/limbs = target.limbs
	var/amount_of_parts = rand(1, 6)	// Amount of times to roll for a limb fracture
	var/patient_type = pick(75;PATIENT_TYPE_MUNDANE, 15;PATIENT_TYPE_ORGAN, 10;PATIENT_TYPE_TOXIN) // 75% chance for mundane damage, 15% for organ damage, 10% for toxin

	if(patient_type >= PATIENT_TYPE_MUNDANE)
		for(var/i in 1 to amount_of_parts)
			var/obj/limb/selected_limb = pick(limbs)
			var/damage_amount = (rand((40 * survival_difficulty), (50 * survival_difficulty)))
			selected_limb.take_damage(round((damage_amount * damage_amount_split) / amount_of_parts), round((damage_amount * (1 - damage_amount_split)) / amount_of_parts))
			if((damage_amount > 30) && prob(survival_difficulty * 10))
				selected_limb.fracture()
	if(patient_type == PATIENT_TYPE_ORGAN)	// applies organ damage AS WELL as mundane damage if type 2
		var/datum/internal_organ/organ = pick(target.internal_organs)
		target.apply_internal_damage(rand(1,(survival_difficulty*3.75)), "[organ.name]")
	else if(patient_type == PATIENT_TYPE_TOXIN)	// applies toxin damage AS WELL as mundane damage if type 3
		target.setToxLoss(rand(1,10*survival_difficulty))

	if(prob(40))	// Simulates premedicated patients
		var/datum/reagent/medical/reagent = pick(premeds)
		target.reagents.add_reagent(reagent.id, rand(5, reagent.overdose - 1))	// OD safety

	target.updatehealth()
	target.UpdateDamageIcon()
	RegisterSignal(target, COMSIG_HUMAN_HM_TUTORIAL_TREATED, PROC_REF(final_health_checks))
	RegisterSignal(target, COMSIG_HUMAN_SET_UNDEFIBBABLE, PROC_REF(make_agent_leave))	// perma detection

	RegisterSignal(target, COMSIG_LIVING_REJUVENATED, PROC_REF(make_agent_leave)) // for debugging

// 'bypass' variable used by the rejuvenate proc to override health checks
/datum/tutorial/marine/hospital_corpsman_sandbox/proc/final_health_checks(mob/living/carbon/human/target, bypass)
	SIGNAL_HANDLER

	// Makes sure complex injuries are treated once 70% health is reached

	var/list/healing_tasks = list()
	UnregisterSignal(target, COMSIG_HUMAN_HM_TUTORIAL_TREATED)
	for(var/obj/limb/limb as anything in target.limbs)
		var/list/injury_type = list()
		if((limb.status & LIMB_BROKEN) && !(limb.status & LIMB_SPLINTED))
			injury_type |= FRACTURE
			RegisterSignal(limb, COMSIG_LIVING_LIMB_SPLINTED, PROC_REF(health_tasks_handler))
		if(limb.can_bleed_internally)
			for(var/datum/wound/wound as anything in limb.wounds)
				if(wound.internal)
					injury_type |= INTERNAL_BLEEDING
					RegisterSignal(tutorial_mob, COMSIG_HUMAN_SURGERY_STEP_SUCCESS, PROC_REF(health_tasks_handler), TRUE) // yeah yeah, give me a break
		if(length(injury_type))
			healing_tasks[limb] = injury_type
	if(!length(healing_tasks) || bypass)
		make_agent_leave(target)
	else
		agent_healing_tasks[target] = healing_tasks

/datum/tutorial/marine/hospital_corpsman_sandbox/proc/health_tasks_handler(datum/source, mob/living/carbon/human/realistic_dummy/target, datum/surgery/surgery)
	SIGNAL_HANDLER

	var/list/healing_tasks = agent_healing_tasks[target]

	var/obj/limb/limb
	if(istype(source, /obj/limb)) // swaps around the variables from COMSIG_LIVING_LIMB_SPLINTED to make them consistent
		limb = source
		var/target_redirect = limb.owner
		health_tasks_handler(target, target_redirect)
		UnregisterSignal(limb, COMSIG_LIVING_LIMB_SPLINTED)
		return
	for(limb in healing_tasks)
		var/list/injury_type = list()
		injury_type |= healing_tasks[limb]
		if(surgery && limb == surgery.affected_limb)
			if(istype(surgery, /datum/surgery/internal_bleeding))
				injury_type -= INTERNAL_BLEEDING
				injury_type |= SUTURE
			if(istype(surgery, /datum/surgery/suture_incision))
				injury_type = healing_tasks[surgery.affected_limb]
				if(SUTURE in injury_type)
					injury_type -= SUTURE
		if((FRACTURE in injury_type) && (limb.status & LIMB_BROKEN) && (limb.status & LIMB_SPLINTED))
			injury_type -= FRACTURE
		if(!length(injury_type) && limb) // makes sure something DID exist on the list
			healing_tasks -= limb
		else
			healing_tasks[limb] = injury_type
	if(!length(healing_tasks))
		UnregisterSignal(tutorial_mob, COMSIG_HUMAN_SURGERY_STEP_SUCCESS)
		make_agent_leave(target)

/datum/tutorial/marine/hospital_corpsman_sandbox/proc/eval_agent_status()

	for(var/mob/living/carbon/human/target as anything in agents)
		if(target.stat != CONSCIOUS) // are they awake?
			var/mob/living/carbon/human/dragging_agent = new(target.loc)
			init_dragging_agent(dragging_agent)
			dragging_agent.do_pull(target)
			dragging_agents[dragging_agent] = target
			movement_handler()
		else
			active_agents |= target
			movement_handler()

/datum/tutorial/marine/hospital_corpsman_sandbox/proc/handle_speech(mob/living/carbon/human/target)

	var/list/help_me = list()

	if(target in dragging_agents)
		target.emote("medic")
		return
	if(prob(25))
		target.emote("medic")
		return
	for(var/obj/limb/limb as anything in target.limbs)
		if(limb.status & LIMB_BROKEN)
			var/targetlimb = limb.display_name
			help_me |= list("Need a [targetlimb] splint please Doc", "Splint [targetlimb]", "Can you splint my [targetlimb] please")

	help_me |= list(
		"Doc can I get some pills?",
		"Need a patch up please",
		"Im hurt Doc...",
		"Can I get some healthcare?",
		"Pill me real quick",
		"HEEEEEELP!!!",
		"M-Medic.. I'm dying",
		"I'll pay you 20 bucks to patch me up",
		"MEDIC!!!!! HEEEEEELP!!!!",
		"HEEEELP MEEEEEE!!!!!"
	)

	target.say("[pick(help_me)]")

/datum/tutorial/marine/hospital_corpsman_sandbox/proc/movement_handler()

	listclearnulls(dragging_agents)
	listclearnulls(active_agents)
	for(var/mob/living/carbon/human/dragging_agent as anything in dragging_agents)
		move_agent(dragging_agent, dragging_agents)
	for(var/mob/living/carbon/human/active_agent as anything in active_agents)
		move_agent(active_agent, active_agents)

/datum/tutorial/marine/hospital_corpsman_sandbox/proc/terminate_agent_processing()

	if(terminate_movement_timer)
		deltimer(terminate_movement_timer)
		terminate_movement_timer = null
	for(var/mob/living/carbon/human/dragging_agent as anything in dragging_agents)
		dragging_agent.stop_pulling()
		var/mob/living/carbon/human/dragging_target = dragging_agents[dragging_agent]
		if(dragging_target)
			active_agents |= dragging_target	// sorry bud, you'll have to get there yourself
		dragging_agents -= dragging_agent
		make_dragging_agent_leave(dragging_agent)
	for(var/mob/living/carbon/human/active_agent as anything in active_agents)
		var/turf/dropoff_point = loc_from_corner(rand(6, 8), rand(1, 3))
		active_agent.forceMove(dropoff_point)
		active_agents -= active_agent
	listclearnulls(dragging_agents)
	listclearnulls(active_agents)

/datum/tutorial/marine/hospital_corpsman_sandbox/proc/move_agent(mob/agent, list/agent_list)

	var/dropoff_point_offset
	var/mob/living/carbon/human/target = agent
	if(agent in dragging_agents)
		target = agent_list[agent]
		dropoff_point_offset = 1
	var/turf/dropoff_point = agents[target]
	var/step_direction
	var/turf/target_turf
	if(!dropoff_point)	// Something has gone horribly wrong
		terminate_agent_processing()
		return
	if(locate(agent) in agent_spawn_location)
		var/initial_step_direction = pick((agent_spawn_location.y) <= (dropoff_point.y) ? NORTH : SOUTH)
		target_turf = get_step(agent, initial_step_direction)
		agent.Move(target_turf, initial_step_direction)
	if((dropoff_point.x > (agent.x  + dropoff_point_offset)) || (dropoff_point.x < (agent.x  + dropoff_point_offset)))
		step_direction = pick((agent.x + dropoff_point_offset) > (dropoff_point.x) ? WEST : EAST)
		target_turf = get_step(agent, step_direction)
		agent.Move(target_turf, step_direction)
	else if(dropoff_point.x == (agent.x + dropoff_point_offset))
		if(((dropoff_point.y - agent.y) >= (1 + dropoff_point_offset)) || ((dropoff_point.y - agent.y) <= -(1 + dropoff_point_offset)))
			step_direction = pick((agent.y) > (dropoff_point.y) ? SOUTH : NORTH)
			target_turf = get_step(agent, step_direction)
			agent.Move(target_turf, step_direction)
			if(agent in dragging_agents)
				var/turf/drag_turf = get_step(agent, EAST)
				target.Move(drag_turf, EAST)
			return
		handle_speech(agent)
		target.Move(dropoff_point)
		if(agent in dragging_agents)
			agent.mob_flags |= IMMOBILE_ACTION
			agent.stop_pulling()
			agent_list -= agent
			make_dragging_agent_leave(agent)
		if(agent in active_agents)
			agent_list -= agent

/datum/tutorial/marine/hospital_corpsman_sandbox/proc/make_dragging_agent_leave(mob/living/carbon/human/dragging_agent)

	if(dragging_agent in dragging_agents)	// failsafe in case the dragging NPC never had their movement code stopped
		dragging_agents -= dragging_agent
	dragging_agent.density = FALSE
	QDEL_IN(dragging_agent, 2.5 SECONDS)
	animate(dragging_agent, 2.5 SECONDS, alpha = 0, easing = CUBIC_EASING)

// NOTE: bypass variable is a boolean used in the simulate_evac proc, used to stop to the balloon text from playing
/datum/tutorial/marine/hospital_corpsman_sandbox/proc/make_agent_leave(mob/living/carbon/human/realistic_dummy/agent, bypass)
	SIGNAL_HANDLER

	UnregisterSignal(agent, COMSIG_LIVING_REJUVENATED)
	UnregisterSignal(agent, COMSIG_HUMAN_SET_UNDEFIBBABLE)
	UnregisterSignal(agent, COMSIG_HUMAN_HM_TUTORIAL_TREATED)
	agent.updatehealth()
	if(!bypass)
		if(agent.undefibbable == TRUE)
			agent.balloon_alert_to_viewers("[agent.name] permanently dead!", null, DEFAULT_MESSAGE_RANGE, null, COLOR_RED)
			playsound(agent.loc, 'sound/items/defib_failed.ogg', 20)
		else
			agent.balloon_alert_to_viewers("[agent.name] fully treated!")
			playsound(agent.loc, 'sound/machines/terminal_success.ogg', 20)
	agents -= agent
	if(agent in active_agents) // failsafe in case patient NPC was healed, despite never reaching their dropzone
		active_agents -= agent
	QDEL_IN(agent, 2.5 SECONDS)
	animate(agent, 2.5 SECONDS, alpha = 0, easing = CUBIC_EASING)
	for(var/obj/item/clothing/suit/storage/marine/medium/armor as anything in cleanup)
		item_cleanup(armor)
	if(!length(agents))
		INVOKE_ASYNC(src, PROC_REF(handle_round_progression))

/datum/tutorial/marine/hospital_corpsman_sandbox/proc/eval_booboo_agent()
	SIGNAL_HANDLER

	var/mob/living/carbon/human/realistic_dummy/active_agent = new(agent_spawn_location)
	arm_equipment(active_agent, /datum/equipment_preset/uscm/tutorial_rifleman)
	var/turf/dropoff_point = loc_from_corner(rand(6, 8), rand(1, 3))
	agents[active_agent] = dropoff_point
	active_agent.a_intent = INTENT_DISARM

	var/damage_amount_split = ((rand(1, 100)) / 100)
	var/list/limbs = active_agent.limbs
	var/amount_of_parts = (rand(1, 6))

	for(var/i in 1 to amount_of_parts)
		var/obj/limb/selected_limb = pick(limbs)
		var/damage_amount = (rand((40 * TUTORIAL_HM_INJURY_SEVERITY_BOOBOO), (50 * TUTORIAL_HM_INJURY_SEVERITY_BOOBOO)))
		selected_limb.take_damage(round((damage_amount * damage_amount_split) / amount_of_parts), round((damage_amount * (1 - damage_amount_split)) / amount_of_parts))
		if((damage_amount > 30) && prob(TUTORIAL_HM_INJURY_SEVERITY_BOOBOO * 10))
			selected_limb.fracture()

	active_agent.updatehealth()
	active_agent.UpdateDamageIcon()
	active_agents |= active_agent
	RegisterSignal(active_agent, COMSIG_HUMAN_HM_TUTORIAL_TREATED, PROC_REF(make_agent_leave))
	RegisterSignal(active_agent, COMSIG_HUMAN_SET_UNDEFIBBABLE, PROC_REF(make_agent_leave))

/datum/tutorial/marine/hospital_corpsman_sandbox/proc/simulate_evac(datum/source, mob/living/carbon/human/target)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/bed/medevac_stretcher/prop, medevac_bed)

	var/list/status_message = list()

	for(var/datum/reagent/medical/chemical as anything in target.reagents.reagent_list)
		if(chemical.volume >= chemical.overdose_critical)
			status_message |= "Critical [chemical.name] overdose detected"
	for(var/datum/internal_organ/organ as anything in target.internal_organs)
		if(organ.damage >= organ.min_broken_damage)
			if((locate(/datum/reagent/medical/peridaxon) in target.reagents.reagent_list) || (target.stat == DEAD))
				status_message |= "Ruptured [organ.name] detected"
			else
				medevac_bed.balloon_alert_to_viewers("Organ damage detected! Please stabilize patient with Peridaxon before transit.", null, DEFAULT_MESSAGE_RANGE, null, COLOR_RED)
				playsound(medevac_bed.loc, 'sound/machines/twobeep.ogg', 20)
				return

	if(tutorial_mob == target)
		medevac_bed.balloon_alert_to_viewers("Error! Unable to self-evacuate!", null, DEFAULT_MESSAGE_RANGE, null, COLOR_RED)
		playsound(medevac_bed.loc, 'sound/machines/twobeep.ogg', 20)
		return
	if(length(status_message))
		medevac_bed.balloon_alert_to_viewers("[pick(status_message)]! Evacuating patient!!", null, DEFAULT_MESSAGE_RANGE, null, LIGHT_COLOR_BLUE)
		playsound(medevac_bed.loc, pick_weight(list('sound/machines/ping.ogg' = 9, 'sound/machines/juicer.ogg' = 1)), 20)
		make_agent_leave(target, TRUE)
		addtimer(CALLBACK(src, PROC_REF(animate_medevac_bed), target), 2.7 SECONDS)
	else
		medevac_bed.balloon_alert_to_viewers("Error! Patient condition does not warrant evacuation!", null, DEFAULT_MESSAGE_RANGE, null, COLOR_RED)
		playsound(medevac_bed.loc, 'sound/machines/twobeep.ogg', 20)
		return

/datum/tutorial/marine/hospital_corpsman_sandbox/proc/animate_medevac_bed(mob/living/carbon/human/target)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/bed/medevac_stretcher/prop, medevac_bed)
	medevac_bed.update_icon()
	flick("winched_stretcher", medevac_bed)

/datum/tutorial/marine/hospital_corpsman_sandbox/process(delta_time)

	if(length(dragging_agents) || length(active_agents))
		movement_handler()

/datum/tutorial/marine/hospital_corpsman_sandbox/proc/item_cleanup(obj/item/clothing/suit/storage/marine/medium/armor)
	SIGNAL_HANDLER

	if(!(armor in cleanup))
		cleanup |= armor // marks item for removal once the dummy is ready
		UnregisterSignal(armor, COMSIG_ITEM_UNEQUIPPED)
		return
	else
		cleanup -= armor
		var/obj/item/storage/internal/armor_storage = locate(/obj/item/storage/internal) in armor
		for(var/obj/item/item as anything in armor_storage)
			armor_storage.remove_from_storage(item, get_turf(armor))
		QDEL_IN(armor, 1 SECONDS)

/datum/tutorial/marine/hospital_corpsman_sandbox/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/tutorial/fed)
	tutorial_mob.set_skills(/datum/skills/combat_medic)
	give_action(tutorial_mob, /datum/action/hm_tutorial/sandbox/ready_up, null, null, src)
	tutorial_mob.job = JOB_SQUAD_MEDIC
	tutorial_mob.forceMove(get_turf(loc_from_corner(0,1))) // spawn point


/datum/tutorial/marine/hospital_corpsman_sandbox/init_map()

	new /obj/structure/machinery/cm_vending/clothing/medic/tutorial(loc_from_corner(2, 0))
	new /obj/structure/machinery/cm_vending/gear/medic/tutorial/(loc_from_corner(3, 0))
	var/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor/prep_door = locate(/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor) in get_turf(loc_from_corner(4, 1))
	var/obj/structure/bed/medevac_stretcher/prop/medevac_bed = locate(/obj/structure/bed/medevac_stretcher/prop) in get_turf(loc_from_corner(7, 0))
	var/obj/structure/machinery/smartfridge/smartfridge = locate(/obj/structure/machinery/smartfridge) in get_turf(loc_from_corner(0, 3))
	supply_vendors |= locate(/obj/structure/machinery/cm_vending/sorted/medical/blood/bolted) in get_turf(loc_from_corner(0, 0))
	supply_vendors |= locate(/obj/structure/machinery/cm_vending/sorted/medical/bolted) in get_turf(loc_from_corner(1, 0))
	supply_vendors |= locate(/obj/structure/machinery/cm_vending/sorted/medical/marinemed) in get_turf(loc_from_corner(2, 3))
	agent_spawn_location = get_turf(loc_from_corner(12, 2))
	var/obj/item/storage/pill_bottle/imialky/ia = new /obj/item/storage/pill_bottle/imialky
	smartfridge.add_local_item(ia) //I have won, but at what cost?
	prep_door.req_one_access = null
	prep_door.req_access = null
	add_to_tracking_atoms(prep_door)
	add_to_tracking_atoms(medevac_bed)
	RegisterSignal(medevac_bed, COMSIG_LIVING_BED_BUCKLED, PROC_REF(simulate_evac))

/datum/tutorial/marine/hospital_corpsman_sandbox/proc/init_npcs()

	CMO_npc = new(loc_from_corner(7, 7))
	arm_equipment(CMO_npc, /datum/equipment_preset/uscm_ship/uscm_medical/cmo/npc)

/datum/tutorial/marine/hospital_corpsman_sandbox/proc/init_dragging_agent(mob/living/carbon/human/dragging_agent)
	arm_equipment(dragging_agent, /datum/equipment_preset/uscm/tutorial_rifleman)
	dragging_agent.a_intent = INTENT_DISARM

/datum/tutorial/marine/hospital_corpsman_sandbox/Destroy(force)
	STOP_PROCESSING(SSfastobj, src)
	if(booboo_timer)
		deltimer(booboo_timer)
		booboo_timer = null
	if(terminate_movement_timer)
		deltimer(terminate_movement_timer)
		terminate_movement_timer = null
	agent_healing_tasks = list()
	terminate_agent_processing()
	QDEL_LIST(supply_vendors)
	QDEL_LIST(agents)
	QDEL_LIST(active_agents)
	QDEL_LIST(dragging_agents)
	return ..()

/datum/action/hm_tutorial/sandbox/ready_up
	name = "Ready Up"
	action_icon_state = "walkman_next"
	var/datum/weakref/tutorial

/datum/action/hm_tutorial/sandbox/ready_up/New(Target, override_icon_state, datum/tutorial/marine/hospital_corpsman_sandbox/selected_tutorial)
	. = ..()
	tutorial = WEAKREF(selected_tutorial)

/datum/action/hm_tutorial/sandbox/ready_up/action_activate()
	. = ..()
	if(!tutorial)
		return

	var/datum/tutorial/marine/hospital_corpsman_sandbox/selected_tutorial = tutorial.resolve()

	selected_tutorial.end_supply_phase()

#undef TUTORIAL_HM_PHASE_PREP
#undef TUTORIAL_HM_PHASE_MAIN
#undef TUTORIAL_HM_PHASE_RESUPPLY
#undef TUTORIAL_HM_PHASE_NIGHTMARE

#undef TUTORIAL_HM_DIFFICULTY_INCREASE

#undef TUTORIAL_HM_INJURY_SEVERITY_BOOBOO
#undef TUTORIAL_HM_INJURY_SEVERITY_MINOR
#undef TUTORIAL_HM_INJURY_SEVERITY_ROUTINE
#undef TUTORIAL_HM_INJURY_SEVERITY_SEVERE
#undef TUTORIAL_HM_INJURY_SEVERITY_FATAL
#undef TUTORIAL_HM_INJURY_SEVERITY_EXTREME
#undef TUTORIAL_HM_INJURY_SEVERITY_MAXIMUM

#undef PATIENT_TYPE_MUNDANE
#undef PATIENT_TYPE_ORGAN
#undef PATIENT_TYPE_TOXIN

#undef INTERNAL_BLEEDING
#undef SUTURE
#undef FRACTURE
