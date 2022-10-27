/mob/living/simple_animal/hostile/alien/hologram/
	icon_gib = "syndicate_gib"
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	move_to_delay = 5
	meat_type = null
	maxHealth = 1000
	health = 1000
	harm_intent_damage = 0
	melee_damage_lower = 0
	melee_damage_upper = 0
	attacktext = "slashes"
	a_intent = INTENT_HARM
	attack_sound = 'sound/weapons/alien_claw_flesh1.ogg'
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 0
	faction = FACTION_XENOMORPH
	wall_smash = 0
	minbodytemp = 0
	heat_damage_per_tick = 0
	stop_automated_movement_when_pulled = 1
	break_stuff_probability = 0
	wander = 0
	stop_automated_movement = 1
	evasion = 1000
	density = FALSE
	status_flags = null
	hud_possible = list(XENO_BANISHED_HUD)

/mob/living/simple_animal/hostile/alien/hologram/prepare_huds()
	. = ..()
	hud_update_projected()
	add_to_all_mob_huds()

/mob/living/simple_animal/hostile/alien/hologram/Destroy()
	remove_from_all_mob_huds()
	. = ..()


/mob/living/simple_animal/hostile/alien/hologram/attackby(obj/item/O, mob/user)
	return

/mob/living/simple_animal/hostile/alien/hologram/attack_alien(mob/living/carbon/Xenomorph/M)
	return

/mob/living/simple_animal/hostile/alien/hologram/attack_hand(mob/living/carbon/human/M as mob)
	return

/mob/living/simple_animal/hostile/alien/hologram/pull_response(mob/puller)
	if(has_species(puller,"Human"))
		return FALSE

/mob/living/simple_animal/hostile/alien/hologram/Collide(atom/movable/AM)
	return

/mob/living/simple_animal/hostile/alien/hologram/Initialize()
	. = ..()
	generate_hologram_name()

/mob/living/simple_animal/hostile/alien/hologram/proc/generate_hologram_name()
	var/rand_number = rand(1, 999)
	name = "[name] (XX-[rand_number])"

/mob/living/simple_animal/hostile/alien/hologram/proc/hud_update_projected()
	var/image/holder = hud_list[XENO_BANISHED_HUD]
	holder.icon_state = "xeno_projection"
	hud_list[XENO_BANISHED_HUD] = holder

///mob/living/simple_animal/hostile/alien/hologram/lurker
//	name = XENO_CASTE_LURKER
//	desc = "A beefy, fast alien with sharp claws."
//	icon = '/cm/icons/custom/mob/xenos/lurker.dmi'
//	icon_state = "Normal Lurker Walking"
//	icon_living = "Normal Lurker Running"
//	icon_dead = "Normal Lurker Dead"
//	pixel_x = -12
//	old_x = -12

/mob/living/simple_animal/hostile/alien/hologram/drone
	name = XENO_CASTE_DRONE
	desc = "An Alien Drone"
	icon = 'icons/mob/hostiles/drone.dmi'
	icon_state = "Normal Drone Walking"
	icon_living = "Normal Drone Running"
	icon_dead = "Normal Drone Dead"
	pixel_x = -12
	old_x = -12

/mob/living/simple_animal/hostile/alien/hologram/drone/healer
	icon_state = "Healer Drone Running"
	icon_living = "Healer Drone Running"
	icon_dead = "Healer Drone Dead"

/mob/living/simple_animal/hostile/alien/hologram/drone/gardener
	icon_state = "Gardener Drone Running"
	icon_living = "Gardener Drone Running"
	icon_dead = "Gardener Drone Dead"

///mob/living/simple_animal/hostile/alien/hologram/sentinel
//	name = XENO_CASTE_SENTINEL
//	desc = "A slithery, spitting kind of alien."
//	icon = '/cm/icons/custom/mob/xenos/spitter.dmi'
//	icon_state = "Normal Sentinel Walking"
//	icon_living = "Normal Sentinel Running"
//	icon_dead = "Normal Sentinel Dead"
	//ranged = 1
//	projectiletype = /obj/item/projectile/neurotox
//	projectilesound = 'sound/weapons/pierce.ogg'
//	pixel_x = -12
//	old_x = -12

/mob/living/simple_animal/hostile/alien/hologram/ravager
	name = XENO_CASTE_RAVAGER
	desc = "A huge, nasty red alien with enormous scythed claws."
	icon = 'icons/mob/hostiles/ravager.dmi'
	icon_state = "Normal Ravager Walking"
	icon_living = "Normal Ravager Running"
	icon_dead = "Normal Ravager Dead"
	pixel_x = -16
	old_x = -16

/mob/living/simple_animal/hostile/alien/hologram/ravager/hedgehog
	icon_state = "Hedgehog Ravager Running"
	icon_living = "Hedgehog Ravager Running"
	icon_dead = "Hedgehog Ravager Dead"

/mob/living/simple_animal/hostile/alien/hologram/ravager/berserker
	icon_state = "Berserker Ravager Running"
	icon_living = "Berserker Ravager Running"
	icon_dead = "Berserker Ravager Dead"

///mob/living/simple_animal/hostile/alien/hologram/praetorian
//	name = XENO_CASTE_PRAETORIAN
//	desc = "A huge, looming beast of an alien."
//	icon = 'cm/icons/custom/mob/xenos/praetorian.dmi'
//	icon_state = "Normal Praetorian Walking"
//	icon_living = "Normal Praetorian Running"
//	icon_dead = "Normal Praetorian Dead"
//	pixel_x = -16
//	old_x = -16

///mob/living/simple_animal/hostile/alien/hologram/praetorian/warden
//	icon_state = "Warden Praetorian Running"
//	icon_living = "Warden Praetorian Running"
//	icon_dead = "Warden Praetorian Dead"

///mob/living/simple_animal/hostile/alien/hologram/praetorian/dancer
//	icon_state = "Dancer Praetorian Running"
//	icon_living = "Dancer Praetorian Running"
//	icon_dead = "Dancer Praetorian Dead"

///mob/living/simple_animal/hostile/alien/hologram/praetorian/vanguard
//	icon_state = "Vanguard Praetorian Running"
//	icon_living = "Vanguard Praetorian Running"
//	icon_dead = "Vanguard Praetorian Dead"

///mob/living/simple_animal/hostile/alien/hologram/praetorian/oppressor
//	icon_state = "Oppressor Praetorian Running"
//	icon_living = "Oppressor Praetorian Running"
//	icon_dead = "Oppressor Praetorian Dead"

/mob/living/simple_animal/hostile/alien/hologram/hivelord
	name = XENO_CASTE_HIVELORD
	desc = "A builder of really big hives."
	icon = 'icons/mob/hostiles/hivelord.dmi'
	icon_state = "Normal Hivelord Walking"
	icon_living = "Normal Hivelord Running"
	icon_dead = "Normal Hivelord Dead"
	pixel_x = -16
	old_x = -16

/mob/living/simple_animal/hostile/alien/hologram/hivelord/resinwhisperer
	icon_state = "Resin Whisperer Hivelord Running"
	icon_living = "Resin Whisperer Hivelord Running"
	icon_dead = "Resin Whisperer Hivelord Dead"

///mob/living/simple_animal/hostile/alien/hologram/spitter
//	name = XENO_CASTE_SPITTER
//	desc = "A gross, oozing alien of some kind."
//	icon = '/cm/icons/custom/mob/xenos/spitter.dmi'
//	icon_state = "Normal Spitter Walking"
//	icon_living = "Normal Spitter Running"
//	icon_dead = "Normal Spitter Dead"
	//ranged = 1
//	projectiletype = /obj/item/projectile/neurotox
//	projectilesound = 'sound/voice/alien_spitacid.ogg'
//	pixel_x = -12
//	old_x = -12

/mob/living/simple_animal/hostile/alien/hologram/burrower
	name = XENO_CASTE_BURROWER
	desc = "A beefy, alien with sharp claws."
	icon = 'icons/mob/hostiles/burrower.dmi'
	icon_state = "Normal Burrower Walking"
	icon_living = "Normal Burrower Running"
	icon_dead = "Normal Burrower Dead"
	pixel_x = -12
	old_x = -12

///mob/living/simple_animal/hostile/alien/hologram/crusher
//	name = XENO_CASTE_CRUSHER
//	desc = "A huge alien with an enormous armored head crest."
//	icon = '/cm/icons/custom/mob/xenos/crusher.dmi'
//	icon_state = "Normal Crusher Walking"
//	icon_living = "Normal Crusher Running"
//	icon_dead = "Normal Crusher Dead"
//	pixel_x = -16
//	pixel_y = -3
//	old_x = -16
//	old_y = -3

/mob/living/simple_animal/hostile/alien/hologram/defender
	name = XENO_CASTE_DEFENDER
	desc = "A alien with an armored head crest."
	icon = 'icons/mob/hostiles/defender.dmi'
	icon_state = "Normal Defender Walking"
	icon_living = "Normal Defender Running"
	icon_dead = "Normal Defender Dead"
	pixel_x = -16
	old_x = -16

/mob/living/simple_animal/hostile/alien/hologram/defender/steelcrest
	icon_state = "Steelcrest Defender Running"
	icon_living = "Steelcrest Defender Running"
	icon_dead = "Steelcrest Defender Dead"

/mob/living/simple_animal/hostile/alien/hologram/runner
	name = XENO_CASTE_RUNNER
	desc = "A small red alien that looks like it could run fairly quickly..."
	icon = 'icons/mob/hostiles/runner.dmi'
	icon_state = "Normal Runner Walking"
	icon_living = "Normal Runner Running"
	icon_dead = "Normal Runner Dead"
	pixel_x = -16
	old_x = -16

/mob/living/simple_animal/hostile/alien/hologram/warrior
	name = XENO_CASTE_WARRIOR
	icon = 'icons/mob/hostiles/warrior.dmi'
	desc = "A beefy, alien with an armored carapace."
	icon_state = "Normal Warrior Walking"
	icon_living = "Normal Warrior Running"
	icon_dead = "Normal Warrior Dead"
	pixel_x = -16
	old_x = -16

/obj/item/projectile/neurotox
	damage = 0
	icon_state = "toxin"

/mob/living/simple_animal/hostile/alien/hologram/death(cause, gibbed, deathmessage = "lets out a waning guttural screech, green blood bubbling from its maw.")
	. = ..()
	if(!.) return //If they were already dead, it will return.
	playsound(src, 'sound/voice/alien_death.ogg', 50, 1)
