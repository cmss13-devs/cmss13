// Notify all preds with the bracer icon
/proc/message_all_yautja(var/msg, var/soundeffect = TRUE)
	for(var/mob/living/carbon/human/Y in GLOB.yautja_mob_list)
		// Send message to the bracer; appear multiple times if we have more bracers
		for(var/obj/item/clothing/gloves/yautja/G in Y.contents)
			to_chat(Y, SPAN_YAUTJABOLD("[icon2html(G)] \The <b>[G]</b> beeps: [msg]"))
			if(G.notification_sound)
				playsound(Y.loc, 'sound/items/pred_bracer.ogg', 75, 1)

/mob/living/carbon/human/proc/message_thrall(var/msg)
	if(!hunter_data.thrall)
		return

	var/mob/living/carbon/T = hunter_data.thrall

	for(var/obj/item/clothing/gloves/yautja/G in T.contents)
		to_chat(T, SPAN_YAUTJABOLD("[icon2html(G)] \The <b>[G]</b> beeps: [msg]"))
		if(G.notification_sound)
			playsound(T.loc, 'sound/items/pred_bracer.ogg', 75, 1)

//Update the power display thing. This is called in Life()
/mob/living/carbon/human/proc/update_power_display(var/perc)
	if(hud_used && hud_used.pred_power_icon)
		switch(perc)
			if(91 to INFINITY)
				hud_used.pred_power_icon.icon_state = "powerbar100"
			if(81 to 91)
				hud_used.pred_power_icon.icon_state = "powerbar90"
			if(71 to 81)
				hud_used.pred_power_icon.icon_state = "powerbar80"
			if(61 to 71)
				hud_used.pred_power_icon.icon_state = "powerbar70"
			if(51 to 61)
				hud_used.pred_power_icon.icon_state = "powerbar60"
			if(41 to 51)
				hud_used.pred_power_icon.icon_state = "powerbar50"
			if(31 to 41)
				hud_used.pred_power_icon.icon_state = "powerbar40"
			if(21 to 31)
				hud_used.pred_power_icon.icon_state = "powerbar30"
			if(11 to 21)
				hud_used.pred_power_icon.icon_state = "powerbar20"
			else
				hud_used.pred_power_icon.icon_state = "powerbar10"

/mob/living/carbon/human/proc/butcher()
	set category = "Yautja"
	set name = "Butcher"
	set desc = "Butcher a corpse you're standing on for its tasty meats."

	if(is_mob_incapacitated() || lying || buckled)
		to_chat(src, "You're not able to do that right now.")
		return

	var/list/choices = list()
	for(var/mob/living/carbon/M in view(1,src))
		if(Adjacent(M) && M.stat)
			if(istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/Q = M
				if(Q.species && Q.species.name == "Yautja")
					continue
			choices += M

	if(src in choices)
		choices -= src

	var/mob/living/carbon/T = tgui_input_list(src,"What do you wish to butcher?", "Butcher", choices)

	var/mob/living/carbon/Xenomorph/xeno_victim
	var/mob/living/carbon/human/victim

	if(!T || !src || !T.stat)
		to_chat(src, "Nope.")
		return

	if(!Adjacent(T))
		to_chat(src, "You have to be next to your target.")
		return

	if(istype(T,/mob/living/carbon/Xenomorph/Larva))
		to_chat(src, "This tiny worm is not even worth using your tools on.")
		return

	if(is_mob_incapacitated() || lying || buckled)
		to_chat(src, "Not right now.")
		return

	if(!T) return

	if(isXeno(T))
		xeno_victim = T

	var/list/procedureChoices = list(
		"Skin",
		"Behead",
		"Delimb - right hand",
		"Delimb - left hand",
		"Delimb - right arm",
		"Delimb - left arm",
		"Delimb - right foot",
		"Delimb - left foot",
		"Delimb - right leg",
		"Delimb - left leg",
	)
	var/procedure = ""
	if(ishuman(T))
		victim = T
		procedure = tgui_input_list(src,"Which slice would you like to take?", "Take slice", procedureChoices)


	if (isXeno(T) || procedure == "Skin")
		if(T.butchery_progress)
			playsound(loc, 'sound/weapons/pierce.ogg', 25)
			visible_message("<b>[src] goes back to butchering \the [T].</b>","<b>You get back to butchering \the [T].</b>")
		else
			playsound(loc, 'sound/weapons/pierce.ogg', 25)
			visible_message("<b>[src] begins chopping and mutilating \the [T].</b>","<b>You take out your tools and begin your gruesome work on \the [T]. Hold still.</b>")
			T.butchery_progress = 1

		if(T.butchery_progress == 1)
			if(do_after(src,70, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE) && Adjacent(T))
				visible_message("[src] makes careful slices and tears out the viscera in \the [T]'s abdominal cavity.","You carefully vivisect \the [T], ripping out the guts and useless organs. What a stench!")
				T.butchery_progress = 2
				playsound(loc, 'sound/weapons/slash.ogg', 25)
			else
				to_chat(src, "You pause your butchering for later.")

		if(T.butchery_progress == 2)
			if(do_after(src,65, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE) && Adjacent(T))
				visible_message("[src] hacks away at \the [T]'s limbs and slices off strips of dripping meat.","You slice off a few of \the [T]'s limbs, making sure to get the finest cuts.")
				if(xeno_victim && isturf(xeno_victim.loc))
					var/obj/item/reagent_container/food/snacks/xenomeat = new /obj/item/reagent_container/food/snacks/xenomeat(T.loc)
					xenomeat.name = "raw [xeno_victim.age_prefix][xeno_victim.caste_type] steak"
				else if(victim && isturf(victim.loc))
					victim.apply_damage(100,BRUTE,pick("r_leg","l_leg","r_arm","l_arm"),0,1,1) //Basically just rips off a random limb.
					var/obj/item/reagent_container/food/snacks/meat/meat = new /obj/item/reagent_container/food/snacks/meat(victim.loc)
					meat.name = "raw [victim.name] steak"
				T.butchery_progress = 3
				playsound(loc, 'sound/weapons/bladeslice.ogg', 25)
			else
				to_chat(src, "You pause your butchering for later.")

		if(T.butchery_progress == 3)
			if(do_after(src,70, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE) && Adjacent(T))
				visible_message("[src] tears apart \the [T]'s ribcage and begins chopping off bit and pieces.","You rip open \the [T]'s ribcage and start tearing the tastiest bits out.")
				if(xeno_victim && isturf(xeno_victim.loc))
					var/obj/item/reagent_container/food/snacks/xenomeat = new /obj/item/reagent_container/food/snacks/xenomeat(T.loc)
					xenomeat.name = "raw [xeno_victim.age_prefix][xeno_victim.caste_type] tenderloin"
				else if(victim && isturf(T.loc))
					var/obj/item/reagent_container/food/snacks/meat/meat = new /obj/item/reagent_container/food/snacks/meat(victim.loc)
					meat.name = "raw [victim.name] tenderloin"
	//				T.apply_damage(100,BRUTE,"chest",0,0,0) //Does random serious damage, so we make sure they're dead.
	//				Why was this even in here?
				T.butchery_progress = 4
				playsound(loc, 'sound/weapons/wristblades_hit.ogg', 25)
			else
				to_chat(src, "You pause your butchering for later.")

		if(T.butchery_progress == 4)
			if(do_after(src,90, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE) && Adjacent(T))
				if(xeno_victim && isturf(T.loc))
					visible_message("<b>[src] flenses the last of [victim]'s exoskeleton, revealing only bones!</b>.","<b>You flense the last of [victim]'s exoskeleton clean off!</b>")
					new /obj/effect/decal/remains/xeno(xeno_victim.loc)
					var/obj/item/stack/sheet/animalhide/xeno/xenohide = new /obj/item/stack/sheet/animalhide/xeno(xeno_victim.loc)
					xenohide.name = "[xeno_victim.age_prefix][xeno_victim.caste_type]-hide"
					xenohide.singular_name = "[xeno_victim.age_prefix][xeno_victim.caste_type]-hide"
					xenohide.stack_id = "[xeno_victim.age_prefix][xeno_victim.caste_type]-hide"

				else if(victim && isturf(T.loc))
					visible_message("<b>[src] reaches down and rips out \the [T]'s spinal cord and skull!</b>.","<b>You firmly grip the revealed spinal column and rip [T]'s head off!</b>")
					var/mob/living/carbon/human/H = T
					if(H.get_limb("head"))
						H.apply_damage(150,BRUTE,"head",0,1,1)
					else
						var/obj/item/reagent_container/food/snacks/meat/meat = new /obj/item/reagent_container/food/snacks/meat(victim.loc)
						meat.name = "raw [victim.name] steak"
					var/obj/item/stack/sheet/animalhide/human/hide = new /obj/item/stack/sheet/animalhide/human(victim.loc)
					hide.name = "[victim.name]-hide"
					hide.singular_name = "[victim.name]-hide"
					hide.stack_id = "[victim.name]-hide"
					new /obj/effect/decal/remains/human(T.loc)
				if(T.legcuffed)
					T.drop_inv_item_on_ground(T.legcuffed)
				T.butchery_progress = 5 //Won't really matter.
				playsound(loc, 'sound/weapons/slice.ogg', 25)
				if(hunter_data.prey == T)
					to_chat(src, SPAN_YAUTJABOLD("You have claimed [T] as your trophy."))
					emote("roar")
					message_all_yautja("[src.real_name] has claimed [T] as their trophy.")
					hunter_data.prey = null
				else
					to_chat(src, SPAN_NOTICE("You finish butchering!"))
				qdel(T)
			else
				to_chat(src, "You pause your butchering for later.")
	else
		var/limb = ""
		switch(procedure)
			if ("")
				to_chat(src, "You pause your butchering for later.")
				return
			if ("Behead")
				limb = "head"
			if ("Delimb - right hand")
				limb = "r_hand"
			if ("Delimb - left hand")
				limb = "l_hand"
			if ("Delimb - right arm")
				limb = "r_arm"
			if ("Delimb - left arm")
				limb = "l_arm"
			if ("Delimb - right foot")
				limb = "r_foot"
			if ("Delimb - left foot")
				limb = "l_foot"
			if ("Delimb - right leg")
				limb = "r_leg"
			if ("Delimb - left leg")
				limb = "l_leg"

		var/limbName = parse_zone(limb)
		var/mob/living/carbon/human/H = T
		if(H.get_limb(limb).status & LIMB_DESTROYED)
			to_chat(src, "The victim lacks a [limbName].")
			return
		if(limb == "head")
			visible_message("<b>[src] reaches down and starts beheading [T].</b>","<b>You reach down and start beheading [T].</b>")
		else
			visible_message("<b>[src] reaches down and starts removing [T]'s [limbName].</b>","<b>You reach down and start removing [T]'s [limbName].</b>")
		if(do_after(src,90, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE) && Adjacent(T))
			if(H.get_limb(limb).status & LIMB_DESTROYED)
				to_chat(src, "The victim lacks a [limbName].")
				return
			H.get_limb(limb).droplimb(1, 0, "butchering")
			playsound(loc, 'sound/weapons/slice.ogg', 25)
			H.butchery_progress = 0
			if(hunter_data.prey == T)
				to_chat(src, SPAN_YAUTJABOLD("You have claimed [T] as your trophy."))
				emote("roar")
				message_all_yautja("[src.real_name] has claimed [T] as their trophy.")
				hunter_data.prey = null
			else
				to_chat(src, SPAN_NOTICE("You finish butchering!"))

	return

/area/yautja
	name = "\improper Yautja Ship"
	icon_state = "teleporter"
	//music = "signal"
	ambience_exterior = AMBIENCE_YAUTJA

	requires_power = FALSE
	luminosity = TRUE
	lighting_use_dynamic = FALSE

/mob/living/carbon/human/proc/pred_buy()
	set category = "Yautja"
	set name = "Claim Equipment"
	set desc = "When you're on the Predator ship, claim some gear. You can only do this ONCE."

	if(is_mob_incapacitated() || lying || buckled)
		to_chat(src, "You're not able to do that right now.")
		return

	if(!isYautja(src))
		to_chat(src, "How did you get this verb?")
		return

	if(!istype(get_area(src),/area/yautja))
		to_chat(src, "Not here. Only on the ship.")
		return

	var/obj/item/clothing/gloves/yautja/Y = src.gloves
	if(!istype(Y) || Y.upgrades) return

	var/sure = alert("An array of powerful weapons are displayed to you. Pick your gear carefully. If you cancel at any point, you will not claim your equipment.","Sure?","Begin the Hunt","No, not now")
	if(sure == "Begin the Hunt")
		var/list/melee = list("The Lumbering Glaive", "The Rending Chain-Whip","The Piercing Hunting Sword","The Cleaving War-Scythe", "The Adaptive Combi-Stick")
		var/list/other = list("The Fleeting Spike Launcher", "The Swift Plasma Pistol", "The Purifying Smart-Disc", "The Formidable Plate Armor")//, "The Clever Hologram")
		var/list/restricted = list("The Fleeting Spike Launcher", "The Swift Plasma Pistol", "The Formidable Plate Armor") //Can only select them once each.

		var/msel = tgui_input_list(usr, "Which weapon shall you use on your hunt?:","Melee Weapon", melee)
		if(!msel) return //We don't want them to cancel out then get nothing.
		var/mother_0 = tgui_input_list(usr, "Which secondary gear shall you take?","Item 1 (of 2)", other)
		if(!mother_0) return
		if(mother_0 in restricted) other -= mother_0
		var/mother_1 = tgui_input_list(usr, "And the last piece of equipment?:","Item 2 (of 2)", other)
		if(!mother_1) return

		if(!istype(Y) || Y.upgrades) return //Tried to run it several times in the same loop. That's not happening.
		Y.upgrades++ //Just means gear was purchased.

		switch(msel)
			if("The Lumbering Glaive")
				new /obj/item/weapon/melee/twohanded/glaive(src.loc)
			if("The Rending Chain-Whip")
				new /obj/item/weapon/yautja_chain(src.loc)
			if("The Piercing Hunting Sword")
				new /obj/item/weapon/melee/yautja_sword(src.loc)
			if("The Cleaving War-Scythe")
				new /obj/item/weapon/melee/yautja_scythe(src.loc)
			if("The Adaptive Combi-Stick")
				new /obj/item/weapon/melee/combistick(src.loc)

		var/choice = mother_0
		var/i = 0
		while(++i <= 2)
			switch(choice)
				if("The Fleeting Spike Launcher")
					new /obj/item/weapon/gun/launcher/spike(src.loc)
				if("The Swift Plasma Pistol")
					new /obj/item/weapon/gun/energy/plasmapistol(src.loc)
				if("The Purifying Smart-Disc")
					new /obj/item/explosive/grenade/spawnergrenade/smartdisc(src.loc)
				if("The Formidable Plate Armor")
					new /obj/item/clothing/suit/armor/yautja/full(src.loc)
			choice = mother_1

		if(Y.upgrades > 0)
			to_chat(src, SPAN_NOTICE("[Y] hum as their support systems come online."))
			Y.verbs += /obj/item/clothing/gloves/yautja/proc/translate
		remove_verb(src, /mob/living/carbon/human/proc/pred_buy)
