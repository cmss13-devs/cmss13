#define MINECART_MAX_PHORON 150

/obj/structure/minecart
	name = "minecart"
	desc = "A study minecart used to transport goods in rough terrain."
	icon = 'icons/obj/structures/minecart.dmi'
	icon_state = "minecart"
	drag_delay = 1.5
	density = TRUE
	anchored = FALSE
	debris = list(/obj/item/stack/sheet/metal)
	var/amount = 0

/obj/structure/minecart/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER|PASS_AROUND|PASS_UNDER

/obj/structure/minecart/update_icon()
	overlays.Cut()

	switch(round(amount * 100 / MINECART_MAX_PHORON))
		if(99 to INFINITY)
			overlays += "+full_amount"
		if(50 to 99)
			overlays += "+big_amount"
		if(25 to 50)
			overlays += "+medium_amount"
		if(1 to 25)
			overlays += "+small_amount"

/obj/structure/minecart/examine(var/mob/user)
	..()
	var/text
	switch(round(amount * 100 / MINECART_MAX_PHORON))
		if(99 to INFINITY)
			text = "It appears to be full."
		if(50 to 99)
			text = "It appears to be almost full."
		if(25 to 50)
			text = "It appears to be halfway filled."
		if(0 to 25)
			text = "It appears to be slightly filled."
		else
			text = "It appears to be empty."

	to_chat(user, SPAN_NOTICE(text))

/obj/structure/minecart/attack_alien(mob/living/carbon/Xenomorph/M)
	M.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	health -= rand(M.melee_damage_lower, M.melee_damage_upper)

	if(health <= 0)
		M.visible_message(SPAN_DANGER("\The [M] slices [src] apart!"), SPAN_DANGER("You slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		destroy()
	else
		M.visible_message(SPAN_DANGER("[M] slashes [src]!"), SPAN_DANGER("You slash [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)

