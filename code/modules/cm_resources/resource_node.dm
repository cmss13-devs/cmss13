//Resource node structure
/obj/structure/resource_node
	name = "resource node"
	icon = 'icons/obj/structures/resources.dmi'
	icon_state = "mound0_0"
	anchored = TRUE
	density = FALSE
	unacidable = TRUE
	unslashable = TRUE

	layer = OBJ_LAYER
	flags_can_pass_all = PASS_THROUGH|PASS_HIGH_OVER_ONLY

	// Used by spawner landmarks to determine resource group
	var/node_group

	// How many resources remain in this node
	var/amount_left = 0

	// How many resources per gather for collectors
	var/collect_amount = 1

/obj/structure/resource_node/Initialize()
	. = ..()
	update_icon()

// Sets the amount of resources this node has
/obj/structure/resource_node/proc/activate(var/amount)
	amount_left = amount


/obj/structure/resource_node/proc/gather_resource(var/amount)
	var/amount_to_give = min(amount_left, collect_amount)
	// amount_left -= amount_to_give
	update_icon()
	resource_check()
	return amount_to_give

/obj/structure/resource_node/proc/resource_check(var/amount)
	if(!amount_left)
		qdel(src)
		return FALSE
	return TRUE


// /obj/structure/resource_node/examine(mob/user)
// 	..()
// 	to_chat(user, "It has [amount_left] resources left.")

/obj/structure/resource_node/ex_act(severity)
	return

/obj/structure/resource_node/attack_alien(mob/living/carbon/Xenomorph/X)
	return

/obj/structure/resource_node/plasma
	name = "plasmagas node"
	desc = "A shimmering chunk of purple crystal. Prized by various living beings, refined plasmagas can be used to build various unique structures."
	luminosity = 2

	// Crystals can only be gathered at full growth level
	var/growth_level = 0
	var/max_growth_level = 2

	// How long it takes for the crystal to grow 1 level
	var/growth_delay = RESOURCE_GROWTH_NORMAL

	// Sprite variant
	var/icon_variant = 0

/obj/structure/resource_node/plasma/Initialize()
	..()
	icon_variant = rand(0,1)

/obj/structure/resource_node/plasma/update_icon()
	..()
	overlays.Cut()
	icon_state = "mound[growth_level]_[icon_variant]"
	var/obj/effect/alien/resin/collector/C = locate() in loc
	if((!C || C.disposed) && growth_level)
		overlays += image(icon, "mound_puff")

/obj/structure/resource_node/plasma/attack_alien(mob/living/carbon/Xenomorph/X)
	if(growth_level < max_growth_level)
		to_chat(X, SPAN_NOTICE("This gas isn't ready to be harvested yet!"))
		return
	..()

// Kick off the growing cycle
/obj/structure/resource_node/plasma/activate(var/amount)
	..()

	// Vary by up to +/- RESOURCE_GROWTH_VARY
	var/growth_delay_variance = (rand(0,1) == 0 ? (-1) : 1) * rand(0,RESOURCE_GROWTH_VARY)
	add_timer(CALLBACK(src, .proc/grow), growth_delay + growth_delay_variance)

/obj/structure/resource_node/plasma/proc/grow()
	growth_level++

	SetLuminosity(growth_level+2)
	update_icon()

	if(growth_level == max_growth_level)
		return

	// Continue growing
	var/growth_delay_variance = (rand(0,1) == 0 ? (-1) : 1) * rand(0,RESOURCE_GROWTH_VARY)
	add_timer(CALLBACK(src, .proc/grow), growth_delay + growth_delay_variance)
