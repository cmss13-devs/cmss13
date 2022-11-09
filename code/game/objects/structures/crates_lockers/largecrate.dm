/obj/structure/largecrate
	name = "large crate"
	desc = "A hefty wooden crate."
	icon = 'icons/obj/structures/crates.dmi'
	icon_state = "densecrate"
	density = 1
	anchored = 0
	var/parts_type = /obj/item/stack/sheet/wood
	var/unpacking_sound = 'sound/effects/woodhit.ogg'

/obj/structure/largecrate/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER|PASS_AROUND

/obj/structure/largecrate/attack_hand(mob/user as mob)
	to_chat(user, SPAN_NOTICE("You need a crowbar to pry this open!"))
	return

/obj/structure/largecrate/proc/unpack()
	if(parts_type)
		new parts_type(loc, 2)
	for(var/obj/O in contents)
		O.forceMove(loc)
	playsound(src, unpacking_sound, 35)
	qdel(src)

/obj/structure/largecrate/attackby(obj/item/W as obj, mob/user as mob)
	if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
		unpack()
		user.visible_message(SPAN_NOTICE("[user] pries \the [src] open."), \
							 SPAN_NOTICE("You pry open \the [src]."))
	else
		return attack_hand(user)

/obj/structure/largecrate/attack_alien(mob/living/carbon/Xenomorph/M)
	M.animation_attack_on(src)
	unpack()
	M.visible_message(SPAN_DANGER("[M] smashes [src] apart!"), \
					  SPAN_DANGER("You smash [src] apart!"), 5, CHAT_TYPE_XENO_COMBAT)
	return XENO_ATTACK_ACTION

/obj/structure/largecrate/ex_act(var/power)
	if(power >= EXPLOSION_THRESHOLD_VLOW)
		unpack()

/obj/structure/largecrate/mule
	icon_state = "mulecrate"

/obj/structure/largecrate/lisa
	icon_state = "lisacrate"

/obj/structure/largecrate/lisa/attackby(obj/item/W as obj, mob/user as mob)	//ugly but oh well
	if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
		new /mob/living/simple_animal/corgi/Lisa(loc)
	..()

/obj/structure/largecrate/cow
	name = "cow crate"
	icon_state = "lisacrate"

/obj/structure/largecrate/cow/attackby(obj/item/W as obj, mob/user as mob)
	if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
		new /mob/living/simple_animal/cow(loc)
	..()

/obj/structure/largecrate/goat
	name = "goat crate"
	icon_state = "lisacrate"

/obj/structure/largecrate/goat/attackby(obj/item/W as obj, mob/user as mob)
	if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
		new /mob/living/simple_animal/hostile/retaliate/goat(loc)
	..()

/obj/structure/largecrate/chick
	name = "chicken crate"
	icon_state = "lisacrate"

/obj/structure/largecrate/chick/attackby(obj/item/W as obj, mob/user as mob)
	if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
		var/num = rand(4, 6)
		for(var/i = 0, i < num, i++)
			new /mob/living/simple_animal/chick(loc)
	..()


///////////CM largecrates ///////////////////////
//Possibly the most generically named procs in history. congrats
/obj/structure/largecrate/random
	name = "supply crate"
	var/num_things = 0
	var/list/stuff = list(/obj/item/cell/high,
						/obj/item/storage/belt/utility/full,
						/obj/item/device/multitool,
						/obj/item/tool/crowbar,
						/obj/item/device/flashlight,
						/obj/item/reagent_container/food/snacks/donkpocket,
						/obj/item/explosive/grenade/smokebomb,
						/obj/item/circuitboard/airlock,
						/obj/item/device/assembly/igniter,
						/obj/item/tool/weldingtool,
						/obj/item/tool/wirecutters,
						/obj/item/device/analyzer,
						/obj/item/clothing/under/marine,
						/obj/item/clothing/shoes/marine)

/obj/structure/largecrate/random/Initialize()
	. = ..()
	if(!num_things) num_things = rand(0,3)

	for(var/i in 1 to num_things)
		var/obj/item/thing = pick(stuff)
		new thing(src)
	num_things = 0

/obj/structure/largecrate/random/mini
	name = "small crate"
	desc = "The large supply crate's cousin, 1st removed."
	icon_state = "mini_crate"
	density = 0

/obj/structure/largecrate/random/mini/chest
	desc = "A small plastic crate wrapped with securing elastic straps."
	icon_state = "mini_chest"
	name = "small chest"

/obj/structure/largecrate/random/mini/chest/b
	icon_state = "mini_chest_b"
	name = "small chest"

/obj/structure/largecrate/random/mini/chest/c
	icon_state = "mini_chest_c"
	name = "small chest"

/obj/structure/largecrate/random/mini/wooden
	desc = "A small wooden crate. Two supporting ribs cross this one's frame."
	icon_state = "mini_wooden"
	name = "wooden crate"

/obj/structure/largecrate/random/mini/small_case
	desc = "A small hard-shell case. What could be inside?"
	icon_state = "mini_case"
	name = "small case"

/obj/structure/largecrate/random/mini/small_case/b
	icon_state = "mini_case_b"
	name = "small case"

/obj/structure/largecrate/random/mini/small_case/c
	icon_state = "mini_case_c"
	name = "small case"

/obj/structure/largecrate/random/mini/ammo
	desc = "A small metal crate. Here, Freeman ammo!"
	name = "small ammocase"
	icon_state = "mini_ammo"
	stuff = list(/obj/item/ammo_magazine/pistol,
				/obj/item/ammo_magazine/revolver,
				/obj/item/ammo_magazine/rifle,
				/obj/item/ammo_magazine/rifle/extended,
				/obj/item/ammo_magazine/shotgun,
				/obj/item/ammo_magazine/shotgun/buckshot,
				/obj/item/ammo_magazine/shotgun/flechette,
				/obj/item/ammo_magazine/smg/m39,
				/obj/item/ammo_magazine/smg/m39/extended,)

/obj/structure/largecrate/random/mini/med
	desc = "A small metal crate. Here, Freeman take this medkit!" //https://www.youtube.com/watch?v=OMXan7GS8-Q
	icon_state = "mini_medcase"
	name = "small medcase"
	num_things = 1 //funny lootbox tho.
	stuff = list(/obj/item/stack/medical/bruise_pack,
				/obj/item/storage/pill_bottle/packet/tricordrazine,
				/obj/item/tool/crowbar/red,
				/obj/item/device/flashlight,
				/obj/item/reagent_container/hypospray/autoinjector/skillless,
				/obj/item/storage/pill_bottle/packet/tramadol,
				/obj/item/stack/medical/ointment,
				/obj/item/stack/medical/splint,
				/obj/item/device/healthanalyzer,
				/obj/item/stack/medical/advanced/ointment,
				/obj/item/stack/medical/advanced/bruise_pack,
				/obj/item/tool/extinguisher/mini,
				/obj/item/tool/shovel/etool,
				/obj/item/tool/screwdriver)

/obj/structure/largecrate/random/case
	name = "storage case"
	desc = "A black storage case."
	icon_state = "case"

/obj/structure/largecrate/random/case/double
	name = "cases"
	desc = "A stack of black storage cases."
	icon_state = "case_double"

/obj/structure/largecrate/random/case/double/unpack()
	if(parts_type)
		new parts_type(loc, 2)
	for(var/obj/O in contents)
		O.forceMove(loc)
	new /obj/structure/largecrate/random/case(loc)
	playsound(src, unpacking_sound, 35)
	qdel(src)

/obj/structure/largecrate/random/case/small
	name = "small cases"
	desc = "Two small black storage cases."
	icon_state = "case_small"

/obj/structure/largecrate/random/barrel
	name = "blue barrel"
	desc = "A blue storage barrel"
	icon_state = "barrel_blue"
	parts_type = /obj/item/stack/sheet/metal
	unpacking_sound = 'sound/effects/metalhit.ogg'

/obj/structure/largecrate/random/barrel/blue
	name = "blue barrel"
	desc = "A blue storage barrel"
	icon_state = "barrel_blue"

/obj/structure/largecrate/random/barrel/red
	name = "red barrel"
	desc = "A red storage barrel"
	icon_state = "barrel_red"

/obj/structure/largecrate/random/barrel/green
	name = "green barrel"
	desc = "A green storage barrel"
	icon_state = "barrel_green"

/obj/structure/largecrate/random/barrel/yellow
	name = "yellow barrel"
	desc = "A yellow storage barrel"
	icon_state = "barrel_yellow"

/obj/structure/largecrate/random/barrel/white
	name = "white barrel"
	desc = "A white storage barrel"
	icon_state = "barrel_white"

/obj/structure/largecrate/random/secure
	name = "secure supply crate"
	desc = "A secure crate."
	icon_state = "secure_crate_strapped"
	var/strapped = 1

/obj/structure/largecrate/random/secure/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if (!strapped)
		..()
		return

	if (!W.sharp)
		to_chat(user, SPAN_NOTICE("You need something sharp to cut off the straps."))
		return

	to_chat(user, SPAN_NOTICE("You begin to cut the straps off \the [src]..."))

	if (do_after(user, 15, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
		to_chat(user, SPAN_NOTICE("You cut the straps away."))
		icon_state = "secure_crate"
		strapped = 0


/obj/structure/largecrate/guns
	name = "\improper USCM firearms crate (x3)"
	var/num_guns = 3
	var/num_mags = 3
	var/list/stuff = list(
					/obj/item/weapon/gun/pistol/m4a3 = /obj/item/ammo_magazine/pistol,
					/obj/item/weapon/gun/pistol/m4a3 = /obj/item/ammo_magazine/pistol,
					/obj/item/weapon/gun/revolver/m44 = /obj/item/ammo_magazine/revolver,
					/obj/item/weapon/gun/rifle/m41a = /obj/item/ammo_magazine/rifle,
					/obj/item/weapon/gun/rifle/m41a = /obj/item/ammo_magazine/rifle,
					/obj/item/weapon/gun/shotgun/pump = /obj/item/ammo_magazine/shotgun,
					/obj/item/weapon/gun/smg/m39 = /obj/item/ammo_magazine/smg/m39,
					/obj/item/weapon/gun/smg/m39 = /obj/item/ammo_magazine/smg/m39
				)

/obj/structure/largecrate/guns/Initialize()
	. = ..()
	var/gun_type
	var/i = 0
	while(++i <= num_guns)
		gun_type = pick(stuff)
		new gun_type(src)
		var/obj/item/ammo_magazine/new_mag = stuff[gun_type]
		var/m = 0
		while(++m <= num_mags)
			new new_mag(src)

/obj/structure/largecrate/guns/russian
	num_guns = 3
	num_mags = 3
	name = "\improper Hyperdyne firearm crate"
	stuff = list(	/obj/item/weapon/gun/revolver/nagant = /obj/item/ammo_magazine/revolver/upp,
					/obj/item/weapon/gun/pistol/c99 = /obj/item/ammo_magazine/pistol/c99,
					/obj/item/weapon/gun/pistol/kt42 = /obj/item/ammo_magazine/pistol/kt42,
					/obj/item/weapon/gun/rifle/mar40 = /obj/item/ammo_magazine/rifle/mar40,
					/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40/extended,
					/obj/item/weapon/gun/rifle/sniper/svd = /obj/item/ammo_magazine/sniper/svd,
					/obj/item/weapon/gun/smg/ppsh = /obj/item/ammo_magazine/smg/ppsh
				)

/obj/structure/largecrate/guns/merc
	num_guns = 1
	num_mags = 5
	name = "\improper Black market firearm crate"
	stuff = list(	/obj/item/weapon/gun/pistol/holdout = /obj/item/ammo_magazine/pistol/holdout,
					/obj/item/weapon/gun/pistol/highpower = /obj/item/ammo_magazine/pistol/highpower,
					/obj/item/weapon/gun/pistol/m1911 = /obj/item/ammo_magazine/pistol/m1911,
					/obj/item/weapon/gun/pistol/heavy = /obj/item/ammo_magazine/pistol/heavy,
					/obj/item/weapon/gun/revolver/small = /obj/item/ammo_magazine/revolver/small,
					/obj/item/weapon/gun/revolver/cmb = /obj/item/ammo_magazine/revolver/cmb,
					/obj/item/weapon/gun/shotgun/merc = /obj/item/ammo_magazine/handful/shotgun/buckshot,
					/obj/item/weapon/gun/shotgun/pump/cmb = /obj/item/ammo_magazine/handful/shotgun/buckshot,
					/obj/item/weapon/gun/shotgun/double = /obj/item/ammo_magazine/handful/shotgun/buckshot,
					/obj/item/weapon/gun/shotgun/double/with_stock = /obj/item/ammo_magazine/handful/shotgun/buckshot,
					/obj/item/weapon/gun/smg/mp27 = /obj/item/ammo_magazine/smg/mp27,
					/obj/item/weapon/gun/pistol/skorpion = /obj/item/ammo_magazine/pistol/skorpion,
					/obj/item/weapon/gun/smg/mac15 = /obj/item/ammo_magazine/smg/mac15,
					/obj/item/weapon/gun/smg/uzi = /obj/item/ammo_magazine/smg/uzi,
					/obj/item/weapon/gun/m60 = /obj/item/ammo_magazine/m60,
					/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40,
					/obj/item/weapon/gun/smg/ppsh = /obj/item/ammo_magazine/smg/ppsh,
					/obj/item/weapon/gun/rifle/hunting = /obj/item/ammo_magazine/rifle/hunting,
					/obj/item/weapon/gun/smg/mp5 = /obj/item/ammo_magazine/smg/mp5,
					/obj/item/weapon/gun/rifle/m16 = /obj/item/ammo_magazine/rifle/m16,
					/obj/item/weapon/gun/rifle/ar10 = /obj/item/ammo_magazine/rifle/ar10,
					/obj/item/weapon/gun/rifle/type71 = /obj/item/ammo_magazine/rifle/type71,
					/obj/item/weapon/gun/smg/fp9000 = /obj/item/ammo_magazine/smg/fp9000
				)

/obj/structure/largecrate/merc/clothing
	name = "\improper Black market clothing crate"

/obj/structure/largecrate/merc/clothing/Initialize()
	. = ..()
	var/i = pick(1,5)
	switch(i)
		if(1) //pmc
			new /obj/item/clothing/under/marine/veteran/PMC(src)
			new /obj/item/clothing/head/helmet/marine/veteran/PMC(src)
			new /obj/item/clothing/suit/storage/marine/veteran/PMC(src)
			new /obj/item/clothing/gloves/marine/veteran(src)
			new /obj/item/clothing/mask/rebreather/scarf(src)
		if(2) //dutch's
			new /obj/item/clothing/head/helmet/marine/veteran/dutch(src)
			new /obj/item/clothing/under/marine/veteran/dutch(src)
			new /obj/item/clothing/suit/storage/marine/veteran/dutch(src)
			new /obj/item/clothing/gloves/marine/veteran(src)
		if(3) //pizza
			new /obj/item/clothing/under/pizza(src)
			new /obj/item/clothing/head/soft/red(src)
		if(4) //clf
			new /obj/item/clothing/under/colonist/clf(src)
			new /obj/item/clothing/suit/storage/militia(src)
			new /obj/item/clothing/head/militia(src)
			new /obj/item/clothing/gloves/marine/veteran(src)
		if(5) //freelancer
			new /obj/item/clothing/under/marine/veteran/freelancer(src)
			new /obj/item/clothing/suit/storage/marine/faction/freelancer(src)
			new /obj/item/clothing/head/cmbandana(src)
			new /obj/item/clothing/gloves/marine/veteran(src)

/obj/structure/largecrate/merc/ammo
	name = "\improper Black market ammo crate"

/datum/supply_packs/merc/ammo
	name = "Black market ammo crate"
	randomised_num_contained = 6
	contains = list(
					/obj/item/ammo_magazine/pistol/holdout,
					/obj/item/ammo_magazine/pistol/highpower,
					/obj/item/ammo_magazine/pistol/m1911,
					/obj/item/ammo_magazine/pistol/heavy,
					/obj/item/ammo_magazine/revolver/small,
					/obj/item/ammo_magazine/revolver/cmb,
					/obj/item/ammo_magazine/handful/shotgun/buckshot,
					/obj/item/ammo_magazine/smg/mp27,
					/obj/item/ammo_magazine/pistol/skorpion,
					/obj/item/ammo_magazine/smg/mac15,
					/obj/item/ammo_magazine/m60,
					/obj/item/ammo_magazine/rifle/mar40,
					/obj/item/ammo_magazine/smg/ppsh,
					/obj/item/ammo_magazine/rifle/hunting,
					/obj/item/ammo_magazine/smg/mp5,
					/obj/item/ammo_magazine/rifle/m16,
					/obj/item/ammo_magazine/handful/shotgun/heavy/buckshot,
					/obj/item/ammo_magazine/rifle/type71,
					/obj/item/ammo_magazine/smg/fp9000,
					)

/obj/structure/largecrate/hunter_games_construction
	name = "construction crate"

/obj/structure/largecrate/hunter_games_construction/Initialize()
	. = ..()
	new /obj/item/stack/sheet/metal(src, 50)
	new /obj/item/stack/sheet/glass(src, 50)
	new /obj/item/stack/sheet/plasteel(src, 50)
	new /obj/item/stack/sheet/wood(src, 50)
	new /obj/item/stack/sandbags_empty(src, 50)
	new /obj/item/storage/toolbox/mechanical(src)
	new /obj/item/storage/toolbox/mechanical(src)
	new /obj/item/storage/toolbox/electrical(src)
	new /obj/item/storage/belt/utility/full(src)
	new /obj/item/storage/belt/utility/full(src)
	new /obj/item/clothing/gloves/yellow(src)
	new /obj/item/clothing/gloves/yellow(src)
	new /obj/item/clothing/head/welding(src)
	new /obj/item/clothing/head/welding(src)
	new /obj/item/circuitboard/airlock(src)
	new /obj/item/cell/high(src)
	new /obj/item/cell/high(src)
	new /obj/item/storage/pouch/tools(src)


/obj/structure/largecrate/hunter_games_medical
	name = "medical crate"

/obj/structure/largecrate/hunter_games_medical/Initialize()
	. = ..()
	new /obj/item/clothing/glasses/hud/health(src)
	new /obj/item/clothing/glasses/hud/health(src)
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/storage/belt/medical/full(src)
	new /obj/item/storage/belt/medical/lifesaver/full(src)
	new /obj/item/storage/firstaid/regular(src)
	new /obj/item/storage/firstaid/adv(src)
	new /obj/item/storage/firstaid/o2(src)
	new /obj/item/storage/firstaid/toxin(src)
	new /obj/item/storage/firstaid/fire(src)
	new /obj/item/storage/firstaid/rad(src)
	new /obj/item/storage/pill_bottle/tramadol(src)
	new /obj/item/storage/pill_bottle/inaprovaline(src)
	new /obj/item/storage/pouch/medical(src)
	new /obj/item/storage/pouch/firstaid/full(src)
	new /obj/item/storage/box/quickclot(src)

/obj/structure/largecrate/hunter_games_surgery
	name = "surgery crate"

/obj/structure/largecrate/hunter_games_surgery/Initialize()
	. = ..()
	new /obj/item/tool/surgery/cautery(src)
	new /obj/item/tool/surgery/surgicaldrill(src)
	new /obj/item/clothing/mask/breath/medical(src)
	new /obj/item/tank/anesthetic(src)
	new /obj/item/tool/surgery/FixOVein(src)
	new /obj/item/tool/surgery/hemostat(src)
	new /obj/item/tool/surgery/scalpel(src)
	new /obj/item/tool/surgery/bonegel(src)
	new /obj/item/tool/surgery/retractor(src)
	new /obj/item/tool/surgery/bonesetter(src)
	new /obj/item/tool/surgery/circular_saw(src)
	new /obj/item/tool/surgery/surgical_line(src)
	new /obj/item/tool/surgery/scalpel/manager(src)


/obj/structure/largecrate/hunter_games_supplies
	name = "supplies crate"

/obj/structure/largecrate/hunter_games_supplies/Initialize()
	. = ..()
	new /obj/item/storage/box/m94(src)
	new /obj/item/storage/box/m94(src)
	new /obj/item/storage/pouch/general/medium(src)
	new /obj/item/storage/pouch/survival(src)
	new /obj/item/device/flashlight (src)
	new /obj/item/device/flashlight (src)
	new /obj/item/tool/crowbar/red (src)
	new /obj/item/tool/crowbar/red (src)
	new /obj/item/storage/pouch/pistol(src)
	new /obj/item/storage/pouch/magazine(src)
	new /obj/item/storage/pouch/flare(src)
	new /obj/item/storage/backpack(src)
	new /obj/item/storage/backpack/satchel(src)
	new /obj/item/storage/backpack(src)
	new /obj/item/device/radio(src)
	new /obj/item/device/radio(src)
	new /obj/item/attachable/bayonet(src)
	new /obj/item/attachable/bayonet(src)
	new /obj/item/weapon/melee/throwing_knife(src)
	new /obj/item/weapon/melee/throwing_knife(src)
	new /obj/item/storage/box/uscm_mre(src)
	new /obj/item/storage/box/donkpockets(src)
	new /obj/item/storage/box/MRE(src)
	new /obj/item/storage/box/MRE(src)
	new /obj/item/storage/box/pizza(src)


/obj/structure/largecrate/hunter_games_guns
	name = "weapons crate"

/obj/structure/largecrate/hunter_games_guns/mediocre/Initialize()
	. = ..()
	new /obj/item/weapon/gun/pistol/holdout(src)
	new /obj/item/ammo_magazine/pistol/holdout(src)
	new /obj/item/ammo_magazine/pistol/holdout(src)
	new /obj/item/weapon/gun/pistol/m4a3(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/weapon/gun/shotgun/double/with_stock(src)
	new /obj/item/ammo_magazine/shotgun(src)
	new /obj/item/weapon/gun/revolver/small(src)
	new /obj/item/ammo_magazine/revolver/small(src)
	new /obj/item/ammo_magazine/revolver/small(src)


/obj/structure/largecrate/hunter_games_guns/decent/Initialize()
	. = ..()
	new /obj/item/weapon/gun/pistol/m4a3(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)
	if(prob(50))
		new /obj/item/weapon/gun/smg/m39(src)
		new /obj/item/ammo_magazine/smg/m39(src)
		new /obj/item/ammo_magazine/smg/m39(src)
	else
		new /obj/item/weapon/gun/smg/mac15(src)
		new /obj/item/ammo_magazine/smg/mac15(src)
		new /obj/item/ammo_magazine/smg/mac15(src)
	new /obj/item/weapon/gun/shotgun/pump/cmb(src)
	new /obj/item/ammo_magazine/shotgun(src)
	new /obj/item/ammo_magazine/shotgun/buckshot(src)
	new /obj/item/weapon/gun/revolver/m44(src)
	new /obj/item/ammo_magazine/revolver(src)
	new /obj/item/ammo_magazine/revolver(src)
	new /obj/item/weapon/gun/rifle/m16(src)
	new /obj/item/ammo_magazine/rifle/m16(src)
	new /obj/item/ammo_magazine/rifle/m16(src)


/obj/structure/largecrate/hunter_games_guns/good/Initialize()
	. = ..()
	new /obj/item/weapon/gun/pistol/highpower(src)
	new /obj/item/ammo_magazine/pistol/highpower(src)
	new /obj/item/ammo_magazine/pistol/highpower(src)
	if(prob(50))
		new /obj/item/weapon/gun/rifle/m41a(src)
		new /obj/item/ammo_magazine/rifle(src)
		new /obj/item/ammo_magazine/rifle(src)
	else
		new /obj/item/weapon/gun/rifle/mar40(src)
		new /obj/item/ammo_magazine/rifle/mar40(src)
		new /obj/item/ammo_magazine/rifle/mar40(src)
	new /obj/item/weapon/gun/pistol/skorpion(src)
	new /obj/item/ammo_magazine/pistol/skorpion(src)
	new /obj/item/ammo_magazine/pistol/skorpion(src)
	new /obj/item/weapon/gun/shotgun/combat(src)
	new /obj/item/ammo_magazine/shotgun(src)
	new /obj/item/ammo_magazine/shotgun/buckshot(src)


/obj/structure/largecrate/hunter_games_ammo
	name = "ammo crate"

/obj/structure/largecrate/hunter_games_ammo/mediocre/Initialize()
	. = ..()
	new /obj/item/ammo_magazine/pistol/holdout(src)
	new /obj/item/ammo_magazine/pistol/holdout(src)
	new /obj/item/ammo_magazine/pistol/holdout(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/shotgun(src)
	new /obj/item/ammo_magazine/revolver/small(src)
	new /obj/item/ammo_magazine/revolver/small(src)

/obj/structure/largecrate/hunter_games_ammo/decent/Initialize()
	. = ..()
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/pistol(src)
	new /obj/item/ammo_magazine/smg/m39(src)
	new /obj/item/ammo_magazine/smg/m39(src)
	new /obj/item/ammo_magazine/smg/mac15(src)
	new /obj/item/ammo_magazine/smg/mac15(src)
	new /obj/item/ammo_magazine/shotgun(src)
	new /obj/item/ammo_magazine/shotgun/buckshot(src)
	new /obj/item/ammo_magazine/revolver(src)
	new /obj/item/ammo_magazine/revolver(src)
	new /obj/item/ammo_magazine/rifle/m16(src)
	new /obj/item/ammo_magazine/rifle/m16(src)

/obj/structure/largecrate/hunter_games_ammo/good/Initialize()
	. = ..()
	new /obj/item/ammo_magazine/pistol/highpower(src)
	new /obj/item/ammo_magazine/pistol/highpower(src)
	new /obj/item/ammo_magazine/rifle(src)
	new /obj/item/ammo_magazine/rifle(src)
	new /obj/item/ammo_magazine/rifle/mar40(src)
	new /obj/item/ammo_magazine/rifle/mar40(src)
	new /obj/item/ammo_magazine/pistol/skorpion(src)
	new /obj/item/ammo_magazine/pistol/skorpion(src)
	new /obj/item/ammo_magazine/shotgun(src)
	new /obj/item/ammo_magazine/shotgun/buckshot(src)





/obj/structure/largecrate/hunter_games_armors
	name = "armors crate"

/obj/structure/largecrate/hunter_games_armors/Initialize()
	. = ..()
	new /obj/item/clothing/gloves/marine(src)
	new /obj/item/clothing/gloves/marine(src)
	new /obj/item/clothing/gloves/marine(src)
	new /obj/item/clothing/head/helmet(src)
	new /obj/item/clothing/head/helmet(src)
	new /obj/item/clothing/head/helmet/riot(src)
	new /obj/item/clothing/shoes/combat(src)
	new /obj/item/clothing/shoes/combat(src)
	new /obj/item/clothing/shoes/combat(src)
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/clothing/suit/armor/bulletproof(src)
	new /obj/item/weapon/shield/riot(src)
