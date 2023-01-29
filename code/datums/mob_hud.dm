/* HUD DATUMS */

//GLOBAL HUD LIST
var/list/datum/mob_hud/huds = list(
	MOB_HUD_SECURITY_BASIC = new /datum/mob_hud/security/basic(),
	MOB_HUD_SECURITY_ADVANCED = new /datum/mob_hud/security/advanced(),
	MOB_HUD_MEDICAL_BASIC = new /datum/mob_hud/medical/basic(),
	MOB_HUD_MEDICAL_ADVANCED = new /datum/mob_hud/medical/advanced(),
	MOB_HUD_MEDICAL_OBSERVER = new /datum/mob_hud/medical/observer(),
	MOB_HUD_XENO_INFECTION = new /datum/mob_hud/xeno_infection(),
	MOB_HUD_XENO_STATUS = new /datum/mob_hud/xeno(),
	MOB_HUD_XENO_HOSTILE = new /datum/mob_hud/xeno_hostile(),
	MOB_HUD_FACTION_USCM = new /datum/mob_hud/faction(),
	MOB_HUD_FACTION_OBSERVER = new /datum/mob_hud/faction/observer(),
	MOB_HUD_FACTION_UPP = new /datum/mob_hud/faction/upp(),
	MOB_HUD_FACTION_WY = new /datum/mob_hud/faction/wy(),
	MOB_HUD_FACTION_TWE = new /datum/mob_hud/faction/twe(),
	MOB_HUD_FACTION_CLF = new /datum/mob_hud/faction/clf(),
	MOB_HUD_FACTION_PMC = new /datum/mob_hud/faction/pmc(),
	MOB_HUD_HUNTER = new /datum/mob_hud/hunter_hud(),
	MOB_HUD_HUNTER_CLAN = new /datum/mob_hud/hunter_clan()
	)

/datum/mob_hud
	var/list/mob/hudmobs = list() //list of all mobs which display this hud
	var/list/mob/hudusers = list() //list with all mobs who can see the hud
	var/list/hud_icons = list() //these will be the indices for the atom's hud_list
								// which is the list of the images maintenenced by this HUD
								// Actually managing those images is left up to clients.

// Stop displaying a HUD to a specific person
// (took off medical glasses)
/datum/mob_hud/proc/remove_hud_from(mob/user)
	for(var/mob/target in hudmobs)
		remove_from_single_hud(user, target)
	hudusers -= user

// Stop rendering a HUD on a target
// "unenroll" them so to speak
/datum/mob_hud/proc/remove_from_hud(mob/target)
	for(var/mob/user in hudusers)
		remove_from_single_hud(user, target)
	hudmobs -= target

// Always invoked on every 'user'
// Removes target from user's client's images.
/datum/mob_hud/proc/remove_from_single_hud(mob/user, mob/target)
	if(!user.client)
		return
	for(var/i in hud_icons)
		user.client.images -= target.hud_list[i]
		if(target.clone)
			user.client.images -= target.clone.hud_list[i]

// Allow user to view a HUD (putting on medical glasses)
/datum/mob_hud/proc/add_hud_to(mob/user)
	hudusers |= user
	for(var/mob/target in hudmobs)
		add_to_single_hud(user, target)

// "Enroll" a target into the HUD. (let others see the HUD on target)
/datum/mob_hud/proc/add_to_hud(mob/target)
	hudmobs |= target
	for(var/mob/user in hudusers)
		add_to_single_hud(user, target)

// This is sufficient to ship a HUD rendered on target to user for
// all time. essentially, OR-ing the images with the client
// makes the client able to 'see' them whenever they're offscreen
// somewhat confusingly
/datum/mob_hud/proc/add_to_single_hud(mob/user, mob/target)
	if(!user.client)
		return
	for(var/i in hud_icons)
		if(i in target.hud_list)
			user.client.images |= target.hud_list[i]
			if(target.clone)
				user.client.images |= target.clone.hud_list[i]




// MOB HUD TYPES //////////////////////////////////:


//Medical

/datum/mob_hud/medical
	hud_icons = list(HEALTH_HUD, STATUS_HUD)

//med hud used by silicons, only shows humans with a uniform with sensor mode activated.
/datum/mob_hud/medical/basic

/datum/mob_hud/medical/basic/proc/check_sensors(mob/living/carbon/human/H)
	if(!istype(H))
		return FALSE

	var/obj/item/clothing/under/U = H.w_uniform
	if(!istype(U))
		return FALSE

	if(H.species && HAS_TRAIT(H, TRAIT_FOREIGN_BIO))
		return FALSE

	if(U.sensor_mode <= SENSOR_MODE_DAMAGE || U.has_sensor == UNIFORM_NO_SENSORS)
		return FALSE

	return TRUE

/datum/mob_hud/medical/basic/add_to_single_hud(mob/user, mob/target)
	if(check_sensors(target))
		..()

/datum/mob_hud/medical/basic/proc/update_suit_sensors(mob/living/carbon/human/H)
	if(check_sensors(H))
		add_to_hud(H)
	else
		remove_from_hud(H)


//med hud used by medical hud glasses
/datum/mob_hud/medical/advanced

/datum/mob_hud/medical/advanced/add_to_single_hud(mob/user, mob/living/carbon/human/target)
	if(istype(target))
		if(target.species && HAS_TRAIT(target, TRAIT_FOREIGN_BIO)) //so you can't tell a pred's health with hud glasses.
			return
	..()

//medical hud used by ghosts
/datum/mob_hud/medical/observer
	hud_icons = list(HEALTH_HUD, STATUS_HUD_OOC, STATUS_HUD_XENO_CULTIST)


//infection status that appears on humans, viewed by xenos only and observers.
/datum/mob_hud/xeno_infection
	hud_icons = list(STATUS_HUD_XENO_INFECTION, STATUS_HUD_XENO_CULTIST)



//Xeno status hud, for xenos
/datum/mob_hud/xeno
	hud_icons = list(HEALTH_HUD_XENO, PLASMA_HUD, PHEROMONE_HUD, QUEEN_OVERWATCH_HUD, ARMOR_HUD_XENO, XENO_STATUS_HUD, XENO_BANISHED_HUD, HUNTER_HUD)

/datum/mob_hud/xeno_hostile
	hud_icons = list(XENO_HOSTILE_ACID, XENO_HOSTILE_SLOW, XENO_HOSTILE_TAG, XENO_HOSTILE_FREEZE)

/datum/mob_hud/hunter_clan
	hud_icons = list(HUNTER_CLAN)

/datum/mob_hud/hunter_hud
	hud_icons = list(HUNTER_HUD)

//Security

/datum/mob_hud/security

/datum/mob_hud/security/basic
	hud_icons = list(ID_HUD)

/datum/mob_hud/security/advanced
	hud_icons = list(ID_HUD, WANTED_HUD)

//Factions
/datum/mob_hud/faction
	hud_icons = list(FACTION_HUD, ORDER_HUD)
	var/faction_to_check = FACTION_MARINE

/datum/mob_hud/faction/add_to_single_hud(mob/user, mob/target)
	var/faction = target.faction
	if(faction == faction_to_check || isobserver(user) || isyautja(user))
		..()

/datum/mob_hud/faction/upp
	faction_to_check = FACTION_UPP

/datum/mob_hud/faction/wy
	faction_to_check = FACTION_WY

/datum/mob_hud/faction/twe
	faction_to_check = FACTION_TWE

/datum/mob_hud/faction/clf
	faction_to_check = FACTION_CLF

/datum/mob_hud/faction/pmc
	faction_to_check = FACTION_PMC

/datum/mob_hud/faction/observer
	hud_icons = list(FACTION_HUD, ORDER_HUD, HUNTER_CLAN)

///////// MOB PROCS //////////////////////////////:


/mob/proc/add_to_all_mob_huds()
	return

/mob/hologram/queen/add_to_all_mob_huds()
	var/datum/mob_hud/hud = huds[MOB_HUD_XENO_STATUS]
	hud.add_to_hud(src)

/mob/living/carbon/human/add_to_all_mob_huds()
	for(var/datum/mob_hud/hud in huds)
		if(istype(hud, /datum/mob_hud/xeno)) //this one is xeno only
			continue
		hud.add_to_hud(src)

/mob/living/carbon/xenomorph/add_to_all_mob_huds()
	for(var/datum/mob_hud/hud in huds)
		if(!istype(hud, /datum/mob_hud/xeno))
			continue
		hud.add_to_hud(src)


/mob/proc/remove_from_all_mob_huds()
	return

/mob/hologram/queen/remove_from_all_mob_huds()
	var/datum/mob_hud/hud = huds[MOB_HUD_XENO_STATUS]
	hud.remove_from_hud(src)

/mob/living/carbon/human/remove_from_all_mob_huds()
	for(var/datum/mob_hud/hud in huds)
		if(istype(hud, /datum/mob_hud/xeno))
			continue
		hud.remove_from_hud(src)

/mob/living/carbon/xenomorph/remove_from_all_mob_huds()
	for(var/datum/mob_hud/hud in huds)
		if(istype(hud, /datum/mob_hud/xeno))
			hud.remove_from_hud(src)
			hud.remove_hud_from(src)
		else if (istype(hud, /datum/mob_hud/xeno_infection))
			hud.remove_hud_from(src)




/mob/proc/refresh_huds(mob/source_mob)
	var/mob/M = source_mob ? source_mob : src
	for(var/datum/mob_hud/hud in huds)
		if(M in hud.hudusers)
			readd_hud(hud)

/mob/proc/readd_hud(datum/mob_hud/hud)
	hud.add_hud_to(src)




//Medical HUDs

//called when a human changes suit sensors
/mob/living/carbon/human/proc/update_suit_sensors()
	var/datum/mob_hud/medical/basic/B = huds[MOB_HUD_MEDICAL_BASIC]
	B.update_suit_sensors(src)

//called when a human changes health
/mob/proc/med_hud_set_health()
	return
/mob/proc/med_hud_set_armor()
	return

/mob/living/carbon/xenomorph/med_hud_set_health()
	var/image/holder = hud_list[HEALTH_HUD_XENO]

	var/health_hud_type = "xenohealth"
	if(stat == DEAD)
		holder.icon_state = "[health_hud_type]0"
	else
		var/amount = health > 0 ? round(health * 100 / maxHealth, 10) : CEILING(health, 10)
		if(health < 0)
			var/warding_health = crit_health != 0 ? warding_aura * 20 : 0
			amount = round((health / (crit_health - warding_health)) * -100, 10)
		else
			amount = CEILING((health / maxHealth) * 100, 10)
		if(!amount)
			amount = -1 //don't want the 'zero health' icon when we are crit
		holder.icon_state = "[health_hud_type][amount]"

/mob/living/carbon/xenomorph/proc/overlay_shields()
	var/image/holder = hud_list[HEALTH_HUD_XENO]
	holder.overlays.Cut()
	var/total_shield_hp
	for (var/datum/xeno_shield/XS in xeno_shields)
		total_shield_hp += XS.amount

	var/percentage_shield = round(100*XENO_SHIELD_HUD_SCALE_FACTOR*total_shield_hp/maxHealth, 10)
	percentage_shield = min(100, percentage_shield)

	if(percentage_shield > 1)
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoshield[percentage_shield]")
	else
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoshield0")

/mob/living/carbon/xenomorph/med_hud_set_armor()
	if(GLOB.xeno_general.armor_ignore_integrity)
		return FALSE

	var/image/holder = hud_list[ARMOR_HUD_XENO]
	if(stat == DEAD || armor_deflection <=0)
		holder.icon_state = "xenoarmor0"
	else
		var/amount = round(armor_integrity*100/armor_integrity_max, 10)
		if(!amount) amount = 1 //don't want the 'zero health' icon when we still have 4% of our health
		holder.icon_state = "xenoarmor[amount]"

/mob/living/carbon/human/med_hud_set_health()
	var/image/holder = hud_list[HEALTH_HUD]
	if(stat == DEAD)
		holder.icon_state = "hudhealth-100"
	else
		var/percentage = round(health*100/species.total_health, 10)
		if(percentage > -1)
			holder.icon_state = "hudhealth[percentage]"
		else if(percentage > -49)
			holder.icon_state = "hudhealth-0"
		else if(percentage > -99)
			holder.icon_state = "hudhealth-50"
		else
			holder.icon_state = "hudhealth-100"


/mob/proc/med_hud_set_status() //called when mob stat changes, or get a virus/xeno host, etc
	return

/mob/living/carbon/xenomorph/med_hud_set_status()
	hud_set_plasma()
	hud_set_pheromone()

/mob/hologram/queen/med_hud_set_status()
	var/image/holder = hud_list[XENO_STATUS_HUD]
	holder.icon_state = "hudeye"
	holder.color = color

/mob/living/carbon/human/med_hud_set_status()
	var/image/holder = hud_list[STATUS_HUD]
	holder.overlays.Cut()
	var/image/holder2 = hud_list[STATUS_HUD_OOC]
	holder2.overlays.Cut()
	var/image/holder3 = hud_list[STATUS_HUD_XENO_INFECTION]
	var/image/holder4 = hud_list[STATUS_HUD_XENO_CULTIST]

	holder2.color = null
	holder3.color = null
	holder4.color = null

	holder4.icon_state = "hudblank"

	if(species && species.flags & IS_SYNTHETIC)
		holder3.icon_state = "hudsynth" // xenos have less awareness of synth status
		if(HAS_TRAIT(src, TRAIT_INFILTRATOR_SYNTH))
			return FALSE
		if(stat != DEAD)
			holder.icon_state = "hudsynth"
			holder2.icon_state = "hudsynth"
		else
			if(!client)
				var/mob/dead/observer/G = get_ghost(FALSE, TRUE)
				if(!G)
					holder.icon_state = "hudsynthdnr"
					holder2.icon_state = "hudsynthdnr"
				else if(!G.client)
					holder.overlays += image('icons/mob/hud/hud.dmi', "hudnosynthclient")
					holder2.overlays += image('icons/mob/hud/hud.dmi', "hudnosynthclient")
			else
				holder.icon_state = "hudsynthdead"
				holder2.icon_state = "hudsynthdead"
			return
	else
		var/revive_enabled = stat == DEAD && check_tod() && is_revivable()
		if(stat == DEAD)
			revive_enabled = check_tod() && is_revivable()
		var/datum/internal_organ/heart/heart = islist(internal_organs_by_name) ? internal_organs_by_name["heart"] : null

		var/holder2_set = 0
		if(hivenumber)
			holder4.icon_state = "hudalien"

			if(GLOB.hive_datum[hivenumber])
				var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]

				if(hive)
					if(hive.color)
						holder4.color = hive.color
					if(hive.leading_cult_sl == src)
						holder4.icon_state = "hudalien_leader"

		if(status_flags & XENO_HOST)
			holder2.icon_state = "hudxeno"//Observer and admin HUD only
			holder2_set = 1
			var/obj/item/alien_embryo/E = locate(/obj/item/alien_embryo) in src
			if(E)
				holder3.icon_state = "infected[E.stage]"
				var/datum/hive_status/hive = GLOB.hive_datum[E.hivenumber]

				if(hive && hive.color)
					holder3.color = hive.color

		if(stat == DEAD)
			if(revive_enabled)
				if(!client)
					var/mob/dead/observer/G = get_ghost(FALSE, TRUE)
					if(!G)
						holder.icon_state = "huddeaddnr"
						if(!holder2_set)
							holder2.icon_state = "huddeaddnr"
							holder3.icon_state = "huddead"
							holder2_set = 1
						return
					else if(!G.client)
						holder.overlays += image('icons/mob/hud/hud.dmi', "hudnoclient")
						holder2.overlays += image('icons/mob/hud/hud.dmi', "hudnoclient")
				if(world.time > timeofdeath + revive_grace_period - 1 MINUTES)
					holder.icon_state = "huddeadalmost"
					if(!holder2_set)
						holder2.icon_state = "huddeadalmost"
						holder3.icon_state = "huddead"
						holder2_set = 1
				else if(world.time > timeofdeath + revive_grace_period - 2.5 MINUTES)
					holder.icon_state = "huddeadclose"
					if(!holder2_set)
						holder2.icon_state = "huddeadclose"
						holder3.icon_state = "huddead"
						holder2_set = 1
				else
					holder.icon_state = "huddeaddefib"
					if(!holder2_set)
						holder2.icon_state = "huddeaddefib"
						holder3.icon_state = "huddead"
						holder2_set = 1
			else
				if(heart && (heart.organ_status >= ORGAN_BROKEN && check_tod())) // broken heart icon
					holder.icon_state = "huddeadheart"
					if(!holder2_set)
						holder2.icon_state = "huddeadheart"
						holder3.icon_state = "huddead"
						holder2_set = 1
					return

				holder.icon_state = "huddead"
				if(!holder2_set)
					holder2.icon_state = "huddead"
					holder3.icon_state = "huddead"
					holder2_set = 1

			return


		for(var/datum/disease/D in viruses)
			if(!D.hidden[SCANNER])
				holder.icon_state = "hudill"
				if(!holder2_set)
					holder2.icon_state = "hudill"
				return
		holder.icon_state = "hudhealthy"
		if(!holder2_set)
			holder2.icon_state = "hudhealthy"
			holder3.icon_state = ""

//xeno status HUD

/mob/living/carbon/xenomorph/proc/hud_set_marks()
	if(!client)
		return
	for(var/obj/effect/alien/resin/marker/i in hive.resin_marks)
		client.images |= i.seenMeaning

/mob/living/carbon/xenomorph/proc/hud_set_plasma()
	var/image/holder = hud_list[PLASMA_HUD]
	if(stat == DEAD || plasma_max == 0)
		holder.icon_state = "plasma0"
	else
		var/amount = round(get_plasma_percentage(), 10)
		holder.icon_state = "plasma[amount]"


/mob/living/carbon/xenomorph/proc/hud_set_pheromone()
	var/image/holder = hud_list[PHEROMONE_HUD]
	holder.overlays.Cut()
	holder.icon_state = "hudblank"
	if(stat != DEAD)
		var/tempname = ""
		if(frenzy_aura)
			tempname += "frenzy"
		if(warding_aura)
			tempname += "warding"
		if(recovery_aura)
			tempname += "recovery"
		if(tempname)
			holder.icon_state = "hud[tempname]"

		var/has_frenzy_aura = FALSE
		var/has_recovery_aura = FALSE
		var/has_warding_aura = FALSE
		switch(current_aura)
			if("frenzy")
				has_frenzy_aura = TRUE
			if("recovery")
				has_recovery_aura = TRUE
			if("warding")
				has_warding_aura = TRUE
			if("all")
				has_frenzy_aura = TRUE
				has_recovery_aura = TRUE
				has_warding_aura = TRUE
		switch(leader_current_aura)
			if("frenzy")
				has_frenzy_aura = TRUE
			if("recovery")
				has_recovery_aura = TRUE
			if("warding")
				has_warding_aura = TRUE
			if("all")
				has_frenzy_aura = TRUE
				has_recovery_aura = TRUE
				has_warding_aura = TRUE

		if (has_frenzy_aura)
			holder.overlays += image('icons/mob/hud/hud.dmi',src, "hudaurafrenzy")
		if(has_recovery_aura)
			holder.overlays += image('icons/mob/hud/hud.dmi',src, "hudaurarecovery")
		if(has_warding_aura)
			holder.overlays += image('icons/mob/hud/hud.dmi',src, "hudaurawarding")

	hud_list[PHEROMONE_HUD] = holder


/mob/living/carbon/xenomorph/proc/hud_set_queen_overwatch()
	var/image/holder = hud_list[QUEEN_OVERWATCH_HUD]
	holder.overlays.Cut()
	holder.icon_state = "hudblank"
	if (stat != DEAD && hivenumber && hivenumber <= GLOB.hive_datum)
		var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
		var/mob/living/carbon/xenomorph/queen/Q = hive.living_xeno_queen
		if (Q && Q.observed_xeno == src)
			holder.icon_state = "queen_overwatch"
	hud_list[QUEEN_OVERWATCH_HUD] = holder

/mob/living/carbon/xenomorph/proc/hud_update_banished()
	var/image/holder = hud_list[XENO_BANISHED_HUD]
	holder.overlays.Cut()
	holder.icon_state = "hudblank"
	if (stat != DEAD && banished)
		holder.icon_state = "xeno_banished"
	hud_list[XENO_BANISHED_HUD] = holder

/mob/living/carbon/xenomorph/proc/hud_update()
	var/image/holder = hud_list[XENO_STATUS_HUD]
	holder.overlays.Cut()
	if (stat == DEAD)
		return
	if (IS_XENO_LEADER(src))
		var/image/I = image('icons/mob/hud/hud.dmi',src, "hudxenoleader")
		holder.overlays += I
	if (age)
		var/image/J = image('icons/mob/hud/hud.dmi',src, "hudxenoupgrade[age]")
		holder.overlays += J
	if(hive && hivenumber != XENO_HIVE_NORMAL)
		var/image/J = image('icons/mob/hud/hud.dmi', src, "hudalien_xeno")
		J.color = hive.color
		holder.overlays += J

//Sec HUDs

/mob/living/carbon/proc/sec_hud_set_ID()
	return

/mob/living/carbon/human/sec_hud_set_ID()
	var/image/holder = hud_list[ID_HUD]
	holder.icon_state = "hudsec_unknown"
	if(wear_id)
		var/obj/item/card/id/I = wear_id.GetID()
		if(I)
			holder.icon_state = "hudsec_[ckey(I.GetJobName())]"

/mob/living/carbon/human/proc/sec_hud_set_security_status()
	var/image/holder = hud_list[WANTED_HUD]
	holder.icon_state = "hudblank"
	criminal = FALSE
	var/perpref = null
	if(wear_id)
		var/obj/item/card/id/I = wear_id.GetID()
		if(I)
			perpref = I.registered_ref

	if(!GLOB.data_core)
		return

	for(var/datum/data/record/E in GLOB.data_core.general)
		if(E.fields["ref"] == perpref)
			for(var/datum/data/record/R in GLOB.data_core.security)
				if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "*Arrest*"))
					holder.icon_state = "hudsec_wanted"
					criminal = TRUE
					break
				else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Incarcerated"))
					holder.icon_state = "hudsec_prisoner"
					criminal = TRUE
					break
				else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Released"))
					holder.icon_state = "hudsec_released"
					criminal = FALSE
					break
				else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Suspect"))
					holder.icon_state = "hudsec_suspect"
					break
				else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "NJP"))
					holder.icon_state = "hudsec_njp"
					break
//Squad HUD

/mob/proc/hud_set_squad()
	return

/mob/living/carbon/human/hud_set_squad()
	var/datum/faction/F = get_faction(faction)
	var/image/holder = hud_list[F.hud_type]
	holder.icon_state = "hudblank"
	holder.overlays.Cut()

	if(mob_flags & MUTINEER)
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', src, "hudmutineer")
		return

	F.modify_hud_holder(holder, src)

/mob/living/carbon/human/yautja/hud_set_squad()
	set waitfor = FALSE

	var/image/holder = hud_list[HUNTER_CLAN]

	holder.icon_state = "predhud"

	if(client && client.clan_info && client.clan_info.clan_id)
		var/datum/entity/clan/player_clan = GET_CLAN(client.clan_info.clan_id)
		player_clan.sync()

		holder.color = player_clan.color

	hud_list[HUNTER_CLAN] = holder



/mob/proc/hud_set_hunter()
	return

var/global/image/hud_icon_hunter_gear
var/global/image/hud_icon_hunter_hunted
var/global/image/hud_icon_hunter_dishonored
var/global/image/hud_icon_hunter_honored
var/global/image/hud_icon_hunter_thralled


/mob/living/carbon/hud_set_hunter()
	var/image/holder = hud_list[HUNTER_HUD]
	holder.icon_state = "hudblank"
	holder.overlays.Cut()
	if(hunter_data.hunted)
		if(!hud_icon_hunter_hunted)
			hud_icon_hunter_hunted = image('icons/mob/hud/hud_yautja.dmi', src, "hunter_hunted")
		holder.overlays += hud_icon_hunter_hunted

	if(hunter_data.dishonored)
		if(!hud_icon_hunter_dishonored)
			hud_icon_hunter_dishonored = image('icons/mob/hud/hud_yautja.dmi', src, "hunter_dishonored")
		holder.overlays += hud_icon_hunter_dishonored
	else if(hunter_data.honored)
		if(!hud_icon_hunter_honored)
			hud_icon_hunter_honored = image('icons/mob/hud/hud_yautja.dmi', src, "hunter_honored")
		holder.overlays += hud_icon_hunter_honored

	if(hunter_data.thralled)
		if(!hud_icon_hunter_thralled)
			hud_icon_hunter_thralled = image('icons/mob/hud/hud_yautja.dmi', src, "hunter_thralled")
		holder.overlays += hud_icon_hunter_thralled
	else if(hunter_data.gear)
		if(!hud_icon_hunter_gear)
			hud_icon_hunter_gear = image('icons/mob/hud/hud_yautja.dmi', src, "hunter_gear")
		holder.overlays += hud_icon_hunter_gear

	hud_list[HUNTER_HUD] = holder

/mob/living/carbon/xenomorph/hud_set_hunter()
	var/image/holder = hud_list[HUNTER_HUD]
	holder.icon_state = "hudblank"
	holder.overlays.Cut()
	holder.pixel_x = -18
	if(hunter_data.hunted)
		if(!hud_icon_hunter_hunted)
			hud_icon_hunter_hunted = image('icons/mob/hud/hud_yautja.dmi', src, "hunter_hunted")
		holder.overlays += hud_icon_hunter_hunted

	if(hunter_data.dishonored)
		if(!hud_icon_hunter_dishonored)
			hud_icon_hunter_dishonored = image('icons/mob/hud/hud_yautja.dmi', src, "hunter_dishonored")
		holder.overlays += hud_icon_hunter_dishonored
	else if(hunter_data.honored)
		if(!hud_icon_hunter_honored)
			hud_icon_hunter_honored = image('icons/mob/hud/hud_yautja.dmi', src, "hunter_honored")
		holder.overlays += hud_icon_hunter_honored

	hud_list[HUNTER_HUD] = holder


/mob/proc/hud_set_order()
	return

var/global/image/hud_icon_hudmove
var/global/image/hud_icon_hudhold
var/global/image/hud_icon_hudfocus
// ORDER HUD
/mob/living/carbon/human/hud_set_order()
	var/image/holder = hud_list[ORDER_HUD]
	holder.icon_state = "hudblank"
	holder.overlays.Cut()
	if(mobility_aura)
		if(!hud_icon_hudmove)
			hud_icon_hudmove = image('icons/mob/hud/marine_hud.dmi', src, "hudmove")
		holder.overlays += hud_icon_hudmove
	if(protection_aura)
		if(!hud_icon_hudhold)
			hud_icon_hudhold = image('icons/mob/hud/marine_hud.dmi', src, "hudhold")
		holder.overlays += hud_icon_hudhold
	if(marksman_aura)
		if(!hud_icon_hudfocus)
			hud_icon_hudfocus = image('icons/mob/hud/marine_hud.dmi', src, "hudfocus")
		holder.overlays += hud_icon_hudfocus
	hud_list[ORDER_HUD] = holder



// Xeno "hostile" HUD
/mob/living/carbon/human/proc/update_xeno_hostile_hud()
	var/image/acid_holder = hud_list[XENO_HOSTILE_ACID]
	var/image/slow_holder = hud_list[XENO_HOSTILE_SLOW]
	var/image/tag_holder = hud_list[XENO_HOSTILE_TAG]
	var/image/freeze_holder = hud_list[XENO_HOSTILE_FREEZE]

	acid_holder.icon_state = "hudblank"
	slow_holder.icon_state = "hudblank"
	tag_holder.icon_state = "hudblank"
	freeze_holder.icon_state = "hudblank"

	acid_holder.overlays.Cut()
	slow_holder.overlays.Cut()
	tag_holder.overlays.Cut()
	freeze_holder.overlays.Cut()

	var/acid_found = FALSE
	var/acid_count = 0
	for (var/datum/effects/prae_acid_stacks/PAS in effects_list)
		if (!QDELETED(PAS))
			acid_count = PAS.stack_count
			acid_found = TRUE
			break

	if (acid_found && acid_count > 0)
		acid_holder.overlays += image('icons/mob/hud/hud.dmi',"acid_stacks[acid_count]")

	var/slow_found = FALSE
	for (var/datum/effects/xeno_slow/XS in effects_list)
		if (!QDELETED(XS))
			slow_found = TRUE
			break

	if (slow_found)
		slow_holder.overlays += image('icons/mob/hud/hud.dmi', "xeno_slow")

	var/tag_found = FALSE
	for (var/datum/effects/dancer_tag/DT in effects_list)
		if (!QDELETED(DT))
			tag_found = TRUE
			break

	if (tag_found)
		tag_holder.overlays += image('icons/mob/hud/hud.dmi', src, "prae_tag")

	// Hacky, but works. Currently effects are hard to make with precise timings
	var/freeze_found = frozen

	if (freeze_found)
		freeze_holder.overlays += image('icons/mob/hud/hud.dmi', src, "xeno_freeze")
