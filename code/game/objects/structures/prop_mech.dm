/obj/structure/prop/mech
	icon = 'icons/obj/structures/props/mech.dmi'

/obj/structure/prop/mech/hydralic_clamp
	name = "Hydraulic Clamp"
	icon_state = "mecha_clamp"

/obj/structure/prop/mech/drill
	name = "Drill"
	desc = "This is the drill that'll pierce the heavens!"
	icon_state = "mecha_drill"

/obj/structure/prop/mech/armor_booster
	name = "Armor Booster Module (Close Combat Weaponry)"
	desc = "Boosts exosuit armor against armed melee attacks. Requires energy to operate."
	icon_state = "mecha_abooster_ccw"

/obj/structure/prop/mech/repair_droid
	name = "Repair Droid"
	desc = "Automated repair droid. Scans exosuit for damage and repairs it. Can fix almost all types of external or internal damage."
	icon_state = "repair_droid"

/obj/structure/prop/mech/tesla_energy_relay
	name = "Energy Relay"
	desc = "Wirelessly drains energy from any available power channel in area. The performance index is quite low."
	icon_state = "tesla"

/obj/structure/prop/mech/parts
	name = "mecha part"
	flags_atom = FPRINT|CONDUCT

/obj/structure/prop/mech/parts/chassis
	name="Mecha Chassis"
	icon_state = "backbone"

// ripley to turn into P-1000 an Older version of the P-5000 to anchor it more into the lore...
/obj/structure/prop/mech/parts/chassis/ripley
	name = "P-1000 Chassis"
	icon_state = "ripley_chassis"
/obj/structure/prop/mech/parts/chassis/firefighter
	name = "Firefighter Chassis"
	icon_state = "ripley_chassis"
/obj/structure/prop/mech/parts/ripley_torso
	name="P-1000 Torso"
	desc="A torso part of P-1000 APLU. Contains power unit, processing core and life support systems."
	icon_state = "ripley_harness"
/obj/structure/prop/mech/parts/ripley_left_arm
	name="P-1000 Left Arm"
	desc="A P-1000 APLU left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_l_arm"
/obj/structure/prop/mech/parts/ripley_right_arm
	name="P-1000 Right Arm"
	desc="A P-1000 APLU right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_r_arm"
/obj/structure/prop/mech/parts/ripley_left_leg
	name="P-1000 Left Leg"
	desc="A P-1000 APLU left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_l_leg"
/obj/structure/prop/mech/parts/ripley_right_leg
	name="P-1000 Right Leg"
	desc="A P-1000 APLU right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_r_leg"

//gygax turned into MAX (Mobile Assault Exo-Warrior)look like a gygax from afar
/obj/structure/prop/mech/parts/chassis/gygax
	name = "MAX Chassis"
	icon_state = "gygax_chassis"
/obj/structure/prop/mech/parts/gygax_torso
	name="MAX Torso"
	desc="A torso part of MAX. Contains power unit, processing core and life support systems. Has an additional equipment slot."
	icon_state = "gygax_harness"
/obj/structure/prop/mech/parts/gygax_head
	name="MAX Head"
	desc="A MAX head. Houses advanced surveilance and targeting sensors."
	icon_state = "gygax_head"
/obj/structure/prop/mech/parts/gygax_left_arm
	name="MAX Left Arm"
	desc="A MAX left arm. Data and power sockets are compatible with most exosuit tools and weapons."
	icon_state = "gygax_l_arm"
/obj/structure/prop/mech/parts/gygax_right_arm
	name="MAX Right Arm"
	desc="A MAX right arm. Data and power sockets are compatible with most exosuit tools and weapons."
	icon_state = "gygax_r_arm"
/obj/structure/prop/mech/parts/gygax_left_leg
	name="MAX Left Leg"
	icon_state = "gygax_l_leg"
/obj/structure/prop/mech/parts/gygax_right_leg
	name="MAX Right Leg"
	icon_state = "gygax_r_leg"
/obj/structure/prop/mech/parts/gygax_armor
	name="MAX Armor Plates"
	icon_state = "gygax_armor"

// durand MOX (mobile offensive exo-warrior) look like a durand from afar.
/obj/structure/prop/mech/parts/chassis/durand
	name = "MOX Chassis"
	icon_state = "durand_chassis"
/obj/structure/prop/mech/parts/durand_torso
	name="MOX Torso"
	icon_state = "durand_harness"
/obj/structure/prop/mech/parts/durand_head
	name="MOX Head"
	icon_state = "durand_head"
/obj/structure/prop/mech/parts/durand_left_arm
	name="MOX Left Arm"
	icon_state = "durand_l_arm"
/obj/structure/prop/mech/parts/durand_right_arm
	name="MOX Right Arm"
	icon_state = "durand_r_arm"
/obj/structure/prop/mech/parts/durand_left_leg
	name="MOX Left Leg"
	icon_state = "durand_l_leg"
/obj/structure/prop/mech/parts/durand_right_leg
	name="MOX Right Leg"
	icon_state = "durand_r_leg"
/obj/structure/prop/mech/parts/durand_armor
	name="MOX Armor Plates"
	icon_state = "durand_armor"

// phazon currently not in use. could  be deleted...
/obj/structure/prop/mech/parts/chassis/phazon
	name = "Phazon Chassis"
	icon_state = "phazon_chassis"
/obj/structure/prop/mech/parts/phazon_torso
	name="Phazon Torso"
	icon_state = "phazon_harness"
/obj/structure/prop/mech/parts/phazon_head
	name="Phazon Head"
	icon_state = "phazon_head"
/obj/structure/prop/mech/parts/phazon_left_arm
	name="Phazon Left Arm"
	icon_state = "phazon_l_arm"
/obj/structure/prop/mech/parts/phazon_right_arm
	name="Phazon Right Arm"
	icon_state = "phazon_r_arm"
/obj/structure/prop/mech/parts/phazon_left_leg
	name="Phazon Left Leg"
	icon_state = "phazon_l_leg"
/obj/structure/prop/mech/parts/phazon_right_leg
	name="Phazon Right Leg"
	icon_state = "phazon_r_leg"
/obj/structure/prop/mech/parts/phazon_armor_plates
	name="Phazon Armor Plates"
	icon_state = "phazon_armor"

// odysseus currently not in use  could  be deleted...
/obj/structure/prop/mech/parts/chassis/odysseus
	name = "Odysseus Chassis"
	icon_state = "odysseus_chassis"
/obj/structure/prop/mech/parts/odysseus_head
	name="Odysseus Head"
	icon_state = "odysseus_head"
/obj/structure/prop/mech/parts/odysseus_torso
	name="Odysseus Torso"
	desc="A torso part of Odysseus. Contains power unit, processing core and life support systems."
	icon_state = "odysseus_torso"
/obj/structure/prop/mech/parts/odysseus_left_arm
	name="Odysseus Left Arm"
	desc="An Odysseus left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "odysseus_l_arm"
/obj/structure/prop/mech/parts/odysseus_right_arm
	name="Odysseus Right Arm"
	desc="An Odysseus right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "odysseus_r_arm"
/obj/structure/prop/mech/parts/odysseus_left_leg
	name="Odysseus Left Leg"
	desc="An Odysseus left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "odysseus_l_leg"
/obj/structure/prop/mech/parts/odysseus_right_leg
	name="Odysseus Right Leg"
	desc="A Odysseus right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "odysseus_r_leg"
/obj/structure/prop/mech/parts/odysseus_armor_plates
	name="Odysseus Armor Plates"
	icon_state = "odysseus_armor"
