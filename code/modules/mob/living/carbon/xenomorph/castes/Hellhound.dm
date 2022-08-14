/datum/caste_datum/hellhound
	caste_type = XENO_CASTE_HELLHOUND
	caste_desc = "A fast, four-legged terror, but weak in sustained combat."
	tier = 0
	melee_damage_lower = XENO_DAMAGE_TIER_3
	melee_damage_upper = XENO_DAMAGE_TIER_4
	plasma_gain = XENO_PLASMA_GAIN_TIER_4
	plasma_max = XENO_NO_PLASMA
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_4
	armor_deflection = XENO_ARMOR_TIER_3
	max_health = XENO_HEALTH_TIER_7
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_HELLHOUND
	attack_delay = -2

	tackle_min = 4
	tackle_max = 5
	tackle_chance = 40
	tacklestrength_min = 4
	tacklestrength_max = 4

	heal_resting = 2.5
	heal_standing = 1.25
	heal_knocked_out = 1.25
	innate_healing = TRUE

/mob/living/carbon/Xenomorph/Hellhound
	caste_type = XENO_CASTE_HELLHOUND
	name = XENO_CASTE_HELLHOUND
	desc = "A disgusting beast from hell, it has four menacing spikes growing from its head."
	icon = 'icons/mob/hostiles/hellhound.dmi'
	icon_state = "Hellhound Walking"
	icon_size = 32
	layer = MOB_LAYER
	plasma_types = list(PLASMA_CHITIN)
	tier = 0
	acid_blood_damage = 0
	pull_speed = -0.5
	viewsize = 9

	speaking_key = "h"
	speaking_noise = "hiss_talk"
	langchat_color = "#9c7463"

	slash_verb = "rend"
	slashes_verb = "rends"
	slash_sound = 'sound/weapons/bite.ogg'

	mob_size = MOB_SIZE_XENO_SMALL

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/onclick/xenohide,
		/datum/action/xeno_action/activable/pounce/runner,
		/datum/action/xeno_action/onclick/toggle_long_range/runner
	)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
	)
	mutation_type = HELLHOUND_NORMAL

	icon_xeno = 'icons/mob/hostiles/hellhound.dmi'
	icon_xenonid = 'icons/mob/hostiles/hellhound.dmi'

/mob/living/carbon/Xenomorph/Hellhound/Initialize(mapload, mob/living/carbon/Xenomorph/oldXeno, h_number)
	. = ..(mapload, oldXeno, h_number || XENO_HIVE_YAUTJA)

	set_languages(list(LANGUAGE_HELLHOUND, LANGUAGE_YAUTJA))

	GLOB.living_xeno_list -= src
	GLOB.xeno_mob_list -= src
	SSmob.living_misc_mobs += src
	GLOB.hellhound_list += src

/mob/living/carbon/Xenomorph/Hellhound/prepare_huds()
	..()
	var/image/health_holder = hud_list[HEALTH_HUD_XENO]
	health_holder.pixel_x = -12
	var/image/status_holder = hud_list[XENO_STATUS_HUD]
	status_holder.pixel_x = -10
	var/image/banished_holder = hud_list[XENO_BANISHED_HUD]
	banished_holder.pixel_x = -12
	banished_holder.pixel_y = -6

/mob/living/carbon/Xenomorph/Hellhound/emote(var/act,var/m_type=1,var/message = null, player_caused)
	if(findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		act = copytext(act, 1, t1)

	if(findtext(act, "s", -1) && !findtext(act, "_", -2))
		act = copytext(act, 1, length(act))

	if(stat)
		return

	switch(act)
		if("me")
			return
		if("custom")
			return
		if("scratch")
			if (!src.is_mob_restrained())
				message = "<B>The [src.name]</B> scratches."
				m_type = 1
		if("roar")
			message = "<B>The [src.name] roars!</b>"
			m_type = 2
			playsound(src.loc, 'sound/voice/ed209_20sec.ogg', 25, 1)
		if("tail")
			message = "<B>The [src.name]</B> waves its tail."
			m_type = 1
		if("paw")
			if (!src.is_mob_restrained())
				message = "<B>The [src.name]</B> flails its paw."
				m_type = 1
		if("sway")
			message = "<B>The [src.name]</B> sways around dizzily."
			m_type = 1
		if("snore")
			message = "<B>The [src.name]</B> snores."
			m_type = 1
		if("whimper")
			message = "<B>The [src.name]</B> whimpers."
			m_type = 1
		if("grunt")
			message = "<B>The [src.name]</B> grunts."
			m_type = 1
		if("rumble")
			message = "<B>The [src.name]</B> rumbles deeply."
			m_type = 1
		if("howl")
			message = "<B>The [src.name]</B> howls!"
			m_type = 1
		if("growl")
			message = "<B>The [src.name]</B> emits a strange, menacing growl."
			m_type = 1
		if("stare")
			message = "<B>The [src.name]</B> stares."
			m_type = 1
		if("sniff")
			message = "<B>The [src.name]</B> sniffs about."
			m_type = 1
		if("help")
			to_chat(src, "<br><br><b>To use an emote, type an asterix (*) before a following word. Emotes with a sound are <span style='color: green;'>green</span>. Spamming emotes with sound will likely get you banned. Don't do it.<br><br>\
			scratch, \
			<span style='color: green;'>roar</span>, \
			tail, \
			paw, \
			sway, \
			snow, \
			whimper, \
			grunt, \
			rumble, \
			howl, \
			growl, \
			stare, \
			sniff \
			</b><br>")
			return
		else
			to_chat(src, "Invalid Emote: [act]")
			return
	if(message)
		if(src.client)
			log_emote("[name]/[key] : [message]")
		if(m_type & 1)
			for(var/mob/O in viewers(src, null))
				O.show_message(message, m_type)
		else
			for(var/mob/O in hearers(src, null))
				O.show_message(message, m_type)


/mob/living/carbon/Xenomorph/Hellhound/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_FLAGS_CRAWLER

/mob/living/carbon/Xenomorph/Hellhound/Login()
	. = ..()
	if(SSticker.mode) SSticker.mode.xenomorphs -= mind
	to_chat(src, "<span style='font-weight: bold; color: red;'>Attention!! You are playing as a hellhound. You can get server banned if you are shitty so listen up!</span>")
	to_chat(src, "<span style='color: red;'>You MUST listen to and obey the Predator's commands at all times. Die if they demand it. Not following them is unthinkable to a hellhound.</span>")
	to_chat(src, "<span style='color: red;'>You are not here to go hog wild rambo. You're here to be part of something rare, a Predator hunt.</span>")
	to_chat(src, "<span style='color: red;'>The Predator players must follow a strict code of role-play and you are expected to as well.</span>")
	to_chat(src, "<span style='color: red;'>The Predators cannot understand your speech. They can only give you orders and expect you to follow them.</span>")
	to_chat(src, "<span style='color: red;'>Hellhounds are fiercely protective of their masters and will never leave their side if under attack.</span>")
	to_chat(src, "<span style='color: red;'>Note that ANY Predator can give you orders. If they conflict, follow the latest one. If they dislike your performance they can ask for another ghost and everyone will mock you. So do a good job!</span>")

/mob/living/carbon/Xenomorph/Hellhound/death(var/cause, var/gibbed)
	. = ..(cause, gibbed, "lets out a horrible roar as it collapses and stops moving...")
	if(!.)
		return
	emote("roar")
	GLOB.hellhound_list -= src
	SSmob.living_misc_mobs -= src

/mob/living/carbon/Xenomorph/Hellhound/rejuvenate()
	..()
	GLOB.living_xeno_list -= src
	GLOB.hellhound_list |= src
	SSmob.living_misc_mobs |= src

/mob/living/carbon/Xenomorph/Hellhound/Destroy()
	GLOB.hellhound_list -= src
	SSmob.living_misc_mobs -= src
	return ..()

/mob/living/carbon/Xenomorph/Hellhound/handle_blood_splatter(var/splatter_dir)
	new /obj/effect/temp_visual/dir_setting/bloodsplatter/hellhound(loc, splatter_dir)
