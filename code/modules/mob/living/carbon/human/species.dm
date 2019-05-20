/*
	Datum-based species. Should make for much cleaner and easier to maintain mutantrace code.
*/

/datum/species

	var/name                                             // Species name.
	var/name_plural

	var/icobase = 'icons/mob/human_races/r_human.dmi'    // Normal icon set.
	var/deform = 'icons/mob/human_races/r_def_human.dmi' // Mutated icon set.
	var/prone_icon                                       // If set, draws this from icobase when mob is prone.
	var/eyes = "eyes_s"                                  // Icon for eyes.
	var/uses_ethnicity = FALSE						 //Set to TRUE to load proper ethnicities and what have you

	var/primitive                              // Lesser form, if any (ie. monkey for humans)
	var/tail                                   // Name of tail image in species effects icon file.
	var/datum/unarmed_attack/unarmed           // For empty hand harm-intent attack
	var/datum/unarmed_attack/secondary_unarmed // For empty hand harm-intent attack if the first fails.
	var/datum/hud_data/hud
	var/hud_type
	var/slowdown = 0
	var/gluttonous        // Can eat some mobs. 1 for monkeys, 2 for people.
	var/rarity_value = 1  // Relative rarity/collector value for this species. Only used by ninja and cultists atm.
	var/unarmed_type =           /datum/unarmed_attack
	var/secondary_unarmed_type = /datum/unarmed_attack/bite

	var/list/speech_sounds        // A list of sounds to potentially play when speaking.
	var/list/speech_chance
	var/has_fine_manipulation = 1 // Can use small items.
	var/insulated                 // Immune to electrocution and glass shards to the feet.

	// Some species-specific gibbing data.
	var/gibbed_anim = "gibbed-h"
	var/dusted_anim = "dust-h"
	var/remains_type = /obj/effect/decal/remains/xeno
	var/death_sound
	var/death_message = "seizes up and falls limp, their eyes dead and lifeless..."

	var/breath_type = "oxygen"   // Non-oxygen gas breathed, if any.
	var/poison_type = "phoron"   // Poisonous air.
	var/exhale_type = "carbon_dioxide"      // Exhaled gas type.

	var/total_health = 100  //new maxHealth

	var/cold_level_1 = 260  // Cold damage level 1 below this point.
	var/cold_level_2 = 240  // Cold damage level 2 below this point.
	var/cold_level_3 = 120  // Cold damage level 3 below this point.

	var/heat_level_1 = 360  // Heat damage level 1 above this point.
	var/heat_level_2 = 400  // Heat damage level 2 above this point.
	var/heat_level_3 = 1000 // Heat damage level 2 above this point.

	var/body_temperature = 310.15	//non-IS_SYNTHETIC species will try to stabilize at this temperature. (also affects temperature processing)
	var/reagent_tag                 //Used for metabolizing reagents.

	var/darksight = 2
	var/hazard_high_pressure = HAZARD_HIGH_PRESSURE   // Dangerously high pressure.
	var/warning_high_pressure = WARNING_HIGH_PRESSURE // High pressure warning.
	var/warning_low_pressure = WARNING_LOW_PRESSURE   // Low pressure warning.
	var/hazard_low_pressure = HAZARD_LOW_PRESSURE     // Dangerously low pressure.

	var/brute_mod = null    // Physical damage reduction/malus.
	var/burn_mod = null     // Burn damage reduction/malus.

	var/flags = 0       // Various specific features.

	var/list/abilities = list()	// For species-derived or admin-given powers

	var/blood_color = "#A10808" //Red.
	var/flesh_color = "#FFC896" //Pink.
	var/base_color      //Used when setting species.
	var/hair_color      //If the species only has one hair color

	//Used in icon caching.
	var/race_key = 0
	var/icon/icon_template

	// Species-specific abilities.
	var/list/inherent_verbs
	var/list/has_organ = list(
		"heart" =    /datum/internal_organ/heart,
		"lungs" =    /datum/internal_organ/lungs,
		"liver" =    /datum/internal_organ/liver,
		"kidneys" =  /datum/internal_organ/kidneys,
		"brain" =    /datum/internal_organ/brain,
		"appendix" = /datum/internal_organ/appendix,
		"eyes" =     /datum/internal_organ/eyes
		)

	var/knock_down_reduction = 1 //how much the knocked_down effect is reduced per Life call.
	var/stun_reduction = 1 //how much the stunned effect is reduced per Life call.
	var/knock_out_reduction = 1 //same thing

	var/list/slot_equipment_priority = DEFAULT_SLOT_PRIORITY

/datum/species/New()
	if(hud_type)
		hud = new hud_type()
	else
		hud = new()

	if(unarmed_type) unarmed = new unarmed_type()
	if(secondary_unarmed_type) secondary_unarmed = new secondary_unarmed_type()

/datum/species/proc/create_organs(var/mob/living/carbon/human/H) //Handles creation of mob organs and limbs.

	H.limbs = list()
	H.internal_organs = list()
	H.internal_organs_by_name = list()

	//This is a basic humanoid limb setup.
	var/datum/limb/chest/C = new(null, H)
	H.limbs += C
	var/datum/limb/groin/G = new(C, H)
	H.limbs += G
	H.limbs += new/datum/limb/head(C, H)
	var/datum/limb/arm/l_arm/LA = new(C, H)
	H.limbs += LA
	var/datum/limb/arm/r_arm/RA = new(C, H)
	H.limbs += RA
	var/datum/limb/leg/l_leg/LL = new(G, H)
	H.limbs += LL
	var/datum/limb/leg/r_leg/RL = new(G, H)
	H.limbs += RL
	H.limbs +=  new/datum/limb/hand/l_hand(LA, H)
	H.limbs +=  new/datum/limb/hand/r_hand(RA, H)
	H.limbs +=  new/datum/limb/foot/l_foot(LL, H)
	H.limbs +=  new/datum/limb/foot/r_foot(RL, H)

	for(var/organ in has_organ)
		var/organ_type = has_organ[organ]
		H.internal_organs_by_name[organ] = new organ_type(H)

	if(flags & IS_SYNTHETIC)
		for(var/datum/limb/E in H.limbs)
			if(E.status & LIMB_DESTROYED) continue
			E.status |= LIMB_ROBOT
		for(var/datum/internal_organ/I in H.internal_organs)
			I.mechanize()


/datum/species/proc/hug(var/mob/living/carbon/human/H,var/mob/living/target)

	var/t_him = "them"
	switch(target.gender)
		if(MALE)
			t_him = "him"
		if(FEMALE)
			t_him = "her"

	H.visible_message(SPAN_NOTICE("[H] hugs [target] to make [t_him] feel better!"), \
					SPAN_NOTICE("You hug [target] to make [t_him] feel better!"), null, 4)

//special things to change after we're no longer that species
/datum/species/proc/post_species_loss(mob/living/carbon/human/H)
	return

/datum/species/proc/remove_inherent_verbs(var/mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs -= verb_path
	return

/datum/species/proc/add_inherent_verbs(var/mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs |= verb_path
	return

/datum/species/proc/handle_post_spawn(var/mob/living/carbon/human/H) //Handles anything not already covered by basic species assignment.
	if(!H.languages || H.languages.len == 0)
		H.set_languages(list("English"))
	add_inherent_verbs(H)

/datum/species/proc/handle_death(var/mob/living/carbon/human/H) //Handles any species-specific death events.
/*
	if(flags & IS_SYNTHETIC)
		H.h_style = ""
		spawn(100)
			if(!H) return
			H.update_hair()
	return
*/

//Only used by horrors at the moment. Only triggers if the mob is alive and not dead.
/datum/species/proc/handle_unique_behavior(var/mob/living/carbon/human/H)
	return

// Used to update alien icons for aliens.
/datum/species/proc/handle_login_special(var/mob/living/carbon/human/H)
	return

// As above.
/datum/species/proc/handle_logout_special(var/mob/living/carbon/human/H)
	return

// Builds the HUD using species-specific icons and usable slots.
/datum/species/proc/build_hud(var/mob/living/carbon/human/H)
	return

// Grabs the window recieved when you click-drag someone onto you.
/datum/species/proc/get_inventory_dialogue(var/mob/living/carbon/human/H)
	return

//Used by xenos understanding larvae and dionaea understanding nymphs.
/datum/species/proc/can_understand(var/mob/other)
	return

/datum/species/human
	name = "Human"
	name_plural = "Humans"
	primitive = /mob/living/carbon/monkey
	unarmed_type = /datum/unarmed_attack/punch
	flags = HAS_SKIN_TONE|HAS_LIPS|HAS_UNDERWEAR
	uses_ethnicity = TRUE

	//If you wanted to add a species-level ability:
	/*abilities = list(/client/proc/test_ability)*/

//Slightly tougher humans.
/datum/species/human/hero
	name = "Human Hero"
	name_plural = "Human Heroes"
	brute_mod = 0.55
	burn_mod = 0.55
	unarmed_type = /datum/unarmed_attack/punch/strong

	cold_level_1 = 220
	cold_level_2 = 180
	cold_level_3 = 80
	heat_level_1 = 390
	heat_level_2 = 480
	heat_level_3 = 1100


//Various horrors that spawn in and haunt the living.
/datum/species/human/spook
	name = "Horror"
	name_plural = "Horrors"
	icobase = 'icons/mob/human_races/r_spooker.dmi'
	deform = 'icons/mob/human_races/r_spooker.dmi'
	brute_mod = 0.15
	burn_mod = 1.50
	reagent_tag = IS_HORROR
	flags = HAS_SKIN_COLOR|NO_BREATHE|NO_POISON|HAS_LIPS|NO_PAIN|NO_SCAN|NO_POISON|NO_BLOOD|NO_SLIP|NO_CHEM_METABOLIZATION
	unarmed_type = /datum/unarmed_attack/punch/strong
	secondary_unarmed_type = /datum/unarmed_attack/bite/strong
	death_message = "doubles over, unleashes a horrible, ear-shattering scream, then falls motionless and still..."
	death_sound = 'sound/voice/scream_horror1.ogg'

	darksight = 8
	slowdown = 0.3
	insulated = 1
	has_fine_manipulation = 0

	heat_level_1 = 1000
	heat_level_2 = 1500
	heat_level_3 = 2000

	cold_level_1 = 100
	cold_level_2 = 50
	cold_level_3 = 20

	//To show them we mean business.
	handle_unique_behavior(var/mob/living/carbon/human/H)
		//if(prob(25)) animation_horror_flick(H)

		//Organ damage will likely still take them down eventually.
		H.adjustBruteLoss(-3)
		H.adjustFireLoss(-3)
		H.adjustOxyLoss(-15)
		H.adjustToxLoss(-15)


/datum/species/human/spook/handle_post_spawn(mob/living/carbon/human/H)
	H.set_languages(list("Drrrrrrr"))
	return ..()

/datum/species/synthetic
	name = "Synthetic"
	name_plural = "synthetics"
	uses_ethnicity = TRUE //Uses ethnic presets

	unarmed_type = /datum/unarmed_attack/punch/strong
	rarity_value = 2

	total_health = 150 //more health than regular humans

	brute_mod = 0.75
	burn_mod = 1.1

	cold_level_1 = -1
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 500
	heat_level_2 = 1000
	heat_level_3 = 2000

	body_temperature = 350

	flags = IS_WHITELISTED|NO_BREATHE|NO_SCAN|NO_BLOOD|NO_POISON|NO_PAIN|IS_SYNTHETIC|NO_CHEM_METABOLIZATION

	blood_color = "#EEEEEE"

	has_organ = list(
		"heart" =    /datum/internal_organ/heart/prosthetic,
		"brain" =    /datum/internal_organ/brain/prosthetic,
		)

	knock_down_reduction = 5
	stun_reduction = 5

	inherent_verbs = list(
		/datum/species/synthetic/verb/toggle_synthHUD1,
		/datum/species/synthetic/verb/toggle_synthHUD2,
		)

/datum/species/synthetic
var/toggled_med_HUD = 0
var/toggled_sec_HUD = 0

/datum/species/synthetic/verb/toggle_synthHUD1()
	set category = "Synthetic"//future-proofing for later things
	set name = "Toggle Medical HUD"
	set desc = "Toggles the advanced medical HUD integrated into your optical systems."
	var/datum/mob_hud/H = huds[MOB_HUD_MEDICAL_ADVANCED]
	if(usr.stat)
		return
	if(!toggled_med_HUD)
		toggled_med_HUD = 1
		H.add_hud_to(src)
		to_chat(src, "<span class='info'><B>Enabled</B></span>")
	else
		toggled_med_HUD = 0
		H.remove_hud_from(src)
		to_chat(src, "<span class='info'><B>Disabled</B></span>")

/datum/species/synthetic/verb/toggle_synthHUD2()
	set category = "Synthetic"
	set name = "Toggle Security HUD"
	set desc = "Toggles the advanced security HUD integrated into your optical systems."
	var/datum/mob_hud/H = huds[MOB_HUD_SECURITY_ADVANCED]
	if(usr.stat)
		return
	if(!toggled_sec_HUD)
		toggled_sec_HUD = 1
		H.add_hud_to(src)
		to_chat(src, "<span class='info'><B>Enabled</B></span>")
	else
		toggled_sec_HUD = 0
		H.remove_hud_from(src)
		to_chat(src, "<span class='info'><B>Disabled</B></span>")

/datum/species/synthetic/second_gen_synthetic
	name = "Second Generation Synthetic"
	uses_ethnicity = FALSE //2nd gen uses generic human look

/datum/species/early_synthetic
	name = "Early Synthetic"
	name_plural = "Early Synthetics"
	icobase = 'icons/mob/human_races/r_synthetic.dmi'
	deform = 'icons/mob/human_races/r_synthetic.dmi'
	unarmed_type = /datum/unarmed_attack/punch/strong
	rarity_value = 1.5
	slowdown = 1.3 //Slower than later synths
	total_health = 200 //But more durable
	insulated = 1
	brute_mod = 0.75
	burn_mod = 1.1

	cold_level_1 = -1
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 500
	heat_level_2 = 1000
	heat_level_3 = 2000

	body_temperature = 350

	flags = IS_WHITELISTED|NO_BREATHE|NO_SCAN|NO_BLOOD|NO_POISON|NO_PAIN|IS_SYNTHETIC|NO_CHEM_METABOLIZATION

	blood_color = "#EEEEEE"
	hair_color = "#000000"
	has_organ = list(
		"heart" =    /datum/internal_organ/heart/prosthetic,
		"brain" =    /datum/internal_organ/brain/prosthetic,
		)

	knock_down_reduction = 2
	stun_reduction = 2

/datum/species/zombie
	name= "Zombie"
	name_plural = "Zombies"
	slowdown = 1
	blood_color = "#333333"
	icobase = 'icons/mob/human_races/r_goo_zed.dmi'
	deform = 'icons/mob/human_races/r_goo_zed.dmi'
	death_message = "seizes up and falls limp... But is it dead?"
	flags = NO_PAIN|NO_BREATHE|NO_SCAN|NO_POISON
	brute_mod = 0.25 //EXTREME BULLET RESISTANCE
	burn_mod = 2 //IT BURNS
	speech_chance  = 5
	warning_low_pressure = 0
	hazard_low_pressure = 0
	cold_level_1 = -1  //zombies don't mind the cold
	cold_level_2 = -1
	cold_level_3 = -1
	hud_type = /datum/hud_data/zombie
	has_fine_manipulation = FALSE
	knock_down_reduction = 10
	stun_reduction = 10
	knock_out_reduction = 5
	has_organ = list()

/datum/species/zombie/handle_post_spawn(mob/living/carbon/human/H)
	H.set_languages("Zombie")
	return ..()

/datum/species/zombie/handle_post_spawn(var/mob/living/carbon/human/H)
	if(H.hud_used)
		qdel(H.hud_used)
		H.hud_used = null
//		H.create_mob_hud()
		if(H.hud_used)
			H.hud_used.show_hud(H.hud_used.hud_version)
	if(H.l_hand) H.drop_inv_item_on_ground(H.l_hand, FALSE, TRUE)
	if(H.r_hand) H.drop_inv_item_on_ground(H.r_hand, FALSE, TRUE)
	if(H.wear_id) qdel(H.wear_id)
	if(H.gloves) qdel(H.gloves)
	if(H.head) qdel(H.head)
	if(H.glasses) qdel(H.glasses)
	if(H.wear_mask) qdel(H.wear_mask)
	var/obj/item/weapon/zombie_claws/ZC = new()
	ZC.icon_state = "claw_r"
	H.equip_to_slot_or_del(ZC, WEAR_R_HAND, TRUE)
	H.equip_to_slot_or_del(new /obj/item/weapon/zombie_claws, WEAR_L_HAND, TRUE)
	H.equip_to_slot(new /obj/item/clothing/glasses/zombie_eyes, WEAR_EYES, TRUE)
	H.equip_to_slot(new /obj/item/clothing/mask/rebreather/scarf/zombie, WEAR_FACE, TRUE)
	return ..()



/datum/species/zombie/handle_unique_behavior(var/mob/living/carbon/human/H)
	if(prob(5))
		playsound(H.loc, 'sound/voice/alien_talk3.ogg', 25, 1)
	else if(prob(5))
		playsound(H.loc, 'sound/hallucinations/far_noise.ogg', 15, 1)
	else if(prob(5))
		playsound(H.loc, 'sound/hallucinations/veryfar_noise.ogg', 15, 1)

/datum/species/zombie/handle_death(var/mob/living/carbon/human/H, gibbed)
	set waitfor = 0
	if(gibbed) return
	if(!H.regenZ) return  //Also in each check, in case they are hit with the stuff to stop the regenerating during timers.
	sleep(5)
	if(H && H.loc && H.stat == DEAD && H.regenZ)
		to_chat(H, "<span class='xenowarning'> You fall... but your body is slowly regenerating itself.</span>")
	sleep(1200)
	if(H && H.loc && H.stat == DEAD && H.regenZ)
		to_chat(H, "<span class='xenowarning'> Your body is half regenerated...</span>")
	sleep(1200)

	if(H && H.loc && H.stat == DEAD && H.regenZ)
		H.revive(TRUE)
		H.stunned = 4
		H.make_jittery(500)
		H.visible_message(SPAN_WARNING("[H] rises!"), SPAN_XENOWARNING("YOU RISE AGAIN!"))
		H.equip_to_slot(new /obj/item/clothing/glasses/zombie_eyes, WEAR_EYES, TRUE)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine, WEAR_FEET, TRUE)

		spawn(30)
			H.jitteriness = 0


/datum/hud_data/zombie
	has_a_intent = 1
	has_m_intent = 1
	has_warnings = 1
	has_pressure = 1
	has_nutrition = 0
	has_bodytemp = 1
	has_hands = 1
	has_drop = 0
	has_throw = 0
	has_resist = 1
	has_internals = 0
	gear = list()


/datum/species/synthetic/handle_post_spawn(mob/living/carbon/human/H)
	H.set_languages(list("English", "Russian", "Tradeband", "Sainja", "Xenomorph"))
	living_human_list -= H
	return ..()


/datum/species/yautja
	name = "Yautja"
	name_plural = "Yautja"
	icobase = 'icons/mob/human_races/r_predator.dmi'
	deform = 'icons/mob/human_races/r_predator.dmi'
	brute_mod = 0.33 //Beefy!
	burn_mod = 0.65
	reagent_tag = IS_YAUTJA
	flags = IS_WHITELISTED|HAS_SKIN_COLOR|NO_PAIN|NO_SCAN|NO_POISON //Hmm, let's see if this does anything
	unarmed_type = /datum/unarmed_attack/punch/strong
	secondary_unarmed_type = /datum/unarmed_attack/bite/strong
	blood_color = "#20d450"
	flesh_color = "#907E4A"
	speech_sounds = list('sound/voice/pred_click1.ogg', 'sound/voice/pred_click2.ogg')
	speech_chance = 100
	hud_type = /datum/hud_data/yautja
	death_message = "clicks in agony and falls still, motionless and completely lifeless..."
	darksight = 5
	slowdown = -0.5

	heat_level_1 = 500
	heat_level_2 = 700
	heat_level_3 = 1000

	inherent_verbs = list(
		/mob/living/carbon/human/proc/pred_buy,
		/mob/living/carbon/human/proc/butcher
		)

	knock_down_reduction = 2
	stun_reduction = 2

		//Set their special slot priority

	slot_equipment_priority= list( \
		WEAR_BACK,\
		WEAR_ID,\
		WEAR_BODY,\
		WEAR_JACKET,\
		WEAR_HEAD,\
		WEAR_FEET,\
		WEAR_IN_SHOES,\
		WEAR_FACE,\
		WEAR_HANDS,\
		WEAR_EAR,\
		WEAR_EYES,\
		WEAR_IN_SCABBARD,\
		WEAR_WAIST,\
		WEAR_IN_J_STORE,\
		WEAR_IN_L_STORE,\
		WEAR_IN_R_STORE,\
		WEAR_J_STORE,\
		WEAR_IN_ACCESSORY,\
		WEAR_IN_JACKET,\
		WEAR_L_STORE,\
		WEAR_R_STORE,\
		WEAR_IN_BELT,\
		WEAR_IN_BACK\
	)

/datum/species/yautja/handle_death(var/mob/living/carbon/human/H, gibbed)
	if(gibbed)
		yautja_mob_list -= H

/datum/species/yautja/post_species_loss(mob/living/carbon/human/H)
	var/datum/mob_hud/medical/advanced/A = huds[MOB_HUD_MEDICAL_ADVANCED]
	A.add_to_hud(H)
	H.blood_type = pick("A+","A-","B+","B-","O-","O+","AB+","AB-")
	yautja_mob_list -= src
	for(var/datum/limb/L in H.limbs)
		switch(L.name)
			if("groin","chest")
				L.min_broken_damage = 40
				L.max_damage = 200
			if("head")
				L.min_broken_damage = 40
				L.max_damage = 60
			if("l_hand","r_hand","r_foot","l_foot")
				L.min_broken_damage = 25
				L.max_damage = 30
			if("r_leg","r_arm","l_leg","l_arm")
				L.min_broken_damage = 30
				L.max_damage = 35
		L.time_to_knit = -1

/datum/species/yautja/handle_post_spawn(var/mob/living/carbon/human/H)

	//Spawn them some equipment
	H.equip_to_slot_or_del(new /obj/item/clothing/under/chainshirt(H), WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yautja(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/yautja(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/weapon/yautja_knife(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/yautja_teleporter(H),WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/backpack/yautja(H), WEAR_BACK)

	living_human_list -= H
	H.universal_understand = 1

	H.blood_type = "Y*"
	yautja_mob_list += src
	for(var/datum/limb/L in H.limbs)
		switch(L.name)
			if("groin","chest")
				L.min_broken_damage = 80
				L.max_damage = 200
				L.time_to_knit = 1200 // 10 mins
			if("head")
				L.min_broken_damage = 70
				L.max_damage = 90
				L.time_to_knit = 1200 // 10 mins
			if("l_hand","r_hand","r_foot","l_foot")
				L.min_broken_damage = 40
				L.max_damage = 60
				L.time_to_knit = 600 // 5 mins
			if("r_leg","r_arm","l_leg","l_arm")
				L.min_broken_damage = 60
				L.max_damage = 80
				L.time_to_knit = 600 // 5 mins


	var/datum/mob_hud/medical/advanced/A = huds[MOB_HUD_MEDICAL_ADVANCED]
	A.remove_from_hud(H)
	H.set_languages(list("Sainja"))

	return ..()

// Called when using the shredding behavior.
/datum/species/proc/can_shred(var/mob/living/carbon/human/H)

	if(H.a_intent != "hurt")
		return 0

	if(unarmed.is_usable(H))
		if(unarmed.shredding)
			return 1
	else if(secondary_unarmed.is_usable(H))
		if(secondary_unarmed.shredding)
			return 1

	return 0

//Species unarmed attacks
/datum/unarmed_attack
	var/attack_verb = list("attack")	// Empty hand hurt intent verb.
	var/damage = 0						// Extra empty hand attack damage.
	var/attack_sound = "punch"
	var/miss_sound = 'sound/weapons/punchmiss.ogg'
	var/shredding = 0 // Calls the old attack_alien() behavior on objects/mobs when on harm intent.
	var/sharp = 0
	var/edge = 0

/datum/unarmed_attack/proc/is_usable(var/mob/living/carbon/human/user)
	if(user.is_mob_restrained())
		return 0

	// Check if they have a functioning hand.
	var/datum/limb/E = user.get_limb("l_hand")
	if(E && !(E.status & LIMB_DESTROYED))
		return 1

	E = user.get_limb("r_hand")
	if(E && !(E.status & LIMB_DESTROYED))
		return 1

	return 0

/datum/unarmed_attack/bite
	attack_verb = list("bite") // 'x has biteed y', needs work.
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = 0
	damage = 5
	sharp = 1
	edge = 1

/datum/unarmed_attack/bite/is_usable(var/mob/living/carbon/human/user)
	if (user.wear_mask && istype(user.wear_mask, /obj/item/clothing/mask/muzzle))
		return 0
	return 1

/datum/unarmed_attack/punch
	attack_verb = list("punch")
	damage = 3

/datum/unarmed_attack/punch/strong
	attack_verb = list("punch","bust","jab")
	damage = 10

/datum/unarmed_attack/claws
	attack_verb = list("scratch", "claw")
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	damage = 5
	sharp = 1
	edge = 1

/datum/unarmed_attack/claws/strong
	attack_verb = list("slash")
	damage = 10
	shredding = 1

/datum/unarmed_attack/bite/strong
	attack_verb = list("maul")
	damage = 15
	shredding = 1

/datum/hud_data
	var/icon              // If set, overrides ui_style.
	var/has_a_intent = 1  // Set to draw intent box.
	var/has_m_intent = 1  // Set to draw move intent box.
	var/has_warnings = 1  // Set to draw environment warnings.
	var/has_pressure = 1  // Draw the pressure indicator.
	var/has_nutrition = 1 // Draw the nutrition indicator.
	var/has_bodytemp = 1  // Draw the bodytemp indicator.
	var/has_hands = 1     // Set to draw shand.
	var/has_drop = 1      // Set to draw drop button.
	var/has_throw = 1     // Set to draw throw button.
	var/has_resist = 1    // Set to draw resist button.
	var/has_internals = 1 // Set to draw the internals toggle button.
	var/is_yautja = 0
	var/list/equip_slots = list() // Checked by mob_can_equip().

	// Contains information on the position and tag for all inventory slots
	// to be drawn for the mob. This is fairly delicate, try to avoid messing with it
	// unless you know exactly what it does.
	var/list/gear = list(
		"i_clothing" =   list("loc" = ui_iclothing, "slot" = WEAR_BODY, "state" = "center", "toggle" = 1, "dir" = SOUTH),
		"o_clothing" =   list("loc" = ui_oclothing, "slot" = WEAR_JACKET, "state" = "equip",  "toggle" = 1,  "dir" = SOUTH),
		"mask" =         list("loc" = ui_mask,      "slot" = WEAR_FACE, "state" = "equip",  "toggle" = 1,  "dir" = NORTH),
		"gloves" =       list("loc" = ui_gloves,    "slot" = WEAR_HANDS,    "state" = "gloves", "toggle" = 1),
		"eyes" =         list("loc" = ui_glasses,   "slot" = WEAR_EYES,   "state" = "glasses","toggle" = 1),
		"wear_ear" =     list("loc" = ui_wear_ear,  "slot" = WEAR_EAR,     "state" = "ears",   "toggle" = 1),
		"head" =         list("loc" = ui_head,      "slot" = WEAR_HEAD,      "state" = "hair",   "toggle" = 1),
		"shoes" =        list("loc" = ui_shoes,     "slot" = WEAR_FEET,     "state" = "shoes",  "toggle" = 1),
		"suit storage" = list("loc" = ui_sstore1,   "slot" = WEAR_J_STORE,   "state" = "belt",   "dir" = 8),
		"back" =         list("loc" = ui_back,      "slot" = WEAR_BACK,      "state" = "back",   "dir" = NORTH),
		"id" =           list("loc" = ui_id,        "slot" = WEAR_ID,   "state" = "id",     "dir" = NORTH),
		"storage1" =     list("loc" = ui_storage1,  "slot" = WEAR_L_STORE,   "state" = "pocket"),
		"storage2" =     list("loc" = ui_storage2,  "slot" = WEAR_R_STORE,   "state" = "pocket"),
		"belt" =         list("loc" = ui_belt,      "slot" = WEAR_WAIST,      "state" = "belt")
		)

/datum/hud_data/New()
	..()
	for(var/slot in gear)
		equip_slots |= gear[slot]["slot"]

	if(has_hands)
		equip_slots |= WEAR_L_HAND
		equip_slots |= WEAR_R_HAND
		equip_slots |= WEAR_HANDCUFFS

	if(WEAR_BACK in equip_slots)
		equip_slots |= WEAR_IN_BACK
		equip_slots |= WEAR_IN_SCABBARD

	equip_slots |= WEAR_LEGCUFFS

	if(WEAR_WAIST in equip_slots)
		equip_slots |= WEAR_IN_BELT

	if(WEAR_J_STORE in equip_slots)
		equip_slots |= WEAR_IN_J_STORE

	if(WEAR_L_STORE in equip_slots)
		equip_slots |= WEAR_IN_L_STORE

	if(WEAR_R_STORE in equip_slots)
		equip_slots |= WEAR_IN_R_STORE

	if(WEAR_BODY in equip_slots)
		equip_slots |= WEAR_ACCESSORY
		equip_slots |= WEAR_IN_ACCESSORY

	if(WEAR_JACKET in equip_slots)
		equip_slots |= WEAR_IN_JACKET

	if(WEAR_FEET in equip_slots)
		equip_slots |= WEAR_IN_SHOES
