/mob/living/carbon/human/Initialize(mapload, new_species = null)
	blood_type = pick(7;"O-", 38;"O+", 6;"A-", 34;"A+", 2;"B-", 9;"B+", 1;"AB-", 3;"AB+")
	human_mob_list += src
	living_human_list += src
	processable_human_list += src

	if(!species)
		if(new_species)
			set_species(new_species)
		else
			set_species()

	create_reagents(1000)
	change_real_name(src, "unknown")

	. = ..()

	prev_gender = gender // Debug for plural genders

	if(map_tag == MAP_WHISKEY_OUTPOST)
		hardcore = TRUE //For WO disposing of corpses

/mob/living/carbon/human/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = SETUP_LIST_FLAGS(PASS_MOB_IS_HUMAN)
		PF.flags_can_pass_all = SETUP_LIST_FLAGS(PASS_MOB_THRU_HUMAN, PASS_AROUND, PASS_HIGH_OVER_ONLY)

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
	if(assigned_squad)
		SStracking.stop_tracking(assigned_squad.tracking_id, src)
		var/n = assigned_squad.marines_list.Find(src)
		if(n)
			assigned_squad.marines_list[n] = name //mob reference replaced by name string
		if(assigned_squad.squad_leader == src)
			assigned_squad.squad_leader = null
		if(assigned_squad.overwatch_officer == src)
			assigned_squad.overwatch_officer = null
		assigned_squad = null

	if(internal_organs_by_name)
		for(var/name in internal_organs_by_name)
			var/datum/internal_organ/I = internal_organs_by_name[name]
			if(I)
				I.owner = null
			internal_organs_by_name[name] = null
		internal_organs_by_name = null

	if(limbs)
		for(var/obj/limb/L in limbs)
			L.owner = null
			qdel(L)
		limbs = null

	remove_from_all_mob_huds()
	human_mob_list -= src
	living_human_list -= src
	processable_human_list -= src

	. = ..()

	if(agent_holder)
		agent_holder.source_human = null
		human_agent_list -= src

/mob/living/carbon/human/Stat()
	if(!..())
		return FALSE

	if(statpanel("Stats"))
		stat("Operation Time:","[worldtime2text()]")
		stat("Security Level:","[uppertext(get_security_level())]")
		stat("DEFCON Level:","[defcon_controller.current_defcon_level]")

		if(!isnull(ticker) && !isnull(ticker.mode) && !isnull(ticker.mode.active_lz) && !isnull(ticker.mode.active_lz.loc) && !isnull(ticker.mode.active_lz.loc.loc))
			stat("Primary LZ: ", ticker.mode.active_lz.loc.loc.name)

		if(assigned_squad)
			if(assigned_squad.overwatch_officer)
				stat("Overwatch Officer: ", "[assigned_squad.overwatch_officer.get_paygrade()][assigned_squad.overwatch_officer.name]")
			if(assigned_squad.primary_objective)
				stat("Primary Objective: ", assigned_squad.primary_objective)
			if(assigned_squad.secondary_objective)
				stat("Secondary Objective: ", assigned_squad.secondary_objective)

		if(mobility_aura)
			stat("Active Order: ", "MOVE")
		if(protection_aura)
			stat("Active Order: ", "HOLD")
		if(marksman_aura)
			stat("Active Order: ", "FOCUS")

		if(EvacuationAuthority)
			var/eta_status = EvacuationAuthority.get_status_panel_eta()
			if(eta_status)
				stat(null, eta_status)
		return TRUE

/mob/living/carbon/human/ex_act(var/severity, var/direction, var/source, var/source_mob)
	if(lying)
		severity *= EXPLOSION_PRONE_MULTIPLIER

	if(severity >= 30)
		flash_eyes()

	var/b_loss = 0
	var/f_loss = 0

	var/damage = severity

	damage = armor_damage_reduction(config.marine_explosive, damage, getarmor(null, ARMOR_BOMB))

	if(source)
		last_damage_source = source
	if(source_mob)
		last_damage_mob = source_mob

	if(damage >= EXPLOSION_THRESHOLD_GIB)
		var/oldloc = loc
		gib(source)
		create_shrapnel(oldloc, rand(5, 9), direction, 45, /datum/ammo/bullet/shrapnel/light/human, source, source_mob)
		sleep(1)
		create_shrapnel(oldloc, rand(5, 9), direction, 30, /datum/ammo/bullet/shrapnel/light/human/var1, source, source_mob)
		create_shrapnel(oldloc, rand(5, 9), direction, 45, /datum/ammo/bullet/shrapnel/light/human/var2, source, source_mob)
		return

	if(!istype(wear_ear, /obj/item/clothing/ears/earmuffs))
		ear_damage += severity * 0.15
		ear_deaf += severity * 0.5

	var/knockdown_value = min( round( severity*0.1  ,1) ,10)
	if(knockdown_value > 0)
		var/obj/item/Item1 = get_active_hand()
		var/obj/item/Item2 = get_inactive_hand()
		KnockDown(knockdown_value)
		var/knockout_value = min( round( damage*0.1  ,1) ,10)
		KnockOut( knockout_value )
		Daze( knockout_value*2 )
		explosion_throw(severity, direction)

		if(Item1 && isturf(Item1.loc))
			Item1.explosion_throw(severity, direction)
		if(Item2 && isturf(Item2.loc))
			Item2.explosion_throw(severity, direction)

	if(damage >= 0)
		b_loss += damage * 0.5
		f_loss += damage * 0.5
	else
		return

	var/update = 0

	//Focus half the blast on one organ
	var/obj/limb/take_blast = pick(limbs)
	update |= take_blast.take_damage(b_loss * 0.5, f_loss * 0.5, used_weapon = "Explosive blast", attack_source = source_mob)
	pain.apply_pain(b_loss * 0.5, BRUTE)
	pain.apply_pain(f_loss * 0.5, BURN)

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
		update |= temp.take_damage(b_loss * limb_multiplier, f_loss * limb_multiplier, used_weapon = weapon_message, attack_source = source_mob)
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
			O.show_message(SPAN_DANGER("<B>[M]</B> [M.attacktext] [src]!"), 1)
		last_damage_source = initial(M.name)
		last_damage_mob = M
		M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [key_name(src)]</font>")
		src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [key_name(M)]</font>")
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		var/dam_zone = pick("chest", "l_hand", "r_hand", "l_leg", "r_leg")
		var/obj/limb/affecting = get_limb(ran_zone(dam_zone))
		apply_damage(damage, BRUTE, affecting)


/mob/living/carbon/human/proc/implant_loyalty(mob/living/carbon/human/M, override = FALSE) // Won't override by default.
	if(!config.use_loyalty_implants && !override) return // Nuh-uh.

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



/mob/living/carbon/human/show_inv(mob/living/user)
	if(ismaintdrone(user))
		return
	var/obj/item/clothing/under/suit = null
	if(istype(w_uniform, /obj/item/clothing/under))
		suit = w_uniform

	user.set_interaction(src)
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR>
	<BR><B>Head(Mask):</B> <A href='?src=\ref[src];item=[WEAR_FACE]'>[(wear_mask ? wear_mask : "Nothing")]</A>
	<BR><B>Left Hand:</B> <A href='?src=\ref[src];item=[WEAR_L_HAND]'>[(l_hand ? l_hand  : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='?src=\ref[src];item=[WEAR_R_HAND]'>[(r_hand ? r_hand : "Nothing")]</A>
	<BR><B>Gloves:</B> <A href='?src=\ref[src];item=[WEAR_HANDS]'>[(gloves ? gloves : "Nothing")]</A>
	<BR><B>Eyes:</B> <A href='?src=\ref[src];item=[WEAR_EYES]'>[(glasses ? glasses : "Nothing")]</A>
	<BR><B>Left Ear:</B> <A href='?src=\ref[src];item=[WEAR_EAR]'>[(wear_ear ? wear_ear : "Nothing")]</A>
	<BR><B>Head:</B> <A href='?src=\ref[src];item=[WEAR_HEAD]'>[(head ? head : "Nothing")]</A>
	<BR><B>Shoes:</B> <A href='?src=\ref[src];item=[WEAR_FEET]'>[(shoes ? shoes : "Nothing")]</A>
	<BR><B>Belt:</B> <A href='?src=\ref[src];item=[WEAR_WAIST]'>[(belt ? belt : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(belt, /obj/item/tank) && !internal) ? " <A href='?src=\ref[src];internal=1'>Set Internal</A>" : "")]
	<BR><B>Uniform:</B> <A href='?src=\ref[src];item=[WEAR_BODY]'>[(w_uniform ? w_uniform : "Nothing")]</A> [(suit) ? ((suit.has_sensor == 1) ? " <A href='?src=\ref[src];sensor=1'>Sensors</A>" : "") : null]
	<BR><B>(Exo)Suit:</B> <A href='?src=\ref[src];item=[WEAR_JACKET]'>[(wear_suit ? wear_suit : "Nothing")]</A>
	<BR><B>Back:</B> <A href='?src=\ref[src];item=[WEAR_BACK]'>[(back ? back : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/tank) && !( internal )) ? " <A href='?src=\ref[src];internal=1'>Set Internal</A>" : "")]
	<BR><B>ID:</B> <A href='?src=\ref[src];item=[WEAR_ID]'>[(wear_id ? wear_id : "Nothing")]</A>
	<BR><B>Suit Storage:</B> <A href='?src=\ref[src];item=[WEAR_J_STORE]'>[(s_store ? s_store : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(s_store, /obj/item/tank) && !( internal )) ? " <A href='?src=\ref[src];internal=1'>Set Internal</A>" : "")]
	<BR><B>Left Pocket:</B> <A href='?src=\ref[src];item=[WEAR_L_STORE]'>[(l_store ? l_store : "Nothing")]</A>
	<BR><B>Right Pocket:</B> <A href='?src=\ref[src];item=[WEAR_R_STORE]'>[(r_store ? r_store : "Nothing")]</A>
	<BR>
	[handcuffed ? "<BR><A href='?src=\ref[src];item=[WEAR_HANDCUFFS]'>Handcuffed</A>" : ""]
	[legcuffed ? "<BR><A href='?src=\ref[src];item=[WEAR_LEGCUFFS]'>Legcuffed</A>" : ""]
	[suit && suit.accessories.len ? "<BR><A href='?src=\ref[src];tie=1'>Remove Accessory</A>" : ""]
	[internal ? "<BR><A href='?src=\ref[src];internal=1'>Remove Internal</A>" : ""]
	[istype(wear_id, /obj/item/card/id/dogtag) ? "<BR><A href='?src=\ref[src];item=id'>Retrieve Info Tag</A>" : ""]
	<BR><A href='?src=\ref[src];splints=1'>Remove Splints</A>
	<BR>
	<BR><A href='?src=\ref[user];refresh=1'>Refresh</A>
	<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	show_browser(user, dat, name, "mob[name]")

// called when something steps onto a human
// this handles mulebots and vehicles
/mob/living/carbon/human/Crossed(var/atom/movable/AM)
	if(istype(AM, /obj/structure/machinery/bot/mulebot))
		var/obj/structure/machinery/bot/mulebot/MB = AM
		MB.RunOver(src)

	if(istype(AM, /obj/vehicle))
		var/obj/vehicle/V = AM
		V.RunOver(src)


//gets assignment from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_assignment(var/if_no_id = "No id", var/if_no_job = "No job")
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
/mob/living/carbon/human/proc/get_authentification_name(var/if_no_id = "Unknown")
	var/obj/item/card/id/id = wear_id
	if(istype(id))
		. = id.registered_name
	else
		return if_no_id
	return

//gets paygrade from ID
//paygrade is a user's actual rank, as defined on their ID.  size 1 returns an abbreviation, size 0 returns the full rank name, the third input is used to override what is returned if no paygrade is assigned.
/mob/living/carbon/human/proc/get_paygrade(size = 1)
	if(!species)
		return ""

	switch(species.name)
		if("Human","Human Hero")
			var/obj/item/card/id/id = wear_id
			if(istype(id))
				. = get_paygrades(id.paygrade, size, gender)
		else
			return ""


//repurposed proc. Now it combines get_id_name() and get_face_name() to determine a mob's name variable. Made into a seperate proc as it'll be useful elsewhere
/mob/living/carbon/human/proc/get_visible_name()
	if(wear_mask && (wear_mask.flags_inv_hide & HIDEFACE) )	//Wearing a mask which hides our face, use id-name if possible
		return get_id_name("Unknown")
	if(head && (head.flags_inv_hide & HIDEFACE) )
		return get_id_name("Unknown")		//Likewise for hats
	var/face_name = get_face_name()
	var/id_name = get_id_name("")
	if(id_name && (id_name != face_name))
		return "[face_name] (as [id_name])"
	return face_name

//Returns "Unknown" if facially disfigured and real_name if not. Useful for setting name when polyacided or when updating a human's name variable
/mob/living/carbon/human/proc/get_face_name()
	var/obj/limb/head/head = get_limb("head")
	if(!head || head.disfigured || (head.status & LIMB_DESTROYED) || !real_name)	//disfigured. use id-name if possible
		return "Unknown"
	return real_name

//gets name from ID or PDA itself, ID inside PDA doesn't matter
//Useful when player is being seen by other mobs
/mob/living/carbon/human/proc/get_id_name(var/if_no_id = "Unknown")
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
/mob/living/carbon/human/electrocute_act(var/shock_damage, var/obj/source, var/base_siemens_coeff = 1.0, var/def_zone = null)
	if(status_flags & GODMODE)	return FALSE	//godmode

	if(!def_zone)
		def_zone = pick("l_hand", "r_hand")

	var/obj/limb/affected_organ = get_limb(check_zone(def_zone))
	var/siemens_coeff = base_siemens_coeff * get_siemens_coefficient_organ(affected_organ)

	return ..(shock_damage, source, siemens_coeff, def_zone)


/mob/living/carbon/human/Topic(href, href_list)
	if(href_list["refresh"])
		if(interactee&&(in_range(src, usr)))
			show_inv(interactee)

	if(href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		unset_interaction()
		close_browser(src, t1)


	if(href_list["item"])
		if(!usr.is_mob_incapacitated() && Adjacent(usr))
			if(href_list["item"] == "id")
				if(istype(wear_id, /obj/item/card/id/dogtag) && (undefibbable || !skillcheck(usr, SKILL_POLICE, SKILL_POLICE_MP)))
					var/obj/item/card/id/dogtag/DT = wear_id
					if(!DT.dogtag_taken)
						if(stat == DEAD)
							to_chat(usr, SPAN_NOTICE("You take [src]'s information tag, leaving the ID tag"))
							DT.dogtag_taken = TRUE
							DT.icon_state = "dogtag_taken"
							var/obj/item/dogtag/D = new(loc)
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
			if(!usr.action_busy || skillcheck(usr, SKILL_POLICE, SKILL_POLICE_MP))
				var/slot = href_list["item"]
				var/obj/item/what = get_item_by_slot(slot)
				if(what)
					usr.stripPanelUnequip(what,src,slot)
				else
					what = usr.get_active_hand()
					usr.stripPanelEquip(what,src,slot)

	if(href_list["internal"])

		if(!usr.action_busy)
			attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their internals toggled by [key_name(usr)]</font>")
			usr.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to toggle [key_name(src)]'s' internals</font>")
			if(internal)
				usr.visible_message(SPAN_DANGER("<B>[usr] is trying to disable [src]'s internals</B>"), null, null, 3)
			else
				usr.visible_message(SPAN_DANGER("<B>[usr] is trying to enable [src]'s internals.</B>"), null, null, 3)

			if(do_after(usr, POCKET_STRIP_DELAY, INTERRUPT_ALL, BUSY_ICON_GENERIC, src, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
				if(internal)
					internal.add_fingerprint(usr)
					internal = null
					visible_message("[src] is no longer running on internals.", null, null, 1)
				else
					if(istype(wear_mask, /obj/item/clothing/mask))
						if(istype(back, /obj/item/tank))
							internal = back
						else if(istype(s_store, /obj/item/tank))
							internal = s_store
						else if(istype(belt, /obj/item/tank))
							internal = belt
						if(internal)
							visible_message(SPAN_NOTICE("[src] is now running on internals."), null, null, 1)
							internal.add_fingerprint(usr)

				// Update strip window
				if(usr.interactee == src && Adjacent(usr))
					show_inv(usr)


	if(href_list["splints"])
		remove_splints(usr)

	if(href_list["tie"])
		if(!usr.action_busy)
			if(w_uniform && istype(w_uniform, /obj/item/clothing))
				var/obj/item/clothing/under/U = w_uniform
				if(U.accessories.len < 1)
					return FALSE
				var/obj/item/clothing/accessory/A = U.accessories[1]
				if(U.accessories.len > 1)
					A = input("Select an accessory to remove from [U]") as null|anything in U.accessories
				if(!istype(A))
					return
				attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their accessory ([A]) removed by [key_name(usr)]</font>")
				usr.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [key_name(src)]'s' accessory ([A])</font>")
				if(istype(A, /obj/item/clothing/accessory/holobadge) || istype(A, /obj/item/clothing/accessory/medal))
					visible_message(SPAN_DANGER("<B>[usr] tears off \the [A] from [src]'s [U]!</B>"), null, null, 5)
					if(U == w_uniform)
						U.remove_accessory(usr, A)
				else
					visible_message(SPAN_DANGER("<B>[usr] is trying to take off \a [A] from [src]'s [U]!</B>"), null, null, 5)
					if(do_after(usr, HUMAN_STRIP_DELAY, INTERRUPT_ALL, BUSY_ICON_GENERIC, src, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
						if(U == w_uniform)
							U.remove_accessory(usr, A)

	if(href_list["sensor"])
		if(!usr.action_busy)

			attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their sensors toggled by [key_name(usr)]</font>")
			usr.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to toggle [key_name(src)]'s' sensors</font>")
			var/obj/item/clothing/under/U = w_uniform
			if(QDELETED(U))
				to_chat(usr, "You're not wearing a uniform!.")
			else if(U.has_sensor >= 2)
				to_chat(usr, "The controls are locked.")
			else
				var/oldsens = U.has_sensor
				visible_message(SPAN_DANGER("<B>[usr] is trying to modify [src]'s sensors!</B>"), null, null, 4)
				if(do_after(usr, HUMAN_STRIP_DELAY, INTERRUPT_ALL, BUSY_ICON_GENERIC, src, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
					if(U == w_uniform)
						if(U.has_sensor >= 2)
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
			var/perpname = "wot"
			if(wear_id)
				var/obj/item/card/id/I = wear_id.GetID()
				if(I)
					perpname = I.registered_name
				else
					perpname = name
			else
				perpname = name

			if(perpname)
				for(var/datum/data/record/E in GLOB.data_core.general)
					if(E.fields["name"] == perpname)
						for(var/datum/data/record/R in GLOB.data_core.security)
							if(R.fields["id"] == E.fields["id"])

								var/setcriminal = input(usr, "Specify a new criminal status for this person.", "Security HUD", R.fields["criminal"]) in list("None", "*Arrest*", "Incarcerated", "Released", "Cancel")

								if(hasHUD(usr, "security"))
									if(setcriminal != "Cancel")
										R.fields["criminal"] = setcriminal
										modified = 1
										sec_hud_set_security_status()


			if(!modified)
				to_chat(usr, SPAN_DANGER("Unable to locate a data core entry for this person."))

	if(href_list["secrecord"])
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				if(istype(wear_id,/obj/item/card/id))
					perpname = wear_id:registered_name
			else
				perpname = src.name
			for(var/datum/data/record/E in GLOB.data_core.general)
				if(E.fields["name"] == perpname)
					for(var/datum/data/record/R in GLOB.data_core.security)
						if(R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"security"))
								to_chat(usr, "<b>Name:</b> [R.fields["name"]]	<b>Criminal Status:</b> [R.fields["criminal"]]")
								to_chat(usr, "<b>Incidents:</b> [R.fields["incident"]]")
								to_chat(usr, "<a href='?src=\ref[src];secrecordComment=1'>\[View Comment Log\]</a>")
								read = 1

			if(!read)
				to_chat(usr, SPAN_DANGER("Unable to locate a data core entry for this person."))

	if(href_list["secrecordComment"] && hasHUD(usr,"security"))
		var/perpname = "wot"
		if(wear_id && istype(wear_id,/obj/item/card/id))
			perpname = wear_id:registered_name
		if(!wear_id)
			perpname = src.name

		var/read = 0

		for(var/datum/data/record/E in GLOB.data_core.general)
			if(E.fields["name"] != perpname)
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
				to_chat(usr, "<a href='?src=\ref[src];secrecordadd=1'>\[Add comment\]</a><br />")

		if(!read)
			to_chat(usr, SPAN_DANGER("Unable to locate a data core entry for this person."))

	if(href_list["secrecordadd"] && hasHUD(usr,"security"))
		var/perpname = "wot"
		if(wear_id && istype(wear_id,/obj/item/card/id))
			perpname = wear_id:registered_name
		if(!wear_id)
			perpname = src.name
		for(var/datum/data/record/E in GLOB.data_core.general)
			if(E.fields["name"] != perpname)
				continue
			for(var/datum/data/record/R in GLOB.data_core.security)
				if(R.fields["id"] != E.fields["id"])
					continue
				var/t1 = copytext(trim(strip_html(input("Your name and time will be added to this new comment.", "Add a comment", null, null)  as message)), 1, MAX_MESSAGE_LEN)
				if(!(t1) || usr.stat || usr.is_mob_restrained())
					return
				var/created_at = text("[]&nbsp;&nbsp;[]&nbsp;&nbsp;[]", time2text(world.realtime, "MMM DD"), time2text(world.time, "[worldtime2text()]:ss"), game_year)
				var/new_comment = list("entry" = t1, "created_by" = list("name" = "", "rank" = ""), "deleted_by" = null, "deleted_at" = null, "created_at" = created_at)
				if(istype(usr,/mob/living/carbon/human))
					var/mob/living/carbon/human/U = usr
					new_comment["created_by"]["name"] = U.get_authentification_name()
					new_comment["created_by"]["rank"] = U.get_assignment()
				else if(istype(usr,/mob/living/silicon/robot))
					var/mob/living/silicon/robot/U = usr
					new_comment["created_by"]["name"] = U.name
					new_comment["created_by"]["rank"] = "[U.modtype] [U.braintype]"
				if(!islist(R.fields["comments"]))
					R.fields["comments"] = list("1" = new_comment)
				else
					var/new_com_i = length(R.fields["comments"]) + 1
					R.fields["comments"]["[new_com_i]"] = new_comment
				to_chat(usr, "You have added a new comment to the Security Record of [R.fields["name"]]. <a href='?src=\ref[src];secrecordComment=1'>\[View Comment Log\]</a>")

	if(href_list["medical"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/modified = 0

			if(wear_id)
				if(istype(wear_id,/obj/item/card/id))
					perpname = wear_id:registered_name
			else
				perpname = src.name

			for(var/datum/data/record/E in GLOB.data_core.general)
				if(E.fields["name"] == perpname)
					for(var/datum/data/record/R in GLOB.data_core.general)
						if(R.fields["id"] == E.fields["id"])

							var/setmedical = input(usr, "Specify a new medical status for this person.", "Medical HUD", R.fields["p_stat"]) in list("*SSD*", "*Deceased*", "Physically Unfit", "Active", "Disabled", "Cancel")

							if(hasHUD(usr,"medical"))
								if(setmedical != "Cancel")
									R.fields["p_stat"] = setmedical
									modified = 1

									spawn()
										if(istype(usr,/mob/living/carbon/human))
											var/mob/living/carbon/human/U = usr
											U.handle_regular_hud_updates()
										if(istype(usr,/mob/living/silicon/robot))
											var/mob/living/silicon/robot/U = usr
											U.handle_regular_hud_updates()

			if(!modified)
				to_chat(usr, SPAN_DANGER("Unable to locate a data core entry for this person."))

	if(href_list["medrecord"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				if(istype(wear_id,/obj/item/card/id))
					perpname = wear_id:registered_name
			else
				perpname = src.name
			for(var/datum/data/record/E in GLOB.data_core.general)
				if(E.fields["name"] == perpname)
					for(var/datum/data/record/R in GLOB.data_core.medical)
						if(R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"medical"))
								to_chat(usr, "<b>Name:</b> [R.fields["name"]]	<b>Blood Type:</b> [R.fields["b_type"]]")
								to_chat(usr, "<b>Minor Disabilities:</b> [R.fields["mi_dis"]]")
								to_chat(usr, "<b>Details:</b> [R.fields["mi_dis_d"]]")
								to_chat(usr, "<b>Major Disabilities:</b> [R.fields["ma_dis"]]")
								to_chat(usr, "<b>Details:</b> [R.fields["ma_dis_d"]]")
								to_chat(usr, "<b>Notes:</b> [R.fields["notes"]]")
								to_chat(usr, "<a href='?src=\ref[src];medrecordComment=1'>\[View Comment Log\]</a>")
								read = 1

			if(!read)
				to_chat(usr, SPAN_DANGER("Unable to locate a data core entry for this person."))

	if(href_list["medrecordComment"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				if(istype(wear_id,/obj/item/card/id))
					perpname = wear_id:registered_name
			else
				perpname = src.name
			for(var/datum/data/record/E in GLOB.data_core.general)
				if(E.fields["name"] == perpname)
					for(var/datum/data/record/R in GLOB.data_core.medical)
						if(R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"medical"))
								read = 1
								var/counter = 1
								while(R.fields["com_[counter]"])
									to_chat(usr, R.fields["com_[counter]"])
									counter++
								if(counter == 1)
									to_chat(usr, "No comment found")
								to_chat(usr, "<a href='?src=\ref[src];medrecordadd=1'>\[Add comment\]</a>")

			if(!read)
				to_chat(usr, SPAN_DANGER("Unable to locate a data core entry for this person."))

	if(href_list["medrecordadd"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			if(wear_id)
				if(istype(wear_id,/obj/item/card/id))
					perpname = wear_id:registered_name
			else
				perpname = src.name
			for(var/datum/data/record/E in GLOB.data_core.general)
				if(E.fields["name"] == perpname)
					for(var/datum/data/record/R in GLOB.data_core.medical)
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
									R.fields[text("com_[counter]")] = text("Made by [U.get_authentification_name()] ([U.get_assignment()]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")
								if(istype(usr,/mob/living/silicon/robot))
									var/mob/living/silicon/robot/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.name] ([U.modtype] [U.braintype]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")

	if(href_list["medholocard"])
		if(!skillcheck(usr, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
			to_chat(usr, SPAN_WARNING("You're not trained to use this."))
			return
		if(!has_species(src, "Human"))
			to_chat(usr, SPAN_WARNING("Triage holocards only works on humans."))
			return
		var/newcolor = input("Choose a triage holo card to add to the patient:", "Triage holo card", null, null) in list("black", "red", "orange", "none")
		if(!newcolor) return
		if(get_dist(usr, src) > 7)
			to_chat(usr, SPAN_WARNING("[src] is too far away."))
			return
		if(newcolor == "none")
			if(!holo_card_color) return
			holo_card_color = null
			to_chat(usr, SPAN_NOTICE("You remove the holo card on [src]."))
		else if(newcolor != holo_card_color)
			holo_card_color = newcolor
			to_chat(usr, SPAN_NOTICE("You add a [newcolor] holo card on [src]."))
		update_targeted()

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

			for(var/datum/data/record/R in GLOB.data_core.medical)
				if(R.fields["name"] == real_name)
					if(R.fields["last_scan_time"] && R.fields["last_scan_result"])
						show_browser(usr, R.fields["last_scan_result"], "Medical Scan Report", "scanresults", "size=430x600")
					break

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
	..()
	return

///get_eye_protection()
///Returns a number between -1 to 2
/mob/living/carbon/human/get_eye_protection()
	var/number = 0

	if(species && !species.has_organ["eyes"]) return 2//No eyes, can't hurt them.

	if(!internal_organs_by_name)
		return 2
	var/datum/internal_organ/eyes/I = internal_organs_by_name["eyes"]
	if(I)
		if(I.cut_away)
			return 2
		if(I.robotic == ORGAN_ROBOT)
			return 2
	else
		return 2

	if(istype(head, /obj/item/clothing))
		var/obj/item/clothing/C = head
		number += C.eye_protection
	if(istype(wear_mask))
		number += wear_mask.eye_protection
	if(glasses)
		number += glasses.eye_protection

	return number


/mob/living/carbon/human/abiotic(var/full_body = 0)
	if(full_body && ((src.l_hand && !( src.l_hand.flags_item & ITEM_ABSTRACT)) || (src.r_hand && !( src.r_hand.flags_item & ITEM_ABSTRACT)) || (src.back || src.wear_mask || src.head || src.shoes || src.w_uniform || src.wear_suit || src.glasses || src.wear_ear || src.gloves)))
		return TRUE

	if((src.l_hand && !(src.l_hand.flags_item & ITEM_ABSTRACT)) || (src.r_hand && !(src.r_hand.flags_item & ITEM_ABSTRACT)) )
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
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, src, "You feel like you are about to throw up!"), 15 SECONDS)
		addtimer(CALLBACK(src, .proc/do_vomit), 25 SECONDS)

/mob/living/carbon/human/proc/do_vomit()
	Stun(5)
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
	for(var/obj/limb/O in limbs)
		if(O.status & LIMB_ROBOT)
			O.status = LIMB_ROBOT
		else
			O.status = NO_FLAGS
		O.perma_injury = 0
		O.wounds.Cut()
		O.heal_damage(1000,1000,1,1)
		O.reset_limb_surgeries()

	var/obj/limb/head/h = get_limb("head")
	if(QDELETED(h))
		h = get_limb("synthetic head")
	else
		h.disfigured = 0
	name = get_visible_name()

	if(species && !(species.flags & NO_BLOOD))
		restore_blood()

	//try to find the brain player in the decapitated head and put them back in control of the human
	if(!client && !mind) //if another player took control of the human, we don't want to kick them out.
		for(var/obj/item/limb/head/H in item_list)
			if(H.brainmob)
				if(H.brainmob.real_name == src.real_name)
					if(H.brainmob.mind)
						H.brainmob.mind.transfer_to(src)
						qdel(H)

	for(var/datum/internal_organ/I in internal_organs)
		I.damage = 0

	if(!keep_viruses)
		for(var/datum/disease/virus in viruses)
			if(istype(virus, /datum/disease/black_goo))
				continue
			virus.cure(0)

	pain.recalculate_pain()

	undefibbable = FALSE
	..()

/mob/living/carbon/human/proc/is_lung_ruptured()
	var/datum/internal_organ/lungs/L = internal_organs_by_name["lungs"]
	return L && L.is_bruised()

/mob/living/carbon/human/proc/rupture_lung()
	var/datum/internal_organ/lungs/L = internal_organs_by_name["lungs"]

	if(L && !L.is_bruised())
		src.custom_pain("You feel a stabbing pain in your chest!", 1)
		L.damage = L.min_bruised_damage


/mob/living/carbon/human/get_visible_implants(var/class = 0)
	var/list/visible_objects = list()
	for(var/obj/item/W in embedded_items)
		if(!istype(W, /obj/item/shard/shrapnel))
			visible_objects += W
	return visible_objects


/mob/living/carbon/human/proc/handle_embedded_objects()
	if((stat == DEAD) || lying || buckled) // Shouldnt be needed, but better safe than sorry
		return

	for(var/obj/item/W in embedded_items)
		var/obj/limb/organ = W.embedded_organ
		// Check if shrapnel
		if(istype(W, /obj/item/shard/shrapnel))
			var/obj/item/shard/shrapnel/embedded = W
			embedded.on_embedded_movement(src)
		// Check if its a sharp weapon
		else if(is_sharp(W))
			if(organ.status & LIMB_SPLINTED) //Splints prevent movement.
				continue
			if(prob(20)) //Let's not make throwing knives too good in HvH
				organ.take_damage(rand(1,2), 0, 0)
		if(prob(30))	// Spam chat less
			to_chat(src, SPAN_HIGHDANGER("Your movement jostles [W] in your [organ.display_name] painfully."))

/mob/living/carbon/human/verb/check_status()
	set category = "Object"
	set name = "Check Status"
	set src in view(1)
	var/self = (usr == src)
	var/msg = ""


	if(usr.stat > 0 || usr.is_mob_restrained() || !ishuman(usr)) return

	if(self)
		var/list/L = get_broken_limbs()	- list("chest","head","groin")
		if(L.len > 0)
			msg += "Your [english_list(L)] [L.len > 1 ? "are" : "is"] broken\n"
	to_chat(usr,SPAN_NOTICE("You [self ? "take a moment to analyze yourself":"start analyzing [src]"]"))
	if(toxloss > 20)
		msg += "[self ? "Your" : "Their"] skin is slightly green\n"
	if(is_bleeding())
		msg += "[self ? "You" : "They"] have bleeding wounds on [self ? "your" : "their"] body\n"
	if(knocked_out && stat != DEAD)
		msg += "They seem to be unconscious\n"
	if(stat == DEAD)
		if(src.check_tod() && is_revivable())
			msg += "They're not breathing"
		else
			if(has_limb("head"))
				msg += "Their eyes have gone blank, there are no signs of life"
			else
				msg += "They are definitely dead"
	else
		msg += "[self ? "You're":"They're"] alive and breathing"


	to_chat(usr,SPAN_WARNING(msg))


/mob/living/carbon/human/verb/view_manifest()
	set name = "View Crew Manifest"
	set category = "IC"

	if(faction != FACTION_MARINE && !(faction in FACTION_LIST_WY))
		to_chat(usr, SPAN_WARNING("You have no access to [MAIN_SHIP_NAME] crew manifest."))
		return
	var/dat = GLOB.data_core.get_manifest()

	show_browser(src, dat, "Crew Manifest", "manifest", "size=400x750")

/mob/living/carbon/human/proc/set_species(var/new_species, var/default_colour)
	if(!new_species)
		new_species = "Human"

	if(species)
		if(species.name && species.name == new_species) //we're already that species.
			return

		// Clear out their species abilities.
		species.remove_inherent_verbs(src)

	var/datum/species/oldspecies = species

	species = all_species[new_species]

	// If an invalid new_species value is passed, just default to human
	if (!istype(species))
		species = all_species["Human"]

	if(oldspecies)
		//additional things to change when we're no longer that species
		oldspecies.post_species_loss(src)

	species.create_organs(src)

	if(species.base_color && default_colour)
		//Apply colour.
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

	INVOKE_ASYNC(src, .proc/regenerate_icons)
	INVOKE_ASYNC(src, .proc/restore_blood)
	INVOKE_ASYNC(src, .proc/update_body, 1, 0)
	INVOKE_ASYNC(src, .proc/update_hair)

	if(species)
		return TRUE
	else
		return FALSE


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
/mob/living/carbon/human/proc/locate_squad_leader()
	if(!assigned_squad) return

	var/mob/living/carbon/human/H
	var/tl_prefix = ""
	if(hud_used)
		hud_used.locate_leader.icon_state = "trackoff"

	if(assigned_fireteam && assigned_squad.fireteam_leaders[assigned_fireteam])
		H = assigned_squad.fireteam_leaders[assigned_fireteam]
		tl_prefix = "_tl"
	else if(assigned_squad.squad_leader)
		H = assigned_squad.squad_leader
	else return

	if(H.z != src.z || get_dist(src,H) < 1 || src == H)
		hud_used.locate_leader.icon_state = "trackondirect[tl_prefix]"
	else
		hud_used.locate_leader.dir = get_dir(src,H)
		hud_used.locate_leader.icon_state = "trackon[tl_prefix]"
	return



/mob/living/carbon/proc/locate_nearest_nuke()
	if(!bomb_set) return
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
		hud_used.locate_nuke.dir = get_dir(src,N)
		hud_used.locate_nuke.icon_state = "nuke_trackon"




/mob/proc/update_sight()
	return

/mob/living/carbon/human/update_sight()
	if(stat == DEAD)
		sight |= (SEE_TURFS|SEE_MOBS|SEE_OBJS)
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_LEVEL_TWO
	else
		sight &= ~(SEE_TURFS|SEE_MOBS|SEE_OBJS)
		see_in_dark = species.darksight
		see_invisible = see_in_dark > 2 ? SEE_INVISIBLE_LEVEL_ONE : SEE_INVISIBLE_LIVING
		if(glasses)
			process_glasses(glasses)
		else
			see_invisible = SEE_INVISIBLE_LIVING




/mob/proc/update_tint()

/mob/living/carbon/human/update_tint()
	var/tint_level = VISION_IMPAIR_NONE

	if(istype(head, /obj/item/clothing/head/welding))
		var/obj/item/clothing/head/welding/O = head
		if(!O.up)
			tint_level = VISION_IMPAIR_MAX

	else if(istype(head, /obj/item/clothing/head/helmet/marine/tech))
		var/obj/item/clothing/head/helmet/marine/tech/O = head
		if(O.protection_on)
			tint_level = VISION_IMPAIR_MAX

	if(glasses && glasses.has_tint && glasses.active)
		tint_level = VISION_IMPAIR_MAX

	if(istype(wear_mask, /obj/item/clothing/mask/gas))
		var/obj/item/clothing/mask/gas/G = wear_mask
		if(G.vision_impair && tint_level < G.vision_impair)
			tint_level = G.vision_impair

	if(tint_level)
		overlay_fullscreen("tint", /obj/screen/fullscreen/impaired, tint_level)
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

/mob/living/carbon/human/verb/checkSkills()
	set name = "Check Skills"
	set category = "IC"
	set src = usr

	var/dat
	if(!usr || !usr.skills)
		dat += "NULL<br/>"
	else
		dat += "CQC: [usr.skills.get_skill_level(SKILL_CQC)]<br/>"
		dat += "Melee: [usr.skills.get_skill_level(SKILL_MELEE_WEAPONS)]<br/>"
		dat += "Firearms: [usr.skills.get_skill_level(SKILL_FIREARMS)]<br/>"
		dat += "Specialist Weapons: [usr.skills.get_skill_level(SKILL_SPEC_WEAPONS)]<br/>"
		dat += "Endurance: [usr.skills.get_skill_level(SKILL_ENDURANCE)]<br/>"
		dat += "Engineer: [usr.skills.get_skill_level(SKILL_ENGINEER)]<br/>"
		dat += "Construction: [usr.skills.get_skill_level(SKILL_CONSTRUCTION)]<br/>"
		dat += "Leadership: [usr.skills.get_skill_level(SKILL_LEADERSHIP)]<br/>"
		dat += "Medical: [usr.skills.get_skill_level(SKILL_MEDICAL)]<br/>"
		dat += "Surgery: [usr.skills.get_skill_level(SKILL_SURGERY)]<br/>"
		dat += "Pilot: [usr.skills.get_skill_level(SKILL_PILOT)]<br/>"
		dat += "Police: [usr.skills.get_skill_level(SKILL_POLICE)]<br/>"
		dat += "Powerloader: [usr.skills.get_skill_level(SKILL_POWERLOADER)]<br/>"
		dat += "Vehicles: [usr.skills.get_skill_level(SKILL_VEHICLE)]<br/>"

	show_browser(src, dat, "Skills", "checkskills")
	return

/mob/living/carbon/human/verb/remove_your_splints()
	set name = "Remove Your Splints"
	set category = "Object"

	remove_splints()

// target = person whose splints are being removed
// source = person removing the splints
/mob/living/carbon/human/proc/remove_splints(mob/living/carbon/human/source)
	var/mob/living/carbon/human/HT = src
	var/mob/living/carbon/human/HS = source

	if(!istype(HS))
		HS = src
	if(!istype(HS) || !istype(HT))
		return

	var/cur_hand = "l_hand"
	if(!HS.hand)
		cur_hand = "r_hand"

	if(!HS.action_busy)
		var/list/obj/limb/to_splint = list()
		var/same_arm_side = FALSE // If you are trying to splint yourself, need opposite hand to splint an arm/hand
		if(HS.get_limb(cur_hand).status & LIMB_DESTROYED)
			to_chat(HS, SPAN_WARNING("You cannot remove splints without a hand."))
			return
		for(var/bodypart in list("l_leg","r_leg","l_arm","r_arm","r_hand","l_hand","r_foot","l_foot","chest","head","groin"))
			var/obj/limb/l = HT.get_limb(bodypart)
			if(l && l.status & LIMB_SPLINTED)
				if(HS == HT)
					if((bodypart in list("l_arm", "l_hand")) && (cur_hand == "l_hand"))
						same_arm_side = TRUE
						continue
					if((bodypart in list("r_arm", "r_hand")) && (cur_hand == "r_hand"))
						same_arm_side = TRUE
						continue
				to_splint.Add(l)

		var/msg = "" // Have to use this because there are issues with the to_chat macros and text macros and quotation marks
		if(to_splint.len)
			if(do_after(HS, HUMAN_STRIP_DELAY * HS.get_skill_duration_multiplier(SKILL_MEDICAL), INTERRUPT_ALL, BUSY_ICON_GENERIC, HT, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
				var/can_reach_splints = TRUE
				var/amount_removed = 0
				if(wear_suit && istype(wear_suit,/obj/item/clothing/suit/space))
					var/obj/item/clothing/suit/space/suit = HT.wear_suit
					if(suit.supporting_limbs && suit.supporting_limbs.len)
						msg = "[HS == HT ? "your":"\proper [HT]'s"]"
						to_chat(HS, SPAN_WARNING("You cannot remove the splints, [msg] [suit] is supporting some of the breaks."))
						can_reach_splints = FALSE
				if(can_reach_splints)
					var/obj/item/stack/W = new /obj/item/stack/medical/splint(HS.loc)
					W.amount = 0 //we checked that we have at least one bodypart splinted, so we can create it no prob. Also we need amount to be 0
					W.add_fingerprint(HS)
					for(var/obj/limb/l in to_splint)
						amount_removed += 1
						l.status &= ~LIMB_SPLINTED
						pain.recalculate_pain()
						if(!W.add(1))
							W = new /obj/item/stack/medical/splint(HS.loc)//old stack is dropped, time for new one
							W.amount = 0
							W.add_fingerprint(HS)
							W.add(1)
					msg = "[HS == HT ? "their own":"\proper [HT]'s"]"
					HT.visible_message(SPAN_NOTICE("[HS] removes [msg] [amount_removed>1 ? "splints":"splint"]."), \
						SPAN_NOTICE("Your [amount_removed>1 ? "splints are":"splint is"] removed."))
					HT.update_med_icon()
			else
				msg = "[HS == HT ? "your":"\proper [HT]'s"]"
				to_chat(HS, SPAN_NOTICE("You stop trying to remove [msg] splints."))
		else
			if(same_arm_side)
				to_chat(HS, SPAN_WARNING("You need to use the opposite hand to remove the splints on your arm and hand!"))
			else
				to_chat(HS, SPAN_WARNING("There are no splints to remove."))

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
	. = ..(mapload, "Synthetic")

/mob/living/carbon/human/synthetic_old/Initialize(mapload)
	. = ..(mapload, "Early Synthetic")

/mob/living/carbon/human/synthetic_2nd_gen/Initialize(mapload)
	. = ..(mapload, "Second Generation Synthetic")


/mob/living/carbon/human/resist_fire()
	if(isYautja(src))
		adjust_fire_stacks(HUNTER_FIRE_RESIST_AMOUNT, min_stacks = 0)
		KnockDown(1, TRUE) // actually 0.5
		spin(5, 1)
		visible_message(SPAN_DANGER("[src] expertly rolls on the floor, greatly reducing the amount of flames!"), \
			SPAN_NOTICE("You expertly roll to extinguish the flames!"), null, 5)
	else
		adjust_fire_stacks(HUMAN_FIRE_RESIST_AMOUNT, min_stacks = 0)
		KnockDown(4, TRUE)
		spin(35, 2)
		visible_message(SPAN_DANGER("[src] rolls on the floor, trying to put themselves out!"), \
			SPAN_NOTICE("You stop, drop, and roll!"), null, 5)

	if(istype(get_turf(src), /turf/open/gm/river))
		ExtinguishMob()

	if(fire_stacks > 0)
		return

	visible_message(SPAN_DANGER("[src] has successfully extinguished themselves!"), \
			SPAN_NOTICE("You extinguish yourself."), null, 5)

/mob/living/carbon/human/resist_acid()
	var/sleep_amount = 1
	if(isYautja(src))
		KnockDown(1, TRUE)
		spin(10, 2)
		visible_message(SPAN_DANGER("[src] expertly rolls on the floor!"), \
			SPAN_NOTICE("You expertly roll to get rid of the acid!"), null, 5)
	else
		KnockDown(1.5, TRUE)
		spin(15, 2)
		visible_message(SPAN_DANGER("[src] rolls on the floor, trying to get the acid off!"), \
			SPAN_NOTICE("You stop, drop, and roll!"), null, 5)

	sleep(sleep_amount)

	visible_message(SPAN_DANGER("[src] has successfully removed the acid!"), \
			SPAN_NOTICE("You get rid of the acid."), null, 5)
	extinguish_acid()
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
		visible_message(SPAN_DANGER("[src] is attempting to break out of [restraint]..."), \
		SPAN_NOTICE("You use your superior zombie strength to start breaking [restraint]..."))
		if(!do_after(src, 100, INTERRUPT_NO_NEEDHAND^INTERRUPT_RESIST, BUSY_ICON_HOSTILE))
			return

		if(!restraint || buckled)
			return
		visible_message(SPAN_DANGER("[src] tears [restraint] in half!"), \
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
			O.show_message(SPAN_DANGER("<B>[src] is trying to break [restraint]!</B>"), 1)
		if(!do_after(src, 50, INTERRUPT_NO_NEEDHAND^INTERRUPT_RESIST, BUSY_ICON_HOSTILE))
			return

		if(!restraint || buckled)
			return
		for(var/mob/O in viewers(src))
			O.show_message(SPAN_DANGER("<B>[src] manages to break [restraint]!</B>"), 1)
		to_chat(src, SPAN_WARNING("You successfully break [restraint]."))
		say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
		if(handcuffed)
			QDEL_NULL(handcuffed)
			handcuff_update()
		else
			QDEL_NULL(legcuffed)
			handcuff_update()
	else
		var/displaytime = max(1, round(breakouttime / 600)) //Minutes
		to_chat(src, SPAN_WARNING("You attempt to remove [restraint]. (This will take around [displaytime] minute(s) and you need to stand still)"))
		for(var/mob/O in viewers(src))
			O.show_message(SPAN_DANGER("<B>[usr] attempts to remove [restraint]!</B>"), 1)
		if(!do_after(src, breakouttime, INTERRUPT_NO_NEEDHAND^INTERRUPT_RESIST, BUSY_ICON_HOSTILE))
			return

		if(!restraint || buckled)
			return // time leniency for lag which also might make this whole thing pointless but the server
		for(var/mob/O in viewers(src))//                                         lags so hard that 40s isn't lenient enough - Quarxink
			O.show_message(SPAN_DANGER("<B>[src] manages to remove [restraint]!</B>"), 1)
		to_chat(src, SPAN_NOTICE(" You successfully remove [restraint]."))
		drop_inv_item_on_ground(restraint)

/mob/living/carbon/human/equip_to_appropriate_slot(obj/item/W, ignore_delay = 1, var/list/slot_equipment_priority)
	if(species)
		slot_equipment_priority = species.slot_equipment_priority
	return ..(W,ignore_delay,slot_equipment_priority)
