/datum/xeno_mutator/knight
	name = "STRAIN: Warrior - Knight"
	description = "You forfeit all your brawling abilities, replacing them with the ability to fight on the front, with your long-ranged Pike to harass, your Bulwark to protect from suppression, and your Leap to reposition. Being on weeds will enhance your abilities."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_WARRIOR) //Only warrior.
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/warrior_punch,
		/datum/action/xeno_action/activable/lunge,
		/datum/action/xeno_action/activable/fling
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/tail_stab/tail_trip,
		/datum/action/xeno_action/activable/pike,
		/datum/action/xeno_action/onclick/bulwark,
		/datum/action/xeno_action/activable/pounce/leap
	)
	behavior_delegate_type = /datum/behavior_delegate/warrior_knight
	keystone = TRUE

/datum/xeno_mutator/knight/apply_mutator(datum/mutator_set/individual_mutators/mutator_set)
	. = ..()
	if (!.)
		return

	var/mob/living/carbon/xenomorph/Warrior/Knight = mutator_set.xeno
	Knight.health_modifier += XENO_HEALTH_MOD_MED
	Knight.armor_modifier += XENO_ARMOR_MOD_SMALL
	Knight.explosivearmor_modifier += XENO_EXPLOSIVE_ARMOR_TIER_4
	Knight.claw_type = CLAW_TYPE_SHARP
	Knight.plasma_types = list(PLASMA_CHITIN)
	mutator_update_actions(Knight)
	mutator_set.recalculate_actions(description, flavor_description)
	Knight.recalculate_everything()

	Knight.mutation_icon_state = WARRIOR_KNIGHT
	Knight.mutation_type = WARRIOR_KNIGHT

	apply_behavior_delegate(Knight)

/datum/behavior_delegate/warrior_knight
	name = "Warrior Knight Behavior Delegate"

	/// If the Knight has chess-leaped onto a victim - they have been owned and will be stomped on. This var is jank meant to bypass bad pounce code.
	var/owned = FALSE

	/// If the Knight is on weeds, and thus has its abilities enhanced.
	var/abilities_enhanced = FALSE

	/// If bulwark is on - allows abilities to stay enhanced offweeds.
	var/bulwark_enabled = FALSE

	/// Clarity stacks, gained with Bulwark.
	var/clarity_stacks = 0

	// Colors for various abilities - pike, bulwark.

	/// When the Warrior is on weeds.
	var/enhanced_color = "#A7A2CB"
	/// When the warrior isn't on weeds.
	var/un_enhanced_color = "#6a6688"
	/// Currently selected color.
	var/current_color

	// These vars will adjust brightness if the Knight isn't from the default hive.

	var/un_enhanced_brightness = 50
	var/enhanced_brightness = 125

	// This is a purely-flavor overlay for when the Knight is on weeds.

	var/mutable_appearance/enhancement_tendrils_icon

	COOLDOWN_DECLARE(toggle_msg_cd) // 14 SECONDS - reduces chat spam

/datum/behavior_delegate/warrior_knight/add_to_xeno()
	RegisterSignal(bound_xeno, COMSIG_MOVABLE_TURF_ENTER, PROC_REF(weed_enhance_check))
	if(bound_xeno.hivenumber != XENO_HIVE_NORMAL)
		un_enhanced_color = adjust_brightness(bound_xeno.hive.color, un_enhanced_brightness)
		enhanced_color = adjust_brightness(bound_xeno.hive.color, enhanced_brightness)
	weed_enhance_check(bound_xeno, get_turf(bound_xeno))

/datum/behavior_delegate/warrior_knight/on_update_icons()
	if(!enhancement_tendrils_icon)
		enhancement_tendrils_icon = mutable_appearance('icons/mob/xenos/warrior_strain_overlays.dmi',"Immortal Will Overlay")

	bound_xeno.overlays -= enhancement_tendrils_icon
	enhancement_tendrils_icon.overlays.Cut()

	if(!abilities_enhanced)
		return

	if(bound_xeno.stat == DEAD || bound_xeno.lying || bound_xeno.resting || bound_xeno.sleeping || bound_xeno.health < 0) // only if they'are up and about
		return

	bound_xeno.overlays += enhancement_tendrils_icon

/datum/behavior_delegate/warrior_knight/proc/weed_enhance_check(var/mob/living/carbon/xenomorph/Warrior/Knight, var/turf/entered_turf)
	SIGNAL_HANDLER
	var/datum/behavior_delegate/warrior_knight/knight_delegate = Knight.behavior_delegate
	//If the entered turf has weeds *and* they're of the same hive, try to buff if not already buffed.
	if(entered_turf.weeds?.hivenumber == Knight.hivenumber)
		if(knight_delegate.abilities_enhanced)
			return
		knight_delegate.buff()
	//If neither are true, try to debuff if not already debuffed. If bulwark is on, don't debuff - let them stay offweeds for a bit.
	else
		if(!knight_delegate.abilities_enhanced || bulwark_enabled)
			return
		knight_delegate.debuff()

/datum/behavior_delegate/warrior_knight/proc/buff()

	abilities_enhanced = TRUE
	current_color = enhanced_color

	var/color = enhanced_color
	var/alpha = 25
	if(COOLDOWN_FINISHED(src, toggle_msg_cd))
		bound_xeno.visible_message(SPAN_DANGER("\The [bound_xeno] begins faintly glowing purple."), SPAN_NOTICE("Tendrils from your hive's weeds connect you to the hive's psychic power. Your abilities are now enhanced."))
		COOLDOWN_START(src, toggle_msg_cd, 8 SECONDS)
	color += num2text(alpha, 2, 16)
	bound_xeno.add_filter("enhanced_buff", 1, list("type" = "outline", "color" = color, "size" = 2))

/datum/behavior_delegate/warrior_knight/proc/debuff()

	abilities_enhanced = FALSE
	current_color = un_enhanced_color

	if(COOLDOWN_FINISHED(src, toggle_msg_cd))
		bound_xeno.visible_message(SPAN_DANGER("\The [bound_xeno] ceases glowing."), SPAN_NOTICE("As you step away from your hive's weeds its tendrils unhook from your body. Your abilities weaken and are no longer enhanced."))
		COOLDOWN_START(src, toggle_msg_cd, 8 SECONDS)
	bound_xeno.remove_filter("enhanced_buff")
