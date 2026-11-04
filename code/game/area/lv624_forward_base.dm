/area/forward_base/lv624/reqs
	name = "Bunker Requisitions Bay"
	icon_state = "req"

// ========== Command Areas ==========

/area/forward_base/lv624/command
	minimap_color = MINIMAP_AREA_COMMAND

/area/forward_base/lv624/command/cic
	name = "Combat Information Center"
	icon_state = "cic"
	flags_area = AREA_NOBURROW

/area/forward_base/lv624/command/sea_office
	name = "Senior Enlisted Advisor's Office"
	icon_state = "airoom"

// ========== Liasion's Office
/area/forward_base/lv624/liasion
	name = "Bunker W-Y Liasion's Office"
	icon_state = "corporatespace"

// ========== Engineering Areas ==========
/area/forward_base/lv624/engineering/
	icon_state = "engineering"
	minimap_color = MINIMAP_AREA_ENGI

/area/forward_base/lv624/engineering/power_storage
	name = "Bunker Power Storage Bay"
	icon_state = "coreroom"

/area/forward_base/lv624/engineering/orbital_cannon
	name = "Bunker Heavy Artillery Room"
	icon_state = "weaponroom"

// ========== Brig Areas ==========

/area/forward_base/lv624/brig
	name = "Bunker Brig"
	icon_state = "brig"
	minimap_color = MINIMAP_AREA_SEC

/area/forward_base/lv624/brig/reception
	name = "Bunker Brig Reception"

/area/forward_base/lv624/brig/cells
	name = "Bunker Brig Cells"
	icon_state = "brigcells"

// ========== Hallway Areas ==========

/area/forward_base/lv624/hallways/
	name = "Bunker Hallway"
	icon_state = "missionplanner"

/area/forward_base/lv624/hallways/west
	name = "Western Bunker Hallway"
	icon_state = "stern"

/area/forward_base/lv624/hallways/east
	name = "Eastern Bunker Hallway"
	icon_state = "aft"

/area/forward_base/lv624/hallways/south
	name = "Southern Bunker Hallway"
	icon_state = "port"

/area/forward_base/lv624/hallways/north_gate
	name = "Firebase Charlie Northern Gate"

/area/forward_base/lv624/hallways/stairwell
	icon_state = "stairs_lowerdeck"

/area/forward_base/lv624/hallways/stairwell/preps
	name = "Squad Preparation Stairwell"

/area/forward_base/lv624/hallways/stairwell/research
	name = "Bunker Research Stairwell"

/area/forward_base/lv624/hallways/pillbox/southeast
	name = "Southeast Bunker Pillbox"

/area/forward_base/lv624/hallways/pillbox/northwest
	name = "Northwest Bunker Pillbox"

/area/forward_base/lv624/hallways/pillbox/northeast
	name = "Northeast Bunker Pillbox"

// ========== Living Space Areas ==========

/area/forward_base/lv624/living/
	icon_state = "livingspace"

/area/forward_base/lv624/living/kitchen
	name = "Bunker Kitchen"
	icon_state = "food"

/area/forward_base/lv624/living/cafeteria
	name = "Bunker Mess Hall"
	icon_state = "food"

/area/forward_base/lv624/living/briefing
	name = "Bunker Briefing Area"
	icon_state = "briefing"

/area/forward_base/lv624/living/cryogenics
	name = "Bunker Backup Cryogenics Bay"
	icon_state = "cryo"

/area/forward_base/lv624/living/synth_closet
	name = "Bunker Synthetic Storage Closet"

// ========== Squad Prep Areas ==========

/area/forward_base/lv624/preps
	name = "Squad Preparations"
	icon_state = "ab_shared"

/area/forward_base/lv624/preps/leader
	name = "Squad Leader Preparations"

/area/forward_base/lv624/preps/leader/cryo
	name = "Squad Leader Cryogenics Bay"

/area/forward_base/lv624/preps/spec
	name = "Weapon Specialist Preparations"

/area/forward_base/lv624/preps/spec/cryo
	name = "Weapon Specialist Cryogenics Bay"

/area/forward_base/lv624/preps/corpsman
	name = "Hospital Corpsman Preparations"

/area/forward_base/lv624/preps/corpsman/cryo
	name = "Hospital Corpsman Cryogenics Bay"

/area/forward_base/lv624/preps/comtech
	name = "Combat Technicians Preparations"

/area/forward_base/lv624/preps/comtech/cryo
	name = "Combat Technician Cryogenics Bay"

/area/forward_base/lv624/preps/smartgunner
	name = "Smartgunner Preparations"

/area/forward_base/lv624/preps/smartgunner/cryo
	name = "Smartgunner Cryogenics Bay"

// ========== Medical Areas ==========

/area/forward_base/lv624/medical
	icon_state = "medical"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/forward_base/lv624/medical/pharmacy
	name = "Bunker Pharmacy"
	icon_state = "chemistry"

/area/forward_base/lv624/medical/icu
	name = "Bunker Intensive Care Unit"

// ========== Research Areas ==========

/area/forward_base/lv624/research
	name = "Bunker Research Department"
	icon_state = "science"

	minimap_color = MINIMAP_AREA_RESEARCH

/area/forward_base/lv624/research/botany
	name = "Bunker Research Hydroponics Bay"

/area/forward_base/lv624/research/containment
	name = "Bunker Research Containment Cell"

/area/forward_base/lv624/research/fabrication
	name = "Bunker Research Fabrication Closet"

// ========== Intel Areas ==========

/area/forward_base/lv624/intel
	name = "Bunker Intel Processing & Overwatch"
	icon_state = "officerstudy"

/area/forward_base/lv624/intel/prep
	name = "Bunker Intelligence Storage & Preparations"

// ========== Tent Areas ==========

/area/forward_base/lv624/tent_camp
	name = "Bunker Exterior Tent Camp"
	icon_state = "invi"

/area/forward_base/lv624/tent
	name = "Tent"
	icon_state = "livingspace"

	ceiling = CEILING_NONE
	sound_environment = SOUND_ENVIRONMENT_CARPETED_HALLWAY
	minimap_color = MINIMAP_AREA_CELL_LOW

/area/forward_base/lv624/tent/officer_tent
	name = "Senior Officer's Tent"
	icon_state = "officerstudy"

	minimap_color = MINIMAP_AREA_COMMAND

/area/forward_base/lv624/tent/commander_tent
	name = "Commanding OFficer's Tent"
	icon_state = "officerstudy"

	minimap_color = MINIMAP_AREA_COMMAND

/area/forward_base/lv624/tent/reqs_tent
	name = "Requisitions Tent"
	icon_state = "req"

/area/forward_base/lv624/tent/med_tent
	name = "Medical Tent"
	icon_state = "medical"

	minimap_color = MINIMAP_AREA_MEDBAY

/area/forward_base/lv624/tent/jtac_tent
	name = "JTAC Preparations Tent"
	icon_state = "hangar"

	minimap_color = MINIMAP_AREA_ENGI

/area/forward_base/lv624/tent/mess_tent
	name = "Mess Tent"
	icon_state = "food"

/area/forward_base/lv624/tent/correspondent_tent
	name = "Combat Correspondent's Tent"
