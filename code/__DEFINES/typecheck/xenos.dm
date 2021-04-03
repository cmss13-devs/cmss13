//Xenomorph Hud Test APOPHIS 22MAY2015
#define isXeno(A) (istype(A, /mob/living/carbon/Xenomorph))

#define isXenoOrHuman(A) (isXeno(A) || ishuman(A))
//ask walter if i should turn into castechecks
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

/mob/living/carbon/Xenomorph/proc/can_not_harm(var/mob/living/carbon/C)
	if(!istype(C))
		return FALSE

	if(!hive)
		hive = GLOB.hive_datum[hivenumber]

	if(!hive)
		return FALSE

	return hive.is_ally(C)

// need this to set the data for walls/eggs/huggers when they are initialized
/proc/set_hive_data(var/atom/A, hivenumber)
	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
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
