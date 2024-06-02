/obj/item/device/radio/electropack
	name = "electropack"
	desc = "Dance my monkeys! DANCE!!!"
	icon_state = "electropack0"
	item_state = "electropack"
	frequency = 1457
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_BACK
	w_class = SIZE_HUGE

	matter = list("metal" = 10000,"glass" = 2500)
	black_market_value = 20

	var/code = 2
	var/mob_move_time = 0

/obj/item/device/radio/electropack/attack_hand(mob/user as mob)
	if(src == user.back)
		to_chat(user, SPAN_NOTICE("You need help taking this off!"))
		return
	..()


/obj/item/device/radio/electropack/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(usr.stat || usr.is_mob_restrained())
		return
	if(((istype(usr, /mob/living/carbon/human) && ((!( SSticker ) || (SSticker && SSticker.mode != "monkey")) && usr.contents.Find(src))) || (usr.contents.Find(master) || (in_range(src, usr) && istype(loc, /turf)))))
		usr.set_interaction(src)
		if(href_list["freq"])
			var/new_frequency = sanitize_frequency(frequency + text2num(href_list["freq"]))
			set_frequency(new_frequency)
		else
			if(href_list["code"])
				code += text2num(href_list["code"])
				code = floor(code)
				code = min(100, code)
				code = max(1, code)
			else
				if(href_list["power"])
					on = !( on )
					icon_state = "electropack[on]"
		if(!( master ))
			if(istype(loc, /mob))
				attack_self(loc)
			else
				for(var/mob/M as anything in viewers(1, src))
					if(M.client)
						attack_self(M)
		else
			if(istype(master.loc, /mob))
				attack_self(master.loc)
			else
				for(var/mob/M as anything in viewers(1, master))
					if(M.client)
						attack_self(M)
	else
		close_browser(usr, "radio")
		return
	return

/obj/item/device/radio/electropack/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption != code)
		return

	if(ismob(loc) && on)
		var/mob/M = loc
		var/turf/T = M.loc
		if(istype(T, /turf))
			if( (world.time - mob_move_time) >= (5 SECONDS) && M.last_move_dir)
				mob_move_time = world.time
				step(M, M.last_move_dir)
		to_chat(M, SPAN_DANGER("You feel a sharp shock!"))
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(3, 1, M)
		s.start()

		M.apply_effect(10, WEAKEN)

	if(master && wires & 1)
		master.receive_signal()
	return

/obj/item/device/radio/electropack/attack_self(mob/user as mob, flag1)
	..()

	if(!istype(user, /mob/living/carbon/human))
		return
	user.set_interaction(src)
	var/dat = {"<TT>
<A href='?src=\ref[src];power=1'>Turn [on ? "Off" : "On"]</A><BR>
<B>Frequency/Code</B> for electropack:<BR>
Frequency: [format_frequency(frequency)] kHz<BR>

Code:
<A href='byond://?src=\ref[src];code=-5'>-</A>
<A href='byond://?src=\ref[src];code=-1'>-</A> [code]
<A href='byond://?src=\ref[src];code=1'>+</A>
<A href='byond://?src=\ref[src];code=5'>+</A><BR>
</TT>"}
	show_browser(user, dat, "Electropack Configuration", "radio")
	onclose(user, "radio")
	return
