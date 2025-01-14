/datum/xeno_strain/boxer
	name = WARRIOR_BOXER
	description = "In exchange for your ability to fling and shield yourself with slashes, you gain KO meter and the ability to resist stuns. Your punches will reset the cooldown of your Jab. Jab lets you close in and confuse your opponents while resetting Punch cooldown. Your slashes and abilities build up KO meter that later lets you deal damage, knockback, heal, and restore your stun resistance depending on how much KO meter you gained with a titanic Uppercut strike."
	flavor_description = "You will play box around."
	icon_state_prefix = "Boxer"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/fling,
		/datum/action/xeno_action/activable/lunge,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/jab,
		/datum/action/xeno_action/activable/uppercut,
	)
	behavior_delegate_type = /datum/behavior_delegate/boxer

/datum/xeno_strain/boxer/apply_strain(mob/living/carbon/xenomorph/warrior/warrior)
	warrior.health_modifier += XENO_HEALTH_MOD_MED
	warrior.armor_modifier += XENO_ARMOR_MOD_VERY_SMALL
	warrior.agility = FALSE
	warrior.recalculate_everything()

/datum/behavior_delegate/boxer
	name = "Boxer Warrior Behavior Delegate"
	var/ko_delay = 5 SECONDS
	var/max_clear_head = 3
	var/clear_head_delay = 15 SECONDS
	var/clear_head = 3
	var/next_clear_head_regen
	var/clear_head_tickcancel
	var/mob/punching_bag
	var/ko_counter = 0
	var/ko_reset_timer
	var/max_ko_counter = 15
	var/image/ko_icon
	var/image/big_ko_icon

/datum/behavior_delegate/boxer/New()
	. = ..()
	if(SSticker.mode && (SSticker.mode.flags_round_type & MODE_XVX)) // this is pain to do, but how else? hopefully we can replace clarity with something better in the future
		clear_head = 0
		max_clear_head = 0

/datum/behavior_delegate/boxer/append_to_stat()
	. = list()
	if(punching_bag)
		. += "Beating [punching_bag] - [ko_counter] hits"
	. += "Clarity [clear_head] hits"

/datum/behavior_delegate/boxer/on_life()
	var/wt = world.time
	if(wt > next_clear_head_regen && clear_head<max_clear_head)
		clear_head++
		next_clear_head_regen = wt + clear_head_delay

/datum/behavior_delegate/boxer/melee_attack_additional_effects_target(mob/living/carbon/A, ko_boost = 0.5)
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
	ko_reset_timer = addtimer(CALLBACK(src, PROC_REF(remove_ko)), ko_delay, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT|TIMER_STOPPABLE)

/datum/behavior_delegate/boxer/proc/remove_ko()
	punching_bag = null
	ko_counter = 0
	if(bound_xeno.client && ko_icon)
		bound_xeno.client.images -= ko_icon
	ko_icon = null

/datum/behavior_delegate/boxer/proc/display_ko_message(mob/carbon)
	if(!bound_xeno.client)
		return

	if(!bound_xeno.client.prefs || bound_xeno.client.prefs.lang_chat_disabled)
		return

	big_ko_icon = image(null, carbon)
	big_ko_icon.alpha = 196
	big_ko_icon.maptext_y = carbon.langchat_height
	big_ko_icon.maptext_width = LANGCHAT_WIDTH
	big_ko_icon.maptext_height = 64
	big_ko_icon.color = "#FF0000"
	big_ko_icon.maptext_x = bound_xeno.get_maxptext_x_offset(big_ko_icon)
	big_ko_icon.maptext = "<span class='center langchat langchat_bolditalicbig'>KO!</span>"
	bound_xeno.client.images += big_ko_icon
	addtimer(CALLBACK(src, PROC_REF(remove_big_ko)), 2 SECONDS)

/datum/behavior_delegate/boxer/proc/remove_big_ko()
	if(bound_xeno.client && big_ko_icon)
		bound_xeno.client.images -= big_ko_icon
	big_ko_icon = null
