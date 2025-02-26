

/*LANDMARK SPAWNS*/

//Yes, I know that for landmarks you only need the name for it to work. This is for ease of access when spawning in the landmarks for events.
/obj/effect/landmark/whiskey_outpost
	icon_state = "x3"
	invisibility = 0

/obj/effect/landmark/whiskey_outpost/supplydrops
	name = "whiskey_outpost_supply"
	icon_state = "supply"

/obj/effect/landmark/whiskey_outpost/xenospawn
	name = "Xeno Spawn"
	icon_state = "xeno_spawn"


//Landmarks to spawn in more landmarks. Would you like redundancy on your redundancy?
//But in seriousness, this is for admins to spawn in, so they only need to spawn in 4-8 things, instead of 200+, making the delay for round start much shorter for players.
/obj/effect/landmark/wo_spawners
	name = "landmark spawner"
	var/obj/effect/landmark/Landmark = null //The landmarks we'll spawn in
	var/range = 3 //The range we'll spawn these in at.
	invisibility = 0

/obj/effect/landmark/wo_spawners/New()
	..()
	var/num
	for(var/turf/open/O in range(range))
		new Landmark(O)
		num ++
	sleep(5)
	message_admins("[num] [src]\s were spawned in at [loc.loc.name] ([loc.x],[loc.y],[loc.z]). [ADMIN_JMP(loc)]")
	qdel(src)

/obj/effect/landmark/wo_spawners/supplydrops
	name = "supply drop location"
	icon_state = "supply"
	Landmark = /obj/effect/landmark/whiskey_outpost/supplydrops
	range = 2

/obj/effect/landmark/wo_spawners/xenospawn
	name = "xeno location 1 spawn point"
	icon_state = "xeno_spawn"
	Landmark = /obj/effect/landmark/whiskey_outpost/xenospawn
