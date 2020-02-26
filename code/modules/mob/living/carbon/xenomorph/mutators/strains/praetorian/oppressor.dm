/datum/xeno_mutator/praetorian_oppressor
	// Dread it, run from it, destiny still arrives.. or should I say, I do
	name = "STRAIN: Praetorian - Oppressor"
	description = "You abandon your speed and some of your pheromones to become a nigh-indestructible bulwark of the Queen and gain a powerful neurotoxin bomb you can lob at your foes. Your screech now makes your sisters and yourself even harder to kill."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Praetorian")  
	mutator_actions_to_remove = list("Xeno Spit","Toggle Spit Type", "Spray Acid")
	mutator_actions_to_add = list(/datum/action/xeno_action/activable/prae_punch, /datum/action/xeno_action/activable/prae_bomb)
	keystone = TRUE

/datum/xeno_mutator/praetorian_oppressor/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return
	
	var/mob/living/carbon/Xenomorph/Praetorian/P = MS.xeno
	P.armor_modifier += XENO_ARMOR_MOD_SMALL;
	P.explosivearmor_modifier += XENO_EXPOSIVEARMOR_MOD_MED;
	P.speed_modifier += XENO_SPEED_MOD_ULTRA + XENO_SPEED_MOD_VERYLARGE;
	P.phero_modifier -= XENO_PHERO_MOD_SMALL;
	P.plasma_types = list(PLASMA_NEUROTOXIN,PLASMA_CHITIN)
	mutator_update_actions(P);
	MS.recalculate_actions(description)
	P.recalculate_everything()
	P.has_spat = FALSE
	P.mutation_type = PRAETORIAN_OPPRESSOR

/*
	NEURO NADE
*/

/datum/action/xeno_action/activable/prae_bomb
	name = "Toxin Bomb (300)"
	action_icon_state = "bombard"
	ability_name = "toxin bomb"
	macro_path = /datum/action/xeno_action/verb/verb_prae_bomb
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/prae_bomb/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.praetorian_neuro_grenade(A)
	..()

/datum/action/xeno_action/activable/prae_bomb/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.has_spat

/datum/action/xeno_action/verb/verb_prae_bomb()
	set category = "Alien"
	set name = "Praetorian Bomb"
	set hidden = 1
	var/action_name = "Toxin Bomb (300)"
	handle_xeno_macro(src, action_name)

/mob/living/carbon/Xenomorph/proc/praetorian_neuro_grenade(atom/T)
	var/datum/caste_datum/praetorian/pCaste = src.caste
	if (!check_state())
		return

	if (has_spat)
		to_chat(src, SPAN_XENOWARNING("You must gather your strength before launching another toxin bomb."))
		return

	if (!check_plasma(300))
		return

	var/turf/current_turf = get_turf(src)

	if (!current_turf)
		return

	has_spat = TRUE

	if (do_after(src, pCaste.oppressor_grenade_setup, INTERRUPT_NO_NEEDHAND|INTERRUPT_LCLICK, BUSY_ICON_HOSTILE, show_remaining_time = TRUE))
		to_chat(src, SPAN_XENOWARNING("You decide not to use your toxin bomb."))
		has_spat = FALSE
		return

	plasma_stored -= 300

	add_timer(CALLBACK(src, .proc/toxin_bomb_cooldown), pCaste.oppressor_grenade_cooldown)

	to_chat(src, SPAN_XENOWARNING("You lob a compressed ball of neurotoxin into the air!"))
	
	var/obj/item/explosive/grenade/xeno_neuro_grenade/grenade = new /obj/item/explosive/grenade/xeno_neuro_grenade
	grenade.loc = loc
	grenade.launch_towards(T, 5, SPEED_VERY_SLOW, src, TRUE)

	spawn (pCaste.oppressor_grenade_fuse)
		grenade.prime()



/*
	PRAE PUNCH
*/

/datum/action/xeno_action/activable/prae_punch
	name = "Punch (75)"
	action_icon_state = "punch"
	ability_name = "punch"
	macro_path = /datum/action/xeno_action/verb/verb_prae_punch
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/prae_punch/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.praetorian_punch(A)
	..()

/datum/action/xeno_action/activable/prae_punch/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_punch

/datum/action/xeno_action/verb/verb_prae_punch()
	set category = "Alien"
	set name = "Praetorian Punch"
	set hidden = 1
	var/action_name = "Punch (75)"
	handle_xeno_macro(src, action_name) 

/mob/living/carbon/Xenomorph/proc/praetorian_punch(atom/A)
	var/datum/caste_datum/praetorian/pCaste = src.caste

	if (!A || !ishuman(A))
		return

	if (!check_state())
		return

	if (used_punch)
		to_chat(src, "<span class='xenowarning'>You must gather your strength before punching again.</span>")
		return

	if (!check_plasma(75))
		return

	if (!Adjacent(A))
		return

	use_plasma(75)
	var/mob/living/carbon/human/H = A
	if(H.stat == DEAD) return
	if(istype(H.buckled, /obj/structure/bed/nest)) return
	
	var/obj/limb/L = H.get_limb(check_zone(zone_selected))

	if (!L || (L.status & LIMB_DESTROYED))
		return

	visible_message("<span class='xenowarning'>\The [src] hits [H] in the [L.display_name] with a devastatingly powerful punch!</span>", \
	"<span class='xenowarning'>You hit [H] in the [L.display_name] with a devastatingly powerful punch!</span>")
	var/S = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(H,S, 50, 1)
	used_punch = 1
	
	if(L.status & LIMB_SPLINTED) //If they have it splinted, the splint won't hold.
		L.status &= ~LIMB_SPLINTED
		to_chat(H, SPAN_DANGER("The splint on your [L.display_name] comes apart!"))

	if(isYautja(H))
		L.take_damage(rand(8,12))
	else
		var/fracture_chance = 50
		switch(L.body_part)
			if(BODY_FLAG_HEAD)
				fracture_chance = 20
			if(BODY_FLAG_CHEST)
				fracture_chance = 30
			if(BODY_FLAG_GROIN)
				fracture_chance = 40

		L.take_damage(rand(40,50), 0, 0)
		if(prob(fracture_chance))
			L.fracture()

	shake_camera(H, 2, 1)

	var/facing = get_dir(src, H)
	var/fling_distance = pCaste.oppressor_punch_fling_dist
	var/turf/T = loc
	var/turf/temp = loc

	for (var/x in 0 to fling_distance-1)
		temp = get_step(T, facing)
		if (!temp)
			break
		T = temp

	H.launch_towards(T, fling_distance, SPEED_FAST, src, 1)

	add_timer(CALLBACK(src, .proc/prae_punch_cooldown), pCaste.oppressor_punch_cooldown)


/mob/living/carbon/Xenomorph/proc/toxin_bomb_cooldown()
	has_spat = FALSE
	to_chat(src, SPAN_XENOWARNING("You gather enough strength to use your toxin bomb again."))
	for(var/X in actions)
		var/datum/action/act = X
		act.update_button_icon()

/mob/living/carbon/Xenomorph/proc/prae_punch_cooldown()
	used_punch = 0
	to_chat(src, SPAN_NOTICE("You gather enough strength to punch again."))
	for(var/X in actions)
		var/datum/action/act = X
		act.update_button_icon()
