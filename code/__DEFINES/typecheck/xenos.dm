//Xenomorph Hud Test APOPHIS 22MAY2015
#define isxeno(A) (istype(A, /mob/living/carbon/xenomorph))

#define isxeno_human(A) (isxeno(A) || ishuman(A))
//ask walter if i should turn into castechecks
#define isboiler(A) (istype(A, /mob/living/carbon/xenomorph/boiler))
#define iscarrier(A) (istype(A, /mob/living/carbon/xenomorph/carrier))
#define iscrusher(A) (istype(A, /mob/living/carbon/xenomorph/crusher))
#define isdrone(A) (istype(A, /mob/living/carbon/xenomorph/drone))
#define ishivelord(A) (istype(A, /mob/living/carbon/xenomorph/hivelord))
#define islurker(A) (istype(A, /mob/living/carbon/xenomorph/lurker))
#define isdefender(A) (istype(A, /mob/living/carbon/xenomorph/defender))
#define ispredalien(A) (istype(A, /mob/living/carbon/xenomorph/predalien))
#define islarva(A) (istype(A, /mob/living/carbon/xenomorph/larva))
#define ispredalienlarva(A) (istype(A, /mob/living/carbon/xenomorph/larva/predalien))
#define isfacehugger(A) (istype(A, /mob/living/carbon/xenomorph/facehugger))
#define islesserdrone(A) (istype(A, /mob/living/carbon/xenomorph/lesser_drone))
#define ispraetorian(A) (istype(A, /mob/living/carbon/xenomorph/praetorian))
#define isqueen(A) (istype(A, /mob/living/carbon/xenomorph/queen))
#define isravager(A) (istype(A, /mob/living/carbon/xenomorph/ravager))
#define isrunner(A) (istype(A, /mob/living/carbon/xenomorph/runner))
#define issentinel(A) (istype(A, /mob/living/carbon/xenomorph/sentinel))
#define isspitter(A) (istype(A, /mob/living/carbon/xenomorph/spitter))
#define iswarrior(A) (istype(A, /mob/living/carbon/xenomorph/warrior))
#define isburrower(A) (istype(A, /mob/living/carbon/xenomorph/burrower))

#define isxeno_builder(A) (isdrone(A) || ishivelord(A) || iscarrier(A) || isburrower(A) || isqueen(A))

/// Returns true/false based on if the xenomorph can harm the passed carbon mob.
/mob/living/carbon/xenomorph/proc/can_not_harm(mob/living/carbon/attempt_harm_mob)
	if(!istype(attempt_harm_mob))
		return FALSE

	if(!hive)
		hive = GLOB.hive_datum[hivenumber]

	if(!hive)
		return FALSE

	if(hivenumber == XENO_HIVE_RENEGADE)
		var/datum/hive_status/corrupted/renegade/renegade_hive = hive
		return renegade_hive.iff_protection_check(src, attempt_harm_mob)

	if(HAS_TRAIT(attempt_harm_mob, TRAIT_HAULED))
		return TRUE

	return hive.is_ally(attempt_harm_mob)

/mob/living/carbon/xenomorph/proc/claw_restrained()
	if(legcuffed && legcuffed.stop_xeno_slash)
		return TRUE
	return FALSE

// need this to set the data for walls/eggs/huggers when they are initialized
/proc/set_hive_data(atom/focused_atom, hivenumber)
	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
	if (hive.color)
		focused_atom.color = hive.color
	focused_atom.name = "[lowertext(hive.prefix)][focused_atom.name]"

/proc/get_xeno_stun_duration(mob/stun_mob, duration)
	if(iscarbonsizexeno(stun_mob))
		return duration * XVX_STUN_LENGTHMULT
	return duration

/proc/get_xeno_damage_slash(mob/slash_mob, damage)
	if(iscarbonsizexeno(slash_mob))
		return damage * XVX_SLASH_DAMAGEMULT
	return damage

/proc/get_xeno_damage_acid(mob/target_mob, damage)
	if(isxeno(target_mob))
		return damage * XVX_ACID_DAMAGEMULT
	return damage
