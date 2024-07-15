/datum/action/xeno_action/onclick/charge_spit/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/zenomorf = owner

	if (!action_cooldown_check())
		return

	if (!istype(zenomorf) || !zenomorf.check_state())
		return

	if (buffs_active)
		to_chat(zenomorf, SPAN_XENOHIGHDANGER("We cannot stack this!"))
		return

	if (!check_and_use_plasma_owner())
		return

	to_chat(zenomorf, SPAN_XENOHIGHDANGER("We accumulate acid in your glands. Our next spit will be stronger but shorter-ranged."))
	to_chat(zenomorf, SPAN_XENOWARNING("Additionally, we are slightly faster and more armored for a small amount of time."))
	zenomorf.create_custom_empower(icolor = "#93ec78", ialpha = 200, small_xeno = TRUE)
	zenomorf.balloon_alert(zenomorf, "our next spit will be stronger", text_color = "#93ec78")
	buffs_active = TRUE
	zenomorf.ammo = GLOB.ammo_list[/datum/ammo/xeno/acid/spatter] // shitcode is my city
	zenomorf.speed_modifier -= speed_buff_amount
	zenomorf.armor_modifier += armor_buff_amount
	zenomorf.recalculate_speed()
	zenomorf.recalculate_armor()

	/// Though the ability's other buffs are supposed to last for its duration, it's only supposed to enhance one spit.
	RegisterSignal(zenomorf, COMSIG_XENO_POST_SPIT, PROC_REF(disable_spatter))

	addtimer(CALLBACK(src, PROC_REF(remove_effects)), duration)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/charge_spit/proc/disable_spatter()
	SIGNAL_HANDLER
	var/mob/living/carbon/xenomorph/zenomorf = owner
	if(zenomorf.ammo == GLOB.ammo_list[/datum/ammo/xeno/acid/spatter])
		to_chat(zenomorf, SPAN_XENOWARNING("Our acid glands empty out and return back to normal. We will once more fire long-ranged weak spits."))
		zenomorf.balloon_alert(zenomorf, "our spits are back to normal", text_color = "#93ec78")
		zenomorf.ammo = GLOB.ammo_list[/datum/ammo/xeno/acid] // el codigo de mierda es mi ciudad
	UnregisterSignal(zenomorf, COMSIG_XENO_POST_SPIT)

/datum/action/xeno_action/onclick/charge_spit/proc/remove_effects()
	var/mob/living/carbon/xenomorph/zenomorf = owner

	if (!istype(zenomorf))
		return

	zenomorf.speed_modifier += speed_buff_amount
	zenomorf.armor_modifier -= armor_buff_amount
	zenomorf.recalculate_speed()
	zenomorf.recalculate_armor()
	to_chat(zenomorf, SPAN_XENOHIGHDANGER("We feel our movement speed slow down!"))
	disable_spatter()
	buffs_active = FALSE

/datum/action/xeno_action/activable/tail_stab/spitter/use_ability(atom/A)
	var/target = ..()
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		carbon_target.reagents.add_reagent("molecularacid", 2)
		carbon_target.reagents.set_source_mob(owner, /datum/reagent/toxin/molecular_acid)
