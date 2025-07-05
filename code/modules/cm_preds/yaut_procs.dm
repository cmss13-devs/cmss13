// Notify all preds with the bracer icon
/proc/message_all_yautja(msg, soundeffect = TRUE)
	for(var/mob/living/carbon/human/Y in GLOB.yautja_mob_list)
		// Send message to the bracer; appear multiple times if we have more bracers
		for(var/obj/item/clothing/gloves/yautja/hunter/G in Y.contents)
			to_chat(Y, SPAN_YAUTJABOLD("[icon2html(G)] \The <b>[G]</b> beeps: [msg]"))
			if(G.notification_sound)
				playsound(Y.loc, 'sound/items/pred_bracer.ogg', 75, 1)

/proc/elder_overseer_message(text = "", title_text = "Elder Overseer", elder_user = "AutomatedMessage") // you can override the title_text if you want.
	for(var/mob/living/carbon/human/hunter as anything in GLOB.yautja_mob_list)
		if(!hunter.client)
			continue
		if(hunter.stat == DEAD)
			continue
		text = "[SPAN_YAUTJABOLDBIG("<b>[text]<b>")]"
		hunter.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>[title_text]</u></span><br>" + text, /atom/movable/screen/text/screen_text/command_order/yautja, override_color = "#af0614")
		var/elder_picked = pick('sound/voice/pred_elder_overseer_1.ogg', 'sound/voice/pred_elder_overseer_2.ogg', 'sound/voice/pred_elder_overseer_3.ogg', 'sound/voice/pred_elder_overseer_4.ogg')
		playsound_client(hunter.client, elder_picked, 25)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat_spaced), hunter, "[SPAN_YAUTJABOLDBIG("Overseer Message Log")]<br><br>[SPAN_YAUTJABOLDBIG("[title_text]")]<br><br>[SPAN_YAUTJABOLD(text)]", MESSAGE_TYPE_RADIO), 12 SECONDS)
	if(elder_user != "AutomatedMessage")
		message_admins("[elder_user] has created a Yautja Elder Overseer message")
		log_admin("[elder_user] created a predator council message: [text]")

/client/proc/pred_council_message()
	set name = "Yautja Overseer Report"
	set category = "OOC.Whitelist"

	if(!check_whitelist_status(WHITELIST_YAUTJA_COUNCIL))
		to_chat(src, SPAN_WARNING("Only the Yautja Council may use this command."))
		return

	var/is_living_yautja = FALSE
	if(isyautja(mob) && !mob.stat)
		is_living_yautja = TRUE

	if(!(is_living_yautja || (isHellhound(mob) && !mob.stat) || isobserver(mob)))
		to_chat(src, SPAN_WARNING("You must be a Yautja related mob (and conscious) or a ghost to use this command."))
		return

	var/message_personal = "Send a message to all living hunters."
	var/message_impersonal = "This is a message from the Yautja Elder Overseer. They are not your character. Use this to direct big groups of Yautja when needed and to stop/prevent honor code breaches."
	var/title_personal = "What will you say?"
	var/title_impersonal = "What Will The Elder Say?"

	var/input = tgui_input_text(src, is_living_yautja ? message_personal : message_impersonal, is_living_yautja ? title_personal : title_impersonal)
	if(!input)
		return FALSE
	if(is_living_yautja)
		elder_overseer_message(input, mob.real_name, "[key_name(src)]")
		return TRUE
	elder_overseer_message(input, elder_user = "[key_name(src)]")
	return TRUE

/mob/living/carbon/human/proc/message_thrall(msg)
	if(!hunter_data.thrall)
		return

	var/mob/living/carbon/T = hunter_data.thrall

	for(var/obj/item/clothing/gloves/yautja/hunter/G in T.contents)
		to_chat(T, SPAN_YAUTJABOLD("[icon2html(G)] \The <b>[G]</b> beeps: [msg]"))
		if(G.notification_sound)
			playsound(T.loc, 'sound/items/pred_bracer.ogg', 75, 1)

//Update the power display thing. This is called in Life()
/mob/living/carbon/human/proc/update_power_display(perc)
	if(hud_used?.pred_power_icon)
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
	set category = "Yautja.Misc"
	set name = "Butcher"
	set desc = "Butcher a corpse you're standing on for its tasty meats."

	if(is_mob_incapacitated() || body_position != STANDING_UP || buckled)
		return

	var/list/choices = list()
	for(var/mob/living/carbon/M in view(1, src) - src)
		if(Adjacent(M) && M.stat == DEAD)
			if(ishuman(M))
				var/mob/living/carbon/human/Q = M
				if(Q.species && issamespecies(Q, src))
					continue
			choices += M

	var/mob/living/carbon/T = tgui_input_list(src, "What do you wish to butcher?", "Butcher", choices)

	var/mob/living/carbon/xenomorph/xeno_victim
	var/mob/living/carbon/human/victim

	if(!T || !src || !T.stat)
		to_chat(src, SPAN_WARNING("Nope."))
		return

	if(!Adjacent(T))
		to_chat(src, SPAN_WARNING("You have to be next to your target."))
		return

	if(islarva(T) || isfacehugger(T))
		to_chat(src, SPAN_WARNING("This tiny worm is not even worth using your tools on."))
		return

	if(is_mob_incapacitated() || body_position != STANDING_UP || buckled)
		return

	if(issynth(T))
		to_chat(src, SPAN_WARNING("You would break your tools if you did this!"))
		return

	if(isxeno(T))
		xeno_victim = T

	var/static/list/procedure_choices = list(
		"Skin" = null,
		"Behead" = "head",
		"Delimb - Right Hand" = "r_hand",
		"Delimb - Left Hand" = "l_hand",
		"Delimb - Right Arm" = "r_arm",
		"Delimb - Left Arm" = "l_arm",
		"Delimb - Right Foot" = "r_foot",
		"Delimb - Left Foot" = "l_foot",
		"Delimb - Right Leg" = "r_leg",
		"Delimb - Left Leg" = "l_leg",
	)

	var/procedure = ""
	if(ishuman(T))
		victim = T

	if(victim)
		procedure = tgui_input_list(src, "Which slice would you like to take?", "Take Slice", procedure_choices)
		if(!procedure)
			return

	if(isxeno(T) || procedure == "Skin")
		if(T.butchery_progress)
			playsound(loc, 'sound/weapons/pierce.ogg', 25)
			visible_message(SPAN_DANGER("[src] goes back to butchering \the [T]."), SPAN_NOTICE("You get back to butchering \the [T]."))
		else
			playsound(loc, 'sound/weapons/pierce.ogg', 25)
			visible_message(SPAN_DANGER("[src] begins chopping and mutilating \the [T]."), SPAN_NOTICE("You take out your tools and begin your gruesome work on \the [T]. Hold still."))
			T.butchery_progress = 1

		if(T.butchery_progress == 1)
			if(do_after(src, 7 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				visible_message(SPAN_DANGER("[src] makes careful slices and tears out the viscera in \the [T]'s abdominal cavity."), SPAN_NOTICE("You carefully vivisect \the [T], ripping out the guts and useless organs. What a stench!"))
				T.butchery_progress = 2
				playsound(loc, 'sound/weapons/slash.ogg', 25)
			else
				to_chat(src, SPAN_NOTICE("You pause your butchering for later."))

		if(T.butchery_progress == 2)
			if(do_after(src, 6.5 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				visible_message(SPAN_DANGER("[src] hacks away at \the [T]'s limbs and slices off strips of dripping meat."), SPAN_NOTICE("You slice off a few of \the [T]'s limbs, making sure to get the finest cuts."))
				if(xeno_victim && isturf(xeno_victim.loc))
					var/obj/item/reagent_container/food/snacks/meat/xenomeat = new /obj/item/reagent_container/food/snacks/meat/xenomeat(T.loc)
					xenomeat.name = "raw [xeno_victim.age_prefix][xeno_victim.caste_type] steak"
				else if(victim && isturf(victim.loc))
					victim.apply_damage(100, BRUTE, pick("r_leg", "l_leg", "r_arm", "l_arm"), FALSE, TRUE) //Basically just rips off a random limb.
					var/obj/item/reagent_container/food/snacks/meat/meat = new /obj/item/reagent_container/food/snacks/meat(victim.loc)
					meat.name = "raw [victim.name] steak"
				T.butchery_progress = 3
				playsound(loc, 'sound/weapons/bladeslice.ogg', 25)
			else
				to_chat(src, SPAN_NOTICE("You pause your butchering for later."))

		if(T.butchery_progress == 3)
			if(do_after(src, 7 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				visible_message(SPAN_DANGER("[src] tears apart \the [T]'s ribcage and begins chopping off bit and pieces."), SPAN_NOTICE("You rip open \the [T]'s ribcage and start tearing the tastiest bits out."))
				if(xeno_victim && isturf(xeno_victim.loc))
					var/obj/item/reagent_container/food/snacks/meat/xenomeat = new /obj/item/reagent_container/food/snacks/meat/xenomeat(T.loc)
					xenomeat.name = "raw [xeno_victim.age_prefix][xeno_victim.caste_type] tenderloin"
				else if(victim && isturf(T.loc))
					var/obj/item/reagent_container/food/snacks/meat/meat = new /obj/item/reagent_container/food/snacks/meat(victim.loc)
					meat.name = "raw [victim.name] tenderloin"
					victim.apply_damage(100, BRUTE,"chest", FALSE, FALSE)
				T.butchery_progress = 4
				playsound(loc, 'sound/weapons/wristblades_hit.ogg', 25)
			else
				to_chat(src, SPAN_NOTICE("You pause your butchering for later."))

		if(T.butchery_progress == 4)
			if(do_after(src, 9 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				if(xeno_victim && isturf(T.loc))
					visible_message(SPAN_DANGER("[src] flenses the last of [victim]'s exoskeleton, revealing only bones!."), SPAN_NOTICE("You flense the last of [victim]'s exoskeleton clean off!"))
					new /obj/effect/decal/remains/xeno(xeno_victim.loc)
					var/obj/item/skull/skull = new xeno_victim.skull(xeno_victim.loc)
					var/obj/item/pelt/pelt = new xeno_victim.pelt(xeno_victim.loc)
					pelt.name = "[xeno_victim.real_name] pelt"
					skull.name = "[xeno_victim.real_name] skull"
				else if(victim && isturf(T.loc))
					visible_message(SPAN_DANGER("[src] reaches down and rips out \the [T]'s spinal cord and skull!."), SPAN_NOTICE("You firmly grip the revealed spinal column and rip [T]'s head off!"))
					if(!(victim.get_limb("head").status & LIMB_DESTROYED))
						victim.apply_damage(150, BRUTE, "head", FALSE, TRUE)
						var/obj/item/clothing/accessory/limb/skeleton/head/spine/new_spine = new /obj/item/clothing/accessory/limb/skeleton/head/spine(victim.loc)
						new_spine.name = "[victim]'s spine"
					else
						var/obj/item/reagent_container/food/snacks/meat/meat = new /obj/item/reagent_container/food/snacks/meat(victim.loc)
						meat.name = "raw [victim.real_name] steak"
						new /obj/item/clothing/accessory/limb/skeleton/torso(victim.loc)
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
					emote("roar2")
					message_all_yautja("[src.real_name] has claimed [T] as their trophy.")
					hunter_data.prey = null
				else
					to_chat(src, SPAN_NOTICE("You finish butchering!"))
				qdel(T)
			else
				to_chat(src, SPAN_NOTICE("You pause your butchering for later."))
	else
		var/limb = procedure_choices[procedure]
		var/limbName = parse_zone(limb)
		if(victim.get_limb(limb).status & LIMB_DESTROYED)
			to_chat(src, SPAN_WARNING("The victim lacks a [limbName]."))
			return
		if(limb == "head")
			visible_message("<b>[src] reaches down and starts beheading [T].</b>","<b>You reach down and start beheading [T].</b>")
		else
			visible_message("<b>[src] reaches down and starts removing [T]'s [limbName].</b>","<b>You reach down and start removing [T]'s [limbName].</b>")
		if(do_after(src, 9 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			if(victim.get_limb(limb).status & LIMB_DESTROYED)
				to_chat(src, SPAN_WARNING("The victim lacks a [limbName]."))
				return
			victim.get_limb(limb).droplimb(TRUE, FALSE, "butchering")
			playsound(loc, 'sound/weapons/slice.ogg', 25)
			if(hunter_data.prey == T)
				to_chat(src, SPAN_YAUTJABOLD("You have claimed [T] as your trophy."))
				emote("roar2")
				message_all_yautja("[src.real_name] has claimed [T] as their trophy.")
				hunter_data.prey = null
			else
				to_chat(src, SPAN_NOTICE("You finish butchering!"))

/area/yautja
	name = "\improper Yautja Ship"
	icon = 'icons/turf/areas.dmi'
	icon_state = "hunter"
	//music = "signal"
	ambience_exterior = AMBIENCE_YAUTJA
	ceiling = CEILING_METAL
	requires_power = FALSE
	base_lighting_alpha = 155
	base_lighting_color = "#ffc49c"
	flags_area = AREA_YAUTJA_GROUNDS

/area/yautja/lower_deck
	name = "\improper Yautja Ship - Lower Deck"
	base_lighting_alpha = 105

/area/yautja/hangar
	name = "\improper Yautja Ship - Hangar"
	base_lighting_alpha = 180
