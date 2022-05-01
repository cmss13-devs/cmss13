/obj/item/clothing/gloves/synth
	var/obj/structure/transmitter/internal/internal_transmitter

/obj/item/clothing/gloves/synth/Initialize(mapload, ...)
	. = ..()
	internal_transmitter = new(src)
	internal_transmitter.relay_obj = src
	internal_transmitter.phone_category = "Synth"
	internal_transmitter.enabled = FALSE

	RegisterSignal(internal_transmitter, COMSIG_TRANSMITTER_UPDATE_ICON, .proc/check_for_ringing)

/obj/item/clothing/gloves/synth/Destroy()
	QDEL_NULL(internal_transmitter)
	return ..()

/obj/item/clothing/gloves/synth/proc/check_for_ringing()
	SIGNAL_HANDLER
	update_icon()

/obj/item/clothing/gloves/synth/forceMove(atom/dest)
	. = ..()
	if(isturf(dest))
		internal_transmitter.set_tether_holder(src)
	else
		internal_transmitter.set_tether_holder(loc)

/obj/item/clothing/gloves/synth/pickup(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.comm_title)
			internal_transmitter.phone_id = "[H.comm_title] [H]"
		else if(H.job)
			internal_transmitter.phone_id = "[H.job] [H]"
		else
			internal_transmitter.phone_id = "[H]"

		if(H.assigned_squad)
			internal_transmitter.phone_id += " ([H.assigned_squad.name])"
	else
		internal_transmitter.phone_id = "[user]"

	internal_transmitter.enabled = TRUE

/obj/item/clothing/gloves/synth/dropped(mob/user)
	. = ..()
	if(internal_transmitter)
		internal_transmitter.phone_id = "[src]"
		internal_transmitter.enabled = FALSE

/obj/item/clothing/gloves/synth/attackby(obj/item/W, mob/user)
	if(internal_transmitter.attached_to == W)
		internal_transmitter.attackby(W, user)
		return
	return ..()

/obj/item/clothing/gloves/synth/attack_hand(mob/living/carbon/human/user)
	if(istype(user) && user.gloves == src)
		internal_transmitter.attack_hand(user)
		return
	return ..()
