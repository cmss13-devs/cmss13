/datum/species/zombie
	group = SPECIES_HUMAN
	name = SPECIES_ZOMBIE
	name_plural = "Zombies"
	slowdown = 1
	blood_color = "#333333"
	icobase = 'icons/mob/humans/species/r_goo_zed.dmi'
	deform = 'icons/mob/humans/species/r_goo_zed.dmi'
	eyes = "blank_s"
	pain_type = /datum/pain/zombie
	stamina_type = /datum/stamina/none
	death_message = "seizes up and falls limp..."
	flags = NO_BREATHE|NO_CLONE_LOSS|NO_POISON|NO_NEURO|NO_SHRAPNEL
	mob_inherent_traits = list(TRAIT_FOREIGN_BIO)
	brute_mod = 0.25 //EXTREME BULLET RESISTANCE
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

	var/list/to_revive = list()
	var/list/revive_times = list()

	var/basic_moan = 'sound/hallucinations/far_noise.ogg'
	var/basic_variance = TRUE
	var/rare_moan = 'sound/hallucinations/veryfar_noise.ogg'
	var/rare_variance = TRUE

/datum/species/zombie/handle_post_spawn(var/mob/living/carbon/human/zombie)
	zombie.set_languages(list("Zombie"))

	zombie.faction = FACTION_ZOMBIE
	zombie.faction_group = list(FACTION_ZOMBIE)

	if(zombie.l_hand) zombie.drop_inv_item_on_ground(zombie.l_hand, FALSE, TRUE)
	if(zombie.r_hand) zombie.drop_inv_item_on_ground(zombie.r_hand, FALSE, TRUE)
	if(zombie.wear_id) qdel(zombie.wear_id)
	if(zombie.gloves) zombie.drop_inv_item_on_ground(zombie.gloves, FALSE, TRUE)
	if(zombie.head) zombie.drop_inv_item_on_ground(zombie.head, FALSE, TRUE)
	if(zombie.glasses) zombie.drop_inv_item_on_ground(zombie.glasses, FALSE, TRUE)
	if(zombie.wear_mask) zombie.drop_inv_item_on_ground(zombie.wear_mask, FALSE, TRUE)

	if(zombie.lying)
		zombie.lying = FALSE

	var/obj/item/weapon/zombie_claws/ZC = new(zombie)
	ZC.icon_state = "claw_r"
	zombie.equip_to_slot_or_del(ZC, WEAR_R_HAND, TRUE)
	zombie.equip_to_slot_or_del(new /obj/item/weapon/zombie_claws(zombie), WEAR_L_HAND, TRUE)
	zombie.equip_to_slot_or_del(new /obj/item/clothing/glasses/zombie_eyes(zombie), WEAR_EYES, TRUE)

	var/datum/disease/black_goo/D = locate() in zombie.viruses
	if(!D)
		D = zombie.AddDisease(new /datum/disease/black_goo())
	D.stage = 5

	var/datum/mob_hud/Hu = huds[MOB_HUD_MEDICAL_OBSERVER]
	Hu.add_hud_to(zombie)

	return ..()


/datum/species/zombie/post_species_loss(mob/living/carbon/human/zombie)
	..()
	remove_from_revive(zombie)
	var/datum/mob_hud/Hu = huds[MOB_HUD_MEDICAL_OBSERVER]
	Hu.remove_hud_from(zombie)


/datum/species/zombie/handle_unique_behavior(var/mob/living/carbon/human/zombie)
	if(prob(5))
		playsound(zombie.loc, basic_moan, 15, basic_variance)
	else if(prob(5))
		playsound(zombie.loc, rare_moan, 15, rare_variance)

/datum/species/zombie/handle_death(var/mob/living/carbon/human/zombie, gibbed)
	set waitfor = 0

	if(gibbed)
		remove_from_revive(zombie)
		return

	if(zombie)
		var/obj/limb/head/head = zombie.get_limb("head")
		if(!QDELETED(head) && !(head.status & LIMB_DESTROYED))
			if(zombie.client)
				zombie.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>You are dead...</u></span><br>You will rise again in one minute.", /atom/movable/screen/text/screen_text/command_order, rgb(155, 0, 200))
			to_chat(zombie, SPAN_XENOWARNING("You fall... but your body is slowly regenerating itself."))
			to_revive[WEAKREF(zombie)] = addtimer(CALLBACK(src, .proc/revive_from_death, zombie), 1 MINUTES, TIMER_STOPPABLE|TIMER_OVERRIDE|TIMER_UNIQUE)
			revive_times[WEAKREF(zombie)] = world.time + 1 MINUTES
		else
			if(zombie.client)
				zombie.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>You are dead...</u></span><br>You lost your head. No reviving for you.", /atom/movable/screen/text/screen_text/command_order, rgb(155, 0, 200))
			to_chat(zombie, SPAN_XENOWARNING("You fall... headless, you will no longer rise."))

/datum/species/zombie/handle_dead_death(var/mob/living/carbon/human/zombie, gibbed)
	if(gibbed)
		remove_from_revive(zombie)

/datum/species/zombie/proc/revive_from_death(var/mob/living/carbon/human/zombie)
	if(zombie && zombie.loc && zombie.stat == DEAD)
		zombie.revive(TRUE)
		zombie.stunned = 4

		zombie.make_jittery(500)
		zombie.visible_message(SPAN_WARNING("[zombie] rises from the ground!"))
		remove_from_revive(zombie)

		handle_alert_ghost(zombie)

		addtimer(CALLBACK(zombie, /mob/.proc/remove_jittery), 3 SECONDS)

/datum/species/zombie/proc/handle_alert_ghost(var/mob/living/carbon/human/zombie)
	var/mob/dead/observer/ghost = zombie.get_ghost()
	if(ghost?.client)
		playsound_client(ghost.client, 'sound/effects/adminhelp_new.ogg')
		to_chat(ghost, SPAN_BOLDNOTICE(FONT_SIZE_LARGE("Your body has risen! (Verbs -> Ghost -> Re-enter corpse, or <a href='?src=\ref[ghost];reentercorpse=1'>click here!</a>)")))

/datum/species/zombie/proc/remove_from_revive(var/mob/living/carbon/human/zombie)
	if(WEAKREF(zombie) in to_revive)
		deltimer(to_revive[WEAKREF(zombie)])
		to_revive -= WEAKREF(zombie)
	revive_times -= WEAKREF(zombie)

/datum/species/zombie/get_status_tab_items(var/mob/living/carbon/human/zombie)
	var/list/static_tab_items = list()
	if(zombie.stat == DEAD)
		var/revive_time = revive_times[WEAKREF(zombie)]
		if(revive_time)
			var/revive_time_left = revive_time - world.time
			static_tab_items += ""
			static_tab_items += "Time Till Revive: [duration2text_sec(revive_time_left)]"
	return static_tab_items

/datum/species/zombie/handle_head_loss(var/mob/living/carbon/human/zombie)
	if(WEAKREF(zombie) in to_revive)
		remove_from_revive(zombie)
		var/client/receiving_client = zombie.client
		if(!receiving_client)
			var/mob/dead/observer/ghost = zombie.get_ghost()
			if(ghost) receiving_client = ghost.client
		if(receiving_client)
			receiving_client.mob.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>Beheaded...</u></span><br>Your corpse will no longer rise.", /atom/movable/screen/text/screen_text/command_order, rgb(155, 0, 200))
			to_chat(receiving_client, SPAN_BOLDNOTICE(FONT_SIZE_LARGE("You've been beheaded! Your body will no longer rise.")))
