/datum/caste_datum/spitter
	caste_type = XENO_CASTE_SPITTER
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_3
	melee_vehicle_damage = XENO_DAMAGE_TIER_3
	max_health = XENO_HEALTH_TIER_7
	plasma_gain = XENO_PLASMA_GAIN_TIER_7
	plasma_max = XENO_PLASMA_TIER_6
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_ARMOR_MOD_MED
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_5

	caste_desc = "Ptui!"
	spit_types = list(/datum/ammo/xeno/acid, /datum/ammo/xeno/acid/spatter)
	evolves_to = list(XENO_CASTE_PRAETORIAN, XENO_CASTE_BOILER)
	deevolves_to = list(XENO_CASTE_SENTINEL)
	acid_level = 2

	spit_delay = 2.5 SECONDS

	tackle_min = 2
	tackle_max = 6
	tackle_chance = 45
	tacklestrength_min = 4
	tacklestrength_max = 5

	minimum_evolve_time = 9 MINUTES

	minimap_icon = "spitter"

/mob/living/carbon/xenomorph/spitter
	caste_type = XENO_CASTE_SPITTER
	name = XENO_CASTE_SPITTER
	desc = "A gross, oozing alien of some kind."
	icon_size = 48
	icon_state = "Spitter Walking"
	plasma_types = list(PLASMA_NEUROTOXIN)
	pixel_x = -12
	old_x = -12
	organ_value = 2000
	tier = 2
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab/spitter,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/onclick/charge_spit,
		/datum/action/xeno_action/activable/spray_acid/spitter,
		/datum/action/xeno_action/onclick/tacmap,
	)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
	)

	icon_xeno = 'icons/mob/xenos/castes/tier_2/spitter.dmi'
	icon_xenonid = 'icons/mob/xenonids/castes/tier_2/spitter.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_48x48.dmi'
	weed_food_states = list("Drone_1","Drone_2","Drone_3")
	weed_food_states_flipped = list("Drone_1","Drone_2","Drone_3")


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
