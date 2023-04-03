///from /mob/living/carbon/human/proc/force_say(): ()
#define COMSIG_HUMAN_FORCESAY "human_forcesay"

#define COMSIG_HUMAN_TAKE_DAMAGE "human_take_damage"
	#define COMPONENT_BLOCK_DAMAGE (1<<0)

/// From /mob/living/carbon/human/ExtinguishMob()
#define COMSIG_HUMAN_EXTINGUISH "human_extinguish"


/// From /obj/item/device/defibrillator/attack
#define COMSIG_HUMAN_REVIVED "human_revived"
/// From /mob/living/carbon/human/bullet_act
#define COMSIG_HUMAN_PRE_BULLET_ACT "human_pre_bullet_act"
/// From /mob/living/carbon/human/bullet_act(): (damage_result, ammo_flags, obj/item/projectile/P)
#define COMSIG_HUMAN_BULLET_ACT "human_bullet_act"
	#define COMPONENT_CANCEL_BULLET_ACT (1<<0)

/// From /obj/effect/decal/cleanable/blood/Crossed(): (amount, bcolor, dry_time_left)
#define COMSIG_HUMAN_BLOOD_CROSSED "human_blood_crossed"
#define COMSIG_HUMAN_CLEAR_BLOODY_FEET "human_clear_bloody_feet"
/// from /mob/living/carbon/human/attack_alien()
#define COMSIG_HUMAN_ALIEN_ATTACK "human_alien_attack"
/// From /obj/item/clothing/mask/facehugger/proc/impregnate(): (obj/item/clothing/mask/facehugger/hugger)
#define COMSIG_HUMAN_IMPREGNATE "human_impregnate"
	#define COMPONENT_NO_IMPREGNATE (1<<0)
/// From /mob/living/carbon/human/apply_overlay(): (cache_index, overlay_image)
#define COMSIG_HUMAN_OVERLAY_APPLIED "human_overlay_applied"
/// From /mob/living/carbon/human/remove_overlay(): (cache_index, overlay_image)
#define COMSIG_HUMAN_OVERLAY_REMOVED "human_overlay_removed"

#define COMSIG_HUMAN_BONEBREAK_PROBABILITY "human_bonebreak_probability"

#define COMSIG_HUMAN_UPDATE_SIGHT "human_update_sight"
	#define COMPONENT_OVERRIDE_UPDATE_SIGHT (1<<0)

///from /mob/living/carbon/human/update_sight()
#define COMSIG_HUMAN_POST_UPDATE_SIGHT "human_post_update_sight"
///from /mob/living/carbon/human/movement_delay(): (list/movedata)
#define COMSIG_HUMAN_POST_MOVE_DELAY "human_post_move_delay"

#define COMSIG_HUMAN_XENO_ATTACK "human_attack_alien"
	#define COMPONENT_CANCEL_XENO_ATTACK (1<<0)

/// From /mob/living/carbon/human/MouseDrop_T(atom/dropping, mob/user)
//this is a jank way to use signals, but you would need to rework the entire proc otherwise
#define COMSIG_HUMAN_CARRY "fireman_carry"
	#define COMPONENT_CARRY_ALLOW (1<<0)

//from /mob/living/carbon/human/equip_to_slot()
#define COMSIG_HUMAN_EQUIPPED_ITEM "human_equipped_item"

//from /mob/living/carbon/human/Life()
#define COMSIG_HUMAN_SET_UNDEFIBBABLE "human_set_undefibbable"
