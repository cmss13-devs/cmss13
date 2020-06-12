


///////////////////// LANDMARK CORPSE ///////


//These are meant for spawning on maps, namely Away Missions.

//If someone can do this in a neater way, be my guest-Kor

/obj/effect/landmark/corpsespawner
	name = "Unknown"

/obj/effect/landmark/corpsespawner/Initialize()
	. = ..()
	if(loc && !disposed) //there's some issue with the code that calls this initialize twice,
		createCorpse()	//once normally and once when the landmark is in null space, thus spawning a mob there
						//this is a bandaid until it's properly fixed.

/obj/effect/landmark/corpsespawner/proc/createCorpse() //Creates a mob and checks for gear in each slot before attempting to equip it.
	var/mob/living/carbon/human/M = new /mob/living/carbon/human(src.loc)
	M.create_hud() //Need to generate hud before we can equip anything apparently...
	arm_equipment(M, "Corpse - [name]", TRUE, FALSE)
	qdel(src)

// I'll work on making a list of corpses people request for maps, or that I think will be commonly used. Syndicate operatives for example.

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