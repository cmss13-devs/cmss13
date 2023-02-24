// From obj/limb/proc/take_damage()
// Sent after the limb has taken damage
#define COMSIG_LIMB_TAKEN_DAMAGE "limb_taken_damage"

/// From /obj/effect/alien/weeds/Initialize()
#define COMSIG_WEEDNODE_GROWTH_COMPLETE "weednode_growth_complete"
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
