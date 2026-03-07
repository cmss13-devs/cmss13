/* Medical Boxes
Y'know medical stuff, and research adjacent stuff
*/


/obj/item/storage/box/gloves
	name = "box of latex gloves"
	desc = "Contains white gloves."
	icon_state = "latex"
	item_state = "latex"
	w_class = SIZE_SMALL
	storage_slots = STORAGE_SLOTS_DEFAULT

/obj/item/storage/box/gloves/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/clothing/gloves/latex(src)

/obj/item/storage/box/bloodbag
	name = "box of blood bags"
	desc = "This box can hold all kinds of blood bags."
	icon_state = "blood"
	item_state = "blood"
	w_class = SIZE_LARGE
	storage_slots = STORAGE_SLOTS_DEFAULT

/obj/item/storage/box/masks
	name = "box of sterile masks"
	desc = "This box contains masks of sterility."
	icon_state = "sterile"
	item_state = "sterile"
	w_class = SIZE_SMALL
	storage_slots = STORAGE_SLOTS_DEFAULT

/obj/item/storage/box/masks/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/clothing/mask/surgical(src)

/obj/item/storage/box/syringes
	name = "box of syringes"
	desc = "A box full of syringes."
	desc = "A biohazard alert warning is printed on the box."
	icon_state = "syringe"
	item_state = "syringe"
	w_class = SIZE_MEDIUM
	storage_slots = STORAGE_SLOTS_DEFAULT

/obj/item/storage/box/syringes/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/reagent_container/syringe(src)

/obj/item/storage/box/beakers
	name = "box of beakers"
	icon_state = "beaker"
	item_state = "beaker"
	w_class = SIZE_LARGE // yeah
	storage_slots = STORAGE_SLOTS_DEFAULT

/obj/item/storage/box/beakers/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/reagent_container/glass/beaker(src)

/obj/item/storage/box/vials
	name = "box of vials"
	icon_state = "vial"
	item_state = "vial"
	w_class = SIZE_SMALL
	storage_slots = STORAGE_SLOTS_DEFAULT

/obj/item/storage/box/vials/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/reagent_container/glass/beaker(src)

/obj/item/storage/box/sprays
	name = "box of spray bottles"
	icon_state = "spray"
	item_state = "spray"
	w_class = SIZE_LARGE
	storage_slots = STORAGE_SLOTS_DEFAULT

/obj/item/storage/box/sprays/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/reagent_container/spray(src)

/obj/item/storage/box/chemimp
	name = "boxed chemical implant kit"
	desc = "Box of stuff used to implant chemicals."
	icon_state = "implant"
	storage_slots = STORAGE_SLOTS_DEFAULT

/obj/item/storage/box/chemimp/fill_preset_inventory()
	for(var/i in 1 to 5)
		new /obj/item/implantcase/chem(src)
	new /obj/item/implanter(src)
	new /obj/item/implantpad(src)

/obj/item/storage/box/rxglasses
	name = "box of prescription glasses"
	desc = "This box contains nerd glasses."
	icon_state = "glasses"
	storage_slots = STORAGE_SLOTS_DEFAULT

/obj/item/storage/box/rxglasses/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/clothing/glasses/regular(src)

/obj/item/storage/box/cdeathalarm_kit
	name = "Death Alarm Kit"
	desc = "Box of stuff used to implant death alarms."
	icon_state = "implant"
	item_state = "box"
	storage_slots = STORAGE_SLOTS_DEFAULT

/obj/item/storage/box/cdeathalarm_kit/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/implantcase/death_alarm(src)
	new /obj/item/implanter(src)

/obj/item/storage/box/monkeycubes
	name = "monkey cube box"
	desc = "Drymate brand monkey cubes. Just add water!"
	icon = 'icons/obj/items/storage/boxes.dmi'
	icon_state = "monkeycubebox"
	item_state = "monkeycubebox"
	w_class = SIZE_LARGE
	storage_slots = 5
	var/monkey_type = /obj/item/reagent_container/food/snacks/monkeycube/wrapped

/obj/item/storage/box/monkeycubes/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new monkey_type(src)

/obj/item/storage/box/monkeycubes/farwacubes
	name = "farwa cube box"
	desc = "Drymate brand farwa cubes, shipped from Ahdomai. Just add water!"
	monkey_type = /obj/item/reagent_container/food/snacks/monkeycube/wrapped/farwacube

/obj/item/storage/box/monkeycubes/farwacubes/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new monkey_type(src)

/obj/item/storage/box/monkeycubes/stokcubes
	name = "stok cube box"
	desc = "Drymate brand stok cubes, shipped from Moghes. Just add water!"
	monkey_type = /obj/item/reagent_container/food/snacks/monkeycube/wrapped/stokcube

/obj/item/storage/box/monkeycubes/stokcubes/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new monkey_type(src)

/obj/item/storage/box/monkeycubes/neaeracubes
	name = "neaera cube box"
	desc = "Drymate brand neaera cubes, shipped from Jargon 4. Just add water!"
	monkey_type = /obj/item/reagent_container/food/snacks/monkeycube/wrapped/neaeracube

/obj/item/storage/box/monkeycubes/neaeracubes/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new monkey_type(src)

/obj/item/storage/box/monkeycubes/yautja
	name = "weird cube box"
	desc = "Some box with unknown language label on it."
	icon_state = "box_of_doom"

/obj/item/storage/box/pillbottles
	name = "box of pill bottles"
	desc = "It has pictures of pill bottles on its front."
	icon_state = "pillbox"
	item_state = "pillbox"
	storage_slots = STORAGE_SLOTS_DEFAULT

	storage_flags = STORAGE_FLAGS_BOX|STORAGE_CLICK_GATHER|STORAGE_GATHER_SIMULTANEOUSLY

	//multiplier to time required to empty the box into chem master
	var/time_to_empty = 0.3 SECONDS


/obj/item/storage/box/pillbottles/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/storage/pill_bottle( src )

/obj/item/storage/box/autoinjectors
	name = "box of autoinjectors"
	icon_state = "syringe"
	item_state = "syringe"
	w_class = SIZE_LARGE
	storage_slots = STORAGE_SLOTS_DEFAULT

/obj/item/storage/box/autoinjectors/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/reagent_container/hypospray/autoinjector/empty(src)
