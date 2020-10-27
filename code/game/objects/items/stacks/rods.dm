/obj/item/stack/rods
	name = "metal rod"
	desc = "Some rods. Can be used for building, or something."
	singular_name = "metal rod"
	icon_state = "rods"
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_MEDIUM
	force = 9.0
	throwforce = 15.0
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	matter = list("metal" = 1875)
	max_amount = 60
	attack_verb = list("hit", "bludgeoned", "whacked")
	stack_id = "metal rod"
	garbage = TRUE

/obj/item/stack/rods/Initialize(mapload, ...)
	. = ..()
	
	recipes = rod_recipes

/obj/item/stack/rods/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/WT = W

		if(amount < 4)
			to_chat(user, SPAN_DANGER("You need at least four rods to do this."))
			return

		if(WT.remove_fuel(0,user))
			var/obj/item/stack/sheet/metal/new_item = new(usr.loc)
			new_item.add_to_stacks(usr)
			for (var/mob/M in viewers(src))
				M.show_message(SPAN_DANGER("[src] is shaped into metal by [user.name] with the weldingtool."), 3, SPAN_DANGER("You hear welding."), 2)
			var/obj/item/stack/rods/R = src
			src = null
			var/replace = (user.get_inactive_hand()==R)
			R.use(4)
			if (!R && replace)
				user.put_in_hands(new_item)
		return

var/global/list/datum/stack_recipe/rod_recipes = list ( \
	new/datum/stack_recipe("grille", /obj/structure/grille, 4, time = 20, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION_TRAINED), \
	new/datum/stack_recipe("fence", /obj/structure/fence, 10, time = 20, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION_TRAINED), \
)


/obj/item/stack/rods/plasteel
	name = "plasteel rod"
	desc = "Some plasteel rods. Can be used for building sturdier structures and objects."
	singular_name = "plasteel rod"
	icon_state = "rods_plasteel"
	flags_atom = FPRINT
	w_class = SIZE_MEDIUM
	force = 9.0
	throwforce = 15.0
	throw_speed = 0
	throw_range = 20
	matter = list("plasteel" = 3750)
	max_amount = 60
	attack_verb = list("hit", "bludgeoned", "whacked")
	stack_id = "plasteel rod"

/obj/item/stack/rods/plasteel/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/M = W

		if(amount < 5) // Placeholder until we get an elaborate crafting system created
			to_chat(user, SPAN_DANGER("You need at least five plasteel rods to do this."))
			return

		if(M.amount >= 10 && do_after(user, SECONDS_1, INTERRUPT_ALL, BUSY_ICON_BUILD))
			if(!M.use(10))
				return
			var/obj/item/device/m56d_post_frame/PF = new(get_turf(user))
			to_chat(user, SPAN_NOTICE("You create \a [PF]."))
			qdel(src)
		else
			to_chat(user, SPAN_WARNING("You need at least ten metal sheets to do this."))
		return
	..()
