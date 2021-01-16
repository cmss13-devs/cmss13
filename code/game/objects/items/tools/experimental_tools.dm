/obj/item/tool/crew_monitor
	name = "crew monitor"
	desc = "A tool used to get coordinates to deployed personnel. It was invented after it was found out 3/4 command officers couldn't read numbers."
	icon = 'icons/obj/items/experimental_tools.dmi'
	icon_state = "crew_monitor"
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_SMALL

	var/cooldown_to_use = 0

/obj/item/tool/crew_monitor/attack_self(var/mob/user)
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
		var/leader_text = ""
		var/spec_text = ""
		var/medic_text = ""
		var/engi_text = ""
		var/smart_text = ""
		var/marine_text = ""
		var/misc_text = ""

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

				if(M_turf && (M_turf.z == user_turf.z))
					dist = "[get_dist(H, user)] ([dir2text_short(get_dir(user, H))])"

				if(H.assigned_squad)
					squad = H.assigned_squad.name

				switch(H.stat)
					if(CONSCIOUS)
						mob_state = "Conscious"
					if(UNCONSCIOUS)
						mob_state = "<b>Unconscious</b>"
					else
						mob_state = "<b>Dead</b>"

			var/marine_infos = "<tr><td>[mob_name]</a></td><td>[squad]</td><td>[role]</td><td>[mob_state]</td><td>[area_name]</td><td>[dist]</td></tr>"
			switch(role)
				if(JOB_SQUAD_LEADER)
					leader_text += marine_infos
				if(JOB_SQUAD_SPECIALIST)
					spec_text += marine_infos
				if(JOB_SQUAD_MEDIC)
					medic_text += marine_infos
				if(JOB_SQUAD_ENGI)
					engi_text += marine_infos
				if(JOB_SQUAD_SMARTGUN)
					smart_text += marine_infos
				if(JOB_SQUAD_MARINE)
					marine_text += marine_infos
				else
					misc_text += marine_infos

		dat += leader_text + spec_text + medic_text + engi_text + smart_text + marine_text + misc_text

	dat += "</table>"
	dat += "<br><hr>"
	return dat
