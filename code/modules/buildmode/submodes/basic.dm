/datum/buildmode_mode/basic
	key = "basic"
	help = "Left Mouse Button  = Construct / Upgrade \n\
	Right Mouse Button = Manipulation Menu\n\
	Right Mouse Button + ctrl = Quick delete\n\
	Left Mouse Button + ctrl = Object Creation Menu\n\
	Use the button in the upper left corner to\n\
	change the direction of built objects"
	var/list/radial_menu_options = list()

/datum/buildmode_mode/basic/when_clicked(client/admin_building, params, atom/clicked_atom)
	var/list/modifiers = params2list(params)

	var/left_click = LAZYACCESS(modifiers, LEFT_CLICK)
	var/right_click = LAZYACCESS(modifiers, RIGHT_CLICK)
	var/alt_click = LAZYACCESS(modifiers, ALT_CLICK)
	var/ctrl_click = LAZYACCESS(modifiers, CTRL_CLICK)
	if(istype(clicked_atom, /atom/movable/screen/radial)) //we're actively using radials in basic mode, so don't intercept any clicks that target those.
		return TRUE
	if(istype(clicked_atom, /turf))
		var/turf/clicked_turf = clicked_atom
		if(left_click && !alt_click && !ctrl_click)
			var/list/upgrade_reference = list(
				/turf/closed/wall/almayer/outer = null,
				/turf/closed/wall/r_wall = /turf/closed/wall/almayer/outer,
				/turf/closed/wall = /turf/closed/wall/r_wall,
				/turf/open/floor/plating = /turf/open/floor/almayer,
				/turf/open/floor = /turf/closed/wall,
			)
			var/turf/upgrade_version
			for(var/i in upgrade_reference)
				if(istype(clicked_atom, i))
					upgrade_version = upgrade_reference[i]
					break
			if(upgrade_version)
				clicked_turf.PlaceOnTop(upgrade_version)
			else
				clicked_turf.PlaceOnTop(/turf/open/floor/plating)
			log_admin("Build Mode: [key_name(admin_building)] built [upgrade_version] at [AREACOORD(clicked_turf)]")
			return
		else if(right_click && !alt_click && !ctrl_click)
			var/destruction_switch = "Make Indestructible"
			if(clicked_atom.unacidable || clicked_atom.explo_proof || CHECK_BITFIELD(clicked_turf.turf_flags, TURF_HULL))
				destruction_switch = "Make Destructible"
			radial_menu_options = list(
					"Destroy" = image('icons/misc/buildmode.dmi', icon_state = "buildquit"),
					"[destruction_switch]" = image('icons/misc/buildmode.dmi', icon_state = "build", dir = NORTH),
					"Downgrade" = image('icons/misc/buildmode.dmi', icon_state = "build"),
					"Turn" = image('icons/misc/buildmode.dmi', icon_state = "buildmode_edit"),
				)
			if(GLOB.radial_menus["buildmode_basic_turf_[key_name(admin_building)]"])
				return
			var/picked_option = show_radial_menu(admin_building.mob, clicked_atom, radial_menu_options, tooltips = TRUE, uniqueid = "buildmode_basic_turf_[key_name(admin_building)]")
			switch(picked_option)
				if("Destroy")
					log_admin("Build Mode: [key_name(admin_building)] deleted [clicked_turf] at [AREACOORD(clicked_turf)]")
					clicked_turf.ScrapeAway()
				if("Downgrade")
					var/list/downgrade_reference = list(
						/turf/closed/wall/almayer/outer = /turf/closed/wall/r_wall,
						/turf/closed/wall/r_wall = /turf/closed/wall,
					)
					var/turf/downgrade_version
					for(var/i in downgrade_reference)
						if(istype(clicked_atom, i))
							downgrade_version = downgrade_reference[i]
					if(downgrade_version)
						clicked_turf.PlaceOnTop(downgrade_version)
					else
						clicked_turf.ScrapeAway()
					log_admin("Build Mode: [key_name(admin_building)] downgraded [clicked_turf] at [AREACOORD(clicked_turf)]")
				if("Make Indestructible", "Make Destructible")
					if(destruction_switch == "Make Destructible")
						clicked_atom.unacidable = FALSE
						clicked_atom.explo_proof = FALSE
						DISABLE_BITFIELD(clicked_turf.turf_flags, TURF_HULL)
					else
						clicked_atom.unacidable = TRUE
						clicked_atom.explo_proof = TRUE
						ENABLE_BITFIELD(clicked_turf.turf_flags, TURF_HULL)
					log_admin("Build Mode: [key_name(admin_building)] made [clicked_turf] [clicked_atom.explo_proof ? "indestructible" : "destructible"] at [AREACOORD(clicked_turf)]")
				if("Turn")
					radial_menu_options = list(
						"North" = image('icons/misc/buildmode.dmi', icon_state = "build", dir = NORTH),
						"East" = image('icons/misc/buildmode.dmi', icon_state = "build", dir = EAST),
						"South" = image('icons/misc/buildmode.dmi', icon_state = "build", dir = SOUTH),
						"West" = image('icons/misc/buildmode.dmi', icon_state = "build", dir = WEST),
					)
					if(GLOB.radial_menus["buildmode_basic_turf_[key_name(admin_building)]"])
						return
					var/picked_turn_option = show_radial_menu(admin_building.mob, clicked_atom, radial_menu_options, tooltips = TRUE, uniqueid = "buildmode_basic_turf_[key_name(admin_building)]")
					clicked_atom.setDir(text2dir(capitalize(picked_turn_option)))
					log_admin("Build Mode: [key_name(admin_building)] turned [clicked_turf] at [AREACOORD(clicked_turf)]")

		else if(right_click && !alt_click && ctrl_click)
			log_admin("Build Mode: [key_name(admin_building)] deleted [clicked_turf] at [AREACOORD(clicked_turf)]")
			clicked_turf.ScrapeAway()

		else if(left_click && !alt_click && ctrl_click)
			radial_menu_options = list(
				"Window" = image('icons/turf/walls/windows.dmi', icon_state = "alm_rwindow0"),
				"Door" = image('icons/obj/structures/doors/personaldoor.dmi', icon_state = "door_closed"),
				"Wall" = image('icons/turf/walls/walls.dmi', icon_state = "rwall"),
				"Barricade" = image('icons/obj/structures/barricades.dmi', icon_state = "metal_0"),
				"Plasteel Barricade" = image('icons/obj/structures/barricades.dmi', icon_state = "plasteel_0"),
				"Reinforced Table" = image('icons/obj/structures/tables.dmi', icon_state = "reinftable"),
			)
			var/list/build_options = list(
				"Window" = /obj/structure/window/framed/almayer,
				"Door" = /obj/structure/machinery/door/airlock/almayer/generic,
				"Wall" = /turf/closed/wall/r_wall,
				"Barricade" = /obj/structure/barricade/metal,
				"Plasteel Barricade" = /obj/structure/barricade/plasteel,
				"Reinforced Table" = /obj/structure/surface/table/reinforced,
				)
			var/picked_option = show_radial_menu(admin_building.mob, clicked_atom, radial_menu_options, tooltips = TRUE)
			if(picked_option)
				var/atom/build_picked = build_options[picked_option]
				var/atom/built_atom = new build_picked(get_turf(clicked_atom))
				if(picked_option != "Reinforced Table")
					built_atom.setDir(BM.build_dir)
	if(istype(clicked_atom, /obj))
		var/obj/clicked_object = clicked_atom
		var/destruction_switch = "Make Indestructible"
		if(clicked_atom.unacidable || clicked_atom.explo_proof || clicked_object.health == -1)
			destruction_switch = "Make Destructible"
		if(right_click && !alt_click && !ctrl_click)
			if(GLOB.radial_menus["buildmode_basic_obj_[key_name(admin_building)]"])
				return
			radial_menu_options = list(
					"Destroy" = image('icons/misc/buildmode.dmi', icon_state = "buildquit"),
					"[destruction_switch]" = image('icons/misc/buildmode.dmi', icon_state = "build", dir = NORTH),
					"Turn" = image('icons/misc/buildmode.dmi', icon_state = "buildmode_edit"),
				)
			var/picked_option = show_radial_menu(admin_building.mob, clicked_atom, radial_menu_options, tooltips = TRUE, uniqueid = "buildmode_basic_obj_[key_name(admin_building)]")
			switch(picked_option)
				if("Destroy")
					log_admin("Build Mode: [key_name(admin_building)] deleted [clicked_object] at [AREACOORD(clicked_object)]")
					qdel(clicked_object)
				if("Make Indestructible", "Make Destructible")
					if(destruction_switch == "Make Destructible")
						clicked_atom.unacidable = FALSE
						clicked_atom.explo_proof = FALSE
						clicked_object.health = initial(clicked_object.health)
					else
						clicked_atom.unacidable = TRUE
						clicked_atom.explo_proof = TRUE
						clicked_object.health = -1

				if("Turn")
					if(GLOB.radial_menus["buildmode_basic_obj_[key_name(admin_building)]"])
						return
					radial_menu_options = list(
						"North" = image('icons/misc/buildmode.dmi', icon_state = "build", dir = NORTH),
						"East" = image('icons/misc/buildmode.dmi', icon_state = "build", dir = EAST),
						"South" = image('icons/misc/buildmode.dmi', icon_state = "build", dir = SOUTH),
						"West" = image('icons/misc/buildmode.dmi', icon_state = "build", dir = WEST),
					)
					var/picked_turn_option = show_radial_menu(admin_building.mob, clicked_atom, radial_menu_options, tooltips = TRUE, uniqueid = "buildmode_basic_obj_[key_name(admin_building)]")
					clicked_atom.setDir(text2dir(capitalize(picked_turn_option)))
					log_admin("Build Mode: [key_name(admin_building)] turned [clicked_object] at [AREACOORD(clicked_object)]")
		else if(right_click && !alt_click && ctrl_click)
			log_admin("Build Mode: [key_name(admin_building)] deleted [clicked_object] at [AREACOORD(clicked_object)]")
			qdel(clicked_atom)
