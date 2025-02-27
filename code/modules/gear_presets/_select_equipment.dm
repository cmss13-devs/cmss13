#define EQUIPMENT_PRESET_STUB 0
#define EQUIPMENT_PRESET_START_OF_ROUND (1<<0)
#define EQUIPMENT_PRESET_EXTRA (1<<1)
#define EQUIPMENT_PRESET_START_OF_ROUND_WO (1<<2)
#define EQUIPMENT_PRESET_MARINE (1<<3)

/datum/equipment_preset
	var/name = "Preset"
	var/flags = EQUIPMENT_PRESET_STUB
	var/uses_special_name = FALSE //For equipment that loads special name, aka Synths, Yautja, Death Squad, etc.

	var/list/languages = list(LANGUAGE_ENGLISH)
	var/skills
	var/idtype = /obj/item/card/id
	var/list/access = list()
	var/assignment
	var/rank
	var/list/paygrades = list("???")
	var/role_comm_title
	var/minimum_age
	var/faction = FACTION_NEUTRAL
	var/list/faction_group
	var/origin_override

	var/minimap_icon = "private"
	var/minimap_background = "background"
	var/always_minimap_visible = TRUE

	//Uniform data
	var/utility_under = null
	var/utility_over = null
	var/utility_gloves = null
	var/utility_shoes = null
	var/utility_hat = null
	var/utility_extra = null

	var/service_under = null
	var/service_over = null
	var/service_shoes = null
	var/service_hat = null
	var/service_gloves = null
	var/service_extra = null

	var/dress_under = null
	var/dress_over = null
	var/dress_shoes = null
	var/dress_hat = null
	var/dress_gloves = null
	var/dress_extra = null

	var/list/uniform_sets = null



/datum/equipment_preset/New()
	uniform_sets = list(
		UNIFORM_VEND_UTILITY_UNIFORM = utility_under,
		UNIFORM_VEND_UTILITY_JACKET = utility_over,
		UNIFORM_VEND_UTILITY_HEAD = utility_hat,
		UNIFORM_VEND_UTILITY_GLOVES = utility_gloves,
		UNIFORM_VEND_UTILITY_SHOES = utility_shoes,
		UNIFORM_VEND_UTILITY_EXTRA = utility_extra,

		UNIFORM_VEND_SERVICE_UNIFORM = service_under,
		UNIFORM_VEND_SERVICE_JACKET = service_over,
		UNIFORM_VEND_SERVICE_HEAD = service_hat,
		UNIFORM_VEND_SERVICE_GLOVES = service_gloves,
		UNIFORM_VEND_SERVICE_SHOES = service_shoes,
		UNIFORM_VEND_SERVICE_EXTRA = service_extra,

		UNIFORM_VEND_DRESS_UNIFORM = dress_under,
		UNIFORM_VEND_DRESS_JACKET = dress_over,
		UNIFORM_VEND_DRESS_HEAD = dress_hat,
		UNIFORM_VEND_DRESS_GLOVES = dress_gloves,
		UNIFORM_VEND_DRESS_SHOES = dress_shoes,
		UNIFORM_VEND_DRESS_EXTRA = dress_extra
	)

	if(!faction_group)
		faction_group = list(faction)

	//load_appearance()
/datum/equipment_preset/proc/load_race(mob/living/carbon/human/new_human, client/mob_client)
	return

/datum/equipment_preset/proc/load_name(mob/living/carbon/human/new_human, randomise, client/mob_client)
	new_human.gender = pick(60;MALE,40;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(new_human)
	var/random_name = capitalize(pick(new_human.gender == MALE ? GLOB.first_names_male : GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(21,45)

/datum/equipment_preset/proc/load_age(mob/living/carbon/human/new_human, client/mob_client)
	if(minimum_age && new_human.age < minimum_age)
		new_human.age = minimum_age

/datum/equipment_preset/proc/load_rank(mob/living/carbon/human/new_human, client/mob_client)//Beagle-Code
	if(paygrades.len == 1)
		return paygrades[1]
	var/playtime
	if(!mob_client || new_human.client != mob_client)
		playtime = JOB_PLAYTIME_TIER_1
	else
		playtime = get_job_playtime(mob_client, rank)
		if((playtime >= JOB_PLAYTIME_TIER_1) && !mob_client.prefs.playtime_perks)
			playtime = JOB_PLAYTIME_TIER_1
	var/final_paygrade
	for(var/current_paygrade as anything in paygrades)
		var/required_time = paygrades[current_paygrade]
		if(required_time - playtime > 0)
			break
		final_paygrade = current_paygrade
	if(rank == JOB_SQUAD_MARINE && final_paygrade == PAY_SHORT_ME3)
		if(GLOB.data_core.leveled_riflemen > GLOB.data_core.leveled_riflemen_max)
			return PAY_SHORT_ME2
		else
			GLOB.data_core.leveled_riflemen++
			return final_paygrade
	if(!final_paygrade)
		. = "???"
		CRASH("[key_name(new_human)] spawned with no valid paygrade.")

	return final_paygrade

/datum/equipment_preset/proc/load_gear(mob/living/carbon/human/new_human, client/mob_client)
	return

/datum/equipment_preset/proc/load_status(mob/living/carbon/human/new_human, client/mob_client)
	return

/datum/equipment_preset/proc/load_skills(mob/living/carbon/human/new_human, client/mob_client)
	new_human.set_skills(skills)

/datum/equipment_preset/proc/load_id(mob/living/carbon/human/new_human, client/mob_client)
	if(!idtype)
		return
	if(!mob_client)
		mob_client = new_human.client
	var/obj/item/card/id/ID = new idtype()
	ID.name = "[new_human.real_name]'s [ID.id_type]"
	if(assignment)
		ID.name += " ([assignment])"
	ID.access = access.Copy(1, 0)
	ID.faction = faction
	ID.faction_group = faction_group.Copy()
	ID.assignment = assignment
	ID.rank = rank
	ID.registered_name = new_human.real_name
	ID.registered_ref = WEAKREF(new_human)
	ID.registered_gid = new_human.gid
	ID.blood_type = new_human.blood_type
	ID.paygrade = load_rank(new_human, mob_client) || ID.paygrade
	ID.uniform_sets = uniform_sets
	new_human.equip_to_slot_or_del(ID, WEAR_ID)
	new_human.faction = faction
	new_human.faction_group = faction_group.Copy()
	if(new_human.mind)
		new_human.mind.name = new_human.real_name
		// Bank account details handled in generate_money_account()
	new_human.job = rank
	new_human.comm_title = role_comm_title

/datum/equipment_preset/proc/load_languages(mob/living/carbon/human/new_human, client/mob_client)
	new_human.set_languages(languages)

/datum/equipment_preset/proc/load_preset(mob/living/carbon/human/new_human, randomise = FALSE, count_participant = FALSE, client/mob_client, show_job_gear = TRUE)
	if(!new_human.hud_used)
		new_human.create_hud()

	load_race(new_human, mob_client)
	if(randomise || uses_special_name)
		load_name(new_human, randomise, mob_client)
	else if(origin_override)
		var/datum/origin/origin = GLOB.origins[origin_override]
		new_human.name = origin.correct_name(new_human.name, new_human.gender)
	if(origin_override)
		new_human.origin = origin_override
	load_skills(new_human, mob_client) //skills are set before equipment because of skill restrictions on certain clothes.
	load_languages(new_human, mob_client)
	load_age(new_human, mob_client)
	load_id(new_human, mob_client)
	if(show_job_gear)
		load_gear(new_human, mob_client)
	load_status(new_human, mob_client)
	load_vanity(new_human, mob_client)
	load_traits(new_human, mob_client)
	if(GLOB.round_statistics && count_participant)
		GLOB.round_statistics.track_new_participant(faction)

	new_human.assigned_equipment_preset = src

	new_human.regenerate_icons()

	new_human.marine_points = MARINE_TOTAL_BUY_POINTS //resetting buy points
	new_human.marine_snowflake_points = MARINE_TOTAL_SNOWFLAKE_POINTS
	new_human.marine_buyable_categories = MARINE_CAN_BUY_ALL
	new_human.hud_set_squad()
	new_human.add_to_all_mob_huds()

/datum/equipment_preset/proc/load_vanity(mob/living/carbon/human/new_human, client/mob_client)
	if(!new_human.client || !new_human.client.prefs || !new_human.client.prefs.gear)
		return//We want to equip them with custom stuff second, after they are equipped with everything else.
	for(var/gear_type in new_human.client.prefs.gear)
		var/datum/gear/current_gear = GLOB.gear_datums_by_type[gear_type]
		current_gear.equip_to_user(new_human)

	//Gives ranks to the ranked
	var/current_rank = paygrades[1]
	var/obj/item/card/id/I = new_human.get_idcard()
	if(I)
		current_rank = I.paygrade
	if(new_human.w_uniform && current_rank)
		var/rankpath = get_rank_pins(current_rank)
		if(rankpath)
			var/obj/item/clothing/accessory/ranks/R = new rankpath()
			if(new_human.wear_suit && new_human.wear_suit.can_attach_accessory(R))
				new_human.wear_suit.attach_accessory(new_human, R, TRUE)
			else if(new_human.w_uniform && new_human.w_uniform.can_attach_accessory(R))
				new_human.w_uniform.attach_accessory(new_human, R, TRUE)
			else
				qdel(R)

	if(flags & EQUIPMENT_PRESET_MARINE)
		var/playtime = get_job_playtime(new_human.client, rank)
		var/medal_type

		switch(playtime)
			if(JOB_PLAYTIME_TIER_1 to JOB_PLAYTIME_TIER_2)
				medal_type = /obj/item/clothing/accessory/medal/bronze/service
			if(JOB_PLAYTIME_TIER_2 to JOB_PLAYTIME_TIER_3)
				medal_type = /obj/item/clothing/accessory/medal/silver/service
			if(JOB_PLAYTIME_TIER_3 to JOB_PLAYTIME_TIER_4)
				medal_type = /obj/item/clothing/accessory/medal/gold/service
			if(JOB_PLAYTIME_TIER_4 to INFINITY)
				medal_type = /obj/item/clothing/accessory/medal/platinum/service

		if(!new_human.client.prefs.playtime_perks)
			medal_type = null

		if(medal_type)
			var/obj/item/clothing/accessory/medal/medal = new medal_type()
			medal.recipient_name = new_human.real_name
			medal.recipient_rank = assignment

			if(new_human.wear_suit && new_human.wear_suit.can_attach_accessory(medal))
				new_human.wear_suit.attach_accessory(new_human, medal, TRUE)
			else if(new_human.w_uniform && new_human.w_uniform.can_attach_accessory(medal))
				new_human.w_uniform.attach_accessory(new_human, medal, TRUE)
			else
				if(!new_human.equip_to_slot_if_possible(medal, WEAR_IN_BACK, disable_warning = TRUE))
					if(!new_human.equip_to_slot_if_possible(medal, WEAR_L_HAND))
						if(!new_human.equip_to_slot_if_possible(medal, WEAR_R_HAND))
							medal.forceMove(new_human.loc)


	//Gives glasses to the vision impaired
	if(new_human.disabilities & NEARSIGHTED)
		var/obj/item/clothing/glasses/regular/P = new /obj/item/clothing/glasses/regular()
		if(!new_human.equip_to_slot_if_possible(P, WEAR_EYES))
			if(istype(new_human.glasses, /obj/item/clothing/glasses))
				var/obj/item/clothing/glasses/EYES = new_human.glasses
				if(EYES.prescription) //if they already have prescription glasses they don't need new ones
					return
			if(!new_human.equip_to_slot_if_possible(P, WEAR_IN_BACK))
				if(!new_human.equip_to_slot_if_possible(P, WEAR_L_HAND))
					if(!new_human.equip_to_slot_if_possible(P, WEAR_R_HAND))
						P.forceMove(new_human.loc)

/datum/equipment_preset/proc/load_traits(mob/living/carbon/human/new_human, client/mob_client)
	var/client/real_client = mob_client || new_human.client
	if(!real_client?.prefs?.traits)
		return

	for(var/trait in real_client.prefs.traits)
		var/datum/character_trait/character_trait = GLOB.character_traits[trait]
		character_trait.apply_trait(new_human, src)

/datum/equipment_preset/proc/get_minimap_icon(mob/living/carbon/human/user)
	var/image/background = mutable_appearance('icons/ui_icons/map_blips.dmi', user.assigned_squad?.background_icon ? user.assigned_squad.background_icon : minimap_background)

	if(islist(minimap_icon))
		for(var/icons in minimap_icon)
			var/iconstate = icons ? icons : "unknown"
			var/mutable_appearance/icon = image('icons/ui_icons/map_blips.dmi', icon_state = iconstate)
			icon.appearance_flags = RESET_COLOR

			if(minimap_icon[icons])
				icon.color = minimap_icon[icons]
			background.overlays += icon
	else
		var/obj/item/card/id/ID = user.get_idcard()
		var/icon_to_use
		if(ID.minimap_icon_override)
			icon_to_use = ID.minimap_icon_override
		else
			icon_to_use = minimap_icon ? minimap_icon : "unknown"
		var/mutable_appearance/icon = image('icons/ui_icons/map_blips.dmi', icon_state = icon_to_use)
		icon.appearance_flags = RESET_COLOR
		background.overlays += icon

	return background

/datum/equipment_preset/strip //For removing all equipment
	name = "*strip*"
	flags = EQUIPMENT_PRESET_EXTRA
	idtype = null


/datum/equipment_preset/proc/spawn_rebel_uniform(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	var/uniformpath = pick(
		/obj/item/clothing/under/colonist/clf,
		)
	new_human.equip_to_slot_or_del(new uniformpath, WEAR_BODY)


/datum/equipment_preset/proc/spawn_rebel_suit(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	var/suitpath = pick(
		/obj/item/clothing/suit/storage/militia,
		/obj/item/clothing/suit/storage/militia/vest,
		/obj/item/clothing/suit/storage/militia/brace,
		/obj/item/clothing/suit/storage/militia/partial,
		/obj/item/clothing/suit/armor/bulletproof,
		/obj/item/clothing/suit/armor/vest,
		)
	new_human.equip_to_slot_or_del(new suitpath, WEAR_JACKET)


/datum/equipment_preset/proc/spawn_rebel_helmet(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	var/helmetpath = pick(
		/obj/item/clothing/head/militia,
		/obj/item/clothing/head/militia/bucket,
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/head/helmet/skullcap,
		/obj/item/clothing/head/helmet/swat,
		/obj/item/clothing/head/hardhat,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/head/bandana,
		/obj/item/clothing/head/headband/red,
		/obj/item/clothing/head/headband/rebel,
		/obj/item/clothing/head/headband/rambo,
		)
	new_human.equip_to_slot_or_del(new helmetpath, WEAR_HEAD)


/datum/equipment_preset/proc/spawn_rebel_shoes(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	var/shoespath = pick(
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/shoes/laceup,
		/obj/item/clothing/shoes/leather,
		/obj/item/clothing/shoes/combat,
		/obj/item/clothing/shoes/swat,
		)
	new_human.equip_to_slot_or_del(new shoespath, WEAR_FEET)


/datum/equipment_preset/proc/spawn_rebel_gloves(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	var/glovespath = pick(
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/gloves/swat,
		/obj/item/clothing/gloves/combat,
		/obj/item/clothing/gloves/botanic_leather,
		)
	new_human.equip_to_slot_or_del(new glovespath, WEAR_HANDS)


/datum/equipment_preset/proc/spawn_rebel_belt(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	var/beltpath = pick(
		/obj/item/storage/belt/utility/full,
		/obj/item/storage/belt/knifepouch,
		/obj/item/storage/belt/gun/flaregun/full,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/large_holster/katana/full,
		/obj/item/storage/large_holster/machete/full,
		/obj/item/storage/belt/marine)
	new_human.equip_to_slot_or_del(new beltpath, WEAR_WAIST)


/datum/equipment_preset/proc/spawn_rebel_weapon(atom/M, sidearm = 0, ammo_amount = 12)
	if(!M)
		return

	var/list/rebel_firearms = list(
		/obj/item/weapon/gun/shotgun/double = /obj/item/ammo_magazine/handful/shotgun/buckshot,
		/obj/item/weapon/gun/shotgun/double/with_stock = /obj/item/ammo_magazine/handful/shotgun/flechette,
		/obj/item/weapon/gun/shotgun/pump/dual_tube/cmb = /obj/item/ammo_magazine/handful/shotgun/incendiary,
		/obj/item/weapon/gun/shotgun/pump/dual_tube/cmb = /obj/item/ammo_magazine/handful/shotgun/incendiary,
		/obj/item/weapon/gun/shotgun/double/sawn = /obj/item/ammo_magazine/handful/shotgun/incendiary,
		/obj/item/weapon/gun/shotgun/double/sawn = /obj/item/ammo_magazine/handful/shotgun/buckshot,
		/obj/item/weapon/gun/rifle/mar40 = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40 = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40/lmg = /obj/item/ammo_magazine/rifle/mar40/lmg,
		/obj/item/weapon/gun/rifle/mar40/lmg = /obj/item/ammo_magazine/rifle/mar40/lmg,
		/obj/item/weapon/gun/rifle/m16 = /obj/item/ammo_magazine/rifle/m16,
		/obj/item/weapon/gun/rifle/ar10 = /obj/item/ammo_magazine/rifle/ar10,
		/obj/item/weapon/gun/rifle/l42a/abr40 = /obj/item/ammo_magazine/rifle/l42a/abr40,
		/obj/item/weapon/gun/rifle/l42a/abr40 = /obj/item/ammo_magazine/rifle/l42a/abr40,
		/obj/item/weapon/gun/rifle/l42a/abr40 = /obj/item/ammo_magazine/rifle/l42a/abr40,
		/obj/item/weapon/gun/rifle/l42a/abr40 = /obj/item/ammo_magazine/rifle/l42a/abr40,
		/obj/item/weapon/gun/pistol/b92fs = /obj/item/ammo_magazine/pistol/b92fs,
		/obj/item/weapon/gun/smg/mp27 = /obj/item/ammo_magazine/smg/mp27,
		/obj/item/weapon/gun/smg/mp5 = /obj/item/ammo_magazine/smg/mp5,
		/obj/item/weapon/gun/smg/bizon = /obj/item/ammo_magazine/smg/bizon,
		/obj/item/weapon/gun/smg/mac15 = /obj/item/ammo_magazine/smg/mac15,
		/obj/item/weapon/gun/smg/uzi = /obj/item/ammo_magazine/smg/uzi
		)

	//no guns in sidearms list, we don't want players spawning with a gun in hand.
	var/list/rebel_sidearms = list(
		/obj/item/weapon/twohanded/lungemine = null,
		/obj/item/weapon/twohanded/lungemine = null,
		/obj/item/attachable/bayonet = null,
		/obj/item/attachable/bayonet/upp = null,
		/obj/item/explosive/grenade/custom/ied = null,
		/obj/item/explosive/grenade/custom/ied = null,
		/obj/item/explosive/grenade/custom/ied_incendiary = null,
		/obj/item/reagent_container/spray/pepper = null,
		/obj/item/reagent_container/spray/pepper = null,
		/obj/item/clothing/accessory/storage/webbing = null,
		/obj/item/clothing/accessory/storage/webbing = null,
		/obj/item/storage/belt/marine = null,
		/obj/item/storage/pill_bottle/tramadol/skillless = null,
		/obj/item/explosive/grenade/phosphorus = null,
		/obj/item/clothing/glasses/welding = null,
		/obj/item/reagent_container/ld50_syringe/choral = null,
		/obj/item/storage/firstaid/regular = null,
		/obj/item/reagent_container/pill/cyanide = null,
		/obj/item/device/megaphone = null,
		/obj/item/storage/belt/utility/full = null,
		/obj/item/storage/belt/utility/full = null,
		/obj/item/storage/bible = null,
		/obj/item/weapon/baseballbat = null,
		/obj/item/weapon/baseballbat = null,
		/obj/item/weapon/baseballbat = null,
		/obj/item/weapon/baseballbat/metal = null,
		/obj/item/explosive/grenade/empgrenade = null,
		/obj/item/explosive/grenade/smokebomb = null,
		/obj/item/explosive/grenade/smokebomb = null,
		/obj/item/explosive/grenade/smokebomb = null,
		/obj/item/explosive/grenade/phosphorus/upp = null,
		/obj/item/tool/hatchet = null,
		/obj/item/tool/hatchet = null,
		/obj/item/tool/hatchet = null,
		/obj/item/storage/box/mre = null,
		/obj/item/clothing/glasses/night/m42_night_goggles/upp = null,
		/obj/item/storage/box/handcuffs = null,
		/obj/item/storage/pill_bottle/happy = null,
		/obj/item/weapon/twohanded/fireaxe = null,
		/obj/item/weapon/twohanded/spear = null
		)

	var/gunpath = sidearm? pick(rebel_sidearms) : pick(rebel_firearms)
	var/ammopath = sidearm? rebel_sidearms[gunpath] : rebel_firearms[gunpath]

	spawn_weapon(gunpath, ammopath, M, sidearm, ammo_amount)

	return 1

/datum/equipment_preset/proc/spawn_rebel_specialist_weapon(atom/M, ammo_amount = 4)
	if(!M)
		return

	var/list/rebel_gunner_firearms = list(
		/obj/item/weapon/gun/m60 = /obj/item/ammo_magazine/m60,
		/obj/item/weapon/gun/rifle/mar40/lmg = /obj/item/ammo_magazine/rifle/mar40/lmg,
		/obj/item/weapon/gun/rifle/sniper/svd = /obj/item/ammo_magazine/sniper/svd
		)

	var/gunpath = pick(rebel_gunner_firearms)
	var/ammopath = rebel_gunner_firearms[gunpath]

	spawn_weapon(gunpath, ammopath, M, FALSE, ammo_amount)

	return 1


GLOBAL_LIST_INIT(rebel_shotguns, list(
	/obj/item/weapon/gun/shotgun/double = /obj/item/ammo_magazine/handful/shotgun/buckshot,
	/obj/item/weapon/gun/shotgun/double/with_stock = /obj/item/ammo_magazine/handful/shotgun/flechette,
	/obj/item/weapon/gun/shotgun/pump/dual_tube/cmb = /obj/item/ammo_magazine/handful/shotgun/incendiary,
	/obj/item/weapon/gun/shotgun/pump/dual_tube/cmb = /obj/item/ammo_magazine/handful/shotgun/incendiary,
	/obj/item/weapon/gun/shotgun/double/sawn = /obj/item/ammo_magazine/handful/shotgun/incendiary,
	/obj/item/weapon/gun/shotgun/double/sawn = /obj/item/ammo_magazine/handful/shotgun/buckshot
	))

GLOBAL_LIST_INIT(rebel_smgs, list(
	/obj/item/weapon/gun/smg/pps43 = /obj/item/ammo_magazine/smg/pps43,
	/obj/item/weapon/gun/smg/mp27 = /obj/item/ammo_magazine/smg/mp27,
	/obj/item/weapon/gun/smg/mp5 = /obj/item/ammo_magazine/smg/mp5,
	/obj/item/weapon/gun/smg/bizon = /obj/item/ammo_magazine/smg/bizon,
	/obj/item/weapon/gun/smg/mac15 = /obj/item/ammo_magazine/smg/mac15,
	/obj/item/weapon/gun/smg/uzi = /obj/item/ammo_magazine/smg/uzi,
	/obj/item/weapon/gun/smg/fp9000 = /obj/item/ammo_magazine/smg/fp9000
	))

GLOBAL_LIST_INIT(rebel_rifles, list(
	/obj/item/weapon/gun/rifle/mar40 = /obj/item/ammo_magazine/rifle/mar40,
	/obj/item/weapon/gun/rifle/mar40 = /obj/item/ammo_magazine/rifle/mar40,
	/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40,
	/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40,
	/obj/item/weapon/gun/rifle/mar40/lmg = /obj/item/ammo_magazine/rifle/mar40/lmg,
	/obj/item/weapon/gun/rifle/m16 = /obj/item/ammo_magazine/rifle/m16,
	/obj/item/weapon/gun/rifle/ar10 = /obj/item/ammo_magazine/rifle/ar10,
	/obj/item/weapon/gun/rifle/l42a/abr40 = /obj/item/ammo_magazine/rifle/l42a/abr40,
	/obj/item/weapon/gun/rifle/l42a/abr40 = /obj/item/ammo_magazine/rifle/l42a/abr40,
	))

/datum/equipment_preset/proc/spawn_rebel_smg(atom/M, ammo_amount = 12)
	if(!M)
		return

	var/gunpath = pick(GLOB.rebel_smgs)
	var/ammopath = GLOB.rebel_smgs[gunpath]

	spawn_weapon(gunpath, ammopath, M, ammo_amount)

	return 1

/datum/equipment_preset/proc/spawn_rebel_shotgun(atom/M, ammo_amount = 12)
	if(!M)
		return

	var/gunpath = pick(GLOB.rebel_shotguns)
	var/ammopath = GLOB.rebel_shotguns[gunpath]

	spawn_weapon(gunpath, ammopath, M, ammo_amount)

	return 1

/datum/equipment_preset/proc/spawn_rebel_rifle(atom/M, ammo_amount = 12)
	if(!M)
		return

	var/gunpath = pick(GLOB.rebel_rifles)
	var/ammopath = GLOB.rebel_rifles[gunpath]

	spawn_weapon(gunpath, ammopath, M, ammo_amount)

	return 1

/datum/equipment_preset/proc/spawn_merc_helmet(mob/living/carbon/human/new_human)
	if(!istype(new_human))
		return
	var/helmetpath = pick(
		/obj/item/clothing/head/freelancer,
		/obj/item/clothing/head/helmet/skullcap,
		/obj/item/clothing/head/bandana,
		/obj/item/clothing/head/cmbandana,
		/obj/item/clothing/head/cmbandana/tan,
		/obj/item/clothing/head/beanie,
		/obj/item/clothing/head/headband,
		/obj/item/clothing/head/headband/red,
		/obj/item/clothing/head/headband/tan,
	)
	new_human.equip_to_slot_or_del(new helmetpath, WEAR_HEAD)


/datum/equipment_preset/proc/spawn_merc_weapon(atom/M, sidearm = 0, ammo_amount = 12)
	if(!M)
		return

	var/list/merc_sidearms = list(
		/obj/item/weapon/gun/pistol/heavy = /obj/item/ammo_magazine/pistol/heavy,
		/obj/item/weapon/gun/pistol/m1911 = /obj/item/ammo_magazine/pistol/m1911,
		/obj/item/weapon/gun/pistol/kt42 = /obj/item/ammo_magazine/pistol/kt42,
		/obj/item/weapon/gun/pistol/holdout = /obj/item/ammo_magazine/pistol/holdout,
		/obj/item/weapon/gun/pistol/highpower = /obj/item/ammo_magazine/pistol/highpower,
		/obj/item/weapon/gun/smg/mp27 = /obj/item/ammo_magazine/smg/mp27,
		/obj/item/weapon/gun/smg/mac15 = /obj/item/ammo_magazine/smg/mac15,
		/obj/item/weapon/gun/smg/mac15 = /obj/item/ammo_magazine/smg/mac15/extended)

	var/list/merc_firearms = list(
		/obj/item/weapon/gun/shotgun/merc = /obj/item/ammo_magazine/handful/shotgun/slug,
		/obj/item/weapon/gun/shotgun/combat = /obj/item/ammo_magazine/handful/shotgun/slug,
		/obj/item/weapon/gun/shotgun/double/with_stock = /obj/item/ammo_magazine/handful/shotgun/buckshot,
		/obj/item/weapon/gun/shotgun/pump/dual_tube/cmb = /obj/item/ammo_magazine/handful/shotgun/incendiary,
		/obj/item/weapon/gun/rifle/mar40 = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40/lmg = /obj/item/ammo_magazine/rifle/mar40/lmg,
		/obj/item/weapon/gun/rifle/m41aMK1 = /obj/item/ammo_magazine/rifle/m41aMK1,
		/obj/item/weapon/gun/smg/fp9000 = /obj/item/ammo_magazine/smg/fp9000,
		/obj/item/weapon/gun/smg/bizon = /obj/item/ammo_magazine/smg/bizon,
		/obj/item/weapon/gun/rifle/m16 = /obj/item/ammo_magazine/rifle/m16)

	var/gunpath = sidearm? pick(merc_sidearms) : pick(merc_firearms)
	var/ammopath = sidearm? merc_sidearms[gunpath] : merc_firearms[gunpath]

	spawn_weapon(gunpath, ammopath, M, sidearm, ammo_amount)

	return 1

/datum/equipment_preset/proc/spawn_merc_shotgun(atom/M, ammo_amount = 24)
	if(!M)
		return

	var/list/merc_shotguns = list(
		/obj/item/weapon/gun/shotgun/merc = pick(GLOB.shotgun_handfuls_12g),
		/obj/item/weapon/gun/shotgun/combat = pick(GLOB.shotgun_handfuls_12g),
		/obj/item/weapon/gun/shotgun/double/with_stock = pick(GLOB.shotgun_handfuls_12g),
		/obj/item/weapon/gun/shotgun/pump/dual_tube/cmb = pick(GLOB.shotgun_handfuls_12g))

	var/gunpath = pick(merc_shotguns)
	var/ammopath = merc_shotguns[gunpath]

	spawn_weapon(gunpath, ammopath, M, 0, ammo_amount)

/datum/equipment_preset/proc/spawn_merc_rifle(atom/M, ammo_amount = 12)
	if(!M)
		return

	var/list/merc_rifles = list(
		/obj/item/weapon/gun/rifle/mar40 = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40/lmg = /obj/item/ammo_magazine/rifle/mar40/lmg,
		/obj/item/weapon/gun/rifle/m41aMK1 = /obj/item/ammo_magazine/rifle/m41aMK1,
		/obj/item/weapon/gun/smg/fp9000 = /obj/item/ammo_magazine/smg/fp9000,
		/obj/item/weapon/gun/rifle/m16 = /obj/item/ammo_magazine/rifle/m16)

	var/gunpath = pick(merc_rifles)
	var/ammopath = merc_rifles[gunpath]

	spawn_weapon(gunpath, ammopath, M, 0, ammo_amount)

/datum/equipment_preset/proc/spawn_merc_elite_weapon(atom/M, ammo_amount = 12, shotgun_chance = 50, spawn_belt = 1)
	if(!M)
		return

	var/list/elite_merc_rifles = list(
	/obj/item/weapon/gun/smg/m39/elite = /obj/item/ammo_magazine/smg/m39/ap,
	/obj/item/weapon/gun/rifle/m41aMK1 = /obj/item/ammo_magazine/rifle/m41aMK1,
	/obj/item/weapon/gun/rifle/m41a/elite = /obj/item/ammo_magazine/rifle/ap)

	var/list/elite_merc_shotguns = list(
	/obj/item/weapon/gun/shotgun/merc = pick(GLOB.shotgun_handfuls_12g),
	/obj/item/weapon/gun/shotgun/combat = pick(GLOB.shotgun_handfuls_12g),
	/obj/item/weapon/gun/shotgun/type23 = pick(GLOB.shotgun_handfuls_8g))

	if(prob(shotgun_chance))
		var/gunpath = pick(elite_merc_shotguns)
		var/ammopath = elite_merc_shotguns[gunpath]
		if(spawn_belt)
			if(ishuman(M))
				var/mob/living/carbon/human/new_human = M
				new_human.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun, WEAR_WAIST)
			ammo_amount = 24
		spawn_weapon(gunpath, ammopath, M, 0, ammo_amount)
	else
		var/gunpath = pick(elite_merc_rifles)
		var/ammopath = elite_merc_rifles[gunpath]
		if(spawn_belt)
			if(ishuman(M))
				var/mob/living/carbon/human/new_human = M
				new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine, WEAR_WAIST)
		spawn_weapon(gunpath, ammopath, M, 0, ammo_amount)


/datum/equipment_preset/proc/spawn_weapon(gunpath, ammopath, atom/M, sidearm = 0, ammo_amount = 12)

	var/atom/spawnloc = M
	var/obj/item/weapon/gun/gun

	if(gunpath)
		gun = new gunpath(spawnloc)
		if(ishuman(spawnloc))
			var/mob/living/carbon/human/new_human = spawnloc
			new_human.equip_to_slot_or_del(gun, sidearm? pick(WEAR_L_HAND, WEAR_R_HAND) : WEAR_J_STORE)
			if(ammopath && ammo_amount)
				for(var/i in 0 to ammo_amount-1)
					if(!new_human.equip_to_appropriate_slot(new ammopath))
						break
		else if(ammopath)
			spawnloc = get_turf(spawnloc)
			for(var/i in 0 to ammo_amount-1)
				new ammopath(spawnloc)


/datum/equipment_preset/proc/generate_random_marine_primary_for_wo(mob/living/carbon/human/new_human, shuffle = rand(0,10))
	switch(shuffle)
		if(0 to 4)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/stripped(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41a(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(new_human), WEAR_IN_BACK)
		if(5,7)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m39(new_human), WEAR_WAIST)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(new_human), WEAR_IN_BACK)
		else
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump(new_human), WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/full(new_human), WEAR_WAIST)
	return

/datum/equipment_preset/proc/add_common_wo_equipment(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/self_setting(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/attachments(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre(new_human), WEAR_IN_BACK)

/datum/equipment_preset/proc/add_ice_colony_survivor_equipment(mob/living/carbon/human/new_human)
	if((SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD]) && (SSmapping.configs[GROUND_MAP].map_name != MAP_CORSAT))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(new_human), WEAR_HEAD)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/snow_suit/survivor(new_human), WEAR_JACKET)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/rebreather/scarf(new_human), WEAR_FACE)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(new_human), WEAR_HANDS)

/datum/equipment_preset/proc/add_random_synth_infiltrator_equipment(mob/living/carbon/human/new_human) //To mitigate people metaing infiltrators on the spot
	var/random_gear = rand(0,4)
	switch(random_gear)
		if(0)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/w_br(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(new_human), WEAR_FEET)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(new_human), WEAR_EYES)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/gray_blu(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(new_human), WEAR_FEET)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/tshirt/r_bla(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/trainee(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress(new_human), WEAR_FEET)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/colonist(new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)

/datum/equipment_preset/proc/add_random_survivor_medical_gear(mob/living/carbon/human/new_human) // Randomized medical gear. Survivors wont have their gear all kitted out once the outbreak began much like a doctor on a coffee break wont carry their instruments around. This is a generation of items they may or maynot get when the outbreak happens
	var/random_gear = rand(0,4)
	switch(random_gear)
		if(0)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/robust(new_human), WEAR_IN_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/robust(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/robust(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/surgical(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)

/datum/equipment_preset/proc/add_random_survivor_research_gear(mob/living/carbon/human/new_human) // Randomized medical gear. Survivors wont have their gear all kitted out once the outbreak began much like a doctor on a coffee break wont carry their instruments around. This is a generation of items they may or maynot get when the outbreak happens
	var/random_gear = rand(0,3)
	switch(random_gear)
		if(0)
			new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector(new_human), WEAR_IN_BACK)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/metal_foam(new_human), WEAR_IN_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/structure/closet/bodybag/tarp/reactive(new_human), WEAR_IN_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/custom/antiweed(new_human), WEAR_IN_BACK)


/datum/equipment_preset/proc/add_random_cl_survivor_loot(mob/living/carbon/human/new_human) // Loot Generation associated with CL survivor. Makes them a little more valuable and not a useless pick.
	var/random_gear = rand(0,2)
	switch(random_gear)
		if(0)
			new_human.equip_to_slot_or_del(new /obj/item/paper/research_notes/grant/high(new_human.back), WEAR_IN_BACK)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/paper/research_notes/grant(new_human.back), WEAR_IN_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/paper/research_notes/good(new_human.back), WEAR_IN_BACK)

/datum/equipment_preset/proc/add_random_kutjevo_survivor_uniform(mob/living/carbon/human/new_human) // Kutjevo Survivor Clothing Randomizer
	var/random_gear = rand(0,1)
	switch(random_gear)
		if(0)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/kutjevo/drysuit(new_human), WEAR_BODY)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/kutjevo(new_human), WEAR_BODY)

/datum/equipment_preset/proc/add_random_kutjevo_survivor_equipment(mob/living/carbon/human/new_human) // Kutjevo Survivor Clothing Randomizer
	var/random_gear = rand(0,2)
	switch(random_gear)
		if(0)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/kutjevo(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/kutjevo(new_human), WEAR_HEAD)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/kutjevo(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/kutjevo(new_human), WEAR_HEAD)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/kutjevo(new_human), WEAR_FACE)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/kutjevo(new_human), WEAR_EYES)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/kutjevo(new_human), WEAR_HEAD)

/datum/equipment_preset/proc/add_random_survivor_equipment(mob/living/carbon/human/new_human) // Think of this gear as something a survivor of an outbreak might get before shortly taking shelter I.E spawn.
	var/random_gear = rand(0,5)
	switch(random_gear)
		if(0)
			new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/incendiary/molotov(new_human), WEAR_IN_BACK)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/m94(new_human), WEAR_IN_BACK)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/nailgun(new_human), WEAR_IN_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/twohanded/fireaxe(new_human), WEAR_R_HAND) //doesn't fit in backpack
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/tool/weldingtool/largetank(new_human), WEAR_IN_BACK)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(new_human.back), WEAR_R_HAND) //can't put in bag if not a medic

// Random Survivor Weapon Spawners
/datum/equipment_preset/proc/add_survivor_weapon_pistol(mob/living/carbon/human/new_human) // Pistols a survivor might come across in a colony. They may have gotten it from a code red gun cabinet or simply have one becuase of hostile natives.
	var/random_weapon = rand(0,4)
	switch(random_weapon)
		if(0)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/b92fs(new_human.back), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/b92fs(new_human), WEAR_IN_BACK)

		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/cmb(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/cmb(new_human), WEAR_IN_BACK)

		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/highpower(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/highpower(new_human), WEAR_IN_BACK)

		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m1911(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/m1911(new_human), WEAR_IN_BACK)

		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/small(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/small(new_human), WEAR_IN_BACK)

/datum/equipment_preset/proc/add_merc_survivor_weapon(mob/living/carbon/human/new_human) // Random Weapons an unaffiliated mercenary may have.
	var/random_weapon = rand(0,5)
	switch(random_weapon)
		if(0)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/mp5(new_human), WEAR_WAIST)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/fp9000(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/fp9000(new_human), WEAR_WAIST)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/shotgun_ammo, WEAR_WAIST)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m16(new_human), WEAR_WAIST)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/mar40/carbine(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/mar40(new_human), WEAR_WAIST)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/merc(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/shotgun_ammo, WEAR_WAIST)

/datum/equipment_preset/proc/add_pmc_survivor_weapon(mob/living/carbon/human/new_human) // Random Weapons a WY PMC may have during a deployment on a colony. They are not equiped with the elite weapons than their space station counterparts but they do bear some of the better weapons the outer rim has to offer.
	var/random_weapon = rand(0,19)
	switch(random_weapon)
		if(0 to 4)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a/corporate/no_lock(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(new_human), WEAR_IN_BACK)
		if(5 to 9)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/nsg23/no_lock/stripped(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/nsg23(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/nsg23(new_human), WEAR_IN_BACK)
		if(10 to 13)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39/corporate/no_lock, WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(new_human), WEAR_IN_BACK)
		if(14 to 17)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/fp9000/pmc(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/fp9000(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/fp9000(new_human), WEAR_IN_BACK)
		if(18,19)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/combat(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot(new_human), WEAR_IN_BACK)

/**
 * Randomizes the primary weapon a survivor might find at the start of the outbreak in a gun cabinet.
 * For the most part you will stil get a shotgun but there is an off chance you get something unique.
 * If you dont like the weapon deal with it. Cursed ammo for shotguns is intentional for scarcity reasons.
 * Some weapons may not appear at all in a colony so they will need the extra ammo.
 * MERC, and DB needed a handfull of shells to compete with the normal CMB.
 */
/datum/equipment_preset/proc/add_survivor_weapon_civilian(mob/living/carbon/human/new_human)
	// a high chance to just not have a primary weapon
	if(prob(60))
		return
	var/random_weapon = rand(0,3)
	switch(random_weapon)
		if(0)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/boltaction(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/boltaction(new_human), WEAR_WAIST)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/uzi(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/uzi(new_human), WEAR_WAIST)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/shotgun_ammo, WEAR_WAIST)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/ar10(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/ar10(new_human), WEAR_WAIST)

/datum/equipment_preset/proc/add_survivor_weapon_security(mob/living/carbon/human/new_human) // Randomizes the primary weapon a survivor might find at the start of the outbreak in a gun cabinet.

	var/random_weapon = rand(0, 3)
	switch(random_weapon)
		if(0)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/mar40/carbine(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/mar40(new_human), WEAR_WAIST)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/mp5(new_human), WEAR_WAIST)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/shotgun_ammo, WEAR_WAIST)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m16(new_human), WEAR_WAIST)

/datum/equipment_preset/proc/add_survivor_weapon_rebel(mob/living/carbon/human/new_human) // Randomizes the primary weapon a CLF survivor might have(Assumes you have an empty 3 slot webbing).

	var/random_weapon = rand(0, 5)
	switch(random_weapon)
		if(0)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/mar40/carbine(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/mar40(new_human), WEAR_IN_ACCESSORY)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp5(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp5(new_human), WEAR_IN_ACCESSORY)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/buckshot(new_human), WEAR_IN_ACCESSORY)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m16(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m16(new_human), WEAR_IN_ACCESSORY)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mac15(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mac15(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mac15(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mac15(new_human), WEAR_IN_ACCESSORY)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/mp27(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp27(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp27(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/mp27(new_human), WEAR_IN_ACCESSORY)

/////////////// Antag Vendor Equipment ///////////////
/datum/equipment_preset/proc/get_antag_clothing_equipment()
	return list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("CLF Shoes (Random)", 0, /obj/effect/essentials_set/random/clf_shoes, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("CLF Uniform", 0, /obj/item/clothing/under/colonist/clf, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("CLF Armor (Random)", 0, /obj/effect/essentials_set/random/clf_armor, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("CLF Gloves (Random)", 0, /obj/effect/essentials_set/random/clf_gloves, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("CLF Belt (Random)", 0, /obj/effect/essentials_set/random/clf_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),
		list("CLF Head Gear (Random)", 0, /obj/effect/essentials_set/random/clf_head, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/distress/dutch, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Flashlight", 0, /obj/item/device/flashlight, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Bayonet Sheath", 0, /obj/item/storage/pouch/bayonet/upp, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS (CHOOSE 1)", 0, null, null, null),
		list("Angled Grip", 0, /obj/item/attachable/angledgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 0, /obj/item/attachable/extended_barrel, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Gyroscopic Stabilizer", 0, /obj/item/attachable/gyro, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Masterkey Shotgun", 0, /obj/item/attachable/attached_gun/shotgun, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Recoil Compensator", 0, /obj/item/attachable/compensator, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Suppressor", 0, /obj/item/attachable/suppressor, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 0, /obj/item/attachable/verticalgrip, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/proc/get_antag_gear_equipment()
	return list(
		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Entrenching Tool", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_RECOMMENDED),
		list("Sandbags x25", 5, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("M16 AP Magazine (5.56x45mm)", 10, /obj/item/ammo_magazine/rifle/m16/ap, null, VENDOR_ITEM_REGULAR),
		list("MAR Extended Magazine (7.62x39mm)", 10, /obj/item/ammo_magazine/rifle/mar40/extended, null, VENDOR_ITEM_REGULAR),
		list("Shotgun Incendiary Shells (Handful)", 15, /obj/item/ammo_magazine/handful/shotgun/incendiary, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("EMP Grenade", 10, /obj/item/explosive/grenade/empgrenade, null, VENDOR_ITEM_REGULAR),
		list("Improvised Explosive Device", 15, /obj/item/explosive/grenade/custom/ied, null, VENDOR_ITEM_REGULAR),
		list("Improvised Firebomb", 10, /obj/item/explosive/grenade/incendiary/molotov, null, VENDOR_ITEM_REGULAR),
		list("Incendiary IED", 15, /obj/item/explosive/grenade/custom/ied_incendiary, null, VENDOR_ITEM_REGULAR),
		list("Improvised Phosphorus Bomb", 20, /obj/item/explosive/grenade/phosphorus/clf, null, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", 5, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Random Useful (Or Not) Item", 5, /obj/effect/essentials_set/random/clf_bonus_item, null, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 10, /obj/item/clothing/accessory/storage/holster, null, VENDOR_ITEM_REGULAR),
		list("Webbing", 10, /obj/item/clothing/accessory/storage/webbing, null, VENDOR_ITEM_REGULAR)
	)

/datum/equipment_preset/proc/load_upp_shotgun(mob/living/carbon/human/new_human)
	var/random_shotgun = rand(1,3)
	switch(random_shotgun)
		if(1)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/type23/breacher, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavybuck, WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavybuck, WEAR_R_STORE)
		if(2)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/type23/breacher/slug, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavyslug, WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavyslug, WEAR_R_STORE)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/type23/breacher/flechette, WEAR_J_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavyflechette, WEAR_L_STORE)
			new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/shotgun/heavyflechette, WEAR_R_STORE)

/datum/equipment_preset/proc/add_upp_weapon(mob/living/carbon/human/new_human)
	var/random_gun = rand(1,5)
	switch(random_gun)
		if(1, 2)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(new_human), WEAR_IN_BACK)
		if(3)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/type71/carbine(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/type71(new_human), WEAR_IN_BACK)
		if(4)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/type23(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/heavy/buckshot(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/heavy/buckshot(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/handful/shotgun/heavy/buckshot(new_human), WEAR_IN_BACK)
		if(5)
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/bizon(new_human), WEAR_L_HAND)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/bizon(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/bizon(new_human), WEAR_IN_BACK)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/bizon(new_human), WEAR_IN_BACK)

/datum/equipment_preset/proc/spawn_random_upp_headgear(mob/living/carbon/human/new_human)
	var/random_hat = rand(1,10)
	switch(random_hat)
		if (1, 2)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/UPP(new_human), WEAR_HEAD)
		if (3, 4, 5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap(new_human), WEAR_HEAD)
		if (6, 7)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret(new_human), WEAR_HEAD)
		if (8, 9)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/ushanka(new_human), WEAR_HEAD)

/datum/equipment_preset/proc/spawn_random_upp_armor(mob/living/carbon/human/new_human)
	var/random_gear = rand(1, 5)
	switch(random_gear)
		if (1, 2, 3)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP (new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/webbing(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/device/flashlight(new_human), WEAR_J_STORE)
		if (4)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP (new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar(new_human), WEAR_IN_JACKET)
		if (5)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/UPP (new_human), WEAR_BODY)
			new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/faction/UPP/support(new_human), WEAR_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/tool/crowbar(new_human), WEAR_IN_JACKET)
			new_human.equip_to_slot_or_del(new /obj/item/storage/box/mre/upp, WEAR_IN_JACKET)

/datum/equipment_preset/proc/spawn_random_upp_belt(mob/living/carbon/human/new_human)
	var/random_gun = rand(1, 4)
	switch(random_gun)
		if (1 to 2)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/np92(new_human), WEAR_WAIST)
		if (3)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/type47/t73(new_human), WEAR_WAIST)
		if (4)
			new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/upp(new_human), WEAR_WAIST)
