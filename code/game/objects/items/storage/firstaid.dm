/* First aid storage
 * Contains:
 * First Aid Kits
 * Pill Bottles
 * Pill Packets
 */

//---------FIRST AID KITS---------
/obj/item/storage/firstaid
	name = "first-aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos. With medical training you can fit this in a backpack."
	icon = 'icons/obj/items/storage/medical.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_righthand.dmi',
	)
	icon_state = "firstaid"
	var/empty_icon = "kit_empty"
	throw_speed = SPEED_FAST
	throw_range = 8
	use_sound = "toolbox"
	matter = list("plastic" = 2000)
	can_hold = list(
		/obj/item/device/healthanalyzer,
		/obj/item/reagent_container/dropper,
		/obj/item/reagent_container/pill,
		/obj/item/reagent_container/glass/bottle,
		/obj/item/reagent_container/syringe,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/reagent_container/hypospray,
		/obj/item/storage/syringe_case,
		/obj/item/storage/surgical_case,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft,
		/obj/item/roller,
		/obj/item/bodybag,
		/obj/item/reagent_container/blood,
	)
	storage_flags = STORAGE_FLAGS_BOX
	required_skill_for_nest_opening = SKILL_MEDICAL
	required_skill_level_for_nest_opening = SKILL_MEDICAL_MEDIC

	var/icon_full //icon state to use when kit is full
	var/possible_icons_full

/obj/item/storage/firstaid/Initialize()
	. = ..()

	if(possible_icons_full)
		icon_full = pick(possible_icons_full)
	else
		icon_full = initial(icon_state)

	update_icon()

/obj/item/storage/firstaid/update_icon()
	if(content_watchers || !length(contents))
		icon_state = empty_icon
	else
		icon_state = icon_full

/obj/item/storage/firstaid/attack_self(mob/living/user)
	..()

	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.swap_hand()
		open(user)

/obj/item/storage/firstaid/fire
	name = "fire first-aid kit"
	desc = "It's an emergency medical kit for when the dropship ammo storage <i>-spontaneously-</i> burns down. With medical training you can fit this in a backpack."
	icon_state = "ointment"
	item_state = "firstaid-ointment"
	possible_icons_full = list("ointment","firefirstaid")


/obj/item/storage/firstaid/fire/fill_preset_inventory()
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/reagent_container/hypospray/autoinjector/kelotane(src)
	new /obj/item/reagent_container/hypospray/autoinjector/kelotane(src)
	new /obj/item/reagent_container/hypospray/autoinjector/kelotane(src)
	new /obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol(src)

/obj/item/storage/firstaid/fire/empty/fill_preset_inventory()
	return

/obj/item/storage/firstaid/regular
	icon_state = "firstaid"
	item_state = "firstaid"
	desc = "It's an emergency medical kit containing basic medication and equipment. No training required to use. With medical training you can fit this in a backpack."

/obj/item/storage/firstaid/regular/fill_preset_inventory()
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/reagent_container/hypospray/autoinjector/skillless(src)
	new /obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol(src)
	new /obj/item/reagent_container/hypospray/autoinjector/inaprovaline(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/splint(src)

/obj/item/storage/firstaid/regular/empty/fill_preset_inventory()
	return

/obj/item/storage/firstaid/regular/response
	desc = "It's an emergency medical kit containing basic medication and equipment. No training required to use. This one is simpler and requires no training to store."
	required_skill_for_nest_opening = SKILL_MEDICAL
	required_skill_level_for_nest_opening = SKILL_MEDICAL_DEFAULT

/obj/item/storage/firstaid/robust
	icon_state = "firstaid"

/obj/item/storage/firstaid/robust/fill_preset_inventory()
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/storage/pill_bottle/bicaridine(src)
	new /obj/item/storage/pill_bottle/kelotane(src)
	new /obj/item/storage/pill_bottle/tramadol(src)
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)

/obj/item/storage/firstaid/robust/empty/fill_preset_inventory()
	return

/obj/item/storage/firstaid/toxin
	name = "toxin first-aid kit"
	desc = "It's an emergency medical kit containing lifesaving anti-toxic medication. With medical training you can fit this in a backpack."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"

/obj/item/storage/firstaid/toxin/fill_preset_inventory()
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/storage/pill_bottle/antitox(src)
	new /obj/item/reagent_container/pill/antitox(src)
	new /obj/item/reagent_container/pill/antitox(src)
	new /obj/item/reagent_container/pill/antitox(src)

/obj/item/storage/firstaid/toxin/empty/fill_preset_inventory()
	return

/obj/item/storage/firstaid/o2
	name = "oxygen deprivation first-aid kit"
	desc = "A box full of reoxygenating goodies. With medical training you can fit this in a backpack."
	icon_state = "o2"
	item_state = "firstaid-o2"

/obj/item/storage/firstaid/o2/fill_preset_inventory()
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/reagent_container/pill/dexalin(src)
	new /obj/item/reagent_container/pill/dexalin(src)
	new /obj/item/reagent_container/hypospray/autoinjector/dexalinp(src)
	new /obj/item/reagent_container/hypospray/autoinjector/dexalinp(src)
	new /obj/item/reagent_container/hypospray/autoinjector/dexalinp(src)
	new /obj/item/reagent_container/hypospray/autoinjector/inaprovaline(src)

/obj/item/storage/firstaid/o2/empty/fill_preset_inventory()
	return

/obj/item/storage/firstaid/adv
	name = "advanced first-aid kit"
	desc = "Contains more effective methods of medical treatment than a basic first-aid kit, such as burn and trauma kits. With medical training you can fit this in a backpack."
	icon_state = "advfirstaid"
	item_state = "firstaid-advanced"

/obj/item/storage/firstaid/adv/fill_preset_inventory()
	new /obj/item/reagent_container/hypospray/autoinjector/tricord(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)

/obj/item/storage/firstaid/adv/empty/fill_preset_inventory()
	return

/obj/item/storage/firstaid/synth
	name = "synthetic repair kit"
	desc = "Contains equipment to repair a damaged synthetic. A tag on the back reads: 'Does not contain a shocking tool to repair disabled synthetics, nor a scanning device to detect specific damage; pack separately.' With medical training you can fit this in a backpack."
	icon_state = "bezerk"
	item_state = "firstaid-advanced"
	can_hold = list(
		/obj/item/device/healthanalyzer,
		/obj/item/reagent_container/dropper,
		/obj/item/reagent_container/pill,
		/obj/item/reagent_container/glass/bottle,
		/obj/item/reagent_container/syringe,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/reagent_container/hypospray,
		/obj/item/storage/syringe_case,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft,
		/obj/item/stack/nanopaste,
		/obj/item/stack/cable_coil,
		/obj/item/tool/weldingtool,
	)

/obj/item/storage/firstaid/synth/fill_preset_inventory()
	new /obj/item/stack/nanopaste(src)
	new /obj/item/stack/nanopaste(src)
	new /obj/item/stack/nanopaste(src)
	new /obj/item/stack/nanopaste(src)
	new /obj/item/stack/cable_coil/white(src)
	new /obj/item/stack/cable_coil/white(src)
	new /obj/item/tool/weldingtool(src)

/obj/item/storage/firstaid/synth/empty/fill_preset_inventory()
	return

/obj/item/storage/firstaid/whiteout
	name = "elite repair kit"
	desc = "An expensive looking, carbon finish kit box, has a big W-Y logo on front. Contains advanced equipment for repairing a damaged synthetic, including a reset key."
	icon_state = "whiteout"
	empty_icon = "whiteout_empty"
	item_state = "whiteout"
	can_hold = list(
		/obj/item/device/healthanalyzer,
		/obj/item/reagent_container/dropper,
		/obj/item/reagent_container/pill,
		/obj/item/reagent_container/glass/bottle,
		/obj/item/reagent_container/syringe,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/reagent_container/hypospray,
		/obj/item/storage/syringe_case,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft,
		/obj/item/stack/nanopaste,
		/obj/item/stack/cable_coil,
		/obj/item/tool/weldingtool,
		/obj/item/device/defibrillator/synthetic,
	)

/obj/item/storage/firstaid/whiteout/fill_preset_inventory()
	new /obj/item/stack/nanopaste(src)
	new /obj/item/stack/nanopaste(src)
	new /obj/item/stack/nanopaste(src)
	new /obj/item/stack/nanopaste(src)
	new /obj/item/stack/cable_coil/white(src)
	new /obj/item/device/defibrillator/synthetic/noskill(src)
	new /obj/item/tool/weldingtool/largetank(src)

/obj/item/storage/firstaid/whiteout/empty/fill_preset_inventory()
	return

/obj/item/storage/firstaid/whiteout/medical
	name = "elite field revival kit"
	desc = "An expensive looking, carbon finish kit box, has a big W-Y logo on front. Contains advanced medical tools for providing medical aid to high priority figures."
	icon_state = "whiteout_medical"
	empty_icon = "whiteout_empty"
	item_state = "whiteout"
	can_hold = list(
		/obj/item/device/healthanalyzer,
		/obj/item/reagent_container/dropper,
		/obj/item/reagent_container/pill,
		/obj/item/reagent_container/glass/bottle,
		/obj/item/reagent_container/syringe,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/reagent_container/hypospray,
		/obj/item/storage/syringe_case,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft,
		/obj/item/stack/nanopaste,
		/obj/item/stack/cable_coil,
		/obj/item/tool/weldingtool,
		/obj/item/device/defibrillator,
		/obj/item/tool/surgery/scalpel/manager,
		/obj/item/storage/box/czsp/medic_upgraded_kits/full,
		/obj/item/storage/surgical_case,
		/obj/item/roller,
	)

/obj/item/storage/firstaid/whiteout/medical/fill_preset_inventory()
	new /obj/item/storage/box/czsp/medic_upgraded_kits/full(src)
	new /obj/item/storage/box/czsp/medic_upgraded_kits/full(src)
	new /obj/item/stack/medical/splint/nano(src)
	new /obj/item/storage/surgical_case/elite/whiteout(src)
	new /obj/item/storage/syringe_case/whiteout(src)
	new /obj/item/device/defibrillator/compact(src)
	new /obj/item/roller/surgical(src)

/obj/item/storage/firstaid/whiteout/medical/commando/fill_preset_inventory()
	new /obj/item/storage/box/czsp/medic_upgraded_kits/full(src)
	new /obj/item/storage/box/czsp/medic_upgraded_kits/full(src)
	new /obj/item/stack/medical/splint/nano(src)
	new /obj/item/stack/medical/splint/nano(src)
	new /obj/item/storage/syringe_case/commando(src)
	new /obj/item/storage/surgical_case/elite/commando(src)
	new /obj/item/roller/surgical(src)

/obj/item/storage/firstaid/whiteout/medical/commando/looted/fill_preset_inventory() //for commando insert
	new /obj/item/storage/box/czsp/medic_upgraded_kits/looted(src)
	new /obj/item/storage/box/czsp/medic_upgraded_kits/looted(src)
	new /obj/item/stack/medical/splint/nano/low_amount(src)
	new /obj/item/storage/syringe_case/commando/looted(src)
	new /obj/item/storage/surgical_case/elite/commando/looted(src)
	new /obj/item/roller(src)

/obj/item/storage/firstaid/rad
	name = "radiation first-aid kit"
	desc = "Contains treatment for radiation exposure. With medical training you can fit this in a backpack."
	icon_state = "purplefirstaid"

/obj/item/storage/firstaid/rad/fill_preset_inventory()
	new /obj/item/reagent_container/pill/russianRed(src)
	new /obj/item/reagent_container/pill/russianRed(src)
	new /obj/item/reagent_container/pill/russianRed(src)
	new /obj/item/reagent_container/pill/russianRed(src)
	new /obj/item/reagent_container/hypospray/autoinjector/bicaridine(src)
	new /obj/item/reagent_container/hypospray/autoinjector/bicaridine(src)

/obj/item/storage/firstaid/rad/empty/fill_preset_inventory()
	return

/obj/item/storage/firstaid/surgical
	name = "basic field surgery kit"
	desc = "Contains a surgical line, cautery, scalpel, hemostat, retractor, drapes and an oxycodone injector for tending wounds surgically. With medical training you can fit this in a backpack."
	icon_state = "bezerk"
	can_hold = list(
		/obj/item/device/healthanalyzer,
		/obj/item/reagent_container/dropper,
		/obj/item/reagent_container/pill,
		/obj/item/reagent_container/glass/bottle,
		/obj/item/reagent_container/syringe,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/reagent_container/hypospray,
		/obj/item/storage/syringe_case,
		/obj/item/tool/surgery,
	)

/obj/item/storage/firstaid/surgical/fill_preset_inventory()
	new /obj/item/tool/surgery/surgical_line(src)
	new /obj/item/tool/surgery/cautery(src)
	new /obj/item/tool/surgery/scalpel(src)
	new /obj/item/tool/surgery/hemostat(src)
	new /obj/item/tool/surgery/retractor(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone(src)

/obj/item/storage/firstaid/surgical/empty/fill_preset_inventory()
	return

//---------SYRINGE CASE---------

/obj/item/storage/syringe_case
	name = "syringe case"
	desc = "It's a medical case for storing syringes and bottles."
	icon = 'icons/obj/items/storage/medical.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_righthand.dmi',
	)
	icon_state = "syringe_case"
	throw_speed = SPEED_FAST
	throw_range = 8
	storage_slots = 3
	w_class = SIZE_SMALL
	matter = list("plastic" = 1000)
	can_hold = list(
		/obj/item/reagent_container/pill,
		/obj/item/reagent_container/glass/bottle,
		/obj/item/paper,
		/obj/item/reagent_container/syringe,
		/obj/item/reagent_container/hypospray/autoinjector,
	)

/obj/item/storage/syringe_case/regular

/obj/item/storage/syringe_case/regular/fill_preset_inventory()
	new /obj/item/reagent_container/syringe( src )
	new /obj/item/reagent_container/glass/bottle/inaprovaline( src )
	new /obj/item/reagent_container/glass/bottle/tricordrazine( src )

/obj/item/storage/syringe_case/burn

/obj/item/storage/syringe_case/burn/fill_preset_inventory()
	new /obj/item/reagent_container/syringe( src )
	new /obj/item/reagent_container/glass/bottle/kelotane( src )
	new /obj/item/reagent_container/glass/bottle/tricordrazine( src )

/obj/item/storage/syringe_case/tox

/obj/item/storage/syringe_case/tox/fill_preset_inventory()
	new /obj/item/reagent_container/syringe( src )
	new /obj/item/reagent_container/glass/bottle/antitoxin( src )
	new /obj/item/reagent_container/glass/bottle/antitoxin( src )

/obj/item/storage/syringe_case/oxy

/obj/item/storage/syringe_case/oxy/fill_preset_inventory()
	new /obj/item/reagent_container/syringe( src )
	new /obj/item/reagent_container/glass/bottle/inaprovaline( src )
	new /obj/item/reagent_container/glass/bottle/dexalin( src )

/obj/item/storage/syringe_case/rmc

/obj/item/storage/syringe_case/rmc/fill_preset_inventory()
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone( src )
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone( src )
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone( src )

/obj/item/storage/syringe_case/whiteout

/obj/item/storage/syringe_case/whiteout/fill_preset_inventory()
	new /obj/item/reagent_container/hypospray/autoinjector/stimulant/redemption_stimulant( src )
	new /obj/item/reagent_container/hypospray/autoinjector/emergency( src )
	new /obj/item/reagent_container/hypospray/autoinjector/oxycodone( src )

/obj/item/storage/syringe_case/commando

/obj/item/storage/syringe_case/commando/fill_preset_inventory()
	new /obj/item/reagent_container/hypospray/autoinjector/ultrazine( src )
	new /obj/item/reagent_container/hypospray/autoinjector/inaprovaline( src )
	new /obj/item/reagent_container/hypospray/autoinjector/adrenaline( src )

/obj/item/storage/syringe_case/commando/looted //for surv insert

/obj/item/storage/syringe_case/commando/looted/fill_preset_inventory()
	new /obj/item/reagent_container/hypospray/autoinjector/ultrazine/empty( src )
	new /obj/item/reagent_container/hypospray/autoinjector/inaprovaline( src )
	new /obj/item/reagent_container/hypospray/autoinjector/adrenaline( src )

/obj/item/storage/box/czsp/first_aid
	name = "first-aid combat support kit"
	desc = "Contains upgraded medical kits, nanosplints and an upgraded defibrillator."
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "medicbox"
	storage_slots = 3

/obj/item/storage/box/czsp/first_aid/Initialize()
	. = ..()
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/ointment(src)
	if(prob(5))
		new /obj/item/device/healthanalyzer(src)

/obj/item/storage/box/czsp/medical
	name = "medical combat support kit"
	desc = "Contains upgraded medical kits, nanosplints and an upgraded defibrillator."
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "medicbox"
	storage_slots = 4

/obj/item/storage/box/czsp/medical/Initialize()
	. = ..()
	new /obj/item/stack/medical/advanced/bruise_pack/upgraded(src)
	new /obj/item/stack/medical/advanced/ointment/upgraded(src)
	new /obj/item/stack/medical/splint/nano(src)
	new /obj/item/device/defibrillator/upgraded(src)

/obj/item/storage/box/czsp/medic_upgraded_kits
	name = "medical upgrade kit"
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "upgradedkitbox"
	desc = "This kit holds upgraded trauma and burn kits, for critical injuries."
	w_class = SIZE_SMALL
	max_w_class = SIZE_MEDIUM
	storage_slots = 2

/obj/item/storage/box/czsp/medic_upgraded_kits/full/Initialize()
	. = ..()
	new /obj/item/stack/medical/advanced/bruise_pack/upgraded(src)
	new /obj/item/stack/medical/advanced/ointment/upgraded(src)

/obj/item/storage/box/czsp/medic_upgraded_kits/looted/Initialize()
	. = ..()
	if(prob(35))
		new /obj/item/stack/medical/advanced/bruise_pack/upgraded/low_amount(src)
	if(prob(35))
		new /obj/item/stack/medical/advanced/ointment/upgraded/low_amount(src)


//---------SURGICAL CASE---------


/obj/item/storage/surgical_case
	name = "surgical case"
	desc = "It's a medical case for storing basic surgical tools. It comes with a brief description for treating common internal bleeds.\
		\nBefore surgery: Verify correct location and patient is adequately numb to pain.\
		\nStep one: Open an incision at the site with the scalpel.\
		\nStep two: Clamp bleeders with the hemostat.\
		\nStep three: Draw back the skin with the retracter.\
		\nStep four: Patch the damaged vein with a surgical line.\
		\nStep five: Close the incision with a surgical line."
	icon = 'icons/obj/items/storage/medical.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_righthand.dmi',
	)
	icon_state = "surgical_case"
	throw_speed = SPEED_FAST
	throw_range = 8
	storage_slots = 3
	w_class = SIZE_SMALL
	matter = list("plastic" = 1000)
	can_hold = list(
		/obj/item/tool/surgery/scalpel,
		/obj/item/tool/surgery/hemostat,
		/obj/item/tool/surgery/retractor,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft,
		/obj/item/tool/surgery/FixOVein,
	)

/obj/item/storage/surgical_case/regular

/obj/item/storage/surgical_case/regular/fill_preset_inventory()
	new /obj/item/tool/surgery/scalpel(src)
	new /obj/item/tool/surgery/hemostat(src)
	new /obj/item/tool/surgery/retractor(src)

/obj/item/storage/surgical_case/elite
	name = "elite surgical case"
	desc = "It's an expensive looking medical case for storing compactly placed field surgical tools. Has a bright reflective W-Y logo on it.\
		\nBefore surgery: Verify correct location and patient is adequately numb to pain.\
		\nStep one: Open an incision at the site with the scalpel.\
		\nStep two: Clamp bleeders with the hemostat.\
		\nStep three: Draw back the skin with the retracter.\
		\nStep four: Patch the damaged vein with a surgical line.\
		\nStep five: Close the incision with a surgical line."
	icon_state = "surgical_case_elite"
	storage_slots = 5

/obj/item/storage/surgical_case/elite/commando/fill_preset_inventory()
	new /obj/item/tool/surgery/scalpel(src)
	new /obj/item/tool/surgery/hemostat(src)
	new /obj/item/tool/surgery/retractor(src)
	new /obj/item/tool/surgery/surgical_line(src)
	new /obj/item/tool/surgery/synthgraft(src)

/obj/item/storage/surgical_case/elite/commando/looted/fill_preset_inventory()
	if(prob(65))
		new /obj/item/tool/surgery/scalpel(src)
	if(prob(65))
		new /obj/item/tool/surgery/hemostat(src)
	if(prob(65))
		new /obj/item/tool/surgery/retractor(src)
	new /obj/item/tool/surgery/surgical_line(src)
	new /obj/item/tool/surgery/synthgraft(src)

/obj/item/storage/surgical_case/elite/whiteout
	storage_slots = 3

/obj/item/storage/surgical_case/elite/whiteout/fill_preset_inventory()
	new /obj/item/tool/surgery/scalpel/manager(src)
	new /obj/item/tool/surgery/surgical_line(src)
	new /obj/item/tool/surgery/synthgraft(src)

/obj/item/storage/surgical_case/rmc_surgical_case
	name = "\improper RMC surgical case"
	desc = "It's a medical case for storing basic surgical tools. It comes with a brief description for treating common internal bleeds. This one was made specifically for Royal Marine Commandos, allowing them to suture their wounds during prolonged operations.\
		\nBefore surgery: Verify correct location and patient is adequately numb to pain.\
		\nStep one: Open an incision at the site with the scalpel.\
		\nStep two: Clamp bleeders with the hemostat.\
		\nStep three: Draw back the skin with the retracter.\
		\nStep four: Patch the damaged vein with a surgical line.\
		\nStep five: Close the incision with a surgical line."
	storage_slots = 5
	can_hold = list(
		/obj/item/tool/surgery/scalpel,
		/obj/item/tool/surgery/hemostat,
		/obj/item/tool/surgery/retractor,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft,
		/obj/item/tool/surgery/FixOVein,
	)

/obj/item/storage/surgical_case/rmc_surgical_case/full/fill_preset_inventory()
	new /obj/item/tool/surgery/scalpel(src)
	new /obj/item/tool/surgery/hemostat(src)
	new /obj/item/tool/surgery/retractor(src)
	new /obj/item/tool/surgery/surgical_line(src)
	new /obj/item/tool/surgery/synthgraft(src)


//---------PILL BOTTLES---------

/obj/item/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/items/chemistry.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_righthand.dmi'
	)
	item_state = "pill_canister"
	w_class = SIZE_SMALL
	matter = list("plastic" = 500)
	can_hold = list(
		/obj/item/reagent_container/pill,
		/obj/item/toy/dice,
		/obj/item/paper,
	)
	storage_flags = STORAGE_FLAGS_BOX|STORAGE_CLICK_GATHER|STORAGE_QUICK_GATHER|STORAGE_DISABLE_USE_EMPTY
	storage_slots = null
	use_sound = "pillbottle"
	max_storage_space = 16
	var/skilllock = SKILL_MEDICAL_MEDIC
	var/pill_type_to_fill //type of pill to use to fill in the bottle in /Initialize()
	var/bottle_lid = TRUE //Whether it shows a visual lid when opened or closed.
	var/display_maptext = TRUE
	var/maptext_label
	maptext_height = 16
	maptext_width = 24
	maptext_x = 4
	maptext_y = 2

	var/base_icon = "pill_canister"
	var/static/list/possible_colors = list(
		"Orange" = "",
		"Blue" = "1",
		"Yellow" = "2",
		"Light Purple" = "3",
		"Light Grey" = "4",
		"White" = "5",
		"Light Green" = "6",
		"Cyan" = "7",
		"Bordeaux" = "8",
		"Aquamarine" = "9",
		"Grey" = "10",
		"Red" = "11",
		"Black" = "12",
	)

/obj/item/storage/pill_bottle/Initialize()
	. = ..()
	if(!display_maptext)
		verbs -= /obj/item/storage/pill_bottle/verb/set_maptext

/obj/item/storage/pill_bottle/fill_preset_inventory()
	if(pill_type_to_fill)
		for(var/i in 1 to max_storage_space)
			new pill_type_to_fill(src)

/obj/item/storage/pill_bottle/update_icon()
	if(!bottle_lid)
		return
	overlays.Cut()
	if(content_watchers || !length(contents))
		overlays += "pills_open"
	else
		overlays += "pills_closed"

	if((isstorage(loc) || ismob(loc)) && display_maptext)
		maptext = SPAN_LANGCHAT("[maptext_label]")
	else
		maptext = ""

/obj/item/storage/pill_bottle/get_examine_text(mob/user)
	. = ..()
	var/pills_amount = length(contents)
	if(pills_amount)
		var/percentage_filled = floor(pills_amount/max_storage_space * 100)
		switch(percentage_filled)
			if(80 to 101)
				. += SPAN_INFO("The [name] seems fairly full.")
			if(60 to 79)
				. += SPAN_INFO("The [name] feels more than half full.")
			if(40 to 59)
				. += SPAN_INFO("The [name] seems to be around half full.")
			if(20 to 39)
				. += SPAN_INFO("The [name] feels less than half full.")
			if(0 to 19)
				. += SPAN_INFO("The [name] feels like it's nearly empty!")
	else
		. += SPAN_INFO("The [name] is empty.")

/obj/item/storage/pill_bottle/attack_self(mob/living/user)
	..()

	if(user.get_inactive_hand())
		to_chat(user, SPAN_WARNING("You need an empty hand to take out a pill."))
		return
	if(!can_storage_interact(user))
		error_idlock(user)
		return
	if(length(contents))
		var/obj/item/I = contents[1]
		if(user.put_in_inactive_hand(I))
			playsound(loc, use_sound, 10, TRUE, 3)
			remove_from_storage(I,user)
			to_chat(user, SPAN_NOTICE("You take a pill out of the [name]."))
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.swap_hand()
			return
	else
		to_chat(user, SPAN_WARNING("The [name] is empty."))
		return

/obj/item/storage/pill_bottle/shake(mob/user, turf/tile)
	if(!can_storage_interact(user))
		error_idlock(user)
		return
	return ..()

/obj/item/storage/pill_bottle/attackby(obj/item/storage/pill_bottle/W, mob/user)
	if(istype(W))
		if((skilllock || W.skilllock) && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
			error_idlock(user)
			return
		dump_into(W,user)
	else
		return ..()


/obj/item/storage/pill_bottle/open(mob/user)
	if(!can_storage_interact(user))
		error_idlock(user)
		return
	..()

/obj/item/storage/pill_bottle/can_be_inserted(obj/item/W, mob/user, stop_messages = FALSE)
	. = ..()
	if(.)
		if(!can_storage_interact(user))
			error_idlock(usr)
			return

/obj/item/storage/pill_bottle/clicked(mob/user, list/mods)
	if(..())
		return TRUE
	if(!istype(loc, /obj/item/storage/belt/medical))
		return FALSE
	var/obj/item/storage/belt/medical/M = loc
	if(!M.mode)
		return FALSE
	if(!can_storage_interact(user))
		error_idlock(user)
		return FALSE
	if(user.get_active_hand())
		return FALSE
	var/mob/living/carbon/C = user
	if(C.is_mob_restrained())
		to_chat(user, SPAN_WARNING("You are restrained!"))
		return FALSE
	if(!length(contents))
		to_chat(user, SPAN_WARNING("The [name] is empty."))
		return FALSE
	var/obj/item/I = contents[1]
	if(user.put_in_active_hand(I))
		remove_from_storage(I,user)
		to_chat(user, SPAN_NOTICE("You take [I] out of the [name]."))
		return TRUE

/obj/item/storage/pill_bottle/empty(mob/user, turf/T)
	if(skilllock && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		error_idlock(user)
		return
	..()

/obj/item/storage/pill_bottle/equipped()
	..()
	update_icon()

/obj/item/storage/pill_bottle/on_exit_storage()
	..()
	update_icon()

/obj/item/storage/pill_bottle/dropped()
	..()
	update_icon()

/obj/item/storage/pill_bottle/attack_hand(mob/user, mods)
	if(loc != user)
		return ..()

	if(!mods || !mods[ALT_CLICK])
		return ..()

	if(!ishuman(user))
		return ..()

	if(!can_storage_interact(user))
		error_idlock(user)
		return FALSE

	return ..()

/obj/item/storage/pill_bottle/proc/error_idlock(mob/user)
	to_chat(user, SPAN_WARNING("It must have some kind of ID lock..."))

/obj/item/storage/pill_bottle/proc/choose_color(mob/user)
	if(!user)
		user = usr

	var/selected_color = tgui_input_list(user, "Select a color.", "Color choice", possible_colors)
	if(!selected_color)
		return

	selected_color = possible_colors[selected_color]

	icon_state = base_icon + selected_color
	to_chat(user, SPAN_NOTICE("You color [src]."))
	update_icon()

/obj/item/storage/pill_bottle/verb/set_maptext()
	set category = "Object"
	set name = "Set short label (on-sprite)"
	set src in usr

	if(src && ishuman(usr))
		var/str = copytext(reject_bad_text(input(usr,"Label text? (3 CHARACTERS MAXIMUM)", "Set \the [src]'s on-sprite label", "")), 1, 4)
		if(!str || !length(str))
			to_chat(usr, SPAN_NOTICE("You clear the label off \the [src]."))
			maptext_label = null
			update_icon()
			return
		maptext_label = str
		to_chat(usr, SPAN_NOTICE("You label \the [src] with '[str]' in big, blocky letters."))
		update_icon()

/obj/item/storage/pill_bottle/can_storage_interact(mob/user)
	if(skilllock && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		return FALSE
	return ..()

/obj/item/storage/pill_bottle/kelotane
	name = "\improper Kelotane pill bottle"
	icon_state = "pill_canister2"
	item_state = "pill_canister2"
	pill_type_to_fill = /obj/item/reagent_container/pill/kelotane
	maptext_label = "Kl"

/obj/item/storage/pill_bottle/kelotane/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/storage/pill_bottle/antitox
	name = "\improper Dylovene pill bottle"
	icon_state = "pill_canister6"
	item_state = "pill_canister6"
	pill_type_to_fill = /obj/item/reagent_container/pill/antitox
	maptext_label = "Dy"


/obj/item/storage/pill_bottle/antitox/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/storage/pill_bottle/inaprovaline
	name = "\improper Inaprovaline pill bottle"
	icon_state = "pill_canister3"
	item_state = "pill_canister3"
	pill_type_to_fill = /obj/item/reagent_container/pill/inaprovaline
	maptext_label = "In"

/obj/item/storage/pill_bottle/inaprovaline/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/storage/pill_bottle/tramadol
	name = "\improper Tramadol pill bottle"
	icon_state = "pill_canister5"
	item_state = "pill_canister5"
	pill_type_to_fill = /obj/item/reagent_container/pill/tramadol
	maptext_label = "Tr"

/obj/item/storage/pill_bottle/tramadol/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/storage/pill_bottle/spaceacillin
	name = "\improper Spaceacillin pill bottle"
	icon_state = "pill_canister4"
	item_state = "pill_canister4"
	pill_type_to_fill = /obj/item/reagent_container/pill/spaceacillin
	maptext_label = "Sp"

/obj/item/storage/pill_bottle/spaceacillin/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/storage/pill_bottle/bicaridine
	name = "\improper Bicaridine pill bottle"
	icon_state = "pill_canister11"
	item_state = "pill_canister11"
	pill_type_to_fill = /obj/item/reagent_container/pill/bicaridine
	maptext_label = "Bi"

/obj/item/storage/pill_bottle/bicaridine/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/storage/pill_bottle/dexalin
	name = "\improper Dexalin pill bottle"
	icon_state = "pill_canister1"
	item_state = "pill_canister1"
	pill_type_to_fill = /obj/item/reagent_container/pill/dexalin
	maptext_label = "Dx"

/obj/item/storage/pill_bottle/dexalin/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

//Alkysine
/obj/item/storage/pill_bottle/alkysine
	name = "\improper Alkysine pill bottle"
	icon_state = "pill_canister7"
	item_state = "pill_canister7"
	pill_type_to_fill = /obj/item/reagent_container/pill/alkysine
	maptext_label = "Al"

/obj/item/storage/pill_bottle/alkysine/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

//imidazoline
/obj/item/storage/pill_bottle/imidazoline
	name = "\improper Imidazoline pill bottle"
	icon_state = "pill_canister9"
	item_state = "pill_canister9"
	pill_type_to_fill = /obj/item/reagent_container/pill/imidazoline
	maptext_label = "Im"

/obj/item/storage/pill_bottle/imidazoline/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/storage/pill_bottle/imialky
	name = "\improper Imidazoline-Alkysine pill bottle"
	icon_state = "pill_canister9"
	pill_type_to_fill = /obj/item/reagent_container/pill/imialky
	maptext_label = "IA"

//PERIDAXON
/obj/item/storage/pill_bottle/peridaxon
	name = "\improper Peridaxon pill bottle"
	icon_state = "pill_canister10"
	item_state = "pill_canister10"
	pill_type_to_fill = /obj/item/reagent_container/pill/peridaxon
	maptext_label = "Pr"

/obj/item/storage/pill_bottle/peridaxon/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

//RUSSIAN RED ANTI-RAD
/obj/item/storage/pill_bottle/russianRed
	name = "\improper Russian red pill bottle"
	icon_state = "pill_canister"
	item_state = "pill_canister"
	pill_type_to_fill = /obj/item/reagent_container/pill/russianRed
	maptext_label = "Rr"

/obj/item/storage/pill_bottle/russianRed/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

//Ultrazine
/obj/item/storage/pill_bottle/ultrazine
	name = "pill bottle"
	icon_state = "pill_canister11"
	item_state = "pill_canister11"
	max_storage_space = 5
	skilllock = SKILL_MEDICAL_DEFAULT //CL can open it
	var/idlock = TRUE
	pill_type_to_fill = /obj/item/reagent_container/pill/ultrazine/unmarked
	display_maptext = FALSE //for muh corporate secrets - Stan_Albatross

	req_one_access = list(ACCESS_WY_EXEC, ACCESS_WY_RESEARCH)
	black_market_value = 35


/obj/item/storage/pill_bottle/ultrazine/proc/id_check(mob/user)

	if(!idlock)
		return TRUE

	var/mob/living/carbon/human/human_user = user

	if(!allowed(human_user))
		to_chat(user, SPAN_NOTICE("It must have some kind of ID lock..."))
		return FALSE

	var/obj/item/card/id/idcard = human_user.get_idcard()
	if(!idcard) //not wearing an ID
		to_chat(human_user, SPAN_NOTICE("It must have some kind of ID lock..."))
		return FALSE

	if(!idcard.check_biometrics(human_user))
		to_chat(human_user, SPAN_WARNING("Wrong ID card owner detected."))
		return FALSE

	return TRUE

/obj/item/storage/pill_bottle/ultrazine/attack_self(mob/living/user)
	if(!id_check(user))
		return
	..()

/obj/item/storage/pill_bottle/ultrazine/open(mob/user)
	if(!id_check(user))
		return
	..()

/obj/item/storage/pill_bottle/ultrazine/skillless
	name = "\improper Ultrazine pill bottle"
	idlock = FALSE
	display_maptext = TRUE
	maptext_label = "Uz"

/obj/item/storage/pill_bottle/mystery
	name = "\improper Weird-looking pill bottle"
	desc = "You can't seem to identify this."

/obj/item/storage/pill_bottle/mystery/Initialize()
	icon_state = "pill_canister[rand(1, 12)]"
	maptext_label = "??"
	. = ..()

/obj/item/storage/pill_bottle/mystery/fill_preset_inventory()
	var/list/cool_pills = subtypesof(/obj/item/reagent_container/pill)
	for(var/i=1 to max_storage_space)
		var/pill_to_fill = pick(cool_pills)
		var/obj/item/reagent_container/pill/P = new pill_to_fill(src)
		P.identificable = FALSE

/obj/item/storage/pill_bottle/mystery/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

/obj/item/storage/pill_bottle/stimulant
	name = "\improper Stimulant pill bottle"
	icon_state = "pill_canister12"
	item_state = "pill_canister12"
	pill_type_to_fill = /obj/item/reagent_container/pill/stimulant
	maptext_label = "ST"

/obj/item/storage/pill_bottle/stimulant/skillless
	skilllock = SKILL_MEDICAL_DEFAULT

//NOT FOR USCM USE!!!!
/obj/item/storage/pill_bottle/paracetamol
	name = "\improper Paracetamol pill bottle"
	desc = "This is probably someone's prescription bottle."
	icon_state = "pill_canister7"
	pill_type_to_fill = /obj/item/reagent_container/pill/paracetamol
	skilllock = SKILL_MEDICAL_DEFAULT
	maptext_label = "Pc"

//---------PILL PACKETS---------
/obj/item/storage/pill_bottle/packet
	name = "\improper pill packet"
	desc = "Contains pills. Once you take them out, they don't go back in."
	icon_state = "pill_packet"
	item_state_slots = list(WEAR_AS_GARB = "brutepack (bandages)")
	item_icons = list(
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/medical.dmi',
	)
	bottle_lid = FALSE
	storage_slots = 4
	max_w_class = 0
	max_storage_space = 4
	skilllock = SKILL_MEDICAL_DEFAULT
	storage_flags = STORAGE_FLAGS_BOX|STORAGE_DISABLE_USE_EMPTY
	display_maptext = FALSE

/obj/item/storage/pill_bottle/packet/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(try_forced_folding))

/obj/item/storage/pill_bottle/packet/proc/try_forced_folding(datum/source, mob/user)
	SIGNAL_HANDLER

	if(!isturf(loc))
		return

	if(locate(/obj/item/reagent_container/pill) in src)
		return

	UnregisterSignal(src, COMSIG_ITEM_DROPPED)
	storage_close(user)
	to_chat(user, SPAN_NOTICE("You throw away [src]."))
	qdel(src)

/obj/item/storage/pill_bottle/packet/tricordrazine
	name = "Tricordazine pill packet"
	icon_state = "tricordrazine_packet"
	desc = "This packet contains tricordazine pills. Heals all types of damage slightly. Once you take them out, they don't go back in. Don't take more than 2 pills in a short period."
	pill_type_to_fill = /obj/item/reagent_container/pill/tricordrazine

/obj/item/storage/pill_bottle/packet/tramadol
	name = "Tramadol pill packet"
	icon_state = "tramadol_packet"
	desc = "This packet contains tramadol pills, a mild painkiller. Once you take them out, they don't go back in. Don't take more than 2 pills in a short period."
	pill_type_to_fill = /obj/item/reagent_container/pill/tramadol

/obj/item/storage/pill_bottle/packet/bicaridine
	name = "Bicaridine pill packet"
	icon_state = "bicaridine_packet"
	desc = "This packet contains bicaridine pills. Heals brute damage effectively. Once you take them out, they don't go back in. Don't take more than 2 pills in a short period."
	pill_type_to_fill = /obj/item/reagent_container/pill/bicaridine

/obj/item/storage/pill_bottle/packet/kelotane
	name = "kelotane pill packet"
	icon_state = "kelotane_packet"
	desc = "This packet contains kelotane pills. Heals burn damage effectively. Once you take them out, they don't go back in. Don't take more than 2 pills in a short period."
	pill_type_to_fill = /obj/item/reagent_container/pill/kelotane

/obj/item/storage/pill_bottle/packet/oxycodone
	name = "oxycodone pill packet"
	icon_state = "oxycodone_packet"
	desc = "This packet contains oxycodone pills. A highly effective painkiller. Once you take them out, they don't go back in. Don't take more than 1 pill in a short period."
	pill_type_to_fill = /obj/item/reagent_container/pill/oxycodone
