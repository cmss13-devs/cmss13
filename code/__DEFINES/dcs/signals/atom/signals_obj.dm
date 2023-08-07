// From obj/limb/proc/take_damage()
// Sent after the limb has taken damage
#define COMSIG_LIMB_TAKEN_DAMAGE "limb_taken_damage"

/// From /obj/effect/alien/weeds/Initialize()
#define COMSIG_WEEDNODE_GROWTH_COMPLETE "weednode_growth_complete"
/// From /obj/effect/alien/weeds/Initialize()
#define COMSIG_WEEDNODE_GROWTH "weednode_growth"
/// From /obj/effect/alien/weeds/proc/on_weed_expand()
#define COMSIG_WEEDNODE_CANNOT_EXPAND_FURTHER "weednode_cannot_expand_further"

/// shuttle mode change
#define COMSIG_SHUTTLE_SETMODE "shuttle_setmode"

#define COMSIG_GRENADE_PRE_PRIME "grenade_pre_prime"
	#define COMPONENT_GRENADE_PRIME_CANCEL (1<<0)

#define COMSIG_CLOSET_FLASHBANGED "closet_flashbanged"

#define COMSIG_SENTRY_ENGAGED_ALERT "signal_sentry_engaged"
#define COMSIG_SENTRY_LOW_AMMO_ALERT "signal_sentry_low_ammo"
#define COMSIG_SENTRY_EMPTY_AMMO_ALERT "signal_sentry_empty_ammo"
#define COMSIG_SENTRY_DESTROYED_ALERT "signal_sentry_destroyed"

/// from /obj/structure/transmitter/update_icon()
#define COMSIG_TRANSMITTER_UPDATE_ICON "transmitter_update_icon"

#define COMSIG_TENT_COLLAPSING "tent_collapsing"

/// from /obj/proc/afterbuckle()
#define COSMIG_OBJ_AFTER_BUCKLE "signal_obj_after_buckle"

/// from /datum/cm_objective/retrieve_data/disk/process()
#define COMSIG_INTEL_DISK_LOST_POWER "intel_disk_lost_power"

/// from /datum/cm_objective/retrieve_data/disk/complete()
#define COMSIG_INTEL_DISK_COMPLETED "intel_disk_completed"

/// from /obj/vehicle/multitile/arc/toggle_antenna()
#define COMSIG_ARC_ANTENNA_TOGGLED "arc_antenna_toggled"
