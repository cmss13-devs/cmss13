//// Holds Xeno verbs that don't belong anywhere else.
/mob/living/carbon/xenomorph/verb/hive_status()
	set name = "Hive Status"
	set desc = "Check the status of our current hive."
	set category = "Alien.Hivemind"

	if(!hive)
		return

	if((!hive.living_xeno_queen) && !hive.allow_no_queen_actions)
		to_chat(src, SPAN_WARNING("There is no Queen. We are alone."))
		return

	if(HAS_TRAIT(src, TRAIT_HIVEMIND_INTERFERENCE))
		to_chat(src, SPAN_WARNING("Our psychic connection has been temporarily disabled!"))
		return

	hive.hive_ui.open_hive_status(src)

/mob/living/carbon/xenomorph/verb/hive_alliance_status()
	set name = "Hive Alliance Status"
	set desc = "Check the status of your alliances."
	set category = "Alien.Hivemind"

	if(!hive)
		return

	if(hive.hivenumber == XENO_HIVE_RENEGADE) //Renegade's ability to attack someone depends on IFF settings, not on alliance
		if(!iff_tag)
			to_chat(src, SPAN_NOTICE("You are not obligated to protect anyone."))
			return
		to_chat(src, SPAN_NOTICE("You seem compelled to protect [english_list(iff_tag.faction_groups, "no one")]."))
		return

	if((!hive.living_xeno_queen || Check_WO()) && !hive.allow_no_queen_actions) //No Hive status on WO
		to_chat(src, SPAN_WARNING("There is no Queen. You are alone."))
		return

	if(HAS_TRAIT(src, TRAIT_HIVEMIND_INTERFERENCE))
		to_chat(src, SPAN_WARNING("Our psychic connection has been temporarily disabled!"))
		return

	hive.faction_ui.tgui_interact(src)

/mob/living/carbon/xenomorph/verb/clear_built_structures()
	set name = "Clear Built Structures"
	set desc = "Clears your current built structures that are tied to you."
	set category = "Alien"

	if(!length(built_structures))
		to_chat(usr, SPAN_WARNING("You don't have any built structures!"))
		return

	var/list/options = list()
	for(var/i in built_structures)
		var/atom/A = i
		options[initial(A.name)] = i

	var/input = tgui_input_list(usr, "Choose a structure type to clear", "Clear Built Structures", options, theme="hive_status")

	if(!input)
		return

	var/type = options[input]

	var/cleared_amount = 0
	for(var/i in built_structures[type])
		cleared_amount++
		built_structures[type] -= i
		if(isturf(i))
			var/turf/T = i
			T.ScrapeAway()
			continue
		qdel(i)

	to_chat(usr, SPAN_INFO("Destroyed [cleared_amount] of [input]."))


/mob/living/carbon/xenomorph/verb/toggle_xeno_mobhud()
	set name = "Toggle Xeno Status HUD"
	set desc = "Toggles the health and plasma HUD appearing above Xenomorphs."
	set category = "Alien.Preferences"

	if(xeno_mobhud)
		for(var/datum/mob_hud/hud in GLOB.huds)
			hud.remove_hud_from(usr, usr)
	else
		handle_xeno_hive_hud(hivenumber, TRUE)

	xeno_mobhud = !xeno_mobhud

/mob/living/carbon/xenomorph/verb/toggle_xeno_hostilehud()
	set name = "Toggle Hostile Status HUD"
	set desc = "Toggles the HUD that renders various negative status effects inflicted on humans."
	set category = "Alien.Preferences"

	var/datum/mob_hud/H = GLOB.huds[MOB_HUD_XENO_HOSTILE]
	if (xeno_hostile_hud)
		H.remove_hud_from(usr, usr)
	else
		H.add_hud_to(usr, usr)

	xeno_hostile_hud = !xeno_hostile_hud

/mob/living/carbon/xenomorph/verb/toggle_auto_shove()
	set name = "Toggle Automatic Shove"
	set desc = "Toggles whethever you will automatically shove people as the Queen."
	set category = "Alien.Preferences"


	if (!client || !client.prefs)
		return

	client.prefs.toggle_prefs ^= TOGGLE_AUTO_SHOVE_OFF
	client.prefs.save_preferences()
	if (client.prefs.toggle_prefs & TOGGLE_AUTO_SHOVE_OFF)
		to_chat(src, SPAN_NOTICE("You will no longer automatically shove people in the way as the Queen."))
	else
		to_chat(src, SPAN_NOTICE("You will now automatically shove people in the way as the Queen."))


/mob/living/carbon/xenomorph/verb/ability_deactivation_toggle()
	set name = "Toggle Ability Deactivation"
	set desc = "Toggles whether you can deactivate your currently active ability when re-selecting it."
	set category = "Alien.Preferences"

	if (!client || !client.prefs)
		return

	client.prefs.toggle_prefs ^= TOGGLE_ABILITY_DEACTIVATION_OFF
	client.prefs.save_preferences()
	if (client.prefs.toggle_prefs & TOGGLE_ABILITY_DEACTIVATION_OFF)
		to_chat(src, SPAN_NOTICE("Your current ability can no longer be toggled off when re-selected."))
	else
		to_chat(src, SPAN_NOTICE("Your current ability can be toggled off when re-selected."))

/mob/living/carbon/xenomorph/verb/directional_attack_toggle()
	set name = "Toggle Directional Attacks"
	set desc = "Toggles the use of directional assist attacks."
	set category = "Alien.Preferences"

	if (!client || !client.prefs)
		return

	client.prefs.toggle_prefs ^= TOGGLE_DIRECTIONAL_ATTACK
	client.prefs.save_preferences()
	if(client.prefs.toggle_prefs & TOGGLE_DIRECTIONAL_ATTACK)
		to_chat(src, SPAN_NOTICE("Attacks will now use directional assist."))
	else
		to_chat(src, SPAN_NOTICE("Attacks will no longer use directional assist."))

/mob/living/carbon/xenomorph/cancel_camera()
	. = ..()

	if(observed_xeno)
		overwatch(observed_xeno, TRUE)

/mob/living/carbon/xenomorph/verb/view_tacmaps()
	set name = "View Tacmap"
	set category = "Alien.Essentials"
	GLOB.tacmap_viewer.tgui_interact(src)

/mob/living/carbon/xenomorph/look_up()
	if(is_zoomed)
		to_chat(src, SPAN_WARNING("You cannot look up while zoomed!"))
		return

	. = ..()
// /mob/living/carbon/xenomorph/verb/enter_tree()
// set name = "Enter Techtree"
// set desc = "Enter the Xenomorph techtree."
// set category = "Alien.Techtree"

// var/datum/techtree/T = GET_TREE(TREE_XENO)
// T.enter_mob(src)

/mob/living/carbon/xenomorph/verb/rip_limb()
	set name = "Rip Limb"
	set desc = "Rip off a limb from living pray."
	set category = "Alien"

	if(caste_type != XENO_CASTE_WARRIOR)
		to_chat(src, SPAN_WARNING("Only Warriors can do this!"))
		return

	if(action_busy) //can't stack the attempts
		return

	if(!pulling)
		to_chat(src, SPAN_XENOWARNING("We need to grab a target first!"))
		return

	if(!istype(pulling, /mob/living/carbon/human))
		to_chat(src, SPAN_XENOWARNING("We prefer to rip off limbs from humanoids!"))
		return

	var/mob/living/carbon/human/target_human = pulling
	var/obj/limb/limb = target_human.get_limb(check_zone(zone_selected))

	if(!istype(target_human, /mob/living/carbon/human))
		return

	if(can_not_harm(target_human))
		to_chat(src, SPAN_XENOWARNING("We can't harm this host!"))
		return

	if(!limb || limb.body_part == BODY_FLAG_CHEST || limb.body_part == BODY_FLAG_GROIN || (limb.status & LIMB_DESTROYED)) //Only limbs and head.
		to_chat(src, SPAN_XENOWARNING("We can't rip off that limb."))
		return

	var/limb_time = rand(40,60)
	if(limb.body_part == BODY_FLAG_HEAD)
		limb_time = rand(90,110)

	visible_message(SPAN_XENOWARNING("[src] begins pulling on [target_human]'s [limb.display_name] with incredible strength!"),
	SPAN_XENOWARNING("We begin to pull on [target_human]'s [limb.display_name] with incredible strength!"))

	if(!do_after(src, limb_time, INTERRUPT_ALL|INTERRUPT_DIFF_SELECT_ZONE, BUSY_ICON_HOSTILE) || target_human.stat == DEAD || target_human.status_flags & XENO_HOST)
		to_chat(src, SPAN_NOTICE("We stop ripping off the limb."))
		return

	if(target_human.status_flags & XENO_HOST)
		to_chat(src, SPAN_NOTICE("We detect an embryo inside [target_human] which overwhelms our instinct to rip."))
		return

	if(limb.status & LIMB_DESTROYED)
		return

	if(limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
		limb.take_damage(rand(30,40), 0, 0) // just do more damage
		visible_message(SPAN_XENOWARNING("You hear [target_human]'s [limb.display_name] being pulled beyond its load limits!"),
		SPAN_XENOWARNING("[target_human]'s [limb.display_name] begins to tear apart!"))
	else
		visible_message(SPAN_XENOWARNING("We hear the bones in [target_human]'s [limb.display_name] snap with a sickening crunch!"),
		SPAN_XENOWARNING("[target_human]'s [limb.display_name] bones snap with a satisfying crunch!"))
		limb.take_damage(rand(15,25), 0, 0)
		limb.fracture(100)
	target_human.last_damage_data = create_cause_data(initial(caste_type), src)
	src.attack_log += text("\[[time_stamp()]\] <font color='red'>ripped the [limb.display_name] off of [target_human.name] ([target_human.ckey]) 1/2 progress</font>")
	target_human.attack_log += text("\[[time_stamp()]\] <font color='orange'>had their [limb.display_name] ripped off by [src.name] ([src.ckey]) 1/2 progress</font>")
	log_attack("[src.name] ([src.ckey]) ripped the [limb.display_name] off of [target_human.name] ([target_human.ckey]) 1/2 progress")

	if(!do_after(src, limb_time, INTERRUPT_ALL|INTERRUPT_DIFF_SELECT_ZONE, BUSY_ICON_HOSTILE)  || target_human.stat == DEAD || iszombie(target_human))
		to_chat(src, SPAN_NOTICE("We stop ripping off the limb."))
		return

	if(target_human.status_flags & XENO_HOST)
		to_chat(src, SPAN_NOTICE("We detect an embryo inside [target_human] which overwhelms our instinct to rip."))
		return

	if(limb.status & LIMB_DESTROYED)
		return

	visible_message(SPAN_XENOWARNING("[src] rips [target_human]'s [limb.display_name] away from their body!"),
	SPAN_XENOWARNING("[target_human]'s [limb.display_name] rips away from their body!"))
	src.attack_log += text("\[[time_stamp()]\] <font color='red'>ripped the [limb.display_name] off of [target_human.name] ([target_human.ckey]) 2/2 progress</font>")
	target_human.attack_log += text("\[[time_stamp()]\] <font color='orange'>had their [limb.display_name] ripped off by [src.name] ([src.ckey]) 2/2 progress</font>")
	log_attack("[src.name] ([src.ckey]) ripped the [limb.display_name] off of [target_human.name] ([target_human.ckey]) 2/2 progress")

	limb.droplimb(0, 0, initial(name))
