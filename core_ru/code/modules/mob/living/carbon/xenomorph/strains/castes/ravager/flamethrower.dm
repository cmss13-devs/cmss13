/datum/xeno_strain/flamethrower
	name = "Flamethrower"
	description = "Youre losing your charge and empower as armor, but gain FLAME! Shall your enemies BURN down to ashes! It's a goddamn dragon! Run! RUUUUN!"
	flavor_description = "Run, Hide - death will come to every host anyway! It's a goddamn dragon! Run! RUUUUN!"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/pounce/charge,
		/datum/action/xeno_action/onclick/empower,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/breathe_fire,
	)

/datum/xeno_strain/flamethrower/apply_strain(mob/living/carbon/xenomorph/ravager/ravager)
	ravager.armor_modifier -= XENO_ARMOR_MOD_MED
	ravager.recalculate_everything()
	ravager.desc = "It's a goddamn dragon! Run! RUUUUN!"


/datum/action/xeno_action/verb/verb_breathe_fire()
	set category = "Alien"
	set name = "Breathe Fire"
	set hidden = TRUE
	var/action_name = "Breathe Fire"
	handle_xeno_macro(src, action_name)


/datum/action/xeno_action/activable/breathe_fire
	name = "Breathe Fire"
	action_icon_state = "breathe_fire"
	macro_path = /datum/action/xeno_action/verb/verb_breathe_fire
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 15 SECONDS

/datum/action/xeno_action/activable/breathe_fire/use_ability(atom/target)
	set waitfor = 0
	var/mob/living/carbon/xenomorph/ravager/ravager = owner
	if(!action_cooldown_check())
		return

	if(!ravager.check_state())
		return

	var/turf/temp[] = get_line(get_turf(ravager), get_turf(target))

	var/turf/to_fire = temp[2]

	var/obj/flamer_fire/fire = locate() in to_fire
	if(fire)
		qdel(fire)

	playsound(to_fire, 'sound/weapons/gun_flamethrower2.ogg', 50, TRUE)
	ravager.visible_message("<span class='xenowarning'>\The [ravager] sprays out a stream of flame from its mouth!</span>", \
	"<span class='xenowarning'>You unleash a spray of fire on your enemies!</span>")

	new /obj/flamer_fire(to_fire, create_cause_data(initial(ravager.name), ravager), new /datum/reagent/xenomorph_plasma(), 5, null, FLAMESHAPE_LINE, target)

	apply_cooldown()
	..()

#define PROPERTY_FRIENDLY_EVADE "friendly-evade"

/obj/flamer_fire
	var/friendlydetection = FALSE

/datum/reagent
	var/friendlydetection = FALSE

/datum/reagent/xenomorph_plasma
	name = "Flamable Plasma"
	id = "fmplasma"
	description = "That very sticky liquid can burn down entire body!"
	reagent_state = LIQUID
	color = "#35298f"
	burncolor = "#35298f"
	burn_sprite = "dynamic"
	properties = list(
		PROPERTY_INTENSITY = BURN_LEVEL_TIER_3,
		PROPERTY_DURATION = BURN_TIME_TIER_1,
		PROPERTY_FRIENDLY_EVADE = 1,
		PROPERTY_RADIUS = 5,
	)

/datum/chem_property/special/friendly_evade
	name = PROPERTY_FRIENDLY_EVADE
	code = "IFF"
	description = "Allow you to skip friendlies"
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_REACTANT|PROPERTY_TYPE_ANOMALOUS
	value = 666

/datum/chem_property/special/friendly_evade/reset_reagent()
	holder.friendlydetection = initial(holder.friendlydetection)

	..()

/datum/chem_property/special/friendly_evade/update_reagent()
	holder.friendlydetection = TRUE

	..()
