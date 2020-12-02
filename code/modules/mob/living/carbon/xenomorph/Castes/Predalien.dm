/datum/caste_datum/predalien
	caste_name = "Predalien"
	display_name = "Abomination"

	melee_damage_lower = XENO_DAMAGE_TIER_4
	melee_damage_upper = XENO_DAMAGE_TIER_5
	max_health = XENO_HEALTH_TIER_9
	plasma_gain = XENO_PLASMA_GAIN_TIER_9
	plasma_max = XENO_PLASMA_TIER_3
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_10
	armor_deflection = XENO_ARMOR_TIER_3
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_7

	evolution_allowed = FALSE

	tackle_min = 3
	tackle_max = 6
	tacklestrength_min = 6
	tacklestrength_max = 10

	is_intelligent = TRUE
	tier = 1
	attack_delay = -2

	behavior_delegate_type = /datum/behavior_delegate/predalien_base

/mob/living/carbon/Xenomorph/Predalien
	caste_name = "Predalien"
	name = "Abomination"
	desc = "A strange looking creature with fleshy strands on its head. It appears like a mixture of armor and flesh, smooth, but well carapaced."
	icon_state = "Predalien Walking"
	plasma_types = list(PLASMA_CATECHOLAMINE)
	faction = FACTION_PREDALIEN
	wall_smash = TRUE
	hardcore = FALSE
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	tier = 1
	age = XENO_NO_AGE //Predaliens are already in their ultimate form, they don't get even better
	small_explosives_stun = FALSE

	actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/pounce/predalien,
		/datum/action/xeno_action/activable/predalien_roar,
		/datum/action/xeno_action/activable/smash,
		/datum/action/xeno_action/activable/devastate
		)
	mutation_type = "Normal"

	var/butcher_time = SECONDS_6


/mob/living/carbon/Xenomorph/Predalien/Initialize(mapload, mob/living/carbon/Xenomorph/oldXeno, h_number)
	. = ..()
	icon = get_icon_from_source(CONFIG_GET(string/alien_predalien))
	addtimer(CALLBACK(src, .proc/announce_spawn), SECONDS_3)

/mob/living/carbon/Xenomorph/Predalien/proc/announce_spawn()
	if(!loc)
		return FALSE

	to_chat(src, {"
<span class='role_body'>|______________________|</span>
<span class='role_header'>You are a predator-alien hybrid!</span>
<span class='role_body'>You are a very powerful xenomorph creature that was born of a Yautja warrior body.
You are stronger, faster, and smarter than a regular xenomorph, but you must still listen to the queen.
You have a degree of freedom to where you can hunt and claim the heads of the hive's enemies, so check your verbs.
Your health meter will not regenerate normally, so kill and die for the hive!</span>
<span class='role_body'>|______________________|</span>
"})
	emote("roar")

/datum/behavior_delegate/predalien_base
	name = "Base Predalien Behavior Delegate"

	var/kills = 0
	var/max_kills = 10

/datum/behavior_delegate/predalien_base/append_to_stat()
	stat("Kills:", "[kills]/[max_kills]")

/datum/behavior_delegate/predalien_base/on_kill_mob(mob/M)
	. = ..()

	kills = min(kills + 1, max_kills)

/datum/behavior_delegate/predalien_base/melee_attack_modify_damage(original_damage, atom/A = null)
	if(isYautja(A))
		original_damage *= 1.5

	return original_damage + kills * 2.5

/datum/behavior_delegate/predalien_base/handle_slash(mob/M)
	if(bound_xeno.match_hivemind(M))
		return FALSE

	var/mob/living/carbon/Xenomorph/Predalien/X = bound_xeno

	if(!istype(X))
		return FALSE

	if(M.stat == DEAD && isXenoOrHuman(M))
		if(X.action_busy)
			to_chat(X, SPAN_XENONOTICE("You are already performing an action!"))
			return TRUE

		playsound(X.loc, 'sound/weapons/slice.ogg', 25)

		if(!do_after(X, X.butcher_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE, M))
			to_chat(X, SPAN_XENONOTICE("You decide not to butcher [M]"))
			return TRUE

		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			for(var/i in 1 to 3)
				var/obj/item/reagent_container/food/snacks/meat/h_meat = new(H.loc)
				h_meat.name = "[H.name] meat"

		else if (isXeno(M))
			var/mob/living/carbon/Xenomorph/xeno_victim = M

			new /obj/effect/decal/remains/xeno(xeno_victim.loc)
			var/obj/item/stack/sheet/animalhide/xeno/xenohide = new /obj/item/stack/sheet/animalhide/xeno(xeno_victim.loc)
			xenohide.name = "[xeno_victim.age_prefix][xeno_victim.caste_name]-hide"
			xenohide.singular_name = "[xeno_victim.age_prefix][xeno_victim.caste_name]-hide"
			xenohide.stack_id = "[xeno_victim.age_prefix][xeno_victim.caste_name]-hide"

		playsound(X.loc, 'sound/effects/blobattack.ogg', 25)

		M.gib("butchering")

		return TRUE

	return FALSE
