/obj/item/tool/crew_monitor
	name = "crew monitor"
	desc = "A tool used to get coordinates to deployed personnel. It was invented after it was found out 3/4 command officers couldn't read numbers."
	icon = 'icons/obj/items/experimental_tools.dmi'
	icon_state = "crew_monitor"
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_SMALL

	var/cooldown_to_use = 0

/obj/item/tool/crew_monitor/attack_self(var/mob/user)
	..()

	if(cooldown_to_use > world.time)
		return

	ui_interact(user)

	cooldown_to_use = world.time + 2 SECONDS

/obj/item/tool/crew_monitor/ui_interact(var/mob/user as mob)
	user.set_interaction(src)

	var/dat = "<head><title>Crew Monitor</title></head><body>"
	dat += get_crew_info(user)

	dat += "<BR><A HREF='?src=\ref[user];mach_close=crew_monitor'>Close</A>"
	show_browser(user, dat, name, "crew_monitor", "size=600x700")
	onclose(user, "crew_monitor")

/obj/item/tool/crew_monitor/proc/get_crew_info(var/mob/user)
	var/dat = ""
	dat += {"
	<script type="text/javascript">
		function updateSearch() {
			var filter_text = document.getElementById("filter");
			var filter = filter_text.value.toLowerCase();

			var marine_list = document.getElementById("marine_list");
			var ltr = marine_list.getElementsByTagName("tr");

			for(var i = 0; i < ltr.length; ++i) {
				try {
					var tr = ltr\[i\];
					tr.style.display = '';
					var ltd = tr.getElementsByTagName("td")
					var name = ltd\[0\].innerText.toLowerCase();
					var role = ltd\[1\].innerText.toLowerCase()
					if(name.indexOf(filter) == -1 && role.indexOf(filter) == -1) {
						tr.style.display = 'none';
					}
				} catch(err) {}
			}
		}
	</script>
	"}

	var/turf/user_turf = get_turf(user)

	dat += "<center><b>Search:</b> <input type='text' id='filter' value='' onkeyup='updateSearch();' style='width:300px;'></center>"
	dat += "<table id='marine_list' border='2px' style='width: 100%; border-collapse: collapse;' align='center'><tr>"
	dat += "<th>Name</th><th>Squad</th><th>Role</th><th>State</th><th>Location</th><th>Distance</th></tr>"
	for(var/datum/squad/S in RoleAuthority.squads)
		var/list/squad_roles = ROLES_MARINES.Copy()
		for(var/i in squad_roles)
			squad_roles[i] = ""
		var/misc_roles = ""

		for(var/X in S.marines_list)
			if(!X)
				continue //just to be safe
			var/mob_name = "unknown"
			var/mob_state = ""
			var/squad = "None"
			var/role = "unknown"
			var/dist = "<b>???</b>"
			var/area_name = "<b>???</b>"
			var/mob/living/carbon/human/H
			if(ishuman(X))
				H = X
				mob_name = H.real_name
				var/area/A = get_area(H)
				var/turf/M_turf = get_turf(H)
				if(A)
					area_name = sanitize(A.name)

				if(H.undefibbable)
					continue

				if(H.job)
					role = H.job
				else if(istype(H.wear_id, /obj/item/card/id)) //decapitated marine is mindless,
					var/obj/item/card/id/ID = H.wear_id		//we use their ID to get their role.
					if(ID.rank)
						role = ID.rank

				if(M_turf)
					var/area/mob_area = M_turf.loc
					var/area/user_area = user_turf.loc
					if(M_turf.z == user_turf.z && mob_area.fake_zlevel == user_area.fake_zlevel)
						dist = "[get_dist(H, user)] ([dir2text_short(get_dir(user, H))])"

				if(H.assigned_squad)
					squad = H.assigned_squad.name

				switch(H.stat)
					if(CONSCIOUS)
						mob_state = "Conscious"
					if(UNCONSCIOUS)
						if(H.health < 0)
							mob_state = "<b>Critical</b>"
						else
							mob_state = "Unconscious"
					if(DEAD)
						mob_state = "<b>Dead</b>"

			var/marine_infos = "<tr><td>[mob_name]</a></td><td>[squad]</td><td>[role]</td><td>[mob_state]</td><td>[area_name]</td><td>[dist]</td></tr>"
			if(role in squad_roles)
				squad_roles[role] += marine_infos
			else
				misc_roles += marine_infos

		for(var/i in squad_roles)
			dat += squad_roles[i]
		dat += misc_roles

	dat += "</table>"
	dat += "<br><hr>"
	return dat

/obj/item/clothing/suit/auto_cpr
	name = "autocompressor" //autocompressor
	desc = "A device that gives regular compression to the victim's ribcage, used in case of urgent heart issues.\nClick a person with it to place it on them."
	icon = 'icons/obj/items/experimental_tools.dmi'
	icon_state = "autocomp"
	item_state = "autocomp"
	item_state_slots = list(WEAR_JACKET = "autocomp")
	w_class = SIZE_MEDIUM
	flags_equip_slot = SLOT_OCLOTHING
	flags_atom = FPRINT|CONDUCT
	flags_item = NOBLUDGEON
	force = 5
	throwforce = 5
	var/last_pump
	var/doing_cpr = FALSE
	var/pump_cost = 20
	var/obj/item/cell/pdcell = null
	movement_compensation = 0

/obj/item/clothing/suit/auto_cpr/Initialize(mapload, ...)
	. = ..()
	pdcell = new/obj/item/cell(src) //has 1000 charge
	update_icon()

/obj/item/clothing/suit/auto_cpr/mob_can_equip(mob/living/carbon/human/H, slot, disable_warning = 0, force = 0)
	. = ..()
	if(!isHumanStrict(H))
		return FALSE

/obj/item/clothing/suit/auto_cpr/attack(mob/living/carbon/human/M, mob/living/user)
	if(M == user)
		return ..()
	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		to_chat(user, SPAN_WARNING("You have no idea how to use \the [src]..."))
		return
	if(M.stat == CONSCIOUS)
		to_chat(user, SPAN_WARNING("They're fine, no need for <b>CPR</b>!"))
		return
	if(!M.is_revivable() || !M.check_tod())
		to_chat(user, SPAN_WARNING("That won't be of any use, they're already too far gone!"))
		return
	if(istype(M) && user.a_intent == INTENT_HELP)
		if(M.wear_suit)
			to_chat(user, SPAN_WARNING("Their [M.wear_suit] is in the way, remove it first!"))
			return
		if(!mob_can_equip(M, WEAR_JACKET))
			to_chat(user, SPAN_WARNING("\The [src] only fits on humans!"))
			return
		user.affected_message(M,
							SPAN_NOTICE("You start fitting \the [src] onto [M]'s chest."),
							SPAN_WARNING("[user] starts fitting \the [src] onto your chest!"),
							SPAN_NOTICE("[user] starts fitting \the [src] onto [M]'s chest."))
		if(!(do_after(user, HUMAN_STRIP_DELAY * user.get_skill_duration_multiplier(), INTERRUPT_ALL, BUSY_ICON_GENERIC, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL)))
			return
		if(!mob_can_equip(M, WEAR_JACKET))
			return
		user.drop_inv_item_on_ground(src)
		if(!M.equip_to_slot_if_possible(src, WEAR_JACKET))
			user.put_in_active_hand(src)
			return
		M.update_inv_wear_suit()
	else
		return ..()

/obj/item/clothing/suit/auto_cpr/equipped(mob/user, slot)
	..()
	if(slot == WEAR_JACKET)
		start_cpr()

/obj/item/clothing/suit/auto_cpr/unequipped(mob/user, slot)
	. = ..()
	if(slot == WEAR_JACKET)
		end_cpr()


/obj/item/clothing/suit/auto_cpr/update_icon()
	. = ..()
	if(doing_cpr)
		icon_state = "autocomp_active"
	else
		icon_state = "autocomp"
	if(pdcell && pdcell.charge)
		overlays.Cut()
	switch(round(pdcell.charge * 100 / pdcell.maxcharge))
		if(66 to INFINITY)
			overlays += "cpr_batt_hi"
		if(65 to 33)
			overlays += "cpr_batt_mid"
		if(32 to 1)
			overlays += "cpr_batt_lo"

/obj/item/clothing/suit/auto_cpr/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("It has [round(pdcell.charge * 100 / pdcell.maxcharge)]% charge remaining."))



/obj/item/clothing/suit/auto_cpr/proc/start_cpr()
	if(doing_cpr)
		return
	src.visible_message(SPAN_NOTICE("\The [src] whirrs into life and begins pumping."))
	START_PROCESSING(SSobj,src)
	doing_cpr = TRUE
	update_icon()

/obj/item/clothing/suit/auto_cpr/proc/end_cpr()
	if(!doing_cpr)
		return
	doing_cpr = FALSE
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.drop_inv_item_on_ground(src)
		src.visible_message(SPAN_NOTICE("\The [src] automatically detaches from [H]!"))
	src.visible_message(SPAN_NOTICE("\The [src] powers down and stops pumping."))
	STOP_PROCESSING(SSobj,src)
	update_icon()

/obj/item/clothing/suit/auto_cpr/process()
	if(!ishuman(loc))
		end_cpr()
		return PROCESS_KILL

	var/mob/living/carbon/human/H = loc
	if(H.wear_suit != src)
		end_cpr()
		return PROCESS_KILL

	if(pdcell.charge <= 49)
		src.visible_message(SPAN_NOTICE("\The [src] beeps its low power alarm."))
		end_cpr()
		return PROCESS_KILL

	if(world.time > last_pump + 10 SECONDS)
		last_pump = world.time
		if(H.stat == UNCONSCIOUS)
			var/suff = min(H.getOxyLoss(), 10) //Pre-merge level, less healing, more prevention of dying.
			H.apply_damage(-suff, OXY)
			H.updatehealth()
			H.affected_message(H,
				SPAN_HELPFUL("You feel a <b>breath of fresh air</b> enter your lungs. It feels good."),
				message_viewer = SPAN_NOTICE("<b>\The [src]</b> automatically performs <b>CPR</b> on <b>[H]</b>.")
				)
			pdcell.use(pump_cost)
			update_icon()
			return
		else if(H.is_revivable() && H.stat == DEAD)
			if(H.cpr_cooldown < world.time)
				H.revive_grace_period += 7 SECONDS
				H.visible_message(SPAN_NOTICE("<b>\The [src]</b> automatically performs <b>CPR</b> on <b>[H]</b>."))
			else
				H.visible_message(SPAN_NOTICE("<b>\The [src]</b> fails to perform CPR on <b>[H]</b>."))
				if(prob(50))
					var/obj/limb/E = H.get_limb("chest")
					E.fracture(100)
			H.cpr_cooldown = world.time + 7 SECONDS
			pdcell.use(pump_cost)
			update_icon()
			return
		else
			end_cpr()
			return PROCESS_KILL
