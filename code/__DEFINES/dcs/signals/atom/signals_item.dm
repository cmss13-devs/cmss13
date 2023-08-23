#define COMSIG_ITEM_ATTACK "item_attack" //Triggered on the item.
#define COMSIG_ITEM_ATTEMPT_ATTACK "item_attempt_attack" //Triggered on the target mob.
	#define COMPONENT_CANCEL_ATTACK (1<<0)

#define COMSIG_ITEM_ATTACK_AIRLOCK "item_attack_airlocK"
	#define COMPONENT_CANCEL_AIRLOCK_ATTACK (1<<0)

/// from /obj/item/attackby() : (obj/item, mob/user)
#define COMSIG_ITEM_ATTACKED "item_attacked"
	#define COMPONENT_CANCEL_ITEM_ATTACK (1<<0)

// Return a nonzero value to cancel these actions
#define COMSIG_BINOCULAR_ATTACK_SELF "binocular_attack_self"
#define COMSIG_BINOCULAR_HANDLE_CLICK "binocular_handle_click"

///from base of obj/item/dropped(): (mob/user)
#define COMSIG_ITEM_DROPPED "item_drop"
/// From base of /obj/item/proc/equipped(): (mob/user, slot)
#define COMSIG_ITEM_EQUIPPED "item_equipped"
/// From base of /obj/item/proc/unequipped(): (mob/user, slot)
#define COMSIG_ITEM_UNEQUIPPED "item_unequipped"
///from /obj/item/proc/unwield
#define COMSIG_ITEM_UNWIELD "item_unwield"
/// From base of /obj/item/proc/attack_self(): (mob/user)
#define COMSIG_ITEM_ATTACK_SELF "item_attack_self"

///from /obj/item/reagent_container/food/snacks/proc/On_Consume
#define COMSIG_SNACK_EATEN "snack_eaten"

#define COMSIG_ITEM_PICKUP "item_pickup"

/// from /obj/item/proc/mob_can_equip
#define COMSIG_ITEM_ATTEMPTING_EQUIP "item_attempting_equip"
///Return this in response if you don't want items equipped
	#define COMPONENT_CANCEL_EQUIP (1<<0)

/// from /obj/item/proc/do_zoom() : (mob/user)
#define COMSIG_ITEM_ZOOM "item_zoom"
/// from /obj/item/proc/unzoom() : (mob/user)
#define COMSIG_ITEM_UNZOOM "item_unzoom"

//Signals for automatic fire at component
#define COMSIG_AUTOMATIC_SHOOTER_START_SHOOTING_AT "start_shooting_at"
#define COMSIG_AUTOMATIC_SHOOTER_STOP_SHOOTING_AT "stop_shooting_at"
#define COMSIG_AUTOMATIC_SHOOTER_SHOOT "shoot"

//Signals for gun auto fire component
#define COMSIG_GET_BURST_FIRE "get_burst_fire"
	#define BURST_FIRING (1<<0)

#define COMSIG_GUN_FIRE "gun_fire"
#define COMSIG_GUN_STOP_FIRE "gun_stop_fire"
#define COMSIG_GUN_FIRE_MODE_TOGGLE "gun_fire_mode_toggle"
#define COMSIG_GUN_AUTOFIREDELAY_MODIFIED "gun_autofiredelay_modified"
#define COMSIG_GUN_BURST_SHOTS_TO_FIRE_MODIFIED "gun_burst_shots_to_fire_modified"
#define COMSIG_GUN_BURST_SHOT_DELAY_MODIFIED "gun_burst_shot_delay_modified"
