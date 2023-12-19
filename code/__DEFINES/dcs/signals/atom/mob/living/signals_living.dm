/// From /mob/living/verb/resist()
#define COMSIG_MOB_RESISTED "mob_resist"
/// From /mob/living/verb/resist()
#define COMSIG_MOB_RECALCULATE_CLIENT_COLOR "mob_recalc_client_color"

/// From /mob/living/rejuvenate
#define COMSIG_LIVING_REJUVENATED "living_rejuvenated"
/// From /mob/living/proc/IgniteMob
#define COMSIG_LIVING_PREIGNITION "living_preignition"
	#define COMPONENT_CANCEL_IGNITION (1<<0)
#define COMSIG_LIVING_IGNITION "living_ignition"

/// From /obj/flamer_fire/Crossed
#define COMSIG_LIVING_FLAMER_CROSSED "living_flamer_crossed"
/// From /obj/flamer_fire/Initialize
#define COMSIG_LIVING_FLAMER_FLAMED "living_flamer_flamed"
	#define COMPONENT_NO_BURN (1<<0)
	#define COMPONENT_NO_IGNITE (1<<1)
	#define COMPONENT_XENO_FRENZY (1<<2)
/// From /obj/item/proc/unzoom
#define COMSIG_LIVING_ZOOM_OUT "living_zoom_out"

#define COMSIG_LIVING_SPEAK "living_speak"
	#define COMPONENT_OVERRIDE_SPEAK (1<<0)

/// From /obj/structure/proc/do_climb(var/mob/living/user, mods)
#define COMSIG_LIVING_CLIMB_STRUCTURE "climb_over_structure"
/// From /mob/living/Collide(): (atom/A)
#define COMSIG_LIVING_PRE_COLLIDE "living_pre_collide"
	#define COMPONENT_LIVING_COLLIDE_HANDLED (1<<0)

///from base of mob/living/set_buckled(): (new_buckled)
#define COMSIG_LIVING_SET_BUCKLED "living_set_buckled"
///from base of mob/living/set_body_position()
#define COMSIG_LIVING_SET_BODY_POSITION  "living_set_body_position"
