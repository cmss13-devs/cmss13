/datum/admins/proc/topic_events(var/href)
	switch(href)
		if("securitylevel")
			owner.change_security_level()
		if("distress")
			admin_force_distress()
		if("selfdestruct")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") == "No")
				return
			admin_force_selfdestruct()
		if("medal")
			owner.award_medal()
		if("weaponmults")
			owner.adjust_weapon_mult()
		if("pmcguns")
			owner.toggle_gun_restrictions()
		if("monkify")
			owner.turn_everyone_into_primitives()
		if("comms_blackout")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") == "No")
				return
			var/answer = alert(usr, "Would you like to alert the crew?", "Alert", "Yes", "No")
			if(answer == "Yes")
				communications_blackout(0)
			else
				communications_blackout(1)
			message_admins("[key_name_admin(usr)] triggered a communications blackout.", 1)
		if("blackout")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") == "No")
				return
			message_admins("[key_name_admin(usr)] broke all lights", 1)
			lightsout(0,0)
		if("whiteout")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") == "No")
				return
			for(var/obj/structure/machinery/light/L in machines)
				L.fix()
			message_admins("[key_name_admin(usr)] fixed all lights", 1)
		if("power")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") == "No")
				return
			message_admins(SPAN_NOTICE("[key_name_admin(usr)] powered all SMESs and APCs"), 1)
			power_restore()
		if("unpower")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") == "No")
				return
			message_admins(SPAN_NOTICE("[key_name_admin(usr)] unpowered all SMESs and APCs"), 1)
			power_failure()
		if("quickpower")
			if(alert(usr, "Are you sure you want to do this? It will laaag.", "Confirmation", "Yes", "No") == "No")
				return
			message_admins(SPAN_NOTICE("[key_name_admin(usr)] powered all SMESs"), 1)
			power_restore_quick()
		if("powereverything")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") == "No")
				return
			message_admins(SPAN_NOTICE("[key_name_admin(usr)] powered all SMESs and APCs everywhere"), 1)
			power_restore_everything()
		if("powershipreactors")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") == "No")
				return
			message_admins(SPAN_NOTICE("[key_name_admin(usr)] powered all ship reactors"), 1)
			power_restore_ship_reactors()
		if("decrease_defcon")
			if(alert(usr, "Are you sure you want to do this?", "Confirmation", "Yes", "No") == "No")
				return
			message_admins(SPAN_NOTICE("[key_name_admin(usr)] decreased DEFCON level."), 1)
			defcon_controller.decrease_defcon_level()
		if("give_defcon_points")
			var/amount = input(usr, "How many points to add?") as num
			if(amount != 0) //can add negative numbers too!
				message_admins(SPAN_NOTICE("[key_name_admin(usr)] added [amount] DEFCON points."), 1)
				objectives_controller.add_admin_points(amount)
		if("change_clearance")
			var/list/clearance_levels = list(0,1,2,3,4,5)
			var/level = input("Select new clearance level:","Current level: [chemical_research_data.clearance_level]") as null|anything in clearance_levels
			if(!level)
				return
			message_admins(SPAN_NOTICE("[key_name_admin(usr)] changed research clearance level to [level]."), 1)
			chemical_research_data.clearance_level = level
		if("give_research_credits")
			var/amount = input(usr, "How many credits to add?") as num
			if(amount != 0) //can add negative numbers too!
				message_admins(SPAN_NOTICE("[key_name_admin(usr)] added [amount] research credits."), 1)
				chemical_research_data.update_credits(amount)