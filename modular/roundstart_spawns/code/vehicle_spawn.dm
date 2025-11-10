// ==========================================
// =============== Мотоциклы ================

/datum/roundstart_spawn/motorbike
	object_to_spawn = list(
		/obj/vehicle/motorbike/camo/full,
		// /obj/item/pamphlet/skill/vc/low,
	)
	min_spawns = 1
	max_spawns = 3
	range = 1
	required_players = 60

// /datum/roundstart_spawn/motorbike/intel
// 	object_to_spawn = list(
// 		/obj/vehicle/motorbike/camo, // Без коляски
// 		// /obj/item/pamphlet/skill/vc/low,
// 	)
// 	attached_to_type = /obj/effect/landmark/start/intel
// 	min_spawns = 2

/datum/roundstart_spawn/motorbike/mp
	object_to_spawn = list(
		/obj/vehicle/motorbike/urban/full,	// Городской
		// /obj/item/pamphlet/skill/vc/low,
	)
	attached_to_type = /obj/effect/landmark/late_join/chief_police
	max_spawns = 1

/datum/roundstart_spawn/motorbike/cargo
	attached_to_type = /obj/effect/landmark/start/cargo
	min_spawns = 0
	max_spawns = 2

/datum/roundstart_spawn/motorbike/req
	attached_to_type = /obj/effect/landmark/start/requisition
	max_spawns = 1

/datum/roundstart_spawn/motorbike/crc
	object_to_spawn = list(
		/obj/vehicle/motorbike/urban, // Без коляски, городской
		/obj/item/pamphlet/skill/vc/low,
	)
	attached_to_type = /obj/effect/landmark/start/crew_chief
	min_spawns = 0
	max_spawns = 2
	required_players = 90

// ==========================================
