/datum/buildmode_mode/boom
	key = "boom"
	help = "Right Click on Mode = Set explosive settings\n\
	Mouse Button on obj = Kaboom\n\
	NOTE: Using the \"Config/Launch Supplypod\" verb allows you to do this in an IC way (i.e., making a cruise missile come down from the sky and explode wherever you click!)"

	var/falloff = 1200
	var/power = 400

/datum/buildmode_mode/boom/change_settings(client/c)
	power = tgui_input_number(c?.mob, "How much explosive power should the blast have?", "Set power", 1200)
	falloff = tgui_input_number(c?.mob, "How much falloff should the blast have?", "Set falloff", 400)

/datum/buildmode_mode/boom/when_clicked(client/c, params, object)
	var/list/modifiers = params2list(params)

	var/location
	if(isturf(object))
		location = object
	if(isobj(object))
		var/obj/obj = object
		location = obj?.loc

	if(LAZYACCESS(modifiers, LEFT_CLICK))
		log_admin("Build Mode: [key_name(c)] caused an explosion(power=[power], falloff=[falloff]]")
		cell_explosion(location, power, falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("divine intervention", c))
