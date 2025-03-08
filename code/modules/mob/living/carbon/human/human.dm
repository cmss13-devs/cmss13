/mob/living/carbon/human/Initialize(mapload, new_species = null)
	blood_type = pick(7;"O-", 38;"O+", 6;"A-", 34;"A+", 2;"B-", 9;"B+", 1;"AB-", 3;"AB+")
	GLOB.human_mob_list += src
	GLOB.alive_human_list += src
	SShuman.processable_human_list += src

	if(!species)
		if(new_species)
			set_species(new_species)
		else
			set_species()

	create_reagents(1000)
	if(!real_name || !name)
		change_real_name(src, "unknown")
	AddElement(/datum/element/strippable, GLOB.strippable_human_items, TYPE_PROC_REF(/mob/living/carbon/human, should_strip))
	. = ..()

	prev_gender = gender // Debug for plural genders

	if(SSticker?.mode?.hardcore)
		hardcore = TRUE //For WO disposing of corpses

/mob/living/carbon/human/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_MOB_IS_HUMAN
		PF.flags_can_pass_all = PASS_MOB_THRU_HUMAN|PASS_AROUND|PASS_HIGH_OVER_ONLY

/mob/living/carbon/human/prepare_huds()
	..()
	//updating all the mob's hud images
	med_hud_set_health()
	med_hud_set_armor()
	med_hud_set_status()
	sec_hud_set_ID()
	sec_hud_set_security_status()
	hud_set_squad()
	//and display them
	add_to_all_mob_huds()

/mob/living/carbon/human/initialize_pain()
	if(species)
		return species.initialize_pain(src)
	QDEL_NULL(pain)
	pain = new /datum/pain/human(src)

/mob/living/carbon/human/initialize_stamina()
	if(species)
		return species.initialize_stamina(src)
	QDEL_NULL(stamina)
	stamina = new /datum/stamina(src)

/mob/living/carbon/human/Destroy()
	SSround_recording.recorder.stop_tracking(src)
	remove_from_all_mob_huds()
	despawn_fax_responder()
	assigned_equipment_preset = null
	GLOB.human_mob_list -= src
	GLOB.alive_human_list -= src
	SShuman.processable_human_list -= src

	QDEL_NULL_LIST(embedded_items)
	QDEL_LIST_ASSOC_VAL(internal_organs_by_name)
	QDEL_NULL_LIST(limbs)
	if(hud_used)
		QDEL_NULL(hud_used)
	. = ..()

	overlays_standing = null

	//Equipment slots
	wear_suit = null
	w_uniform = null
	shoes = null
	belt = null
	gloves = null
	glasses = null
	head = null
	wear_l_ear = null
	wear_r_ear = null
	wear_id = null
	r_store = null
	l_store = null
	s_store = null

	species = null
	limbs_to_process = null
	brute_mod_override = null
	burn_mod_override = null
	assigned_squad = null
	selected_ability = null
	remembered_dropped_objects = null

/mob/living/carbon/human/get_status_tab_items()
	. = ..()

	. += ""
	if(ishumansynth_strict(src)) // So that yautja or other species dont see the ships security alert
		. += "Security Level: [uppertext(get_security_level())]"

	if(species?.has_species_tab_items)
		var/list/species_tab_items = species.get_status_tab_items(src)
		for(var/tab_item in species_tab_items)
			. += tab_item

	if(faction == FACTION_MARINE & !isnull(SSticker) && !isnull(SSticker.mode) && !isnull(SSticker.mode.active_lz) && !isnull(SSticker.mode.active_lz.loc) && !isnull(SSticker.mode.active_lz.loc.loc))
		. += "Primary LZ: [SSticker.mode.active_lz.loc.loc.name]"

	if(faction == FACTION_MARINE & !isnull(SSticker) && !isnull(SSticker.mode))
		. += "Operation Name: [GLOB.round_statistics.round_name]"

	if(assigned_squad)
		if(assigned_squad.overwatch_officer)
			. += "Overwatch Officer: [assigned_squad.overwatch_officer.get_paygrade()][assigned_squad.overwatch_officer.name]"
		if(assigned_squad.primary_objective)
			. += "Primary Objective: [html_decode(assigned_squad.primary_objective)]"
		if(assigned_squad.secondary_objective)
			. += "Secondary Objective: [html_decode(assigned_squad.secondary_objective)]"
	if(faction == FACTION_MARINE)
		. += ""
		. += "<a href='byond://?MapView=1'>View Tactical Map</a>"
	if(mobility_aura)
		. += "Active Order: MOVE"
	if(protection_aura)
		. += "Active Order: HOLD"
	if(marksman_aura)
		. += "Active Order: FOCUS"

	if(SShijack)
		var/eta_status = SShijack.get_evac_eta()
		if(eta_status)
			. += "Evacuation Goals: [eta_status]"
		if(SShijack.sd_unlocked)
			. += "Self Destruct Status: [SShijack.get_sd_eta()]"

/mob/living/carbon/human/ex_act(severity, direction, datum/cause_data/cause_data)
	if(body_position == LYING_DOWN && direction)
		severity *= EXPLOSION_PRONE_MULTIPLIER



	var/b_loss = 0
	var/f_loss = 0

	var/damage = severity
	var/bomb_armor = getarmor(null, ARMOR_BOMB)

	damage = armor_damage_reduction(GLOB.marine_explosive, damage, bomb_armor)

	last_damage_data = istype(cause_data) ? cause_data : create_cause_data(cause_data)

	if(damage >= EXPLOSION_THRESHOLD_GIB)
		var/oldloc = loc
		gib(last_damage_data)
		create_shrapnel(oldloc, rand(5, 9), direction, 45, /datum/ammo/bullet/shrapnel/light/human, last_damage_data)
		create_shrapnel(oldloc, rand(5, 9), direction, 30, /datum/ammo/bullet/shrapnel/light/human/var1, last_damage_data)
		create_shrapnel(oldloc, rand(5, 9), direction, 45, /datum/ammo/bullet/shrapnel/light/human/var2, last_damage_data)
		return

	if(!HAS_TRAIT(src, TRAIT_EAR_PROTECTION))
		ear_damage += severity * 0.15
		AdjustEarDeafness(severity * 0.5)

	/// Reduces effects by armor value.
	var/bomb_armor_mult = ((CLOTHING_ARMOR_HARDCORE - bomb_armor) * 0.01)

	if(severity >= 30)
		flash_eyes(flash_timer = 4 SECONDS * bomb_armor_mult)
	var/obj/item/item1 = get_active_hand()
	var/obj/item/item2 = get_inactive_hand()
	var/knockdown_value = severity * 0.1
	var/knockout_value = damage * 0.1
	if(SSticker.mode && MODE_HAS_MODIFIER(/datum/gamemode_modifier/weaker_explosions_fire)) //explosions slow down but way less stun
		var/knockdown_minus_armor = min(max(knockdown_value * bomb_armor_mult - 0.5 SECONDS, 0), 0.5 SECONDS) //only explosions with more then 20 severity stun
		apply_effect(floor(knockdown_minus_armor), WEAKEN)
		apply_effect(floor(knockdown_minus_armor), STUN) // Remove this to let people crawl after an explosion. Funny but perhaps not desirable.
		var/slowdown_minus_armor =min(knockout_value * bomb_armor_mult * 0.5, 0.5 SECONDS)
		apply_effect(floor(slowdown_minus_armor), SUPERSLOW)
		apply_effect(floor(slowdown_minus_armor) * 2, SLOW)
		damage *= 0.5 //we reduce after checking eye flash and stun and slow
		severity *= 0.5
	else
		// Stuns are multiplied by 1 reduced by their medium armor value. So a medium of 30 would mean a 30% reduction.
		var/knockdown_minus_armor = min(knockdown_value * bomb_armor_mult, 1 SECONDS)
		apply_effect(floor(knockdown_minus_armor), WEAKEN)
		apply_effect(floor(knockdown_minus_armor), STUN) // Remove this to let people crawl after an explosion. Funny but perhaps not desirable.

		var/knockout_minus_armor = min(knockout_value * bomb_armor_mult * 0.5, 0.5 SECONDS) // the KO time is halved from the knockdown timer. basically same stun time, you just spend less time KO'd.
		apply_effect(floor(knockout_minus_armor), PARALYZE)
		apply_effect(floor(knockout_minus_armor) * 2, DAZE)
	explosion_throw(severity, direction)

	if(item1 && isturf(item1.loc))
		item1.explosion_throw(severity, direction)
	if(item2 && isturf(item2.loc))
		item2.explosion_throw(severity, direction)

	if(damage >= 0)
		b_loss += damage * 0.5
		f_loss += damage * 0.5
	else
		return

	var/update = 0

	//Focus half the blast on one organ
	var/mob/attack_source = last_damage_data?.resolve_mob()
	var/obj/limb/take_blast = pick(limbs)
	if(take_blast)
		update |= take_blast.take_damage(b_loss * 0.5, f_loss * 0.5, used_weapon = "Explosive blast", attack_source = attack_source)
	pain?.apply_pain(b_loss * 0.5, BRUTE)
	pain?.apply_pain(f_loss * 0.5, BURN)

	//Distribute the remaining half all limbs equally
	b_loss *= 0.5
	f_loss *= 0.5

	var/weapon_message = "Explosive Blast"
	var/limb_multiplier = 0.05
	for(var/obj/limb/temp in limbs)
		switch(temp.name)
			if("head")
				limb_multiplier = 0.2
			if("chest")
				limb_multiplier = 0.4
			if("l_arm")
				limb_multiplier = 0.05
			if("r_arm")
				limb_multiplier = 0.05
			if("l_leg")
				limb_multiplier = 0.05
			if("r_leg")
				limb_multiplier = 0.05
			if("r_foot")
				limb_multiplier = 0.05
			if("l_foot")
				limb_multiplier = 0.05
			if("r_arm")
				limb_multiplier = 0.05
			if("l_arm")
				limb_multiplier = 0.05
		update |= temp.take_damage(b_loss * limb_multiplier, f_loss * limb_multiplier, used_weapon = weapon_message, attack_source = attack_source)
		pain.apply_pain(b_loss * limb_multiplier, BRUTE)
		pain.apply_pain(f_loss * limb_multiplier, BURN)
	if(update)
		UpdateDamageIcon()
	return TRUE


/mob/living/carbon/human/attack_animal(mob/living/M as mob)
	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		if(M.attack_sound)
			playsound(loc, M.attack_sound, 25, 1)
		for(var/mob/O in viewers(src, null))
			O.show_message(SPAN_DANGER("<B>[M]</B> [M.attacktext] [src]!"), SHOW_MESSAGE_VISIBLE)
		last_damage_data = create_cause_data(initial(M.name), M)
		M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [key_name(src)]</font>")
		src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [key_name(M)]</font>")
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		var/dam_zone = pick("chest", "l_hand", "r_hand", "l_leg", "r_leg")
		var/obj/limb/affecting = get_limb(rand_zone(dam_zone))
		apply_damage(damage, BRUTE, affecting)


/mob/living/carbon/human/proc/implant_loyalty(mob/living/carbon/human/M, override = FALSE) // Won't override by default.
	if(!CONFIG_GET(flag/use_loyalty_implants) && !override)
		return // Nuh-uh.

	var/obj/item/implant/loyalty/L = new/obj/item/implant/loyalty(M)
	L.imp_in = M
	L.implanted = 1
	var/obj/limb/affected = M.get_limb("head")
	affected.implants += L
	L.part = affected

/mob/living/carbon/human/proc/is_loyalty_implanted(mob/living/carbon/human/M)
	for(var/L in M.contents)
		if(istype(L, /obj/item/implant/loyalty))
			for(var/obj/limb/O in M.limbs)
				if(L in O.implants)
					return TRUE
	return FALSE



/**
 * Handles any storage containers that the human is looking inside when auto-observed.
 */
/mob/living/carbon/human/auto_observed(mob/dead/observer/observer)
	. = ..()

	// If `src` doesn't have an inventory open.
	if(!s_active)
		return

	// Add the storage interface to `observer`'s screen.
	observer.client.add_to_screen(s_active.closer)
	observer.client.add_to_screen(s_active.contents)

	// If the storage has a set number of item slots.
	if(s_active.storage_slots)
		observer.client.add_to_screen(s_active.boxes)
	// If the storage instead has a maximum combined item 'weight'.
	else
		observer.client.add_to_screen(s_active.storage_start)
		observer.client.add_to_screen(s_active.storage_continue)
		observer.client.add_to_screen(s_active.storage_end)

// called when something steps onto a human
// this handles mulebots and vehicles
/mob/living/carbon/human/Crossed(atom/movable/AM)
	if(istype(AM, /obj/structure/machinery/bot/mulebot))
		var/obj/structure/machinery/bot/mulebot/MB = AM
		MB.RunOver(src)

	if(istype(AM, /obj/vehicle))
		var/obj/vehicle/V = AM
		V.RunOver(src)


//gets assignment from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_assignment(if_no_id = "No id", if_no_job = "No job")
	var/obj/item/card/id/id = wear_id
	if(istype(id))
		. = id.assignment
	else
		return if_no_id
	if(!.)
		. = if_no_job
	return

//gets name from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_authentification_name(if_no_id = "Unknown")
	var/obj/item/card/id/id = wear_id
	if(istype(id))
		. = id.registered_name
	else
		return if_no_id
	return

//gets paygrade from ID
//paygrade is a user's actual rank, as defined on their ID.  size 1 returns an abbreviation, size 0 returns the full rank name, the third input is used to override what is returned if no paygrade is assigned.
/mob/living/carbon/human/get_paygrade(size = 1)
	var/obj/item/card/id/id = wear_id
	if(!species || !istype(id))
		return ""
	return species.handle_paygrades(id.paygrade, size, gender)


//repurposed proc. Now it combines get_id_name() and get_face_name() to determine a mob's name variable. Made into a separate proc as it'll be useful elsewhere
/mob/living/carbon/human/proc/get_visible_name()
	if(wear_mask && (wear_mask.flags_inv_hide & HIDEFACE) ) //Wearing a mask which hides our face, use id-name if possible
		return get_id_name("Unknown")
	if(head && (head.flags_inv_hide & HIDEFACE) )
		return get_id_name("Unknown") //Likewise for hats
	var/face_name = get_face_name()
	var/id_name = get_id_name("")
	if(id_name && (id_name != face_name))
		return "[face_name] (as [id_name])"
	return face_name

//Returns "Unknown" if facially unidentifiable and real_name if not. Useful for setting name when headless or when updating a human's name variable
/mob/living/carbon/human/proc/get_face_name()
	var/obj/limb/head/head = get_limb("head")
	if(!head || (head.status & LIMB_DESTROYED) || !real_name) //unidentifiable. use id-name if possible
		return "Unknown"
	return real_name

//gets name from ID or PDA itself, ID inside PDA doesn't matter
//Useful when player is being seen by other mobs
/mob/living/carbon/human/proc/get_id_name(if_no_id = "Unknown")
	. = if_no_id
	if(wear_id)
		var/obj/item/card/id/I = wear_id.GetID()
		if(I)
			return I.registered_name
	return

//gets ID card object from special clothes slot or null.
/mob/living/carbon/human/proc/get_idcard()
	if(wear_id)
		return wear_id.GetID()

//Removed the horrible safety parameter. It was only being used by ninja code anyways.
//Now checks siemens_coefficient of the affected area by default
/mob/living/carbon/human/electrocute_act(shock_damage, obj/source, base_siemens_coeff = 1.0, def_zone = null)
	if(status_flags & GODMODE)
		return FALSE //godmode

	if(!def_zone)
		def_zone = pick("l_hand", "r_hand")

	var/obj/limb/affected_organ = get_limb(check_zone(def_zone))
	var/siemens_coeff = base_siemens_coeff * get_siemens_coefficient_organ(affected_organ)

	return ..(shock_damage, source, siemens_coeff, def_zone)


/mob/living/carbon/human/Topic(href, href_list)

	if(href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		unset_interaction()
		close_browser(src, t1)


	if(href_list["item"])
		if(!usr.is_mob_incapacitated() && Adjacent(usr))
			if(href_list["item"] == "id")
				if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/disable_stripdrag_enemy) && (stat == DEAD || health < HEALTH_THRESHOLD_CRIT) && !get_target_lock(usr.faction_group))
					to_chat(usr, SPAN_WARNING("You can't strip a crit or dead member of another faction!"))
					return
				if(istype(wear_id, /obj/item/card/id/dogtag) && (undefibbable || !skillcheck(usr, SKILL_POLICE, SKILL_POLICE_SKILLED)))
					var/obj/item/card/id/dogtag/DT = wear_id
					if(!DT.dogtag_taken)
						if(stat == DEAD)
							to_chat(usr, SPAN_NOTICE("You take [src]'s information tag, leaving the ID tag"))
							DT.dogtag_taken = TRUE
							DT.icon_state = DT.tags_taken_icon
							var/obj/item/dogtag/D = new(loc)
							D.fallen_references = list(DT.registered_ref)
							D.fallen_names = list(DT.registered_name)
							D.fallen_assgns = list(DT.assignment)
							D.fallen_blood_types = list(DT.blood_type)
							usr.put_in_hands(D)
						else
							to_chat(usr, SPAN_WARNING("You can't take a dogtag's information tag while its owner is alive."))
					else
						to_chat(usr, SPAN_WARNING("Someone's already taken [src]'s information tag."))
					return
			//police skill lets you strip multiple items from someone at once.
			if(!usr.action_busy || skillcheck(usr, SKILL_POLICE, SKILL_POLICE_SKILLED))
				var/slot = href_list["item"]
				var/obj/item/what = get_item_by_slot(slot)
				if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/disable_stripdrag_enemy) && (stat == DEAD || health < HEALTH_THRESHOLD_CRIT) && !get_target_lock(usr.faction_group))
					if(!MODE_HAS_MODIFIER(/datum/gamemode_modifier/disable_strip_essentials) || (what in list(head, wear_suit, w_uniform, shoes)))
						to_chat(usr, SPAN_WARNING("You can't strip a crit or dead member of another faction!"))
						return
				if(what)
					usr.stripPanelUnequip(what,src,slot)
				else
					what = usr.get_active_hand()
					usr.stripPanelEquip(what,src,slot)

	if(href_list["sensor"])
		if(!usr.action_busy && !usr.is_mob_incapacitated() && Adjacent(usr))
			if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/disable_stripdrag_enemy) && (stat == DEAD || health < HEALTH_THRESHOLD_CRIT) && !get_target_lock(usr.faction_group))
				to_chat(usr, SPAN_WARNING("You can't tweak the sensors of a crit or dead member of another faction!"))
				return
			attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their sensors toggled by [key_name(usr)]</font>")
			usr.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to toggle [key_name(src)]'s' sensors</font>")
			var/obj/item/clothing/under/U = w_uniform
			if(QDELETED(U))
				to_chat(usr, "You're not wearing a uniform!")
			else if(U.has_sensor >= UNIFORM_FORCED_SENSORS)
				to_chat(usr, "The controls are locked.")
			else
				var/oldsens = U.has_sensor
				visible_message(SPAN_DANGER("<B>[usr] is trying to modify [src]'s sensors!</B>"), null, null, 4)
				if(do_after(usr, get_strip_delay(usr, src), INTERRUPT_ALL, BUSY_ICON_GENERIC, src, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
					if(U == w_uniform)
						if(U.has_sensor >= UNIFORM_FORCED_SENSORS)
							to_chat(usr, "The controls are locked.")
						else if(U.has_sensor == oldsens)
							U.set_sensors(usr)

	if (href_list["squadfireteam"])

		var/mob/living/carbon/human/target
		var/mob/living/carbon/human/sl
		if(href_list["squadfireteam_target"])
			sl = src
			for(var/mob/living/carbon/human/mar in sl.assigned_squad.marines_list)
				if(href_list["squadfireteam_target"] == "\ref[mar]")
					target = mar
					break
		else
			sl = usr
			target = src

		if(sl.is_mob_incapacitated() || !hasHUD(sl,"squadleader"))
			return

		if(!target || !target.assigned_squad || !target.assigned_squad.squad_leader || target.assigned_squad.squad_leader != sl)
			return

		if(target.squad_status == "K.I.A.")
			to_chat(sl, "[FONT_SIZE_BIG("<font color='red'>You can't assign K.I.A. marines to fireteams.</font>")]")
			return

		target.assigned_squad.manage_fireteams(target)

	if (href_list["squad_status"])
		var/mob/living/carbon/human/target
		for(var/mob/living/carbon/human/mar in assigned_squad.marines_list)
			if(href_list["squad_status_target"] == "\ref[mar]")
				target = mar
				break
		if(!istype(target))
			return

		if(is_mob_incapacitated() && !hasHUD(src,"squadleader"))
			return

		if(!target.assigned_squad || !target.assigned_squad.squad_leader || target.assigned_squad.squad_leader != src)
			return

		assigned_squad.change_squad_status(target)

	if(href_list["criminal"])
		if(hasHUD(usr,"security"))
			var/modified = 0
			var/perpref = null
			if(wear_id)
				var/obj/item/card/id/I = wear_id.GetID()
				if(I)
					perpref = I.registered_ref

			if(perpref)
				for(var/datum/data/record/E in GLOB.data_core.general)
					if(E.fields["ref"] == perpref)
						for(var/datum/data/record/R in GLOB.data_core.security)
							if(R.fields["id"] == E.fields["id"])

								var/setcriminal = tgui_input_list(usr, "Specify a new criminal status for this person.", "Security HUD", list("None", "*Arrest*", "Incarcerated", "Released", "Suspect", "NJP", "Cancel"))

								if(hasHUD(usr, "security"))
									if(setcriminal != "Cancel")
										R.fields["criminal"] = setcriminal
										modified = 1
										sec_hud_set_security_status()


			if(!modified)
				to_chat(usr, SPAN_DANGER("Unable to locate a data core entry for this person."))

	if(href_list["secrecord"])
		if(hasHUD(usr,"security") || isobserver(usr))
			var/perpref = null
			var/read = 0

			if(wear_id)
				var/obj/item/card/id/ID = wear_id.GetID()
				if(istype(ID))
					perpref = ID.registered_ref
			for(var/datum/data/record/E in GLOB.data_core.general)
				if(E.fields["ref"] == perpref)
					for(var/datum/data/record/R in GLOB.data_core.security)
						if(R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"security") || isobserver(usr))
								to_chat(usr, "<b>Name:</b> [R.fields["name"]] <b>Criminal Status:</b> [R.fields["criminal"]]")
								to_chat(usr, "<b>Incidents:</b> [R.fields["incident"]]")
								to_chat(usr, "<a href='byond://?src=\ref[src];secrecordComment=1'>\[View Comment Log\]</a>")
								read = 1

			if(!read)
				to_chat(usr, SPAN_DANGER("Unable to locate a data core entry for this person."))

	if(href_list["secrecordComment"] && (hasHUD(usr,"security") || isobserver(usr)))
		var/perpref = null
		if(wear_id)
			var/obj/item/card/id/ID = wear_id.GetID()
			if(istype(ID))
				perpref = ID.registered_ref

		var/read = 0

		if(perpref)
			for(var/datum/data/record/E in GLOB.data_core.general)
				if(E.fields["ref"] != perpref)
					continue
				for(var/datum/data/record/R in GLOB.data_core.security)
					if(R.fields["id"] != E.fields["id"])
						continue
					read = 1
					if(!islist(R.fields["comments"]))
						to_chat(usr, "<br /><b>No comments</b>")
						continue
					var/comment_markup = ""
					for(var/com_i in R.fields["comments"])
						var/comment = R.fields["comments"][com_i]
						comment_markup += text("<br /><b>[] / [] ([])</b><br />", comment["created_at"], comment["created_by"]["name"], comment["created_by"]["rank"])
						if (isnull(comment["deleted_by"]))
							comment_markup += text("[]<br />", comment["entry"])
							continue
						comment_markup += text("<i>Comment deleted by [] at []</i><br />", comment["deleted_by"], comment["deleted_at"])
					to_chat(usr, comment_markup)
					if(!isobserver(usr))
						to_chat(usr, "<a href='byond://?src=\ref[src];secrecordadd=1'>\[Add comment\]</a><br />")

		if(!read)
			to_chat(usr, SPAN_DANGER("Unable to locate a data core entry for this person."))

	if(href_list["secrecordadd"] && hasHUD(usr,"security"))
		var/perpref = null
		if(wear_id)
			var/obj/item/card/id/ID = wear_id.GetID()
			if(istype(ID))
				perpref = ID.registered_ref

		if(perpref)
			for(var/datum/data/record/E in GLOB.data_core.general)
				if(E.fields["ref"] != perpref)
					continue
				for(var/datum/data/record/R in GLOB.data_core.security)
					if(R.fields["id"] != E.fields["id"])
						continue
					var/t1 = copytext(trim(strip_html(input("Your name and time will be added to this new comment.", "Add a comment", null, null)  as message)), 1, MAX_MESSAGE_LEN)
					if(!(t1) || usr.stat || usr.is_mob_restrained())
						return
					var/created_at = text("[]&nbsp;&nbsp;[]&nbsp;&nbsp;[]", time2text(world.realtime, "MMM DD"), time2text(world.time, "[worldtime2text()]:ss"), GLOB.game_year)
					var/new_comment = list("entry" = t1, "created_by" = list("name" = "", "rank" = ""), "deleted_by" = null, "deleted_at" = null, "created_at" = created_at)
					if(istype(usr,/mob/living/carbon/human))
						var/mob/living/carbon/human/U = usr
						new_comment["created_by"]["name"] = U.get_authentification_name()
						new_comment["created_by"]["rank"] = U.get_assignment()
					if(!islist(R.fields["comments"]))
						R.fields["comments"] = list("1" = new_comment)
					else
						var/new_com_i = length(R.fields["comments"]) + 1
						R.fields["comments"]["[new_com_i]"] = new_comment
					to_chat(usr, "You have added a new comment to the Security Record of [R.fields["name"]]. <a href='byond://?src=\ref[src];secrecordComment=1'>\[View Comment Log\]</a>")

	if(href_list["medical"])
		if(hasHUD(usr,"medical"))
			var/perpref = null
			if(wear_id)
				var/obj/item/card/id/ID = wear_id.GetID()
				if(istype(ID))
					perpref = ID.registered_ref

			var/modified = FALSE

			if(perpref)
				for(var/datum/data/record/E in GLOB.data_core.general)
					if(E.fields["ref"] == perpref)
						for(var/datum/data/record/R in GLOB.data_core.general)
							if(R.fields["id"] == E.fields["id"])

								var/setmedical = tgui_input_list(usr, "Specify a new medical status for this person.", "Medical HUD", R.fields["p_stat"], list("*SSD*", "*Deceased*", "Physically Unfit", "Active", "Disabled", "Cancel"))

								if(hasHUD(usr,"medical"))
									if(setmedical != "Cancel")
										R.fields["p_stat"] = setmedical
										modified = 1

										spawn()
											if(istype(usr,/mob/living/carbon/human))
												var/mob/living/carbon/human/U = usr
												U.handle_regular_hud_updates()

			if(!modified)
				to_chat(usr, SPAN_DANGER("Unable to locate a data core entry for this person."))

	if(href_list["medrecord"])
		if(hasHUD(usr,"medical"))
			var/perpref = null
			if(wear_id)
				var/obj/item/card/id/ID = wear_id.GetID()
				if(istype(ID))
					perpref = ID.registered_ref

			var/read = FALSE

			if(perpref)
				for(var/datum/data/record/E in GLOB.data_core.general)
					if(E.fields["ref"] == perpref)
						for(var/datum/data/record/R as anything in GLOB.data_core.medical)
							if(R.fields["id"] == E.fields["id"])
								if(hasHUD(usr,"medical"))
									to_chat(usr, "<b>Name:</b> [R.fields["name"]] <b>Blood Type:</b> [R.fields["b_type"]]")
									to_chat(usr, "<b>Minor Disabilities:</b> [R.fields["mi_dis"]]")
									to_chat(usr, "<b>Details:</b> [R.fields["mi_dis_d"]]")
									to_chat(usr, "<b>Major Disabilities:</b> [R.fields["ma_dis"]]")
									to_chat(usr, "<b>Details:</b> [R.fields["ma_dis_d"]]")
									to_chat(usr, "<b>Notes:</b> [R.fields["notes"]]")
									to_chat(usr, "<a href='byond://?src=\ref[src];medrecordComment=1'>\[View Comment Log\]</a>")
									read = 1

			if(!read)
				to_chat(usr, SPAN_DANGER("Unable to locate a data core entry for this person."))

	if(href_list["medrecordComment"])
		if(hasHUD(usr,"medical"))
			var/perpref = null
			if(wear_id)
				var/obj/item/card/id/ID = wear_id.GetID()
				if(istype(ID))
					perpref = ID.registered_ref

			var/read = FALSE

			if(perpref)
				for(var/datum/data/record/E in GLOB.data_core.general)
					if(E.fields["ref"] == perpref)
						for(var/datum/data/record/R as anything in GLOB.data_core.medical)
							if(R.fields["id"] == E.fields["id"])
								if(hasHUD(usr,"medical"))
									read = 1
									var/counter = 1
									while(R.fields["com_[counter]"])
										to_chat(usr, R.fields["com_[counter]"])
										counter++
									if(counter == 1)
										to_chat(usr, "No comment found")
									to_chat(usr, "<a href='byond://?src=\ref[src];medrecordadd=1'>\[Add comment\]</a>")

			if(!read)
				to_chat(usr, SPAN_DANGER("Unable to locate a data core entry for this person."))

	if(href_list["medrecordadd"])
		if(hasHUD(usr,"medical"))
			var/perpref = null
			if(wear_id)
				var/obj/item/card/id/ID = wear_id.GetID()
				if(istype(ID))
					perpref = ID.registered_ref

			if(perpref)
				for(var/datum/data/record/E in GLOB.data_core.general)
					if(E.fields["ref"] == perpref)
						for(var/datum/data/record/R as anything in GLOB.data_core.medical)
							if(R.fields["id"] == E.fields["id"])
								if(hasHUD(usr,"medical"))
									var/t1 = strip_html(input("Add Comment:", "Med. records", null, null)  as message)
									if(!(t1) || usr.stat || usr.is_mob_restrained() || !(hasHUD(usr,"medical")) )
										return
									var/counter = 1
									while(R.fields[text("com_[]", counter)])
										counter++
									if(istype(usr,/mob/living/carbon/human))
										var/mob/living/carbon/human/U = usr
										R.fields[text("com_[counter]")] = text("Made by [U.get_authentification_name()] ([U.get_assignment()]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [GLOB.game_year]<BR>[t1]")

	if(href_list["medholocard"])
		change_holo_card(usr)

	if(href_list["lookitem"])
		var/obj/item/I = locate(href_list["lookitem"])
		if(istype(I))
			I.examine(usr)

	if(href_list["flavor_change"])
		if(usr.client != client)
			return

		switch(href_list["flavor_change"])
			if("done")
				close_browser(src, "flavor_changes")
				return
			if("general")
				var/msg = input(usr,"Update the general description of your character. This will be shown regardless of clothing, and may include OOC notes and preferences.","Flavor Text",html_decode(flavor_texts[href_list["flavor_change"]])) as message
				if(msg != null)
					msg = copytext(msg, 1, MAX_MESSAGE_LEN)
					msg = html_encode(msg)
				flavor_texts[href_list["flavor_change"]] = msg
				return
			else
				var/msg = input(usr,"Update the flavor text for your [href_list["flavor_change"]].","Flavor Text",html_decode(flavor_texts[href_list["flavor_change"]])) as message
				if(msg != null)
					msg = copytext(msg, 1, MAX_MESSAGE_LEN)
					msg = html_encode(msg)
				flavor_texts[href_list["flavor_change"]] = msg
				set_flavor()
				return

	if(href_list["scanreport"])
		if(hasHUD(usr,"medical"))
			if(!skillcheck(usr, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
				to_chat(usr, SPAN_WARNING("You're not trained to use this."))
				return
			if(!has_species(src, "Human"))
				to_chat(usr, SPAN_WARNING("This only works on humans."))
				return
			if(get_dist(usr, src) > 7)
				to_chat(usr, SPAN_WARNING("[src] is too far away."))
				return

			var/me_ref = WEAKREF(src)
			for(var/datum/data/record/R as anything in GLOB.data_core.medical)
				if(R.fields["ref"] == me_ref)
					if(R.fields["last_scan_time"] && R.fields["last_scan_result"])
						tgui_interact(usr)
					break

	if(href_list["check_status"])
		if(!usr.Adjacent(src))
			return
		var/mob/living/carbon/human/user = usr
		user.check_status(src)

	if(href_list["use_stethoscope"])
		var/mob/living/carbon/human/user = usr
		var/obj/item/clothing/accessory/stethoscope/stethoscope = locate() in user.w_uniform
		if(!stethoscope || !user.Adjacent(src))
			return

		stethoscope.attack(src, user)

	..()
	return

/mob/living/carbon/human/proc/change_holo_card(mob/user)
	if(isobserver(user))
		return
	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		// Removing your own holocard when you are not trained
		if(user == src && holo_card_color)
			if(tgui_alert(user, "Are you sure you want to reset your own holocard?", "Resetting Holocard", list("Yes", "No")) != "Yes")
				return
			holo_card_color = null
			to_chat(user, SPAN_NOTICE("You reset your holocard."))
			hud_set_holocard()
			return
		to_chat(user, SPAN_WARNING("You're not trained to use this."))
		return
	if(!has_species(src, "Human"))
		to_chat(user, SPAN_WARNING("Triage holocards only works on humans."))
		return
	var/newcolor = tgui_input_list(user, "Choose a triage holo card to add to the patient:", "Triage holo card", list("black", "red", "orange", "purple", "none"))
	if(!newcolor)
		return
	if(get_dist(user, src) > 7)
		to_chat(user, SPAN_WARNING("[src] is too far away."))
		return
	if(newcolor == "none")
		if(!holo_card_color)
			return
		holo_card_color = null
		to_chat(user, SPAN_NOTICE("You remove the holo card on [src]."))
	else if(newcolor != holo_card_color)
		if(newcolor == "black" && is_revivable() && check_tod())
			to_chat(user, SPAN_WARNING("They are yet saveable."))
			return
		holo_card_color = newcolor
		to_chat(user, SPAN_NOTICE("You add a [newcolor] holo card on [src]."))
	hud_set_holocard()

/mob/living/carbon/human/tgui_interact(mob/user, datum/tgui/ui) // I'M SORRY, SO FUCKING SORRY
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HealthScan", "Last Medical Scan of [src]")
		ui.open()
		ui.set_autoupdate(FALSE)

/mob/living/carbon/human/ui_data(mob/user)
	var/me_ref = WEAKREF(src)
	for(var/datum/data/record/R as anything in GLOB.data_core.medical)
		if(R.fields["ref"] == me_ref)
			if(R.fields["last_tgui_scan_result"])
				return R.fields["last_tgui_scan_result"]

/mob/living/carbon/human/ui_state(mob/user)
	return GLOB.not_incapacitated_state

///get_eye_protection()
///Returns a number between -1 to 2
/mob/living/carbon/human/get_eye_protection()
	var/number = 0

	if(species && !species.has_organ["eyes"])
		return EYE_PROTECTION_WELDING //No eyes, can't hurt them.

	if(!internal_organs_by_name)
		return EYE_PROTECTION_WELDING
	var/datum/internal_organ/eyes/I = internal_organs_by_name["eyes"]
	if(I)
		if(I.cut_away)
			return EYE_PROTECTION_WELDING
		if(I.robotic == ORGAN_ROBOT)
			return EYE_PROTECTION_WELDING
	else
		return EYE_PROTECTION_WELDING

	if(istype(head, /obj/item/clothing))
		var/obj/item/clothing/C = head
		number += C.eye_protection
	if(istype(wear_mask, /obj/item/clothing))
		number += wear_mask.eye_protection
	if(glasses)
		number += glasses.eye_protection

	return number


/mob/living/carbon/human/abiotic(full_body = 0)
	if(full_body && ((l_hand && !( l_hand.flags_item & ITEM_ABSTRACT)) || (r_hand && !( r_hand.flags_item & ITEM_ABSTRACT)) || (back || wear_mask || head || shoes || w_uniform || wear_suit || glasses || wear_l_ear || wear_r_ear || gloves)))
		return TRUE

	if((l_hand && !(l_hand.flags_item & ITEM_ABSTRACT)) || (r_hand && !(r_hand.flags_item & ITEM_ABSTRACT)) )
		return TRUE

	return FALSE

/mob/living/carbon/human/get_species()
	if(!species)
		set_species()
	return species.name

/mob/living/carbon/human/proc/vomit()

	if(species.flags & IS_SYNTHETIC)
		return //Machines don't throw up.

	if(stat == 2) //Corpses don't puke
		return

	if(!lastpuke)
		lastpuke = 1
		to_chat(src, SPAN_WARNING("You feel nauseous..."))
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), src, "You feel like you are about to throw up!"), 15 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(do_vomit)), 25 SECONDS)

/mob/living/carbon/human/proc/do_vomit()
	apply_effect(5, STUN)
	if(stat == 2) //One last corpse check
		return
	src.visible_message(SPAN_WARNING("[src] throws up!"), SPAN_WARNING("You throw up!"), null, 5)
	playsound(loc, 'sound/effects/splat.ogg', 25, 1, 7)

	var/turf/location = loc
	if(istype(location, /turf))
		location.add_vomit_floor(src, 1)

	nutrition -= 40
	apply_damage(-3, TOX)
	addtimer(VARSET_CALLBACK(src, lastpuke, FALSE), 35 SECONDS)

/mob/living/carbon/human/proc/get_visible_gender()
	if(wear_suit && wear_suit.flags_inv_hide & HIDEJUMPSUIT && ((head && head.flags_inv_hide & HIDEMASK) || wear_mask))
		return NEUTER
	return gender

/mob/living/carbon/human/revive(keep_viruses)
	var/obj/limb/head/h = get_limb("head")
	if(QDELETED(h))
		h = get_limb("synthetic head")

	if(species && !(species.flags & NO_BLOOD))
		restore_blood()

	//try to find the brain player in the decapitated head and put them back in control of the human
	if(!client && !mind) //if another player took control of the human, we don't want to kick them out.
		for(var/i in GLOB.head_limb_list)
			var/obj/item/limb/head/H = i
			if(!H.brainmob)
				continue
			if(H.brainmob.real_name != src.real_name)
				continue
			if(!H.brainmob.mind)
				continue
			H.brainmob.mind.transfer_to(src)
			qdel(H)

	if(!keep_viruses)
		for(var/datum/disease/virus in viruses)
			if(istype(virus, /datum/disease/black_goo))
				continue
			virus.cure(0)

	undefibbable = FALSE

	//Remove any larva.
	var/obj/item/alien_embryo/A = locate() in src
	if(A)
		var/mob/living/carbon/xenomorph/larva/L = locate() in src //if the larva was fully grown, ready to burst.
		if(L)
			qdel(L)
		qdel(A)
		status_flags &= ~XENO_HOST

	..()

/// Returns whether this person has a broken heart but is otherwise revivable
/mob/living/carbon/human/proc/is_heart_broken()
	var/datum/internal_organ/heart/heart = internal_organs_by_name["heart"]
	return heart && heart.organ_status >= ORGAN_BROKEN && check_tod() && is_revivable(ignore_heart = TRUE)

/mob/living/carbon/human/proc/is_lung_ruptured()
	var/datum/internal_organ/lungs/L = internal_organs_by_name["lungs"]
	return L && L.organ_status >= ORGAN_BRUISED

/mob/living/carbon/human/proc/rupture_lung()
	var/datum/internal_organ/lungs/L = internal_organs_by_name["lungs"]

	if(L && !L.organ_status >= ORGAN_BRUISED)
		src.custom_pain("You feel a stabbing pain in your chest!", 1)
		L.damage = L.min_bruised_damage

/mob/living/carbon/human/get_visible_implants(class = 0)
	var/list/visible_objects = list()
	for(var/obj/item/W in embedded_items)
		if(!istype(W, /obj/item/shard/shrapnel))
			visible_objects += W
	return visible_objects


/mob/living/carbon/human/proc/handle_embedded_objects()
	if((stat == DEAD) || body_position || buckled) // Shouldnt be needed, but better safe than sorry
		return

	for(var/obj/item/W in embedded_items)
		var/obj/limb/organ = W.embedded_organ
		// Check if shrapnel
		if(istype(W, /obj/item/large_shrapnel))
			var/obj/item/large_shrapnel/embedded = W
			embedded.on_embedded_movement(src)
		else if(istype(W, /obj/item/shard/shrapnel))
			var/obj/item/shard/shrapnel/embedded = W
			embedded.on_embedded_movement(src)
		// Check if its a sharp weapon
		else if(is_sharp(W))
			if(organ.status & LIMB_SPLINTED) //Splints prevent movement.
				continue
			if(prob(20)) //Let's not make throwing knives too good in HvH
				organ.take_damage(rand(1,2), 0, 0)
		if(prob(30)) // Spam chat less
			to_chat(src, SPAN_HIGHDANGER("Your movement jostles [W] in your [organ.display_name] painfully."))

/mob/living/carbon/human/proc/check_status(mob/living/carbon/human/target)
	if(is_dead() || is_mob_restrained())
		return
	///Final message detailing injuries on the target.
	var/msg
	///Is the target the user or somebody else?
	var/self = (target == src)
	to_chat(usr,SPAN_NOTICE("You [self ? "take a moment to analyze yourself." : "start analyzing [target.name]."]"))

	if(self)
		var/list/broken_limbs = target.get_broken_limbs() - list("chest","head","groin")
		if(length(broken_limbs))
			msg += "Your [english_list(broken_limbs)] [length(broken_limbs) > 1 ? "are" : "is"] broken.\n"
	if(target.toxloss > 20)
		msg += "[self ? "Your" : "Their"] skin is slightly green.\n"

	if(target.is_bleeding())
		msg += "[self ? "You" : "They"] have bleeding wounds on [self ? "your" : "their"] body.\n"

	if(!self && skillcheck(usr, SKILL_SURGERY, SKILL_SURGERY_NOVICE))
		for(var/datum/effects/bleeding/internal/internal_bleed in target.effects_list)
			msg += "They have bloating and discoloration on their [internal_bleed.limb.display_name].\n"

	switch(target.stat)
		if(DEAD)
			if(target.check_tod() && target.is_revivable())
				msg += "They're not breathing."
			else
				if(has_limb("head"))
					msg += "Their eyes have gone blank, there are no signs of life."
				else
					msg += "They are definitely dead."
		if(UNCONSCIOUS)
			msg += "They seem to be unconscious.\n"
		if(CONSCIOUS)
			msg += "[self ? "You're" : "They're"] alive and breathing."

	to_chat(src, SPAN_WARNING(msg))


/mob/living/carbon/human/verb/view_manifest()
	set name = "View Crew Manifest"
	set category = "IC"

	if(faction != FACTION_MARINE && !((faction in FACTION_LIST_WY) || faction == FACTION_FAX))
		to_chat(usr, SPAN_WARNING("You have no access to [MAIN_SHIP_NAME] crew manifest."))
		return
	GLOB.crew_manifest.open_ui(src)

/mob/living/carbon/human/verb/view_objective_memory()
	set name = "View intel objectives"
	set category = "IC"

	if(!mind)
		to_chat(src, "The game appears to have misplaced your mind datum.")
		return

	if(!skillcheck(usr, SKILL_INTEL, SKILL_INTEL_TRAINED) || faction != FACTION_MARINE && !(faction in FACTION_LIST_WY))
		to_chat(usr, SPAN_WARNING("You have no access to the [MAIN_SHIP_NAME] intel network."))
		return

	mind.view_objective_memories(src)

/mob/living/carbon/human/verb/view_research_objective_memory()
	set name = "View research objectives"
	set category = "IC"

	if(!mind)
		to_chat(src, "The game appears to have misplaced your mind datum.")
		return

	if(!skillcheck(usr, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED) || !(FACTION_MARINE in get_id_faction_group()))
		to_chat(usr, SPAN_WARNING("You have no access to the [MAIN_SHIP_NAME] research network."))
		return

	mind.view_research_objective_memories(src)

/mob/living/carbon/human/verb/purge_objective_memory()
	set name = "Reset view objectives"
	set category = "OOC.Fix"

	if(!mind)
		to_chat(src, "The game appears to have misplaced your mind datum.")
		return

	if(tgui_alert(src, "Remove the faulty entry?", "Confirm", list("Yes", "No"), 10 SECONDS) == "Yes")
		for(var/datum/cm_objective/retrieve_data/disk/Objective in src.mind.objective_memory.disks)
			if(!Objective.disk.disk_color || !Objective.disk.display_color)
				src.mind.objective_memory.disks -= Objective
	else
		return

	if(tgui_alert(src, "Did it work?", "Confirm", list("Yes", "No"), 10 SECONDS) == "No")
		for(var/datum/cm_objective/Objective in src.mind.objective_memory.disks)
			src.mind.objective_memory.disks -= Objective

/mob/living/carbon/human/proc/set_species(new_species, default_color)
	if(!new_species)
		new_species = "Human"

	if(species)
		if(species.name && species.name == new_species) //we're already that species.
			return

		// Clear out their species abilities.
		species.remove_inherent_verbs(src)

	var/datum/species/oldspecies = species

	species = GLOB.all_species[new_species]

	// If an invalid new_species value is passed, just default to human
	if (!istype(species))
		species = GLOB.all_species["Human"]

	if(oldspecies)
		//additional things to change when we're no longer that species
		oldspecies.post_species_loss(src)
		if(oldspecies.weed_slowdown_mult != 1)
			UnregisterSignal(src, COMSIG_MOB_WEED_SLOWDOWN)

	mob_flags = species.mob_flags
	for(var/T in species.mob_inherent_traits)
		ADD_TRAIT(src, T, TRAIT_SOURCE_SPECIES)

	if(species.weed_slowdown_mult != 1)
		RegisterSignal(src, COMSIG_MOB_WEED_SLOWDOWN, PROC_REF(handle_weed_slowdown))

	species.create_organs(src)

	if(species.base_color && default_color)
		//Apply color.
		r_skin = hex2num(copytext(species.base_color,2,4))
		g_skin = hex2num(copytext(species.base_color,4,6))
		b_skin = hex2num(copytext(species.base_color,6,8))
	else
		r_skin = 0
		g_skin = 0
		b_skin = 0

	if(species.hair_color)
		r_hair = hex2num(copytext(species.hair_color, 2, 4))
		g_hair = hex2num(copytext(species.hair_color, 4, 6))
		b_hair = hex2num(copytext(species.hair_color, 6, 8))

	// Switches old pain and stamina over
	species.initialize_pain(src)
	species.initialize_stamina(src)
	species.handle_post_spawn(src)

	INVOKE_ASYNC(src, PROC_REF(regenerate_icons))
	INVOKE_ASYNC(src, PROC_REF(restore_blood))
	INVOKE_ASYNC(src, PROC_REF(update_body), 1, 0)
	if(!(species.flags & HAS_UNDERWEAR))
		INVOKE_ASYNC(src, PROC_REF(remove_underwear))

	default_lighting_alpha = species.default_lighting_alpha
	update_sight()

	if(species)
		return TRUE
	else
		return FALSE

/mob/living/carbon/human/proc/handle_weed_slowdown(mob/user, list/slowdata)
	SIGNAL_HANDLER
	slowdata["movement_slowdown"] *= species.weed_slowdown_mult

/mob/living/carbon/human/print_flavor_text()
	var/list/equipment = list(src.head,src.wear_mask,src.glasses,src.w_uniform,src.wear_suit,src.gloves,src.shoes)
	var/head_exposed = 1
	var/face_exposed = 1
	var/eyes_exposed = 1
	var/torso_exposed = 1
	var/arms_exposed = 1
	var/legs_exposed = 1
	var/hands_exposed = 1
	var/feet_exposed = 1

	for(var/obj/item/clothing/C in equipment)
		if(C.flags_armor_protection & BODY_FLAG_HEAD)
			head_exposed = 0
		if(C.flags_armor_protection & BODY_FLAG_FACE)
			face_exposed = 0
		if(C.flags_armor_protection & BODY_FLAG_EYES)
			eyes_exposed = 0
		if(C.flags_armor_protection & BODY_FLAG_CHEST)
			torso_exposed = 0
		if(C.flags_armor_protection & BODY_FLAG_ARMS)
			arms_exposed = 0
		if(C.flags_armor_protection & BODY_FLAG_HANDS)
			hands_exposed = 0
		if(C.flags_armor_protection & BODY_FLAG_LEGS)
			legs_exposed = 0
		if(C.flags_armor_protection & BODY_FLAG_FEET)
			feet_exposed = 0

	flavor_text = flavor_texts["general"]
	flavor_text += "\n\n"
	for(var/T in flavor_texts)
		if(flavor_texts[T] && flavor_texts[T] != "")
			if((T == "head" && head_exposed) || (T == "face" && face_exposed) || (T == "eyes" && eyes_exposed) || (T == "torso" && torso_exposed) || (T == "arms" && arms_exposed) || (T == "hands" && hands_exposed) || (T == "legs" && legs_exposed) || (T == "feet" && feet_exposed))
				flavor_text += flavor_texts[T]
				flavor_text += "\n\n"
	return ..()



/mob/living/carbon/human/proc/vomit_on_floor()
	if(stat)
		return
	var/turf/T = get_turf(src)
	visible_message(SPAN_DANGER("[src] vomits on the floor!"), null, null, 5)
	nutrition -= 20
	apply_damage(-3, TOX)
	playsound(T, 'sound/effects/splat.ogg', 25, 1, 7)
	T.add_vomit_floor(src)

/mob/living/carbon/human/slip(slip_source_name, stun_level, weaken_level, run_only, override_noslip, slide_steps)
	if(shoes && !override_noslip) // && (shoes.flags_inventory & NOSLIPPING)) // no more slipping if you have shoes on. -spookydonut
		return FALSE
	. = ..()



//very similar to xeno's queen_locator() but this is for locating squad leader.
/mob/living/carbon/human/proc/locate_squad_leader(tracker_setting = TRACKER_SL)
	if(!hud_used)
		return

	var/mob/living/carbon/human/H
	var/tracking_suffix = ""

	hud_used.locate_leader.icon_state = "trackoff"

	var/static/list/squad_leader_trackers = list(
		TRACKER_ASL = /datum/squad/marine/alpha,
		TRACKER_BSL = /datum/squad/marine/bravo,
		TRACKER_CSL = /datum/squad/marine/charlie,
		TRACKER_DSL = /datum/squad/marine/delta,
		TRACKER_ESL = /datum/squad/marine/echo,
		TRACKER_FSL = /datum/squad/marine/cryo
	)
	switch(tracker_setting)
		if(TRACKER_SL)
			if(assigned_squad)
				H = assigned_squad.squad_leader
		if(TRACKER_LZ)
			var/obj/structure/machinery/computer/shuttle_control/C = SSticker.mode.active_lz
			if(!C) //no LZ selected
				hud_used.locate_leader.icon_state = "trackoff"
			else if(C.z != src.z || get_dist(src,C) < 1)
				hud_used.locate_leader.icon_state = "trackondirect_lz"
			else
				hud_used.locate_leader.setDir(Get_Compass_Dir(src,C))
				hud_used.locate_leader.icon_state = "trackon_lz"
			return
		if(TRACKER_FTL)
			if(assigned_squad)
				if(assigned_fireteam)
					H = assigned_squad.fireteam_leaders[assigned_fireteam]
					tracking_suffix = "_tl"
		if(TRACKER_CO)
			H = GLOB.marine_leaders[JOB_CO]
			tracking_suffix = "_co"
		if(TRACKER_XO)
			H = GLOB.marine_leaders[JOB_XO]
			tracking_suffix = "_xo"
		if(TRACKER_CMP)
			var/datum/job/command/warrant/cmp_job = GLOB.RoleAuthority.roles_for_mode[JOB_CHIEF_POLICE]
			if(cmp_job?.active_cmp)
				H = cmp_job.active_cmp
			tracking_suffix = "_cmp"
		if(TRACKER_CL)
			var/datum/job/civilian/liaison/liaison_job = GLOB.RoleAuthority.roles_for_mode[JOB_CORPORATE_LIAISON]
			if(liaison_job?.active_liaison)
				H = liaison_job.active_liaison
			tracking_suffix = "_cl"
		else
			if(tracker_setting in squad_leader_trackers)
				var/datum/squad/S = GLOB.RoleAuthority.squads_by_type[squad_leader_trackers[tracker_setting]]
				H = S.squad_leader
				tracking_suffix = tracker_setting

	if(!H || H.w_uniform?.sensor_mode != SENSOR_MODE_LOCATION)
		return

	var/atom/tracking_atom = H
	if(tracking_atom.z != src.z && SSinterior.in_interior(tracking_atom))
		var/datum/interior/interior = SSinterior.get_interior_by_coords(tracking_atom.x, tracking_atom.y, tracking_atom.z)
		var/atom/exterior = interior.exterior
		if(exterior)
			tracking_atom = exterior

	if(tracking_atom.z != src.z || get_dist(src, tracking_atom) < 1 || src == tracking_atom)
		hud_used.locate_leader.icon_state = "trackondirect[tracking_suffix]"
	else
		hud_used.locate_leader.setDir(Get_Compass_Dir(src, tracking_atom))
		hud_used.locate_leader.icon_state = "trackon[tracking_suffix]"

/mob/living/carbon/proc/locate_nearest_nuke()
	if(!GLOB.bomb_set)
		return
	var/obj/structure/machinery/nuclearbomb/N
	for(var/obj/structure/machinery/nuclearbomb/bomb in world)
		if(!istype(N) || N.z != src.z )
			N = bomb
		if(bomb.z == src.z && get_dist(src,bomb) < get_dist(src,N))
			N = bomb
	if(N.z != src.z || !N)
		hud_used.locate_nuke.icon_state = "trackoff"
		return

	if(get_dist(src,N) < 1)
		hud_used.locate_nuke.icon_state = "nuke_trackondirect"
	else
		hud_used.locate_nuke.setDir(Get_Compass_Dir(src,N))
		hud_used.locate_nuke.icon_state = "nuke_trackon"




/mob/proc/update_sight()
	sync_lighting_plane_alpha()

/mob/living/carbon/human/update_sight()
	if(SEND_SIGNAL(src, COMSIG_HUMAN_UPDATE_SIGHT) & COMPONENT_OVERRIDE_UPDATE_SIGHT)
		return

	sight &= ~BLIND // Never have blind on by default

	lighting_alpha = default_lighting_alpha
	sight &= ~(SEE_TURFS|SEE_MOBS|SEE_OBJS|SEE_BLACKNESS)
	see_in_dark = species.darksight
	sight |= species.flags_sight
	if(glasses)
		process_glasses(glasses)

	if(!(sight & SEE_TURFS) && !(sight & SEE_MOBS) && !(sight & SEE_OBJS))
		sight |= SEE_BLACKNESS

	SEND_SIGNAL(src, COMSIG_HUMAN_POST_UPDATE_SIGHT)
	sync_lighting_plane_alpha()


/mob/proc/update_tint()

/mob/living/carbon/human/update_tint()
	var/tint_level = VISION_IMPAIR_NONE

	if(head && head.vision_impair)
		tint_level += head.vision_impair

	if(glasses && glasses.vision_impair)
		tint_level += glasses.vision_impair

	if(wear_mask && wear_mask.vision_impair)
		tint_level += wear_mask.vision_impair

	if(tint_level > VISION_IMPAIR_MAX)
		tint_level = VISION_IMPAIR_MAX

	if(tint_level)
		if(tint_level == VISION_IMPAIR_MAX)
			overlay_fullscreen("tint", /atom/movable/screen/fullscreen/blind)
		else
			overlay_fullscreen("tint", /atom/movable/screen/fullscreen/impaired, tint_level)
		return TRUE
	else
		clear_fullscreen("tint", 0)
		return FALSE


/mob/proc/update_glass_vision(obj/item/clothing/glasses/G)
	return

/mob/living/carbon/human/update_glass_vision(obj/item/clothing/glasses/G)
	if(G.fullscreen_vision)
		if(G == glasses && G.active) //equipped and activated
			overlay_fullscreen("glasses_vision", G.fullscreen_vision)
			return TRUE
		else //unequipped or deactivated
			clear_fullscreen("glasses_vision", 0)

/mob/living/carbon/human/verb/remove_your_splints()
	set name = "Remove Your Splints"
	set category = "IC"

	remove_splints()

// target = person whose splints are being removed
// user = person removing the splints
/mob/living/carbon/human/proc/remove_splints(mob/living/carbon/human/user)
	var/mob/living/carbon/human/target = src

	if(!istype(user))
		user = src
	if(!istype(user) || !istype(target))
		return

	var/cur_hand = "l_hand"
	if(!user.hand)
		cur_hand = "r_hand"

	if(!user.action_busy)
		var/list/obj/limb/to_splint = list()
		var/same_arm_side = FALSE // If you are trying to splint yourself, need opposite hand to splint an arm/hand
		if(user.get_limb(cur_hand).status & LIMB_DESTROYED)
			to_chat(user, SPAN_WARNING("You cannot remove splints without a hand."))
			return
		var/is_splint = FALSE
		for(var/bodypart in list("l_leg","r_leg","l_arm","r_arm","r_hand","l_hand","r_foot","l_foot","chest","head","groin")) //check for any splints before do_after
			var/obj/limb/l = target.get_limb(bodypart)
			if(l && (l.status & LIMB_SPLINTED))
				if(user == target)
					if((bodypart in list("l_arm", "l_hand")) && (cur_hand == "l_hand"))
						same_arm_side = TRUE
						continue
					if((bodypart in list("r_arm", "r_hand")) && (cur_hand == "r_hand"))
						same_arm_side = TRUE
						continue
				is_splint = TRUE
				break

		var/msg = "" // Have to use this because there are issues with the to_chat macros and text macros and quotation marks
		if(is_splint)
			if(do_after(user, HUMAN_STRIP_DELAY * user.get_skill_duration_multiplier(SKILL_MEDICAL), INTERRUPT_ALL, BUSY_ICON_GENERIC, target, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
				var/can_reach_splints = TRUE
				var/amount_removed = 0
				for(var/bodypart in list("l_leg","r_leg","l_arm","r_arm","r_hand","l_hand","r_foot","l_foot","chest","head","groin")) // make sure the splints still exist before removing
					var/obj/limb/target_limb = target.get_limb(bodypart)
					if(target_limb && (target_limb.status & LIMB_SPLINTED))
						if(user == target)
							if((bodypart in list("l_arm", "l_hand")) && (cur_hand == "l_hand"))
								same_arm_side = TRUE
								continue
							if((bodypart in list("r_arm", "r_hand")) && (cur_hand == "r_hand"))
								same_arm_side = TRUE
								continue
						to_splint += target_limb
				if(!length(to_splint))
					if(same_arm_side)
						to_chat(user, SPAN_WARNING("You need to use the opposite hand to remove the splints on your arm and hand!"))
					else
						to_chat(user, SPAN_WARNING("There are no splints to remove."))
					return
				if(wear_suit && istype(wear_suit,/obj/item/clothing/suit/space))
					var/obj/item/clothing/suit/space/suit = target.wear_suit
					if(LAZYLEN(suit.supporting_limbs))
						msg = "[user == target ? "your":"\proper [target]'s"]"
						to_chat(user, SPAN_WARNING("You cannot remove the splints, [msg] [suit] is supporting some of the breaks."))
						can_reach_splints = FALSE
				if(can_reach_splints)
					var/obj/item/stack/medical/splint/new_splint = new(user.loc)
					new_splint.amount = 0 //we checked that we have at least one bodypart splinted, so we can create it no prob. Also we need amount to be 0
					new_splint.add_fingerprint(user)
					for(var/obj/limb/cur_limb in to_splint)
						amount_removed++
						cur_limb.status &= ~LIMB_SPLINTED
						pain.recalculate_pain()
						if(cur_limb.status & LIMB_SPLINTED_INDESTRUCTIBLE)
							new /obj/item/stack/medical/splint/nano(user.loc, 1)
							cur_limb.status &= ~LIMB_SPLINTED_INDESTRUCTIBLE
						else if(!new_splint.add(1))
							new_splint = new(user.loc)//old stack is dropped, time for new one
							new_splint.amount = 0
							new_splint.add_fingerprint(user)
							new_splint.add(1)
					if(new_splint.amount == 0)
						qdel(new_splint) //we only removed nano splints
					msg = "[user == target ? "their own":"\proper [target]'s"]"
					target.visible_message(SPAN_NOTICE("[user] removes [msg] [amount_removed>1 ? "splints":"splint"]."),
						SPAN_NOTICE("Your [amount_removed>1 ? "splints are":"splint is"] removed."))
					target.update_med_icon()
			else
				msg = "[user == target ? "your":"\proper [target]'s"]"
				to_chat(user, SPAN_NOTICE("You stop trying to remove [msg] splints."))
		else
			if(same_arm_side)
				to_chat(user, SPAN_WARNING("You need to use the opposite hand to remove the splints on your arm and hand!"))
			else
				to_chat(user, SPAN_WARNING("There are no splints to remove."))

/mob/living/carbon/human/yautja/Initialize(mapload)
	. = ..(mapload, new_species = "Yautja")

/mob/living/carbon/human/monkey/Initialize(mapload)
	. = ..(mapload, new_species = "Monkey")


/mob/living/carbon/human/farwa/Initialize(mapload)
	. = ..(mapload, new_species = "Farwa")


/mob/living/carbon/human/neaera/Initialize(mapload)
	. = ..(mapload, new_species = "Neaera")

/mob/living/carbon/human/stok/Initialize(mapload)
	. = ..(mapload, new_species = "Stok")

/mob/living/carbon/human/yiren/Initialize(mapload)
	. = ..(mapload, new_species = "Yiren")

/mob/living/carbon/human/synthetic/Initialize(mapload)
	. = ..(mapload, SYNTH_GEN_THREE)

/mob/living/carbon/human/synthetic/old/Initialize(mapload)
	. = ..(mapload, SYNTH_COLONY)

/mob/living/carbon/human/synthetic/combat/Initialize(mapload)
	. = ..(mapload, SYNTH_COMBAT)

/mob/living/carbon/human/synthetic/infiltrator/Initialize(mapload)
	. = ..(mapload, SYNTH_INFILTRATOR)

/mob/living/carbon/human/synthetic/first/Initialize(mapload)
	. = ..(mapload, SYNTH_GEN_ONE)

/mob/living/carbon/human/synthetic/second/Initialize(mapload)
	. = ..(mapload, SYNTH_GEN_TWO)

/mob/living/carbon/human/synthetic/synth_k9/Initialize(mapload)
	. = ..(mapload, SYNTH_K9)

/mob/living/carbon/human/resist_fire()
	if(isyautja(src))
		adjust_fire_stacks(HUNTER_FIRE_RESIST_AMOUNT, min_stacks = 0)
		apply_effect(1, WEAKEN) // actually 0.5
		spin(5, 1)
		visible_message(SPAN_DANGER("[src] expertly rolls on the floor, greatly reducing the amount of flames!"),
			SPAN_NOTICE("You expertly roll to extinguish the flames!"), null, 5)
	else
		adjust_fire_stacks(HUMAN_FIRE_RESIST_AMOUNT, min_stacks = 0)
		apply_effect(4, WEAKEN)
		spin(35, 2)
		visible_message(SPAN_DANGER("[src] rolls on the floor, trying to put themselves out!"),
			SPAN_NOTICE("You stop, drop, and roll!"), null, 5)

	if(istype(get_turf(src), /turf/open/gm/river))
		ExtinguishMob()

	if(fire_stacks > 0)
		return

	visible_message(SPAN_DANGER("[src] has successfully extinguished themselves!"),
			SPAN_NOTICE("You extinguish yourself."), null, 5)

/mob/living/carbon/human/resist_acid()
	var/sleep_amount = 1
	if(isyautja(src))
		apply_effect(1, WEAKEN)
		spin(10, 2)
		visible_message(SPAN_DANGER("[src] expertly rolls on the floor!"),
			SPAN_NOTICE("You expertly roll to get rid of the acid!"), max_distance = 5)
	else
		apply_effect(1.5, WEAKEN)
		spin(15, 2)
		visible_message(SPAN_DANGER("[src] rolls on the floor, trying to get the acid off!"),
			SPAN_NOTICE("You stop, drop, and roll!"), max_distance = 5)

	sleep(sleep_amount)

	if( extinguish_acid() )
		visible_message(SPAN_DANGER("[src] has successfully removed the acid!"),
				SPAN_NOTICE("You get rid of the acid."), max_distance = 5)
	else
		visible_message(SPAN_DANGER("[src] has managed to get rid of some of the acid!"),
				SPAN_NOTICE("You manage to get rid of some of the acid... but it's still melting you!"), max_distance = 5)

	return

/mob/living/carbon/human/resist_restraints()
	var/restraint
	var/breakouttime
	if(handcuffed)
		restraint = handcuffed
		breakouttime = handcuffed.breakouttime
	else if(legcuffed)
		restraint = legcuffed
		breakouttime = legcuffed.breakouttime
	else
		return

	next_move = world.time + 100
	last_special = world.time + 10
	var/can_break_cuffs
	if(iszombie(src))
		visible_message(SPAN_DANGER("[src] is attempting to break out of [restraint]..."),
		SPAN_NOTICE("You use your superior zombie strength to start breaking [restraint]..."))
		if(!do_after(src, 100, INTERRUPT_NO_NEEDHAND^INTERRUPT_RESIST, BUSY_ICON_HOSTILE))
			return

		if(!restraint || buckled)
			return
		visible_message(SPAN_DANGER("[src] tears [restraint] in half!"),
			SPAN_NOTICE("You tear [restraint] in half!"))
		restraint = null
		if(handcuffed)
			QDEL_NULL(handcuffed)
			handcuff_update()
		else
			QDEL_NULL(legcuffed)
			handcuff_update()
		return
	if(species.can_shred(src))
		can_break_cuffs = TRUE
	if(can_break_cuffs) //Don't want to do a lot of logic gating here.
		to_chat(usr, SPAN_DANGER("You attempt to break [restraint]. (This will take around 5 seconds and you need to stand still)"))
		for(var/mob/O in viewers(src))
			O.show_message(SPAN_DANGER("<B>[src] is trying to break [restraint]!</B>"), SHOW_MESSAGE_VISIBLE)
		if(!do_after(src, 50, INTERRUPT_NO_NEEDHAND^INTERRUPT_RESIST, BUSY_ICON_HOSTILE))
			return

		if(!restraint || buckled)
			return
		for(var/mob/O in viewers(src))
			O.show_message(SPAN_DANGER("<B>[src] manages to break [restraint]!</B>"), SHOW_MESSAGE_VISIBLE)
		to_chat(src, SPAN_WARNING("You successfully break [restraint]."))
		say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
		if(handcuffed)
			QDEL_NULL(handcuffed)
			handcuff_update()
		else
			QDEL_NULL(legcuffed)
			handcuff_update()
	else
		var/displaytime = max(1, floor(breakouttime / 600)) //Minutes
		to_chat(src, SPAN_WARNING("You attempt to remove [restraint]. (This will take around [displaytime] minute(s) and you need to stand still)"))
		for(var/mob/O in viewers(src))
			O.show_message(SPAN_DANGER("<B>[usr] attempts to remove [restraint]!</B>"), 1)
		if(!do_after(src, breakouttime, INTERRUPT_NO_NEEDHAND^INTERRUPT_RESIST, BUSY_ICON_HOSTILE))
			return

		if(!restraint || buckled)
			return // time leniency for lag which also might make this whole thing pointless but the server
		for(var/mob/O in viewers(src))//  lags so hard that 40s isn't lenient enough - Quarxink
			O.show_message(SPAN_DANGER("<B>[src] manages to remove [restraint]!</B>"), SHOW_MESSAGE_VISIBLE)
		to_chat(src, SPAN_NOTICE(" You successfully remove [restraint]."))
		drop_inv_item_on_ground(restraint)

/mob/living/carbon/human/equip_to_appropriate_slot(obj/item/W, ignore_delay = 1, list/slot_equipment_priority)
	if(species)
		slot_equipment_priority = species.slot_equipment_priority
	return ..(W,ignore_delay,slot_equipment_priority)

/mob/living/carbon/human/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	pose =  strip_html(input(usr, "This is [src]. \He is...", "Pose", null)  as text)

/mob/living/carbon/human/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	var/HTML = "<body>"
	HTML += "<tt>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=general'>General:</a> "
	HTML += TextPreview(flavor_texts["general"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=head'>Head:</a> "
	HTML += TextPreview(flavor_texts["head"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=face'>Face:</a> "
	HTML += TextPreview(flavor_texts["face"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=eyes'>Eyes:</a> "
	HTML += TextPreview(flavor_texts["eyes"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=torso'>Body:</a> "
	HTML += TextPreview(flavor_texts["torso"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=arms'>Arms:</a> "
	HTML += TextPreview(flavor_texts["arms"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=hands'>Hands:</a> "
	HTML += TextPreview(flavor_texts["hands"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=legs'>Legs:</a> "
	HTML += TextPreview(flavor_texts["legs"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=feet'>Feet:</a> "
	HTML += TextPreview(flavor_texts["feet"])
	HTML += "<br>"
	HTML += "<hr />"
	HTML +="<a href='byond://?src=\ref[src];flavor_change=done'>\[Done\]</a>"
	HTML += "<tt>"
	show_browser(src, HTML, "Update Flavor Text", "flavor_changes", "size=430x300")

/mob/living/carbon/human/throw_item(atom/target)
	if(!throw_allowed)
		var/obj/item/I = get_active_hand()
		if(I.throwforce) // for hurty stuff only
			to_chat(src, SPAN_DANGER("You are currently unable to throw harmful items."))
			return
	. = ..()

/mob/living/carbon/human/equip_to_slot_if_possible(obj/item/equipping_item, slot, ignore_delay = 1, del_on_fail = 0, disable_warning = 0, redraw_mob = 1, permanent = 0)

	if(SEND_SIGNAL(src, COMSIG_HUMAN_ATTEMPTING_EQUIP, equipping_item, slot) & COMPONENT_HUMAN_CANCEL_ATTEMPT_EQUIP)
		return FALSE

	. = ..()

/mob/living/carbon/human/make_dizzy(amount)
	dizziness = min(500, dizziness + amount) // store what will be new value
													// clamped to max 500
	if(dizziness > 100 && !is_dizzy)
		INVOKE_ASYNC(src, PROC_REF(dizzy_process))

/proc/setup_human(mob/living/carbon/human/target, mob/new_player/new_player, is_late_join = FALSE)
	new_player.spawning = TRUE
	new_player.close_spawn_windows()
	new_player.client.prefs.copy_all_to(target, new_player.job, is_late_join)

	if(new_player.client.prefs.be_random_body)
		var/datum/preferences/rand_prefs = new()
		rand_prefs.randomize_appearance(target)

	target.job = new_player.job
	target.name = new_player.real_name
	target.voice = new_player.real_name

	if(new_player.mind)
		new_player.mind_initialize()
		new_player.mind.transfer_to(target, TRUE)
		new_player.mind.setup_human_stats()

	target.sec_hud_set_ID()
	target.hud_set_squad()

	INVOKE_ASYNC(target, TYPE_PROC_REF(/mob/living/carbon/human, regenerate_icons))
	INVOKE_ASYNC(target, TYPE_PROC_REF(/mob/living/carbon/human, update_body), 1, 0)
	INVOKE_ASYNC(target, TYPE_PROC_REF(/mob/living/carbon/human, update_hair))

/mob/living/carbon/human/point_to_atom(atom/A, turf/T)
	if(isitem(A))
		var/obj/item/item = A
		if(item == get_active_hand() || item == get_inactive_hand())
			item.showoff(src)
			return TRUE
	return ..()

/mob/living/carbon/human/on_knockedout_trait_gain(datum/source)
	. = ..()

	update_execute_hud()

	return .

/mob/living/carbon/human/on_knockedout_trait_loss(datum/source)
	. = ..()

	update_execute_hud()

	return .

/// generates realistic-ish pulse output based on preset levels.
/// method == GETPULSE_HAND is for hands, GETPULSE_TOOL is for machines, more accurate
/mob/living/carbon/human/proc/get_pulse(method)
	var/temp = 0 //see setup.dm:694

	if(species && species.flags & NO_BLOOD)
		pulse = PULSE_NONE //No blood, no pulse.

	else if(stat == DEAD || status_flags & FAKEDEATH)
		pulse = PULSE_NONE //That's it, you're dead, nothing can influence your pulse

	else if(floor(blood_volume) <= BLOOD_VOLUME_BAD) //How much blood do we have
		pulse = PULSE_THREADY //not enough :(

	else
		pulse = PULSE_NORM

	switch(pulse)
		if(PULSE_NONE)
			return "0"
		if(PULSE_SLOW)
			temp = rand(40, 60)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_NORM)
			temp = rand(60, 90)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_FAST)
			temp = rand(90, 120)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_FASTER)
			temp = rand(120, 160)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_THREADY)
			return method ? ">250" : "extremely weak and fast, patient's artery feels like a thread"
// output for machines^ ^^^^^^^output for people^^^^^^^^^


