/area/forward_base
	name = "\improper Forward Base"
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "almayer"
	flags_area = AREA_NOBURROW|AREA_NOTUNNEL
	ceiling = CEILING_REINFORCED_METAL
	ceiling_muffle = FALSE
	sound_environment = SOUND_ENVIRONMENT_ROOM
	weather_enabled = FALSE
	requires_power = FALSE //Temporary
	unlimited_power = TRUE //Temporary

	var/static/xeno_alert_cooldown = 0
	var/static/list/xeno_alert_timers = list()

/area/forward_base/Entered(atom/movable/thing, atom/OldLoc)
	. = ..()
	if(!isxeno(thing) || !OldLoc || istype(get_area(OldLoc), /area/forward_base) || !COOLDOWN_FINISHED(src, xeno_alert_cooldown))
		return
	var/mob/living/carbon/xenomorph/xeno = thing
	if(xeno.stat == DEAD || (FACTION_MARINE in xeno.iff_tag?.faction_groups))
		return
	for(var/mob/living/carbon/xenomorph/other_xeno as anything in GLOB.living_xeno_list)
		if(other_xeno == xeno || xeno_alert_timers[other_xeno])
			continue
		if(other_xeno.stat == DEAD || (FACTION_MARINE in other_xeno.iff_tag?.faction_groups))
			continue
		if(istype(get_area(other_xeno), /area/forward_base))
			return
	xeno_alert_timers[xeno] = addtimer(CALLBACK(src, PROC_REF(alert_xeno_intrusion), xeno), 5 SECONDS, TIMER_STOPPABLE)

/area/forward_base/Exited(atom/movable/thing, atom/new_loc)
	. = ..()
	if(istype(get_area(new_loc), /area/forward_base))
		return
	deltimer(xeno_alert_timers[thing])
	xeno_alert_timers -= thing

/area/forward_base/proc/alert_xeno_intrusion(mob/living/carbon/xenomorph/xeno)
	xeno_alert_timers -= xeno
	if(xeno.stat == DEAD || (FACTION_MARINE in xeno.iff_tag?.faction_groups))
		return
	if(!COOLDOWN_FINISHED(src, xeno_alert_cooldown))
		return
	COOLDOWN_START(src, xeno_alert_cooldown, 5 MINUTES)
	shipwide_ai_announcement("Unidentified lifesigns detected inside the base. Recommendation: lockdown of exterior access ports, including ducting and ventilation.", "Unidentified Lifesigns", 'sound/AI/unidentified_lifesigns.ogg', ares_logging = ARES_LOG_SECURITY)

/area/forward_base/command
	minimap_color = MINIMAP_AREA_COMMAND

/area/forward_base/command/cic
	name = "\improper Forward Base Combat Information Center"
	icon_state = "cic"
	flags_area = AREA_NOBURROW|AREA_NOTUNNEL

/area/forward_base/command/combat_correspondent
	name = "\improper Forward Base Combat Correspondent Office"
	icon_state = "selfdestruct"

/area/forward_base/command/corporateliaison
	name = "\improper Forward Base Corporate Liaison Office"
	icon_state = "corporatespace"

/area/forward_base/command/securestorage
	name = "\improper Forward Base Intelligence Office"
	icon_state = "corporatespace"

/area/forward_base/engineering
	minimap_color = MINIMAP_AREA_ENGI

/area/forward_base/engineering/lower
	name = "\improper Forward Base Engineering"
	icon_state = "lowerengineering"

/area/forward_base/engineering/lower/workshop
	name = "\improper Forward Base Engineering Workshop"
	icon_state = "workshop"

/area/forward_base/hallways/lower/port_midship_hallway
	name = "\improper Forward Base Lower Port Hallway"
	icon_state = "port"

/area/forward_base/hallways/lower/starboard_midship_hallway
	name = "\improper Forward Base Lower Starboard Hallway"
	icon_state = "starboard"

/area/forward_base/hallways/upper/port
	name = "\improper Forward Base Upper Port Hallway"
	icon_state = "port"

/area/forward_base/hallways/upper/starboard
	name = "\improper Forward Base Upper Starboard Hallway"
	icon_state = "starboard"

/area/forward_base/living/briefing
	name = "\improper Forward Base Briefing Area"
	icon_state = "briefing"

/area/forward_base/living/grunt_rnr
	name = "\improper Forward Base Lounge"
	icon_state = "gruntrnr"

/area/forward_base/living/offices/cryo
	name = "\improper Forward Base Cryogenics Bay"
	icon_state = "cryo"

/area/forward_base/medical
	minimap_color = MINIMAP_AREA_MEDBAY

/area/forward_base/medical/chemistry
	name = "\improper Forward Base Chemical Laboratory"
	icon_state = "chemistry"

/area/forward_base/medical/lower_medical_lobby
	name = "\improper Forward Base Lower Medical Lobby"
	icon_state = "medical"

/area/forward_base/medical/medical_science
	name = "\improper Forward Base Research Laboratory"
	icon_state = "science"

/area/forward_base/medical/morgue
	name = "\improper Forward Base Morgue"
	icon_state = "operating"

/area/forward_base/medical/operating_room_one
	name = "\improper Forward Base Operating Room 1"
	icon_state = "operating"

/area/forward_base/medical/upper_medical
	name = "\improper Forward Base Upper Medbay"
	icon_state = "medical"

/area/forward_base/shipboard/brig/processing
	name = "\improper Forward Base Brig"
	icon_state = "brig"
	minimap_color = MINIMAP_AREA_SEC

/area/forward_base/shipboard/weapon_room
	name = "\improper Forward Base Weapon Control"
	icon_state = "weaponroom"
	minimap_color = MINIMAP_AREA_SEC

/area/forward_base/squads/alpha_bravo_shared
	name = "\improper Forward Base Squad Preparation"
	icon_state = "ab_shared"

/area/forward_base/squads/req
	name = "\improper Forward Base Requisitions"
	icon_state = "req"

/area/forward_base/underdeck/hangar
	name = "\improper Forward Base Hangar"
	icon_state = "hangar"
