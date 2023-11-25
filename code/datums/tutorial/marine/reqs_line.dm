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

	/// List of line 'agents', aka the dummies requesting items, sorted by line order
	/// During normal stages there is one per stage (except for Forgot stage),
	/// During Survival mode there would usually be two: one at the counter, and one moving.
	/// The agents are mapped to a list of item types requested.
	var/list/mob/living/carbon/human/agents = list()

	/*
	 * REQUESTS LISTS
	 *   First arg is the category. Second arg is the item path.
	 *   All other list items are names that can be given to it.
	 *   This is what we use to generate our line shopping lists.
	 */
	var/static/shopping_catalogue = list(
		list(TUTORIAL_REQS_ITEMS_ATTACHIES, /obj/item/attachable/extended_barrel, "EB", "Extended", "Extended Barrel", "Extendo", "Ext Barrel"),
		list(TUTORIAL_REQS_ITEMS_ATTACHIES, /obj/item/attachable/magnetic_harness, "MH", "Magharn", "Mag Harn", "Mag Harness", "Harness", "Magnetic Harness"),
		list(TUTORIAL_REQS_ITEMS_ATTACHIES, /obj/item/attachable/reddot, "RDS", "Red Dot", "S5", "Red Dot Sight", "reddot"),
		list(TUTORIAL_REQS_ITEMS_ATTACHIES, /obj/item/attachable/reflex, "Reflex", "S6", "Reflex Sight", "S6"),
		list(TUTORIAL_REQS_ITEMS_ATTACHIES, /obj/item/attachable/scope, "S8", "4x", "4x sight", "4x scope", "S8 scope"),
		list(TUTORIAL_REQS_ITEMS_ATTACHIES, /obj/item/attachable/angledgrip, "AG", "agrip", "Agrip", "Angled", "angled grip"),
		list(TUTORIAL_REQS_ITEMS_ATTACHIES, /obj/item/attachable/gyro, "Gryro"),
	)

/datum/tutorial/marine/req_line/init_map()
	var/obj/structure/machinery/cm_vending/sorted/attachments/blend/attachies_vendor = new(loc_from_corner(4, 11))
	add_to_tracking_atoms(attachies_vendor)
	var/obj/structure/machinery/cm_vending/sorted/cargo_guns/cargo/blend/tutorial/guns_vendor = new(loc_from_corner(5, 11))
	add_to_tracking_atoms(guns_vendor)
	var/obj/structure/machinery/cm_vending/sorted/cargo_ammo/cargo/blend/tutorial/ammo_vendor = new(loc_from_corner(6, 11))
	add_to_tracking_atoms(ammo_vendor)
	var/turf/asker_turf = loc_from_corner(3, 10)
	RegisterSignal(asker_turf, COMSIG_TURF_ENTERED, PROC_REF(a_new_challenger_appears))

/datum/tutorial/marine/req_line/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/uscm_ship/cargo)
	// Remove their radio
	var/mob/living/carbon/human/user = tutorial_mob
	var/obj/item/device/radio/headset/headset = user.wear_l_ear
	user.drop_inv_item_on_ground(headset)
	QDEL_NULL(headset)

/datum/tutorial/marine/req_line/process(delta_time)
	var/skip_first = TRUE
	for(var/mob/living/carbon/human/agent in agents)
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
/datum/tutorial/marine/req_line/proc/a_new_challenger_appears(mob/living/carbon/human/challenger)
	if(challenger != agents[1]) // What? Get out of here
		return
	var/list/request = agents[challenger]
	var/speech = verbalize_request(request)
	var/greeting = pick("Hello! ", "hi, ", "hey, ", "Good day.", "", "") // Yes, no greeting is a greeting option for real world accuracy
	challenger.say("[greeting][speech]")
	remind_timer = addtimer(CALLBACK(src, ))

/datum/tutorial/marine/req_line/proc/clean_agent(datum/source)
	SIGNAL_HANDLER
	agents -= source

/datum/tutorial/marine/req_line/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	START_PROCESSING(SSobj, src)

	message_to_player("Welcome to Requisitions Line tutorial. Please have a seat.")
	update_objective("Reach the start of the line to begin!")
	var/turf/target_turf = loc_from_corner(5, 10)
	RegisterSignal(target_turf, COMSIG_TURF_ENTERED, PROC_REF(user_in_position))

/// Called when the player is in position to start handling the line
/datum/tutorial/marine/req_line/proc/user_in_position(atom/movable/mover)
	SIGNAL_HANDLER
	if(mover != tutorial_mob)
		return
	stage = TUTORIAL_REQS_STAGE_ATTACHIES

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

/// Draws attention to a location on the ground. Sorry Zonespace i like the highlighters but there's nothing to highlight...
/obj/effect/overlay/static_pointer
	name = "arrow"
	desc = "Pay attention! Look here!"
	icon = 'icons/mob/hud/screen1.dmi'
	icon_state = "big_arrow"

/* === VENDORS USED IN THE TUTORIAL === */

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
