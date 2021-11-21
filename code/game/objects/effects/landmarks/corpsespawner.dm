///////////////////// LANDMARK CORPSE ///////


//These are meant for spawning on maps, namely Away Missions.

/obj/effect/landmark/corpsespawner
	name = "Unknown"
	icon_state = "corpse_spawner"
	var/equip_path = null

/obj/effect/landmark/corpsespawner/Initialize(mapload, ...)
	. = ..()
	GLOB.corpse_spawns += src

/obj/effect/landmark/corpsespawner/Destroy()
	GLOB.corpse_spawns -= src
	return ..()

/obj/effect/landmark/corpsespawner/realpirate
	name = "Pirate"
	equip_path = /datum/equipment_preset/corpse/realpirate

/obj/effect/landmark/corpsespawner/realpirate/ranged
	name = "Pirate Gunner"
	equip_path = /datum/equipment_preset/corpse/realpirate/ranged

/obj/effect/landmark/corpsespawner/russian
	name = "Russian"
	equip_path = /datum/equipment_preset/corpse/russian

/obj/effect/landmark/corpsespawner/russian/ranged

///////////Civilians//////////////////////

/obj/effect/landmark/corpsespawner/prisoner
	name = "Prisoner"
	equip_path = /datum/equipment_preset/corpse/prisoner

/obj/effect/landmark/corpsespawner/chef
	name = "Chef"
	equip_path = /datum/equipment_preset/corpse/chef

/obj/effect/landmark/corpsespawner/doctor
	name = "Doctor"
	equip_path = /datum/equipment_preset/corpse/doctor

/obj/effect/landmark/corpsespawner/engineer
	name = "Engineer"
	equip_path = /datum/equipment_preset/corpse/engineer

/obj/effect/landmark/corpsespawner/clown
	name = "Clown"
	equip_path = /datum/equipment_preset/corpse/clown

/obj/effect/landmark/corpsespawner/scientist
	name = "Scientist"
	equip_path = /datum/equipment_preset/corpse/scientist

/obj/effect/landmark/corpsespawner/miner
	name = "Shaft Miner"
	equip_path = /datum/equipment_preset/corpse/miner

/obj/effect/landmark/corpsespawner/security
	name = "Security"
	equip_path = /datum/equipment_preset/corpse/security

/obj/effect/landmark/corpsespawner/security/cmb
	name = "Marshal"
	equip_path = /datum/equipment_preset/corpse/security/marshal

/obj/effect/landmark/corpsespawner/security/lawyer
	name = "Lawyer"
	equip_path = /datum/equipment_preset/corpse/security/lawyer

/obj/effect/landmark/corpsespawner/prison_security
	name = "Prison Guard"
	equip_path = /datum/equipment_preset/corpse/prison_security

/////////////////Officers//////////////////////

/obj/effect/landmark/corpsespawner/bridgeofficer
	name = "Staff Officer"
	equip_path = /datum/equipment_preset/corpse/bridgeofficer

/obj/effect/landmark/corpsespawner/bridgeofficer/johnson
	name = "Mr. Johnson Telovin"
	equip_path = /datum/equipment_preset/corpse/bridgeofficer/johnson

/obj/effect/landmark/corpsespawner/commander
	name = "Commanding Officer"
	equip_path = /datum/equipment_preset/corpse/commander

/obj/effect/landmark/corpsespawner/PMC
	name = "Private Security Officer"
	equip_path = /datum/equipment_preset/corpse/PMC

///CM specific jobs///

/obj/effect/landmark/corpsespawner/colonist //default is a colonist
	name = "Colonist"
	equip_path = /datum/equipment_preset/corpse/colonist

/obj/effect/landmark/corpsespawner/colonist/burst
	name = "Burst Colonist"
	equip_path = /datum/equipment_preset/corpse/colonist/burst

/obj/effect/landmark/corpsespawner/ua_riot
	name = "UA Officer"
	equip_path = /datum/equipment_preset/corpse/ua_riot

/obj/effect/landmark/corpsespawner/ua_riot/burst
	name = "Burst UA Officer"
	equip_path = /datum/equipment_preset/corpse/ua_riot/burst
