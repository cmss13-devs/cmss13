//Seed packet object/procs.
/obj/item/seeds
	name = "packet of seeds"
	icon = 'icons/obj/items/seeds.dmi'
	icon_state = "seed"
	flags_atom = NO_FLAGS
	w_class = SIZE_TINY

	var/seed_type
	var/datum/seed/seed
	var/modified = 0

/obj/item/seeds/Initialize()
	. = ..()
	GLOB.seed_list += src
	update_seed()

/obj/item/seeds/Destroy()
	seed = null
	GLOB.seed_list -= src
	return ..()

//Grabs the appropriate seed datum from the global list.
/obj/item/seeds/proc/update_seed()
	if(!seed && seed_type && !isnull(seed_types) && seed_types[seed_type])
		seed = seed_types[seed_type]
	update_appearance()

//Updates strings and icon appropriately based on seed datum.
/obj/item/seeds/proc/update_appearance()
	if(!seed) return
	icon_state = seed.packet_icon
	src.name = "packet of [seed.seed_name] [seed.seed_noun]"
	src.desc = "It has a picture of [seed.display_name] on the front."

/obj/item/seeds/examine(mob/user)
	..()
	if(seed && !seed.roundstart)
		to_chat(user, "It's tagged as variety #[seed.uid].")

/obj/item/seeds/cutting
	name = "cuttings"
	desc = "Some plant cuttings."

/obj/item/seeds/cutting/update_appearance()
	..()
	src.name = "packet of [seed.seed_name] cuttings"
/*
/obj/item/seeds/random
	seed_type = null

/obj/item/seeds/random/New()
	seed = new()
	seed.randomize()

	seed.uid = seed_types.len + 1
	seed.name = "[seed.uid]"
	seed_types[seed.name] = seed

	update_seed()
*/
/obj/item/seeds/poppyseed
	seed_type = "poppies"
	name = "pack of poppie seeds"

/obj/item/seeds/chiliseed
	seed_type = "chili"
	name = "pack of chili seeds"

/obj/item/seeds/plastiseed
	seed_type = "plastic"
	name = "pack of plastic seeds"

/obj/item/seeds/grapeseed
	seed_type = "grapes"
	name = "pack of grape seeds"

/obj/item/seeds/greengrapeseed
	seed_type = "greengrapes"
	name = "pack of greengrape seeds"

/obj/item/seeds/peanutseed
	seed_type = "peanut"
	name = "pack of peanut seeds"

/obj/item/seeds/cabbageseed
	seed_type = "cabbage"
	name = "pack of cabbageseeds"

/obj/item/seeds/shandseed
	seed_type = "shand"
	name = "pack of shand seeds"

/obj/item/seeds/mtearseed
	seed_type = "mtear"
	name = "pack of Messa's tear seeds"

/obj/item/seeds/berryseed
	seed_type = "berries"
	name = "pack of berry seeds"

/obj/item/seeds/glowberryseed
	seed_type = "glowberries"
	name = "pack of glowberrie seeds"

/obj/item/seeds/bananaseed
	seed_type = "banana"
	name = "pack of banana seeds"

/obj/item/seeds/eggplantseed
	seed_type = "eggplant"
	name = "pack of eggplant seeds"

/obj/item/seeds/eggyseed
	seed_type = "realeggplant"
	name = "pack of real eggplant seeds"

/obj/item/seeds/bloodtomatoseed
	seed_type = "bloodtomato"
	name = "pack of blood tomato seeds"

/obj/item/seeds/tomatoseed
	seed_type = "tomato"
	name = "pack of tomato seeds"

/obj/item/seeds/killertomatoseed
	seed_type = "killertomato"
	name = "pack of killer tomato seeds"

/obj/item/seeds/bluetomatoseed
	seed_type = "bluetomato"
	name = "pack of blue tomato seeds"

/obj/item/seeds/bluespacetomatoseed
	seed_type = "bluespacetomato"
	name = "pack of bluespace tomato seeds"

/obj/item/seeds/cornseed
	seed_type = "corn"
	name = "pack of corn seeds"

/obj/item/seeds/poppyseed
	seed_type = "poppies"
	name = "pack of poppie seeds"

/obj/item/seeds/potatoseed
	seed_type = "potato"
	name = "pack of potato seeds"

/obj/item/seeds/icepepperseed
	seed_type = "icechili"
	name = "pack of ice chili seeds"

/obj/item/seeds/soyaseed
	seed_type = "soybean"
	name = "pack of soybean seeds"

/obj/item/seeds/wheatseed
	seed_type = "wheat"
	name = "pack of wheat seeds"

/obj/item/seeds/riceseed
	seed_type = "rice"
	name = "pack of rice seeds"

/obj/item/seeds/carrotseed
	seed_type = "carrot"
	name = "pack of carrot seeds"

/obj/item/seeds/reishimycelium
	seed_type = "reishi"
	name = "pack of reishi spores"

/obj/item/seeds/amanitamycelium
	seed_type = "amanita"
	name = "pack of amanita spores"

/obj/item/seeds/angelmycelium
	seed_type = "destroyingangel"
	name = "pack of destroying angel spores"

/obj/item/seeds/libertymycelium
	seed_type = "libertycap"
	name = "pack of liberty cap spores"

/obj/item/seeds/chantermycelium
	seed_type = "mushrooms"
	name = "pack of mushrooms spores"

/obj/item/seeds/towermycelium
	seed_type = "towercap"
	name = "pack of towercap spores"

/obj/item/seeds/glowshroom
	seed_type = "glowshroom"
	name = "pack of glowshroom spores"

/obj/item/seeds/plumpmycelium
	seed_type = "plumphelmet"
	name = "pack of plumphelmet"

/obj/item/seeds/walkingmushroommycelium
	seed_type = "walkingmushroom"
	name = "pack of walking mushroom spores"

/obj/item/seeds/nettleseed
	seed_type = "nettle"
	name = "pack of nettle seeds"

/obj/item/seeds/deathnettleseed
	seed_type = "deathnettle"
	name = "pack of deathnettle seeds"

/obj/item/seeds/weeds
	seed_type = "weeds"
	name = "pack of weed seeds"

/obj/item/seeds/harebell
	seed_type = "harebells"
	name = "pack of harebell seeds"

/obj/item/seeds/sunflowerseed
	seed_type = "sunflowers"
	name = "pack of sunflower seeds"

/obj/item/seeds/brownmold
	seed_type = "mold"
	name = "pack of mold spores"

/obj/item/seeds/appleseed
	seed_type = "apple"
	name = "pack of apple seeds"

/obj/item/seeds/poisonedappleseed
	seed_type = "poisonapple"
	name = "pack of poisonous apple seeds"

/obj/item/seeds/goldappleseed
	seed_type = "goldapple"
	name = "pack of golden apple seeds"

/obj/item/seeds/ambrosiavulgarisseed
	seed_type = "ambrosia"
	name = "pack of ambrosia seeds"

/obj/item/seeds/ambrosiadeusseed
	seed_type = "ambrosiadeus"
	name = "pack of ambrosiadeus seeds"

/obj/item/seeds/whitebeetseed
	seed_type = "whitebeet"
	name = "pack of whitebeet seeds"

/obj/item/seeds/sugarcaneseed
	seed_type = "sugarcane"
	name = "pack of sugarcane seeds"

/obj/item/seeds/watermelonseed
	seed_type = "watermelon"
	name = "pack of watermelon seeds"

/obj/item/seeds/pumpkinseed
	seed_type = "pumpkin"
	name = "pack of pumpkin seeds"

/obj/item/seeds/limeseed
	seed_type = "lime"
	name = "pack of lime seeds"

/obj/item/seeds/lemonseed
	seed_type = "lemon"
	name = "pack of lemon seeds"

/obj/item/seeds/orangeseed
	seed_type = "orange"
	name = "pack of orange seeds"

/obj/item/seeds/poisonberryseed
	seed_type = "poisonberries"
	name = "pack of poisonous berry seeds"

/obj/item/seeds/deathberryseed
	seed_type = "deathberries"
	name = "pack of deathberry seeds"

/obj/item/seeds/grassseed
	seed_type = "grass"
	name = "pack of grass seeds"

/obj/item/seeds/cocoapodseed
	seed_type = "cocoa"
	name = "pack of cocoa seeds"

/obj/item/seeds/cherryseed
	seed_type = "cherry"
	name = "pack of cherry seeds"

/obj/item/seeds/kudzuseed
	seed_type = "kudzu"
	name = "pack of kudzu seeds"
