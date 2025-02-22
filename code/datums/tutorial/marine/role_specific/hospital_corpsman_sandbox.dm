/* Gameplay Phases */
#define TUTORIAL_HM_PHASE_PREP 0		//! Prep time upon joining, time for players to gear up
#define TUTORIAL_HM_PHASE_MAIN 1		//! Regular round, locks the prep room, spawns up to 5 patients with injuries of any severity
#define TUTORIAL_HM_PHASE_RESUPPLY 2	//! Pauses gameplay, opens the prep room, and allows resupply time, happens at random
#define TUTORIAL_HM_PHASE_NIGHTMARE 3	//! Simulates a Mass-Casualty event, 3-5 patients with severe damage levels

/// How quickly HM tutorial sandbox difficulty increases over time (and how likely a Mass-Cas becomes)
#define TUTORIAL_HM_DIFFICULTY_INCREASE (1/2)

/* Injury Severity Levels */
#define TUTORIAL_HM_INJURY_SEVERITY_BOOBOO 1.5	//! Boo-boos that take less than 5 seconds to fix
#define TUTORIAL_HM_INJURY_SEVERITY_MINOR 3
#define TUTORIAL_HM_INJURY_SEVERITY_ROUTINE 4	//! Routine treatments, occasional IB, 1-2 fractures, moderate damage less than 200, minor ODs, eye damage ONLY
#define TUTORIAL_HM_INJURY_SEVERITY_SEVERE 5	//! Life-threatening injuries, organ damage, missing limbs, up to 250 damage, multiple fracs, low blood
#define TUTORIAL_HM_INJURY_SEVERITY_FATAL 6		//! Life-threatening injuries, organ damage, missing limbs, up to 300 damage, multiple fracs, low blood
#define TUTORIAL_HM_INJURY_SEVERITY_EXTREME 9	//! Fatal injuries, organ damage, missing limbs, up to 450 damage, multiple fracs, low blood
#define TUTORIAL_HM_INJURY_SEVERITY_MAXIMUM 12	//! No limit on injury types, damage ranging from 500-600, extremely rare outside of Mass-Cas events


/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox
	name = "Marine - Hospital Corpsman (Sandbox)"
	desc = "Test your medical skills against an endless wave of wounded Marines!"
	tutorial_id = "marine_hm_3"
	required_tutorial = "marine_basic_1"
	icon_state = "medic"
	tutorial_template = /datum/map_template/tutorial/s15x10/hm

	// holder for the CMO NPC
	var/mob/living/carbon/human/CMOnpc
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
	var/list/difficulties = list(TUTORIAL_HM_INJURY_SEVERITY_BOOBOO, TUTORIAL_HM_INJURY_SEVERITY_MINOR, TUTORIAL_HM_INJURY_SEVERITY_ROUTINE, TUTORIAL_HM_INJURY_SEVERITY_SEVERE, TUTORIAL_HM_INJURY_SEVERITY_FATAL, TUTORIAL_HM_INJURY_SEVERITY_EXTREME, TUTORIAL_HM_INJURY_SEVERITY_MAXIMUM)
	/// Max amount of patient NPCs per survival wave (NOT including booboo NPCs)
	var/max_survival_agents = 3
	/// Min amount of patient NPCs per survival wave (NOT including booboo NPCs)
	var/min_survival_agents = 1
	/// Current survival wave
	var/survival_wave = 0
	/// Current survival wave difficulty (in terms of injury severity)
	var/survival_difficulty = TUTORIAL_HM_INJURY_SEVERITY_BOOBOO
	/// Holds a random timer per survival wave for a booboo agent to spawn
	var/boobootimer
	/// List of injuries on patient NPCs that must be treated before fully healed. Is only tested AFTER they pass 65% health
	var/list/mob/living/carbon/human/realistic_dummy/agent_healing_tasks = list()
	/// Wave number when the last resupply phase triggered. Will wait 3 waves before rolling again
	var/last_resupply_round = 1
	/// Wave number when the last mass-casualty (nightmare) phase triggered. Will wait 3 waves before rolling again
	var/last_masscas_round = 1
	/// Lists possible chemicals that can appear pre-medicated in patient NPCs in harder difficulties
	var/list/datum/reagent/medical/premeds = list(/datum/reagent/medical/tramadol, /datum/reagent/medical/bicaridine, /datum/reagent/medical/kelotane, /datum/reagent/medical/oxycodone)

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	START_PROCESSING(SSfastobj, src)
	init_mob()
	init_npcs()
	remove_action(tutorial_mob, /datum/action/tutorial/skip_text)
	slower_message_to_player("Welcome to the Hospital Corpsman tutorial sandbox mode!")
	slower_message_to_player("Gear up in your prefered HM kit, then press the orange 'Ready Up' arrow at the top of your HUD to begin the first round!")

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/proc/handle_round_progression()

	var/difficultyupgradewarning = null

	if(boobootimer)
		deltimer(boobootimer)
		boobootimer = null

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
	// Will only roll beyond wave 3, and 3 waves after the previous resupply phase.
	if((rand() < (1/5)) && (survival_wave >= (last_resupply_round + 3)))
		begin_supply_phase()
		last_resupply_round = survival_wave
		return
	survival_wave++
	// 1 in 10 chance per round to trigger a mass-cas (NIGHTMARE) phase
	// Will only roll beyond wave 3, and 3 waves after the previous mass-cas phase.
	if((rand() < (1/10)) && (survival_wave >= (last_masscas_round + 3)))
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
		slower_message_to_player("Warning! Mass-Casualty event detected!")
	// 50% chance per wave of increasing difficulty by one step
	// two round grace period from start
	else if((rand() < TUTORIAL_HM_DIFFICULTY_INCREASE) && !(survival_wave <= 2))
		var/current_difficulty = survival_difficulty
		if(current_difficulty != TUTORIAL_HM_INJURY_SEVERITY_MAXIMUM)
			survival_difficulty = next_in_list(current_difficulty, difficulties)
			difficultyupgradewarning = " Difficulty has increased, watch out!!"

	CMOnpc.say("Now entering round [survival_wave]![difficultyupgradewarning]")

	addtimer(CALLBACK(src, PROC_REF(spawn_agents)), 2 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/proc/end_supply_phase()

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor, prepdoor)
	var/turf/boundry = get_turf(loc_from_corner(4, 1))
	if(tutorial_mob.x <= boundry.x)
		slower_message_to_player("Please exit the preperations room before progressing into the next round!")
		return
	prepdoor.close(TRUE)
	prepdoor.lock(TRUE)
	stage = TUTORIAL_HM_PHASE_MAIN
	remove_action(tutorial_mob, /datum/action/hm_tutorial/sandbox/ready_up)
	handle_round_progression()

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/proc/begin_supply_phase()

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor, prepdoor)
	prepdoor.unlock(TRUE)
	prepdoor.open()
	stage = TUTORIAL_HM_PHASE_MAIN // just in case it wasnt already

	slower_message_to_player("Phew! We have entered a resupply phase of the tutorial!")
	slower_message_to_player("Use this rare opportunity to refill, restock, and resupply yourself for future rounds.")
	slower_message_to_player("Remember, on the field, immediate resupply will not always be possible! You won't know for certain when your next chance will arrive, so stock up while you can!")
	slower_message_to_player("When you are ready, leave the supply room, then click the 'Ready Up' action on the top left of your screen to begin your next round.")

	give_action(tutorial_mob, /datum/action/hm_tutorial/sandbox/ready_up, null, null, src)

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/proc/spawn_agents()
	SIGNAL_HANDLER

	for(var/i in 1 to (round(rand(min_survival_agents, max_survival_agents))))
		var/mob/living/carbon/human/realistic_dummy/active_agent = new(agent_spawn_location)
		arm_equipment(active_agent, /datum/equipment_preset/uscm/tutorial_rifleman)
		var/turf/dropoff_point = loc_from_corner(round(rand(6, 8), 1), round(rand(1, 3)))	// Picks a random turf to move the NPC to
		agents[active_agent] = dropoff_point
		active_agent.a_intent = INTENT_DISARM
		simulate_condition(active_agent)
		var/obj/item/clothing/suit/storage/marine/medium/armor = active_agent.get_item_by_slot(WEAR_JACKET)
		RegisterSignal(armor, COMSIG_ITEM_UNEQUIPPED, PROC_REF(item_cleanup))

	addtimer(CALLBACK(src, PROC_REF(eval_agent_status)), 3 SECONDS)	// Gives time for NPCs to pass out or die, if their condition is severe enough
	if((survival_difficulty >= TUTORIAL_HM_INJURY_SEVERITY_FATAL) && (rand() <= 0.75))	// If above difficulty FATAL, starts a random timer to spawn a booboo agent
		boobootimer = addtimer(CALLBACK(src, PROC_REF(eval_booboo_agent)), (rand(15,25)) SECONDS, TIMER_STOPPABLE)

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/proc/simulate_condition(mob/living/carbon/human/target)
	SIGNAL_HANDLER

	// Simulates patient NPC injuries

	var/damageamountsplit = ((round(rand(1, 100))) / 100)	// How damage should be split between brute and burn
	var/list/limbs = target.limbs
	var/amount_of_parts = round(rand(1, 6))	// Amount of times to roll for a limb fracture
	var/patienttype = pick(75;1,15;2,10;3) // 75% chance for mundane damage, 15% for organ damage, 10% for toxin

	if(patienttype >= 1)
		for(var/i in 1 to amount_of_parts)
			var/obj/limb/selectedlimb = pick(limbs)
			var/damageamount = (round(rand((40 * survival_difficulty), (50 * survival_difficulty))))
			selectedlimb.take_damage(round((damageamount * damageamountsplit) / amount_of_parts), round((damageamount * (1 - damageamountsplit)) / amount_of_parts))
			if((damageamount > 30) && (rand()) < (survival_difficulty / 10))
				selectedlimb.fracture()
	if(patienttype == 2)	// applies organ damage AS WELL as mundane damage if type 2
		var/datum/internal_organ/organ = pick(target.internal_organs)
		target.apply_internal_damage(round(rand(1,(survival_difficulty*3.75))), "[organ.name]")
	if(patienttype == 3)	// applies toxin damage AS WELL as mundane damage if type 3
		target.setToxLoss(round(rand(1,10*survival_difficulty)))

	if(pick(15;1,85;0))	// Simulates premedicated patients
		var/datum/reagent/medical/reagent = pick(premeds)
		target.reagents.add_reagent(reagent.id, round(rand(0, reagent.overdose - 1)))	// OD safety

	target.updatehealth()
	target.UpdateDamageIcon()
	RegisterSignal(target, COMSIG_HUMAN_TUTORIAL_HEALED, PROC_REF(final_health_checks))
	RegisterSignal(target, COMSIG_HUMAN_SET_UNDEFIBBABLE, PROC_REF(make_agent_leave))	// perma detection

	RegisterSignal(target, COMSIG_LIVING_REJUVENATED, PROC_REF(make_agent_leave)) // for debugging

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/proc/final_health_checks(mob/living/carbon/human/target, bypass)
	SIGNAL_HANDLER

	// Makes sure complex injuries are treated once 65% health is reached

	var/list/healing_tasks = list()
	UnregisterSignal(target, COMSIG_HUMAN_TUTORIAL_HEALED)
	var/list/injury_type = list()
	for(var/obj/limb/limb in target.limbs)
		if((limb.status & LIMB_BROKEN) && !(limb.status & LIMB_SPLINTED))
			injury_type |= "fracture"
			healing_tasks[limb] = injury_type
			RegisterSignal(limb, COMSIG_HUMAN_SPLINT_APPLIED, PROC_REF(health_tasks_handler))
		for(var/datum/wound/wound as anything in limb.wounds)
			if(wound.internal)
				injury_type |= "IB"
				healing_tasks[limb] = injury_type
				RegisterSignal(tutorial_mob, COMSIG_HUMAN_SURGERY_STEP_SUCCESS, PROC_REF(health_tasks_handler), TRUE) // yeah yeah, give me a break
	if((!(length(healing_tasks))) || bypass)
		make_agent_leave(target)
	else
		agent_healing_tasks[target] = healing_tasks

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/proc/health_tasks_handler(datum/source, mob/living/carbon/human/realistic_dummy/target, datum/surgery/surgery)
	SIGNAL_HANDLER

	var/list/healing_tasks = agent_healing_tasks[target]
	var/list/injury_type = list()
	var/obj/limb/limb
	if(istype(source, /obj/limb)) // swaps around the variables from COMSIG_HUMAN_SPLINT_APPLIED to make them consistent
		limb = source
		var/target_redirect = limb.owner
		health_tasks_handler(target, target_redirect)
		UnregisterSignal(limb, COMSIG_HUMAN_SPLINT_APPLIED)
		return
	if(surgery)
		limb = surgery.affected_limb
		if(surgery.name == "Internal Bleeding Repair")
			for(limb in healing_tasks)
				injury_type = healing_tasks[surgery.affected_limb]
				injury_type -= "IB"
				injury_type |= "suture"
		if(surgery.name == "Suture Incision")
			for(limb in healing_tasks)
				injury_type = healing_tasks[surgery.affected_limb]
				if("suture" in injury_type)
					injury_type -= "suture"
	for(limb in healing_tasks)
		injury_type = healing_tasks[limb]
		if(("fracture" in injury_type) && (limb.status & LIMB_BROKEN) && (limb.status & LIMB_SPLINTED))
			injury_type -= "fracture"
		if(!(length(injury_type)) && (limb)) // makes sure something DID exist on the list
			healing_tasks -= limb
	if(!(length(healing_tasks)))
		UnregisterSignal(tutorial_mob, COMSIG_HUMAN_SURGERY_STEP_SUCCESS)
		make_agent_leave(target)

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/proc/eval_agent_status()

	for(var/mob/living/carbon/human/target in agents)
		if(target.stat > 0) // are they awake?
			var/mob/living/carbon/human/dragging_agent = new(target.loc)
			init_dragging_agent(dragging_agent)
			dragging_agent.do_pull(target)
			dragging_agents[dragging_agent] = target
			move_dragging_agent()
		else
			active_agents |= target
			move_active_agents()

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/proc/handle_speech(mob/living/carbon/human/target)

	var/list/helpme = list()

	if(target in dragging_agents)
		target.emote("medic")
		return
	if(rand() <= 0.25)
		target.emote("medic")
		return
	for(var/obj/limb/limb in target.limbs)
		if(limb.status & LIMB_BROKEN)
			var/targetlimb = limb.display_name
			helpme |= list("Need a [targetlimb] splint please Doc", "Splint [targetlimb]", "Can you splint my [targetlimb] please")

	helpme |= list("Doc can I get some pills?", "Need a patch up please", "Im hurt Doc...", "Can I get some healthcare?", "Pill me real quick")

	target.say("[pick(helpme)]")

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/proc/move_dragging_agent()

	listclearnulls(dragging_agents)
	for(var/mob/living/carbon/human/dragging_agent in dragging_agents)
		var/mob/living/carbon/human/target = dragging_agents[dragging_agent]
		var/turf/dropoff_point = agents[target]
		if(locate(dragging_agent) in agent_spawn_location)
			var/initial_step_direction = pick((agent_spawn_location.y) <= (dropoff_point.y) ? NORTH : SOUTH)
			var/turf/target_turf = get_step(dragging_agent, initial_step_direction)
			dragging_agent.Move(target_turf, initial_step_direction)
		if(dropoff_point.x <= dragging_agent.x) // this is MEANT to move one tile west of the dropzone
			var/turf/target_turf = get_step(dragging_agent, WEST)
			dragging_agent.Move(target_turf, WEST)
		else if(dropoff_point.x == (dragging_agent.x + 1)) // only tests when beyond the dropzone
			if(((dropoff_point.y - dragging_agent.y) >= 2) || ((dropoff_point.y - dragging_agent.y) <= (-2))) // handholding if the dragging agent was born yesterday
				var/step_direction = pick((dragging_agent.y) > (dropoff_point.y) ? SOUTH : NORTH)
				var/turf/target_turf = get_step(dragging_agent, step_direction)
				dragging_agent.Move(target_turf, step_direction)
				var/turf/drag_turf = get_step(dragging_agent, EAST)
				target.Move(drag_turf, EAST)
				return
			dragging_agent.mob_flags |= IMMOBILE_ACTION
			target.Move(dropoff_point)
			dragging_agent.stop_pulling()
			handle_speech(dragging_agent)
			dragging_agents -= dragging_agent
			make_dragging_agent_leave(dragging_agent)

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/proc/make_dragging_agent_leave(mob/living/carbon/human/dragging_agent)

	if(dragging_agent in dragging_agents)	// failsafe in case the dragging NPC never had their movement code stopped
		dragging_agents -= dragging_agent
	dragging_agent.density = 0
	QDEL_IN(dragging_agent, 2.5 SECONDS)
	animate(dragging_agent, 2.5 SECONDS, alpha = 0, easing = CUBIC_EASING)

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/proc/move_active_agents()

	listclearnulls(active_agents) // failsafe
	for(var/mob/living/carbon/human/realistic_dummy/active_agent as anything in active_agents)
		var/turf/dropoff_point = agents[active_agent]
		if(locate(active_agent) in agent_spawn_location)
			var/initial_step_direction = pick((agent_spawn_location.y) <= (dropoff_point.y) ? NORTH : SOUTH)
			var/turf/target_turf = get_step(active_agent, initial_step_direction)
			active_agent.Move(target_turf, initial_step_direction)
		if((dropoff_point.x > active_agent.x) || (dropoff_point.x < active_agent.x))
			var/step_direction = pick((active_agent.x) > (dropoff_point.x) ? WEST : EAST)
			var/turf/target_turf = get_step(active_agent, step_direction)
			active_agent.Move(target_turf, step_direction)
		else if(dropoff_point.x == active_agent.x)
			if(((dropoff_point.y - active_agent.y) >= 2) || ((dropoff_point.y - active_agent.y) <= (-2)))
				var/step_direction = pick((active_agent.y) > (dropoff_point.y) ? SOUTH : NORTH)
				var/turf/target_turf = get_step(active_agent, step_direction)
				active_agent.Move(target_turf, step_direction)
				return
			active_agent.Move(dropoff_point)
			active_agents -= active_agent
			handle_speech(active_agent)

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/proc/make_agent_leave(mob/living/carbon/human/realistic_dummy/agent, bypass)
	SIGNAL_HANDLER

	UnregisterSignal(agent, COMSIG_LIVING_REJUVENATED)
	UnregisterSignal(agent, COMSIG_HUMAN_SET_UNDEFIBBABLE)
	UnregisterSignal(agent, COMSIG_HUMAN_TUTORIAL_HEALED)
	agent.updatehealth()
	if(!(bypass))
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
	for(var/obj/item/clothing/suit/storage/marine/medium/armor in cleanup)
		item_cleanup(armor)
	if((length(agents)) == 0)
		INVOKE_ASYNC(src, PROC_REF(handle_round_progression))

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/proc/eval_booboo_agent()
	SIGNAL_HANDLER

	var/mob/living/carbon/human/realistic_dummy/active_agent = new(agent_spawn_location)
	arm_equipment(active_agent, /datum/equipment_preset/uscm/tutorial_rifleman)
	var/turf/dropoff_point = loc_from_corner(round(rand(6, 8), 1), round(rand(1, 3)))
	agents[active_agent] = dropoff_point
	active_agent.a_intent = INTENT_DISARM

	var/damageamountsplit = ((round(rand(1, 100))) / 100)
	var/list/limbs = active_agent.limbs
	var/amount_of_parts = round(rand(1, 6))

	for(var/i in 1 to amount_of_parts)
		var/obj/limb/selectedlimb = pick(limbs)
		var/damageamount = (round(rand((40 * TUTORIAL_HM_INJURY_SEVERITY_BOOBOO), (50 * TUTORIAL_HM_INJURY_SEVERITY_BOOBOO))))
		selectedlimb.take_damage(round((damageamount * damageamountsplit) / amount_of_parts), round((damageamount * (1 - damageamountsplit)) / amount_of_parts))
		if((damageamount > 30) && (rand()) < (TUTORIAL_HM_INJURY_SEVERITY_BOOBOO / 10))
			selectedlimb.fracture()

	active_agent.updatehealth()
	active_agent.UpdateDamageIcon()
	active_agents |= active_agent
	RegisterSignal(active_agent, COMSIG_HUMAN_TUTORIAL_HEALED, PROC_REF(make_agent_leave))
	RegisterSignal(active_agent, COMSIG_HUMAN_SET_UNDEFIBBABLE, PROC_REF(make_agent_leave))

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/proc/simulate_evac(datum/source, mob/living/carbon/human/target)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/bed/medevac_stretcher/prop, medevacbed)

	var/list/statusmessage = list()

	for(var/datum/reagent/medical/chemical in target.reagents.reagent_list)
		if(chemical.volume >= chemical.overdose_critical)
			statusmessage |= "Critical [chemical.name] overdose detected"
	for(var/datum/internal_organ/organ in target.internal_organs)
		if(organ.damage >= organ.min_broken_damage)
			if((locate(/datum/reagent/medical/peridaxon) in target.reagents.reagent_list) || (target.stat == DEAD))
				statusmessage |= "Ruptured [organ.name] detected"
			else
				medevacbed.balloon_alert_to_viewers("Organ damage detected! Please stabilize patient with Peridaxon before transit.", null, DEFAULT_MESSAGE_RANGE, null, COLOR_RED)
				playsound(medevacbed.loc, 'sound/machines/twobeep.ogg', 20)
				return

	if(tutorial_mob == target)
		medevacbed.balloon_alert_to_viewers("Error! Unable to self-evacuate!", null, DEFAULT_MESSAGE_RANGE, null, COLOR_RED)
		playsound(medevacbed.loc, 'sound/machines/twobeep.ogg', 20)
		return
	if(length(statusmessage) > 0)
		medevacbed.balloon_alert_to_viewers("[pick(statusmessage)]! Evacuating patient!!", null, DEFAULT_MESSAGE_RANGE, null, LIGHT_COLOR_BLUE)
		playsound(medevacbed.loc, pick(90;'sound/machines/ping.ogg',10;'sound/machines/juicer.ogg'), 20)
		spawn(2.7 SECONDS)
		flick("winched_stretcher", medevacbed)
		make_agent_leave(target, TRUE)
		medevacbed.update_icon()
	else
		medevacbed.balloon_alert_to_viewers("Error! Patient condition does not warrant evacuation!", null, DEFAULT_MESSAGE_RANGE, null, COLOR_RED)
		playsound(medevacbed.loc, 'sound/machines/twobeep.ogg', 20)
		return

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/process(delta_time)

	if((length(dragging_agents)) > 0)
		move_dragging_agent()
	if((length(active_agents)) > 0)
		move_active_agents()

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/proc/item_cleanup(obj/item/clothing/suit/storage/marine/medium/armor)
	SIGNAL_HANDLER

	if(!(armor in cleanup))
		cleanup |= armor // marks item for removal once the dummy is ready
		UnregisterSignal(armor, COMSIG_ITEM_UNEQUIPPED)
		return
	else
		cleanup -= armor
		QDEL_IN(armor, 1 SECONDS)

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/tutorial/fed)
	tutorial_mob.set_skills(/datum/skills/combat_medic)
	give_action(tutorial_mob, /datum/action/hm_tutorial/sandbox/ready_up, null, null, src)
	tutorial_mob.job = JOB_SQUAD_MEDIC
	tutorial_mob.forceMove(get_turf(loc_from_corner(0,1))) // spawn point


/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/init_map()

	new /obj/structure/machinery/cm_vending/clothing/medic/tutorial(loc_from_corner(2, 0))
	new /obj/structure/machinery/cm_vending/gear/medic/tutorial/(loc_from_corner(3, 0))
	var/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor/prepdoor = locate(/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor) in get_turf(loc_from_corner(4, 1))
	var/obj/structure/bed/medevac_stretcher/prop/medevacbed = locate(/obj/structure/bed/medevac_stretcher/prop) in get_turf(loc_from_corner(7, 0))
	var/obj/structure/machinery/smartfridge/smartfridge = locate(/obj/structure/machinery/smartfridge) in get_turf(loc_from_corner(0, 3))
	agent_spawn_location = get_turf(loc_from_corner(12, 2))
	var/obj/item/storage/pill_bottle/imialky/ia = new /obj/item/storage/pill_bottle/imialky
	smartfridge.add_local_item(ia) //I have won, but at what cost?
	prepdoor.req_one_access = null
	prepdoor.req_access = null
	add_to_tracking_atoms(prepdoor)
	add_to_tracking_atoms(medevacbed)
	RegisterSignal(medevacbed, COMSIG_LIVING_BED_BUCKLED, PROC_REF(simulate_evac))

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/proc/init_npcs()

	CMOnpc = new(loc_from_corner(7, 7))
	arm_equipment(CMOnpc, /datum/equipment_preset/uscm_ship/uscm_medical/cmo/npc)

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/proc/init_dragging_agent(mob/living/carbon/human/dragging_agent)
	arm_equipment(dragging_agent, /datum/equipment_preset/uscm/tutorial_rifleman)
	dragging_agent.a_intent = INTENT_DISARM

/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/Destroy(force)
	STOP_PROCESSING(SSfastobj, src)
	QDEL_LIST(agents)
	QDEL_LIST(dragging_agents)
	return ..()

//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_medic_sandbox, list(
		list("MEDICAL SET (MANDATORY)", 0, null, null, null),
		list("Essential Medical Set", 0, /obj/effect/essentials_set/medic, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("FIELD SUPPLIES", 0, null, null, null),
		list("Burn Kit", 2, /obj/item/stack/medical/advanced/ointment, null, VENDOR_ITEM_RECOMMENDED),
		list("Trauma Kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, VENDOR_ITEM_RECOMMENDED),
		list("Medical Splints", 1, /obj/item/stack/medical/splint, null, VENDOR_ITEM_RECOMMENDED),
		list("Blood Bag (O-)", 4, /obj/item/reagent_container/blood/OMinus, null, VENDOR_ITEM_REGULAR),

		list("FIRSTAID KITS", 0, null, null, null),
		list("Advanced Firstaid Kit", 12, /obj/item/storage/firstaid/adv, null, VENDOR_ITEM_RECOMMENDED),
		list("Firstaid Kit", 5, /obj/item/storage/firstaid/regular, null, VENDOR_ITEM_REGULAR),
		list("Fire Firstaid Kit", 6, /obj/item/storage/firstaid/fire, null, VENDOR_ITEM_REGULAR),
		list("Toxin Firstaid Kit", 6, /obj/item/storage/firstaid/toxin, null, VENDOR_ITEM_REGULAR),
		list("Oxygen Firstaid Kit", 6, /obj/item/storage/firstaid/o2, null, VENDOR_ITEM_REGULAR),
		list("Radiation Firstaid Kit", 6, /obj/item/storage/firstaid/rad, null, VENDOR_ITEM_REGULAR),

		list("PILL BOTTLES", 0, null, null, null),
		list("Pill Bottle (Bicaridine)", 5, /obj/item/storage/pill_bottle/bicaridine, null, VENDOR_ITEM_RECOMMENDED),
		list("Pill Bottle (Dexalin)", 5, /obj/item/storage/pill_bottle/dexalin, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Dylovene)", 5, /obj/item/storage/pill_bottle/antitox, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Inaprovaline)", 5, /obj/item/storage/pill_bottle/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Kelotane)", 5, /obj/item/storage/pill_bottle/kelotane, null, VENDOR_ITEM_RECOMMENDED),
		list("Pill Bottle (Peridaxon)", 5, /obj/item/storage/pill_bottle/peridaxon, null, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Tramadol)", 5, /obj/item/storage/pill_bottle/tramadol, null, VENDOR_ITEM_RECOMMENDED),

		list("AUTOINJECTORS", 0, null, null, null),
		list("Autoinjector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Epinephrine)", 2, /obj/item/reagent_container/hypospray/autoinjector/adrenaline, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, VENDOR_ITEM_REGULAR),

		list("MEDICAL UTILITIES", 0, null, null, null),
		list("MS-11 Smart Refill Tank", 6, /obj/item/reagent_container/glass/minitank, null, VENDOR_ITEM_REGULAR),
		list("FixOVein", 7, /obj/item/tool/surgery/FixOVein, null, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 4, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Health Analyzer", 4, /obj/item/device/healthanalyzer, null, VENDOR_ITEM_REGULAR),
		list("Stasis Bag", 6, /obj/item/bodybag/cryobag, null, VENDOR_ITEM_REGULAR),

		list("ARMORS", 0, null, null, null),
		list("M3 B12 Pattern Marine Armor", 24, /obj/item/clothing/suit/storage/marine/medium/leader, null, VENDOR_ITEM_REGULAR),
		list("M4 Pattern Armor", 16, /obj/item/clothing/suit/storage/marine/medium/rto, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Fire Extinguisher (Portable)", 3, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 3, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),

		list("HELMET OPTICS", 0, null, null, null),
		list("Welding Visor", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_REGULAR),

		list("PAMPHLETS", 0, null, null, null),
		list("Engineering Pamphlet", 15, /obj/item/pamphlet/skill/engineer, null, VENDOR_ITEM_REGULAR),

	))

/obj/structure/machinery/cm_vending/gear/medic/tutorial
	req_access = null

/obj/structure/machinery/cm_vending/gear/medic/tutorial/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_medic_sandbox

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_medic_sandbox, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Standard Marine Apparel", 0, list(/obj/item/clothing/under/marine/medic, /obj/item/clothing/shoes/marine/knife, /obj/item/clothing/gloves/marine), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Combat Sterile Gloves", 0, /obj/item/clothing/gloves/marine/medical, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Light Armor", 0, /obj/item/clothing/suit/storage/marine/light, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Medium Armor", 0, /obj/item/clothing/suit/storage/marine/medium, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("Heavy Armor", 0, /obj/item/clothing/suit/storage/marine/heavy, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("M10 Corpsman Helmet", 0, /obj/item/clothing/head/helmet/marine/medic, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("M10 White Corpsman Helmet", 0, /obj/item/clothing/head/helmet/marine/medic/white, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Medical Backpack", 0, /obj/item/storage/backpack/marine/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Medical Satchel", 0, /obj/item/storage/backpack/marine/satchel/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),
		list("M276 Medical Storage Rig (Full)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pressurized Reagent Canister Pouch (Revival Mix - Peridaxon)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_peri, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Bicaridine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Kelotane)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (Tricordrazine)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pressurized Reagent Canister Pouch (EMPTY)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Vial Pouch (Full)", 0, /obj/item/storage/pouch/vials/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Sterile Mask", 0, /obj/item/clothing/mask/surgical, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	))

/obj/structure/machinery/cm_vending/clothing/medic/tutorial
	req_access = null

/obj/structure/machinery/cm_vending/clothing/medic/tutorial/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_medic_sandbox

/datum/action/hm_tutorial/sandbox/ready_up
	name = "Ready Up"
	action_icon_state = "walkman_next"
	var/datum/weakref/tutorial

/datum/action/hm_tutorial/sandbox/ready_up/New(Target, override_icon_state, datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/selected_tutorial)
	. = ..()
	tutorial = WEAKREF(selected_tutorial)

/datum/action/hm_tutorial/sandbox/ready_up/action_activate()
	. = ..()
	if(!tutorial)
		return

	var/datum/tutorial/marine/role_specific/hospital_corpsman_sandbox/selected_tutorial = tutorial.resolve()

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
