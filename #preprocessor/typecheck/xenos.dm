//Xenomorph Hud Test APOPHIS 22MAY2015
#define isXeno(A) (istype(A, /mob/living/carbon/Xenomorph))

#define isXenoOrHuman(A) (isXeno(A) || ishuman(A))

#define isXenoBoiler(A) (istype(A, /mob/living/carbon/Xenomorph/Boiler))
#define isXenoCarrier(A) (istype(A, /mob/living/carbon/Xenomorph/Carrier))
#define isXenoCrusher(A) (istype(A, /mob/living/carbon/Xenomorph/Crusher))
#define isXenoDrone(A) (istype(A, /mob/living/carbon/Xenomorph/Drone))
#define isXenoHivelord(A) (istype(A, /mob/living/carbon/Xenomorph/Hivelord))
#define isXenoLurker(A) (istype(A, /mob/living/carbon/Xenomorph/Lurker))
#define isXenoDefender(A) (istype(A, /mob/living/carbon/Xenomorph/Defender))
#define isXenoPredalien(A) (istype(A, /mob/living/carbon/Xenomorph/Predalien))
#define isXenoLarva(A) (istype(A, /mob/living/carbon/Xenomorph/Larva))
#define isXenoLarvaStrict(A) (isXenoLarva(A) && !istype(A, /mob/living/carbon/Xenomorph/Larva/predalien))
#define isXenoPraetorian(A) (istype(A, /mob/living/carbon/Xenomorph/Praetorian))
#define isXenoQueen(A) (istype(A, /mob/living/carbon/Xenomorph/Queen))
#define isXenoQueenLeadingHive(A) (isXenoQueen(A) && A?:hive?:living_xeno_queen == A)
#define isXenoRavager(A) (istype(A, /mob/living/carbon/Xenomorph/Ravager))
#define isXenoRunner(A) (istype(A, /mob/living/carbon/Xenomorph/Runner))
#define isXenoSentinel(A) (istype(A, /mob/living/carbon/Xenomorph/Sentinel))
#define isXenoSpitter(A) (istype(A, /mob/living/carbon/Xenomorph/Spitter))
#define isXenoWarrior(A) (istype(A, /mob/living/carbon/Xenomorph/Warrior))
#define isXenoBurrower(A) (istype(A, /mob/living/carbon/Xenomorph/Burrower))

#define isXenoBuilder(A) (isXenoDrone(A) || isXenoHivelord(A) || isXenoCarrier(A) || isXenoBurrower(A) || isXenoQueen(A))

/mob/living/carbon/proc/allied_to_hivenumber(var/h_number, var/limit = XENO_SLASH_FORBIDDEN)
	if(hivenumber == h_number)
		return TRUE

/mob/living/carbon/human/allied_to_hivenumber(var/h_number, var/limit = XENO_SLASH_FORBIDDEN)
	var/datum/hive_status/hive = hive_datum[h_number]

	if(!hive)
		return FALSE
	
	switch(hive.slashing_allowed)
		if(XENO_SLASH_ALLOWED)
			return FALSE
		if(XENO_SLASH_RESTRICTED, XENO_SLASH_FORBIDDEN)
			if(hivenumber == h_number)
				return limit >= XENO_SLASH_RESTRICTED
			else if(hive.slashing_allowed == XENO_SLASH_FORBIDDEN)
				return limit >= XENO_SLASH_FORBIDDEN
	
	return FALSE

/mob/living/carbon/proc/match_hivemind(var/mob/living/carbon/C)
	if(!istype(C))
		return FALSE

	return C.allied_to_hivenumber(hivenumber) && allied_to_hivenumber(C.hivenumber)

// need this to set the data for walls/eggs/huggers when they are initialized
/proc/set_hive_data(var/atom/A, hivenumber)
	var/datum/hive_status/hive = hive_datum[hivenumber]
	if (hive.color)
		A.color = hive.color
	A.name = "[lowertext(hive.prefix)][A.name]"

/proc/get_xeno_stun_duration(var/mob/A, duration)
	if(isXeno(A))
		return duration * XVX_STUN_LENGTHMULT
	return duration

/proc/get_xeno_damage_slash(var/mob/A, damage)
	if(isXeno(A))
		return damage * XVX_SLASH_DAMAGEMULT
	return damage