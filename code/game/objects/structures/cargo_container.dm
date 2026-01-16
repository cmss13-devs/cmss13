/obj/structure/cargo_container
	name = "Cargo Container"
	desc = "A huge industrial shipping container.\nYou aren't supposed to see this."
	icon = 'icons/obj/structures/props/containers/contain.dmi'
	bound_width = 32
	bound_height = 64
	density = TRUE
	health = 200
	opacity = TRUE
	anchored = TRUE
	///multiples any demage taken from bullets
	var/bullet_damage_multiplier = 0.2
	///multiples any demage taken from explosion
	var/explosion_damage_multiplier = 2

/obj/structure/cargo_container/bullet_act(obj/projectile/projectile)
	. = ..()
	update_health(projectile.damage * bullet_damage_multiplier)

/obj/structure/cargo_container/attack_alien(mob/living/carbon/xenomorph/xenomorph)
	. = ..()
	var/damage = ((floor((xenomorph.melee_damage_lower + xenomorph.melee_damage_upper)/2)) )

	//Frenzy bonus
	if(xenomorph.frenzy_aura > 0)
		damage += (xenomorph.frenzy_aura * FRENZY_DAMAGE_MULTIPLIER)

	xenomorph.animation_attack_on(src)

	xenomorph.visible_message(SPAN_DANGER("[xenomorph] slashes [src]!"),
	SPAN_DANGER("You slash [src]!"))

	update_health(damage)

	return XENO_ATTACK_ACTION

/obj/structure/cargo_container/ex_act(severity, direction)
	. = ..()
	update_health(severity * explosion_damage_multiplier)

//Note, for Watatsumi, Grant, and Arious, "left" and "leftmid" are both the left end of the container, but "left" is generic and "leftmid" has the Sat Mover mark on it
/obj/structure/cargo_container/watatsumi
	name = "Watatsumi Cargo Container"
	desc = "A huge industrial shipping container.\nThis one is from Watatsumi, a manufacturer of a variety of electronical and mechanical products.\nAt least, that is what is says on the container. You have literally never heard of this company before."

/obj/structure/cargo_container/watatsumi/left
	icon_state = "watatsumi_l"

/obj/structure/cargo_container/watatsumi/leftmid
	icon_state = "watatsumi_lm"

/obj/structure/cargo_container/watatsumi/mid
	icon_state = "watatsumi_m"

/obj/structure/cargo_container/watatsumi/rightmid
	icon_state = "watatsumi_rm"

/obj/structure/cargo_container/watatsumi/right
	icon_state = "watatsumi_r"

/obj/structure/cargo_container/grant
	name = "Grant Corporation Cargo Container"
	desc = "A huge industrial shipping container.\nThis one is from The Grant Corporation, a manufacturer of medical and biotechnological parts.\nYou remember hearing about one of their latest drugs, and how dangerous it was... though they claimed to be close to finding a solution."

/obj/structure/cargo_container/grant/left
	icon_state = "grant_l"

/obj/structure/cargo_container/grant/leftmid
	icon_state = "grant_lm"

/obj/structure/cargo_container/grant/rightmid
	icon_state = "grant_rm"

/obj/structure/cargo_container/grant/right
	icon_state = "grant_r"

/obj/structure/cargo_container/arious
	name = "Arious Cargo Container"
	desc = "A huge industrial shipping container.\nThis one is from Arious, a computer parts and motion detector manufacturer.\nYou still wonder why we have a container of old Motion Detectors, and if they even still work."

/obj/structure/cargo_container/arious/left
	icon_state = "arious_l"

/obj/structure/cargo_container/arious/leftmid
	icon_state = "arious_lm"

/obj/structure/cargo_container/arious/mid
	icon_state = "arious_m"

/obj/structure/cargo_container/arious/rightmid
	icon_state = "arious_rm"

/obj/structure/cargo_container/arious/right
	icon_state = "arious_r"

/obj/structure/cargo_container/wy
	name = "Weyland-Yutani Cargo Container"
	desc = "A huge industrial shipping container.\nThis one is from The Weyland-Yutani Corporation, you have probably heard of them before."

/obj/structure/cargo_container/wy/left
	icon_state = "wy_l"

/obj/structure/cargo_container/wy/mid
	icon_state = "wy_m"

/obj/structure/cargo_container/wy/right
	icon_state = "wy_r"

/obj/structure/cargo_container/wy2
	name = "Weyland-Yutani Cargo Container"
	desc = "A huge industrial shipping container.\nThis one is from The Weyland-Yutani Corporation, you have probably heard of them before."

/obj/structure/cargo_container/wy2/left
	icon_state = "wy2_l"

/obj/structure/cargo_container/wy2/mid
	icon_state = "wy2_m"

/obj/structure/cargo_container/wy2/right
	icon_state = "wy2_r"

/obj/structure/cargo_container/armat
	name = "ARMAT Cargo Container"
	desc = "A large industrial container. This one is from ARMAT, the defense contractors behind the M41A and other marine weaponry."

/obj/structure/cargo_container/armat/left
	icon_state = "armat_l"

/obj/structure/cargo_container/armat/mid
	icon_state = "armat_m"

/obj/structure/cargo_container/armat/right
	icon_state = "armat_r"

/obj/structure/cargo_container/hd
	name = "Hyperdyne Systems Cargo Container"
	desc = "A huge industrial shipping container.\nThis one is from Hyperdyne Systems, a manufacturer of synthetics, prosthetics, and weapons.\nWe don't speak about their former affiliations with the UPP."

/obj/structure/cargo_container/hd/left
	icon_state = "hd_l"

/obj/structure/cargo_container/hd/left/alt
	icon_state = "hd_l_alt"

/obj/structure/cargo_container/hd/mid
	icon_state = "hd_m"

/obj/structure/cargo_container/hd/mid/alt
	icon_state = "hd_m_alt"

/obj/structure/cargo_container/hd/right
	icon_state = "hd_r"

/obj/structure/cargo_container/hd/right/alt
	icon_state = "hd_r_alt"

/obj/structure/cargo_container/trijent
	name = "Trijent Corporation Cargo Container"
	desc = "A huge industrial shipping container.\nThis one is from The Trijent Corporation's mining operations.\nIf this breaks open, you figure you probably shouldn't breathe in what's inside."

/obj/structure/cargo_container/trijent/left
	icon_state = "trijent_l"

/obj/structure/cargo_container/trijent/left/alt
	icon_state = "trijent_l_alt"

/obj/structure/cargo_container/trijent/mid
	icon_state = "trijent_m"

/obj/structure/cargo_container/trijent/mid/alt
	icon_state = "trijent_m_alt"

/obj/structure/cargo_container/trijent/right
	icon_state = "trijent_r"

/obj/structure/cargo_container/trijent/right/alt
	icon_state = "trijent_r_alt"

/obj/structure/cargo_container/kelland //The container formerly known as 'gorg'
	name = "Kelland Mining Company Cargo Container"
	desc = "A small industrial shipping container.\nYou haven't heard much about Kelland Mining, besides the incident at LV-178's mining operation."
	bound_height = 32 //It's smaller than the rest
	layer = ABOVE_XENO_LAYER //Due to size, needs to be above player and xenos

/obj/structure/cargo_container/kelland/left
	icon_state = "kelland_l"

/obj/structure/cargo_container/kelland/right
	icon_state = "kelland_r"

/obj/structure/cargo_container/ferret
	name = "Ferret Heavy Industries Cargo Container"
	desc = "A huge industrial shipping container.\nThis one is from Ferret Heavy Industries, a manufacturer of terrestrial crawlers and powerloaders.\nUnfortunately, the company went bankrupt. Fortunately, these containers are really cheap now."

/obj/structure/cargo_container/ferret/left
	icon_state = "ferret_l"

/obj/structure/cargo_container/ferret/mid
	icon_state = "ferret_m"

/obj/structure/cargo_container/ferret/right
	icon_state = "ferret_r"

/obj/structure/cargo_container/lockmart
	name = "Lockmart Corporation Cargo Container"
	desc = "A huge industrial shipping container.\nThis one is from Lockheed Martin, a manufacturer of spaceships and spaceship parts.\nThey made the USCSS Nostromo... whatever happened to that ship, anyways?"

/obj/structure/cargo_container/lockmart/left
	icon_state = "lockmart_l"

/obj/structure/cargo_container/lockmart/mid
	icon_state = "lockmart_m"

/obj/structure/cargo_container/lockmart/right
	icon_state = "lockmart_r"

/obj/structure/cargo_container/seegson
	name = "Seegson Corporation Cargo Container"
	desc = "A huge industrial shipping container.\nThis one is from Seegson, they makes just about anything and everything.\nYou notice this container has a peeling note on it, saying all contents were transferred from another station decades ago, how long has it been here?"

/obj/structure/cargo_container/seegson/left
	icon_state = "seegson_l"

/obj/structure/cargo_container/seegson/mid
	icon_state = "seegson_m"

/obj/structure/cargo_container/seegson/right
	icon_state = "seegson_r"

/obj/structure/cargo_container/attack_hand(mob/user as mob)

	playsound(loc, 'sound/effects/clang.ogg', 25, 1)

	var/damage_dealt
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))

			user.visible_message(SPAN_WARNING("[user] smashes [src] to no avail."),
					SPAN_WARNING("You beat against [src] to no effect"),
					"You hear twisting metal.")

	if(!damage_dealt)
		user.visible_message(SPAN_WARNING("[user] beats against the [src] to no avail."),
					SPAN_WARNING("[user] beats against the [src]."),
					"You hear twisting metal.")

/obj/structure/cargo_container/horizontal
	name = "Cargo Container"
	desc = "A huge industrial shipping container."
	icon = 'icons/obj/structures/props/containers/containHorizont.dmi'
	bound_width = 64
	bound_height = 32
	density = TRUE
	health = 200
	opacity = TRUE

/obj/structure/cargo_container/horizontal/blue
	name = "Generic Cargo Container"
	desc = "A huge industrial shipping container.\nDespite the logo clearly being on the side, you cannot see it, as the logo is not facing south."

/obj/structure/cargo_container/horizontal/blue/top
	icon_state = "blue_t"

/obj/structure/cargo_container/horizontal/blue/middle
	icon_state = "blue_m"

/obj/structure/cargo_container/horizontal/blue/bottom
	icon_state = "blue_b"

/obj/structure/cargo_container/canc
	name = "CANC Cargo Container"
	desc = "A huge industrial shipping container.\nThis one is from the Chinese/Asian–Nation Cooperative, which was absorded into the UPP. Their massive industrial output has ensured that cargo containers bearing their symbols and name won't be disappearing any time soon."

/obj/structure/cargo_container/canc/left
	icon_state = "canc_g_l"

/obj/structure/cargo_container/canc/mid
	icon_state = "canc_g_m"

/obj/structure/cargo_container/canc/right
	icon_state = "canc_g_r"

/obj/structure/cargo_container/canc/tan
	name = "CANC Cargo Container"
	desc = "A huge industrial shipping container.\nThis one is from the Chinese/Asian–Nation Cooperative, which was absorded into the UPP. Their massive industrial output has ensured that cargo containers bearing their symbols and name won't be disappearing any time soon."

/obj/structure/cargo_container/canc/tan/left
	icon_state = "canc_t_l"

/obj/structure/cargo_container/canc/tan/mid
	icon_state = "canc_t_m"

/obj/structure/cargo_container/canc/tan/right
	icon_state = "canc_t_r"

/obj/structure/cargo_container/upp
	name = "UPP Cargo Container"
	desc = "A huge industrial shipping container.\nThis one is from the Union of Progressive Peoples, as indicated by the massive symbol on the side."

/obj/structure/cargo_container/upp/left
	icon_state = "upp_l"

/obj/structure/cargo_container/upp/mid
	icon_state = "upp_m"

/obj/structure/cargo_container/upp/right
	icon_state = "upp_r"

/obj/structure/cargo_container/upp/tan
	name = "UPP Cargo Container"
	desc = "A huge industrial shipping container.\nThis one is from the Union of Progressive Peoples, as indicated by the massive symbol on the side."

/obj/structure/cargo_container/upp/tan/left
	icon_state = "upp_t_l"

/obj/structure/cargo_container/upp/tan/mid
	icon_state = "upp_t_m"

/obj/structure/cargo_container/upp/tan/right
	icon_state = "upp_t_r"

/obj/structure/cargo_container/upp/mk6
	name = "Ministry of Space Security Cargo Container"
	desc = "A huge industrial shipping container.\nThis one belongs to the UPP's Ministry of Space Security."

/obj/structure/cargo_container/upp/mk6/left
	icon_state = "mk6_l"

/obj/structure/cargo_container/upp/mk6/mid
	icon_state = "mk6_m"

/obj/structure/cargo_container/upp/mk6/right
	icon_state = "mk6_r"

/obj/structure/cargo_container/uscm
	name = "United States Colonial Marines Cargo Container"
	desc = "A huge industrial shipping container.\nThis one belongs to the UA's United States Marine Corps."

/obj/structure/cargo_container/uscm/sanfran/left
	name = "United States Colonial Marines Cargo Container"

	icon_state = "uscm1_l"

/obj/structure/cargo_container/uscm/sanfran/mid
	icon_state = "uscm1_m"

/obj/structure/cargo_container/uscm/borodino/left
	name = "United States Colonial Marines Cargo Container"

	icon_state = "uscm2_l"

/obj/structure/cargo_container/uscm/borodino/mid
	icon_state = "uscm2_m"

/obj/structure/cargo_container/uscm/tartarus/left
	name = "United States Colonial Marines Cargo Container"

	icon_state = "uscm3_l"

/obj/structure/cargo_container/uscm/tartarus/mid
	icon_state = "uscm3_m"

/obj/structure/cargo_container/uscm/chinook/left
	name = "United States Colonial Marines Cargo Container"

	icon_state = "uscm4_l"

/obj/structure/cargo_container/uscm/chinook/mid
	icon_state = "uscm4_m"

/obj/structure/cargo_container/uscm/crestus/left
	name = "United States Colonial Marines Cargo Container"

	icon_state = "uscm5_l"

/obj/structure/cargo_container/uscm/crestus/mid
	icon_state = "uscm5_m"

/obj/structure/cargo_container/uscm/micor/left
	name = "United States Colonial Marines Cargo Container"

	icon_state = "uscm6_l"

/obj/structure/cargo_container/uscm/mid
	icon_state = "uscm_m"

/obj/structure/cargo_container/uscm/right
	icon_state = "uscm_r"

/obj/structure/cargo_container/upp_small
	name = "UPP Cargo Container"
	desc = "A small industrial shipping container.\nThis one is from the Union of Progressive Peoples, as indicated by the red star symbol on the side."
	bound_height = 32
	layer = ABOVE_XENO_LAYER

/obj/structure/cargo_container/upp_small/container_1/left
	icon_state = "upp_1_l"

/obj/structure/cargo_container/upp_small/container_1/right
	icon_state = "upp_1_r"

/obj/structure/cargo_container/upp_small/container_2/left
	icon_state = "upp_2_l"

/obj/structure/cargo_container/upp_small/container_2/right
	icon_state = "upp_2_r"

/obj/structure/cargo_container/upp_small/container_3/left
	icon_state = "upp_3_l"

/obj/structure/cargo_container/upp_small/container_3/right
	icon_state = "upp_3_r"

/obj/structure/cargo_container/upp_small/container_4/left
	icon_state = "upp_4_l"

/obj/structure/cargo_container/upp_small/container_4/right
	icon_state = "upp_4_r"

/obj/structure/cargo_container/upp_small/container_5/left
	icon_state = "upp_5_l"

/obj/structure/cargo_container/upp_small/container_5/right
	icon_state = "upp_5_r"

/obj/structure/cargo_container/upp_small/container_6/left
	icon_state = "upp_6_l"

/obj/structure/cargo_container/upp_small/container_6/right
	icon_state = "upp_6_r"

/obj/structure/cargo_container/upp_small/container_7/left
	icon_state = "upp_7_l"

/obj/structure/cargo_container/upp_small/container_7/right
	icon_state = "upp_7_r"

/obj/structure/cargo_container/upp_small/container_8/left
	icon_state = "upp_8_l"

/obj/structure/cargo_container/upp_small/container_8/right
	icon_state = "upp_8_r"

/obj/structure/cargo_container/upp_small/container_9/left
	icon_state = "upp_9_l"

/obj/structure/cargo_container/upp_small/container_9/right
	icon_state = "upp_9_r"

/obj/structure/cargo_container/upp_small/container_10/left
	icon_state = "upp_10_l"

/obj/structure/cargo_container/upp_small/container_10/right
	icon_state = "upp_10_r"

/obj/structure/cargo_container/upp_small/container_11/left
	icon_state = "upp_11_l"

/obj/structure/cargo_container/upp_small/container_11/right
	icon_state = "upp_11_r"

/obj/structure/cargo_container/upp_small/container_12/left
	icon_state = "upp_12_l"

/obj/structure/cargo_container/upp_small/container_12/right
	icon_state = "upp_12_r"

/obj/structure/cargo_container/upp_small/container_13/left
	icon_state = "upp_13_l"

/obj/structure/cargo_container/upp_small/container_13/right
	icon_state = "upp_13_r"

/obj/structure/cargo_container/upp_small/container_14/left
	icon_state = "upp_14_l"

/obj/structure/cargo_container/upp_small/container_14/right
	icon_state = "upp_14_r"

/obj/structure/cargo_container/upp_small/container_15/left
	icon_state = "upp_15_l"

/obj/structure/cargo_container/upp_small/container_15/right
	icon_state = "upp_15_r"

/obj/structure/cargo_container/upp_small/container_16/left
	icon_state = "upp_16_l"

/obj/structure/cargo_container/upp_small/container_16/right
	icon_state = "upp_16_r"

/obj/structure/cargo_container/upp_small/container_17/left
	icon_state = "upp_17_l"

/obj/structure/cargo_container/upp_small/container_17/right
	icon_state = "upp_17_r"

/obj/structure/cargo_container/upp_small/container_18/left
	icon_state = "upp_18_l"

/obj/structure/cargo_container/upp_small/container_18/right
	icon_state = "upp_18_r"

/obj/structure/cargo_container/upp_small/container_19/left
	icon_state = "upp_19_l"

/obj/structure/cargo_container/upp_small/container_19/right
	icon_state = "upp_19_r"

/obj/structure/cargo_container/upp_small/container_20/left
	icon_state = "upp_20_l"

/obj/structure/cargo_container/upp_small/container_20/right
	icon_state = "upp_20_r"
