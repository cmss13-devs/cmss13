/// How many smallhosts to preassigned players to spawn?
#define MONKEYS_TO_TOTAL_RATIO 1/32
/// When to start opening the podlocks identified as "map_lockdown" (takes 30s)
#define PODLOCKS_OPEN_WAIT (45 MINUTES) // CORSAT pod doors drop at 12:45
/// How many pipes explode at a time during hijack?
#define HIJACK_EXPLOSION_COUNT 5
/// What percent do we consider a 'majority?' to win
#define MAJORITY 0.5
/// How long to delay the round completion (command is immediately notified)
#define MARINE_MAJOR_ROUND_END_DELAY (3 MINUTES)
/// The ratio of forsaken to groundside humans before calling more forsaken xenos
#define GROUNDSIDE_XENO_MULTIPLIER 1.0

/datum/game_mode/colonialmarines/upp
	name = "UPP Distress Signal"
	config_tag = "UPP Distress Signal"
//	role_mappings = list(
//		/datum/job/command/commander/whiskey = JOB_CO,
//	)

/datum/game_mode/colonialmarines/upp/get_roles_list()
	return UPP_JOB_LIST + GLOB.ROLES_GROUND

///Spawns a droppod with a temporary defense sentry at the given turf
/datum/game_mode/colonialmarines/upp/spawn_lz_sentry(turf/target, list/structures_to_break)
	var/obj/structure/droppod/equipment/sentry_holder/droppod = new(target, /obj/structure/machinery/sentry_holder/landing_zone/upp)
	droppod.special_structures_to_damage = structures_to_break
	droppod.special_structure_damage = 500
	droppod.drop_time = 0
	droppod.launch(target)

#undef MONKEYS_TO_TOTAL_RATIO
#undef PODLOCKS_OPEN_WAIT
#undef HIJACK_EXPLOSION_COUNT
#undef MAJORITY
#undef MARINE_MAJOR_ROUND_END_DELAY
#undef GROUNDSIDE_XENO_MULTIPLIER
