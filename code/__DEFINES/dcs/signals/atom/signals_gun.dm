#define COMSIG_GUN_FIRE "gun_fire"
#define COMSIG_GUN_STOP_FIRE "gun_stop_fire"
#define COMSIG_GUN_FIRE_MODE_TOGGLE "gun_fire_mode_toggle"
#define COMSIG_GUN_AUTOFIREDELAY_MODIFIED "gun_autofiredelay_modified"
#define COMSIG_GUN_BURST_SHOTS_TO_FIRE_MODIFIED "gun_burst_shots_to_fire_modified"
#define COMSIG_GUN_BURST_SHOT_DELAY_MODIFIED "gun_burst_shot_delay_modified"
#define COMSIG_GUN_NEXT_FIRE_MODIFIED "gun_next_fire_modified"

#define COMSIG_GUN_VULTURE_FIRED_ONEHAND "gun_vulture_fired_onehand"
#define COMSIG_VULTURE_SCOPE_MOVED "vulture_scope_moved"
#define COMSIG_VULTURE_SCOPE_SCOPED "vulture_scope_scoped"
#define COMSIG_VULTURE_SCOPE_UNSCOPED "vulture_scope_unscoped"

/// from /obj/item/weapon/gun/proc/recalculate_attachment_bonuses() : ()
#define COMSIG_GUN_RECALCULATE_ATTACHMENT_BONUSES "gun_recalculate_attachment_bonuses"

/// from  /obj/item/weapon/gun/proc/load_into_chamber() : ()
#define COMSIG_GUN_INTERRUPT_FIRE "gun_interrupt_fire"

//Signals for automatic fire at component
#define COMSIG_AUTO_START_SHOOTING_AT "auto_start_shooting_at"
#define COMSIG_AUTO_STOP_SHOOTING_AT "auto_stop_shooting_at"
#define COMSIG_AUTO_SHOOT "auto_shoot"

//Signals for gun auto fire component
#define COMSIG_GET_BURST_FIRE "get_burst_fire"
	#define BURST_FIRING (1<<0)

/// Called before a gun fires a projectile, note NOT point blanks, /obj/item/weapon/gun/proc/handle_fire()
#define COMSIG_GUN_BEFORE_FIRE "gun_before_fire"
	#define COMPONENT_CANCEL_GUN_BEFORE_FIRE (1<<0) //continue full-auto/burst attempts
	#define COMPONENT_HARD_CANCEL_GUN_BEFORE_FIRE (1<<1) //hard stop firing

/// Called when IFF is toggled on or off
#define COMSIG_GUN_ALT_IFF_TOGGLED "gun_iff_toggled"
