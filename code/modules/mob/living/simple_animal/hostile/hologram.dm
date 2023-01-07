/mob/living/simple_animal/hostile/alien/hologram/
	move_to_delay = 5
	meat_type = null
	maxHealth = 1000
	health = 1000
	harm_intent_damage = 0
	melee_damage_lower = 0
	melee_damage_upper = 0
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
	var/strain = "Normal"

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
	handle_icon_hologram()

/mob/living/simple_animal/hostile/alien/hologram/update_transform()
	if(lying != lying_prev)
		lying_prev = lying
	if(stat == DEAD)
		icon_state = "[strain] [caste_name] Dead"
	else if(lying)
		if((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "[strain] [caste_name] Sleeping"
		else
			icon_state = "[strain] [caste_name] Knocked Down"
	else
		icon_state = "[strain] [caste_name] Running"
	update_wounds()

/mob/living/simple_animal/hostile/alien/hologram/proc/handle_icon_hologram()
	icon_state = "[strain] [caste_name] Running"
	icon_living = "[strain] [caste_name] Running"
	icon_dead = "[strain] [caste_name] Dead"

/mob/living/simple_animal/hostile/alien/hologram/proc/generate_hologram_name()
	var/rand_number = rand(1, 999)
	var/list/rand_age = list("Prime", "Ancient", "Elder", "Mature")
	change_real_name(src, "[pick(rand_age)] [caste_name] ([pick(alphabet_uppercase)][pick(alphabet_uppercase)][pick(alphabet_uppercase)]-[rand_number])")

/mob/living/simple_animal/hostile/alien/hologram/proc/hud_update_projected()
	var/image/holder = hud_list[XENO_BANISHED_HUD]
	holder.icon_state = "xeno_projection"
	hud_list[XENO_BANISHED_HUD] = holder

/mob/living/simple_animal/hostile/alien/hologram/lurker
	name = XENO_CASTE_LURKER
	desc = "A beefy, fast alien with sharp claws."
	icon = 'icons/mob/xenos/lurker.dmi'
	icon_state = "Normal Lurker Walking"
	icon_living = "Normal Lurker Running"
	icon_dead = "Normal Lurker Dead"
	pixel_x = -12
	old_x = -12

/mob/living/simple_animal/hostile/alien/hologram/drone
	name = XENO_CASTE_DRONE
	desc = "An Alien Drone"
	icon = 'icons/mob/xenos/drone.dmi'
	icon_state = "Normal Drone Walking"
	icon_living = "Normal Drone Running"
	icon_dead = "Normal Drone Dead"
	pixel_x = -12
	old_x = -12

/mob/living/simple_animal/hostile/alien/hologram/drone/healer
	strain = "Healer"

/mob/living/simple_animal/hostile/alien/hologram/drone/gardener
	strain = "Gardener"

/mob/living/simple_animal/hostile/alien/hologram/sentinel
	name = XENO_CASTE_SENTINEL
	desc = "A slithery, spitting kind of alien."
	icon = 'icons/mob/xenos/sentinel.dmi'
	icon_state = "Normal Sentinel Walking"
	icon_living = "Normal Sentinel Running"
	icon_dead = "Normal Sentinel Dead"
//	ranged = 1
//	projectiletype = /obj/item/projectile/neurotox
//	projectilesound = 'sound/weapons/pierce.ogg'
	pixel_x = -12
	old_x = -12

/mob/living/simple_animal/hostile/alien/hologram/ravager
	name = XENO_CASTE_RAVAGER
	desc = "A huge, nasty red alien with enormous scythed claws."
	icon = 'icons/mob/xenos/ravager.dmi'
	icon_state = "Normal Ravager Walking"
	icon_living = "Normal Ravager Running"
	icon_dead = "Normal Ravager Dead"
	pixel_x = -16
	old_x = -16

/mob/living/simple_animal/hostile/alien/hologram/ravager/hedgehog
	strain = "Hedgehog"

/mob/living/simple_animal/hostile/alien/hologram/ravager/berserker
	strain = "Berserker"

/mob/living/simple_animal/hostile/alien/hologram/praetorian
	name = XENO_CASTE_PRAETORIAN
	desc = "A huge, looming beast of an alien."
	icon = 'icons/mob/xenos/praetorian.dmi'
	icon_state = "Normal Praetorian Walking"
	icon_living = "Normal Praetorian Running"
	icon_dead = "Normal Praetorian Dead"
	pixel_x = -16
	old_x = -16

/mob/living/simple_animal/hostile/alien/hologram/praetorian/warden
	strain = "Warden"

/mob/living/simple_animal/hostile/alien/hologram/praetorian/dancer
	strain = "Dancer"

/mob/living/simple_animal/hostile/alien/hologram/praetorian/vanguard
	strain = "Vanguard"

/mob/living/simple_animal/hostile/alien/hologram/praetorian/oppressor
	strain = "Oppressor"

/mob/living/simple_animal/hostile/alien/hologram/hivelord
	name = XENO_CASTE_HIVELORD
	desc = "A builder of really big hives."
	icon = 'icons/mob/xenos/hivelord.dmi'
	icon_state = "Normal Hivelord Walking"
	icon_living = "Normal Hivelord Running"
	icon_dead = "Normal Hivelord Dead"
	pixel_x = -16
	old_x = -16

/mob/living/simple_animal/hostile/alien/hologram/hivelord/resinwhisperer
	strain = "Resin Whisperer"

/mob/living/simple_animal/hostile/alien/hologram/spitter
	name = XENO_CASTE_SPITTER
	desc = "A gross, oozing alien of some kind."
	icon = 'icons/mob/xenos/spitter.dmi'
	icon_state = "Normal Spitter Walking"
	icon_living = "Normal Spitter Running"
	icon_dead = "Normal Spitter Dead"
//	ranged = 1
//	projectiletype = /obj/item/projectile/neurotox
//	projectilesound = 'sound/voice/alien_spitacid.ogg'
	pixel_x = -12
	old_x = -12

/mob/living/simple_animal/hostile/alien/hologram/burrower
	name = XENO_CASTE_BURROWER
	desc = "A beefy, alien with sharp claws."
	icon = 'icons/mob/xenos/burrower.dmi'
	icon_state = "Normal Burrower Walking"
	icon_living = "Normal Burrower Running"
	icon_dead = "Normal Burrower Dead"
	pixel_x = -12
	old_x = -12

/mob/living/simple_animal/hostile/alien/hologram/crusher
	name = XENO_CASTE_CRUSHER
	desc = "A huge alien with an enormous armored head crest."
	icon = 'icons/mob/xenos/crusher.dmi'
	icon_state = "Normal Crusher Walking"
	icon_living = "Normal Crusher Running"
	icon_dead = "Normal Crusher Dead"
	pixel_x = -16
	pixel_y = -3
	old_x = -16
	old_y = -3

/mob/living/simple_animal/hostile/alien/hologram/defender
	name = XENO_CASTE_DEFENDER
	desc = "A alien with an armored head crest."
	icon = 'icons/mob/xenos/defender.dmi'
	icon_state = "Normal Defender Walking"
	icon_living = "Normal Defender Running"
	icon_dead = "Normal Defender Dead"
	pixel_x = -16
	old_x = -16

/mob/living/simple_animal/hostile/alien/hologram/defender/steelcrest
	strain = "Steelcrest"

/mob/living/simple_animal/hostile/alien/hologram/runner
	name = XENO_CASTE_RUNNER
	desc = "A small red alien that looks like it could run fairly quickly..."
	icon = 'icons/mob/xenos/runner.dmi'
	icon_state = "Normal Runner Walking"
	icon_living = "Normal Runner Running"
	icon_dead = "Normal Runner Dead"
	pixel_x = -16
	old_x = -16

/mob/living/simple_animal/hostile/alien/hologram/warrior
	name = XENO_CASTE_WARRIOR
	icon = 'icons/mob/xenos/warrior.dmi'
	desc = "A beefy, alien with an armored carapace."
	icon_state = "Normal Warrior Walking"
	icon_living = "Normal Warrior Running"
	icon_dead = "Normal Warrior Dead"
	pixel_x = -16
	old_x = -16

/obj/item/projectile/neurotox
	damage = 0
	icon_state = "toxin"

/mob/living/simple_animal/hostile/alien/hologram/Move(atom/new_loc)
	var/d = get_dir(src, new_loc)
	var/is_diagonal = d & (d - 1)
	if(is_diagonal)
		// d1 and d2 are the component directions
		var/d1 = d & (NORTH | SOUTH)
		var/d2 = d & (EAST | WEST)
		// swap d1 and d2 50% of the time so we don't favor any direction
		if(prob(50))
			var/t = d1
			d1 = d2
			d2 = t

		// try moving in the d1 direction
		dir = d1
		if(step(src, d1))
			return 1

		// if that fails, try moving in the d2 direction
		dir = d2
		if(step(src, d2))
			return 1

		return 0

	// if the move wasn't diagonal
	else
		return ..()
