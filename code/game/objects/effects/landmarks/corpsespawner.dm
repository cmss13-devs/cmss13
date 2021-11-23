///////////////////// LANDMARK CORPSE ///////


//These are meant for spawning on maps, namely Away Missions.

/obj/effect/landmark/corpsespawner
	name = "Unknown"
	icon_state = "corpse_spawner"

/obj/effect/landmark/corpsespawner/Initialize(mapload, ...)
	. = ..()
	GLOB.corpse_spawns += src

/obj/effect/landmark/corpsespawner/Destroy()
	GLOB.corpse_spawns -= src
	return ..()

/obj/effect/landmark/corpsespawner/realpirate
	name = "Pirate"

/obj/effect/landmark/corpsespawner/realpirate/ranged
	name = "Pirate Gunner"

/obj/effect/landmark/corpsespawner/russian
	name = "Russian"

/obj/effect/landmark/corpsespawner/russian/ranged

///////////Civilians//////////////////////

/obj/effect/landmark/corpsespawner/prisoner
	name = "Prisoner"

/obj/effect/landmark/corpsespawner/chef
	name = "Chef"

/obj/effect/landmark/corpsespawner/doctor
	name = "Doctor"

/obj/effect/landmark/corpsespawner/engineer
	name = "Engineer"

/obj/effect/landmark/corpsespawner/clown
	name = "Clown"

/obj/effect/landmark/corpsespawner/scientist
	name = "Scientist"

/obj/effect/landmark/corpsespawner/miner
	name = "Shaft Miner"

/obj/effect/landmark/corpsespawner/security
	name = "Security"

/obj/effect/landmark/corpsespawner/security/cmb
	name = "Marshal"

/obj/effect/landmark/corpsespawner/security/lawyer
	name = "Lawyer"

/obj/effect/landmark/corpsespawner/prison_security
	name = "Prison Guard"

/////////////////Officers//////////////////////

/obj/effect/landmark/corpsespawner/bridgeofficer
	name = "Staff Officer"

/obj/effect/landmark/corpsespawner/bridgeofficer/johnson
	name = "Mr. Johnson Telovin"

/obj/effect/landmark/corpsespawner/commander
	name = "Commanding Officer"

/obj/effect/landmark/corpsespawner/PMC
	name = "Private Security Officer"

///CM specific jobs///

/obj/effect/landmark/corpsespawner/colonist //default is a colonist
	name = "Colonist"

/obj/effect/landmark/corpsespawner/colonist/burst
	name = "Burst Colonist"

/obj/effect/landmark/corpsespawner/ua_riot
	name = "UA Officer"

/obj/effect/landmark/corpsespawner/ua_riot/burst
	name = "Burst UA Officer"
