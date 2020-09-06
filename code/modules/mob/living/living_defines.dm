/mob/living
	see_invisible = SEE_INVISIBLE_LIVING

	//Health and life related vars
	var/maxHealth = 100 //Maximum health that should be possible.
	var/health = 100 	//A mob's health

	//Damage related vars, NOTE: THESE SHOULD ONLY BE MODIFIED BY PROCS
	var/bruteloss = 0.0	//Brutal damage caused by brute force (punching, being clubbed by a toolbox ect... this also accounts for pressure damage)
	var/oxyloss = 0.0	//Oxygen depravation damage (no air in lungs)
	var/toxloss = 0.0	//Toxic damage caused by being poisoned or radiated
	var/fireloss = 0.0	//Burn damage caused by being way too hot, too cold or burnt.
	var/cloneloss = 0	//Damage caused by being cloned or ejected from the cloner early
	var/brainloss = 0	//'Retardation' damage caused by someone hitting you in the head with a bible or being infected with brainrot.
	var/halloss = 0		//Hallucination damage. 'Fake' damage obtained through hallucinating or the holodeck. Sleeping should cause it to wear off.

	var/hallucination = 0 //Directly affects how long a mob will hallucinate for
	var/list/atom/hallucinations = list() //A list of hallucinated people that try to attack the mob. See /obj/effect/fake_attacker in hallucinations.dm

	var/last_special = 0 //Used by the resist verb, likely used to prevent players from bypassing next_move by logging in/out.

	var/now_pushing = null

	var/cameraFollow = null

	var/tod = null // Time of death

	var/silent = null 		//Can't talk. Value goes down every life proc.

	// Putting these here for attack_animal().
	var/melee_damage_lower = 0
	var/melee_damage_upper = 0
	var/attacktext = "attacks"
	var/attack_sound = null
	var/friendly = "nuzzles"
	var/wall_smash = 0

	//Emotes
	var/recent_audio_emote = FALSE

	var/on_fire = 0 //The "Are we on fire?" var
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

	var/list/datum/action/actions = list()

	var/zoom_cooldown = 0 //Cooldown on using zooming items, to limit spam
	var/do_bump_delay = 0	// Flag to tell us to delay movement because of being bumped

	var/reagent_move_delay_modifier = 0 //negative values increase movement speed

	var/datum/event/event_zoomout = null
	var/datum/event/event_movement = null
	var/blood_type = "X*"

	//Flags for any active emotes the mob may be performing
	var/flags_emote
	//ventcrawl
	var/canEnterVentWith = "/obj/item/implant=0&/obj/item/clothing/mask/facehugger=0&/obj/item/device/radio/borg=0&/obj/structure/machinery/camera=0&/obj/item/verbs=0"
	//blood.dm
	var/blood_volume = 0 //how much blood the mob has

	var/datum/pain/pain	//Pain datum for the mob, set on New()
	var/datum/stamina/stamina