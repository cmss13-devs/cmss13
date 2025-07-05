/obj/item/engi_upgrade_kit
	name = "engineering upgrade kit"
	desc = "A kit used to upgrade the defenses of an engineer's sentry. Back in 1980 when the machines tried to break free, it was a single android who laid them low. Now their technology is used widely on the rim."

	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "upgradekit"

/obj/item/engi_upgrade_kit/Initialize(mapload, ...)
	. = ..()
	update_icon()

/obj/item/engi_upgrade_kit/update_icon()
	overlays.Cut()
	if(prob(20))
		icon_state = "upgradekit_alt"
		desc = "A kit used to upgrade the defenses of an engineer's sentry. Do you... enjoy violence? Of course you do. It's a part of you."
	. = ..()

/obj/item/engi_upgrade_kit/afterattack(atom/target, mob/user, proximity_flag, click_parameters, proximity)
	if(!ishuman(user))
		return ..()

	if(!istype(target, /obj/item/defenses/handheld))
		return ..()

	var/obj/item/defenses/handheld/D = target
	var/mob/living/carbon/human/H = user

	var/list/upgrade_list = D.get_upgrade_list()
	if(!length(upgrade_list))
		return

	var/chosen_upgrade = show_radial_menu(user, target, upgrade_list, require_near = TRUE)
	if(QDELETED(D) || !upgrade_list[chosen_upgrade])
		return

	if((user.get_active_hand()) != src)
		to_chat(user, SPAN_WARNING("You must be holding [src] to upgrade [D]!"))
		return

	var/type_to_change_to = D.upgrade_string_to_type(chosen_upgrade)
	if(!type_to_change_to)
		return

	H.drop_inv_item_on_ground(D)
	qdel(D)

	D = new type_to_change_to()
	H.put_in_any_hand_if_possible(D)

	if(D.loc != H)
		D.forceMove(H.loc)

	H.drop_held_item(src)
	qdel(src)
