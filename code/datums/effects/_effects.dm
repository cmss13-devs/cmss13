/*
	What does it do?
	This is used to apply effects to atoms. Effects are intended to be things such as fire, acid, slow or even stun.
	By default, only affects mobs and objs, but can be modified to handle other atoms by changing the validate atoms proc.

	How does it work?
	Atom has a var/list/effects_list which is used to hold all the active effects on that atom.
	A subystem called "Effects" is used to process() every effect every second.

	How to create one?
	Make a new /datum/effects/name in the folder effects
	Overwrite existing procs to fit the wanted behaviour

	How to apply one?
	Create a new /datum/effects/whatever with the object inside the arguments
	Done
*/

/*
	FLAGS FOR EFFECTS
	They determine when an effect should be processed or deleted
*/
#define DEL_ON_DEATH	1	//Delete the effect when something dies
#define DEL_ON_LIVING	2	//Delete the effect when something is alive
#define INF_DURATION	4	//An effect that lasts forever
#define NO_PROCESS_ON_DEATH	8	//Don't process while the mob is dead
#define DEL_ON_UNDEFIBBABLE 16	//Delete the effect when human mob is undefibbable

/datum/effects
	var/effect_name = "standard"		//Name of the effect
	var/duration = 0					//How long it lasts
	var/flags = DEL_ON_DEATH 			//Flags for the effect
	var/atom/affected_atom = null		//The affected atom
	var/def_zone = "chest"				//The area affected if its a mob
	var/icon_path = null				//The icon path if the effect should apply an overlay to things
	var/obj_icon_state_path = null		//The icon_state path for objs
	var/mob_icon_state_path = null		//The icon_state path for mobs
	var/source_mob = null				//Source mob for statistics
	var/source = null					//Damage source for statistics

/datum/effects/New(var/atom/A, var/mob/from = null, var/last_dmg_source = null, var/zone = "chest")
	if(!validate_atom(A))
		qdel(src)
		return

	active_effects += src

	affected_atom = A
	LAZYADD(affected_atom.effects_list, src)
	on_apply_effect()
	def_zone = zone
	if(from && istype(from))
		source_mob = from
	if(last_dmg_source)
		source = last_dmg_source

/datum/effects/proc/validate_atom(var/atom/A)
	if(iscarbon(A) || isobj(A))
		return TRUE

	return FALSE

/datum/effects/proc/on_apply_effect()
	return

/datum/effects/process()
	if(!affected_atom || (duration <= 0 && !(flags & INF_DURATION)))
		qdel(src)
		return

	if(iscarbon(affected_atom))
		process_mob()
	else if(isobj(affected_atom))
		process_obj()
	else if(isturf(affected_atom))
		process_turf()
	else
		process_area()

	duration--

/datum/effects/proc/process_mob()
	var/mob/living/carbon/affected_mob = affected_atom
	if((flags & DEL_ON_DEATH) && affected_mob.stat == DEAD)
		qdel(src)
		return FALSE

	if((flags & DEL_ON_LIVING) && affected_mob.stat != DEAD)
		qdel(src)
		return FALSE

	if((flags & DEL_ON_UNDEFIBBABLE) && ishuman(affected_atom))
		var/mob/living/carbon/human/H = affected_atom
		if(H.undefibbable && H.stat == DEAD)
			qdel(src)
			return FALSE

	if((flags & NO_PROCESS_ON_DEATH) && affected_mob.stat == DEAD)
		return FALSE
	return TRUE

/datum/effects/proc/process_obj()
	var/obj/affected_obj = affected_atom
	if((flags & DEL_ON_DEATH) && affected_obj.health <= 0)
		qdel(src)
		return FALSE

	if((flags & DEL_ON_LIVING) && affected_obj.health > 0)
		qdel(src)
		return FALSE

	if((flags & NO_PROCESS_ON_DEATH) && affected_obj.health <= 0)
		return FALSE
	return TRUE

/datum/effects/proc/process_turf()
	return TRUE

/datum/effects/proc/process_area()
	return TRUE

/datum/effects/Destroy()
	if(affected_atom)
		LAZYREMOVE(affected_atom.effects_list, src)
		affected_atom = null
	active_effects -= src
	. = ..()



