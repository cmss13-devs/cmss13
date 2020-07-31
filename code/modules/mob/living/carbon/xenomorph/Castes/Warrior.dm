/datum/caste_datum/warrior
	caste_name = "Warrior"
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_4
	melee_damage_upper = XENO_DAMAGE_TIER_6
	max_health = XENO_HEALTH_TIER_5
	plasma_gain = XENO_PLASMA_GAIN_TIER_9
	plasma_max = XENO_PLASMA_TIER_1
	xeno_explosion_resistance = XENO_HEAVY_EXPLOSIVE_ARMOR
	armor_deflection = XENO_ARMOR_TIER_1 + XENO_ARMOR_MOD_VERYSMALL
	armor_hardiness_mult = XENO_ARMOR_FACTOR_VERYHIGH
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_TIER_7

	behavior_delegate_type = /datum/behavior_delegate/warrior_base

	evolves_to = list("Praetorian", "Crusher")
	deevolves_to = "Defender"
	caste_desc = "A powerful front line combatant."
	can_vent_crawl = 0

	tackle_min = 2
	tackle_max = 4
	
	agility_speed_increase = -0.9

/mob/living/carbon/Xenomorph/Warrior
	caste_name = "Warrior"
	name = "Warrior"
	desc = "A beefy, alien with an armored carapace."
	icon = 'icons/mob/xenos/warrior.dmi'
	icon_size = 64
	icon_state = "Warrior Walking"
	plasma_types = list(PLASMA_CATECHOLAMINE)
	pixel_x = -16
	old_x = -16
	tier = 2
	pull_speed = 2.0 // about what it was before, slightly faster

	actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/lunge,
		/datum/action/xeno_action/activable/warrior_punch,
		/datum/action/xeno_action/activable/fling
	)
	
	mutation_type = WARRIOR_NORMAL
	claw_type = CLAW_TYPE_SHARP

/mob/living/carbon/Xenomorph/Warrior/update_icons()
	if (stat == DEAD)
		icon_state = "[mutation_type] Warrior Dead"
	else if (lying)
		if ((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "[mutation_type] Warrior Sleeping"
		else
			icon_state = "[mutation_type] Warrior Knocked Down"
	else if (agility)
		icon_state = "[mutation_type] Warrior Agility"
	else
		icon_state = "[mutation_type] Warrior Running"

	update_fire() //the fire overlay depends on the xeno's stance, so we must update it.

/mob/living/carbon/Xenomorph/Warrior/throw_item(atom/target)
	toggle_throw_mode(THROW_MODE_OFF)


/mob/living/carbon/Xenomorph/Warrior/stop_pulling()
	if(isliving(pulling))
		var/mob/living/L = pulling
		L.SetStunned(0)
		L.SetKnockeddown(0)
	..()


/mob/living/carbon/Xenomorph/Warrior/start_pulling(atom/movable/AM, lunge)
	if (!check_state() || agility)
		return FALSE

	if(!isliving(AM))
		return FALSE
	var/mob/living/L = AM
	var/should_neckgrab = (isHumanStrict(L) || (isXeno(L) && !match_hivemind(L))) && lunge

	if(!isnull(L) && !isnull(L.pulledby) && L != src ) //override pull of other mobs
		visible_message(SPAN_WARNING("[src] has broken [L.pulledby]'s grip on [L]!"), null, null, 5)
		L.pulledby.stop_pulling()
		return // Warrior should not-regrab the victim to reset the knockdown

	. = ..(L, lunge, should_neckgrab)

	if(.) //successful pull
		if(should_neckgrab && L.mob_size < MOB_SIZE_BIG)
			L.drop_held_items()
			L.KnockDown(get_xeno_stun_duration(L, 2))
			L.pulledby = src
			visible_message(SPAN_XENOWARNING("\The [src] grabs [L] by the throat!"), \
			SPAN_XENOWARNING("You grab [L] by the throat!"))

/mob/living/carbon/Xenomorph/Warrior/hitby(atom/movable/AM)
	if(ishuman(AM))
		return
	..()

/datum/behavior_delegate/warrior_base
	name = "Base Warrior Behavior Delegate"
	
	var/stored_shield_max = 160
	var/stored_shield_per_slash = 40
	var/stored_shield = 0

/datum/behavior_delegate/warrior_base/melee_attack_additional_effects_self()
	if (stored_shield == stored_shield_max)
		bound_xeno.add_xeno_shield(stored_shield, XENO_SHIELD_SOURCE_GENERIC)
		to_chat(bound_xeno, SPAN_XENOHIGHDANGER("You feel your rage increase your resiliency to damage!"))
		stored_shield = 0
	else
		stored_shield += stored_shield_per_slash

/datum/behavior_delegate/warrior_base/append_to_stat()
	stat("Stored Shield", "[stored_shield]/[stored_shield_max]")

/datum/behavior_delegate/boxer
	name = "Boxer Warrior Behavior Delegate"

	var/ko_delay = SECONDS_5
	var/max_clear_head = 3
	var/clear_head_delay = SECONDS_15
	var/clear_head = 3
	var/next_clear_head_regen
	var/clear_head_tickcancel

	var/mob/punching_bag
	var/ko_counter = 0
	var/ko_reset_timer
	var/max_ko_counter = 15

	var/image/ko_icon
	var/image/big_ko_icon

/datum/behavior_delegate/boxer/append_to_stat()
	if(punching_bag)
		stat("Beating", "[punching_bag] - [ko_counter] hits")
	stat("Clarity", "[clear_head] hits")

/datum/behavior_delegate/boxer/on_life()
	var/wt = world.time
	if(wt > next_clear_head_regen && clear_head<max_clear_head)
		clear_head++
		next_clear_head_regen = wt + clear_head_delay

/datum/behavior_delegate/boxer/melee_attack_additional_effects_target(atom/A, ko_boost = 0.5)
	if(!ismob(A))
		return
	if(punching_bag != A)
		remove_ko()
		punching_bag = A
		ko_icon = image(null, A)
		ko_icon.alpha = 196
		ko_icon.maptext_width = 16
		ko_icon.maptext_x = 16
		ko_icon.maptext_y = 16
		ko_icon.layer = 20
		if(bound_xeno.client && bound_xeno.client.prefs && !bound_xeno.client.prefs.lang_chat_disabled)
			bound_xeno.client.images += ko_icon
	
	ko_counter += ko_boost
	if(ko_counter > max_ko_counter)
		ko_counter = max_ko_counter
	var/to_display = round(ko_counter)
	ko_icon.maptext = "<span class='center langchat'>[to_display]</span>"
	
	ko_reset_timer = add_timer(CALLBACK(src, .proc/remove_ko), ko_delay, TIMER_UNIQUE|TIMER_OVERRIDE_UNIQUE|TIMER_NO_WAIT_UNIQUE|TIMER_STOPPABLE)

/datum/behavior_delegate/boxer/proc/remove_ko()
	punching_bag = null
	ko_counter = 0
	if(bound_xeno.client && ko_icon)
		bound_xeno.client.images -= ko_icon
	if(ko_icon)
		qdel(ko_icon)
		ko_icon = null

/datum/behavior_delegate/boxer/proc/display_ko_message(var/mob/H)
	if(!bound_xeno.client)
		return
	if(!bound_xeno.client.prefs || bound_xeno.client.prefs.lang_chat_disabled)
		return
	big_ko_icon = image(null, H)
	big_ko_icon.alpha = 196
	big_ko_icon.maptext_y = H.langchat_height
	big_ko_icon.maptext_width = LANGCHAT_WIDTH
	big_ko_icon.maptext_height = 64
	big_ko_icon.color = "#FF0000"
	big_ko_icon.maptext_x = LANGCHAT_X_OFFSET
	big_ko_icon.maptext = "<span class='center langchat langchat_bolditalicbig'>KO!</span>"
	bound_xeno.client.images += big_ko_icon
	add_timer(CALLBACK(src, .proc/remove_big_ko), SECONDS_2)

/datum/behavior_delegate/boxer/proc/remove_big_ko()
	if(bound_xeno.client && big_ko_icon)
		bound_xeno.client.images -= big_ko_icon
	if(big_ko_icon)
		qdel(big_ko_icon)
		big_ko_icon = null

// a lot of repeats but it's because we are calling different parent procs
/mob/living/carbon/Xenomorph/Warrior/Daze(amount)
	var/datum/behavior_delegate/boxer/BD = behavior_delegate
	if(mutation_type != WARRIOR_BOXER || !istype(BD) || BD.clear_head <= 0)
		..(amount)
		return
	if(BD.clear_head_tickcancel == world.time)
		return
	BD.clear_head_tickcancel = world.time
	BD.clear_head--
	if(BD.clear_head<=0)
		BD.clear_head = 0

/mob/living/carbon/Xenomorph/Warrior/SetDazed(amount)
	var/datum/behavior_delegate/boxer/BD = behavior_delegate
	if(mutation_type != WARRIOR_BOXER || !istype(BD) || BD.clear_head <= 0)
		..(amount)
		return
	if(BD.clear_head_tickcancel == world.time)
		return
	BD.clear_head_tickcancel = world.time
	BD.clear_head--
	if(BD.clear_head<=0)
		BD.clear_head = 0

/mob/living/carbon/Xenomorph/Warrior/AdjustDazed(amount)
	var/datum/behavior_delegate/boxer/BD = behavior_delegate
	if(mutation_type != WARRIOR_BOXER || !istype(BD) || BD.clear_head <= 0)
		..(amount)
		return
	if(BD.clear_head_tickcancel == world.time)
		return
	BD.clear_head_tickcancel = world.time
	BD.clear_head--
	if(BD.clear_head<=0)
		BD.clear_head = 0

/mob/living/carbon/Xenomorph/Warrior/KnockDown(amount, forced)
	var/datum/behavior_delegate/boxer/BD = behavior_delegate
	if(forced || mutation_type != WARRIOR_BOXER || !istype(BD) || BD.clear_head <= 0)
		..(amount, forced)
		return
	if(BD.clear_head_tickcancel == world.time)
		return
	BD.clear_head_tickcancel = world.time
	BD.clear_head--
	if(BD.clear_head<=0)
		BD.clear_head = 0

/mob/living/carbon/Xenomorph/Warrior/SetKnockeddown(amount)
	var/datum/behavior_delegate/boxer/BD = behavior_delegate
	if(mutation_type != WARRIOR_BOXER || !istype(BD) || BD.clear_head <= 0)
		..(amount)
		return
	if(BD.clear_head_tickcancel == world.time)
		return
	BD.clear_head_tickcancel = world.time
	BD.clear_head--
	if(BD.clear_head<=0)
		BD.clear_head = 0

/mob/living/carbon/Xenomorph/Warrior/AdjustKnockeddown(amount)
	var/datum/behavior_delegate/boxer/BD = behavior_delegate
	if(mutation_type != WARRIOR_BOXER || !istype(BD) || BD.clear_head <= 0)
		..(amount)
		return
	if(BD.clear_head_tickcancel == world.time)
		return
	BD.clear_head_tickcancel = world.time
	BD.clear_head--
	if(BD.clear_head<=0)
		BD.clear_head = 0

/mob/living/carbon/Xenomorph/Warrior/Stun(amount)
	var/datum/behavior_delegate/boxer/BD = behavior_delegate
	if(mutation_type != WARRIOR_BOXER || !istype(BD) || BD.clear_head <= 0)
		..(amount)
		return
	if(BD.clear_head_tickcancel == world.time)
		return
	BD.clear_head_tickcancel = world.time
	BD.clear_head--
	if(BD.clear_head<=0)
		BD.clear_head = 0

/mob/living/carbon/Xenomorph/Warrior/SetStunned(amount) //if you REALLY need to set stun to a set amount without the whole "can't go below current stunned"
	var/datum/behavior_delegate/boxer/BD = behavior_delegate
	if(mutation_type != WARRIOR_BOXER || !istype(BD) || BD.clear_head <= 0)
		..(amount)
		return
	if(BD.clear_head_tickcancel == world.time)
		return
	BD.clear_head_tickcancel = world.time
	BD.clear_head--
	if(BD.clear_head<=0)
		BD.clear_head = 0

/mob/living/carbon/Xenomorph/Warrior/AdjustStunned(amount)
	var/datum/behavior_delegate/boxer/BD = behavior_delegate
	if(mutation_type != WARRIOR_BOXER || !istype(BD) || BD.clear_head <= 0)
		..(amount)
		return
	if(BD.clear_head_tickcancel == world.time)
		return
	BD.clear_head_tickcancel = world.time
	BD.clear_head--
	if(BD.clear_head<=0)
		BD.clear_head = 0
