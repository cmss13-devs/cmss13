/* Diffrent misc types of sheets
 * Contains:
 * Metal
 * Plasteel
 * Wood
 * Cloth
 * Cardboard
 */

/*
 * Metal
 */
var/global/list/datum/stack_recipe/metal_recipes = list ( \
	new/datum/stack_recipe("barbed wire", /obj/item/stack/barbed_wire, 1, 1, 20, time = 1 SECONDS, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED), \
	new/datum/stack_recipe("metal barricade", /obj/structure/barricade/metal, 4, time = 2 SECONDS, one_per_turf = ONE_TYPE_PER_BORDER, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED, min_time = 1 SECONDS), \
	new/datum/stack_recipe("folding metal barricade", /obj/structure/barricade/plasteel/metal, 6, time = 3 SECONDS, one_per_turf = ONE_TYPE_PER_BORDER, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_ENGI, min_time = 1.5 SECONDS), \
	new/datum/stack_recipe("handrail", /obj/structure/barricade/handrail, 2, time = 2 SECONDS, one_per_turf = ONE_TYPE_PER_BORDER, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED, min_time = 1 SECONDS), \
	null, \
	new/datum/stack_recipe("apc frame", /obj/item/frame/apc, 2), \
	new/datum/stack_recipe("fire alarm frame", /obj/item/frame/fire_alarm, 2), \
	null, \
	new/datum/stack_recipe("light fixture frame", /obj/item/frame/light_fixture, 2), \
	new/datum/stack_recipe("small light fixture frame", /obj/item/frame/light_fixture/small, 1), \
	null, \
	new/datum/stack_recipe("floor tile", /obj/item/stack/tile/plasteel, 1, 4, 20), \
	new/datum/stack_recipe("metal rod", /obj/item/stack/rods, 1, 2, 60), \
	new/datum/stack_recipe("wall girder", /obj/structure/girder, 2, time = 50, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_ENGI), \
	new/datum/stack_recipe("window frame", /obj/structure/window_frame/almayer, 5, time = 50, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_ENGI), \
	new/datum/stack_recipe("airlock assembly", /obj/structure/airlock_assembly, 5, time = 50, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_ENGI), \
	null, \
	new/datum/stack_recipe("bed", /obj/structure/bed, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("chair", /obj/structure/bed/chair, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe_list("comfy chairs", list( \
		new/datum/stack_recipe("beige comfy chair", /obj/structure/bed/chair/comfy/beige, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		new/datum/stack_recipe("black comfy chair", /obj/structure/bed/chair/comfy/black, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		new/datum/stack_recipe("brown comfy chair", /obj/structure/bed/chair/comfy/orange, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		new/datum/stack_recipe("lime comfy chair", /obj/structure/bed/chair/comfy/lime, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		new/datum/stack_recipe("teal comfy chair", /obj/structure/bed/chair/comfy/teal, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		), 2), \
	new/datum/stack_recipe_list("squad chairs", list( \
		new/datum/stack_recipe("alpha squad chair", /obj/structure/bed/chair/comfy/alpha, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		new/datum/stack_recipe("bravo squad chair", /obj/structure/bed/chair/comfy/bravo, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		new/datum/stack_recipe("charlie squad chair", /obj/structure/bed/chair/comfy/charlie, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		new/datum/stack_recipe("delta squad chair", /obj/structure/bed/chair/comfy/delta, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		), 2), \
	new/datum/stack_recipe_list("office chairs",list( \
		new/datum/stack_recipe("dark office chair", /obj/structure/bed/chair/office/dark, 5, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		new/datum/stack_recipe("light office chair", /obj/structure/bed/chair/office/light, 5, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		), 5), \
	new/datum/stack_recipe("stool", /obj/structure/bed/stool, one_per_turf = 1, on_floor = 1), \
	null, \
	new/datum/stack_recipe("computer frame", /obj/structure/computerframe, 5, time = 25, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_MASTER), \
	new/datum/stack_recipe("machine frame", /obj/structure/machinery/constructable_frame, 5, time = 25, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_MASTER), \
	null, \
	new/datum/stack_recipe("metal baseball bat", /obj/item/weapon/melee/baseballbat/metal, 10, time = 20, on_floor = 1), \
	null, \
)

/obj/item/stack/sheet/metal
	name = "metal sheets"
	desc = "Sheets made out of metal. They have been dubbed Metal Sheets."
	singular_name = "metal sheet"
	icon_state = "sheet-metal"
	item_state = "sheet-metal"
	matter = list("metal" = 3750)
	throwforce = 14.0
	flags_atom = FPRINT|CONDUCT
	amount_sprites = TRUE
	sheettype = "metal"
	stack_id = "metal"

/obj/item/stack/sheet/metal/small_stack
	amount = STACK_10

/obj/item/stack/sheet/metal/med_small_stack
	amount = STACK_20

/obj/item/stack/sheet/metal/medium_stack
	amount = STACK_30

/obj/item/stack/sheet/metal/med_large_stack
	amount = STACK_40

/obj/item/stack/sheet/metal/large_stack
	amount = STACK_50

/obj/item/stack/sheet/metal/cyborg

/obj/item/stack/sheet/metal/Initialize(mapload, amount)
	recipes = metal_recipes
	return ..()

/*
 * Plasteel
 */
var/global/list/datum/stack_recipe/plasteel_recipes = list ( \
	new/datum/stack_recipe("plasteel barricade", /obj/structure/barricade/plasteel, 8, time = 4 SECONDS, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_ENGI, min_time = 2 SECONDS),
	null, \
	new/datum/stack_recipe("reinforced window frame", /obj/structure/window_frame/colony/reinforced, 5, time = 40, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_ENGI),
	null, \
	new/datum/stack_recipe("plasteel rod", /obj/item/stack/rods/plasteel, 1, 1, 30),
	new/datum/stack_recipe("metal crate", /obj/structure/closet/crate, 5, time = 50, one_per_turf = ONE_TYPE_PER_TURF), \
	)

/obj/item/stack/sheet/plasteel
	name = "plasteel sheet"
	singular_name = "plasteel sheet"
	desc = "These sheets are an alloy of iron and phoron."
	icon_state = "sheet-plasteel"
	item_state = "sheet-plasteel"
	matter = list("metal" = 3750)
	throwforce = 15.0
	flags_atom = FPRINT|CONDUCT
	amount_sprites = TRUE
	sheettype = "plasteel"
	stack_id = "plasteel"

/obj/item/stack/sheet/plasteel/New(var/loc, var/amount=null)
	recipes = plasteel_recipes
	return ..()


/obj/item/stack/sheet/plasteel/small_stack
	amount = STACK_10

/obj/item/stack/sheet/plasteel/med_small_stack
	amount = STACK_20

/obj/item/stack/sheet/plasteel/medium_stack
	amount = STACK_30

/obj/item/stack/sheet/plasteel/med_large_stack
	amount = STACK_40

/obj/item/stack/sheet/plasteel/large_stack
	amount = STACK_50

/*
 * Wood
 */
var/global/list/datum/stack_recipe/wood_recipes = list ( \
	new/datum/stack_recipe("pair of wooden sandals", /obj/item/clothing/shoes/sandal, 1), \
	new/datum/stack_recipe("wood floor tile", /obj/item/stack/tile/wood, 1, 4, 20), \
	/*
	new/datum/stack_recipe("table parts", /obj/item/frame/table/wood, 2), \
	 */
	new/datum/stack_recipe("wooden chair", /obj/structure/bed/chair/wood/normal, 1, time = 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("wooden barricade", /obj/structure/barricade/wooden, 5, time = 20, one_per_turf = ONE_TYPE_PER_BORDER, on_floor = 1), \
	new/datum/stack_recipe("wooden crate", /obj/structure/closet/coffin/woodencrate, 5, time = 15, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("wooden door", /obj/structure/mineral_door/wood, 10, time = 20, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("coffin", /obj/structure/closet/coffin, 5, time = 15, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("baseball bat", /obj/item/weapon/melee/baseballbat, 10, time = 20, on_floor = 1), \
	new/datum/stack_recipe("wooden cross", /obj/structure/prop/wooden_cross, 2, time = 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1) \
	)

/obj/item/stack/sheet/wood
	name = "wooden plank"
	desc = "One can only guess that this is a bunch of wood."
	singular_name = "wood plank"
	icon_state = "sheet-wood"
	item_state = "sheet-wood"
	sheettype = "wood"
	amount_sprites = TRUE
	stack_id = "wood plank"

/obj/item/stack/sheet/wood/small_stack
	amount = STACK_10

/obj/item/stack/sheet/wood/medium_stack
	amount = STACK_25

/obj/item/stack/sheet/wood/large_stack
	amount = STACK_50

/obj/item/stack/sheet/wood/cyborg
	name = "wooden plank"
	desc = "One can only guess that this is a bunch of wood."
	singular_name = "wood plank"
	icon_state = "sheet-wood"

/obj/item/stack/sheet/wood/New(var/loc, var/amount=null)
	recipes = wood_recipes
	return ..()

/*
 * Cloth
 */
/obj/item/stack/sheet/cloth
	name = "cloth"
	desc = "This roll of cloth is made from only the finest chemicals and bunny rabbits."
	singular_name = "cloth roll"
	icon_state = "sheet-cloth"

	stack_id = "cloth"

/*
 * Cardboard
 */
/proc/generate_cardboard_recipes()
	var/list/datum/stack_recipe/recipes = list ( \
		new/datum/stack_recipe("box", /obj/item/storage/box), \
		new/datum/stack_recipe("donut box", /obj/item/storage/donut_box/empty), \
		new/datum/stack_recipe("egg box", /obj/item/storage/fancy/egg_box), \
		new/datum/stack_recipe("light tubes", /obj/item/storage/box/lights/tubes), \
		new/datum/stack_recipe("light bulbs", /obj/item/storage/box/lights/bulbs), \
		new/datum/stack_recipe("mouse traps", /obj/item/storage/box/mousetraps), \
		new/datum/stack_recipe("cardborg suit", /obj/item/clothing/suit/cardborg, 3), \
		new/datum/stack_recipe("cardborg helmet", /obj/item/clothing/head/cardborg), \
		new/datum/stack_recipe("pizza box", /obj/item/pizzabox), \
		null, \
		new/datum/stack_recipe_list("folders",list( \
			new/datum/stack_recipe("blue folder", /obj/item/folder/blue), \
			new/datum/stack_recipe("grey folder", /obj/item/folder), \
			new/datum/stack_recipe("red folder", /obj/item/folder/red), \
			new/datum/stack_recipe("white folder", /obj/item/folder/white), \
			new/datum/stack_recipe("yellow folder", /obj/item/folder/yellow), \
			)), \
		null, \
	)
	var/list/ammo_box_recipes = list()
	for(var/obj/item/ammo_box/AB as anything in (subtypesof(/obj/item/ammo_box)))
		if(initial(AB.empty))
			ammo_box_recipes += new/datum/stack_recipe(initial(AB.name), AB)

	recipes += new/datum/stack_recipe_list("empty ammo boxes", ammo_box_recipes)
	return recipes

/obj/item/stack/sheet/cardboard	//BubbleWrap
	name = "cardboard"
	desc = "Large sheets of card, like boxes folded flat."
	singular_name = "cardboard sheet"
	icon_state = "sheet-card"
	sheettype = "cardboard"
	stack_id = "cardboard"

/obj/item/stack/sheet/cardboard/New(var/loc, var/amount=null)
	recipes = GLOB.cardboard_recipes
	return ..()

/obj/item/stack/sheet/cardboard/attack_self(mob/user)
	if(!recipes)
		recipes = GLOB.cardboard_recipes
	..()

/obj/item/stack/sheet/cardboard/small_stack
	amount = STACK_10

/obj/item/stack/sheet/cardboard/medium_stack
	amount = STACK_30

/obj/item/stack/sheet/cardboard/full_stack
	amount = STACK_50

/*
 * Aluminum
 */
var/global/list/datum/stack_recipe/aluminum_recipes = list ( \
	new/datum/stack_recipe("flask", /obj/item/reagent_container/food/drinks/flask, 1)
	)

/obj/item/stack/sheet/aluminum
	name = "aluminum"
	desc = "A silvery-white soft metal of the boron group. Because of its low density it is often uses as a structural material in aircrafts."
	singular_name = "aluminum sheet"
	icon_state = "sheet-aluminum"
	sheettype = "aluminum"

/*
 * Copper
 */
var/global/list/datum/stack_recipe/copper_recipes = list ( \
	new/datum/stack_recipe("cable coil", /obj/item/stack/cable_coil, 2, 1, 20, time = 10, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED)
	)

/obj/item/stack/sheet/copper
	name = "copper"
	desc = "A soft and malleable red metal with high thermal and electrical conductivity."
	singular_name = "copper sheet"
	icon_state = "sheet-copper"
	sheettype = "copper"

