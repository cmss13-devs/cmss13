/obj/item/stack/rods
	name = "metal rod"
	desc = "Some rods. Can be used for building, or something."
	singular_name = "metal rod"
	icon_state = "rods"
	icon = 'icons/obj/items/stacks.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/material_stacks_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/material_stacks_righthand.dmi',
	)
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_SMALL
	force = 9
	throwforce = 15
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	matter = list("metal" = 1875)
	max_amount = 60
	attack_verb = list("hit", "bludgeoned", "whacked")
	stack_id = "metal rod"
	garbage = TRUE
	var/sheet_path = /obj/item/stack/sheet/metal
	var/used_per_sheet = 4

/obj/item/stack/rods/Initialize(mapload, ...)
	. = ..()
	recipes = GLOB.rod_recipes

/obj/item/stack/rods/attackby(obj/item/W as obj, mob/user as mob)
	if (!iswelder(W))
		return ..()

	if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
		to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
		return

	var/obj/item/tool/weldingtool/WT = W

	if(amount < used_per_sheet)
		to_chat(user, SPAN_DANGER("You need at least [used_per_sheet] rods to do this."))
		return

	if(WT.remove_fuel(0,user))
		var/obj/item/stack/sheet/new_item = new sheet_path(user.loc)
		new_item.add_to_stacks(user)
		for (var/mob/M as anything in viewers(src))
			M.show_message(SPAN_DANGER("[src] is shaped into metal by [user.name] with the weldingtool."), SHOW_MESSAGE_VISIBLE, SPAN_DANGER("You hear welding."), SHOW_MESSAGE_AUDIBLE)
		use(used_per_sheet)

GLOBAL_LIST_INIT(rod_recipes, list (
	new /datum/stack_recipe("grille", /obj/structure/grille, 4, time = 20, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED),
	new /datum/stack_recipe("fence", /obj/structure/fence, 10, time = 20, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED)
	))


/obj/item/stack/rods/plasteel
	name = "plasteel rod"
	desc = "Some plasteel rods. Can be used for building sturdier structures and objects."
	singular_name = "plasteel rod"
	icon_state = "rods_plasteel"
	flags_atom = FPRINT
	matter = list("plasteel" = 3750)
	attack_verb = list("hit", "bludgeoned", "whacked")
	stack_id = "plasteel rod"
	sheet_path = /obj/item/stack/sheet/plasteel
	used_per_sheet = 2

/obj/item/stack/rods/plasteel/Initialize()
	. = ..()
	recipes = null

/obj/item/stack/rods/plasteel/attackby(obj/item/W as obj, mob/user as mob)
	if(!istype(W, /obj/item/stack/sheet/metal))
		return ..()

	var/obj/item/stack/sheet/metal/M = W

	if(amount < 5) // Placeholder until we get an elaborate crafting system created
		to_chat(user, SPAN_DANGER("You need at least five plasteel rods to do this."))
		return

	if(M.amount >= 10 && do_after(user, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
		if(!M.use(10))
			return
		var/obj/item/device/m56d_post_frame/PF = new(get_turf(user))
		to_chat(user, SPAN_NOTICE("You create \a [PF]."))
		var/replace = (user.get_inactive_hand()==src)
		use(5)
		if(QDELETED(src) && replace)
			user.put_in_hands(PF)
	else
		to_chat(user, SPAN_WARNING("You need at least ten metal sheets to do this."))
