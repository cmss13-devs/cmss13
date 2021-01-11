// A special pen for service droids. Can be toggled to switch between normal writting mode, and paper rename mode
// Allows service droids to rename paper items.

/obj/item/tool/pen/robopen
	desc = "A black ink printing attachment with a paper naming mode."
	name = "Printing Pen"
	var/mode = 1

/obj/item/tool/pen/robopen/attack_self(mob/user as mob)

	var/choice = tgui_input_list(usr, "Would you like to change colour or mode?", list("Colour","Mode"))
	if(!choice) return

	playsound(src.loc, 'sound/effects/pop.ogg', 25, 0)

	switch(choice)

		if("Colour")
			var/newcolour = tgui_input_list(usr, "Which colour would you like to use?", list("black","blue","red","green","yellow"))
			if(newcolour) colour = newcolour

		if("Mode")
			if (mode == 1)
				mode = 2
			else
				mode = 1
			to_chat(user, "Changed printing mode to '[mode == 2 ? "Rename Paper" : "Write Paper"]'")

	return

// Copied over from paper's rename verb
// see code\modules\paperwork\paper.dm line 62

/obj/item/tool/pen/robopen/proc/RenamePaper(mob/user as mob,obj/paper as obj)
	if ( !user || !paper )
		return
	var/n_name = input(user, "What would you like to label the paper?", "Paper Labelling", null)  as text
	if ( !user || !paper )
		return

	n_name = copytext(n_name, 1, 32)
	if(( get_dist(user,paper) <= 1  && user.stat == 0))
		paper.name = "paper[(n_name ? text("- '[n_name]'") : null)]"
	add_fingerprint(user)
	return

//TODO: Add prewritten forms to dispense when you work out a good way to store the strings.
/obj/item/form_printer
	//name = "paperwork printer"
	name = "paper dispenser"
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "paper_bin1"
	item_state = "sheet-metal"

/obj/item/form_printer/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	return

/obj/item/form_printer/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag, params)

	if(!target || !flag)
		return

	if(istype(target,/obj/structure/surface/table))
		deploy_paper(get_turf(target))

/obj/item/form_printer/attack_self(mob/user as mob)
	deploy_paper(get_turf(src))

/obj/item/form_printer/proc/deploy_paper(var/turf/T)
	T.visible_message(SPAN_NOTICE("\The [src.loc] dispenses a sheet of crisp white paper."))
	new /obj/item/paper(T)


//Personal shielding for the combat module.
/obj/item/robot/combat/shield
	name = "personal shielding"
	desc = "A powerful experimental module that turns aside or absorbs incoming attacks at the cost of charge."
	icon = 'icons/obj/structures/props/decals.dmi'
	icon_state = "shock"
	var/shield_level = 0.5 //Percentage of damage absorbed by the shield.

/obj/item/robot/combat/shield/verb/set_shield_level()
	set name = "Set shield level"
	set category = "Object"
	set src in range(0)

	var/N = tgui_input_list(usr, "How much damage should the shield absorb?", "Shield level", list("5","10","25","50","75","100"))
	if (N)
		shield_level = text2num(N)/100

/obj/item/robot/combat/mobility
	name = "mobility module"
	desc = "By retracting limbs and tucking in its head, a combat android can roll at high speeds."
	icon = 'icons/obj/structures/props/decals.dmi'
	icon_state = "shock"
