/datum/caste_datum/var/pathogen_creature = FALSE
/datum/caste_datum/pathogen
	minimum_evolve_time = 0
	pathogen_creature = TRUE
	language = LANGUAGE_PATHOGEN

/datum/caste_datum/pathogen/get_minimap_icon()
	var/image/background = mutable_appearance('icons/mob/pathogen/neo_blips.dmi', minimap_background)

	var/iconstate = minimap_icon ? minimap_icon : "unknown"
	var/mutable_appearance/icon = image('icons/mob/pathogen/neo_blips.dmi', icon_state = iconstate)
	icon.appearance_flags = RESET_COLOR
	background.overlays += icon

	return background

/datum/admins/var/create_pathogen_creatures_html = null
/datum/admins/proc/create_pathogen_creatures(mob/user)
	if(!create_xenos_html)
		var/hive_types = XENO_HIVE_PATHOGEN
		var/xeno_types = jointext(ALL_PATHOGEN_CREATURES, ";")
		create_pathogen_creatures_html = file2text('html/create_xenos.html')
		create_pathogen_creatures_html = replacetext(create_pathogen_creatures_html, "null /* hive paths */", "\"[hive_types]\"")
		create_pathogen_creatures_html = replacetext(create_pathogen_creatures_html, "null /* xeno paths */", "\"[xeno_types]\"")
		create_pathogen_creatures_html = replacetext(create_pathogen_creatures_html, "/* href token */", RawHrefToken(forceGlobal = TRUE))

	show_browser(user, replacetext(create_pathogen_creatures_html, "/* ref src */", "\ref[src]"), "Create Pathogen Creatures", "create_pathogen_creatures", width = 450, height = 630)

/client/proc/create_pathogen_creatures()
	set name = "Create Pathogen Creatures"
	set category = "Admin.Events"
	if(admin_holder)
		admin_holder.create_pathogen_creatures(usr)


/// WEEDS
/obj/effect/alien/weeds/node/pathogen
	name = "mycelium blight node"
	desc = "A weird, pulsating node."
	icon = 'icons/mob/pathogen/pathogen_weeds.dmi'
	hivenumber = XENO_HIVE_PATHOGEN

/obj/effect/alien/weeds/pathogen
	name = "mycelium blight"
	desc = "A mycelium growth of strange origins..."
	icon = 'icons/mob/pathogen/pathogen_weeds.dmi'
	hivenumber = XENO_HIVE_PATHOGEN

/obj/effect/alien/weeds/weedwall/pathogen
	name = "mycelium blight"
	desc = "A mycelium growth of strange origins..."
	icon = 'icons/mob/pathogen/pathogen_weeds.dmi'
	hivenumber = XENO_HIVE_PATHOGEN

/obj/effect/alien/weeds/weedwall/window/pathogen
	name = "mycelium blight"
	desc = "A mycelium growth of strange origins..."
	icon = 'icons/mob/pathogen/pathogen_weeds.dmi'
	hivenumber = XENO_HIVE_PATHOGEN

/obj/effect/alien/weeds/weedwall/frame/pathogen
	name = "mycelium blight"
	desc = "A mycelium growth of strange origins..."
	icon = 'icons/mob/pathogen/pathogen_weeds.dmi'
	hivenumber = XENO_HIVE_PATHOGEN

/datum/action/xeno_action/onclick/plant_weeds/pathogen
	name = "Spread Blight (200)"
	action_icon_state = "plant_weeds"
	plasma_cost = 200
	macro_path = /datum/action/xeno_action/verb/verb_plant_weeds
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 1 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_1

	plant_on_semiweedable = TRUE
	node_type = /obj/effect/alien/weeds/node/pathogen

/datum/action/xeno_action/onclick/plant_weeds/pathogen/popper
	name = "Spread Blight (100)"
	plasma_cost = 100

// LANGUAGE SHIT
/mob/living/carbon/xenomorph/proc/make_pathogen_speaker()
	set_languages(list(LANGUAGE_PATHOGEN, LANGUAGE_PATHOGEN_MIND, LANGUAGE_XENOMORPH))
	langchat_color = "#c2c38d"
	speaking_key = "-"

/datum/language/pathogen
	name = LANGUAGE_PATHOGEN
	color = "pathogen"
	desc = "The common tongue of the Pathogen Confluence."
	speech_verb = "clicks"
	ask_verb = "clicks"
	exclaim_verb = "clicks"
	key = "-"
	flags = RESTRICTED
	syllables = list("sss", "sSs", "SSS")

/datum/language/pathogen_mind
	name = LANGUAGE_PATHOGEN_MIND
	desc = "Pathogen Creatures have the strange ability to commune over a mycelial hivemind."
	speech_verb = "hiveminds"
	ask_verb = "hiveminds"
	exclaim_verb = "hiveminds"
	color = "pathogen"
	key = "q"//Same key as xeno hivemind because it does the same backend, it only appears different for language menu.
	flags = RESTRICTED|HIVEMIND

//Make queens BOLD text
/datum/language/pathogen_mind/broadcast(mob/living/speaker, message, speaker_mask)
	if(iscarbon(speaker))
		var/mob/living/carbon/C = speaker

		if(!(C.hivenumber in GLOB.hive_datum))
			return

		C.hivemind_broadcast(message, GLOB.hive_datum[C.hivenumber])



/datum/behavior_delegate/pathogen_base
	name = "Base Pathogen Behavior Delegate"

	// State
	var/next_slash_buffed = FALSE

#define BLIGHT_TOUCH_DELAY 4 SECONDS

/datum/behavior_delegate/pathogen_base/venator/melee_attack_modify_damage(original_damage, mob/living/carbon/carbon_target)
	if (!next_slash_buffed)
		return original_damage

	if (!isxeno_human(carbon_target))
		return original_damage

	if(skillcheck(carbon_target, SKILL_ENDURANCE, SKILL_ENDURANCE_MAX ))
		carbon_target.visible_message(SPAN_DANGER("[carbon_target] withstands the blight!"))
		next_slash_buffed = FALSE
		return original_damage //endurance 5 makes you immune to weak blight
	if(ishuman(carbon_target))
		var/mob/living/carbon/human/human = carbon_target
		if(human.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO || human.species.flags & NO_NEURO)
			human.visible_message(SPAN_DANGER("[human] shrugs off the blight!"))
			next_slash_buffed = FALSE
			return //species like zombies or synths are immune to blight
	if (next_slash_buffed)
		to_chat(bound_xeno, SPAN_XENOHIGHDANGER("We add blight into our attack, [carbon_target] is about to fall over paralyzed!"))
		to_chat(carbon_target, SPAN_XENOHIGHDANGER("You feel like you're about to fall over, as [bound_xeno] slashes you with its blight coated claws!"))
		carbon_target.sway_jitter(times = 3, steps = floor(BLIGHT_TOUCH_DELAY/3))
		carbon_target.apply_effect(6, DAZE)
		addtimer(CALLBACK(src, PROC_REF(blight_slash), carbon_target), BLIGHT_TOUCH_DELAY)
		next_slash_buffed = FALSE
	if(!next_slash_buffed)
		var/datum/action/xeno_action/onclick/blight_slash/ability = get_action(bound_xeno, /datum/action/xeno_action/onclick/blight_slash)
		if (ability && istype(ability))
			ability.button.icon_state = "template"
	return original_damage

#undef BLIGHT_TOUCH_DELAY

/datum/behavior_delegate/pathogen_base/override_intent(mob/living/carbon/target_carbon)
	. = ..()

	if(!isxeno_human(target_carbon))
		return

	if(next_slash_buffed)
		return INTENT_HARM

/datum/behavior_delegate/pathogen_base/proc/blight_slash(mob/living/carbon/human/human_target)
	human_target.KnockDown(2)
	human_target.Stun(2)
	to_chat(human_target, SPAN_XENOHIGHDANGER("You fall over, paralyzed by the blight!"))

/datum/action/xeno_action/verb/verb_blight_slash()
	set category = "Alien"
	set name = "Blight Slash"
	set hidden = TRUE
	var/action_name = "Blight Slash"
	handle_xeno_macro(src,action_name)

// Blight slash
/datum/action/xeno_action/onclick/blight_slash
	name = "Blight Slash"
	action_icon_state = "lurker_inject_neuro"
	macro_path = /datum/action/xeno_action/verb/verb_blight_slash
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_NOT_PRIMARY_ACTION
	xeno_cooldown = 12 SECONDS
	plasma_cost = 50

	var/buff_duration = 50

/datum/action/xeno_action/onclick/blight_slash/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/paraslash_user = owner

	if (!istype(paraslash_user))
		return

	if (!action_cooldown_check())
		return

	if (!check_and_use_plasma_owner())
		return

	var/datum/behavior_delegate/pathogen_base/behavior = paraslash_user.behavior_delegate
	if (istype(behavior))
		behavior.next_slash_buffed = TRUE

	to_chat(paraslash_user, SPAN_XENOHIGHDANGER("Our next slash will apply blight!"))
	button.icon_state = "template_active"

	addtimer(CALLBACK(src, PROC_REF(unbuff_slash)), buff_duration)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/blight_slash/proc/unbuff_slash()
	var/mob/living/carbon/xenomorph/unbuffslash_user = owner
	if (!istype(unbuffslash_user))
		return
	var/datum/behavior_delegate/pathogen_base/behavior = unbuffslash_user.behavior_delegate
	if (istype(behavior))
		// In case slash has already landed
		if (!behavior.next_slash_buffed)
			return
		behavior.next_slash_buffed = FALSE

	to_chat(unbuffslash_user, SPAN_XENODANGER("We have waited too long, our slash will no longer apply blight!"))
	button.icon_state = "template"
