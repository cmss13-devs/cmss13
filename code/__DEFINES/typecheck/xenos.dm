//Xenomorph Hud Test APOPHIS 22MAY2015
#define isXeno(A) (istype(A, /mob/living/carbon/xenomorph))

#define isXenoOrHuman(A) (isXeno(A) || ishuman(A))
//ask walter if i should turn into castechecks
#define isXenoBoiler(A) (istype(A, /mob/living/carbon/xenomorph/boiler))
#define isXenoCarrier(A) (istype(A, /mob/living/carbon/xenomorph/carrier))
#define isXenoCrusher(A) (istype(A, /mob/living/carbon/xenomorph/crusher))
#define isXenoDrone(A) (istype(A, /mob/living/carbon/xenomorph/drone))
#define isXenoHivelord(A) (istype(A, /mob/living/carbon/xenomorph/hivelord))
#define isXenoLurker(A) (istype(A, /mob/living/carbon/xenomorph/lurker))
#define isXenoDefender(A) (istype(A, /mob/living/carbon/xenomorph/defender))
#define isXenoPredalien(A) (istype(A, /mob/living/carbon/xenomorph/predalien))
#define isXenoLarva(A) (istype(A, /mob/living/carbon/xenomorph/larva))
#define isXenoLarvaStrict(A) (isXenoLarva(A) && !istype(A, /mob/living/carbon/xenomorph/larva/predalien))
#define isXenoFacehugger(A) (istype(A, /mob/living/carbon/xenomorph/facehugger))
#define isXenoPraetorian(A) (istype(A, /mob/living/carbon/xenomorph/praetorian))
#define isXenoQueen(A) (istype(A, /mob/living/carbon/xenomorph/queen))
#define isXenoQueenLeadingHive(A) (isXenoQueen(A) && A?:hive?:living_xeno_queen == A)
#define isXenoRavager(A) (istype(A, /mob/living/carbon/xenomorph/ravager))
#define isXenoRunner(A) (istype(A, /mob/living/carbon/xenomorph/runner))
#define isXenoSentinel(A) (istype(A, /mob/living/carbon/xenomorph/sentinel))
#define isXenoSpitter(A) (istype(A, /mob/living/carbon/xenomorph/spitter))
#define isXenoWarrior(A) (istype(A, /mob/living/carbon/xenomorph/warrior))
#define isXenoBurrower(A) (istype(A, /mob/living/carbon/xenomorph/burrower))

#define isXenoBuilder(A) (isXenoDrone(A) || isXenoHivelord(A) || isXenoCarrier(A) || isXenoBurrower(A) || isXenoQueen(A))

/mob/living/carbon/xenomorph/proc/can_not_harm(var/mob/living/carbon/C)
	if(!istype(C))
		return FALSE

	if(!hive)
		hive = GLOB.hive_datum[hivenumber]

	if(!hive)
		return FALSE

	return hive.is_ally(C)

// need this to set the data for walls/eggs/huggers when they are initialized
/proc/set_hive_data(atom/A, hivenumber)
	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
	if (hive.color)
		A.color = hive.color
	A.name = "[lowertext(hive.prefix)][A.name]"

/proc/get_xeno_stun_duration(mob/A, duration)
	if(isCarbonSizeXeno(A))
		return duration * XVX_STUN_LENGTHMULT
	return duration

/proc/get_xeno_damage_slash(mob/A, damage)
	if(isCarbonSizeXeno(A))
		return damage * XVX_SLASH_DAMAGEMULT
	return damage

/proc/get_xeno_damage_acid(mob/target_mob, damage)
	if(isXeno(target_mob))
		return damage * XVX_ACID_DAMAGEMULT
	return damage
