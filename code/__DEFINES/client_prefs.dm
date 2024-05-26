#define BE_ALIEN_AFTER_DEATH (1<<0)
#define BE_AGENT (1<<1)

//toggle_prefs bits from /datum/preferences
#define TOGGLE_IGNORE_SELF (1<<0) // Determines whether you will not hurt yourself when clicking yourself
#define TOGGLE_HELP_INTENT_SAFETY (1<<1) // Determines whether help intent will be completely harmless
#define TOGGLE_MIDDLE_MOUSE_CLICK (1<<2) // This toggles whether selected ability for xeno uses middle mouse clicking or shift clicking
#define TOGGLE_DIRECTIONAL_ATTACK (1<<3) // This toggles whether attacks for xeno use directional attacks
#define TOGGLE_AUTO_EJECT_MAGAZINE_OFF (1<<4) // This toggles whether guns with auto ejectors will not auto eject their magazines
												   // MUTUALLY EXCLUSIVE TO TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND
#define TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND (1<<5) // This toggles whether guns with auto ejectors will cause you to unwield your gun and put the empty magazine in your hand
												   // MUTUALLY EXCLUSIVE TO TOGGLE_AUTO_EJECT_MAGAZINE
#define TOGGLE_EJECT_MAGAZINE_TO_HAND (1<<6) // This toggles whether manuallye jecting magazines from guns will cause you to unwield your gun
												   // and put the empty magazine in your hand
#define TOGGLE_AUTOMATIC_PUNCTUATION (1<<7) // Whether your sentences will automatically be punctuated with a period
#define TOGGLE_COMBAT_CLICKDRAG_OVERRIDE (1<<8) // Whether disarm/harm intents cause clicks to trigger immediately when the mouse button is depressed.
#define TOGGLE_ALTERNATING_DUAL_WIELD (1<<9) // Whether dual-wielding fires both guns at once or swaps between them, OUTDATED, used to update savefiles, now dual_wield_pref
#define TOGGLE_FULLSCREEN (1<<10) // See /client/proc/toggle_fullscreen in client_procs.dm
#define TOGGLE_MEMBER_PUBLIC (1<<11) //determines if you get a byond logo by your name in ooc if you're a member or not
#define TOGGLE_OOC_FLAG (1<<12) // determines if your country flag appears by your name in ooc chat
#define TOGGLE_MIDDLE_MOUSE_SWAP_HANDS (1<<13) //Toggle whether middle click swaps your hands
#define TOGGLE_AMBIENT_OCCLUSION (1<<14) // toggles if ambient occlusion is turned on or off
#define TOGGLE_VEND_ITEM_TO_HAND (1<<15) // This toggles whether items from vendors will be automatically put into your hand.
#define TOGGLE_START_JOIN_CURRENT_SLOT (1<<16) // Whether joining at roundstart ignores assigned character slot for the job and uses currently selected slot.
#define TOGGLE_LATE_JOIN_CURRENT_SLOT (1<<17) //Whether joining during the round ignores assigned character slot for the job and uses currently selected slot.
#define TOGGLE_ABILITY_DEACTIVATION_OFF (1<<18) // This toggles whether selecting the same ability again can toggle it off
#define TOGGLE_AMMO_DISPLAY_TYPE (1<<19)/// limit how often the ammo is displayed when using semi-automatic fire

#define JOB_SLOT_RANDOMISED_SLOT -1
#define JOB_SLOT_CURRENT_SLOT 0
#define JOB_SLOT_RANDOMISED_TEXT "Randomise name and appearance"
#define JOB_SLOT_CURRENT_TEXT "Current character"

#define AGE_MIN 19 //youngest a character can be
#define AGE_MAX 90 //oldest a character can be //no. you are not allowed to be 160.
#define MAX_GEAR_COST 7 //Used in chargen for loadout limit.

///dual_wield_pref from /datum/preferences
///Fire both weapons when dual wielding
#define DUAL_WIELD_FIRE 0
///Swap to the other weapon when dual wielding
#define DUAL_WIELD_SWAP 1
///Do nothing when dual wielding
#define DUAL_WIELD_NONE 2
