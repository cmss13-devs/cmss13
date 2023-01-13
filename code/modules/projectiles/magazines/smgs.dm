/obj/item/ammo_magazine/smg
	name = "\improper default SMG magazine"
	desc = "A submachinegun magazine."
	item_state = "generic_mag"
	default_ammo = /datum/ammo/bullet/smg
	max_rounds = 30

//-------------------------------------------------------
//M39 SMG ammo

/obj/item/ammo_magazine/smg/m39
	name = "\improper M39 HV magazine (10x20mm)"
	desc = "A 10x20mm caseless high-velocity submachinegun magazine. Powerful propellant allows the bullet increased velocity and minor penetration capabilities, noticeably improving its efficacy at medium ranges, although it still suffers significantly compared to a rifle bullet."
	caliber = "10x20mm"
	icon_state = "m39_HV"
	max_rounds = 48
	w_class = SIZE_MEDIUM
	gun_type = /obj/item/weapon/gun/smg/m39
	default_ammo = /datum/ammo/bullet/smg/m39

/obj/item/ammo_magazine/smg/m39/ap
	name = "\improper M39 AP magazine (10x20mm)"
	desc = "A 10x20mm caseless armor-piercing submachinegun magazine. The bullet tips are made out of high-density material, allowing them to pierce straight through armor, but also reducing the raw stopping power and velocity of the ammunition."
	icon_state = "m39_AP"
	default_ammo = /datum/ammo/bullet/smg/ap

/obj/item/ammo_magazine/smg/m39/le
	name = "\improper M39 LE magazine (10x20mm)"
	desc = "A 10x20mm caseless light-explosive submachinegun magazine containing special light explosive rounds, designed to rapidly decimate armor, at the cost of vastly reduced damage and penetration."
	icon_state = "m39_le"
	default_ammo = /datum/ammo/bullet/smg/le

/obj/item/ammo_magazine/smg/m39/rubber
	name = "\improper M39 rubber magazine (10x20mm)"
	desc = "A 10x20mm caseless rubber bullet submachinegun magazine, containing rubber bullets. Non-lethal, but terrible on bioforms."
	icon_state = "m39_le"
	default_ammo = /datum/ammo/bullet/smg/rubber

/obj/item/ammo_magazine/smg/m39/heap
	name = "\improper M39 HEAP magazine (10x20mm)"
	desc = "A 10x20mm caseless armor-piercing high-explosive submachinegun magazine. The bullet tips are made out of a special explosive, designed to penetrate armor then detonate for maximum soft-tissue damage."
	icon_state = "m39_heap"
	default_ammo = /datum/ammo/bullet/smg/heap

/obj/item/ammo_magazine/smg/m39/penetrating
	name = "\improper M39 wall-piercing magazine (10x20mm)"
	desc = "A 10x20mm caseless wall-piercing bullet submachinegun magazine, containing wall-piercing bullets. Designed to penetrate straight through objects and walls."
	icon_state = "m39_penetrating"
	default_ammo = /datum/ammo/bullet/smg/ap/penetrating

/obj/item/ammo_magazine/smg/m39/cluster
	name = "\improper M39 cluster magazine (10x20mm)"
	desc = "A 10x20mm caseless cluster bullet submachinegun magazine, containing cluster bullets. Designed to attach tiny explosives to targets, to detonate all at once if enough hit."
	icon_state = "m39_cluster"
	default_ammo = /datum/ammo/bullet/smg/ap/cluster

/obj/item/ammo_magazine/smg/m39/toxin
	name = "\improper M39 toxin magazine (10x20mm)"
	desc = "A 10x20mm caseless toxin bullet submachinegun magazine, containing toxin bullets. Great at stripping away armour and destroying biological structures."
	icon_state = "m39_toxin"
	default_ammo = /datum/ammo/bullet/smg/ap/toxin

/obj/item/ammo_magazine/smg/m39/incendiary
	name = "\improper M39 incendiary magazine (10x20mm)"
	desc = "A 10x20mm caseless incendiary submachinegun magazine. Incendiary payload sets targets ablaze, but causes the gun to have low stopping power and strongly decreased accuracy."
	icon_state = "m39_incendiary"
	default_ammo = /datum/ammo/bullet/smg/incendiary

/obj/item/ammo_magazine/smg/m39/extended
	name = "\improper M39 HV extended magazine (10x20mm)"
	desc = "A 10x20mm caseless HV extended submachinegun magazine. Powerful propellant allows the bullet increased travel speed and minor penetration capabilities, noticeably improving its efficacy at long ranges, although it still suffers significantly compared to a rifle bullet."
	max_rounds = 72
	icon_state = "m39_HV_extended"
	bonus_overlay = "m39_ex"


//-------------------------------------------------------
//M5, a classic SMG used in a lot of action movies.

/obj/item/ammo_magazine/smg/mp5
	name = "\improper MP5 magazine (9mm)"
	desc = "A 9mm magazine for the MP5."
	default_ammo = /datum/ammo/bullet/smg
	caliber = "9mm"
	icon_state = "mp5"
	gun_type = /obj/item/weapon/gun/smg/mp5
	max_rounds = 30 //Also comes in 10 and 40.


//-------------------------------------------------------
//MP27, based on the MP27, based on the M7.

/obj/item/ammo_magazine/smg/mp27
	name = "\improper MP27 magazine (4.6x30mm)"
	desc = "A 4.6mm magazine for the MP27. Fires large, heavy bullets that have noticeable punch for an SMG but also have equally noticeable scatter and a loss of accuracy."
	default_ammo = /datum/ammo/bullet/smg/mp27
	caliber = "4.6x30mm"
	icon_state = "mp7_30"
	gun_type = /obj/item/weapon/gun/smg/mp27
	max_rounds = 30 //Also comes in 20 and 40.
	bonus_overlay = "mp7_30_overlay"
	var/random_magazine = TRUE

/obj/item/ammo_magazine/smg/mp27/Initialize(mapload, spawn_empty)
	. = ..()
	if(random_magazine)
		var/capacity = pick(20, 30, 40)
		name = "\improper MP27 [capacity]-round magazine (4.6x30mm)"
		desc = "A [capacity]-round 4.6mm magazine for the MP27. Fires large, heavy bullets that have noticeable punch for an SMG but also have equally noticeable scatter and a loss of accuracy. Due to a factory blueprint mixup, 20, 30, and 40-round magazines were all manufactured and sold in the same boxes, leading to a class act lawsuit that bankrupted the company."
		caliber = "4.6x30mm"
		base_mag_icon = "mp7_[capacity]"
		icon_state = "mp7_[capacity]"
		bonus_overlay = "mp7_[capacity]_overlay"
		current_rounds = capacity
		max_rounds = capacity
		random_magazine = FALSE

//-------------------------------------------------------
//PPSH //Based on the PPSh-41.

#define PPSH_STICK_MAGAZINE_JAM_CHANCE 0.1
#define PPSH_DRUM_MAGAZINE_JAM_CHANCE 1

/obj/item/ammo_magazine/smg/ppsh
	name = "\improper PPSh-17b stick magazine (7.62x25mm)"
	desc = "A stick magazine for the PPSh submachinegun. Less ammo than the iconic drum magazine, but the latter causes feeding and handling issues. Your call which one's better."
	caliber = "7.62x25mm"
	icon_state = "ppsh17b_stick"
	bonus_overlay = "ppsh17b_stick_overlay"
	max_rounds = 35
	gun_type = /obj/item/weapon/gun/smg/ppsh
	default_ammo = /datum/ammo/bullet/smg/ppsh
	var/bonus_mag_aim_slowdown = 0
	var/bonus_mag_wield_delay = 0
	var/jam_chance = PPSH_STICK_MAGAZINE_JAM_CHANCE
	var/new_item_state = "ppsh17b"


/obj/item/ammo_magazine/smg/ppsh/extended
	name = "\improper PPSh-17b drum magazine (7.62x25mm)"
	desc = "The iconic PPSh-17b drum magazine. Carries double the amount of bullets than the stick version, but may cause handling and feeding issues. Your call which one's better."
	icon_state = "ppsh17b_drum"
	bonus_overlay = "ppsh17b_drum_overlay"
	max_rounds = 71
	w_class = SIZE_MEDIUM
	bonus_mag_aim_slowdown = SLOWDOWN_ADS_QUICK_MINUS
	bonus_mag_wield_delay = WIELD_DELAY_VERY_FAST
	jam_chance = PPSH_DRUM_MAGAZINE_JAM_CHANCE
	new_item_state = "ppsh17b_d"

#undef PPSH_STICK_MAGAZINE_JAM_CHANCE
#undef PPSH_DRUM_MAGAZINE_JAM_CHANCE

//-------------------------------------------------------
//GENERIC UZI //Based on the uzi submachinegun, of course.

/obj/item/ammo_magazine/smg/mac15 //Based on the Uzi.
	name = "\improper MAC-15 magazine (9mm)"
	desc = "A magazine for the MAC-15."
	caliber = "9mm"
	icon_state = "mac15"
	max_rounds = 25 //Can also be 20, 25, 40, and 50.
	gun_type = /obj/item/weapon/gun/smg/mac15

/obj/item/ammo_magazine/smg/mac15/extended
	name = "\improper MAC-15 extended magazine (9mm)"
	icon_state = "mac15_extended"
	bonus_overlay = "mac15_ext"
	max_rounds = 50

//-------------------------------------------------------
// the real UZI

#define UZI_NORMAL_MAGAZINE_JAM_CHANCE 0
#define UZI_EXTENDED_MAGAZINE_JAM_CHANCE 1

/obj/item/ammo_magazine/smg/uzi
	name = "\improper UZI magazine (9x21mm)"
	desc = "A magazine for the UZI. Seems pretty small, huh? Anything larger caused feeding errors."
	caliber = "9x12mm"
	icon_state = "uzi"
	max_rounds = 25
	gun_type = /obj/item/weapon/gun/smg/uzi
	var/jam_chance = UZI_NORMAL_MAGAZINE_JAM_CHANCE

/obj/item/ammo_magazine/smg/uzi/extended
	name = "\improper UZI extended magazine (9x21mm)"
	desc = "A slightly extended magazine for the UZI. Due to its size, it may or may not cause feeding errors."
	icon_state = "uzi_extended"
	bonus_overlay = "uzi_ext"
	max_rounds = 32
	jam_chance = UZI_EXTENDED_MAGAZINE_JAM_CHANCE

#undef UZI_NORMAL_MAGAZINE_JAM_CHANCE
#undef UZI_EXTENDED_MAGAZINE_JAM_CHANCE

//-------------------------------------------------------
//FP9000 //Based on the FN P90

/obj/item/ammo_magazine/smg/fp9000
	name = "FN FP9000 magazine (5.7x28mm)"
	desc = "A magazine for the FN FP9000 SMG."
	default_ammo = /datum/ammo/bullet/smg/ap
	caliber = "5.7x28mm"
	icon_state = "fp9000"
	w_class = SIZE_MEDIUM
	max_rounds = 50
	gun_type = /obj/item/weapon/gun/smg/fp9000

//-------------------------------------------------------
//Nailgun!
/obj/item/ammo_magazine/smg/nailgun
	name = "nailgun magazine (7x45mm)"
	desc = "A large magazine of oversized plasteel nails. Unfortunately, the production cost of those nail makes them ill-affordable for most military projects, and only some specific construction projects requires them."
	default_ammo = /datum/ammo/bullet/smg/nail
	flags_magazine = NO_FLAGS // Let's not start messing with nails...
	caliber = "7x45mm"
	icon_state = "nailgun"
	w_class = SIZE_SMALL
	max_rounds = 48
	gun_type = /obj/item/weapon/gun/smg/nailgun
