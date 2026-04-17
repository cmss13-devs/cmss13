/obj/item/horde_mode
	name = "horde mode item"
	desc = "you should not be seeing this."
	w_class = SIZE_SMALL
	var/throw_away = FALSE

/obj/item/horde_mode/Initialize(mapload, ...)
	. = ..()
	if(throw_away)
		RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(throw_away))

/obj/item/horde_mode/proc/throw_away(mob/user)
	SIGNAL_HANDLER

	if(!throw_away || !isturf(loc))
		return

	UnregisterSignal(src, COMSIG_ITEM_DROPPED)
	to_chat(user, SPAN_NOTICE("You throw away [src]."))
	QDEL_IN(src, 3 SECONDS)
	animate(src, 3 SECONDS, alpha = 0, easing = CUBIC_EASING)


/obj/item/horde_mode/cas_flare
	name = "signal flare"
	desc = "Pull cord, throw and enjoy."
	icon = 'icons/obj/items/lighting.dmi'
	icon_state = "cas_flare"
	item_state = "cas_flare"
	light_color = "#00aa00"
	light_range = 4
	light_power = 2
	var/burning = FALSE
	COOLDOWN_DECLARE(bomb)
	COOLDOWN_DECLARE(sound)

/obj/item/horde_mode/cas_flare/update_icon()
	overlays?.Cut()
	. = ..()
	if(burning)
		set_light(light_range, light_power, light_color)
		icon_state = "[initial(icon_state)]-on"
		var/image/flame = image('icons/obj/items/lighting.dmi', src, "flare_flame")
		flame.color = "#aaccaa"
		flame.appearance_flags = KEEP_APART|RESET_COLOR|RESET_TRANSFORM
		var/image/flame_base = image('icons/obj/items/lighting.dmi', src, "flare_flame")
		flame_base.color = "#00aa00"
		flame_base.appearance_flags = KEEP_APART|RESET_COLOR
		flame_base.blend_mode = BLEND_ADD
		flame.overlays += flame_base
		overlays += flame
	else
		set_light(0)
		icon_state = "[initial(icon_state)]"

/obj/item/horde_mode/cas_flare/attack_self(mob/living/user)
	if(burning)
		to_chat(user, SPAN_WARNING("[src] is already burning!"))
		return

	. = ..()
	user.visible_message(SPAN_NOTICE("[user] activates the flare."), SPAN_NOTICE("You pull the cord on the flare, activating it!"))
	playsound(src,'sound/handling/flare_activate_2.ogg', 50, 1) //cool guy sound
	RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(air_strike))
	burning = TRUE
	update_icon()
	var/mob/living/carbon/U = user
	if(istype(U) && !U.throw_mode)
		U.toggle_throw_mode(THROW_MODE_NORMAL)

/obj/item/horde_mode/cas_flare/proc/air_strike()
	SIGNAL_HANDLER_DOES_SLEEP

	anchored = TRUE
	playsound_z(SSmapping.levels_by_any_trait(ZTRAIT_HORDE_MODE), 'sound/weapons/dropship_sonic_boom.ogg', volume = 75)
	sleep(1 SECONDS)
	playsound_z(SSmapping.levels_by_any_trait(ZTRAIT_HORDE_MODE), 'sound/effects/horde_mode/airstrike.ogg', volume = 75)
	sleep(1 SECONDS)
	var/list/turf_list = list()
	var/datum/cause_data/cause_data = create_cause_data("airstrike")
	for(var/turf/turfs in range(src, 3))
		turf_list += turfs

	for(var/i = 1 to 80)
		sleep(0.1)
		var/turf/impact_tile = pick(turf_list)

		create_shrapnel(impact_tile, 1, 0, 0, /datum/ammo/bullet/shrapnel/gau, cause_data, FALSE, 100) //simulates a bullet

		for(var/atom/movable/explosion_effect in impact_tile)
			if(isanimal(explosion_effect))
				var/mob/living/simple_animal/target = explosion_effect
				target.ex_act(EXPLOSION_THRESHOLD_VLOW, null, cause_data)
				target.apply_damage(500, BRUTE)
			else
				explosion_effect.ex_act(EXPLOSION_THRESHOLD_VLOW)

		new /obj/effect/particle_effect/expl_particles(impact_tile)
		if(COOLDOWN_FINISHED(src, bomb))
			new /obj/effect/particle_effect/expl_particles(impact_tile)
			cell_explosion(impact_tile, 150, 25, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, cause_data)
			COOLDOWN_START(src, bomb, 0.5 SECONDS)
		if(COOLDOWN_FINISHED(src, sound)) //so we don't play the same sound 20 times very fast.
			playsound(impact_tile, 'sound/effects/gauimpact.ogg',40,1,20)
			COOLDOWN_START(src, sound, 0.2 SECONDS)

	sleep(11) //speed of sound simulation
	playsound_z(SSmapping.levels_by_any_trait(ZTRAIT_HORDE_MODE), 'sound/effects/gau.ogg', volume = 75)
	qdel(src)

//STIM BASE
///////////
/obj/item/horde_mode/stim
	name = "stim"
	icon = 'icons/obj/items/syringe.dmi'
	icon_state = "empty_ez"
	var/image/reagent_image
	var/reagent_image_fill = "custom_ez_1"
	var/reagent_color = "#80ff80"

/obj/item/horde_mode/stim/Initialize(mapload, ...)
	. = ..()
	reagent_image = image(icon, icon_state = reagent_image_fill)
	reagent_image.color = reagent_color
	overlays += reagent_image

//INJECTOR STIM BASE
////////////////////
/obj/item/horde_mode/stim/injector
	name = "\improper autoinjector filled with water"
	desc = "An one-use auto-injector loaded with water. <b>Designed to be disposed after use.</b>"
	reagent_color = COLOR_MODERATE_BLUE
	var/inject_desc = "You feel slightly more hydrated?..."

/obj/item/horde_mode/stim/injector/attack_self(mob/user)
	. = ..()
	inject(user, user)

/obj/item/horde_mode/stim/injector/attack(mob/attacked_mob, mob/user)
	. = ..()
	if(attacked_mob == user)
		inject(user, user)
	if(istype(attacked_mob, /mob/living/carbon/human))
		inject(attacked_mob, user)

/obj/item/horde_mode/stim/injector/interact(mob/user)
	. = ..()
	inject(user, user)

/obj/item/horde_mode/stim/injector/proc/inject(mob/living/carbon/human/target, mob/living/user)
	if(throw_away)
		to_chat(user, SPAN_WARNING("[src] is expended!"))
		return

	playsound(loc, 'sound/items/air_release.ogg', 70)
	overlays = null
	if(icon_state == "stimpack")
		icon_state = "stimpack0"
	if(user == target)
		to_chat(user, SPAN_HIGHDANGER("You inject yourself with [src]. [inject_desc]"))
	else
		to_chat(user, SPAN_NOTICE("You inject [target] with [src]."))
		to_chat(target, SPAN_HIGHDANGER("You feel a tiny prick, and [lowertext(inject_desc)]"))
	throw_away = TRUE

//HEALING STIM
//////////////
/obj/item/horde_mode/stim/injector/healing
	name = "\improper disposable hypergenetic autoinjector"
	desc = "An one-use auto-injector loaded with a mix of advanced healing chemicals, used for treating various types of damage extremely rapidly. Doesn't require any training to use. <b>Designed to be disposed after use.</b>"
	reagent_color = COLOR_DARK_RED
	inject_desc = "Your heart immediately starts beating faster."

/obj/item/horde_mode/stim/injector/healing/inject(mob/living/carbon/human/target, mob/living/user)
	if(..())
		return

	target.heal_overall_damage(target.species.total_health * 0.33, target.species.total_health * 0.33)

//SPEED STIM
/////////////
/obj/item/horde_mode/stim/injector/speed
	name = "\improper disposable musclestimulating autoinjector"
	desc = "An one-use auto-injector loaded with fast metabolizing musclestimulating chemicals, used for giving the user a short rush of speed. Doesn't require any training to use. <b>Designed to be disposed after use.</b>"
	reagent_color = COLOR_YELLOW
	inject_desc = "Your legs immediately start burning up."

/obj/item/horde_mode/stim/injector/speed/get_examine_text(mob/user)
	. = ..()
	. += SPAN_BOLDWARNING("WARNING: LETHAL OVERDOSE IS POSSIBLE. DO NOT INJECT MORE THAN ONE DOSE IN A SHORT PERIOD OF TIME.")

/obj/item/horde_mode/stim/injector/speed/inject(mob/living/carbon/human/target, mob/living/user)
	if(..())
		return

	target.reagents.add_reagent("speed_stimulant_fast_metabolism", 15)

//TEMP MAX HEALTH STIM
/////////////
/obj/item/horde_mode/stim/injector/max_health
	name = "\improper disposable cardiopeutic autoinjector"
	desc = "An one-use auto-injector loaded with chemicals that excelerates blood flow, its production and the user's heartrate. This results in the user being able to withstand more punishment for a brief period of time. Doesn't require any training to use. <b>Designed to be disposed after use.</b>"
	reagent_color = COLOR_STRONG_VIOLET
	inject_desc = "Your heart immediately tenses up."

/obj/item/horde_mode/stim/injector/max_health/inject(mob/living/carbon/human/target, mob/living/user)
	if(..())
		return

	//TODO: make callback timer work ehre it odens't wor kit WON'T WORK WHY WON?T IT WORK
	target.species.total_health += 100
	sleep(15 SECONDS)
	target.species.total_health -= 100
	to_chat(user, SPAN_USERDANGER("You feel your heartrate reach its peak!.. then it starts plummeting."))

//PERMA STAT INCREASE
///////////////////////
/obj/item/horde_mode/stim/injector/stat_mod
	name = "\improper stat stim"
	desc = "An experimental stimulant that permanently enhances a user's stat."
	icon_state = "stimpack"
	reagent_image_fill = "+stimpack_custom"
	inject_desc = "Nothing happens."
	var/stat_modifier = 0.05

//PERMA HEALTH INCREASE
///////////////////////
/obj/item/horde_mode/stim/injector/stat_mod/health
	name = "\improper vitality stim"
	desc = "An experimental stimulant that permanently enhances the user's endurance."
	reagent_color = COLOR_DARK_RED
	inject_desc = "Everything starts to feel clearer."
	stat_modifier = 10

/obj/item/horde_mode/stim/injector/stat_mod/health/inject(mob/living/carbon/human/target, mob/living/user)
	if(..())
		return

	target.species.total_health += stat_modifier

//PERMA SPEED INCREASE
///////////////////////
/obj/item/horde_mode/stim/injector/stat_mod/speed
	name = "\improper marathon stim"
	desc = "An experimental stimulant that permanently enhances the user's conditioning."
	reagent_color = COLOR_YELLOW
	inject_desc = "Everything starts to feel lighter."
	stat_modifier = 0.05

/obj/item/horde_mode/stim/injector/stat_mod/speed/inject(mob/living/carbon/human/target, mob/living/user)
	if(..())
		return

	target.extra_move_delay_modifier -= stat_modifier


//CIPHER STIM
/////////////
/obj/item/horde_mode/stim/cipher
	name = "cipher stim"
	desc = "A product of shady and questionable research, this stimulant is designed to be used on xenomorphs. It modifies their genetic makeup and neural pathways in order to make them more accommodating to humans."
	icon = 'icons/obj/items/syringe.dmi'
	icon_state = "stimpack"
	reagent_image_fill = "+stimpack_custom"

/obj/item/horde_mode/stim/cipher/get_examine_text(mob/user)
	. = ..()
	. += SPAN_DANGER("Weaker specimens will not be able to handle the transformation process and will die due to it!")

/obj/item/horde_mode/stim/cipher/attack(mob/living/target, mob/living/user)
	if(throw_away)
		to_chat(user, SPAN_WARNING("[src] is expended!"))
		return

	if(!istype(target, /mob/living/simple_animal/hostile/alien/horde_mode))
		to_chat(user, SPAN_WARNING("That wouldn't work..."))
		return

	if(istype(target, /mob/living/simple_animal/hostile/alien/horde_mode/boss) && target.health > target.maxHealth * 0.5)
		to_chat(user, SPAN_ALERTWARNING("[target] is too strong and rejects [src]! You need to wound them more."))
		return

	to_chat(user, SPAN_ALERTWARNING("You inject [target] with [src]!"))
	var/mob/living/simple_animal/hostile/alien/horde_mode/boss/xeno = target
	playsound(loc, 'sound/items/air_release.ogg', 75)
	overlays = null
	icon_state = "stimpack0"
	name = "expended [name]"
	xeno.turn_corrupt()
	throw_away = TRUE
