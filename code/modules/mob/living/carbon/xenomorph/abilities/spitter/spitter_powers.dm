/datum/action/xeno_action/onclick/charge_spit/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/zenomorf = owner

	if (!action_cooldown_check())
		return

	if (!istype(zenomorf) || !zenomorf.check_state())
		return

	if (buffs_active)
		to_chat(zenomorf, SPAN_XENOHIGHDANGER("You cannot stack this!"))
		return

	if (!check_and_use_plasma_owner())
		return

	to_chat(zenomorf, SPAN_XENOHIGHDANGER("You accumulate acid in your glands. Your next spit will be stronger but shorter-ranged."))
	to_chat(zenomorf, SPAN_XENOWARNING("Additionally, you are slightly faster and more armored for a small amount of time."))
	zenomorf.create_custom_empower(icolor = "#93ec78", ialpha = 200, small_xeno = TRUE)
	zenomorf.balloon_alert(zenomorf, "your next spit will be stronger", text_color = "#93ec78")
	buffs_active = TRUE
	zenomorf.ammo = GLOB.ammo_list[/datum/ammo/xeno/acid/spatter] // shitcode is my city
	zenomorf.speed_modifier -= speed_buff_amount
	zenomorf.armor_modifier += armor_buff_amount
	zenomorf.recalculate_speed()

	/// Though the ability's other buffs are supposed to last for its duration, it's only supposed to enhance one spit.
	RegisterSignal(zenomorf, COMSIG_XENO_POST_SPIT, PROC_REF(disable_spatter))

	addtimer(CALLBACK(src, PROC_REF(remove_effects)), duration)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/onclick/charge_spit/proc/disable_spatter()
	SIGNAL_HANDLER
	var/mob/living/carbon/xenomorph/zenomorf = owner
	if(zenomorf.ammo == GLOB.ammo_list[/datum/ammo/xeno/acid/spatter])
		to_chat(zenomorf, SPAN_XENOWARNING("Your acid glands empty out and return back to normal. You will once more fire long-ranged weak spits."))
		zenomorf.balloon_alert(zenomorf, "your spits are back to normal", text_color = "#93ec78")
		zenomorf.ammo = GLOB.ammo_list[/datum/ammo/xeno/acid] // el codigo de mierda es mi ciudad
	UnregisterSignal(zenomorf, COMSIG_XENO_POST_SPIT)

/datum/action/xeno_action/onclick/charge_spit/proc/remove_effects()
	var/mob/living/carbon/xenomorph/zenomorf = owner

	if (!istype(zenomorf))
		return

	zenomorf.speed_modifier += speed_buff_amount
	zenomorf.armor_modifier -= armor_buff_amount
	zenomorf.recalculate_speed()
	to_chat(zenomorf, SPAN_XENOHIGHDANGER("You feel your movement speed slow down!"))
	disable_spatter()
	buffs_active = FALSE

/datum/action/xeno_action/activable/tail_stab/spitter/use_ability(atom/A)
	var/target = ..()
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		carbon_target.reagents.add_reagent("molecularacid", 2)

// Marker abilities

/datum/action/xeno_action/activable/xeno_spit/marker
	name = "Marking spit"
	action_icon_state = "Marking_spit"
	ability_name = "Marking spit"
	macro_path = /datum/action/xeno_action/verb/verb_xeno_spit

/datum/action/xeno_action/onclick/healing_surge/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/zenomorf = owner

	if (!action_cooldown_check())
		return

	if (!istype(zenomorf) || !zenomorf.check_state())
		return

	if (buffs_active)
		to_chat(zenomorf, SPAN_XENOHIGHDANGER("You cannot stack this!"))
		return

	if (!check_and_use_plasma_owner())
		return

	to_chat(zenomorf, SPAN_XENOHIGHDANGER("You mix the resin and acid in your glands to produce a glob with healing fumes."))
	zenomorf.create_custom_empower(icolor = "#93ec78", ialpha = 200, small_xeno = TRUE)
	zenomorf.balloon_alert(zenomorf, "your next spit will be heal your sisters in an Area of Effect", text_color = "#93ec78")
	buffs_active = TRUE
	zenomorf.ammo = GLOB.ammo_list[/datum/ammo/xeno/acid/healing] // shitcode is my city

	RegisterSignal(zenomorf, COMSIG_XENO_POST_SPIT, PROC_REF(disable_healing))

	addtimer(CALLBACK(src, PROC_REF(remove_effects)), duration)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/onclick/healing_surge/proc/disable_healing()
	SIGNAL_HANDLER
	var/mob/living/carbon/xenomorph/zenomorf = owner
	if(zenomorf.ammo == GLOB.ammo_list[/datum/ammo/xeno/acid/healing])
		to_chat(zenomorf, SPAN_XENOWARNING("Your glands empty out and return back to normal. You will once more fire acidic spits."))
		zenomorf.balloon_alert(zenomorf, "your spits are back to normal", text_color = "#93ec78")
		zenomorf.ammo = GLOB.ammo_list[/datum/ammo/xeno/acid/marking] // el codigo de mierda es mi ciudad
	UnregisterSignal(zenomorf, COMSIG_XENO_POST_SPIT)

/datum/action/xeno_action/onclick/healing_surge/proc/remove_effects()
	var/mob/living/carbon/xenomorph/zenomorf = owner

	if (!istype(zenomorf))
		return

	to_chat(zenomorf, SPAN_XENOHIGHDANGER("the mixture leaves your glands!"))
	disable_healing()
	buffs_active = FALSE
