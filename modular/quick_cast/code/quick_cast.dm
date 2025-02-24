#define QUICK_CAST_OVERRIDE(subtype)\
/datum/action##subtype/action_activate(){\
	if(hidden){\
		return ..();\
	}\
	var/client/client = owner.client;\
	if(!client.prefs.quick_cast){\
		return ..();\
	}\
	var/atom/target = client.hovered_over;\
	if(!target){\
		return;\
	}\
	if(istype(target, /atom/movable/screen/action_button)){\
		return ..();\
	}\
	if(istype(target, /atom/movable/screen)){\
		return;\
	}\
	if(owner.get_selected_ability() == src){\
		call(src, /datum/action::action_activate())();\
	}\else{\
		. = ..();\
	}\
	use_ability(target, params2list(client.last_hover_over_params));\
}

QUICK_CAST_OVERRIDE(/xeno_action/activable)
QUICK_CAST_OVERRIDE(/human_action/activable)
QUICK_CAST_OVERRIDE(/item_action/hover)
QUICK_CAST_OVERRIDE(/item_action/specialist/aimed_shot)
QUICK_CAST_OVERRIDE(/item_action/specialist/spotter_target)
