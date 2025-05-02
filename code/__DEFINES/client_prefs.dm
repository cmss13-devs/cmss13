//=================================================
#define BE_ALIEN_AFTER_DEATH (1<<0)
#define BE_AGENT (1<<1)
#define BE_KING (1<<2)
//=================================================

// Determines how abilities are activated, whether they're activated via middle click, shift click or right click.
//=================================================
///Xeno abilities are activated using middle mouse
#define XENO_ABILITY_CLICK_MIDDLE 1
///Xeno abilities are activated using shift right click
#define XENO_ABILITY_CLICK_SHIFT 2
///Xeno abilities are activated using right click
#define XENO_ABILITY_CLICK_RIGHT 3
//=================================================

/// Update this to whatever the largest value of the XENO_ABILITY_CLICK_* defines is.
#define XENO_ABILITY_CLICK_MAX 3

//toggle_prefs bits from /datum/preferences
//=================================================
///Determines whether you will not hurt yourself when clicking yourself
#define TOGGLE_IGNORE_SELF (1<<0)
///Determines whether help intent will be completely harmless
#define TOGGLE_HELP_INTENT_SAFETY (1<<1)
// Deprecated. Can't remove this or bitshift values down because it would fuck up the savefiles
// Feel free to replace this whatever you want, if you can find a useful toggle for it. Alternatively, don't because savefiles using flags
// Is a complete and utter mistake.
///UNUSED CURRENTLY
#define TOGGLE_FREE_PLACE_YOUR_OWN_TOGGLE_HERE (1<<2)
///This toggles whether attacks for xeno use directional attacks
#define TOGGLE_DIRECTIONAL_ATTACK (1<<3)
///This toggles whether guns with auto ejectors will not auto eject their magazines
#define TOGGLE_AUTO_EJECT_MAGAZINE_OFF (1<<4)
// MUTUALLY EXCLUSIVE TO TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND
///This toggles whether guns with auto ejectors will cause you to unwield your gun and put the empty magazine in your hand
#define TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND (1<<5)
// MUTUALLY EXCLUSIVE TO TOGGLE_AUTO_EJECT_MAGAZINE
///This toggles whether manuallye jecting magazines from guns will cause you to unwield your gun and put the empty magazine in your hand
#define TOGGLE_EJECT_MAGAZINE_TO_HAND (1<<6)
///Whether your sentences will automatically be punctuated with a period
#define TOGGLE_AUTOMATIC_PUNCTUATION (1<<7)
///Whether disarm/harm intents cause clicks to trigger immediately when the mouse button is depressed.
#define TOGGLE_COMBAT_CLICKDRAG_OVERRIDE (1<<8)
///Whether dual-wielding fires both guns at once or swaps between them, OUTDATED, used to update savefiles, now dual_wield_pref
#define TOGGLE_ALTERNATING_DUAL_WIELD (1<<9)
/// See /client/proc/update_fullscreen in client_procs.dm
#define TOGGLE_FULLSCREEN (1<<10)
///determines if you get a byond logo by your name in ooc if you're a member or not
#define TOGGLE_MEMBER_PUBLIC (1<<11)
/// determines if your country flag appears by your name in ooc chat
#define TOGGLE_OOC_FLAG (1<<12)
///Toggle whether middle click swaps your hands
#define TOGGLE_MIDDLE_MOUSE_SWAP_HANDS (1<<13)
///toggles if ambient occlusion is turned on or off
#define TOGGLE_AMBIENT_OCCLUSION (1<<14)
///This toggles whether items from vendors will be automatically put into your hand.
#define TOGGLE_VEND_ITEM_TO_HAND (1<<15)
///Whether joining at roundstart ignores assigned character slot for the job and uses currently selected slot.
#define TOGGLE_START_JOIN_CURRENT_SLOT (1<<16)
///Whether joining during the round ignores assigned character slot for the job and uses currently selected slot.
#define TOGGLE_LATE_JOIN_CURRENT_SLOT (1<<17)
///This toggles whether selecting the same ability again can toggle it off
#define TOGGLE_ABILITY_DEACTIVATION_OFF (1<<18)
///limit how often the ammo is displayed when using semi-automatic fire
#define TOGGLE_AMMO_DISPLAY_TYPE (1<<19)
///Toggles between automatically shoving xenomorphs in the way as Queen.
#define TOGGLE_AUTO_SHOVE_OFF (1<<20)
///Toggles whether activating marine leader orders will be spoken or not
#define TOGGLE_LEADERSHIP_SPOKEN_ORDERS (1<<21)
//=================================================

#define JOB_SLOT_RANDOMISED_SLOT -1
#define JOB_SLOT_CURRENT_SLOT 0
#define JOB_SLOT_RANDOMISED_TEXT "Randomise name and appearance"
#define JOB_SLOT_CURRENT_TEXT "Current character"

///youngest a character can be
#define AGE_MIN 19
//oldest a character can be
#define AGE_MAX 90
///Used in chargen for loadout limit.
#define MAX_GEAR_COST 7

//dual_wield_pref from /datum/preferences
//=================================================
///Fire both weapons when dual wielding
#define DUAL_WIELD_FIRE 0
///Swap to the other weapon when dual wielding
#define DUAL_WIELD_SWAP 1
///Do nothing when dual wielding
#define DUAL_WIELD_NONE 2
//=================================================

//=================================================
///Do not show any item pickup animations
#define SHOW_ITEM_ANIMATIONS_NONE 0
///Toggles tg-style item animations on and off, default on.
#define SHOW_ITEM_ANIMATIONS_HALF 1
///Toggles being able to see animations that occur on the same tile.
#define SHOW_ITEM_ANIMATIONS_ALL 2
//=================================================

//=================================================
///Blurs your screen a varying amount depending on eye_blur.
#define PAIN_OVERLAY_BLURRY 0
///Impairs your screen like a welding helmet does depending on eye_blur.
#define PAIN_OVERLAY_IMPAIR 1
///Creates a legacy blurring effect over your screen if you have any eye_blur at all. Not recommended.
#define PAIN_OVERLAY_LEGACY 2
//=================================================

//=================================================
///Flashes your screen white.
#define FLASH_OVERLAY_WHITE 0
///Flashes your screen a dark grey.
#define FLASH_OVERLAY_DARK 1
//=================================================

//=================================================
///Overlays your screen white.
#define CRIT_OVERLAY_WHITE 0
///Overlays your screen a dark grey.
#define CRIT_OVERLAY_DARK 1
//=================================================

/// How many slots players have access to, both for loadout slots and character slots
#define MAX_SAVE_SLOTS 10
