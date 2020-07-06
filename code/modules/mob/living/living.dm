/mob/living/proc/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
	else
		health = maxHealth - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - halloss

	recalculate_move_delay = TRUE



/mob/living/Initialize()
	..()

	event_zoomout = new /datum/event()
	event_movement = new /datum/event()

	attack_icon = image("icon" = 'icons/effects/attacks.dmi',"icon_state" = "", "layer" = 0)

	initialize_pain()


/mob/living/Dispose()
	pipes_shown = null

	if(attack_icon)
		qdel(attack_icon)
		attack_icon = null
	if(event_zoomout)
		qdel(event_zoomout)
		event_zoomout = null
	if(event_movement)
		qdel(event_movement)
		event_movement = null

	. = ..()

	if(actions)
		for(var/datum/action/A in actions)
			qdel(A)
		actions = null

//This proc is used for mobs which are affected by pressure to calculate the amount of pressure that actually
//affects them once clothing is factored in. ~Errorage
/mob/living/proc/calculate_affecting_pressure(var/pressure)
	return

/mob/living/proc/initialize_pain()
	pain = new /datum/pain(src)

//sort of a legacy burn method for /electrocute, /shock, and the e_chair
/mob/living/proc/burn_skin(burn_amount)
	if(ishuman(src))
		var/mob/living/carbon/human/H = src	//make this damage method divide the damage to be done among all the body parts, then burn each body part for that much damage. will have better effect then just randomly picking a body part
		var/divided_damage = (burn_amount)/(H.limbs.len)
		var/extradam = 0	//added to when organ is at max dam
		for(var/obj/limb/affecting in H.limbs)
			if(!affecting)	continue
			if(affecting.take_damage(0, divided_damage+extradam))	//TODO: fix the extradam stuff. Or, ebtter yet...rewrite this entire proc ~Carn
				H.UpdateDamageIcon()
		H.updatehealth()
		return 1
	else if(isAI(src))
		return 0

/mob/living/proc/adjustBodyTemp(actual, desired, incrementboost)
	var/temperature = actual
	var/difference = abs(actual-desired)	//get difference
	var/increments = difference/10 //find how many increments apart they are
	var/change = increments*incrementboost	// Get the amount to change by (x per increment)

	// Too cold
	if(actual < desired)
		temperature += change
		if(actual > desired)
			temperature = desired
	// Too hot
	if(actual > desired)
		temperature -= change
		if(actual < desired)
			temperature = desired
//	if(istype(src, /mob/living/carbon/human))
	return temperature



/mob/proc/get_contents()


//Recursive function to find everything a mob is holding.
/mob/living/get_contents(var/obj/item/storage/Storage = null)
	var/list/L = list()

	if(Storage) //If it called itself
		L += Storage.return_inv()

		//Leave this commented out, it will cause storage items to exponentially add duplicate to the list
		//for(var/obj/item/storage/S in Storage.return_inv()) //Check for storage items
		//	L += get_contents(S)

		for(var/obj/item/gift/G in Storage.return_inv()) //Check for gift-wrapped items
			L += G.gift
			if(istype(G.gift, /obj/item/storage))
				L += get_contents(G.gift)

		for(var/obj/item/smallDelivery/D in Storage.return_inv()) //Check for package wrapped items
			L += D.wrapped
			if(istype(D.wrapped, /obj/item/storage)) //this should never happen
				L += get_contents(D.wrapped)
		return L

	else

		L += src.contents
		for(var/obj/item/storage/S in src.contents)	//Check for storage items
			L += get_contents(S)

		for(var/obj/item/gift/G in src.contents) //Check for gift-wrapped items
			L += G.gift
			if(istype(G.gift, /obj/item/storage))
				L += get_contents(G.gift)

		for(var/obj/item/smallDelivery/D in src.contents) //Check for package wrapped items
			L += D.wrapped
			if(istype(D.wrapped, /obj/item/storage)) //this should never happen
				L += get_contents(D.wrapped)
		return L

/mob/living/proc/check_contents_for(A)
	var/list/L = src.get_contents()

	for(var/obj/B in L)
		if(B.type == A)
			return 1
	return 0


/mob/living/proc/get_limbzone_target()
	return ran_zone(zone_selected)



/mob/living/proc/UpdateDamageIcon()
	return


/mob/living/proc/Examine_OOC()
	set name = "Examine Meta-Info (OOC)"
	set category = "OOC"
	set src in view()

	if(config.allow_Metadata)
		if(client)
			to_chat(usr, "[src]'s Metainfo:<br>[client.prefs.metadata]")
		else
			to_chat(usr, "[src] does not have any stored infomation!")
	else
		to_chat(usr, "OOC Metadata is not supported by this server!")

	return


/mob/living/Move(NewLoc, direct)
	if (buckled && buckled.loc != NewLoc) //not updating position
		if (!buckled.anchored)
			return buckled.Move(NewLoc, direct)
		else
			return 0

	var/atom/movable/pullee = pulling
	if(pullee && get_dist(src, pullee) > 1) //Is the pullee adjacent?
		if(!pullee.clone || (pullee.clone && get_dist(src, pullee.clone) > 2)) //Be lenient with the close
			stop_pulling()
	var/turf/T = loc
	. = ..()
	if(. && pulling && pulling == pullee) //we were pulling a thing and didn't lose it during our move.
		if(pulling.anchored)
			stop_pulling()
			return

		var/pull_dir = get_dir(src, pulling)
		if(get_dist(src, pulling) > 1 || ((pull_dir - 1) & pull_dir)) //puller and pullee more than one tile away or in diagonal position
			pulling.Move(T, get_dir(pulling, T)) //the pullee tries to reach our previous position
			if(pulling && get_dist(src, pulling) > 1) //the pullee couldn't keep up
				stop_pulling()
			else
				var/mob/living/pmob =  pulling
				if(istype(pmob))
					pmob.on_movement()
				if(!(flags_atom & DIRLOCK))
					dir = turn(direct, 180) //face the pullee

	if(pulledby && get_dist(src, pulledby) > 1)//separated from our puller and not in the middle of a diagonal move.
		pulledby.stop_pulling()


	if (s_active && !( s_active in contents ) && get_turf(s_active) != get_turf(src))	//check !( s_active in contents ) first so we hopefully don't have to call get_turf() so much.
		s_active.close(src)





/mob/proc/resist_grab(moving_resist)
	return //returning 1 means we successfully broke free

/mob/living/resist_grab(moving_resist)
	if(!pulledby)
		return
	if(pulledby.grab_level)
		if(prob(50))
			playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
			visible_message(SPAN_DANGER("[src] has broken free of [pulledby]'s grip!"), null, null, 5)
			pulledby.stop_pulling()
			return 1
		if(moving_resist && client) //we resisted by trying to move
			visible_message(SPAN_DANGER("[src] struggles to break free of [pulledby]'s grip!"), null, null, 5)
			client.next_movement = world.time + (10*pulledby.grab_level) + client.move_delay
	else
		pulledby.stop_pulling()
		return 1


/mob/living/movement_delay()
	. = ..()

	if (do_bump_delay)
		. += 10
		do_bump_delay = 0

	if (drowsyness > 0)
		. += 6

	if(pulling && pulling.drag_delay && get_pull_miltiplier())	//Dragging stuff can slow you down a bit.
		var/pull_delay = pulling.get_pull_drag_delay() * get_pull_miltiplier()
		. += max(pull_speed + pull_delay + 3*grab_level, 0) //harder grab makes you slower
	move_delay = .


//the inherent slowdown of the object when pulled
/atom/movable/proc/get_pull_drag_delay()
	. = drag_delay

/obj/structure/closet/bodybag/get_pull_drag_delay()
	if(roller_buckled) //if the pulled bodybag is buckled to a roller bed, we use its drag_delay instead.
		. = roller_buckled.drag_delay
	else
		. = drag_delay

/mob/living/get_pull_drag_delay()
	if(buckled) //if the pulled mob is buckled to an object, we use that object's drag_delay.
		. = buckled.drag_delay
	else
		. = drag_delay

//whether we are slowed when dragging things
/mob/living/proc/get_pull_miltiplier()
	return 1.0

/mob/living/carbon/human/get_pull_miltiplier()
	if(has_species(src,"Yautja"))
		return 0//Predators aren't slowed when pulling their prey.
	return 1

/mob/living/forceMove(atom/destination)
	stop_pulling()
	if(pulledby)
		pulledby.stop_pulling()
	if(buckled)
		buckled.unbuckle()
	. = ..()
	on_movement()

	if(.)
		reset_view(destination)

/mob/living/Collide(atom/movable/AM)
	if(buckled || now_pushing)
		return

	if(throwing)
		launch_impact(AM)
		return

	if(!isliving(AM))
		..()
		return

	now_pushing = TRUE
	var/mob/living/L = AM

	// For now a kind of hacky check for if you are performing an action that stops you from being pushed by teammates
	if(L.status_flags & IMMOBILE_ACTION && areSameSpecies(src, L) && src.mob_size <= L.mob_size)
		now_pushing = FALSE
		return

	//Leaping mobs just land on the tile, no pushing, no anything.
	if(status_flags & LEAPING)
		loc = L.loc
		status_flags &= ~LEAPING
		now_pushing = FALSE
		return

	if(L.pulledby && L.pulledby != src && L.is_mob_restrained())
		if(!(world.time % 5))
			to_chat(src, SPAN_WARNING("[L] is restrained, you cannot push past."))
		now_pushing = FALSE
		return

	if(isXeno(L) && !isXenoLarva(L))
		var/mob/living/carbon/Xenomorph/X = L
		if(X.mob_size == MOB_SIZE_BIG || (ishuman(src) && !isYautja(src))) // Small xenos can be pushed by other xenos or preds
			now_pushing = FALSE
			return

	if(L.pulling)
		if(ismob(L.pulling))
			var/mob/P = L.pulling
			if(P.is_mob_restrained())
				if(!(world.time % 5))
					to_chat(src, SPAN_WARNING("[L] is restraining [P], you cannot push past."))
				now_pushing = FALSE
				return

	if(ishuman(L))
		if(!(L.status_flags & CANPUSH))
			now_pushing = FALSE
			return

	if(!L.buckled && !L.anchored)
		var/mob_swap
		//the puller can always swap with its victim if on grab intent
		if(L.pulledby == src && a_intent == GRAB_INTENT)
			mob_swap = 1
		//restrained people act if they were on 'help' intent to prevent a person being pulled from being seperated from their puller
		else if((L.is_mob_restrained() || L.a_intent == HELP_INTENT) && (is_mob_restrained() || a_intent == HELP_INTENT))
			mob_swap = 1
		if(mob_swap)
			//switch our position with L
			if(loc && !loc.Adjacent(L.loc))
				now_pushing = FALSE
				return
			var/oldloc = loc
			var/oldLloc = L.loc

			L.add_temp_pass_flags(PASS_MOB_THRU)
			add_temp_pass_flags(PASS_MOB_THRU)

			L.Move(oldloc)
			Move(oldLloc)

			remove_temp_pass_flags(PASS_MOB_THRU)
			L.remove_temp_pass_flags(PASS_MOB_THRU)

			now_pushing = FALSE
			return

	now_pushing = FALSE

	if(!(L.status_flags & CANPUSH))
		return

	..()

/mob/living/launch_towards(var/datum/launch_metadata/LM)
	if(!LM.target || !src || buckled)
		return
	if(pulling)
		stop_pulling() //being thrown breaks pulls.
	if(pulledby)
		pulledby.stop_pulling()
	. = ..()

//to make an attack sprite appear on top of the target atom.
/mob/living/proc/flick_attack_overlay(atom/target, attack_icon_state)
	set waitfor = 0

	if(!attack_icon)
		return FALSE

	attack_icon.icon_state = attack_icon_state
	attack_icon.pixel_x = -target.pixel_x
	attack_icon.pixel_y = -target.pixel_y
	target.overlays += attack_icon
	var/old_icon = attack_icon.icon_state
	var/old_pix_x = attack_icon.pixel_x
	var/old_pix_y = attack_icon.pixel_y
	add_timer(CALLBACK(src, /mob/living/proc/finish_attack_overlay, target, old_icon, old_pix_x, old_pix_y), 4)

/mob/living/proc/finish_attack_overlay(atom/target, old_icon, old_pix_x, old_pix_y)
	if(!attack_icon || !target)
		return FALSE

	var/new_icon = attack_icon.icon_state
	var/new_pix_x = attack_icon.pixel_x
	var/new_pix_y = attack_icon.pixel_y
	attack_icon.icon_state = old_icon //necessary b/c the attack_icon can change sprite during the sleep.
	attack_icon.pixel_x = old_pix_x
	attack_icon.pixel_y = old_pix_y

	target.overlays -= attack_icon

	attack_icon.icon_state = new_icon
	attack_icon.pixel_x = new_pix_x
	attack_icon.pixel_y = new_pix_y




/mob/proc/flash_eyes()
	return

/mob/living/flash_eyes(intensity = 1, bypass_checks, type = /obj/screen/fullscreen/flash)
	if( bypass_checks || (get_eye_protection() < intensity && !(disabilities & BLIND)) )
		overlay_fullscreen("flash", type)
		spawn(40)
			clear_fullscreen("flash", 20)
		return 1


/mob/living/proc/on_zoomout()
	var/datum/event_args/ev_args = new /datum/event_args()
	event_zoomout.fire_event(src, ev_args)

/mob/living/proc/add_zoomout_handler(datum/event_handler/handler)
	if(isnull(event_zoomout))
		event_zoomout = new /datum/event()
	event_zoomout.add_handler(handler)

/mob/living/proc/remove_zoomout_handler(datum/event_handler/handler)
	event_zoomout.remove_handler(handler)


/datum/event_args/mob_movement
	var/continue_movement = 1
	var/moving = 0

/mob/living/on_movement(moving = 1)
	var/datum/event_args/mob_movement/ev_args = new /datum/event_args/mob_movement()
	ev_args.moving = moving
	if(event_movement)
		event_movement.fire_event(src, ev_args)
	return ev_args.continue_movement

/mob/living/proc/add_movement_handler(datum/event_handler/handler)
	if(isnull(event_movement))
		event_movement = new /datum/event()
	event_movement.add_handler(handler)

/mob/living/proc/remove_movement_handler(datum/event_handler/handler)
	event_movement.remove_handler(handler)

/mob/living/proc/health_scan(mob/living/carbon/human/user, var/ignore_delay = FALSE, var/mode = 1, var/hud_mode = 1)
	var/dat = ""
	if((user.getBrainLoss() >= 60) && prob(50))
		to_chat(user, SPAN_WARNING("You try to analyze the floor's vitals!"))
		for(var/mob/O in viewers(src, null))
			O.show_message(SPAN_WARNING("[user] has analyzed the floor's vitals!"), 1)
		user.show_message(SPAN_NOTICE("Health Analyzer results for The floor:\n\t Overall Status: Healthy"), 1)
		user.show_message(SPAN_NOTICE("\t Damage Specifics: [0]-[0]-[0]-[0]"), 1)
		user.show_message(SPAN_NOTICE("Key: Suffocation/Toxin/Burns/Brute"), 1)
		user.show_message(SPAN_NOTICE("Body Temperature: ???"), 1)
		return
	if(!(istype(user, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		to_chat(usr, SPAN_WARNING("You don't have the dexterity to do this!"))
		return
	if(!ignore_delay && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		to_chat(user, SPAN_WARNING("You start fumbling around with [src]..."))
		var/fduration = 60
		if(skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_DEFAULT))
			fduration = 30
		if(!do_after(user, fduration, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY) || !user.Adjacent(src))
			return
	if(isXeno(src))
		to_chat(user, SPAN_WARNING("[src] can't make sense of this creature."))
		return
	to_chat(user, SPAN_NOTICE("[user] has analyzed [src]'s vitals."))
	playsound(src.loc, 'sound/items/healthanalyzer.ogg', 50)

	// Doesn't work on non-humans and synthetics
	if(!istype(src, /mob/living/carbon))
		user.show_message("\nHealth Analyzer results for ERROR:\n\t Overall Status: ERROR")
		user.show_message("\tType: [SET_CLASS("Oxygen", INTERFACE_BLUE)]-[SET_CLASS("Toxin", INTERFACE_GREEN)]-[SET_CLASS("Burns", INTERFACE_ORANGE)]-[SET_CLASS("Brute", INTERFACE_RED)]", 1)
		user.show_message("\tDamage: [SET_CLASS("?", INTERFACE_BLUE)] - [SET_CLASS("?", INTERFACE_GREEN)] - [SET_CLASS("?", INTERFACE_ORANGE)] - [SET_CLASS("?", INTERFACE_RED)]")
		user.show_message(SPAN_NOTICE("Body Temperature: [src.bodytemperature-T0C]&deg;C ([src.bodytemperature*1.8-459.67]&deg;F)"), 1)
		user.show_message(SPAN_DANGER("<b>Warning: Blood Level ERROR: --% --cl.Type: ERROR"))
		user.show_message(SPAN_NOTICE("Subject's pulse: [SET_CLASS("-- bpm", INTERFACE_RED)]"))
		return

	// Calculate damage amounts
	var/fake_oxy = max(rand(1,40), src.getOxyLoss(), (300 - (src.getToxLoss() + src.getFireLoss() + src.getBruteLoss())))
	var/OX = src.getOxyLoss() > 50 	? 	"<b>[src.getOxyLoss()]</b>" 		: src.getOxyLoss()
	var/TX = src.getToxLoss() > 50 	? 	"<b>[src.getToxLoss()]</b>" 		: src.getToxLoss()
	var/BU = src.getFireLoss() > 50 	? 	"<b>[src.getFireLoss()]</b>" 		: src.getFireLoss()
	var/BR = src.getBruteLoss() > 50 	? 	"<b>[src.getBruteLoss()]</b>" 	: src.getBruteLoss()

	// Show overall
	if(src.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 			? 	"<b>[fake_oxy]</b>" 			: fake_oxy
		dat += "\nHealth Analyzer for [src]:\n\tOverall Status: <b>DEAD</b>\n"
	else
		dat += "\nHealth Analyzer results for [src]:\n\tOverall Status: [src.stat > 1 ? "<b>DEAD</b>" : "<b>[src.health - src.halloss]% healthy"]</b>\n"
	dat += "\tType:    [SET_CLASS("Oxygen", INTERFACE_BLUE)]-[SET_CLASS("Toxin", INTERFACE_GREEN)]-[SET_CLASS("Burns", INTERFACE_ORANGE)]-[SET_CLASS("Brute", INTERFACE_RED)]\n"
	dat += "\tDamage: \t[SET_CLASS(OX, INTERFACE_BLUE)] - [SET_CLASS(TX, INTERFACE_GREEN)] - [SET_CLASS(BU, INTERFACE_ORANGE)] - [SET_CLASS(BR, INTERFACE_RED)]\n"
	dat += "\tUntreated: {B}=Burns,{T}=Trauma,{F}=Fracture\n"

	var/unrevivable = 0

	// Show specific limb damage
	if(istype(src, /mob/living/carbon/human) && mode == 1)
		var/mob/living/carbon/human/H = src
		for(var/obj/limb/org in H.limbs)
			var/brute_treated = TRUE
			var/burn_treated = TRUE
			var/open_incision = TRUE
			if(org.surgery_open_stage == 0)
				open_incision = FALSE
			if((org.brute_dam > 0 && !org.is_bandaged()) || open_incision)
				brute_treated = FALSE
			if(org.burn_dam > 0 && !org.is_salved())
				burn_treated = FALSE

			if(org.status & LIMB_DESTROYED)
				dat += "\t\t [capitalize(org.display_name)]: <span class='scannerb'>Missing!</span>\n"
				continue

			var/bleeding_check = FALSE
			for(var/datum/effects/bleeding/external/E in org.bleeding_effects_list)
				bleeding_check = TRUE
				break
			var/show_limb = (org.burn_dam > 0 || org.brute_dam > 0 || (org.status & LIMB_SPLINTED) || open_incision || bleeding_check)

			var/org_name = "[capitalize(org.display_name)][org.status & LIMB_ROBOT ? " (Cybernetic)" : ""]"
			var/burn_info = org.burn_dam > 0 ? "<span class='scannerburnb'> [round(org.burn_dam)]</span>" : "<span class='scannerburn'>0</span>"
			burn_info += "[burn_treated ? "" : "{B}"]"
			var/brute_info =  org.brute_dam > 0 ? "<span class='scannerb'> [round(org.brute_dam)]</span>" : "<span class='scanner'>0</span>"
			brute_info += "[brute_treated ? "" : "{T}"]"
			var/fracture_info = ""
			if(org.status & LIMB_BROKEN)
				fracture_info = "{F}"
				show_limb = 1

			var/org_bleed = ""
			if(bleeding_check)
				org_bleed = "<span class='scannerb'>(Bleeding)</span>"

			var/org_incision = (open_incision?" <span class='scanner'>Open surgical incision</span>":"")
			var/org_advice = ""
			if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
				switch(org.name)
					if("head")
						fracture_info = ""
						if(org.brute_dam > 40 || src.getBrainLoss() >= 20)
							org_advice = " Possible Skull Fracture."
							show_limb = 1
					if("chest")
						fracture_info = ""
						if(org.brute_dam > 40 || src.getOxyLoss() > 50)
							org_advice = " Possible Chest Fracture."
							show_limb = 1
					if("groin")
						fracture_info = ""
						if(org.brute_dam > 40 || src.getToxLoss() > 50)
							org_advice = " Possible Groin Fracture."
							show_limb = 1
			if(show_limb)
				dat += "\t\t [org_name]: \t [burn_info] - [brute_info] [fracture_info][org_bleed][org_incision][org_advice]"
				if(org.status & LIMB_SPLINTED)
					dat += "(Splinted)"
				dat += "\n"

	// Show red messages - broken bokes, etc
	if (src.getCloneLoss())
		dat += "\t<span class='scanner'> *Subject appears to have been imperfectly cloned.</span>\n"
	for(var/datum/disease/D in src.viruses)
		if(!D.hidden[SCANNER])
			dat += "\t<span class='scannerb'> *Warning: [D.form] Detected</span><span class='scanner'>\nName: [D.name].\nType: [D.spread].\nStage: [D.stage]/[D.max_stages].\nPossible Cure: [D.cure]</span>\n"
	if (src.getBrainLoss() >= 100 || !src.has_brain())
		dat += "\t<span class='scanner'> *Subject is <b>brain dead</b></span>.\n"
	else if (src.getBrainLoss() >= 60)
		dat += "\t<span class='scanner'> *<b>Severe brain damage</b> detected. Subject likely to have mental retardation.</span>\n"
	else if (src.getBrainLoss() >= 10)
		dat += "\t<span class='scanner'> *<b>Significant brain damage</b> detected. Subject may have had a concussion.</span>\n"

	if(src.has_brain() && src.stat != DEAD && ishuman(src))
		if(!src.key)
			dat += SPAN_WARNING("\tNo soul detected.\n") // they ghosted
		else if(!src.client)
			dat += SPAN_WARNING("\tSSD detected.\n") // SSD

	var/internal_bleed_detected = FALSE
	var/embedded_item_detected = FALSE
	if(ishuman(src))
		var/mob/living/carbon/human/H = src

		if(H.embedded_items.len > 0)
			embedded_item_detected = TRUE

		var/core_fracture = 0
		for(var/X in H.limbs)
			var/obj/limb/e = X
			for(var/datum/effects/bleeding/internal/I in e.bleeding_effects_list)
				internal_bleed_detected = TRUE
				break
			if(e.status & LIMB_BROKEN)
				if(!((e.name == "l_arm") || (e.name == "r_arm") || (e.name == "l_leg") || (e.name == "r_leg") || (e.name == "l_hand") || (e.name == "r_hand") || (e.name == "l_foot") || (e.name == "r_foot")))
					core_fracture = 1
		if(core_fracture)
			dat += "\t[SPAN_SCANNER("*<b>Bone fractures</b> detected. Advanced scanner required for location.")]\n"
		if(internal_bleed_detected)
			dat += "\t[SPAN_SCANNER("*<b>Internal bleeding</b> detected. Advanced scanner required for location.")]\n"
		if(embedded_item_detected)
			dat += "\t[SPAN_SCANNER("*<b>Embedded object</b> detected. Advanced scanner required for location.")]\n"

	var/reagents_in_body[0] // yes i know -spookydonut
	if(istype(src, /mob/living/carbon))
		// Show helpful reagents
		if(src.reagents && (src.reagents.total_volume > 0))
			var/unknown = 0
			var/reagentdata[0]
			for(var/A in src.reagents.reagent_list)
				var/datum/reagent/R = A
				reagents_in_body["[R.id]"] = R.volume
				if(R.scannable)
					reagentdata["[R.id]"] = "[R.overdose != 0 && R.volume >= R.overdose ? SPAN_WARNING("<b>OD: </b>") : ""] <font color='#9773C4'><b>[round(R.volume, 1)]u [R.name]</b></font>"
				else
					unknown++
			if(reagentdata.len)
				dat += "\n\tBeneficial reagents:\n"
				for(var/d in reagentdata)
					dat += "\t\t [reagentdata[d]]\n"
			if(unknown)
				dat += "\t<span class='scanner'> Warning: Unknown substance[(unknown>1)?"s":""] detected in subject's blood.</span>\n"

	// Show body temp
	dat += "\n\tBody Temperature: [src.bodytemperature-T0C]&deg;C ([src.bodytemperature*1.8-459.67]&deg;F)\n"

	if (ishuman(src))
		var/mob/living/carbon/human/H = src
		// Show blood level
		var/blood_volume = BLOOD_VOLUME_NORMAL
		if(!(H.species && H.species.flags & NO_BLOOD))
			blood_volume = round(H.blood_volume)

			var/blood_percent =  blood_volume / 560
			var/blood_type = H.blood_type
			blood_percent *= 100
			if(blood_volume <= 500 && blood_volume > 336)
				dat += "\t<span class='scanner'> <b>Warning: Blood Level LOW: [blood_percent]% [blood_volume]cl.</span> [SET_CLASS("Type: [blood_type]", INTERFACE_BLUE)]\n"
			else if(blood_volume <= 336)
				dat += "\t<span class='scanner'> <b>Warning: Blood Level CRITICAL: [blood_percent]% [blood_volume]cl.</span> [SET_CLASS("Type: [blood_type]", INTERFACE_BLUE)]\n"
			else
				dat += "\tBlood Level normal: [blood_percent]% [blood_volume]cl. Type: [blood_type]\n"
		// Show pulse
		dat += "\tPulse: <span class='[H.pulse == PULSE_THREADY || H.pulse == PULSE_NONE ? INTERFACE_RED : ""]'>[H.get_pulse(GETPULSE_TOOL)] bpm.</span>\n"
		if((H.stat == DEAD && !H.client))
			unrevivable = 1
		if(!unrevivable)
			var/advice = ""
			if(blood_volume <= 500 && !reagents_in_body["nutriment"])
				advice += "<span class='scanner'>Administer food or recommend the patient eat.</span>\n"
			if(internal_bleed_detected && reagents_in_body["quickclot"] < 5)
				advice += "<span class='scanner'>Administer a single dose of quickclot.</span>\n"
			if(H.getToxLoss() > 10 && reagents_in_body["anti_toxin"] < 5 && !reagents_in_body["synaptizine"])
				advice += "<span class='scanner'>Administer a single dose of dylovene.</span>\n"
			if((H.getToxLoss() > 50 || (H.getOxyLoss() > 50 && blood_volume > 400) || H.getBrainLoss() >= 10) && reagents_in_body["peridaxon"] < 5 && !reagents_in_body["hyperzine"])
				advice += "<span class='scanner'>Administer a single dose of peridaxon.</span>\n"
			if(H.getOxyLoss() > 50 && reagents_in_body["dexalin"] < 5)
				advice += "<span class='scanner'>Administer a single dose of dexalin.</span>\n"
			if(H.getFireLoss(1) > 30 && reagents_in_body["kelotane"] < 3)
				advice += "<span class='scanner'>Administer a single dose of kelotane.</span>\n"
			if(H.getBruteLoss(1) > 30 && reagents_in_body["bicaridine"] < 3)
				advice += "<span class='scanner'>Administer a single dose of bicaridine.</span>\n"
			if(H.health < 0 && reagents_in_body["inaprovaline"] < 5)
				advice += "<span class='scanner'>Administer a single dose of inaprovaline.</span>\n"

			var/has_pain = FALSE
			for(var/datum/effects/pain/P in H.effects_list)
				has_pain = TRUE
				break

			if(has_pain && reagents_in_body["tramadol"] < 3 && !reagents_in_body["paracetamol"])
				advice += "<span class='scanner'>Administer a single dose of tramadol.</span>\n"
			if(advice != "")
				dat += "\t<span class='scanner'> <b>Medication Advice:</b></span>\n"
				dat += advice
			advice = ""
			if(reagents_in_body["synaptizine"])
				advice += "<span class='scanner'>DO NOT administer dylovene.</span>\n"
			if(reagents_in_body["hyperzine"])
				advice += "<span class='scanner'>DO NOT administer peridaxon.</span>\n"
			if(reagents_in_body["paracetamol"])
				advice += "<span class='scanner'>DO NOT administer tramadol.</span>\n"
			if(advice != "")
				dat += "\t<span class='scanner'> <b>Contraindications:</b></span>\n"
				dat += advice

	if(hud_mode)
		dat = replacetext(dat, "\n", "<br>")
		dat = replacetext(dat, "\t", "&emsp;")
		dat = replacetext(dat, "class='warning'", "class='[INTERFACE_RED]'")
		dat = replacetext(dat, "class='scanner'", "class='[INTERFACE_RED]'")
		dat = replacetext(dat, "class='scannerb'", "style='font-weight: bold;' class='[INTERFACE_RED]'")
		dat = replacetext(dat, "class='scannerburn'", "class='[INTERFACE_ORANGE]'")
		dat = replacetext(dat, "class='scannerburnb'", "style='font-weight: bold;' class='[INTERFACE_ORANGE]'")
		show_browser(user, dat, name, "handscanner", "size=500x400")
	else
		user.show_message(dat, 1)

/mob/living/create_clone_movable(shift_x, shift_y)
	..()
	src.clone.hud_list = new /list(src.hud_list.len)
	for(var/h in src.hud_possible) //Clone HUD
		src.clone.hud_list[h] = new /image("loc" = src.clone, "icon" = src.hud_list[h].icon)

/mob/living/update_clone()
	..()
	for(var/h in src.hud_possible)
		src.clone.hud_list[h].icon_state = src.hud_list[h].icon_state

