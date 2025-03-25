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
	. = ..()
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
	emote_see = list("beeps menacingly.","whirrs threateningly.","scans its immediate vicinity.")
	melee_damage_lower = 25
	melee_damage_upper = 25
	a_intent = INTENT_HARM
	health = 300
	maxHealth = 300
	speed = 8
	destroy_surroundings = FALSE
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
	. = ..()
	if(!.)
		return

	var/datum/effect_system/spark_spread/spark = new /datum/effect_system/spark_spread
	spark.set_up(3, 1, src)
	spark.start()
	spark.holder = null
	qdel(src)

/mob/living/simple_animal/hostile/marine
	name = "marine"
	desc = "A tired-looking marine holding a sharp blade."
	icon_state = "marine"
	icon_living = "marine"
	icon_dead = "marine_dead"
	icon_gib = null
	speak_chance = 0
	turns_per_move = 5
	response_help = "cautiously pets the"
	response_disarm = "pushes aside the"
	response_harm = "hits the"
	speak = list("Wish we had some fuckin' ammo.", "Pass me the smokes.", "When will evac get here?", "I wanna go home.")
	emote_see = list("sniffs.", "coughs.", "sharpens his blade.")
	speed = 5
	maxHealth = 400
	health = 400

	harm_intent_damage = 8
	melee_damage_lower = 35
	melee_damage_upper = 35
	attacktext = "slashes"
	attack_sound = 'sound/weapons/bladeslice.ogg'

	break_stuff_probability = 15

	faction = FACTION_MARINE

/mob/living/simple_animal/hostile/marine/FindTarget()
	. = ..()
	if(. && prob(50))
		manual_emote("shouts an inspiring cry!")
		playsound(src, get_sfx("male_warcry"), 55)

/mob/living/simple_animal/hostile/marine/AttackingTarget()
	. = ..()
	var/mob/living/L = .
	if(istype(L))
		var/datum/status_effect/stacking/bleed/bleed = L.has_status_effect(/datum/status_effect/stacking/bleed)
		if(!bleed)
			bleed = L.apply_status_effect(/datum/status_effect/stacking/bleed, 1)
		else
			bleed.add_stacks(1)

// Here be bosses

/mob/living/simple_animal/hostile/megacarp //zonenote look into bounds
	name = "megacarp"
	desc = "An enormous fang-bearing creature that resembles the smaller space carp, except far angrier."
	icon = 'icons/mob/broadMobs.dmi'
	icon_state = "megacarp"
	icon_living = "megacarp"
	icon_dead = "megacarp_dead"
	icon_gib = "megacarp_gib"
	speak_chance = 0
	turns_per_move = 5
	response_help = "cautiously pets the"
	response_disarm = "pushes aside the"
	response_harm = "hits the"
	speed = 6
	maxHealth = 4000
	health = 4000

	harm_intent_damage = 8
	melee_damage_lower = 50
	melee_damage_upper = 50
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'

	break_stuff_probability = 15

	faction = "carp"
	/// How much additional damage we do based on the target's max HP
	var/maxhealth_damage = 0.07

/mob/living/simple_animal/hostile/megacarp/Initialize()
	. = ..()
	transform.Scale(2, 2) // big fish
	enable_pixel_scaling()

/mob/living/simple_animal/hostile/megacarp/FindTarget()
	. = ..()
	if(.)
		manual_emote("growls at [.]")

/mob/living/simple_animal/hostile/megacarp/AttackingTarget()
	. = ..()
	var/mob/living/L = .
	if(istype(L))
		L.apply_armoured_damage(L.maxHealth * maxhealth_damage, ARMOR_MELEE)

/mob/living/simple_animal/hostile/megacarp/gib_animation()
	if(icon_gib)
		new /obj/effect/overlay/temp/gib_animation/animal/large(loc, src, icon_gib)

/mob/living/simple_animal/hostile/megacarp/death(datum/cause_data/cause_data, gibbed = 0, deathmessage = "seizes up and falls limp...")
	. = ..()
	if(!.)
		return

	if(!gibbed)
		gib(cause_data)

/obj/effect/overlay/temp/gib_animation/animal/large
	icon = 'icons/mob/broadMobs.dmi'


/mob/living/simple_animal/hostile/hivebot // zonenote: these guys can't attack bc nobody has the camp target trait
	name = "hivebot"
	desc = "A strange, armored robot with a worrying red visor. Its blade looks like it could pierce the thickest armor."
	icon_state = "hivebot"
	icon_living = "hivebot"
	icon_dead = "hivebot" // we qdel and explode on death anyway
	icon_gib = null
	speak_chance = 0
	turns_per_move = 5
	response_help = "cautiously pets the"
	response_disarm = "pushes aside the"
	response_harm = "hits the"
	speed = 5
	maxHealth = 4500
	health = 4500

	harm_intent_damage = 8
	melee_damage_lower = 5 // We do extra true damage on hit
	melee_damage_upper = 5
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'

	break_stuff_probability = 15

	faction = "hivebot"
	/// How much full-pen damage to do on hit
	var/true_damage = 25

/mob/living/simple_animal/hostile/hivebot/Initialize()
	. = ..()
	//transform.Scale(2, 2) // big bot
	//enable_pixel_scaling()

/mob/living/simple_animal/hostile/hivebot/death(datum/cause_data/cause_data, gibbed, deathmessage)
	. = ..()
	if(!.)
		return .

	cell_explosion(get_turf(src), 100, 25, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, create_cause_data("self-destruction", src))
	qdel(src)

/mob/living/simple_animal/hostile/hivebot/FindTarget()
	. = ..()
	if(.)
		manual_emote("beeps angrily at [.]")
		playsound(loc, 'sound/machines/twobeep.ogg', 40)

/mob/living/simple_animal/hostile/hivebot/AttackingTarget()
	. = ..()
	var/mob/living/L = .
	if(istype(L))
		L.apply_damage(true_damage, BRUTE)

		// By rending armor we allow for more effective all-ins/steals from the opposing team and a slight damage increase from this guy
		var/datum/status_effect/stacking/rended_armor/rended = L.has_status_effect(/datum/status_effect/stacking/rended_armor)
		if(!rended)
			rended = L.apply_status_effect(/datum/status_effect/stacking/rended_armor, 1)
		else
			rended.add_stacks(1)

/mob/living/simple_animal/hostile/reaper
	name = "Reaper"
	desc = "A towering icon of death and destruction."
	icon = 'icons/mob/xenos/castes/moba/reaper.dmi'
	icon_state = "Normal Reaper Walking"
	icon_living = "Normal Reaper Walking"
	icon_dead = "Normal Reaper Dead"
	icon_gib = null
	speak_chance = 0
	turns_per_move = 5
	response_harm = "mauls the"
	speed = 5
	maxHealth = 7500
	health = 7500

	harm_intent_damage = 10
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "viscerates"
	attack_sound = 'sound/weapons/alien_tail_attack.ogg'

	break_stuff_probability = 15
	faction = "reaper"

	var/true_damage = 35

/mob/living/simple_animal/hostile/reaper/death(datum/cause_data/cause_data, gibbed, deathmessage)
	. = ..()
	if(!.)
		return .

	if(!gibbed)
		gib(src)

/mob/living/simple_animal/hostile/reaper/FindTarget()
	. = ..()
	if(.)
		manual_emote("emits a low gutteral screech towards [.]")

/mob/living/simple_animal/hostile/reaper/AttackingTarget()
	. = ..()
	/*var/mob/living/L = .
	if(istype(L))
		L.apply_damage(true_damage, BRUTE)

		var/datum/status_effect/stacking/rended_armor/rended = L.has_status_effect(/datum/status_effect/stacking/rended_armor)
		if(!rended)
			rended = L.apply_status_effect(/datum/status_effect/stacking/rended_armor, 1)
		else
			rended.add_stacks(1)*/
