/* Gameplay Phases */
#define TUTORIAL_HM_PHASE_PREP 0		//! Prep time upon joining, time for players to gear up
#define TUTORIAL_HM_PHASE_MAIN 1		//! Regular round, locks the prep room, spawns up to 5 patients with injuries of any severity
#define TUTORUAL_HM_PHASE_RESUPPLY 2	//! Pauses gameplay, opens the prep room, and allows resupply time, happens at random
#define TUTORIAL_HM_PHASE_NIGHTMARE 3	//! Simulates a Mass-Casualty event, 3-5 patients with severe damage levels

/// How quickly HM tutorial freeplay difficulty increases over time (and how likely a Mass-Cas becomes)
#define TUTORIAL_HM_DIFFICULTY_INCREASE (1/2)

/* Injury Severity Levels */
#define TUTORIAL_HM_INJURY_SEVERITY_BOOBOO 1.5	//! Boo-boos that take less than 5 seconds to fix
#define TUTORIAL_HM_INJURY_SEVERITY_MINOR 3
#define TUTORIAL_HM_INJURY_SEVERITY_ROUTINE 4	//! Routine treatments, occasional IB, 1-2 fractures, moderate damage less than 200, minor ODs, eye damage ONLY
#define TUTORIAL_HM_INJURY_SEVERITY_SEVERE 5	//! Life-threatening injuries, organ damage, missing limbs, up to 250 damage, multiple fracs, low blood
#define TUTORIAL_HM_INJURY_SEVERITY_FATAL 6		//! Life-threatening injuries, organ damage, missing limbs, up to 300 damage, multiple fracs, low blood
#define TUTORIAL_HM_INJURY_SEVERITY_EXTREME 9	//! Fatal injuries, organ damage, missing limbs, up to 450 damage, multiple fracs, low blood
#define TUTORIAL_HM_INJURY_SEVERITY_MAXIMUM 12	//! No limit on injury types, damage ranging from 500-600, extremely rare outside of Mass-Cas events


/datum/tutorial/marine/hospital_corpsman_freeplay
	name = "Marine - Hospital Corpsman (Sandbox) - Beta"
	desc = "Learn the more advanced skills required of a Marine Hospital Corpsman."
	tutorial_id = "marine_hm_3"
	icon_state = "medic"
	//required_tutorial = "marine_hm_1"
	tutorial_template = /datum/map_template/tutorial/s15x10/hm

	// holder for the CMO NPC
	var/mob/living/carbon/human/realistic_dummy/CMOnpc/CMOnpc

	/// Current step of the tutorial we're at
	var/stage = TUTORIAL_HM_PHASE_PREP
	/// Current "remind" timer after which the agent will remind player of its request
	var/remind_timer

	/// List of line 'agents', aka the dummies requesting items, sorted by line order
	/// During normal stages there is one per stage (except for Forgot stage),
	/// During Survival mode there would usually be two: one at the counter, and one moving.
	/// The agents are mapped to a list of item types requested.
	var/list/mob/living/carbon/human/realistic_dummy/agents = list()

	var/list/mob/living/carbon/human/realistic_dummy/dragging_agent/dragging_agents = list()

	var/list/mob/living/carbon/human/realistic_dummy/active_agents = list()

	var/mob/living/carbon/human/active_agent

	var/mob/living/carbon/human/realistic_dummy/dragging_agent/dragging_agent

	var/mob/living/carbon/human/leaving_agent

	var/turf/agent_spawn_location

	var/list/difficulties = list(TUTORIAL_HM_INJURY_SEVERITY_MINOR, TUTORIAL_HM_INJURY_SEVERITY_ROUTINE, TUTORIAL_HM_INJURY_SEVERITY_SEVERE, TUTORIAL_HM_INJURY_SEVERITY_FATAL, TUTORIAL_HM_INJURY_SEVERITY_EXTREME, TUTORIAL_HM_INJURY_SEVERITY_MAXIMUM)

	/// Max amount of agents per survival wave
	var/max_survival_agents = 5

	var/min_survival_agents = 3
	/// Current survival wave
	var/survival_wave = 0
	/// Difficulty factor per survival wave, increasing both the amount of agents and requested items
	var/survival_difficulty = TUTORIAL_HM_INJURY_SEVERITY_MINOR

/datum/tutorial/marine/hospital_corpsman_freeplay/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	START_PROCESSING(SSfastobj, src)
	init_mob()
	init_npcs()
	message_to_player("Welcome to the Hospital Corpsman tutorial sandbox mode!")
	addtimer(CALLBACK(src, PROC_REF(uniform)), 4 SECONDS)

// plan
//
// Medical Supply Room
// Entering seperate room
//
// Up to 5 marines walk in with random injuries
// severity ranging from 1-4
// occasionally Marines walk in with boo-boos
//
// Mass-Cas random rounds

/datum/tutorial/marine/hospital_corpsman_freeplay/proc/uniform()
	SIGNAL_HANDLER

	message_to_player("Gear up in your prefered HM kit, then press the orange 'Ready Up' arrow at the top of your HUD to begin the first round!")

/datum/tutorial/marine/hospital_corpsman_freeplay/proc/handle_round_progression()

	var/difficultyupgradewarning = null
	switch(stage)
		if(TUTORUAL_HM_PHASE_RESUPPLY)
			return // sometimes it double-calls handle_round_progression()
		if(TUTORIAL_HM_PHASE_NIGHTMARE)
			stage = TUTORUAL_HM_PHASE_RESUPPLY
			survival_wave++
			survival_difficulty = pick(TUTORIAL_HM_INJURY_SEVERITY_MINOR, TUTORIAL_HM_INJURY_SEVERITY_ROUTINE)
			min_survival_agents = 3
			begin_supply_phase()
			return
	survival_wave++
	if(rand() < (1/500)) // mass cas every 1/5
		stage = TUTORIAL_HM_PHASE_NIGHTMARE
		for(var/i in 1 to 2)
			var/current_difficulty = survival_difficulty
			if(current_difficulty != TUTORIAL_HM_INJURY_SEVERITY_MAXIMUM)
				survival_difficulty = next_in_list(current_difficulty, difficulties)
		playsound(tutorial_mob.loc, 'sound/effects/siren.ogg', 50)
		message_to_player("Warning! Mass-Casualty event detected!")
	else if(rand() < TUTORIAL_HM_DIFFICULTY_INCREASE)
		var/current_difficulty = survival_difficulty
		if(current_difficulty != TUTORIAL_HM_INJURY_SEVERITY_MAXIMUM)
			survival_difficulty = next_in_list(current_difficulty, difficulties)
			difficultyupgradewarning = " Difficulty has increased to level [survival_difficulty]!!"

	CMOnpc.say("Now entering round [survival_wave]![difficultyupgradewarning]")


	addtimer(CALLBACK(src, PROC_REF(spawn_agents)), 2 SECONDS)

/datum/tutorial/marine/hospital_corpsman_freeplay/proc/end_supply_phase()

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor, prepdoor)
	var/turf/boundry = get_turf(loc_from_corner(4, 1))
	if(tutorial_mob.x <= boundry.x)
		message_to_player("Please exit the preperations room before progressing into the next round!")
		return
	prepdoor.close(TRUE)
	prepdoor.lock(TRUE)
	stage = TUTORIAL_HM_PHASE_MAIN
	remove_action(tutorial_mob, /datum/action/hm_tutorial/sandbox/ready_up)
	handle_round_progression()

/datum/tutorial/marine/hospital_corpsman_freeplay/proc/begin_supply_phase()

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor, prepdoor)
	prepdoor.unlock(TRUE)
	prepdoor.open()
	stage = TUTORIAL_HM_PHASE_MAIN // just in case it wasnt already

	message_to_player("Phew! We have entered a resupply phase of the tutorial!")
	message_to_player("Use this rare opportunity to refill, restock, and resupply yourself for future rounds.")
	message_to_player("Remember, on the field, immediate resupply will not always be possible! You won't know for certain when your next chance will arrive, so stock up while you can!")
	message_to_player("When you are ready, leave the supply room, then click the 'Ready Up' action on the top left of your screen to begin your next round.")

	give_action(tutorial_mob, /datum/action/hm_tutorial/sandbox/ready_up, null, null, src)


/datum/tutorial/marine/hospital_corpsman_freeplay/proc/spawn_agents()

	agent_spawn_location = get_turf(loc_from_corner(12, 2))

	for(var/i in 3 to (round(rand(min_survival_agents, max_survival_agents))))
		var/mob/living/carbon/human/realistic_dummy/active_agent = new(agent_spawn_location)
		arm_equipment(active_agent, /datum/equipment_preset/other/realistic_dummy/soldier)
		var/turf/dropoff_point = loc_from_corner(round(rand(6, 8), 1), round(rand(1, 3)))
		agents[active_agent] = dropoff_point
		active_agent.a_intent = INTENT_DISARM
		simulate_condition(active_agent)

	addtimer(CALLBACK(src, PROC_REF(eval_agent_status)), 3 SECONDS)

/datum/tutorial/marine/hospital_corpsman_freeplay/proc/simulate_condition(mob/living/carbon/human/realistic_dummy/target)

	var/damageamountsplit = ((round(rand(1, 100))) / 100)
	var/list/limbs = target.limbs
	var/amount_of_parts = round(rand(1, 6))

	for(var/i in 1 to amount_of_parts)
		var/obj/limb/selectedlimb = pick(limbs)
		var/damageamount = (round(rand((40 * survival_difficulty), (50 * survival_difficulty))))
		selectedlimb.take_damage(round((damageamount * damageamountsplit) / amount_of_parts), round((damageamount * (1 - damageamountsplit)) / amount_of_parts))
		if((damageamount > 30) && (rand()) < (survival_difficulty / 10))
			selectedlimb.fracture()

	target.updatehealth()
	target.UpdateDamageIcon()
	RegisterSignal(target, COMSIG_HUMAN_TUTORIAL_HEALED, PROC_REF(make_agent_leave))
	//sleep(25)

/datum/tutorial/marine/hospital_corpsman_freeplay/proc/eval_agent_status()

	//for(var/i in 1 to length(agents))
	for(var/mob/living/carbon/human/realistic_dummy/target in agents)
		if(target.stat > 0) // are they awake?
			var/mob/living/carbon/human/realistic_dummy/dragging_agent/dragging_agent = new(target.loc)
			dragging_agent.do_pull(target)
			dragging_agents[dragging_agent] = target
			move_dragging_agent()
		else
			active_agents |= target
			move_active_agents()

/datum/tutorial/marine/hospital_corpsman_freeplay/proc/move_dragging_agent()

	agent_spawn_location = get_turf(loc_from_corner(12, 2)) // fix this

	listclearnulls(dragging_agents)
	for(var/mob/living/carbon/human/realistic_dummy/dragging_agent/dragging_agent in dragging_agents)
		var/mob/living/carbon/human/realistic_dummy/target = dragging_agents[dragging_agent]
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
			make_dragging_agent_leave(dragging_agent)

/datum/tutorial/marine/hospital_corpsman_freeplay/proc/make_dragging_agent_leave(mob/living/carbon/human/realistic_dummy/dragging_agent/dragging_agent)

	dragging_agents -= dragging_agent
	QDEL_IN(dragging_agent, 2.5 SECONDS)
	animate(dragging_agent, 2.5 SECONDS, alpha = 0, easing = CUBIC_EASING)

/datum/tutorial/marine/hospital_corpsman_freeplay/proc/move_active_agents()

	agent_spawn_location = get_turf(loc_from_corner(12, 2)) // fix this

	listclearnulls(active_agents) // failsafe
	for(var/mob/living/carbon/human/realistic_dummy/active_agent in active_agents)
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

/datum/tutorial/marine/hospital_corpsman_freeplay/proc/make_agent_leave(mob/living/carbon/human/realistic_dummy/agent)

	UnregisterSignal(agent, COMSIG_HUMAN_TUTORIAL_HEALED)
	agent.balloon_alert_to_viewers("[agent.name] fully treated!")
	playsound(agent.loc, 'sound/machines/terminal_success.ogg', 20)
	agents -= agent
	QDEL_IN(agent, 2.5 SECONDS)
	animate(agent, 2.5 SECONDS, alpha = 0, easing = CUBIC_EASING)
	if((length(agents)) == 0)
		INVOKE_ASYNC(src, PROC_REF(handle_round_progression))


/datum/tutorial/marine/hospital_corpsman_freeplay/process(delta_time)

	if((length(dragging_agents)) > 0)
		move_dragging_agent()
	if((length(active_agents)) > 0)
		move_active_agents()

/datum/tutorial/marine/hospital_corpsman_freeplay/proc/tutorial_close()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	UnregisterSignal(marine_dummy, COMSIG_HUMAN_SHRAPNEL_REMOVED)

	message_to_player("This officially completes your basic training to be a Marine Horpital Corpsman. However, you still have some skills left to learn!")
	message_to_player("The <b>Hospital Corpsman <u>Advanced</u></b> tutorial will now be unlocked in your tutorial menu. Give it a go!")
	update_objective("Tutorial completed.")


	tutorial_end_in(15 SECONDS)



// Helpers



// Helpers End


// TO DO LIST
//
//




/datum/tutorial/marine/hospital_corpsman_freeplay/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/tutorial/fed)
	tutorial_mob.set_skills(/datum/skills/combat_medic)
	give_action(tutorial_mob, /datum/action/hm_tutorial/sandbox/ready_up, null, null, src)


/datum/tutorial/marine/hospital_corpsman_freeplay/init_map()

	new /obj/structure/machinery/cm_vending/sorted/medical/tutorial(loc_from_corner(1, 0))
	new /obj/structure/machinery/cm_vending/clothing/medic/tutorial(loc_from_corner(2, 3))
	new /obj/structure/machinery/cm_vending/gear/medic/tutorial/(loc_from_corner(3, 3))
	var/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor/prepdoor = locate(/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor) in get_turf(loc_from_corner(4, 1))
	//prepdoor.setDir(2)
	prepdoor.req_one_access = null
	prepdoor.req_access = null
	//prepdoor = new(loc_from_corner(4, 1))
	add_to_tracking_atoms(prepdoor)

/datum/tutorial/marine/hospital_corpsman_freeplay/proc/init_npcs()

	CMOnpc = new(loc_from_corner(7, 7))

/mob/living/carbon/human/realistic_dummy/CMOnpc/Initialize()
	. = ..()
	create_hud()
	arm_equipment(src, /datum/equipment_preset/uscm_ship/uscm_medical/cmo)

/mob/living/carbon/human/realistic_dummy/dragging_agent/Initialize() // Now comes pre-fitted with Marine gear!! Tutorial realism increased by 400%!!!
	. = ..()
	create_hud()
	arm_equipment(src, /datum/equipment_preset/other/realistic_dummy/soldier)
	a_intent = INTENT_DISARM

/obj/structure/machinery/cm_vending/sorted/medical/tutorial
	name = "\improper Tutorial Wey-Med Plus"
	desc = "Medical pharmaceutical dispenser, featuring an expanded selection of Medicine. Provided by Wey-Yu Pharmaceuticals Division(TM)."

	unslashable = TRUE
	wrenchable = FALSE
	hackable = FALSE

	req_access = null

	allow_supply_link_restock = FALSE

/obj/structure/machinery/cm_vending/sorted/medical/tutorial/populate_product_list()
	listed_products = list(
		list("FIELD SUPPLIES", -1, null, null),
		list("Burn Kit", 10, /obj/item/stack/medical/advanced/ointment, VENDOR_ITEM_REGULAR),
		list("Trauma Kit", 10, /obj/item/stack/medical/advanced/bruise_pack, VENDOR_ITEM_REGULAR),
		list("Ointment", 10, /obj/item/stack/medical/ointment, VENDOR_ITEM_REGULAR),
		list("Roll of Gauze", 10, /obj/item/stack/medical/bruise_pack, VENDOR_ITEM_REGULAR),
		list("Splints", 10, /obj/item/stack/medical/splint, VENDOR_ITEM_REGULAR),

		list("AUTOINJECTORS", -1, null, null),
		list("Autoinjector (Bicaridine)", 5, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Dexalin+)", 5, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Epinephrine)", 5, /obj/item/reagent_container/hypospray/autoinjector/adrenaline, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Inaprovaline)", 5, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Kelotane)", 5, /obj/item/reagent_container/hypospray/autoinjector/kelotane, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Oxycodone)", 5, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tramadol)", 5, /obj/item/reagent_container/hypospray/autoinjector/tramadol, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tricord)", 5, /obj/item/reagent_container/hypospray/autoinjector/tricord, VENDOR_ITEM_REGULAR),

		list("LIQUID BOTTLES", -1, null, null),
		list("Bottle (Bicaridine)", 3, /obj/item/reagent_container/glass/bottle/bicaridine, VENDOR_ITEM_REGULAR),
		list("Bottle (Dylovene)", 3, /obj/item/reagent_container/glass/bottle/antitoxin, VENDOR_ITEM_REGULAR),
		list("Bottle (Dexalin)", 3, /obj/item/reagent_container/glass/bottle/dexalin, VENDOR_ITEM_REGULAR),
		list("Bottle (Inaprovaline)", 3, /obj/item/reagent_container/glass/bottle/inaprovaline, VENDOR_ITEM_REGULAR),
		list("Bottle (Kelotane)", 3, /obj/item/reagent_container/glass/bottle/kelotane, VENDOR_ITEM_REGULAR),
		list("Bottle (Oxycodone)", 3, /obj/item/reagent_container/glass/bottle/oxycodone, VENDOR_ITEM_REGULAR),
		list("Bottle (Peridaxon)", 3, /obj/item/reagent_container/glass/bottle/peridaxon, VENDOR_ITEM_REGULAR),
		list("Bottle (Tramadol)", 3, /obj/item/reagent_container/glass/bottle/tramadol, VENDOR_ITEM_REGULAR),

		list("PILL BOTTLES", -1, null, null),
		list("Pill Bottle (Bicaridine)", 4, /obj/item/storage/pill_bottle/bicaridine, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Dexalin)", 4, /obj/item/storage/pill_bottle/dexalin, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Dylovene)", 4, /obj/item/storage/pill_bottle/antitox, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Inaprovaline)", 4, /obj/item/storage/pill_bottle/inaprovaline, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Kelotane)", 4, /obj/item/storage/pill_bottle/kelotane, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Peridaxon)", 4, /obj/item/storage/pill_bottle/peridaxon, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Tramadol)", 4, /obj/item/storage/pill_bottle/tramadol, VENDOR_ITEM_REGULAR),

		list("RESTRICTED PILL BOTTLES", -1, null, null),

		list("MEDICAL UTILITIES", -1, null, null),
		list("Emergency Defibrillator", 3, /obj/item/device/defibrillator, VENDOR_ITEM_REGULAR),
		list("Surgical Line", 2, /obj/item/tool/surgery/surgical_line, VENDOR_ITEM_REGULAR),
		list("Synth-Graft", 2, /obj/item/tool/surgery/synthgraft, VENDOR_ITEM_REGULAR),
		list("Hypospray", 3, /obj/item/reagent_container/hypospray/tricordrazine, VENDOR_ITEM_REGULAR),
		list("Health Analyzer", 5, /obj/item/device/healthanalyzer, VENDOR_ITEM_REGULAR),
		list("M276 Pattern Medical Storage Rig", 2, /obj/item/storage/belt/medical, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 3, /obj/item/clothing/glasses/hud/health, VENDOR_ITEM_REGULAR),
		list("Stasis Bag", 3, /obj/item/bodybag/cryobag, VENDOR_ITEM_REGULAR),
		list("Syringe", 7, /obj/item/reagent_container/syringe, VENDOR_ITEM_REGULAR)
	)

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
		list("Standard Marine Apparel", 0, list(/obj/item/clothing/under/marine/medic, /obj/item/clothing/shoes/marine, /obj/item/clothing/gloves/marine), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
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

/datum/action/hm_tutorial/sandbox/ready_up/New(Target, override_icon_state, datum/tutorial/marine/hospital_corpsman_freeplay/selected_tutorial)
	. = ..()
	tutorial = WEAKREF(selected_tutorial)

/datum/action/hm_tutorial/sandbox/ready_up/action_activate()
	. = ..()
	if(!tutorial)
		return

	var/datum/tutorial/marine/hospital_corpsman_freeplay/selected_tutorial = tutorial.resolve()

	selected_tutorial.end_supply_phase()
