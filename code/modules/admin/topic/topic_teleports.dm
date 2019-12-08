/datum/admins/proc/topic_teleports(var/href)
	switch(href)
		if("jump_to_area")
			var/area/choice = input(owner, "Pick an area to jump to:") as null|anything in return_sorted_areas()
			if(isnull(choice))
				return

			owner.jump_to_area(choice)

		if("jump_to_turf")
			var/turf/choice = input(owner, "Pick a turf to jump to:") as null|anything in turfs
			if(isnull(choice))
				return

			owner.jump_to_turf(choice)

		if("jump_to_mob")
			var/mob/choice = input(owner, "Pick a mob to jump to:") as null|anything in mob_list
			if(isnull(choice))
				return

			owner.jumptomob(choice)

		if("jump_to_coord")
			var/targ_x = input("Jump to x from 0 to [world.maxx].") as num
			if(!targ_x || targ_x < 0)
				return
			var/targ_y = input("Jump to y from 0 to [world.maxy].") as num
			if(!targ_y || targ_y < 0)
				return
			var/targ_z = input("Jump to z from 0 to [world.maxz].") as num
			if(!targ_z || targ_z < 0)
				return

			owner.jumptocoord(targ_x, targ_y, targ_z)

		if("jump_to_obj")
			var/obj/choice = input(owner, "Pick an object to jump to:") as null|anything in object_list
			if(isnull(choice))
				return

			owner.jump_to_object(choice)

		if("jump_to_key")
			owner.jumptokey()

		if("get_mob")
			var/mob/choice = input(owner, "Pick a mob to teleport here:","Get Mob",null) as null|anything in mob_list
			if(isnull(choice))
				return

			owner.Getmob(choice)

		if("get_key")
			owner.Getkey()

		if("teleport_mob_to_area")
			var/mob/choice = input(owner, "Pick a mob to an area:","Teleport Mob",null) as null|anything in sortmobs()
			if(isnull(choice))
				return

			owner.sendmob(choice)