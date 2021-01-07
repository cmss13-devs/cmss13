/datum/species/zombie
	name= "Zombie"
	name_plural = "Zombies"
	slowdown = 1
	blood_color = "#333333"
	icobase = 'icons/mob/humans/species/r_goo_zed.dmi'
	deform = 'icons/mob/humans/species/r_goo_zed.dmi'
	pain_type = /datum/pain/zombie
	stamina_type = /datum/stamina/none
	death_message = "seizes up and falls limp..."
	flags = NO_BREATHE|NO_SCAN|NO_POISON|NO_NEURO|NO_SHRAPNEL
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

	var/list/to_revive = list()

/datum/species/zombie/handle_post_spawn(var/mob/living/carbon/human/H)
	H.set_languages(list("Zombie"))

	H.faction = FACTION_ZOMBIE
	H.faction_group = list(FACTION_ZOMBIE)

	if(H.l_hand) H.drop_inv_item_on_ground(H.l_hand, FALSE, TRUE)
	if(H.r_hand) H.drop_inv_item_on_ground(H.r_hand, FALSE, TRUE)
	if(H.wear_id) qdel(H.wear_id)
	if(H.gloves) H.drop_inv_item_on_ground(H.gloves, FALSE, TRUE)
	if(H.head) H.drop_inv_item_on_ground(H.head, FALSE, TRUE)
	if(H.glasses) H.drop_inv_item_on_ground(H.glasses, FALSE, TRUE)
	if(H.wear_mask) H.drop_inv_item_on_ground(H.wear_mask, FALSE, TRUE)

	var/obj/item/weapon/zombie_claws/ZC = new(H)
	ZC.icon_state = "claw_r"
	H.equip_to_slot_or_del(ZC, WEAR_R_HAND, TRUE)
	H.equip_to_slot_or_del(new /obj/item/weapon/zombie_claws(H), WEAR_L_HAND, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/zombie_eyes(H), WEAR_EYES, TRUE)

	var/datum/disease/D
	
	for(var/datum/disease/black_goo/DD in H.viruses)
		D = DD

	if(!D) 
		D = H.AddDisease(new /datum/disease/black_goo())
	
	D.stage = 5

	var/datum/mob_hud/Hu = huds[MOB_HUD_MEDICAL_OBSERVER]
	Hu.add_hud_to(H)

	return ..()


/datum/species/zombie/post_species_loss(mob/living/carbon/human/H)
	if(H in to_revive)
		deltimer(to_revive[H])
		to_revive -= H
	
	var/datum/mob_hud/Hu = huds[MOB_HUD_MEDICAL_OBSERVER]
	Hu.remove_hud_from(H)


/datum/species/zombie/handle_unique_behavior(var/mob/living/carbon/human/H)
	if(prob(5))
		playsound(H.loc, 'sound/hallucinations/far_noise.ogg', 15, 1)
	else if(prob(5))
		playsound(H.loc, 'sound/hallucinations/veryfar_noise.ogg', 15, 1)

/datum/species/zombie/handle_death(var/mob/living/carbon/human/H, gibbed)
	set waitfor = 0
	if(gibbed) return

	if(H)
		to_chat(H, SPAN_XENOWARNING("You fall... but your body is slowly regenerating itself."))
		prepare_to_revive(H, MINUTES_1)

/datum/species/zombie/proc/prepare_to_revive(var/mob/living/carbon/human/H, var/time)
	to_revive.Add(H)
	to_revive[H] = addtimer(CALLBACK(src, .proc/revive_from_death, H), time, TIMER_STOPPABLE | TIMER_OVERRIDE|TIMER_UNIQUE)

/datum/species/zombie/proc/remove_from_revive(var/mob/living/carbon/human/H)
	if(H in to_revive)
		deltimer(to_revive[H])

/datum/species/zombie/proc/revive_from_death(var/mob/living/carbon/human/H)
	if(H && H.loc && H.stat == DEAD)
		H.revive(TRUE)
		H.stunned = 4

		H.make_jittery(500)
		H.visible_message(SPAN_WARNING("[H] rises from the ground!"))
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET, TRUE)

		addtimer(CALLBACK(H, /mob/.proc/remove_jittery), SECONDS_3)