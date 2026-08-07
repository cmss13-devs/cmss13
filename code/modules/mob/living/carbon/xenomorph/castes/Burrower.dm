//burrower is COMBAT support
/datum/caste_datum/burrower
	caste_type = XENO_CASTE_BURROWER
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_2
	melee_damage_upper = XENO_DAMAGE_TIER_3
	melee_vehicle_damage = XENO_DAMAGE_TIER_3
	max_health = XENO_HEALTH_TIER_6
	plasma_gain = XENO_PLASMA_GAIN_TIER_8
	plasma_max = XENO_PLASMA_TIER_6
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_4
	armor_deflection = XENO_ARMOR_TIER_2
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_4

	deevolves_to = list(XENO_CASTE_DRONE)
	caste_desc = "A digger and trapper."
	acid_level = 2
	weed_level = WEED_LEVEL_STANDARD
	evolution_allowed = FALSE

	behavior_delegate_type = /datum/behavior_delegate/burrower_base

	tackle_min = 3
	tackle_max = 5
	tackle_chance = 40
	tacklestrength_min = 4
	tacklestrength_max = 5

	minimum_evolve_time = 7 MINUTES

	minimap_icon = "burrower"

/mob/living/carbon/xenomorph/burrower
	caste_type = XENO_CASTE_BURROWER
	name = XENO_CASTE_BURROWER
	desc = "A beefy alien with sharp claws."
	icon = 'icons/mob/xenos/castes/tier_2/burrower.dmi'
	icon_size = 64
	icon_state = "Burrower Walking"
	layer = MOB_LAYER
	plasma_stored = 100
	plasma_types = list(PLASMA_PURPLE)
	pixel_x = -12
	old_x = -12
	xenonid_pixel_x = -16
	base_pixel_x = 0
	base_pixel_y = -20
	tier = 2
	organ_value = 1500

	base_actions = list(
		/datum/action/xeno_action/onclick/toggle_seethrough,
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/onclick/build_tunnel,
		/datum/action/xeno_action/onclick/plant_weeds, //first macro
		/datum/action/xeno_action/onclick/place_trap, //second macro
		/datum/action/xeno_action/activable/burrow, //third macro
		/datum/action/xeno_action/onclick/tremor, //fourth macro
		/datum/action/xeno_action/active_toggle/toggle_meson_vision,
		)

	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
		/mob/living/carbon/xenomorph/proc/rename_tunnel,
		/mob/living/carbon/xenomorph/proc/set_hugger_reserve_for_morpher,
	)

	icon_xeno = 'icons/mob/xenos/castes/tier_2/burrower.dmi'
	icon_xenonid = 'icons/mob/xenonids/castes/tier_2/burrower.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Burrower_1","Burrower_2","Burrower_3")
	weed_food_states_flipped = list("Burrower_1","Burrower_2","Burrower_3")

	skull = /obj/item/skull/burrower
	pelt = /obj/item/pelt/burrower

/datum/behavior_delegate/burrower_base
	name = "Base Burrower Behavior Delegate"

/datum/action/xeno_action/activable/burrow/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	XENO_ACTION_CHECK(xeno)

	if(HAS_TRAIT(xeno, TRAIT_ABILITY_BURROWED))
		digging(get_turf(target_atom))
	else
		burrow()
	return ..()

/datum/action/xeno_action/activable/burrow/proc/burrow()
	var/mob/living/carbon/xenomorph/xeno = owner

	XENO_ACTION_CHECK(xeno)

	if(HAS_TRAIT(xeno, TRAIT_ABILITY_BURROW_UNDERGROUND) || HAS_TRAIT(xeno, TRAIT_ABILITY_BURROW_DIGGING))
		return

	if(xeno.is_ventcrawling || xeno.action_busy)
		return

	var/turf/current_turf = get_turf(xeno)
	if(!current_turf)
		return

	var/area/current_area = get_area(current_turf)
	if(current_area.flags_area & AREA_NOBURROW)
		to_chat(xeno, SPAN_XENOWARNING("There's no way to burrow here."))
		return

	if(istype(current_turf, /turf/open/floor/almayer/research/containment) || istype(current_turf, /turf/closed/wall/almayer/research/containment))
		to_chat(xeno, SPAN_XENOWARNING("We can't escape this cell!"))
		return

	if(xeno.clone) //Prevents burrowing on stairs
		to_chat(xeno, SPAN_XENOWARNING("We can't burrow here!"))
		return

	if(xeno.caste_type && GLOB.xeno_datum_list[xeno.caste_type])
		xeno.caste = GLOB.xeno_datum_list[xeno.caste_type]

	ADD_TRAIT(xeno, TRAIT_ABILITY_BURROW_UNDERGROUND, TRAIT_SOURCE_ABILITY("burrow_underground"))

	to_chat(xeno, SPAN_XENOWARNING("We begin burrowing ourselves into the ground."))
	if(!do_after(xeno, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		addtimer(CALLBACK(src, PROC_REF(do_burrow_cooldown)), burrow_cooldown)
		return
	// TODO Make immune to all damage here.
	to_chat(xeno, SPAN_XENOWARNING("We burrow ourselves into the ground."))
	QDEL_NULL(xeno.observed_atom)
	xeno.invisibility = 101
	xeno.alpha = 100
	xeno.anchored = TRUE

	var/mob/living/carbon/human/hauled = xeno.hauled_mob?.resolve()

	if(hauled)
		hauled.forceMove(xeno)

	xeno.add_traits(list(TRAIT_ABILITY_BURROWED, TRAIT_UNDENSE, TRAIT_IMMOBILIZED), TRAIT_SOURCE_ABILITY("Burrow"))
	playsound(xeno.loc, 'sound/effects/burrowing_b.ogg', 25)
	xeno.update_icons()
	start_duration_display(10 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(do_burrow_cooldown)), burrow_cooldown)
	burrow_timer = world.time + 90 // How long we can be burrowed
	process_burrow()

/datum/action/xeno_action/activable/burrow/proc/process_burrow()
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!HAS_TRAIT(xeno, TRAIT_ABILITY_BURROWED))
		return
	if(world.time > burrow_timer && !HAS_TRAIT(xeno, TRAIT_ABILITY_BURROW_DIGGING))
		burrow_off()
	if(xeno.observed_xeno)
		xeno.overwatch(xeno.observed_xeno, TRUE)
	if(HAS_TRAIT(xeno, TRAIT_ABILITY_BURROWED))
		addtimer(CALLBACK(src, PROC_REF(process_burrow)), 1 SECONDS)

/datum/action/xeno_action/activable/burrow/proc/burrow_off()
	var/mob/living/carbon/xenomorph/xeno = owner

	to_chat(xeno, SPAN_NOTICE("You resurface."))
	xeno.remove_traits(list(TRAIT_ABILITY_BURROWED, TRAIT_UNDENSE, TRAIT_IMMOBILIZED), TRAIT_SOURCE_ABILITY("Burrow"))
	xeno.invisibility = FALSE
	xeno.alpha = initial(xeno.alpha)
	xeno.anchored = FALSE
	end_duration_display()

	var/mob/living/carbon/human/hauled = xeno.hauled_mob?.resolve()
	if(hauled)
		hauled.forceMove(xeno.loc)

	playsound(xeno.loc, 'sound/effects/burrowoff.ogg', 25)
	for(var/mob/living/carbon/mob in xeno.loc)
		if(!xeno.can_not_harm(mob))
			mob.apply_effect(1.5, WEAKEN)

	addtimer(CALLBACK(src, PROC_REF(do_burrow_cooldown)), burrow_cooldown)
	xeno.update_icons()

/datum/action/xeno_action/activable/burrow/proc/do_burrow_cooldown()
	var/mob/living/carbon/xenomorph/xeno = owner

	REMOVE_TRAIT(xeno, TRAIT_ABILITY_BURROW_UNDERGROUND, TRAIT_SOURCE_ABILITY("burrow_underground"))
	if(HAS_TRAIT(xeno, TRAIT_ABILITY_BURROWED))
		to_chat(xeno, SPAN_NOTICE("We can now surface."))
	update_button_icon()



/datum/action/xeno_action/activable/burrow/proc/digging(turf/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	XENO_ACTION_CHECK(xeno)

	if(!HAS_TRAIT(xeno, TRAIT_ABILITY_BURROWED))
		to_chat(xeno, SPAN_NOTICE("We must be burrowed to do this."))
		return

	if(HAS_TRAIT(xeno, TRAIT_ABILITY_BURROW_DIGGING))
		REMOVE_TRAIT(xeno, TRAIT_ABILITY_BURROW_DIGGING, TRAIT_SOURCE_ABILITY("burrow_digging"))
		to_chat(xeno, SPAN_NOTICE("We stop tunneling."))
		used_digging = TRUE
		addtimer(CALLBACK(src, PROC_REF(do_digging_cooldown)), digging_cooldown)
		return

	if(used_digging)
		to_chat(xeno, SPAN_NOTICE("We must wait some time to do this."))
		return

	if(!target_atom)
		to_chat(xeno, SPAN_NOTICE("We can't tunnel there!"))
		return

	if(target_atom.density)
		to_chat(xeno, SPAN_XENOWARNING("We can't tunnel into a solid wall!"))
		return

	if(istype(target_atom, /turf/open/space))
		to_chat(xeno, SPAN_XENOWARNING("We make tunnels, not wormholes!"))
		return

	if(xeno.clone) //Prevents tunnels in Z transition areas
		to_chat(xeno, SPAN_XENOWARNING("We make tunnels, not wormholes!"))
		return

	var/area/area_to_get = get_area(target_atom)
	if(area_to_get.flags_area & AREA_NOBURROW || get_dist(xeno, target_atom) > 15)
		to_chat(xeno, SPAN_XENOWARNING("There's no way to tunnel over there."))
		return

	for(var/obj/objects_in_turf in target_atom.contents)
		if(objects_in_turf.density)
			if(objects_in_turf.flags_atom & ON_BORDER)
				continue
			to_chat(xeno, SPAN_WARNING("There's something solid there to stop us from emerging."))
			return

	if(!target_atom || target_atom.density)
		to_chat(xeno, SPAN_NOTICE("We cannot tunnel to there!"))
	ADD_TRAIT(xeno, TRAIT_ABILITY_BURROW_DIGGING, TRAIT_SOURCE_ABILITY("burrow_digging"))
	to_chat(xeno, SPAN_NOTICE("We start tunneling!"))
	var/target_distance = max(get_dist(xeno, target_atom), 1) // Min distance of 1 is to prevent stunlocking
	digging_timer = (target_distance * 10) + world.time
	process_digging(target_atom)

/datum/action/xeno_action/activable/burrow/proc/process_digging(turf/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!HAS_TRAIT(xeno, TRAIT_ABILITY_BURROW_DIGGING))
		return

	if(world.time > digging_timer)
		REMOVE_TRAIT(xeno, TRAIT_ABILITY_BURROW_DIGGING, TRAIT_SOURCE_ABILITY("burrow_digging"))
		do_digging(target_atom)
	if(HAS_TRAIT(xeno, TRAIT_ABILITY_BURROW_DIGGING) && target_atom)
		addtimer(CALLBACK(src, PROC_REF(process_digging), target_atom), 1 SECONDS)

/datum/action/xeno_action/activable/burrow/proc/do_digging(turf/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	to_chat(xeno, SPAN_NOTICE("We tunnel to the destination."))
	xeno.anchored = FALSE
	xeno.forceMove(target_atom)
	end_duration_display()
	burrow_off()

/datum/action/xeno_action/activable/burrow/proc/do_digging_cooldown()
	var/mob/living/carbon/xenomorph/xeno = owner

	used_digging = FALSE
	to_chat(xeno, SPAN_NOTICE("We can now tunnel while burrowed."))
	update_button_icon()




/datum/action/xeno_action/onclick/tremor/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(HAS_TRAIT(xeno, TRAIT_ABILITY_BURROWED))
		to_chat(xeno, SPAN_XENOWARNING("We must be above ground to do this."))
		return

	if(xeno.is_ventcrawling)
		to_chat(xeno, SPAN_XENOWARNING("We must be above ground to do this."))
		return

	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	playsound(xeno, 'sound/effects/alien_footstep_charge3.ogg', 75, 0)
	to_chat(xeno, SPAN_XENOWARNING("We dig ourselves into the ground and cause tremors."))
	xeno.create_stomp()

	for(var/mob/living/carbon/carbon_target in range(7, xeno))
		to_chat(carbon_target, SPAN_WARNING("You struggle to remain on your feet as the ground shakes beneath your feet!"))
		shake_camera(carbon_target, 2, 3)
		if(get_dist(xeno, carbon_target) <= 3 && !xeno.can_not_harm(carbon_target))
			if(carbon_target.mob_size >= MOB_SIZE_BIG)
				carbon_target.apply_effect(1, SLOW)
			else
				carbon_target.apply_effect(1, WEAKEN)
			to_chat(carbon_target, SPAN_WARNING("The violent tremors make you lose your footing!"))

	apply_cooldown()
	return ..()



/datum/action/xeno_action/onclick/build_tunnel/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	XENO_ACTION_CHECK(xeno)

	if(xeno.action_busy)
		to_chat(xeno, SPAN_XENOWARNING("We should finish up what we're doing before digging."))
		return

	var/turf/turf = xeno.loc
	if(!istype(turf)) //logic
		to_chat(xeno, SPAN_XENOWARNING("We can't do that from there."))
		return

	var/area/current_area = get_area(turf)
	if(!turf.can_dig_xeno_tunnel() || !is_ground_level(turf.z) || current_area.flags_area & AREA_NOTUNNEL)
		to_chat(xeno, SPAN_XENOWARNING("We scrape around, but we can't seem to dig through that kind of floor."))
		return

	if(locate(/obj/structure/tunnel) in xeno.loc)
		to_chat(xeno, SPAN_XENOWARNING("There already is a tunnel here."))
		return

	if(locate(/obj/structure/machinery/sentry_holder/landing_zone) in xeno.loc)
		to_chat(xeno, SPAN_XENOWARNING("We can't dig a tunnel with this object in the way."))
		return

	if(xeno.tunnel_delay)
		to_chat(xeno, SPAN_XENOWARNING("We are not ready to dig a tunnel again."))
		return

	if(xeno.get_active_hand())
		to_chat(xeno, SPAN_XENOWARNING("We need an empty claw for this!"))
		return

	if(!xeno.check_plasma(plasma_cost))
		return

	var/area/target_area = get_area(turf)

	if(isnull(target_area) || !(target_area.is_resin_allowed))
		if(!target_area || target_area.flags_area & AREA_UNWEEDABLE)
			to_chat(xeno, SPAN_XENOWARNING("This area is unsuited to host the hive!"))
			return
		to_chat(xeno, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return

	xeno.visible_message(SPAN_XENONOTICE("[xeno] begins digging out a tunnel entrance."),
	SPAN_XENONOTICE("We begin digging out a tunnel entrance."), null, 5)
	if(!do_after(xeno, 10 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		to_chat(xeno, SPAN_WARNING("Our tunnel caves in as we stop digging it."))
		return
	if(!xeno.check_plasma(plasma_cost))
		return
	xeno.visible_message(SPAN_XENONOTICE("\The [xeno] digs out a tunnel entrance."),
	SPAN_XENONOTICE("We dig out an entrance to the tunnel network."), null, 5)

	var/obj/structure/tunnel/tunnelobj = new(turf, xeno.hivenumber)
	xeno.tunnel_delay = 1
	addtimer(CALLBACK(xeno, PROC_REF(cooldown_end)), 4 MINUTES)
	var/msg = strip_html(input("Add a description to the tunnel:", "Tunnel Description") as text|null)
	msg = replace_non_alphanumeric_plus(msg)
	var/description
	if(msg)
		description = msg
		msg = "[msg] ([get_area_name(tunnelobj)])"
		log_admin("[key_name(xeno)] has named a new tunnel \"[msg]\".")
		msg_admin_niche("[xeno]/([key_name(xeno)]) has named a new tunnel \"[msg]\".")
		tunnelobj.tunnel_desc = "[msg]"

	if(xeno.hive.living_xeno_queen || xeno.hive.allow_no_queen_actions)
		for(var/mob/living/carbon/xenomorph/target_for_message as anything in xeno.hive.totalXenos)
			var/overwatch_target = XENO_OVERWATCH_TARGET_HREF
			var/overwatch_src = XENO_OVERWATCH_SRC_HREF
			to_chat(target_for_message, SPAN_XENOANNOUNCE("Hive: A new tunnel[description ? " ([description])" : ""] has been created by [xeno] (<a href='byond://?src=\ref[target_for_message];[overwatch_target]=\ref[xeno];[overwatch_src]=\ref[target_for_message]'>watch</a>) at <b>[get_area_name(tunnelobj)]</b>."))

	xeno.use_plasma(plasma_cost)
	to_chat(xeno, SPAN_NOTICE("We will be ready to dig a new tunnel in 4 minutes."))
	playsound(xeno.loc, 'sound/weapons/pierce.ogg', 25, 1)
	apply_cooldown()

	return ..()

/datum/action/xeno_action/onclick/build_tunnel/proc/cooldown_end()
	var/mob/living/carbon/xenomorph/xeno = owner
	to_chat(xeno, SPAN_NOTICE("We are ready to dig a tunnel again."))
	xeno.tunnel_delay = 0

/mob/living/carbon/xenomorph/burrower/try_fill_trap(obj/effect/alien/resin/trap/target_trap)
	. = ..()
	if(.)
		target_trap.set_state(RESIN_TRAP_ACID3)
