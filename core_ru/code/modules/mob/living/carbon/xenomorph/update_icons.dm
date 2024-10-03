//Xeno Overlays Indexes//////////
#define X_HALO_LAYER 11
#define X_BACK_LAYER 10
#define X_HEAD_LAYER 9
#define X_SUIT_LAYER 8
#define X_L_HAND_LAYER 7
#define X_R_HAND_LAYER 6
#define X_BACK_FRONT_LAYER 5
#define X_RESOURCE_LAYER 4
#define X_TARGETED_LAYER 3
#define X_LEGCUFF_LAYER 2
#define X_FIRE_LAYER 1
/////////////////////////////////

/mob/living/carbon/xenomorph/proc/create_halo()
	if(has_halo)
		return

	overlays_standing[X_HALO_LAYER] = image("icon" = 'core_ru/code/modules/battlepass/rewards/sprites/halo.dmi', "icon_state" = get_halo_iconname())
	apply_overlay(X_HALO_LAYER)
	has_halo = TRUE

/mob/living/carbon/xenomorph/proc/create_evil_halo()
	if(has_halo)
		return

	overlays_standing[X_HALO_LAYER] = image("icon" = 'core_ru/code/modules/battlepass/rewards/sprites/halo_red.dmi', "icon_state" = get_halo_iconname())
	apply_overlay(X_HALO_LAYER)
	has_halo = TRUE

//Xeno Overlays Indexes//////////
#undef X_TOTAL_LAYERS
#undef X_FIRE_LAYER
#undef X_LEGCUFF_LAYER
#undef X_TARGETED_LAYER
#undef X_RESOURCE_LAYER
#undef X_BACK_FRONT_LAYER
#undef X_R_HAND_LAYER
#undef X_L_HAND_LAYER
#undef X_SUIT_LAYER
#undef X_HEAD_LAYER
#undef X_BACK_LAYER
#undef X_HALO_LAYER
