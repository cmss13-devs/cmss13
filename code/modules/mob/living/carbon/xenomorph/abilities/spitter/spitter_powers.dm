/datum/action/xeno_action/onclick/charge_spit/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if (!istype(X) || !X.check_state())
		return

	if (buffs_active)
		to_chat(X, SPAN_XENOHIGHDANGER("You cannot stack this!"))
		return

	if (!check_and_use_plasma_owner())
		return

	to_chat(X, SPAN_XENOHIGHDANGER("You accumulate acid in your glands. Your next spit will be stronger but shorter-ranged."))
	to_chat(X, SPAN_XENOWARNING("Additionally, you are slightly faster and more armored for a small amount of time."))
	X.create_custom_empower(icolor = "#93ec78", ialpha = 200, small_xeno = TRUE)
	buffs_active = TRUE
	X.ammo = GLOB.ammo_list[/datum/ammo/xeno/acid/spatter] // shitcode is my city
	X.speed_modifier -= speed_buff_amount
	X.armor_modifier += armor_buff_amount
	X.recalculate_speed()

	/// Though the ability's other buffs are supposed to last for its duration, it's only supposed to enhance one spit.
	RegisterSignal(X, COMSIG_XENO_POST_SPIT, .proc/disable_spatter)

	addtimer(CALLBACK(src, .proc/remove_effects), duration)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/onclick/charge_spit/proc/disable_spatter()
	SIGNAL_HANDLER
	var/mob/living/carbon/Xenomorph/X = owner
	to_chat(X, SPAN_XENOWARNING("Your acid glands empty out and return back to normal. You will once more fire long-ranged weak spits."))
	X.ammo = GLOB.ammo_list[/datum/ammo/xeno/acid] // el codigo de mierda es mi ciudad
	UnregisterSignal(X, COMSIG_XENO_POST_SPIT)

/datum/action/xeno_action/onclick/charge_spit/proc/remove_effects()
	var/mob/living/carbon/Xenomorph/X = owner

	if (!istype(X))
		return

	X.speed_modifier += speed_buff_amount
	X.armor_modifier -= armor_buff_amount
	X.recalculate_speed()
	to_chat(X, SPAN_XENOHIGHDANGER("You feel your movement speed slow down!"))
	disable_spatter()
	buffs_active = FALSE
