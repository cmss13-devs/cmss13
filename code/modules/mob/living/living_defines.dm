/mob/living
	see_invisible = SEE_INVISIBLE_LIVING

	//Health and life related vars
	var/maxHealth = 100 //Maximum health that should be possible.
	var/health = 100 //A mob's health

	//Damage related vars, NOTE: THESE SHOULD ONLY BE MODIFIED BY PROCS
	var/bruteloss = 0 //Brutal damage caused by brute force (punching, being clubbed by a toolbox ect... this also accounts for pressure damage)
	var/oxyloss = 0 //Oxygen depravation damage (no air in lungs)
	var/toxloss = 0 //Toxic damage caused by being poisoned or radiated
	var/fireloss = 0 //Burn damage caused by being way too hot, too cold or burnt.
	var/cloneloss = 0 //Damage caused by being cloned or ejected from the cloner early
	var/brainloss = 0 //'Retardation' damage caused by someone hitting you in the head with a bible or being infected with brainrot.
	var/halloss = 0 //Hallucination damage. 'Fake' damage obtained through hallucinating or the holodeck. Sleeping should cause it to wear off.

	// please don't use these directly, use the procs
	var/dazed = 0
	var/slowed = 0 // X_SLOW_AMOUNT
	var/superslowed = 0 // X_SUPERSLOW_AMOUNT
	var/sleeping = 0

	///a list of all status effects the mob has
	var/list/status_effects
	/// Cooldown for manually toggling resting to avoid spamming
	COOLDOWN_DECLARE(rest_cooldown)

	var/hallucination = 0 //Directly affects how long a mob will hallucinate for
	var/list/atom/hallucinations = list() //A list of hallucinated people that try to attack the mob. See /obj/effect/fake_attacker in hallucinations.dm

	var/last_special = 0 //Used by the resist verb, likely used to prevent players from bypassing next_move by logging in/out.

	var/now_pushing = null

	var/cameraFollow = null

	var/tod = null // Time of death

	var/silent = null //Can't talk. Value goes down every life proc.

	// Putting these here for attack_animal().
	var/melee_damage_lower = 0
	var/melee_damage_upper = 0
	var/attacktext = "attacks"
	var/attack_sound = null
	/// Custom sound if the mob gets slashed by a xenomorph
	var/custom_slashed_sound
	var/friendly = "nuzzles"
	var/wall_smash = 0

	//Emotes
	var/recent_audio_emote = FALSE

	var/on_fire = FALSE //The "Are we on fire?" var
	var/fire_stacks = 0 //Tracks how many stacks of fire we have on, max is
	var/datum/reagent/fire_reagent

	var/is_being_hugged = 0 //Is there a hugger humping our face?
	var/chestburst = 0 // 0: normal, 1: bursting, 2: bursted.
	var/first_xeno = FALSE //Are they the first wave of infected?
	var/in_stasis = FALSE //Is the mob in stasis bag?

	var/list/icon/pipes_shown = list()
	var/last_played_vent
	var/is_ventcrawling = 0

	var/pull_speed = 0 //How much slower or faster this mob drags as a base

	var/image/attack_icon = null //the image used as overlay on the things we attack.

	COOLDOWN_DECLARE(zoom_cooldown) //Cooldown on using zooming items, to limit spam

	var/do_bump_delay = 0 // Flag to tell us to delay movement because of being bumped

	var/reagent_move_delay_modifier = 0 //negative values increase movement speed

	var/blood_type = "X*"

	//Flags for any active emotes the mob may be performing
	var/flags_emote
	//ventcrawl
	var/list/canEnterVentWith = list(
		/obj/item/implant,
		/obj/item/clothing/mask/facehugger,
		/obj/item/device/radio,
		/obj/structure/machinery/camera,
		/obj/limb,
		/obj/item/alien_embryo
	)
	//blood.dm
	///How much blood the mob has
	var/blood_volume = 0
	///How much blood the mob should ideally have
	var/max_blood = BLOOD_VOLUME_NORMAL
	///How much blood the mob can have
	var/limit_blood = BLOOD_VOLUME_MAXIMUM

	var/hivenumber

	var/datum/pain/pain //Pain datum for the mob, set on New()
	var/datum/stamina/stamina

	var/action_delay //for do_after

	//Surgery vars.
	///Assoc. list - the operations being performed, by aim zone. Both boolean and link to that surgery.
	var/list/active_surgeries = DEFENSE_ZONES_LIVING
	///Assoc. list - incision depths, by aim zone. Set by initialize_incision_depths().
	var/list/incision_depths = DEFENSE_ZONES_LIVING

	var/current_weather_effect_type

	var/slash_verb = "attack"
	var/slashes_verb = "attacks"

	///what icon the mob uses for speechbubbles
	var/bubble_icon = "default"
	var/bubble_icon_x_offset = 0
	var/bubble_icon_y_offset = 0

	/// This is what the value is changed to when the mob dies. Actual BMV definition in atom/movable.
	var/dead_black_market_value = 0

	/// Variable to track the body position of a mob, regardgless of the actual angle of rotation (usually matching it, but not necessarily).
	var/body_position = STANDING_UP
	/// Number of degrees of rotation of a mob. 0 means no rotation, up-side facing NORTH. 90 means up-side rotated to face EAST, and so on.
	VAR_PROTECTED/lying_angle = 0
	/// Value of lying lying_angle before last change. TODO: Remove the need for this.
	var/lying_prev = 0
	/// Does the mob rotate when lying
	var/rotate_on_lying = FALSE

	/// Flags that determine the potential of a mob to perform certain actions. Do not change this directly.
	var/mobility_flags = MOBILITY_FLAGS_DEFAULT

