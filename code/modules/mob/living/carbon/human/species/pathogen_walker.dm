// DEFINES
///Time until a zombie rises from the dead
#define WALKER_REVIVE_TIME 1 MINUTES

/datum/species/pathogen_walker
	group = SPECIES_HUMAN
	name = SPECIES_PATHO_WALKER
	name_plural = "Walkers"
	slowdown = 0.75
	blood_color = BLOOD_COLOR_ZOMBIE
	icobase = 'icons/mob/humans/species/r_goo_zed.dmi'
	deform = 'icons/mob/humans/species/r_goo_zed.dmi'
	eyes = "blank_s"
	pain_type = /datum/pain/zombie
	stamina_type = /datum/stamina/none
	death_message = "seizes up and falls limp..."
	flags = NO_BREATHE|NO_CLONE_LOSS|NO_POISON|NO_NEURO|NO_SHRAPNEL
	mob_inherent_traits = list(TRAIT_FOREIGN_BIO)
	brute_mod = 0.6 //Minor bullet resistance
	burn_mod = 0.8 //Lowered burn damage since it would 1-shot zombies from 2 to 0.8.
	speech_chance  = 5
	cold_level_1 = -1  //zombies don't mind the cold
	cold_level_2 = -1
	cold_level_3 = -1
	has_fine_manipulation = FALSE
	can_emote = FALSE
	knock_down_reduction = 10
	stun_reduction = 10
	knock_out_reduction = 5
	has_organ = list()

	has_species_tab_items = TRUE

	speech_sounds = list('sound/pathogen_creatures/pathogen_talk1.ogg','sound/pathogen_creatures/pathogen_talk2.ogg','sound/pathogen_creatures/pathogen_talk3.ogg')
	speech_chance = 100

	var/list/to_revive = list()
	var/list/revive_times = list()

	var/basic_noise = 'sound/pathogen_creatures/pathogen_growl2.ogg'
	var/basic_variance = TRUE
	var/rare_noise = 'sound/pathogen_creatures/pathogen_growl1.ogg'
	var/rare_variance = TRUE

/datum/species/pathogen_walker/handle_post_spawn(mob/living/carbon/human/zombie)
	zombie.set_languages(list(LANGUAGE_PATHOGEN, LANGUAGE_PATHOGEN_MIND))

	zombie.faction = FACTION_PATHOGEN
	zombie.hivenumber = XENO_HIVE_PATHOGEN
	zombie.faction_group = list(FACTION_PATHOGEN)
	zombie.job = SPECIES_PATHO_WALKER

	if(zombie.l_hand)
		zombie.drop_inv_item_on_ground(zombie.l_hand, FALSE, TRUE)
	if(zombie.r_hand)
		zombie.drop_inv_item_on_ground(zombie.r_hand, FALSE, TRUE)
	if(zombie.wear_id)
		zombie.drop_inv_item_on_ground(zombie.wear_id, FALSE, TRUE)
	if(zombie.gloves)
		zombie.drop_inv_item_on_ground(zombie.gloves, FALSE, TRUE)
	if(zombie.head)
		zombie.drop_inv_item_on_ground(zombie.head, FALSE, TRUE)
	if(zombie.glasses)
		zombie.drop_inv_item_on_ground(zombie.glasses, FALSE, TRUE)
	if(zombie.wear_mask)
		zombie.drop_inv_item_on_ground(zombie.wear_mask, FALSE, TRUE)

	var/obj/item/weapon/zombie_claws/no_infect/pathogen/ZC = new(zombie)
	ZC.icon_state = "claw_r"
	zombie.equip_to_slot_or_del(ZC, WEAR_R_HAND, TRUE)
	zombie.equip_to_slot_or_del(new /obj/item/weapon/zombie_claws/no_infect/pathogen(zombie), WEAR_L_HAND, TRUE)
	zombie.equip_to_slot_or_del(new /obj/item/clothing/glasses/zombie_eyes/pathogen(zombie), WEAR_EYES, TRUE)

	var/datum/mob_hud/zom_hud = GLOB.huds[MOB_HUD_MEDICAL_OBSERVER]
	zom_hud.add_hud_to(zombie, zombie)
	zom_hud = GLOB.huds[MOB_HUD_XENO_STATUS]
	zom_hud.add_hud_to(zombie, zombie)

	to_chat(zombie, SPAN_PATHOGEN_ANNOUNCE("You have become a [SPECIES_PATHO_WALKER], an undead creation held together by mycelial spores. You serve the [FACTION_PATHOGEN] and its Overmind."))

	return ..()



/datum/species/pathogen_walker/post_species_loss(mob/living/carbon/human/zombie)
	..()
	remove_from_revive(zombie)
	var/datum/mob_hud/zom_hud = GLOB.huds[MOB_HUD_MEDICAL_OBSERVER]
	zom_hud.remove_hud_from(zombie, zombie)
	zom_hud = GLOB.huds[MOB_HUD_XENO_STATUS]
	zom_hud.remove_hud_from(zombie, zombie)


/datum/species/pathogen_walker/handle_unique_behavior(mob/living/carbon/human/zombie)
	if(prob(5))
		playsound(zombie.loc, basic_noise, 15, basic_variance)
	else if(prob(5))
		playsound(zombie.loc, rare_noise, 15, rare_variance)

/datum/species/pathogen_walker/handle_death(mob/living/carbon/human/zombie, gibbed)
	set waitfor = FALSE

	if(gibbed)
		remove_from_revive(zombie)
		return

	if(zombie)
		var/obj/limb/head/head = zombie.get_limb("head")
		if(!QDELETED(head) && !(head.status & LIMB_DESTROYED))
			if(zombie.client)
				zombie.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>You are dead...</u></span><br>You will rise again in one minute.", /atom/movable/screen/text/screen_text/command_order, rgb(155, 0, 200))
			to_chat(zombie, SPAN_XENOWARNING("You fall... but your body is slowly regenerating itself."))
			var/weak_ref = WEAKREF(zombie)
			to_revive[weak_ref] = addtimer(CALLBACK(src, PROC_REF(revive_from_death), zombie, "[REF(zombie)]"), WALKER_REVIVE_TIME, TIMER_STOPPABLE|TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT)
			revive_times[weak_ref] = world.time + 1 MINUTES
		else
			if(zombie.client)
				zombie.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>You are dead...</u></span><br>You lost your head. No reviving for you.", /atom/movable/screen/text/screen_text/command_order, rgb(155, 0, 200))
			to_chat(zombie, SPAN_XENOWARNING("You fall... headless, you will no longer rise."))
			zombie.undefibbable = TRUE // really only for weed_food
			SEND_SIGNAL(zombie, COMSIG_HUMAN_SET_UNDEFIBBABLE)

/datum/species/pathogen_walker/handle_dead_death(mob/living/carbon/human/zombie, gibbed)
	if(gibbed)
		remove_from_revive(zombie)

/datum/species/pathogen_walker/proc/revive_from_death(mob/living/carbon/human/zombie)
	if(zombie && zombie.loc && zombie.stat == DEAD)
		zombie.revive(TRUE)
		zombie.apply_effect(4, STUN)

		zombie.make_jittery(500)
		zombie.visible_message(SPAN_WARNING("[zombie] rises from the ground!"))
		remove_from_revive(zombie)

		handle_alert_ghost(zombie)

		addtimer(CALLBACK(zombie, TYPE_PROC_REF(/mob, remove_jittery)), 3 SECONDS)

/datum/species/pathogen_walker/proc/handle_alert_ghost(mob/living/carbon/human/zombie)
	var/mob/dead/observer/ghost = zombie.get_ghost()
	if(ghost?.client)
		playsound_client(ghost.client, 'sound/effects/adminhelp_new.ogg')
		to_chat(ghost, SPAN_BOLDNOTICE(FONT_SIZE_LARGE("Your body has risen! (Verbs -> Ghost -> Re-enter corpse, or <a href='byond://?src=\ref[ghost];reentercorpse=1'>click here!</a>)")))
	else if(!zombie.client)
		zombie.free_for_ghosts(TRUE)

/datum/species/pathogen_walker/proc/remove_from_revive(mob/living/carbon/human/zombie)
	var/weak_ref = WEAKREF(zombie)
	if(weak_ref in to_revive)
		deltimer(to_revive[weak_ref])
		to_revive -= weak_ref
	revive_times -= weak_ref

/datum/species/pathogen_walker/get_status_tab_items(mob/living/carbon/human/zombie)
	var/list/static_tab_items = list()
	if(zombie.stat == DEAD)
		var/revive_time = revive_times[WEAKREF(zombie)]
		if(revive_time)
			var/revive_time_left = revive_time - world.time
			static_tab_items += ""
			static_tab_items += "Time Till Revive: [duration2text_sec(revive_time_left)]"
	return static_tab_items

/datum/species/pathogen_walker/handle_head_loss(mob/living/carbon/human/zombie)
	if(!zombie.undefibbable)
		zombie.undefibbable = TRUE // really only for weed_food
		SEND_SIGNAL(zombie, COMSIG_HUMAN_SET_UNDEFIBBABLE)
	if(WEAKREF(zombie) in to_revive)
		remove_from_revive(zombie)
		var/client/receiving_client = zombie.client
		if(!receiving_client)
			var/mob/dead/observer/ghost = zombie.get_ghost()
			if(ghost)
				receiving_client = ghost.client
		if(receiving_client)
			receiving_client.mob.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>Beheaded...</u></span><br>Your corpse will no longer rise.", /atom/movable/screen/text/screen_text/command_order, rgb(155, 0, 200))
			to_chat(receiving_client, SPAN_BOLDNOTICE(FONT_SIZE_LARGE("You've been beheaded! Your body will no longer rise.")))
