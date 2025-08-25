//Link to thrall bracer, enabling most of it's abilities
/obj/item/clothing/gloves/yautja/hunter/verb/link_bracer()
	set name = "Link Thrall Bracer"
	set desc = "Link your bracer to that of your thrall."
	set category = "Yautja.Thrall"
	set src in usr

	var/mob/living/carbon/human/user = usr
	if(!istype(user))
		return
	if(!user.hunter_data)
		to_chat(user, SPAN_WARNING("ERROR: No hunter_data detected."))
		return

	if(linked_bracer)
		to_chat(user, SPAN_YAUTJABOLD("[icon2html(src)] \The <b>[src]</b> beeps: Link is already established!"))
		return

	if(user.gloves != src)
		to_chat(user, SPAN_WARNING("You are not wearing your bracer!"))
		return
	else if(!owner || user != owner)
		to_chat(user, SPAN_YAUTJABOLD("[icon2html(src)] \The <b>[src]</b> beeps: Wrong user detected!"))
		return

	var/mob/living/carbon/human/thrall = user.hunter_data.thrall
	if(!thrall)
		to_chat(user, SPAN_WARNING("You do not have a thrall to link to!"))
		return
	else if(!istype(thrall.gloves, /obj/item/clothing/gloves/yautja/thrall))
		to_chat(user, SPAN_YAUTJABOLD("[icon2html(src)] \The <b>[src]</b> beeps: Your thrall is not wearing a bracer!"))
		return
	else
		var/obj/item/clothing/gloves/yautja/thrall/thrall_gloves = thrall.gloves

		linked_bracer = thrall_gloves
		thrall_gloves.linked_bracer = src
		thrall_gloves.owner = thrall
		thrall.client?.init_verbs()
		thrall.set_species("Thrall")
		thrall.allow_gun_usage = FALSE
		to_chat(user, SPAN_YAUTJABOLD("[icon2html(src)] \The <b>[src]</b> beeps: Your bracer is now linked to your thrall."))
		if(notification_sound)
			playsound(loc, 'sound/items/pred_bracer.ogg', 75, 1)

		to_chat(thrall, SPAN_WARNING("\The [thrall_gloves] locks around your wrist with a sharp click."))
		to_chat(thrall, SPAN_YAUTJABOLD("[icon2html(thrall_gloves)] \The <b>[thrall_gloves]</b> beeps: Your master has linked their bracer to yours."))
		if(thrall_gloves.notification_sound)
			playsound(thrall_gloves.loc, 'sound/items/pred_bracer.ogg', 75, 1)

// Message thrall or master
/obj/item/clothing/gloves/yautja/verb/bracer_message()
	set name = "Transmit Message"
	set desc = "For direct communication between thrall and master."
	set src in usr

	var/mob/living/carbon/human/messenger = usr
	if(!istype(messenger))
		return

	var/mob/living/carbon/human/receiver
	var/messenger_title = "thrall"
	var/receiver_title = "master"
	if(messenger.hunter_data.thralled)
		receiver = messenger.hunter_data.thralled_set
	else
		receiver = messenger.hunter_data.thrall
		messenger_title = "master"
		receiver_title = "thrall"

	if(!istype(receiver))
		to_chat(messenger, SPAN_WARNING("You have no one to message!"))
		return
	if(!istype(receiver.gloves, /obj/item/clothing/gloves/yautja))
		to_chat(messenger, SPAN_WARNING("Your [receiver_title] isn't wearing their bracer!"))
		return

	var/message = sanitize(input(messenger, "Enter the message you want to send:", "Send Message") as null|text)
	if(!message)
		return

	if(!istype(receiver))
		to_chat(messenger, SPAN_WARNING("You have no one to message!"))
		return
	var/obj/item/clothing/gloves/yautja/receiver_gloves = receiver.gloves
	if(!istype(receiver_gloves))
		to_chat(messenger, SPAN_WARNING("Your [receiver_title] isn't wearing their bracer!"))
		return

	to_chat(receiver, SPAN_YAUTJABOLD("\The <b>[receiver_gloves]</b> beeps with a message from your [messenger_title]: [message]"))
	to_chat(messenger, SPAN_YAUTJABOLD("\The <b>[src]</b> beeps: You have sent '[message]' to your [receiver_title]."))

	if(notification_sound)
		playsound(loc, 'sound/items/pred_bracer.ogg', 75, 1)
	if(receiver_gloves.notification_sound)
		playsound(receiver_gloves.loc, 'sound/items/pred_bracer.ogg', 75, 1)

	log_game("HUNTER: [key_name(messenger)] has sent [key_name(receiver)] the message '[message]' via bracer")

/obj/item/clothing/gloves/yautja/hunter/bracer_message()
	set category = "Yautja.Thrall"
	. = ..()

/obj/item/clothing/gloves/yautja/thrall/bracer_message()
	set category = "Thrall"
	. = ..()

/obj/item/clothing/gloves/yautja/hunter/verb/stun_thrall()
	set name = "Stun Thrall"
	set desc = "Stun your thrall when it misbehaves"
	set category = "Yautja.Thrall"
	set src in usr

	var/mob/living/carbon/human/master = usr
	var/mob/living/carbon/human/thrall = master.hunter_data.thrall
	if(!thrall)
		to_chat(master, SPAN_WARNING("You have no thrall to punish!"))
		return
	if(thrall.IsStun())
		to_chat(master, SPAN_WARNING("Your thrall is already stunned!"))
		return

	thrall.apply_effect(10, WEAKEN)
	to_chat(master, SPAN_WARNING("Your bracer beeps, your thrall is punished."))
	to_chat(thrall, SPAN_WARNING("You feel a searing shock rip through your body! You fall to the ground in pain!"))

/obj/item/clothing/gloves/yautja/hunter/verb/self_destruct_thrall()
	set name = "Self Destruct Thrall (!)"
	set desc = "Stun and trigger the self destruct device inside of your thrall's bracers. They have failed you. Show no mercy."
	set category = "Yautja.Thrall"
	set src in usr

	var/mob/living/carbon/human/master = usr
	var/mob/living/carbon/human/thrall = master.hunter_data.thrall
	var/area/grounds = get_area(thrall)



	if(master.stat == DEAD)
		to_chat(master, SPAN_WARNING("Little too late for that now!"))
		return
	if(master.health < HEALTH_THRESHOLD_CRIT)
		to_chat(master, SPAN_WARNING("As you fall into unconsciousness you fail to activate your self-destruct device before you collapse."))
		return
	if(master.stat)
		to_chat(master, SPAN_WARNING("Not while you're unconscious..."))
		return
	if(grounds?.flags_area & AREA_YAUTJA_HUNTING_GROUNDS)
		to_chat(master, SPAN_WARNING("Your bracer will not allow you to activate a self-destruction sequence in order to protect the hunting preserve."))
		return
	if(!thrall)
		to_chat(master, SPAN_WARNING("You have no thrall to destroy!"))

	if(exploding)
		return

	if(tgui_alert(thrall, "Are you sure you want to detonate this [thrall.species]'s bracer? There is no stopping this process","Self Destruct Thrall", list("Yes", "No")) == "No")
		return

	var/area/area = get_area(thrall)
	var/turf/turf = get_turf(thrall)
	message_admins(FONT_SIZE_HUGE("ALERT: [master] ([master.key]) triggered their thrall's self-destruct sequence [area ? "in [area.name]":""] [ADMIN_JMP(turf)]"))
	log_attack("[key_name(master)] triggered their thrall's self-destruct sequence in [area ? "in [area.name]":""]")
	message_all_yautja("[master.real_name] has triggered their thrall's self-destruction sequence.")
	to_chat(master, SPAN_DANGER("You set the timer. They have failed you."))
	explode(thrall)
	exploding = FALSE
	do_after(thrall, (80), INTERRUPT_NONE, BUSY_ICON_HOSTILE)

	if(thrall)
		cell_explosion(thrall, 800, 550, EXPLOSION_FALLOFF_SHAPE_LINEAR, null)
		thrall.gib() // kills the thrall
		qdel(thrall)

	if(thrall.stat == DEAD)
		return
	thrall.apply_effect(10, WEAKEN)
	to_chat(thrall, SPAN_WARNING("You feel a searing shock rip through your body! You fall to the ground in pain!"))
