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
	#define COMSIG_ITEM_PICKUP_CANCELLED (1<<0)

///from /obj/item/device/broadcasting
#define COMSIG_BROADCAST_GO_LIVE "broadcast_live"
#define COMSIG_BROADCAST_HEAR_TALK "broadcast_hear_talk"
#define COMSIG_BROADCAST_SEE_EMOTE "broadcast_see_emote"

/// from /obj/item/proc/mob_can_equip
#define COMSIG_ITEM_ATTEMPTING_EQUIP "item_attempting_equip"
///Return this in response if you don't want items equipped
	#define COMPONENT_CANCEL_EQUIP (1<<0)

/// from /obj/item/proc/do_zoom() : (mob/user)
#define COMSIG_ITEM_ZOOM "item_zoom"
/// from /obj/item/proc/unzoom() : (mob/user)
#define COMSIG_ITEM_UNZOOM "item_unzoom"

//from /datum/authority/branch/role/proc/equip_role()
#define COMSIG_POST_SPAWN_UPDATE "post_spawn_update"

#define COMSIG_CAMERA_MAPNAME_ASSIGNED "camera_manager_mapname_assigned"
#define COMSIG_CAMERA_REGISTER_UI "camera_manager_register_ui"
#define COMSIG_CAMERA_UNREGISTER_UI "camera_manager_unregister_ui"
#define COMSIG_CAMERA_SET_NVG "camera_manager_set_nvg"
#define COMSIG_CAMERA_CLEAR_NVG "camera_manager_clear_nvg"
#define COMSIG_CAMERA_SET_TARGET "camera_manager_set_target"
#define COMSIG_CAMERA_SET_AREA "camera_manager_set_area"
#define COMSIG_CAMERA_CLEAR "camera_manager_clear_target"
#define COMSIG_CAMERA_REFRESH "camera_manager_refresh"

#define COMSIG_PRED_BRACER_DECLOAKED "pred_bracer_decloaked"

//from /datum/component/overwatch_console_control
#define COMSIG_OW_CONSOLE_OBSERVE_START "ow_console_observe_start"
#define COMSIG_OW_CONSOLE_OBSERVE_END "ow_console_observe_end"
