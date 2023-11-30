/obj/item/weapon/stunprod
	name = "electrified prodder"
	desc = "A specialised prod designed for incapacitating xenomorphic lifeforms with."
	icon_state = "stunbaton"
	item_state = "baton"
	flags_equip_slot = SLOT_WAIST
	force = 12
	throwforce = 7
	w_class = SIZE_MEDIUM
	var/charges = 12
	var/status = 0
	var/mob/foundmob = "" //Used in throwing proc.



/obj/item/weapon/stunprod/update_icon()
	if(status)
		icon_state = "stunbaton_active"
	else
		icon_state = "stunbaton"

/obj/item/weapon/stunprod/attack_self(mob/user)
	..()
	if(charges > 0)
		status = !status
		to_chat(user, SPAN_NOTICE("\The [src] is now [status ? "on" : "off"]."))
		playsound(src.loc, "sparks", 15, 1)
		update_icon()
	else
		status = 0
		to_chat(user, SPAN_WARNING("\The [src] is out of charge."))
	add_fingerprint(user)

/obj/item/weapon/stunprod/attack(mob/living/M, mob/user)
	if(isrobot(M))
		..()
		return

	if(user.a_intent == INTENT_HARM)
		return
	else if(!status)
		M.visible_message(SPAN_WARNING("[M] has been poked with [src] whilst it's turned off by [user]."))
		return

	if(status)
		M.KnockDown(6)
		M.Stun(6)
		charges -= 2
		M.visible_message(SPAN_DANGER("[M] has been prodded with the [src] by [user]!"))

		user.attack_log += "\[[time_stamp()]\]<font color='red'> Stunned [key_name(M)] with [src.name]</font>"
		M.attack_log += "\[[time_stamp()]\]<font color='orange'> Stunned by [key_name(user)] with [src.name]</font>"
		log_attack("[key_name(user)] stunned [key_name(M)] with [src.name]")

		playsound(src.loc, 'sound/weapons/Egloves.ogg', 25, 1)
		if(charges < 1)
			status = 0
			update_icon()

	add_fingerprint(user)


/obj/item/weapon/stunprod/emp_act(severity)
	. = ..()
	switch(severity)
		if(1)
			charges = 0
		if(2)
			charges = max(0, charges - 5)
	if(charges < 1)
		status = 0
		update_icon()


/obj/item/weapon/stunprod/improved
	charges = 30
	name = "improved electrified prodder"
	desc = "A specialised prod designed for incapacitating xenomorphic lifeforms with. This one seems to be much more effective than its predecessor."
	color = "#FF6666"

/obj/item/weapon/stunprod/improved/attack(mob/M, mob/user)
	..()
	M.apply_effect(14, WEAKEN)

/obj/item/weapon/stunprod/improved/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("It has [charges] charges left.")
