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
#define DEL_ON_DEATH (1<<0) //Delete the effect when something dies
#define DEL_ON_LIVING (1<<1) //Delete the effect when something is alive
#define INF_DURATION (1<<2) //An effect that lasts forever
#define NO_PROCESS_ON_DEATH (1<<3) //Don't process while the mob is dead
#define DEL_ON_UNDEFIBBABLE (1<<4) //Delete the effect when human mob is undefibbable
#define EFFECT_NO_PROCESS (1<<5) //! Do not process this effect at all

/datum/effects
	/// Name of the effect
	var/effect_name = "standard"
	///How long it lasts
	var/duration = 0
	///Flags for the effect
	var/flags = DEL_ON_DEATH
	///The affected atom
	var/atom/affected_atom = null
	///The area affected if its a mob
	var/def_zone = "chest"
	///The icon path if the effect should apply an overlay to things
	var/icon_path = null
	///The icon_state path for objs
	var/obj_icon_state_path = null
	///The icon_state path for mobs
	var/mob_icon_state_path = null
	///Cause data for statistics
	var/datum/cause_data/cause_data = null

/datum/effects/New(atom/thing, mob/from = null, last_dmg_source = null, zone = "chest")
	if(!validate_atom(thing) || QDELETED(thing))
		qdel(src)
		return
	if(flags & EFFECT_NO_PROCESS)
		START_PROCESSING(SSeffects, src)

	affected_atom = thing
	LAZYADD(affected_atom.effects_list, src)
	on_apply_effect()
	def_zone = zone
	cause_data = create_cause_data(last_dmg_source, from)

/datum/effects/proc/validate_atom(atom/thing)
	if(iscarbon(thing) || isobj(thing))
		return TRUE

	return FALSE

/datum/effects/proc/on_apply_effect()
	return

/datum/effects/process()
	if(QDELETED(affected_atom) || (duration <= 0 && !(flags & INF_DURATION)))
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
	STOP_PROCESSING(SSeffects, src)
	. = ..()



