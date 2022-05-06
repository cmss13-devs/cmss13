//Claim gear, same as the Hunter's get.
/obj/item/clothing/gloves/yautja/thrall/proc/buy_gear()
	set category = "Thrall.Misc"
	set name = "Claim Equipment"
	set desc = "When you're on the Predator ship, claim some gear. You can only do this ONCE."
	var/mob/living/carbon/human/user = usr

	if(isSpeciesYautja(user))
		return

	if(user.is_mob_incapacitated() || user.lying || user.buckled)
		to_chat(user, "You're not able to do that right now.")
		return

	if(!istype(get_area(user),/area/yautja))
		to_chat(user, "Not here. Only on the ship.")
		return

	var/obj/item/clothing/gloves/yautja/thrall/Y = user.gloves
	if(!istype(Y) || Y.upgrades) return

	var/sure = alert("An array of powerful weapons are displayed to you. Pick your gear carefully. If you cancel at any point, you will not claim your equipment.","Sure?","Begin the Hunt","No, not now")
	if(sure == "Begin the Hunt")
		var/list/ymelee = list(YAUTJA_GEAR_GLAIVE, "The Nimble Spear", YAUTJA_GEAR_WHIP,YAUTJA_GEAR_SWORD,YAUTJA_GEAR_SCYTHE, YAUTJA_GEAR_STICK)
		var/list/hmelee = list("The Swift Machete", "The Dancing Rapier", "The Broad Claymore", "The Purposeful Fireaxe")
		var/list/radial_ymelee = list(YAUTJA_GEAR_GLAIVE = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "glaive"), YAUTJA_GEAR_WHIP = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "whip"),YAUTJA_GEAR_SWORD = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "clansword"),YAUTJA_GEAR_SCYTHE = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "predscythe"), YAUTJA_GEAR_STICK = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "combistick"), "The Nimble Spear" = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "spearhunter"))
		var/list/radial_hmelee = list("The Swift Machete" = image(icon = 'icons/obj/items/weapons/weapons.dmi', icon_state = "machete"), "The Dancing Rapier" = image(icon = 'icons/obj/items/weapons/weapons.dmi', icon_state = "ceremonial"), "The Broad Claymore" = image(icon = 'icons/obj/items/weapons/weapons.dmi', icon_state = "mercsword"), "The Purposeful Fireaxe" = image(icon = 'icons/obj/items/weapons/weapons.dmi', icon_state = "fireaxe"))
		var/msel
		var/type = alert("Do you seek to bring honor to your race, or embrace an alien culture?", "Human or Alien?", "Semper Humanus!", "What's loyalty?")
		if(type == "Semper Humanus!")
			if(usr.client.prefs && usr.client.prefs.no_radials_preference)
				msel = tgui_input_list(usr, "Which weapon shall you use on your hunt?:","Melee Weapon", hmelee)
			else
				msel = show_radial_menu(usr, src, radial_hmelee)
		else if(type == "What's loyalty?")
			if(usr.client.prefs && usr.client.prefs.no_radials_preference)
				msel = tgui_input_list(usr, "Which weapon shall you use on your hunt?:","Melee Weapon", ymelee)
			else
				msel = show_radial_menu(usr, src, radial_ymelee)
		if(!msel) return //We don't want them to cancel out then get nothing.


		if(!istype(Y) || Y.upgrades) return //Tried to run it several times in the same loop. That's not happening.
		Y.upgrades++ //Just means gear was purchased.

		switch(msel)
			if("The Lumbering Glaive")
				new /obj/item/weapon/melee/twohanded/yautja/glaive(user.loc)
			if("The Nimble Spear")
				new /obj/item/weapon/melee/twohanded/yautja/spear(user.loc)
			if("The Rending Chain-Whip")
				new /obj/item/weapon/melee/yautja/chain(user.loc)
			if("The Piercing Hunting Sword")
				new /obj/item/weapon/melee/yautja/sword(user.loc)
			if("The Cleaving War-Scythe")
				new /obj/item/weapon/melee/yautja/scythe(user.loc)
			if("The Adaptive Combi-Stick")
				new /obj/item/weapon/melee/yautja/combistick(user.loc)
			if("The Swift Machete")
				new /obj/item/weapon/melee/claymore/mercsword/machete(user.loc)
			if("The Dancing Rapier")
				new /obj/item/weapon/melee/claymore/mercsword/ceremonial(user.loc)
			if("The Broad Claymore")
				new /obj/item/weapon/melee/claymore(user.loc)
			if("The Purposeful Fireaxe")
				new /obj/item/weapon/melee/twohanded/fireaxe(user.loc)

		Y.verbs -= /obj/item/clothing/gloves/yautja/thrall/proc/buy_gear
		new /obj/item/clothing/suit/armor/yautja/thrall(user.loc)
		new /obj/item/clothing/shoes/yautja/thrall(user.loc)
		new /obj/item/clothing/under/chainshirt/thrall(user.loc)
		new /obj/item/clothing/mask/gas/yautja/thrall(user.loc)


//Link to thrall bracer, enabling most of it's abilities
/obj/item/clothing/gloves/yautja/hunter/verb/link_bracer()
	set name = "Link Thrall Bracer"
	set desc = "Link your bracer to that of your thrall."
	set category = "Yautja.Thrall"

	var/mob/living/carbon/human/user = usr
	if(!istype(user))
		return
	if(!user.hunter_data)
		to_chat(user, SPAN_WARNING("ERROR: No hunter_data detected."))
		return

	var/mob/living/carbon/human/T = user.hunter_data.thrall
	var/obj/item/clothing/gloves/yautja/hunter/G
	var/obj/item/clothing/gloves/yautja/thrall/TG

	if(istype(user.gloves, /obj/item/clothing/gloves/yautja/hunter))
		G = user.gloves
	else if(user.gloves != src)
		to_chat(user, SPAN_WARNING("You are not wearing your bracer!"))
		return
	else if(!owner || !user == owner)
		to_chat(user, SPAN_YAUTJABOLD("[icon2html(G)] \The <b>[G]</b> beep: Wrong user detected!"))
		return

	if(!T)
		to_chat(user, SPAN_WARNING("You do not have a thrall to link to!"))
		return
	else if(!istype(T.gloves, /obj/item/clothing/gloves/yautja/thrall))
		to_chat(user, SPAN_YAUTJABOLD("[icon2html(G)] \The <b>[G]</b> beep: Your thrall is not wearing a bracer!"))
		return
	else if(G.linked_bracer)
		to_chat(user, SPAN_YAUTJABOLD("[icon2html(G)] \The <b>[G]</b> beep: link is already established!"))
	else
		TG = T.gloves

		G.linked_bracer = TG
		TG.linked_bracer = G
		TG.owner = T
		TG.verbs += /obj/item/clothing/gloves/yautja/thrall/proc/buy_gear

		to_chat(user, SPAN_YAUTJABOLD("[icon2html(G)] \The <b>[G]</b> beep: Your bracer is now linked to your thrall."))
		if(G.notification_sound)
			playsound(G.loc, 'sound/items/pred_bracer.ogg', 75, 1)

		to_chat(T, SPAN_WARNING("The [TG] locks around your wrist with a sharp click."))
		to_chat(T, SPAN_YAUTJABOLD("[icon2html(TG)] \The <b>[TG]</b> beep: Your master has linked their bracer to yours."))
		if(TG.notification_sound)
			playsound(TG.loc, 'sound/items/pred_bracer.ogg', 75, 1)




//Message thrall or master
/obj/item/clothing/gloves/yautja/verb/bracer_message()
	set name = "Transmit Message"
	set desc = "For direct communication between thrall and master."

	var/mob/living/carbon/human/O = usr
	if(!O || !istype(O) || !O.hunter_data)
		return
	var/obj/item/clothing/gloves/yautja/OG = O.gloves
	if(!OG || !istype(OG) || !OG.linked_bracer)
		return
	var/mob/living/carbon/human/T = O.hunter_data.thrall
	var/obj/item/clothing/gloves/yautja/TG = OG.linked_bracer
	var/TM = "thrall" //This is the target
	var/OM = "master" //This is the origin

	if(!istype(OG, /obj/item/clothing/gloves/yautja))
		return
	if(!isYautja(O)) //Swap origin and target due to race
		T = O.hunter_data.thralled_set
		TM = "master"
		OM = "thrall"

	if(!T)
		to_chat(O, SPAN_WARNING("You do not have a [TM] to message."))
		return

	if(!TG)
		to_chat(usr, SPAN_YAUTJABOLD("[icon2html(OG)] \The <b>[OG]</b> beep: Your [TM]'s bracer is unlinked!"))
	else if(!T.gloves == TG)
		to_chat(usr, SPAN_YAUTJABOLD("[icon2html(OG)] \The <b>[OG]</b> beep: Your [TM] is not wearing their bracer!"))
	else if(!TG.owner)
		to_chat(usr, SPAN_YAUTJABOLD("[icon2html(OG)] \The <b>[OG]</b> beep: [TM] bracer is unbound."))
		return
	else
		OG.bracer_message_int(O, OG, T, TG, TM, OM)

/obj/item/clothing/gloves/yautja/hunter/bracer_message()
	set category = "Yautja.Thrall"

	. = ..()
/obj/item/clothing/gloves/yautja/thrall/bracer_message()
	set category = "Thrall"

	. = ..()

/obj/item/clothing/gloves/yautja/proc/bracer_message_int(var/mob/living/carbon/human/O, var/obj/item/clothing/gloves/yautja/OG, var/mob/living/carbon/human/T, var/obj/item/clothing/gloves/yautja/TG, var/TM, var/OM, var/msg)

	if(!msg)
		msg = input("Enter a message to send to your [TM].")

	to_chat(T, SPAN_YAUTJABOLD("[icon2html(TG)] \The <b>[TG]</b> beep with a message from your [OM]: [msg]"))
	to_chat(O, SPAN_YAUTJABOLD("[icon2html(OG)] \The <b>[OG]</b> beep: you have sent '[msg]' to your [TM]"))
	log_game("HUNTER: [key_name(owner)] has sent [key_name(T)] the message '[msg]' via bracer")
	if(TG.notification_sound)
		playsound(TG.loc, 'sound/items/pred_bracer.ogg', 75, 1)
	if(OG.notification_sound)
		playsound(OG.loc, 'sound/items/pred_bracer.ogg', 75, 1)
