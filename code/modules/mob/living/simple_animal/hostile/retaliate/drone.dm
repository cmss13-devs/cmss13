
//malfunctioning combat drones
/mob/living/simple_animal/hostile/retaliate/malf_drone
	name = "combat drone"
	desc = "An automated combat drone armed with state of the art weaponry and shielding."
	icon_state = "drone3"
	icon_living = "drone3"
	icon_dead = "drone_dead"
	ranged = 1
	rapid = 1
	speak_chance = 5
	turns_per_move = 3
	response_help = "pokes the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speak = list("ALERT.","Hostile-ile-ile entities dee-twhoooo-wected.","Threat parameterszzzz- szzet.","Bring sub-sub-sub-systems uuuup to combat alert alpha-a-a.")
	emote_see = list("beeps menacingly","whirrs threateningly","scans its immediate vicinity")
	a_intent = INTENT_HARM
	stop_automated_movement_when_pulled = 0
	health = 300
	maxHealth = 300
	speed = 8
	projectiletype = /obj/projectile/beam/drone
	projectilesound = 'sound/weapons/Laser3.ogg'
	destroy_surroundings = 0
	var/datum/effect_system/ion_trail_follow/ion_trail

	//the drone randomly switches between these states because it's malfunctioning
	var/hostile_drone = 0
	//0 - retaliate, only attack enemies that attack it
	//1 - hostile, attack everything that comes near

	var/turf/patrol_target
	var/explode_chance = 1
	var/disabled = 0
	var/exploding = 0

	//Drones aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	var/has_loot = TRUE
	faction = "malf_drone"

/mob/living/simple_animal/hostile/retaliate/malf_drone/Initialize()
	. = ..()
	if(prob(5))
		projectiletype = /obj/projectile/beam/pulse/drone
		projectilesound = 'sound/weapons/pulse2.ogg'
	ion_trail = new
	ion_trail.set_up(src)
	ion_trail.start()

/mob/living/simple_animal/hostile/retaliate/malf_drone/Process_Spacemove(check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/retaliate/malf_drone/ListTargets()
	if(hostile_drone)
		return view(src, 10)
	else
		return ..()

//self repair systems have a chance to bring the drone back to life
/mob/living/simple_animal/hostile/retaliate/malf_drone/Life(delta_time)

	//emps and lots of damage can temporarily shut us down
	if(disabled > 0)
		set_stat(UNCONSCIOUS)
		icon_state = "drone_dead"
		disabled--
		wander = 0
		speak_chance = 0
		if(disabled <= 0)
			set_stat(CONSCIOUS)
			icon_state = "drone0"
			wander = 1
			speak_chance = 5

	//repair a bit of damage
	if(prob(1))
		src.visible_message(SPAN_DANGER("[icon2html(src, viewers(src))] [src] shudders and shakes as some of it's damaged systems come back online."))
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		health += rand(25,100)

	//spark for no reason
	if(prob(5))
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(3, 1, src)
		s.start()

	//sometimes our targeting sensors malfunction, and we attack anyone nearby
	if(prob(disabled ? 0 : 1))
		if(hostile_drone)
			src.visible_message(SPAN_NOTICE("[icon2html(src, viewers(src))] [src] retracts several targeting vanes, and dulls it's running lights."))
			hostile_drone = 0
		else
			src.visible_message(SPAN_DANGER("[icon2html(src, viewers(src))] [src] suddenly lights up, and additional targeting vanes slide into place."))
			hostile_drone = 1

	if(health / maxHealth > 0.9)
		icon_state = "drone3"
		explode_chance = 0
	else if(health / maxHealth > 0.7)
		icon_state = "drone2"
		explode_chance = 0
	else if(health / maxHealth > 0.5)
		icon_state = "drone1"
		explode_chance = 0.5
	else if(health / maxHealth > 0.3)
		icon_state = "drone0"
		explode_chance = 5
	else if(health > 0)
		//if health gets too low, shut down
		icon_state = "drone_dead"
		exploding = 0
		if(!disabled)
			if(prob(50))
				src.visible_message(SPAN_NOTICE("[icon2html(src, viewers(src))] [src] suddenly shuts down!"))
			else
				src.visible_message(SPAN_NOTICE("[icon2html(src, viewers(src))] [src] suddenly lies still and quiet."))
			disabled = rand(150, 600)
			walk(src,0)

	if(exploding && prob(20))
		if(prob(50))
			src.visible_message(SPAN_DANGER("[icon2html(src, viewers(src))] [src] begins to spark and shake violenty!"))
		else
			src.visible_message(SPAN_DANGER("[icon2html(src, viewers(src))] [src] sparks and shakes like it's about to explode!"))
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(3, 1, src)
		s.start()

	if(!exploding && !disabled && prob(explode_chance))
		exploding = 1
		set_stat(UNCONSCIOUS)
		wander = 1
		walk(src,0)
		spawn(rand(50,150))
			if(!disabled && exploding)
				explosion(get_turf(src), 0, 1, 4, 7)
				//proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1)
	..()

//ion rifle!
/mob/living/simple_animal/hostile/retaliate/malf_drone/emp_act(severity)
	. = ..()
	health -= rand(3,15) * (severity + 1)
	disabled = rand(150, 600)
	hostile_drone = 0
	walk(src,0)

/mob/living/simple_animal/hostile/retaliate/malf_drone/death()
	..(null,"suddenly breaks apart.")
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/malf_drone/Destroy(force)
	QDEL_NULL(ion_trail)

	if(!has_loot || force)
		return ..()

	//some random debris left behind
	var/datum/effect_system/spark_spread/spark = new /datum/effect_system/spark_spread
	spark.set_up(3, 1, src)
	spark.start()
	spark.holder = null
	var/obj/loot

	var/list/reachable_atoms = dview(7, src)
	//shards
	loot = new /obj/item/shard(loc)
	step_to(loot, get_turf(pick(reachable_atoms)))
	if(prob(75))
		loot = new /obj/item/shard(loc)
		step_to(loot, get_turf(pick(reachable_atoms)))
	if(prob(50))
		loot = new /obj/item/shard(loc)
		step_to(loot, get_turf(pick(reachable_atoms)))
	if(prob(25))
		loot = new /obj/item/shard(loc)
		step_to(loot, get_turf(pick(reachable_atoms)))

	//rods
	loot = new /obj/item/stack/rods(loc)
	step_to(loot, get_turf(pick(reachable_atoms)))
	if(prob(75))
		loot = new /obj/item/stack/rods(loc)
		step_to(loot, get_turf(pick(reachable_atoms)))
	if(prob(50))
		loot = new /obj/item/stack/rods(loc)
		step_to(loot, get_turf(pick(reachable_atoms)))
	if(prob(25))
		loot = new /obj/item/stack/rods(loc)
		step_to(loot, get_turf(pick(reachable_atoms)))

	//plasteel
	loot = new /obj/item/stack/sheet/plasteel(loc)
	step_to(loot, get_turf(pick(reachable_atoms)))
	if(prob(75))
		loot = new /obj/item/stack/sheet/plasteel(loc)
		step_to(loot, get_turf(pick(reachable_atoms)))
	if(prob(50))
		loot = new /obj/item/stack/sheet/plasteel(loc)
		step_to(loot, get_turf(pick(reachable_atoms)))
	if(prob(25))
		loot = new /obj/item/stack/sheet/plasteel(loc)
		step_to(loot, get_turf(pick(reachable_atoms)))

	return ..()

/obj/projectile/beam/drone
	damage = 15

/obj/projectile/beam/pulse/drone
	damage = 10
