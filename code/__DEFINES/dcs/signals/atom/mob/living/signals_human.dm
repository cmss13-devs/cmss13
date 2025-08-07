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
/// From /mob/living/carbon/human/bullet_act(): (damage_result, ammo_flags, obj/projectile/P)
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
/// From /datum/flaying_datum
#define COMSIG_HUMAN_FLAY_ATTEMPT "human_flay_attempt"

#define COMSIG_HUMAN_BONEBREAK_PROBABILITY "human_bonebreak_probability"

#define COMSIG_HUMAN_UPDATE_SIGHT "human_update_sight"
	#define COMPONENT_OVERRIDE_UPDATE_SIGHT (1<<0)

///from /mob/living/carbon/human/movement_delay()
#define COMSIG_HUMAN_MOVEMENT_CANCEL_INTERACTION "human_movement_cancel_interaction"
	#define COMPONENT_HUMAN_MOVEMENT_KEEP_USING (1<<0)

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

/// From /mob/proc/equip_to_slot_if_possible()
#define COMSIG_HUMAN_ATTEMPTING_EQUIP "human_attempting_equip"
	#define COMPONENT_HUMAN_CANCEL_ATTEMPT_EQUIP (1<<0)

//from /mob/living/carbon/human/Life()
#define COMSIG_HUMAN_SET_UNDEFIBBABLE "human_set_undefibbable"

/// from /datum/surgery_step/proc/attempt_step()
#define COMSIG_HUMAN_SURGERY_APPLY_MODIFIERS "human_surgery_apply_modifiers"

/// From /datum/surgery_step/proc/success() : (mob/user, mob/living/carbon/target, datum/surgery/surgery, obj/item/tool)
#define COMSIG_HUMAN_SURGERY_STEP_SUCCESS "human_surgery_step_success"

/// From /mob/living/carbon/human/proc/get_flags_cold_protection()
#define COMSIG_HUMAN_COLD_PROTECTION_APPLY_MODIFIERS "human_cold_protection_apply_modifiers"

/// From /obj/item/proc/dig_out_shrapnel() : ()
#define COMSIG_HUMAN_SHRAPNEL_REMOVED "human_shrapnel_removed"

/// From /obj/item/reagent_container/pill/attack() : (mob/living/carbon/human/attacked_mob)
#define COMSIG_HUMAN_PILL_FED "human_pill_fed"

/// From /mob/living/carbon/human/attack_hand() : (successful)
// Sends to attacking mob, successful TRUE or FALSE
#define COMSIG_HUMAN_CPR_PERFORMED "human_cpr_performed"

#define COMSIG_HUMAN_HM_TUTORIAL_TREATED "human_hm_tutorial_treated"

/// From /mob/living/carbon/human/UnarmedAttack()
#define COMSIG_HUMAN_UNARMED_ATTACK "human_unarmed_attack"

/// From /mob/living/carbon/human/hud_set_holocard()
#define COMSIG_HUMAN_TRIAGE_CARD_UPDATED "human_triage_card_updated"
