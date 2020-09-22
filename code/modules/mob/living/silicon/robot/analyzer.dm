//
//Robotic Component Analyser, basically a health analyser for robots
//
/obj/item/device/robotanalyzer
	name = "cyborg analyzer"
	icon_state = "robotanalyzer"
	item_state = "analyzer"
	desc = "A hand-held scanner able to diagnose robotic injuries."
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	throwforce = 3
	w_class = SIZE_SMALL
	throw_speed = SPEED_VERY_FAST
	throw_range = 10
	matter = list("metal" = 200)
	
	var/mode = 1;

/obj/item/device/robotanalyzer/attack(mob/living/M as mob, mob/living/user as mob)
	if((user.getBrainLoss() >= 60) && prob(50))
		to_chat(user, (SPAN_DANGER("You try to analyze the floor's vitals!")))
		for(var/mob/O in viewers(M, null))
			O.show_message(text(SPAN_DANGER("[user] has analyzed the floor's vitals!")), 1)
		user.show_message(text(SPAN_NOTICE("Analyzing Results for The floor:\n\t Overall Status: Healthy")), 1)
		user.show_message(text(SPAN_NOTICE("\t Damage Specifics: [0]-[0]-[0]-[0]")), 1)
		user.show_message(SPAN_NOTICE("Key: Suffocation/Toxin/Burns/Brute"), 1)
		user.show_message(SPAN_NOTICE("Body Temperature: ???"), 1)
		return
	if(!(istype(user, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		to_chat(user, SPAN_DANGER("You don't have the dexterity to do this!"))
		return
	if(!isrobot(M) && !isSynth(M))
		to_chat(user, SPAN_DANGER("You can't analyze non-robotic things!"))
		return

	user.visible_message(SPAN_NOTICE("[user] has analyzed [M]'s components."), SPAN_NOTICE("You have analyzed [M]'s components."))
	var/BU = M.getFireLoss() > 50 	? 	"<b>[M.getFireLoss()]</b>" 		: M.getFireLoss()
	var/BR = M.getBruteLoss() > 50 	? 	"<b>[M.getBruteLoss()]</b>" 	: M.getBruteLoss()
	user.show_message(SPAN_NOTICE("Analyzing Results for [M]:\n\t Overall Status: [M.stat > 1 ? "fully disabled" : "[M.health - M.halloss]% functional"]"))
	user.show_message("\t Key: <font color='#FFA500'>Electronics</font>/<font color='red'>Brute</font>", 1)
	user.show_message("\t Damage Specifics: <font color='#FFA500'>[BU]</font> - <font color='red'>[BR]</font>")
	if(M.tod && M.stat == DEAD)
		user.show_message(SPAN_NOTICE("Time of Disable: [M.tod]"))

	if (isrobot(M))
		var/mob/living/silicon/robot/H = M
		var/list/damaged = H.get_damaged_components(1,1,1)
		user.show_message(SPAN_NOTICE("Localized Damage:"),1)
		if(length(damaged)>0)
			for(var/datum/robot_component/org in damaged)
				var/organ_name = capitalize(org.name)
				var/organ_destroyed_msg = (org.installed == -1) ? "<font color='red'><b>DESTROYED</b></font> ":""
				var/organ_elec_dmg_msg = (org.electronics_damage > 0) ? "<font color='#FFA500'>[org.electronics_damage]</font>":0
				var/organ_brute_dmg_msg = (org.brute_damage > 0) ? "<font color='red'>[org.brute_damage]</font>":0
				var/organ_toggled_msg = (org.toggled) ? "Toggled ON" : "<font color='red'>Toggled OFF</font>"
				var/organ_powered_msg = (org.powered) ? "Power ON" : "<font color='red'>Power OFF</font>"
				user.show_message(SPAN_NOTICE("\t [organ_name]: [organ_destroyed_msg][organ_elec_dmg_msg] - [organ_brute_dmg_msg] - [organ_toggled_msg] - [organ_powered_msg]"), 1)
		else
			user.show_message(SPAN_NOTICE("\t Components are OK."),1)

	if (isSynth(M))
		var/mob/living/carbon/human/H = M
		var/list/damaged = H.get_damaged_limbs(1,1)
		user.show_message(SPAN_NOTICE("Localized Damage, Brute/Electronics:"),1)
		if(length(damaged)>0)
			for(var/obj/limb/org in damaged)
				var/msg_display_name = "[capitalize(org.display_name)]" // Here for now until we purge this useless shitcode
				var/msg_brute_dmg = "[(org.brute_dam > 0)	?	SPAN_DANGER("[org.brute_dam]") : "0"]"
				var/msg_burn_dmg = "[(org.brute_dam > 0)	?	SPAN_DANGER("[org.brute_dam]") : "0"]"
				user.show_message(SPAN_NOTICE("\t [msg_display_name]: [msg_brute_dmg] - [msg_burn_dmg]"), 1)
		else
			user.show_message(SPAN_NOTICE("\t Components are OK."),1)

	user.show_message(SPAN_NOTICE("Operating Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)"), 1)

	src.add_fingerprint(user)
	return
