/*
Mineral Sheets
	Contains:
		- Sandstone
		- Runed Sandstone
		- Diamond
		- Uranium
		- Phoron
		- Gold
		- Silver
		- Enriched Uranium
		- Platinum
		- Metallic Hydrogen
		- Tritium
		- Osmium
*/

GLOBAL_LIST_INIT(sandstone_recipes, list ( \
	new/datum/stack_recipe("pile of dirt", /obj/structure/machinery/portable_atmospherics/hydroponics/soil, 3, time = 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("sandstone door", /obj/structure/mineral_door/sandstone, 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("sandstone wall", /turf/closed/wall/mineral/sandstone, 5, time = 50, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_ENGI, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("sandstone floor", /turf/open/floor/sandstone/runed, 1, on_floor = 1), \
	new/datum/stack_recipe("sandstone handrail (crenellations)", /obj/structure/barricade/handrail/sandstone, 2, time = 2 SECONDS, one_per_turf = ONE_TYPE_PER_BORDER, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED, min_time = 1 SECONDS), \
	new/datum/stack_recipe("sandstone handrail (flat)", /obj/structure/barricade/handrail/sandstone/b, 2, time = 2 SECONDS, one_per_turf = ONE_TYPE_PER_BORDER, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED, min_time = 1 SECONDS), \
	new/datum/stack_recipe("dark sandstone handrail (cren.)", /obj/structure/barricade/handrail/sandstone/dark, 2, time = 2 SECONDS, one_per_turf = ONE_TYPE_PER_BORDER, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED, min_time = 1 SECONDS), \
	new/datum/stack_recipe("dark sandstone handrail (flat)", /obj/structure/barricade/handrail/sandstone/b/dark, 2, time = 2 SECONDS, one_per_turf = ONE_TYPE_PER_BORDER, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED, min_time = 1 SECONDS),
	))

GLOBAL_LIST_INIT(runedsandstone_recipes, list ( \
	new/datum/stack_recipe("temple door", /obj/structure/machinery/door/airlock/sandstone/runed, 15, time = 10, skill_req = SKILL_ANTAG, skill_lvl = SKILL_ANTAG_HUNTER, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("dark temple door", /obj/structure/machinery/door/airlock/sandstone/runed/dark, 15, time = 10, skill_req = SKILL_ANTAG, skill_lvl = SKILL_ANTAG_HUNTER, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe_list("temple walls",list( \
		new/datum/stack_recipe("temple wall", /turf/closed/wall/mineral/sandstone/runed, 5, time = 50, skill_req = SKILL_ANTAG, skill_lvl = SKILL_ANTAG_HUNTER, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		new/datum/stack_recipe("runed temple wall", /turf/closed/wall/mineral/sandstone/runed/decor, 5, time = 50, skill_req = SKILL_ANTAG, skill_lvl = SKILL_ANTAG_HUNTER, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		new/datum/stack_recipe("dark engraved wall", /turf/closed/wall/cult, 5, time = 50, skill_req = SKILL_ANTAG, skill_lvl = SKILL_ANTAG_HUNTER, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		), 5), \
	new/datum/stack_recipe_list("temple floors",list( \
		new/datum/stack_recipe("tan floor", /turf/open/floor/sandstone/runed, 1, on_floor = 1), \
		new/datum/stack_recipe("engraved floor", /turf/open/floor/sandstone/cult, 1, on_floor = 1), \
		new/datum/stack_recipe("dark red floor", /turf/open/floor/sandstone/red, 1, on_floor = 1), \
		new/datum/stack_recipe("sun runed floor", /turf/open/floor/sandstone/red2, 1, on_floor = 1), \
		new/datum/stack_recipe("square runed floor", /turf/open/floor/sandstone/red3, 1, on_floor = 1), \
		), 1), \
	new/datum/stack_recipe("brazier frame", /obj/structure/prop/brazier/frame, 5, time = 5 SECONDS, skill_req = SKILL_ANTAG, skill_lvl = SKILL_ANTAG_HUNTER, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("wall torch frame", /obj/item/prop/torch_frame, 2, time = 2 SECONDS, skill_req = SKILL_ANTAG, skill_lvl = SKILL_ANTAG_HUNTER, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("alien chair", /obj/structure/bed/chair/comfy/yautja, 2, time = 2 SECONDS, skill_req = SKILL_ANTAG, skill_lvl = SKILL_ANTAG_HUNTER, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("alien bed", /obj/structure/bed/alien/yautja, 3, time = 3 SECONDS, skill_req = SKILL_ANTAG, skill_lvl = SKILL_ANTAG_HUNTER, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("tan statue", /obj/structure/showcase/yautja, 10, time = 30, skill_req = SKILL_ANTAG, skill_lvl = SKILL_ANTAG_HUNTER, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("grey statue", /obj/structure/showcase/yautja/alt, 10, time = 30, skill_req = SKILL_ANTAG, skill_lvl = SKILL_ANTAG_HUNTER, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	))

GLOBAL_LIST_INIT(silver_recipes, list ( \
	new/datum/stack_recipe("silver door", /obj/structure/mineral_door/silver, 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("silver beaker", /obj/item/reagent_container/glass/beaker/silver, 3, time = 30, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED), \
	))

GLOBAL_LIST_INIT(diamond_recipes, list ( \
	new/datum/stack_recipe("diamond door", /obj/structure/mineral_door/transparent/diamond, 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	))

GLOBAL_LIST_INIT(uranium_recipes, list ( \
	new/datum/stack_recipe("uranium door", /obj/structure/mineral_door/uranium, 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	))

GLOBAL_LIST_INIT(gold_recipes, list ( \
	new/datum/stack_recipe("golden door", /obj/structure/mineral_door/gold, 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	))

GLOBAL_LIST_INIT(phoron_recipes, list ( \
	new/datum/stack_recipe("phoron door", /obj/structure/mineral_door/transparent/phoron, 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	))

GLOBAL_LIST_INIT(plastic_recipes, list ( \
	new/datum/stack_recipe("plastic crate", /obj/structure/closet/crate/plastic, 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("plastic ashtray", /obj/item/ashtray/plastic, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("plastic fork", /obj/item/tool/kitchen/utensil/pfork, 1, on_floor = 1), \
	new/datum/stack_recipe("plastic spoon", /obj/item/tool/kitchen/utensil/pspoon, 1, on_floor = 1), \
	new/datum/stack_recipe("plastic knife", /obj/item/tool/kitchen/utensil/pknife, 1, on_floor = 1), \
	))

GLOBAL_LIST_INIT(iron_recipes, list ( \
	new/datum/stack_recipe("iron door", /obj/structure/mineral_door/iron, 20, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	null, \
))

/obj/item/stack/sheet/mineral
	force = 5
	throwforce = 5
	w_class = SIZE_MEDIUM
	throw_speed = SPEED_VERY_FAST
	throw_range = 3
	black_market_value = 5

/obj/item/stack/sheet/mineral/Initialize()
	. = ..()
	pixel_x = rand(0,4)-4
	pixel_y = rand(0,4)-4

/obj/item/stack/sheet/mineral/iron
	name = "iron"
	desc = "Iron is a transition metal and the most basic building material in space. It is solid at room temperature, easy to shape, and available in immense quantities."
	singular_name = "iron sheet"
	icon_state = "sheet-silver"

	sheettype = "iron"
	color = "#333333"
	perunit = 3750
	stack_id = "iron"

/obj/item/stack/sheet/mineral/iron/Initialize()
	. = ..()
	recipes = GLOB.iron_recipes

/obj/item/stack/sheet/mineral/sandstone
	name = "sandstone brick"
	desc = "Sandstone is sand cemented into stone. A common building material for primitive civilizations, but it can still make a good enough wall."
	singular_name = "sandstone brick"
	icon_state = "sheet-sandstone"
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	amount_sprites = TRUE
	sheettype = "sandstone"
	stack_id = "sandstone"

/obj/item/stack/sheet/mineral/sandstone/Initialize()
	. = ..()
	recipes = GLOB.sandstone_recipes

/obj/item/stack/sheet/mineral/sandstone/large_stack
	amount = STACK_50

/obj/item/stack/sheet/mineral/sandstone/runed
	name = "runed sandstone brick"
	desc = "Sandstone is sand cemented into stone. A common building material for primitive civilizations, but it can still make a good enough wall. This one has strange runes embued into the brick."
	singular_name = "runed sandstone brick"
	icon_state = "sheet-runedsandstone"
	amount_sprites = FALSE
	black_market_value = 15

/obj/item/stack/sheet/mineral/sandstone/runed/large_stack
	amount = STACK_50

/obj/item/stack/sheet/mineral/sandstone/runed/Initialize()
	. = ..()
	recipes = GLOB.runedsandstone_recipes

/obj/item/stack/sheet/mineral/sandstone/runed/attack_self(mob/user)
	..()

	if(isyautja(user))
		list_recipes(user)

/obj/item/stack/sheet/mineral/diamond
	name = "diamond"
	desc = "Diamond is highly-pressurized and heated carbon in a diamond cubic crystal lattice. It is highly-valued for its look and hardness, despite being artifically-manufactured, these days."
	singular_name = "diamond gem"
	icon_state = "sheet-diamond"

	perunit = 3750
	sheettype = "diamond"
	stack_id = "diamond"
	black_market_value = 30


/obj/item/stack/sheet/mineral/diamond/Initialize()
	. = ..()
	recipes = GLOB.diamond_recipes

/obj/item/stack/sheet/mineral/uranium
	name = "uranium"
	desc = "Uranium is a radioactive metal of the actinide series. Valued as reactor fuel for fission-type generators, and as a primer for fusion bombs."
	singular_name = "uranium rod"
	icon_state = "sheet-uranium"

	perunit = 2000
	sheettype = "uranium"
	stack_id = "uranium"
	black_market_value = 30

/obj/item/stack/sheet/mineral/uranium/Initialize()
	. = ..()
	recipes = GLOB.uranium_recipes

/obj/item/stack/sheet/mineral/uranium/small_stack
	amount = STACK_10

/obj/item/stack/sheet/mineral/phoron
	name = "solid phoron"
	desc = "Phoron is an extremely rare mineral with exotic properties, often used in cutting-edge research. Just getting it into a stable, solid form is already difficult enough, considering it can be quite toxic and flammable."
	singular_name = "phoron ingot"
	icon_state = "sheet-phoron"

	perunit = 2000
	sheettype = "phoron"
	stack_id = "phoron"
	black_market_value = 10

/obj/item/stack/sheet/mineral/phoron/small_stack
	amount = STACK_10

/obj/item/stack/sheet/mineral/phoron/medium_stack
	amount = STACK_30

/obj/item/stack/sheet/mineral/plastic
	name = "Plastic"
	desc = "Plastic is a synthetic polymer, manufactured from organic and inorganic components into a malleable and light fabric. It can be used for a wide range of objects."
	singular_name = "plastic sheet"
	icon_state = "sheet-plastic"
	item_state = "sheet-plastic"
	matter = list("plastic" = 2000)
	amount_sprites = TRUE
	perunit = 2000
	stack_id = "plastic"
	black_market_value = 0

/obj/item/stack/sheet/mineral/plastic/Initialize()
	. = ..()
	recipes = GLOB.plastic_recipes

/obj/item/stack/sheet/mineral/plastic/small_stack
	amount = STACK_10

/obj/item/stack/sheet/mineral/plastic/cyborg
	name = "plastic sheets"
	desc = "Plastic is a synthetic polymer, manufactured from organic and inorganic components into a malleable and light fabric. It can be used for a wide range of objects."
	singular_name = "plastic sheet"
	icon_state = "sheet-plastic"
	item_state = "sheet-plastic"
	perunit = 2000

/obj/item/stack/sheet/mineral/gold
	name = "gold"
	desc = "Gold is a transition metal. A relatively rare metal, known for its color, shine, chemical and electrical properties, it is sought after for both cosmetic, engineering and scientific uses."
	singular_name = "gold ingot"
	icon_state = "sheet-gold"

	perunit = 2000
	sheettype = "gold"
	stack_id = "gold"
	black_market_value = 30

/obj/item/stack/sheet/mineral/gold/Initialize()
	. = ..()
	recipes = GLOB.gold_recipes

/obj/item/stack/sheet/mineral/gold/small_stack
	amount = STACK_5

/obj/item/stack/sheet/mineral/silver
	name = "silver"
	desc = "Silver is a transition metal. It is known for its namesake silver, gray color. It is used both for cosmetics as a cheaper alternative to gold, or for engineering for its unparalleled electrical and thermal conductivity and reflectivity."
	singular_name = "silver ingot"
	icon_state = "sheet-silver"

	perunit = 2000
	sheettype = "silver"
	stack_id = "silver"
	black_market_value = 25

/obj/item/stack/sheet/mineral/silver/Initialize()
	. = ..()
	recipes = GLOB.silver_recipes

/obj/item/stack/sheet/mineral/silver/small_stack
	amount = STACK_10

/obj/item/stack/sheet/mineral/enruranium
	name = "enriched uranium"
	desc = "Enriched uranium rods are made out of around 3 to 5 percent of U-235 mixed with regular U-238. While nowhere near weapons-grade, it is good enough to be used in a fission engine."
	singular_name = "enriched uranium rod"
	icon_state = "sheet-enruranium"

	perunit = 1000
	stack_id = "enuranium"

//Valuable resource, cargo can now actually sell it.
/obj/item/stack/sheet/mineral/platinum
	name = "platinum"
	desc = "Platinum is a transition metal. Relatively rare and pretty, it is used for its cosmetic value and chemical properties as a catalytic agent. It is also used in electrodes."
	singular_name = "platinum ingot"
	icon_state = "sheet-platinum"

	sheettype = "platinum"
	perunit = 2000
	stack_id = "platinum"
	black_market_value = 35


/obj/item/stack/sheet/mineral/lead
	name = "lead"
	desc = "Lead is a heavy metal. It is quite dense, yet soft and malleable in its solid state. Though toxic if consumed, lead sheets are used as a shielding material in walls to protect from radiation, and also to absorb sound and vibrations."
	singular_name = "lead brick"
	icon_state = "sheet-lead"

	sheettype = "lead"
	perunit = 2000
	stack_id = "lead"
	black_market_value = 35

//Extremely valuable to Research.
/obj/item/stack/sheet/mineral/mhydrogen
	name = "metallic hydrogen"
	desc = "Metallic hydrogen is regular hydrogen in a near-solid state, turned into an ingot under immense pressures. The exact procedure to create and stabilize such ingots is still a trade secret."
	singular_name = "hydrogen ingot"
	icon_state = "sheet-mythril"

	sheettype = "mhydrogen"
	perunit = 2000
	stack_id = "mhydrogen"

//Fuel for MRSPACMAN generator.
/obj/item/stack/sheet/mineral/tritium
	name = "tritium"
	desc = "Tritium is an isotope of hydrogen, H-3, turned into an ingot under immense pressures. The exact procedure to create and stabilize such ingots is still a trade secret."
	singular_name = "tritium ingot"
	icon_state = "sheet-silver"
	sheettype = "tritium"

	color = "#777777"
	perunit = 2000
	stack_id = "tritium"
	black_market_value = 35

/obj/item/stack/sheet/mineral/osmium
	name = "osmium"
	desc = "Osmium is a transition metal. The densest naturally occurring element known to man, it is obviously known for its extreme hardness and durability and used as such."
	singular_name = "osmium ingot"
	icon_state = "sheet-silver"
	sheettype = "osmium"

	color = "#9999FF"
	perunit = 2000
	stack_id = "osmium"
	black_market_value = 35

/obj/item/stack/sheet/mineral/chitin
	name = "chitin"
	desc = "Chitin is the building block of an arthropod--such as an insect or crustracean's--exoskeleton. This sheet, in particular, came from aliens."
	singular_name = "chitin brick"
	icon_state = "sheet-chitin"

	sheettype = "chitin"
	perunit = 2000
	stack_id = "chitin"
	black_market_value = 35
