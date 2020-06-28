/datum/caste_datum/predalien
	caste_name = "Predalien"
	display_name = "Abomination"

	melee_damage_lower = XENO_DAMAGE_MEDIUM
	melee_damage_upper = XENO_DAMAGE_HIGH
	max_health = XENO_HEALTH_IMMORTAL
	plasma_gain = XENO_PLASMA_GAIN_ULTRAHIGH
	plasma_max = XENO_PLASMA_HIGHMEDIUM
	xeno_explosion_resistance = XENO_GIGA_EXPLOSIVE_ARMOR
	armor_deflection = XENO_MEDIUM_ARMOR
	armor_hardiness_mult = XENO_ARMOR_FACTOR_LOW
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_SANICFAST
	speed_mod = XENO_SPEED_MOD_LARGE

	evolution_allowed = FALSE
	tacklemin = 6
	tacklemax = 10
	tackle_chance = 80
	is_intelligent = TRUE
	tier = 1
	attack_delay = -2
	can_be_queen_healed = 0
	upgrade = -1

/datum/caste_datum/predalien/primordial
	upgrade_name = "Primordial"
	display_name = "Primordial Abomination"
	caste_desc = "This is it. This is the final boss. There's nothing more powerful than this."
	max_health = XENO_UNIVERSAL_HPMULT * 1000
	plasma_gain = 0.084
	plasma_max = 400
	evolution_allowed = FALSE
	melee_damage_lower = 150
	melee_damage_upper = 175
	tackle_chance = 90
	is_intelligent = TRUE
	armor_deflection = 60
	attack_delay = -3
	speed = -2.3
	upgrade = 4

/mob/living/carbon/Xenomorph/Predalien
	caste_name = "Predalien"
	name = "Abomination"
	desc = "A strange looking creature with fleshy strands on its head. It appears like a mixture of armor and flesh, smooth, but well carapaced."
	icon = 'icons/mob/xenos/predalien.dmi'
	icon_state = "Predalien Walking"
	plasma_types = list(PLASMA_CATECHOLAMINE)
	faction = FACTION_PREDALIEN
	melee_damage_lower = 65
	melee_damage_upper = 80
	amount_grown = 0
	max_grown = 200
	wall_smash = TRUE
	hardcore = TRUE
	tunnel_delay = 0
	pslash_delay = 0
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	tier = 1
	upgrade = -1 //Predaliens are already in their ultimate form, they don't get even better

	var/butchered_last //world.time to prevent spam.
	var/butchered_sum = 0 //The number of people butchered. Lowers the health gained.

	#define PREDALIEN_BUTCHER_COOLDOWN 140 //14 seconds.
	#define PREDALIEN_BUTCHER_WAIT_TIME 120 //12 seconds.
	actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/pounce,
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/Predalien/proc/claim_trophy
		)
	mutation_type = "Normal"

	New()
		..()
		announce_spawn()

/mob/living/carbon/Xenomorph/Predalien/proc/announce_spawn()
	set waitfor = 0
	sleep(30)
	if(!loc) 
		return FALSE
	if(ticker && ticker.mode && ticker.mode.predators.len)
		var/datum/mind/M
		for(var/i in ticker.mode.predators)
			M = i
			if(M.current && M.current.stat != DEAD && z != ADMIN_Z_LEVEL)
				to_chat(M.current, "<span class='event_announcement'>An abomination to your people has been brought onto the world at [get_area(src)]! Hunt it down and destroy it!</span>")
				M.current.emote("roar")
	if(upgrade == 4)
		desc = "Nothing matches this force of destruction. Good luck killing it, mortal."
		color = "#FE0202"
		if(z != ADMIN_Z_LEVEL)
			xeno_message(SPAN_XENOANNOUNCE("A Primordial Abomination has risen! Rejoice!"))
			for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
				if(X && X.stat != DEAD)
					X.emote("roar")
			for(var/mob/living/carbon/human/H in living_mob_list)
				if(z == H.z)
					to_chat(H, SPAN_XENOANNOUNCE("The ground shakes beneath your feet... Echoes of imminent doom tickle your conscious like ripples on a pond..."))
					playsound(H, 'sound/voice/predalien_roar.ogg', 100, 75)
					if(H.client)
						shake_camera(H, 25, 5)

	to_chat(src, {"
<span class='role_body'>|______________________|</span>
<span class='role_header'>You are a predator-alien hybrid!</span>
<span class='role_body'>You are a very powerful xenomorph creature that was born of a Yautja warrior body.
You are stronger, faster, and smarter than a regular xenomorph, but you must still listen to the queen.
You have a degree of freedom to where you can hunt and claim the heads of the hive's enemies, so check your verbs.
Your health meter will not regenerate normally, so kill and die for the hive!</span>
<span class='role_body'>|______________________|</span>
"})
	emote("roar")


/mob/living/carbon/Xenomorph/Predalien/proc/claim_trophy()
	set category = "Alien"
	set name = "Claim Trophy"
	set desc = "Butcher a corpse to attain a trophy from your kill."

	if(is_mob_incapacitated()|| lying || buckled)
		to_chat(src, SPAN_XENOWARNING("You're not able to do that right now."))
		return FALSE

	var/choices[] = new
	for(var/mob/M in view(1, src)) //We are only interested in humans and predators.
		if(Adjacent(M) && ishuman(M) && !iszombie(M) && M.stat) choices += M

	var/mob/living/carbon/human/H = input(src, "From which corpse will you claim your trophy?") as null|anything in choices

	if(!H || !H.loc) 
		return FALSE

	if(is_mob_incapacitated() || lying || buckled)
		to_chat(src, "<span class='xenowarning'>You're not able to do that right now.<span>")
		return FALSE

	if(!H.stat)
		to_chat(src, SPAN_XENOWARNING("Your prey must be dead."))
		return FALSE

	if(!Adjacent(H))
		to_chat(src, SPAN_XENOWARNING("You have to be next to your target."))
		return FALSE

	if(world.time <= butchered_last + PREDALIEN_BUTCHER_COOLDOWN)
		to_chat(src, SPAN_XENOWARNING("You have recently attempted to butcher a carcass. Wait."))
		return FALSE

	butchered_last = world.time

	visible_message(SPAN_DANGER("[src] reaches down, angling its body toward [H], claws outstretched."),
	SPAN_XENONOTICE("You stoop near the host's body, savoring the moment before you claim a trophy for your kill. You must stand still..."))
	if(do_after(src, PREDALIEN_BUTCHER_WAIT_TIME, INTERRUPT_ALL, BUSY_ICON_HOSTILE) && Adjacent(H))
		var/obj/limb/head/O = H.get_limb("head")
		if(!(O.status & LIMB_DESTROYED))
			H.apply_damage(150, BRUTE, "head", TRUE, TRUE)
			if(!(O.status & LIMB_DESTROYED)) O.droplimb(0, 0, initial(name)) //Still not actually detached?
			visible_message(SPAN_DANGER("[src] reaches down and rips off [H]'s spinal cord and skull!"),
			SPAN_XENODANGER("You slice and pull on [H]'s head until it comes off in a bloody arc!"))
			playsound(loc, 'sound/weapons/slice.ogg', 25)
			emote("growl")
			var/to_heal = max(1, 5 - (0.2 * (health < maxHealth ? butchered_sum++ : butchered_sum)))//So we do not heal multiple times due to the inline proc below.
			XENO_HEAL_WOUNDS(isYautja(H)? 15 : to_heal, recovery_aura) //Predators give far better healing.
		else
			visible_message(SPAN_DANGER("[src] slices and dices [H]'s body like a ragdoll!"),
			SPAN_XENODANGER("You fly into a frenzy and butcher [H]'s body!"))
			playsound(loc, 'sound/weapons/bladeslice.ogg', 25)
			emote("growl")
			var/i = 4
			while(i--)
				H.apply_damage(100, BRUTE, pick("r_leg","l_leg","r_arm","l_arm"), TRUE, TRUE)

	#undef PREDALIEN_BUTCHER_COOLDOWN
	#undef PREDALIEN_BUTCHER_WAIT_TIME
