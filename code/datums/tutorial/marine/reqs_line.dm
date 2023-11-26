/* List of Reqs Line tutorial stages */
#define TUTORIAL_REQS_STAGE_STARTING 0    //! Reqs Tutorial Stage 0: Get in position
#define TUTORIAL_REQS_STAGE_ATTACHIES 1   //! Reqs Tutorial Stage 1: Give me some attachies
#define TUTORIAL_REQS_STAGE_GEARBOX 2     //! Reqs Tutorial Stage 2: I would like an HPR
#define TUTORIAL_REQS_STAGE_MIXED 3       //! Reqs Tutorial Stage 3: A little bit of this, and of that...
#define TUTORIAL_REQS_STAGE_IFORGOT 4     //! Reqs Tutorial Stage 4: Toss me that item please
#define TUTORIAL_REQS_STAGE_SURVIVAL 5    //! Reqs Tutorial Stage 5: SURVIVAL MODE, random requests in a loop

/* List of item categories to consider when building item requests */
#define TUTORIAL_REQS_ITEMS_ATTACHIES "attachies"
#define TUTORIAL_REQS_ITEMS_GEARBOX "gearbox"
#define TUTORIAL_REQS_ITEMS_AMMO "ammo"
#define TUTORIAL_REQS_ITEMS_EXPLOSIVES "explosives"


/// Simulates the Requisitions Line experience for newcomers
/datum/tutorial/marine/req_line
	name = "Marine - Requistions Line"
	desc = "Learn how to tend to the requisitions line as a Cargo Technician."
	tutorial_id = "requisitions_line"
	tutorial_template = /datum/map_template/tutorial/reqline

	/// Current step of the tutorial we're at
	var/stage = TUTORIAL_REQS_STAGE_STARTING
	/// Current "remind" timer after which the agent will remind player of its request
	var/remind_timer
	/// Current "hint" timer after which we display visual cues like highlights
	var/hint_timer

	/// List of line 'agents', aka the dummies requesting items, sorted by line order
	/// During normal stages there is one per stage (except for Forgot stage),
	/// During Survival mode there would usually be two: one at the counter, and one moving.
	/// The agents are mapped to a list of item types requested.
	var/list/mob/living/carbon/human/agents = list()

	/// Active agent currently at the line
	var/mob/living/carbon/human/active_agent
	/// Specifically for [TUTORIAL_REQS_STAGE_IFORGOT], the agent that forgot an item
	var/mob/living/carbon/human/loser_agent

	/// Cooldown of confusion if an incorrect item is presented
	COOLDOWN_DECLARE(confused_cooldown)

	/*
	 * REQUESTS LISTS
	 *   Maps item type to its information:
	 *   First arg is the category.
	 *   All other list items are names that can be given to it.
	 *   This is what we use to generate our line shopping lists.
	 */
	var/static/shopping_catalogue = list(
		/obj/item/attachable/extended_barrel = list(TUTORIAL_REQS_ITEMS_ATTACHIES, "EB", "Extended", "Extended Barrel", "Extendo", "Ext Barrel"),
		/obj/item/attachable/magnetic_harness = list(TUTORIAL_REQS_ITEMS_ATTACHIES, "MH", "Magharn", "Mag Harn", "Mag Harness", "Harness", "Magnetic Harness"),
		/obj/item/attachable/reddot = list(TUTORIAL_REQS_ITEMS_ATTACHIES, "RDS", "Red Dot", "S5", "Red Dot Sight", "reddot"),
		/obj/item/attachable/reflex = list(TUTORIAL_REQS_ITEMS_ATTACHIES, "Reflex", "S6", "Reflex Sight", "S6"),
		/obj/item/attachable/scope = list(TUTORIAL_REQS_ITEMS_ATTACHIES, "S8", "4x", "4x sight", "4x scope", "S8 scope"),
		/obj/item/attachable/angledgrip = list(TUTORIAL_REQS_ITEMS_ATTACHIES, "AG", "agrip", "Agrip", "Angled", "angled grip"),
		/obj/item/attachable/gyro = list(TUTORIAL_REQS_ITEMS_ATTACHIES, "Gryro"),
	)

/datum/tutorial/marine/req_line/Destroy(force)
	. = ..()
	STOP_PROCESSING(SSobj, src)
	kill_timers()
	active_agent = null
	loser_agent = null
	agents.Cut()

/datum/tutorial/marine/req_line/init_map()
	var/obj/structure/machinery/cm_vending/sorted/attachments/blend/attachies_vendor = new(loc_from_corner(4, 11))
	add_to_tracking_atoms(attachies_vendor)
	var/obj/structure/machinery/cm_vending/sorted/cargo_guns/cargo/blend/tutorial/guns_vendor = new(loc_from_corner(5, 11))
	add_to_tracking_atoms(guns_vendor)
	var/obj/structure/machinery/cm_vending/sorted/cargo_ammo/cargo/blend/tutorial/ammo_vendor = new(loc_from_corner(6, 11))
	add_to_tracking_atoms(ammo_vendor)
	var/turf/asker_turf = loc_from_corner(3, 10)
	RegisterSignal(asker_turf, COMSIG_TURF_ENTERED, PROC_REF(a_new_challenger_appears))
	var/turf/trade_turf = loc_from_corner(4, 10)
	RegisterSignal(trade_turf, COMSIG_TURF_ENTERED, PROC_REF(item_offered))

/datum/tutorial/marine/req_line/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/uscm_ship/cargo)
	// Remove their radio from CT preset
	var/mob/living/carbon/human/user = tutorial_mob
	var/obj/item/device/radio/headset/headset = user.wear_l_ear
	user.drop_inv_item_on_ground(headset)
	QDEL_NULL(headset)

/datum/tutorial/marine/req_line/process(delta_time)
	var/skip_first = TRUE
	for(var/mob/living/carbon/human/agent as anything in agents)
		if(stage == TUTORIAL_REQS_STAGE_IFORGOT && skip_first)
			skip_first = FALSE
			continue
		if(!agent_step(NORTH))
			agent_step(EAST)

/// Makes agents move on processing tick if they can. They check surroundings to ensure proper movement flow.
/datum/tutorial/marine/req_line/proc/agent_step(mob/living/carbon/human/agent, dir)
	var/turf/target_turf = get_step(agent, dir)
	if(locate(/turf/closed) in target_turf)
		return FALSE
	if(locate(/mob/living) in target_turf)
		return FALSE
	// Don't try to step back through the turnstile
	if(dir == EAST && locate(/obj/structure/machinery/line_nexter) in target_turf)
		return FALSE
	. = TRUE
	agent.Move(target_turf, dir)

/// Creates a new agent with the given request list to queue in the line
/datum/tutorial/marine/req_line/proc/spawn_agent(list/request = list())
	var/turf/target_turf = loc_from_corner(3, 4)
	var/mob/living/carbon/human/dummy/agent = new(target_turf)
	arm_equipment(agent, /datum/equipment_preset/uscm/tutorial_rifleman)
	agents[agent] = request
	RegisterSignal(agent, COMSIG_PARENT_QDELETED, PROC_REF(clean_agent))

/// Called when an agent presents at the line window and needs to make a request
/datum/tutorial/marine/req_line/proc/a_new_challenger_appears(turf/source, mob/living/carbon/human/challenger)
	SIGNAL_HANDLER
	if(!(challenger in agents)) // Bob Vancelave NOT allowed
		return
	if(loser_agent) // We already need to handle that annoying guy
		return
	active_agent = challenger
	if(!length(request))
		make_agent_leave()
		return
	var/list/request = agents[challenger]
	var/speech = verbalize_request(request)
	var/greeting = pick("Hello! ", "hi, ", "hey, ", "Good day.", "I need ", "Please give me ", "", "") // Yes, no greeting is a greeting option for real world accuracy
	var/trailing = pick("", ", please.", " - please and thank you", ", thanks.", ", quick")
	challenger.say("[greeting][speech][trailing]") // Pleasantries for the first exchange only
	remind_timer = addtimer(CALLBACK(src, PROC_REF(remind_request)), 20 SECONDS, TIMER_STOPPABLE)
	hint_timer = addtimer(CALLBACK(src, PROC_REFF(send_hints)), 4 SECONDS, TIMER_STOPPABLE)

/// Called when we need to remind the user of what we want served
/datum/tutorial/marine/req_line/proc/remind_request()
	var/list/request = agents[active_agent]
	var/speech = verbalize_request(request)
	active_agent.say(speech)
	remind_timer = addtimer(CALLBACK(src, PROC_REF(remind_request)), 20 SECONDS, TIMER_STOPPABLE)

/// Transforms the list of required items by the agent into a string request for the user
/datum/tutorial/marine/req_line/proc/verbalize_request(list/request)
	var/output_string = ""
	var/counts = list()
	for(var/item in request)
		if(item in counts)
			counts[item]++
		else
			counts[item] = 1
	var/first = TRUE
	for(var/item in counts)
		var/list/info = shopping_catalogue[item]
		var/word = info[rand(2, info.len)]
		if(!first)
			output_string += ", "
		first = FALSE
		if(counts[item] > 1)
			output_string += "[counts[item]] "
		output_string += word
	return output_string

/// Triggered when an object is put on the table. The agent evaluates if that's something they want and reacts appropriately.
/datum/tutorial/marine/req_line/proc/item_offered(turf/source, obj/item/item, silent = FALSE)
	SIGNAL_HANDLER
	if(!active_agent || loser_agent)
		return
	var/list/request = agents[active_agent]
	if(!(item.type in request))
		if(!silent && COOLDOWN_FINISHED(src, confused_cooldown))
			COOLDOWN_START(src, confused_cooldown, 5 SECONDS)
			active_agent.say("Huh?")
		return

	request -= item.type
	agent_pick_up(active_agent, item)

	// If there's nothing left to pick up, we leave
	if(!length(request))
		make_agent_leave(success = TRUE)

/datum/tutorial/marine/req_line/proc/agent_pick_up(mob/agent, obj/item/item)
	// Actually pick the item up for the animation
	agent.put_in_hands(item, drop_on_fail = FALSE)
	playsound(agent, "rustle", 30)
	// Now delete it
	agent.temp_drop_inv_item(item)
	qdel(item)

/datum/tutorial/marine/req_line/proc/make_agent_leave(success = FALSE)
	switch(stage)
		if(TUTORIAL_REQS_STAGE_ATTACHIES)
			continue_stage_gearbox()
		if(TUTORIAL_REQS_STAGE_GEARBOX)
			continue_stage_mixed()
		if(TUTORIAL_REQS_STAGE_MIXED)
			wait_i_forgot_something()
		if(TUTORIAL_REQS_STAGE_IFORGOT)
			return // Logic handled elsewhere, this shouldn't even happen.
		if(TUTORIAL_REQS_STAGE_SURVIVAL)
			continue_stage_survival()
	clean_items()
	kill_timers()

	if(!active_agent)
		return // Nani?

	if(success && prob(80))
		var/speech = pick("Thanks!", "thanks bro", "Thank you.")
		active_agent.say(speech)

	// Immediately step the agent through the turnstile and towards exit
	var/turf/target_turf = get_step(active_agent, WEST)
	active_agent.Move(target_turf, WEST)
	active_agent = null

/// Cleanup when an agent reaches the exit
/datum/tutorial/marine/req_line/proc/clean_agent(datum/source)
	SIGNAL_HANDLER
	agents -= source
	if(active_agent == source)
		active_agent = null

/// Cleanup the table and ground contents when an agent leaves the line
/datum/tutorial/marine/req_line/proc/clean_items()
	var/turf/trade_turf = loc_from_corner(4, 10)
	for(var/obj/item/item in trade_turf)
		qdel(item)
	var/turf/forgot_turf = loc_from_corner(2, 10)
	for(var/obj/item/item in forgot_turf)
		qdel(item)

/// Kills active timers to reset state
/datum/tutorial/marine/req_line/proc/kill_timers()
	if(remind_timer)
		deltimer(remind_timer)
		remind_timer = null
	if(hint_timer) // User was just that fast
		deltimer(hint_timer)
		hint_timer = null

/// Displays appropriate hints for the user based on tutorial stage
/datum/tutorial/marine/req_line/proc/send_hints()
	switch(stage)
		if(TUTORIAL_REQS_STAGE_ATTACHIES)
			TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/attachments/blend, attachies_vendor)
			add_highlight(attachies_vendor)
			message_to_player("This marine wants attachies. You can find them in the leftmost vendor.")
			update_objective("Serve the marine's request using the vendors.")

/datum/tutorial/marine/req_line/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	START_PROCESSING(SSobj, src)

	message_to_player("Welcome to Requisitions Line tutorial. Come in and have a seat.")
	update_objective("Reach the line window to begin!")
	var/turf/target_turf = loc_from_corner(5, 10)
	RegisterSignal(target_turf, COMSIG_TURF_ENTERED, PROC_REF(user_in_position))


// TODO below

/// Called when the player is in position to start handling the line
/datum/tutorial/marine/req_line/proc/user_in_position(turf/source, atom/movable/mover)
	SIGNAL_HANDLER
	if(mover != tutorial_mob)
		return
	UnregisterSignal(source, COMSIG_TURF_ENTERED)
	stage = TUTORIAL_REQS_STAGE_ATTACHIES
	var/list/request = list(/obj/item/attachable/magnetic_harness, /obj/item/attachable/extended_barrel)
	spawn_agent(request)

/datum/tutorial/marine/req_line/proc/continue_stage_gearbox()
	message_to_player("Success!") //placeholder
/datum/tutorial/marine/req_line/proc/continue_stage_mixed()
/datum/tutorial/marine/req_line/proc/wait_i_forgot_something()
	loser_agent = active_agent
	stage = TUTORIAL_REQS_STAGE_IFORGOT

/datum/tutorial/marine/req_line/proc/i_found_the_item()
	loser_agent = null
	// At this point there shouldn't be anyone left in line,
	// so we don't have to worry about resuming from previous state
	// We just boot up survival mode


/datum/tutorial/marine/req_line/proc/continue_stage_survival()

/datum/map_template/tutorial/reqline
	name = "Reqs Line Tutorial (8x13)"
	mappath = "maps/tutorial/tutorial_reqs.dmm"
	width = 8
	height = 13

/* === ITEMS USED IN THE TUTORIAL === */

/// Deletes dummies coming onto it, purely and simply
/obj/effect/landmark/tutorial/reqs_line_cleaner/Crossed(atom/movable/passer)
	if(istype(passer, /mob/living/carbon/human/dummy))
		qdel(passer)

/// Draws attention to a location on the ground. Sorry Zonespace i like the highlighters but there's nothing to highlight for this...
/obj/effect/overlay/static_pointer
	name = "arrow"
	desc = "Pay attention! Look here!"
	icon = 'icons/mob/hud/screen1.dmi'
	icon_state = "big_arrow"

/* === VENDORS USED IN THE TUTORIAL === */

/obj/structure/machinery/cm_vending/sorted/cargo_guns/cargo/blend/tutorial

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/cargo/blend/tutorial

/* === AGENTS USED IN THE TUTORIAL === */
/datum/equipment_preset/uscm/tutorial_rifleman
	name = "Tutorial Rifleman"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	assignment = JOB_SQUAD_MARINE
	rank = JOB_SQUAD_MARINE
	paygrade = "ME2"
	role_comm_title = "RFN"
	skills = /datum/skills/pfc/crafty
	minimap_icon = "private"

/datum/equipment_preset/uscm/tutorial_rifleman/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
