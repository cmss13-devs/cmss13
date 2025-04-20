/obj/item/fishing_pole
	name = "fishing pole"
	desc = "A fishing pole. You reckon you might need water for this..."

	icon = 'icons/obj/structures/fishing.dmi' // replace this or whatever, i ain't a spriter
	icon_state = "pole_inhand" // this you should rename, though

	force = 15
	throwforce = 7
	attack_verb = list("slapped")

	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK

	var/common_weight = 80
	var/uncommon_weight = 40
	var/rare_weight = 5
	var/ultra_rare_weight = 1

	var/deploy_type = /obj/structure/prop/fishing/pole_interactive
	var/obj/item/fish_bait/loaded_bait

/obj/item/fishing_pole/examine(mob/user)
	if(loaded_bait)
		to_chat(user, SPAN_NOTICE("It has [loaded_bait] loaded on its hook."))
	else
		to_chat(user, SPAN_WARNING("It doesn't have any bait attached!"))

/obj/item/fishing_pole/attack_self(mob/user)
	..()
	var/turf/forward = get_step(user.loc, user.dir)
	if(!forward)
		return

	if(!forward.fishing_allowed)
		to_chat(user, SPAN_WARNING("You can not fish here!"))
		return
	
	user.visible_message(SPAN_NOTICE("[user] starts setting up \the [src]..."))
	
	if(!do_after(user, 3 SECONDS, show_busy_icon = BUSY_ICON_BUILD))
		return

	user.visible_message(SPAN_NOTICE("[user] finishes setting up \the [src]!"), SPAN_NOTICE("You finish setting up \the [src]!"))
	var/obj/structure/prop/fishing/pole_interactive/deployed_pole = new deploy_type(get_turf(src))
	transfer_to_pole(deployed_pole, user)

/obj/item/fishing_pole/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/fish_bait))
		if(loaded_bait)
			to_chat(user, SPAN_WARNING("\The [src] already has bait loaded onto the hook!"))
			return
		if(user.drop_inv_item_to_loc(I, src))
			loaded_bait = I
			user.visible_message(SPAN_NOTICE("[user] loads \the [I] onto \the [src]'s hook."), SPAN_NOTICE("You load \the [I] onto \the [src]'s hook."))
			return
	return ..()

/obj/item/fishing_pole/proc/transfer_to_pole(obj/structure/prop/fishing/pole_interactive/pole, mob/user)
	pole.dir = user.dir

	pole.common_weight = common_weight
	pole.uncommon_weight = uncommon_weight
	pole.rare_weight = rare_weight
	pole.ultra_rare_weight = ultra_rare_weight

	if(loaded_bait)
		pole.loaded_bait = loaded_bait
		loaded_bait.forceMove(pole)
		loaded_bait = null

	transfer_fingerprints_to(pole)
	qdel(src)

/obj/item/fishing_pole/proc/transfer_to_user(obj/structure/prop/fishing/pole_interactive/parent, mob/user)
	common_weight = parent.common_weight
	uncommon_weight = parent.uncommon_weight
	rare_weight = parent.rare_weight
	ultra_rare_weight = parent.ultra_rare_weight

	if(parent.loaded_bait)
		loaded_bait = parent.loaded_bait
		parent.loaded_bait.forceMove(src)
		parent.loaded_bait = null

	user.put_in_hands(src)
	parent.transfer_fingerprints_to(src)
	qdel(parent)
