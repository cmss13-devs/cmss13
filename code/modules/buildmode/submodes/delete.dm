/datum/buildmode_mode/delete
	key = "delete"
	help = "Left Mouse Button on anything to delete it. If you break it, you buy it.\n\
	Right Mouse Button on anything to delete everything of the type. Probably don\'t do this unless you know what you are doing."

#define DELETE_STRICT "Strict type"
#define DELETE_TYPE_AND_SUBTYPES "Type and subtypes"
#define DELETE_CANCEL "Cancel"

#define CONFIRM_YES "Yes"
#define CONFIRM_NO "No"

/datum/buildmode_mode/delete/when_clicked(client/c, params, object)
	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, LEFT_CLICK))
		if(isturf(object))
			var/turf/T = object
			T.ScrapeAway()
		else if(isatom(object))
			qdel(object)

	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if(check_rights(R_DEBUG|R_SERVER)) //Prevents buildmoded non-admins from breaking everything.
			if(isturf(object))
				return
			var/atom/deleting = object
			var/action_type = tgui_alert(usr, "Strict type ([deleting.type]) or type and all subtypes?", "Type Selection", list(DELETE_STRICT, DELETE_TYPE_AND_SUBTYPES, DELETE_CANCEL))
			if(action_type == DELETE_CANCEL || !action_type)
				return

			if(tgui_alert(usr,"Are you really sure you want to delete all instances of type [deleting.type]?", "Confirmation", list(CONFIRM_YES, CONFIRM_NO)) != CONFIRM_YES)
				return

			if(tgui_alert(usr,"Second confirmation required. Delete?", "Double Confirmation", list(CONFIRM_YES, CONFIRM_NO)) != CONFIRM_YES)
				return

			var/o_type = deleting.type
			switch(action_type)
				if(DELETE_STRICT)
					var/i = 0
					for(var/atom/obj in world)
						if(obj.type == o_type)
							i++
							qdel(obj)
						CHECK_TICK
					if(!i)
						to_chat(usr, "No instances of this type exist")
						return
					log_admin("[key_name(usr)] deleted all instances of type [o_type] ([i] instances deleted) ")
					message_admins(SPAN_NOTICE("[key_name(usr)] deleted all instances of type [o_type] ([i] instances deleted) "))
				if(DELETE_TYPE_AND_SUBTYPES)
					var/i = 0
					for(var/obj in world)
						if(istype(obj, o_type))
							i++
							qdel(obj)
						CHECK_TICK
					if(!i)
						to_chat(usr, "No instances of this type exist")
						return
					log_admin("[key_name(usr)] deleted all instances of type or subtype of [o_type] ([i] instances deleted) ")
					message_admins(SPAN_NOTICE("[key_name(usr)] deleted all instances of type or subtype of [o_type] ([i] instances deleted) "))

#undef DELETE_STRICT
#undef DELETE_TYPE_AND_SUBTYPES
#undef DELETE_CANCEL

#undef CONFIRM_YES
#undef CONFIRM_NO
