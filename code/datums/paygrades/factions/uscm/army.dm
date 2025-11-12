/datum/paygrade/army
	name = "Army Paygrade"
	rank_pin = /obj/item/clothing/accessory/ranks/army
	pay_multiplier = 1.6
	default_faction = FACTION_ARMY

// ENLISTED PAYGRADES
/datum/paygrade/army/e1
	paygrade = PAY_SHORT_AE1
	name = "Private"
	prefix = "PV1"
	rank_pin = /obj/item/clothing/accessory/ranks/army/e1
	ranking = 0
	pay_multiplier = 1.6

/datum/paygrade/army/e2
	paygrade = PAY_SHORT_AE2
	name = "Private"
	prefix = "PV2"
	rank_pin = /obj/item/clothing/accessory/ranks/army/e2
	ranking = 1
	pay_multiplier = 1.7

/datum/paygrade/army/e3
	paygrade = PAY_SHORT_AE3
	name = "Private First Class"
	prefix = "PFC"
	rank_pin = /obj/item/clothing/accessory/ranks/army/e3
	ranking = 2
	pay_multiplier = 1.8

/datum/paygrade/army/e4s
	paygrade = PAY_SHORT_AE4S
	name = "Specialist"
	prefix = "Spc"
	rank_pin = /obj/item/clothing/accessory/ranks/army/e4s
	ranking = 3
	pay_multiplier = 2.1

/datum/paygrade/army/e4
	paygrade = PAY_SHORT_AE4
	name = "Corporal"
	prefix = "Cpl"
	rank_pin = /obj/item/clothing/accessory/ranks/army/e4
	ranking = 4
	pay_multiplier = 2.2

/datum/paygrade/army/e5
	paygrade = PAY_SHORT_AE5
	name = "Sergeant"
	prefix = "Sgt"
	rank_pin = /obj/item/clothing/accessory/ranks/army/e5
	ranking = 5
	pay_multiplier = 2.3

/datum/paygrade/army/e6
	paygrade = PAY_SHORT_AE6
	name = "Staff Sergeant"
	prefix = "SSgt"
	rank_pin = /obj/item/clothing/accessory/ranks/army/e6
	ranking = 6
	pay_multiplier = 2.4

/datum/paygrade/army/e7
	paygrade = PAY_SHORT_AE7
	name = "Sergeant First Class"
	prefix = "Sgt1C"
	rank_pin = /obj/item/clothing/accessory/ranks/army/e7
	ranking = 7
	pay_multiplier = 2.75

/datum/paygrade/army/e8
	paygrade = PAY_SHORT_AE8
	name = "Master Sergeant"
	prefix = "MSgt"
	rank_pin = /obj/item/clothing/accessory/ranks/army/e8
	ranking = 8
	pay_multiplier = 2.9

/datum/paygrade/army/e8c
	paygrade = PAY_SHORT_AE8C
	name = "First Sergeant"
	prefix = "FSgt"
	rank_pin = /obj/item/clothing/accessory/ranks/army/e8
	ranking = 9
	pay_multiplier = 2.9

/datum/paygrade/army/e9
	paygrade = PAY_SHORT_AE9
	name = "Sergeant Major"
	prefix = "SgtMaj"
	rank_pin = /obj/item/clothing/accessory/ranks/army/e9
	ranking = 10
	pay_multiplier = 3

/datum/paygrade/army/e9
	paygrade = PAY_SHORT_AE9E
	name = "Command Sergeant Major"
	prefix = "CmdSgtM"
	rank_pin = /obj/item/clothing/accessory/ranks/army/e9e
	ranking = 11
	pay_multiplier = 3

/datum/paygrade/army/e9c
	paygrade = PAY_SHORT_AE9C
	name = "Sergeant Major of the Army"
	prefix = "SMArmy"
	rank_pin = /obj/item/clothing/accessory/ranks/army/e9c
	ranking = 12
	pay_multiplier = 3

/datum/paygrade/army/wo
	paygrade = PAY_SHORT_MWO
	name = "Warrant Officer"
	prefix = "WO"
	rank_pin = /obj/item/clothing/accessory/ranks/army/wo
	ranking = 13
	pay_multiplier = 3
	officer_grade = GRADE_OFFICER

/datum/paygrade/army/cwo
	paygrade = PAY_SHORT_MCWO
	name = "Chief Warrant Officer"
	prefix = "CWO"
	rank_pin = /obj/item/clothing/accessory/ranks/army/cwo
	ranking = 14
	pay_multiplier = 3
	officer_grade = GRADE_OFFICER

// COMMISSIONED PAYGRADES

/datum/paygrade/army/o1
	paygrade = PAY_SHORT_MO1
	name = "Second Lieutenant"
	prefix = "2ndLt"
	rank_pin = /obj/item/clothing/accessory/ranks/army/o1
	ranking = 15
	pay_multiplier = 3
	officer_grade = GRADE_OFFICER

/datum/paygrade/army/o2
	paygrade = PAY_SHORT_MO2
	name = "First Lieutenant"
	prefix = "1stLt"
	rank_pin = /obj/item/clothing/accessory/ranks/army/o2
	ranking = 16
	pay_multiplier = 3.2
	officer_grade = GRADE_OFFICER

/datum/paygrade/army/o3
	paygrade = PAY_SHORT_MO3
	name = "Captain"
	prefix = "Capt"
	rank_pin = /obj/item/clothing/accessory/ranks/army/o3
	ranking = 17
	pay_multiplier = 4
	officer_grade = GRADE_OFFICER

/datum/paygrade/army/o4
	paygrade = PAY_SHORT_AO4
	name = "Major"
	prefix = "Maj"
	rank_pin = /obj/item/clothing/accessory/ranks/army/o4
	ranking = 18
	pay_multiplier = 4
	officer_grade = GRADE_OFFICER

/datum/paygrade/army/o5
	paygrade = PAY_SHORT_MO5
	name = "Lieutenant Colonel"
	prefix = "LtCol"
	rank_pin = /obj/item/clothing/accessory/ranks/army/o5
	ranking = 19
	pay_multiplier = 4.2
	officer_grade = GRADE_OFFICER

//Platoon Commander
/datum/paygrade/army/o6
	paygrade = PAY_SHORT_MO6
	name = "Colonel"
	prefix = "Col"
	rank_pin = /obj/item/clothing/accessory/ranks/army/o6
	ranking = 20
	pay_multiplier = 4.4
	officer_grade = GRADE_OFFICER

/datum/paygrade/army/o6e
	paygrade = PAY_SHORT_MO6E
	name = "Senior Colonel"
	prefix = "Snr Col."
	rank_pin = /obj/item/clothing/accessory/ranks/army/o6e
	ranking = 21
	pay_multiplier = 4.6
	officer_grade = GRADE_OFFICER

/datum/paygrade/army/o6c
	paygrade = PAY_SHORT_MO6C
	name = "Division Colonel"
	prefix = "Div Col."
	rank_pin = /obj/item/clothing/accessory/ranks/army/o6c
	ranking = 22
	pay_multiplier = 4.8
	officer_grade = GRADE_OFFICER

//High Command
/datum/paygrade/army/o7
	paygrade = PAY_SHORT_AO7
	name = "Brigadier General"
	prefix = "BGen"
	rank_pin = /obj/item/clothing/accessory/ranks/army/o7
	ranking = 23
	pay_multiplier = 6
	officer_grade = GRADE_FLAG

/datum/paygrade/army/o8
	paygrade = PAY_SHORT_MO8
	name = "Major General"
	prefix = "MajGen"
	rank_pin = /obj/item/clothing/accessory/ranks/army/o8
	ranking = 24
	pay_multiplier = 6.2
	officer_grade = GRADE_FLAG

/datum/paygrade/army/o9
	paygrade = PAY_SHORT_MO9
	name = "Lieutenant General"
	prefix = "LtGen"
	rank_pin = /obj/item/clothing/accessory/ranks/army/o9
	ranking = 25
	pay_multiplier = 6.4
	officer_grade = GRADE_FLAG

/datum/paygrade/army/o10
	paygrade = PAY_SHORT_MO10
	name = "General"
	prefix = "Gen"
	rank_pin = /obj/item/clothing/accessory/ranks/army/o10
	ranking = 26
	pay_multiplier = 6.6
	officer_grade = GRADE_FLAG

/datum/paygrade/army/o10c
	paygrade = PAY_SHORT_MO10C
	name = "Assistant Commandant of the army Corps"
	prefix = "ACMC"
	rank_pin = /obj/item/clothing/accessory/ranks/army/o10c
	ranking = 27
	pay_multiplier = 6.8
	officer_grade = GRADE_FLAG

/datum/paygrade/army/o10s
	paygrade = PAY_SHORT_MO10S
	name = "Commandant of the Army"
	prefix = "CMC"
	rank_pin = /obj/item/clothing/accessory/ranks/army/o10c
	ranking = 28
	pay_multiplier = 7
	officer_grade = GRADE_FLAG
