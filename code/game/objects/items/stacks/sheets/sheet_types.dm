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
GLOBAL_LIST_INIT_TYPED(metal_recipes, /datum/stack_recipe, list ( \
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
	new/datum/stack_recipe("large airlock assembly", /obj/structure/airlock_assembly/multi_tile, 5, time = 50, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_ENGI), \
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
	new/datum/stack_recipe("metal baseball bat", /obj/item/weapon/baseballbat/metal, 10, time = 20, on_floor = 1), \
	null, \
))

/obj/item/stack/sheet/metal
	name = "metal sheets"
	desc = "Sheets made out of metal. They have been dubbed Metal Sheets."
	singular_name = "metal sheet"
	icon_state = "sheet-metal"
	item_state = "sheet-metal"
	matter = list("metal" = 3750)
	throwforce = 14
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
	recipes = GLOB.metal_recipes
	return ..()

/*
 * Plasteel
 */
GLOBAL_LIST_INIT_TYPED(plasteel_recipes, /datum/stack_recipe, list ( \
	new/datum/stack_recipe("folding plasteel barricade", /obj/structure/barricade/plasteel, 8, time = 4 SECONDS, one_per_turf = ONE_TYPE_PER_BORDER, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_ENGI, min_time = 2 SECONDS),
	new/datum/stack_recipe("plasteel barricade", /obj/structure/barricade/metal/plasteel, 6, time = 8 SECONDS, one_per_turf = ONE_TYPE_PER_BORDER, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_ENGI, min_time = 2 SECONDS),
	null, \
	new/datum/stack_recipe("reinforced window frame", /obj/structure/window_frame/colony/reinforced, 5, time = 40, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_ENGI),
	null, \
	new/datum/stack_recipe("plasteel rod", /obj/item/stack/rods/plasteel, 1, 1, 30),
	new/datum/stack_recipe("metal crate", /obj/structure/closet/crate, 5, time = 50, one_per_turf = ONE_TYPE_PER_TURF), \
	))

/obj/item/stack/sheet/plasteel
	name = "plasteel sheet"
	singular_name = "plasteel sheet"
	desc = "Plasteel is an expensive, durable material made from combining platinum, steel, and advanced polymers to create a metal that is corrosion-resistant, highly durable, and lightweight. The only reason this isn't used more often is because of how damn costly it is."
	icon_state = "sheet-plasteel"
	item_state = "sheet-plasteel"
	matter = list("metal" = 3750)
	throwforce = 15
	flags_atom = FPRINT|CONDUCT
	amount_sprites = TRUE
	sheettype = "plasteel"
	stack_id = "plasteel"
	ground_offset_x = 4
	ground_offset_y = 5

/obj/item/stack/sheet/plasteel/New(loc, amount=null)
	recipes = GLOB.plasteel_recipes
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
GLOBAL_LIST_INIT_TYPED(wood_recipes, /datum/stack_recipe, list ( \
	new/datum/stack_recipe("pair of wooden sandals", /obj/item/clothing/shoes/sandal, 1), \
	new/datum/stack_recipe("wood floor tile", /obj/item/stack/tile/wood, 1, 4, 20), \
	/*
	new/datum/stack_recipe("table parts", /obj/item/frame/table/wood, 2), \
	 */
	new/datum/stack_recipe("campfire", /obj/structure/prop/brazier/frame/full/campfire, 5, time = 15, one_per_turf = ONE_TYPE_PER_TURF, on_floor = TRUE), \
	new/datum/stack_recipe("wooden chair", /obj/structure/bed/chair/wood/normal, 1, time = 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("wooden barricade", /obj/structure/barricade/wooden, 5, time = 20, one_per_turf = ONE_TYPE_PER_BORDER, on_floor = 1), \
	new/datum/stack_recipe("wooden crate", /obj/structure/closet/coffin/woodencrate, 5, time = 15, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("wooden door", /obj/structure/mineral_door/wood, 10, time = 20, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("coffin", /obj/structure/closet/coffin, 5, time = 15, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("baseball bat", /obj/item/weapon/baseballbat, 10, time = 20, on_floor = 1), \
	new/datum/stack_recipe("wooden cross", /obj/structure/prop/wooden_cross, 2, time = 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("wooden pole", /obj/item/weapon/pole, 3, time = 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("fishing pole",/obj/item/fishing_pole, 25, time = 20, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1) \
	))

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

/obj/item/stack/sheet/wood/New(loc, amount=null)
	recipes = GLOB.wood_recipes
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
GLOBAL_LIST_INIT_TYPED(cardboard_recipes, /datum/stack_recipe, list ( \
	new/datum/stack_recipe("box", /obj/item/storage/box), \
	new/datum/stack_recipe("donut box", /obj/item/storage/donut_box/empty), \
	new/datum/stack_recipe("egg box", /obj/item/storage/fancy/egg_box), \
	new/datum/stack_recipe("light tubes", /obj/item/storage/box/lights/tubes), \
	new/datum/stack_recipe("light bulbs", /obj/item/storage/box/lights/bulbs), \
	new/datum/stack_recipe("mouse traps", /obj/item/storage/box/mousetraps), \
	new/datum/stack_recipe("cardborg suit", /obj/item/clothing/suit/cardborg, 3), \
	new/datum/stack_recipe("cardborg helmet", /obj/item/clothing/head/cardborg), \
	new/datum/stack_recipe("pizza box", /obj/item/pizzabox), \
	new/datum/stack_recipe("dartboard", /obj/item/dartboard), \
	null, \
	new/datum/stack_recipe_list("folders",list( \
		new/datum/stack_recipe("blue folder", /obj/item/folder/blue), \
		new/datum/stack_recipe("grey folder", /obj/item/folder), \
		new/datum/stack_recipe("red folder", /obj/item/folder/red), \
		new/datum/stack_recipe("white folder", /obj/item/folder/white), \
		new/datum/stack_recipe("yellow folder", /obj/item/folder/yellow), \
		)), \
	null, \
	new/datum/stack_recipe_list("empty ammo boxes",list( \
		new/datum/stack_recipe("empty magazine box (88 Mod 4 AP)", /obj/item/ammo_box/magazine/mod88/empty), \
		new/datum/stack_recipe("empty magazine box (SU-6)", /obj/item/ammo_box/magazine/su6/empty), \
		new/datum/stack_recipe("empty magazine box (VP78)", /obj/item/ammo_box/magazine/vp78/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (M4A3)", /obj/item/ammo_box/magazine/m4a3/empty), \
		new/datum/stack_recipe("empty magazine box (M4A3 AP)", /obj/item/ammo_box/magazine/m4a3/ap/empty), \
		new/datum/stack_recipe("empty magazine box (M4A3 HP)", /obj/item/ammo_box/magazine/m4a3/hp/empty), \
		new/datum/stack_recipe("empty magazine box (M4A3 Incen)", /obj/item/ammo_box/magazine/m4a3/incen/empty), \
		null, \
		new/datum/stack_recipe("empty speed loader box (M44)", /obj/item/ammo_box/magazine/m44/empty), \
		new/datum/stack_recipe("empty speed loader box (M44 Heavy)", /obj/item/ammo_box/magazine/m44/heavy/empty), \
		new/datum/stack_recipe("empty speed loader box (M44 Marksman)", /obj/item/ammo_box/magazine/m44/marksman/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (M39)", /obj/item/ammo_box/magazine/m39/empty), \
		new/datum/stack_recipe("empty magazine box (M39 AP)", /obj/item/ammo_box/magazine/m39/ap/empty), \
		new/datum/stack_recipe("empty magazine box (M39 Ext)", /obj/item/ammo_box/magazine/m39/ext/empty), \
		new/datum/stack_recipe("empty magazine box (M39 Incen)", /obj/item/ammo_box/magazine/m39/incen/empty), \
		new/datum/stack_recipe("empty magazine box (M39 LE)", /obj/item/ammo_box/magazine/m39/le/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (L42A)", /obj/item/ammo_box/magazine/l42a/empty), \
		new/datum/stack_recipe("empty magazine box (L42A AP)", /obj/item/ammo_box/magazine/l42a/ap/empty), \
		new/datum/stack_recipe("empty magazine box (L42A Ext)", /obj/item/ammo_box/magazine/l42a/ext/empty), \
		new/datum/stack_recipe("empty magazine box (L42A Incen)", /obj/item/ammo_box/magazine/l42a/incen/empty), \
		new/datum/stack_recipe("empty magazine box (L42A LE)", /obj/item/ammo_box/magazine/l42a/le/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (M4RA)", /obj/item/ammo_box/magazine/m4ra/empty), \
		new/datum/stack_recipe("empty magazine box (M4RA AP)", /obj/item/ammo_box/magazine/m4ra/ap/empty), \
		new/datum/stack_recipe("empty magazine box (M4RA Incen)", /obj/item/ammo_box/magazine/m4ra/incen/empty), \
		new/datum/stack_recipe("empty magazine box (M4RA Ext)", /obj/item/ammo_box/magazine/m4ra/ext/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (M41A)", /obj/item/ammo_box/magazine/empty), \
		new/datum/stack_recipe("empty magazine box (M41A AP)", /obj/item/ammo_box/magazine/ap/empty), \
		new/datum/stack_recipe("empty magazine box (M41A Explosive)", /obj/item/ammo_box/magazine/explosive/empty), \
		new/datum/stack_recipe("empty magazine box (M41A Ext)", /obj/item/ammo_box/magazine/ext/empty), \
		new/datum/stack_recipe("empty magazine box (M41A Incen)", /obj/item/ammo_box/magazine/incen/empty), \
		new/datum/stack_recipe("empty magazine box (M41A LE)", /obj/item/ammo_box/magazine/le/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (XM51)", /obj/item/ammo_box/magazine/xm51/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (M41A MK1)", /obj/item/ammo_box/magazine/mk1/empty), \
		new/datum/stack_recipe("empty magazine box (M41A MK1 AP)", /obj/item/ammo_box/magazine/mk1/ap/empty), \
		null, \
		new/datum/stack_recipe("empty drum box (M56B)", /obj/item/ammo_box/magazine/m56b/empty), \
		new/datum/stack_recipe("empty drum box (M56B Irradiated)", /obj/item/ammo_box/magazine/m56b/dirty/empty), \
		new/datum/stack_recipe("empty drum box (M56D)", /obj/item/ammo_box/magazine/m56d/empty), \
		null, \
		new/datum/stack_recipe("empty drum box (M2C)", /obj/item/ammo_box/magazine/m2c/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (M41AE2)", /obj/item/ammo_box/magazine/m41ae2/empty), \
		new/datum/stack_recipe("empty magazine box (M41AE2 Holo-Target)", /obj/item/ammo_box/magazine/m41ae2/holo/empty), \
		new/datum/stack_recipe("empty magazine box (M41AE2 HEAP)", /obj/item/ammo_box/magazine/m41ae2/heap/empty), \
		null, \
		new/datum/stack_recipe("empty flamer tank box (UT-Napthal)", /obj/item/ammo_box/magazine/flamer/empty), \
		new/datum/stack_recipe("empty flamer tank box (Napalm B-Gel)", /obj/item/ammo_box/magazine/flamer/bgel/empty), \
		null, \
		new/datum/stack_recipe("empty shotgun shell box (Beanbag)", /obj/item/ammo_box/magazine/shotgun/beanbag/empty), \
		new/datum/stack_recipe("empty shotgun shell box (Buckshot)", /obj/item/ammo_box/magazine/shotgun/buckshot/empty), \
		new/datum/stack_recipe("empty shotgun shell box (Flechette)", /obj/item/ammo_box/magazine/shotgun/flechette/empty), \
		new/datum/stack_recipe("empty shotgun shell box (Incendiary)", /obj/item/ammo_box/magazine/shotgun/incendiary/empty), \
		new/datum/stack_recipe("empty shotgun shell box (Incendiary Buckshot)", /obj/item/ammo_box/magazine/shotgun/incendiarybuck/empty), \
		new/datum/stack_recipe("empty shotgun shell box (Slugs)", /obj/item/ammo_box/magazine/shotgun/empty), \
		new/datum/stack_recipe("empty shotgun shell box (16g) (Breaching)", /obj/item/ammo_box/magazine/shotgun/light/breaching/empty), \
		null, \
		new/datum/stack_recipe("empty 45-70 bullets box", /obj/item/ammo_box/magazine/lever_action/empty), \
		new/datum/stack_recipe("empty 45-70 bullets box (Blanks)", /obj/item/ammo_box/magazine/lever_action/training/empty), \
		new/datum/stack_recipe("empty 45-70 bullets box (Trackers)", /obj/item/ammo_box/magazine/lever_action/tracker/empty), \
		new/datum/stack_recipe("empty 45-70 bullets box (Marksman)", /obj/item/ammo_box/magazine/lever_action/marksman/empty), \
		null, \
		new/datum/stack_recipe("empty .458 bullets box", /obj/item/ammo_box/magazine/lever_action/xm88/empty), \
		null, \
		new/datum/stack_recipe("empty smg ammo box (10x20mm)", /obj/item/ammo_box/rounds/smg/empty), \
		new/datum/stack_recipe("empty smg ammo box (10x20mm AP)", /obj/item/ammo_box/rounds/smg/ap/empty), \
		new/datum/stack_recipe("empty smg ammo box (10x20mm Incen)", /obj/item/ammo_box/rounds/smg/incen/empty), \
		new/datum/stack_recipe("empty smg ammo box (10x20mm LE)", /obj/item/ammo_box/rounds/smg/le/empty), \
		null, \
		new/datum/stack_recipe("empty rifle ammo box (10x24mm)", /obj/item/ammo_box/rounds/empty), \
		new/datum/stack_recipe("empty rifle ammo box (10x24mm AP)", /obj/item/ammo_box/rounds/ap/empty), \
		new/datum/stack_recipe("empty rifle ammo box (10x24mm Incen)", /obj/item/ammo_box/rounds/incen/empty), \
		new/datum/stack_recipe("empty rifle ammo box (10x24mm LE)", /obj/item/ammo_box/rounds/le/empty), \
		null, \
		new/datum/stack_recipe("empty rifle ammo box (9mm)", /obj/item/ammo_box/rounds/pistol/empty), \
		new/datum/stack_recipe("empty rifle ammo box (9mm AP)", /obj/item/ammo_box/rounds/pistol/ap/empty), \
		new/datum/stack_recipe("empty rifle ammo box (9mm HP)", /obj/item/ammo_box/rounds/pistol/hp/empty), \
		new/datum/stack_recipe("empty rifle ammo box (9mm Incen)", /obj/item/ammo_box/rounds/pistol/incen/empty), \
		null, \
		new/datum/stack_recipe("empty box of MREs", /obj/item/ammo_box/magazine/misc/mre/empty), \
		new/datum/stack_recipe("empty box of M94 Marking Flare Packs", /obj/item/ammo_box/magazine/misc/flares/empty), \
		new/datum/stack_recipe("empty box of M89 Signal Flare Packs", /obj/item/ammo_box/magazine/misc/flares/signal/empty), \
		new/datum/stack_recipe("empty box of flashlights", /obj/item/ammo_box/magazine/misc/flashlight/empty), \
		new/datum/stack_recipe("empty box of combat flashlights", /obj/item/ammo_box/magazine/misc/flashlight/combat/empty), \
		new/datum/stack_recipe("empty box of High-Capacity Power Cells", /obj/item/ammo_box/magazine/misc/power_cell/empty), \
		null, \
		new/datum/stack_recipe("empty box of UPP rations", /obj/item/ammo_box/magazine/misc/mre/upp/empty), \
		new/datum/stack_recipe("empty box of WY rations", /obj/item/ammo_box/magazine/misc/mre/wy/empty), \
		new/datum/stack_recipe("empty box of WY emergency food packs", /obj/item/ammo_box/magazine/misc/mre/wy/empty), \
		new/datum/stack_recipe("empty box of PMC rations", /obj/item/ammo_box/magazine/misc/mre/pmc/empty), \
		new/datum/stack_recipe("empty box of FSR rations", /obj/item/ammo_box/magazine/misc/mre/fsr/empty), \
		new/datum/stack_recipe("empty box of TWE rations", /obj/item/ammo_box/magazine/misc/mre/twe/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (Desert Eagle)", /obj/item/ammo_box/magazine/deagle/empty), \
		new/datum/stack_recipe("empty magazine box (Desert Eagle Heavy)", /obj/item/ammo_box/magazine/deagle/super/empty), \
		new/datum/stack_recipe("empty magazine box (Desert Eagle High-Impact)", /obj/item/ammo_box/magazine/deagle/super/highimpact/empty), \
		new/datum/stack_recipe("empty magazine box (Desert Eagle AP)", /obj/item/ammo_box/magazine/deagle/super/highimpact/ap/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (Spearhead HP)", /obj/item/ammo_box/magazine/spearhead/empty), \
		new/datum/stack_recipe("empty magazine box (Spearhead)", /obj/item/ammo_box/magazine/spearhead/normalpoint/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (M16)", /obj/item/ammo_box/magazine/M16/empty), \
		new/datum/stack_recipe("empty magazine box (M16 AP)", /obj/item/ammo_box/magazine/M16/ap/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (AR10)", /obj/item/ammo_box/magazine/ar10/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (MP5)", /obj/item/ammo_box/magazine/mp5/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (MAR30)", /obj/item/ammo_box/magazine/mar30/empty), \
		new/datum/stack_recipe("empty magazine box (MAR30 EX)", /obj/item/ammo_box/magazine/mar30/ext/empty), \
		new/datum/stack_recipe("empty magazine box (MAR50)", /obj/item/ammo_box/magazine/mar50/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (UZI)", /obj/item/ammo_box/magazine/uzi/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (MAC-15)", /obj/item/ammo_box/magazine/mac15/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (MP27)", /obj/item/ammo_box/magazine/mp27/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (M1911)", /obj/item/ammo_box/magazine/m1911/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (MK-45)", /obj/item/ammo_box/magazine/mk45/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (KT-42)", /obj/item/ammo_box/magazine/kt42/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (Beretta 92FS)", /obj/item/ammo_box/magazine/b92fs/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (FN FP9000)", /obj/item/ammo_box/magazine/fp9000/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (FN P90)", /obj/item/ammo_box/magazine/p90/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (Type19)", /obj/item/ammo_box/magazine/type19/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (ZhNK-72)", /obj/item/ammo_box/magazine/zhnk/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (Type64 Bizon)", /obj/item/ammo_box/magazine/type64/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (S&W .38)", /obj/item/ammo_box/magazine/snw/empty), \
		null, \
		new/datum/stack_recipe("empty Type 23 shotgun shell box (8g Beanbag)", /obj/item/ammo_box/magazine/shotgun/upp/beanbag/empty), \
		new/datum/stack_recipe("empty Type 23 shotgun shell box (8g Buckshot)", /obj/item/ammo_box/magazine/shotgun/upp/buckshot/empty), \
		new/datum/stack_recipe("empty Type 23 shotgun shell box (8g Flechette)", /obj/item/ammo_box/magazine/shotgun/upp/flechette/empty), \
		new/datum/stack_recipe("empty Type 23 shotgun shell box (8g Incendiary)", /obj/item/ammo_box/magazine/shotgun/upp/incendiary/empty), \
		new/datum/stack_recipe("empty Type 23 shotgun shell box (8g Slugs)", /obj/item/ammo_box/magazine/shotgun/upp/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (NSG 23)", /obj/item/ammo_box/magazine/nsg23/empty), \
		new/datum/stack_recipe("empty magazine box (NSG 23 AP)", /obj/item/ammo_box/magazine/nsg23/ap/empty), \
		new/datum/stack_recipe("empty magazine box (NSG 23 EX)", /obj/item/ammo_box/magazine/nsg23/ex/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (Type71)", /obj/item/ammo_box/magazine/type71/empty), \
		new/datum/stack_recipe("empty magazine box (Type71 AP)", /obj/item/ammo_box/magazine/type71/ap/empty), \
		null, \
		new/datum/stack_recipe("empty magazine box (Type73)", /obj/item/ammo_box/magazine/type73/empty), \
		new/datum/stack_recipe("empty magazine box (Type73 High-Impact)", /obj/item/ammo_box/magazine/type73/impact/empty), \
		null, \
		new/datum/stack_recipe("empty rifle ammo box (5.45x39mm)", /obj/item/ammo_box/rounds/type71/empty), \
		new/datum/stack_recipe("empty rifle ammo box (5.45x39mm AP)", /obj/item/ammo_box/rounds/type71/ap/empty), \


		)) \
))

/obj/item/stack/sheet/cardboard //BubbleWrap
	name = "cardboard"
	desc = "Large sheets of card, like boxes folded flat."
	singular_name = "cardboard sheet"
	icon_state = "sheet-card"
	sheettype = "cardboard"
	stack_id = "cardboard"

/obj/item/stack/sheet/cardboard/New(loc, amount=null)
	recipes = GLOB.cardboard_recipes
	return ..()

/obj/item/stack/sheet/cardboard/small_stack
	amount = STACK_10

/obj/item/stack/sheet/cardboard/medium_stack
	amount = STACK_30

/obj/item/stack/sheet/cardboard/full_stack
	amount = STACK_50

/*
 * Aluminum
 */
GLOBAL_LIST_INIT_TYPED(aluminium_recipes, /datum/stack_recipe, list ( \
	new/datum/stack_recipe("flask", /obj/item/reagent_container/food/drinks/flask, 1)
	))

/obj/item/stack/sheet/aluminum
	name = "aluminum"
	desc = "A silvery-white soft metal of the boron group. Because of its low density it is often uses as a structural material in aircrafts."
	singular_name = "aluminum sheet"
	icon_state = "sheet-aluminum"
	sheettype = "aluminum"
	black_market_value = 10

/*
 * Copper
 */
GLOBAL_LIST_INIT_TYPED(copper_recipes, /datum/stack_recipe, list ( \
	new/datum/stack_recipe("cable coil", /obj/item/stack/cable_coil, 2, 1, 20, time = 10, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED)
	))

/obj/item/stack/sheet/copper
	name = "copper"
	desc = "A soft and malleable red metal with high thermal and electrical conductivity."
	singular_name = "copper sheet"
	icon_state = "sheet-copper"
	sheettype = "copper"
	black_market_value = 10

