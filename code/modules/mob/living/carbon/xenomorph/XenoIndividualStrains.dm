// ******************** //
// 	Individual Strains	//
// ******************** //

/datum/xeno_strain/individual
	var/mob/living/carbon/Xenomorph/xeno

/datum/xeno_strain/individual/recalculate_everything(var/description)
	xeno.recalculate_everything()
	to_chat(xeno, SPAN_XENOANNOUNCE("[description]"))
	xeno.xeno_jitter(15)
/datum/xeno_strain/individual/recalculate_stats(var/description)
	xeno.recalculate_stats()
	to_chat(xeno, SPAN_XENOANNOUNCE("[description]"))
	xeno.xeno_jitter(15)
/datum/xeno_strain/individual/recalculate_actions(var/description)
	xeno.recalculate_actions()
	to_chat(xeno, SPAN_XENOANNOUNCE("[description]"))
	xeno.xeno_jitter(15)
/datum/xeno_strain/individual/recalculate_pheromones(var/description)
	xeno.recalculate_pheromones()
	to_chat(xeno, SPAN_XENOANNOUNCE("[description]"))
	xeno.xeno_jitter(15)
/datum/xeno_strain/individual/give_feedback(var/description)
	to_chat(xeno, SPAN_XENOANNOUNCE("[description]"))
	xeno.xeno_jitter(15)


/datum/xeno_strain/individual/railgun
	name = "STRAIN: Boiler - Railgun"
	description = "In exchange for your gas and neurotoxin gas, you gain a new type of glob - the railgun glob. This will do a lot of damage to barricades and humans, with no scatter and perfect accuracy!"
	individual_only = TRUE
	caste_whitelist = list("Boiler") //Only boiler.
	strain_actions_to_remove = list("Toggle Bombard Type")
	strain_actions_to_add = null
	keystone = TRUE
	vars_to_override = list("bombard_time", "min_bombard_dist")
	bombard_time = RAILGUN_BOMBARD_TIME
	min_bombard_dist = RAILGUN_MIN_BOMBARD_DIST

/datum/xeno_strain/individual/railgun/apply_strain(mob/living/carbon/Xenomorph/X)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/Xenomorph/Boiler/B = X
	if(!istype(B))
		log_debug("DEBUG: [B] tried to purchase an invalid strain ([src]).")
		return FALSE
	xeno = X
	X.strain = src

	if(B.is_zoomed)
		B.zoom_out()
	B.remove_action("Toggle Bombard Type")
	B.bombard_speed = RAILGUN_BOMBARD_SPEED
	B.bomb_delay = RAILGUN_BOMB_DELAY
	B.ammo = ammo_list[/datum/ammo/xeno/railgun_glob]
	B.tileoffset = RAILGUN_TILE_OFFSET
	B.viewsize = RAILGUN_VIEWSIZE
	recalculate_actions(description)


/datum/xeno_strain/individual/shatterglob
	name = "STRAIN: Boiler - Shatter Glob"
	description = "Instead of leaving a lasting cloud of gas, your two bombard types will now detonate upon hitting the ground, spraying the area with splashes and drops of acid or neurotoxin."
	individual_only = TRUE
	caste_whitelist = list("Boiler")
	strain_actions_to_remove = null
	strain_actions_to_add = null
	keystone = TRUE

/datum/xeno_strain/individual/shatterglob/apply_strain(mob/living/carbon/Xenomorph/X)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/Xenomorph/Boiler/B = X
	if(!istype(B))
		log_debug("DEBUG: [B] tried to purchase an invalid strain ([src]).")
		return FALSE
	xeno = X
	X.strain = src

	B.ammo = ammo_list[/datum/ammo/xeno/boiler_gas/shatter/acid]
	button.overlays += image('icons/mob/actions.dmi', button, "toggle_bomb1")
	B.bomb_delay = SHATTER_GLOB_BOMB_DELAY // 25s flat, doesn't decrease with maturity anymore
	recalculate_actions(description)


/datum/xeno_strain/individual/royal_guard
	name = "STRAIN: Praetorian - Royal Guard"
	description = "In exchange for your ability to spit, you gain better pheromones, a lower activation time on acid spray and tail sweep."
	individual_only = TRUE
	caste_whitelist = list("Praetorian") //Only praetorian.
	strain_actions_to_remove = list("Xeno Spit","Toggle Spit Type")
	strain_actions_to_add = list(/datum/action/xeno_action/activable/tail_sweep)
	keystone = TRUE
	phero_modifier = XENO_PHERO_MOD_LARGE

/datum/xeno_strain/individual/royal_guard/apply_strain(mob/living/carbon/Xenomorph/X)
	. = ..()
	if (!.)
		return FALSE

	var/mob/living/carbon/Xenomorph/Praetorian/P = X
	if(!istype(P))
		log_debug("DEBUG: [P] tried to purchase an invalid strain ([src]).")
		return FALSE
	xeno = X
	X.strain = src

	P.acid_spray_activation_time = 6
	strain_update_actions(P)
	recalculate_actions(description)
	P.recalculate_pheromone_modifiers()


/datum/xeno_strain/individual/healer
	name = "STRAIN: Drone - Healer"
	description = "In exchange for your ability to build, you gain better pheromones and the ability to transfer life to other Xenomorphs. Be wary, this is a dangerous process, overexert yourself and you might die..."
	individual_only = TRUE
	caste_whitelist = list("Drone") //Only drone.
	strain_actions_to_remove = list("Secrete Resin (75)","Choose Resin Structure")
	strain_actions_to_add = list(/datum/action/xeno_action/activable/transfer_health)
	keystone = TRUE
	phero_modifier = XENO_PHERO_MOD_LARGE

/datum/xeno_strain/individual/healer/apply_strain(mob/living/carbon/Xenomorph/X)
	. = ..()
	if (!.)
		return FALSE
	var/mob/living/carbon/Xenomorph/Drone/D = X
	if(!istype(D))
		log_debug("DEBUG: [D] tried to purchase an invalid strain ([src]).")
		return FALSE
	xeno = X
	X.strain = src

	strain_update_actions(D)
	recalculate_actions(description)
	D.recalculate_pheromone_modifiers()


/datum/xeno_strain/individual/vomiter
	name = "STRAIN: Spitter - Vomiter"
	description = "In exchange for your ability to spit, you gain the ability to spray a weaker variant of acid spray that does not stun, but still damages."
	individual_only = TRUE
	caste_whitelist = list("Spitter")
	strain_actions_to_remove = list("Toggle Spit Type", "Xeno Spit")
	strain_actions_to_add = list (/datum/action/xeno_action/activable/spray_acid)
	keystone = TRUE

/datum/xeno_strain/individual/vomiter/apply_strain(mob/living/carbon/Xenomorph/X)
	. = ..()
	if (!.)
		return FALSE

	var/mob/living/carbon/Xenomorph/Spitter/S = X
	if(!istype(S))
		log_debug("DEBUG: [S] tried to purchase an invalid strain ([src]).")
		return FALSE
	xeno = X
	X.strain = src

	strain_update_actions(S)
	recalculate_actions(description)


/datum/xeno_strain/individual/steel_crest
	name = "STRAIN: Defender - Steel Crest"
	description = "In exchange for your tail sweep and some of your damage, you gain the ability to move while in Fortify. Your headbutt can now be used while your crest is lowered. It also reaches further and does more damage."
	individual_only = TRUE
	caste_whitelist = list("Defender")
	strain_actions_to_remove = list("Tail Sweep")
	keystone = TRUE
	speed_modifier = XENO_SPEED_MOD_SMALL
	damage_modifier = -XENO_DAMAGE_MOD_VERYSMALL

/datum/xeno_strain/individual/steel_crest/apply_strain(mob/living/carbon/Xenomorph/X)
	. = ..()
	if (!.)
		return FALSE

	var/mob/living/carbon/Xenomorph/Defender/D = X
	if(!istype(D))
		log_debug("DEBUG: [D] tried to purchase an invalid strain ([src]).")
		return FALSE
	xeno = X
	X.strain = src

	if(D.fortify)
		D.ability_speed_modifier += 2.5
	recalculate_actions(description)
	D.recalculate_speed_modifiers()
	D.recalculate_damage_modifiers()


/datum/xeno_strain/individual/egg_sacs
	name = "STRAIN: Carrier - Egg Sacs"
	description = "In exchange for your ability to store huggers, you gain the ability to produce eggs."
	individual_only = TRUE
	caste_whitelist = list("Carrier")
	strain_actions_to_remove = list("Use/Throw Facehugger")
	strain_actions_to_add = list(/datum/action/xeno_action/activable/lay_egg)
	keystone = TRUE

/datum/xeno_strain/individual/egg_sacs/apply_strain(mob/living/carbon/Xenomorph/X)
	. = ..()
	if (!.)
		return FALSE

	var/mob/living/carbon/Xenomorph/Carrier/C = X
	if(!istype(C))
		log_debug("DEBUG: [C] tried to purchase an invalid strain ([src]).")
		return FALSE
	xeno = X
	X.strain = src

	strain_update_actions(C)
	recalculate_actions(description)


/datum/xeno_strain/individual/tremor
	name = "STRAIN: Burrower - Tremor"
	description = "In exchange for your ability to create traps, you gain the ability to create tremors in the ground. These tremors will knock down those next to you, while confusing everyone on your screen."
	individual_only = TRUE
	caste_whitelist = list("Burrower")
	strain_actions_to_remove = list("Place resin hole (200)")
	strain_actions_to_add = list(/datum/action/xeno_action/activable/tremor)
	keystone = TRUE

/datum/xeno_strain/individual/tremor/apply_strain(mob/living/carbon/Xenomorph/X)
	. = ..()
	if (!.)
		return FALSE

	var/mob/living/carbon/Xenomorph/Burrower/B = X
	if(!istype(B))
		log_debug("DEBUG: [B] tried to purchase an invalid strain ([src]).")
		return FALSE
	xeno = X
	X.strain = src

	strain_update_actions(B)
	recalculate_actions(description)


/datum/xeno_strain/individual/boxer
	name = "STRAIN: Warrior - Boxer"
	description = "In exchange for your ability to fling, you gain the ability to Jab. Your punches no longer break bones, but they do more damage and confuse your enemies. Jab knocks down your target for a very short time, while also pulling you out of agility mode and refreshing your Punch cooldown."
	individual_only = TRUE
	caste_whitelist = list("Warrior")
	strain_actions_to_remove = list("Fling","Lunge")
	strain_actions_to_add = list(/datum/action/xeno_action/activable/jab)
	keystone = TRUE

/datum/xeno_strain/individual/boxer/apply_strain(mob/living/carbon/Xenomorph/X)
	. = ..()
	if (!.)
		return FALSE

	var/mob/living/carbon/Xenomorph/Warrior/W = X
	if(!istype(W))
		log_debug("DEBUG: [W] tried to purchase an invalid strain ([src]).")
		return FALSE
	xeno = X
	X.strain = src

	strain_update_actions(W)
	recalculate_actions(description)


/datum/xeno_strain/individual/spin_slash
	// I like to call this one... the decappucino!
	name = "STRAIN: Ravager - Spin Slash"
	description = "In exchange for your charge, you gain the ability to perform a deadly spinning slash attack that reaches targets all around you."
	individual_only = TRUE
	caste_whitelist = list("Ravager")  	// Only Ravager.
	strain_actions_to_remove = list("Charge (20)")
	strain_actions_to_add = list(/datum/action/xeno_action/activable/spin_slash)
	keystone = TRUE

/datum/xeno_strain/individual/spin_slash/apply_strain(mob/living/carbon/Xenomorph/X)
	. = ..()
	if (!.)
		return FALSE

	var/mob/living/carbon/Xenomorph/Ravager/R = X
	if(!istype(R))
		log_debug("DEBUG: [R] tried to purchase an invalid strain ([src]).")
		return FALSE
	xeno = X
	X.strain = src

	R.used_lunge = 0
	strain_update_actions(R)
	recalculate_actions(description)


/datum/xeno_strain/individual/flesheater
	name = "STRAIN: Runner - Flesheater"
	description = "In exchange for your pounce and some of your speed, you have more health and get chunks from your enemies with each attack. Some of the chunks are consumed to regenerate your health, but a majority of it is stored until you choose to consume them or give them to fellow sisters to regenerate health in a quick, large burst."
	individual_only = TRUE
	caste_whitelist = list("Runner")
	strain_actions_to_remove = list("Pounce")
	strain_actions_to_add = list(/datum/action/xeno_action/activable/flesh_heal)
	keystone = TRUE
	var/stored_heals = 0
	var/max_stored_heals = MAX_STORED_HEALS
	var/instant_lifesteal_mult = FLESHEATER_INSTANT_LIFESTEAL_MULT
	var/stored_lifesteal_mult = FLESHEATER_STORED_LIFESTEAL_MULT
	var/flesh_heal_cooldown = FLESH_HEAL_COOLDOWN
	var/flesh_heal_delay = FLESH_HEAL_DELAY

	speed_modifier = -XENO_SPEED_MOD_VERYSMALL
	health_modifier = XENO_HEALTH_MOD_SMALL

/datum/xeno_strain/individual/flesheater/apply_strain(mob/living/carbon/Xenomorph/X)
	. = ..()
	if (!.)
		return FALSE

	var/mob/living/carbon/Xenomorph/Runner/R = X
	if(!istype(R))
		log_debug("DEBUG: [R] tried to purchase an invalid strain ([src]).")
		return FALSE
	xeno = X
	X.strain = src

	strain_update_actions(R)
	recalculate_actions(description)
	R.recalculate_speed_modifiers()
	R.recalculate_health_modifiers()