/mob/living/simple_animal/hostile/hellhound
	name = "hellhound"
	desc = "A disgusting beast from hell, it has four menacing spikes growing from its head and some nasty teeth to boot."
	icon = 'icons/mob/humans/onmob/hunter/hellhound.dmi'
	icon_state = "Normal Hellhound Walking"
	icon_living = "Normal Hellhound Walking"
	icon_dead = "Normal Hellhound Dead"
	icon_gib = null
	speak_chance = 0
	turns_per_move = 5
	response_help = "cautiously pets the"
	response_disarm = "pushes aside the"
	response_harm = "hits the"
	speed = 5
	maxHealth = 500
	health = 500

	harm_intent_damage = 8
	melee_damage_lower = 30
	melee_damage_upper = 30
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'

	break_stuff_probability = 15

	faction = FACTION_YAUTJA
	/// How much additional damage we do based on the target's max HP
	var/maxhealth_damage = 0.04

/mob/living/simple_animal/hostile/hellhound/FindTarget()
	. = ..()
	if(. && prob(50))
		manual_emote("growls at [.]")

/mob/living/simple_animal/hostile/hellhound/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		L.apply_armoured_damage(L.maxHealth * maxhealth_damage, ARMOR_MELEE)




// rewritten /mob/living/simple_animal/hostile/retaliate/malf_drone except it's not CM Dev 10 year old code
/mob/living/simple_animal/hostile/combat_drone
	name = "combat drone"
	desc = "An automated combat drone armed with state of the art weaponry and shielding."
	icon_state = "drone3"
	icon_living = "drone3"
	icon_dead = "drone_dead"
	ranged = TRUE
	rapid = TRUE
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
	faction = "malf_drone"
	var/datum/effect_system/ion_trail_follow/ion_trail

/mob/living/simple_animal/hostile/combat_drone/Initialize()
	. = ..()
	ion_trail = new
	ion_trail.set_up(src)
	ion_trail.start()

/mob/living/simple_animal/hostile/combat_drone/Destroy(force)
	QDEL_NULL(ion_trail)
	return ..()

/mob/living/simple_animal/hostile/combat_drone/Process_Spacemove(check_drift = 0)
	return TRUE

//self repair systems have a chance to bring the drone back to life
/mob/living/simple_animal/hostile/combat_drone/Life(delta_time)
	. = ..()
	//spark for no reason
	if(prob(5))
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(3, 1, src)
		s.start()

/mob/living/simple_animal/hostile/combat_drone/updatehealth()
	. = ..()
	if(health / maxHealth > 0.9)
		icon_state = "drone3"
	else if(health / maxHealth > 0.7)
		icon_state = "drone2"
	else if(health / maxHealth > 0.5)
		icon_state = "drone1"
	else if(health / maxHealth > 0.3)
		icon_state = "drone0"

/mob/living/simple_animal/hostile/combat_drone/death()
	var/datum/effect_system/spark_spread/spark = new /datum/effect_system/spark_spread
	spark.set_up(3, 1, src)
	spark.start()
	spark.holder = null
	qdel(src)
	return ..()
