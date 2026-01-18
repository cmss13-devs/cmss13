// From obj/limb/proc/take_damage()
// Sent after the limb has taken damage
#define COMSIG_LIMB_TAKEN_DAMAGE "limb_taken_damage"

// From /datum/effects/bleeding/internal/process_mob() and /datum/effects/bleeding/external/process_mob()
#define COMSIG_BLEEDING_PROCESS "bleeding_process"
	#define COMPONENT_BLEEDING_CANCEL (1<<0)

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

#define COMSIG_STRUCTURE_WRENCHED "structure_wrenched"
#define COMSIG_STRUCTURE_UNWRENCHED "structure_unwrenched"
/// from /obj/structure/Collided() if not overriden for /datum/component/shimmy_around
#define COMSIG_STRUCTURE_COLLIDED "structure_collided"

#define COMSIG_TENT_COLLAPSING "tent_collapsing"

/// from /obj/proc/afterbuckle()
#define COMSIG_OBJ_AFTER_BUCKLE "signal_obj_after_buckle"

/// from /datum/cm_objective/retrieve_data/disk/process()
#define COMSIG_INTEL_DISK_LOST_POWER "intel_disk_lost_power"

/// from /datum/cm_objective/retrieve_data/disk/complete()
#define COMSIG_INTEL_DISK_COMPLETED "intel_disk_completed"

/// from /obj/vehicle/multitile/arc/toggle_antenna()
#define COMSIG_ARC_ANTENNA_TOGGLED "arc_antenna_toggled"
/// from /obj/structure/machinery/cryopod/go_out()
#define COMSIG_CRYOPOD_GO_OUT "cryopod_go_out"

/// from /proc/vendor_successful_vend() : (obj/structure/machinery/cm_vending/vendor, list/itemspec, mob/living/carbon/human/user)
#define COMSIG_VENDOR_SUCCESSFUL_VEND "vendor_successful_vend"

/// from /obj/limb/proc/remove_all_bleeding() : (external, internal)
#define COMSIG_LIMB_STOP_BLEEDING "limb_stop_bleeding"

#define COMSIG_DROPSHIP_ADD_EQUIPMENT "dropship_add_equipment"
#define COMSIG_DROPSHIP_REMOVE_EQUIPMENT "dropship_remove_equipment"

#define COMSIG_STRUCTURE_CRATE_SQUAD_LAUNCHED "structure_crate_squad_launched"

// from /obj/item/device/binoculars/range/designator/acquire_target()
#define COMSIG_DESIGNATOR_LASE "comsig_designator_lase"
#define COMSIG_DESIGNATOR_LASE_OFF "comsig_designator_lase_off"
