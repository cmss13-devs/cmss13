
/obj/item/ammo_magazine/walker/wm88
	name = "M88 Mounted AMR Magazine"
	desc = "A armament M88 magazine"
	icon_state = "mech_wm88_ammo"
	max_rounds = 80
	default_ammo = /datum/ammo/bullet/walker/wm88
	gun_type = /obj/item/walker_gun/wm88

/obj/item/ammo_magazine/walker/wm88/a20
	default_ammo = /datum/ammo/bullet/walker/wm88/a20

/obj/item/ammo_magazine/walker/wm88/a30
	default_ammo = /datum/ammo/bullet/walker/wm88/a30

/obj/item/ammo_magazine/walker/wm88/a40
	default_ammo = /datum/ammo/bullet/walker/wm88/a40

/obj/item/ammo_magazine/walker/wm88/a50
	default_ammo = /datum/ammo/bullet/walker/wm88/a50

/datum/ammo/bullet/walker/wm88
	name = ".458 SOCOM round"

	damage = 80 //изначально 104
	penetration = ARMOR_PENETRATION_TIER_2
	accuracy = HIT_ACCURACY_TIER_1
	shell_speed = AMMO_SPEED_TIER_6
	accurate_range = 14
	handful_state = "boomslang_bullet"

/datum/ammo/bullet/walker/wm88/a20
	penetration = ARMOR_PENETRATION_TIER_4

/datum/ammo/bullet/walker/wm88/a30
	penetration = ARMOR_PENETRATION_TIER_6

/datum/ammo/bullet/walker/wm88/a40
	penetration = ARMOR_PENETRATION_TIER_8

/datum/ammo/bullet/walker/wm88/a50
	penetration = ARMOR_PENETRATION_TIER_10

/obj/item/walker_gun/wm88
	name = "M88 Mounted Automated Anti-Material rifle"
	desc = "Anti-material rifle mounted on walker for counter-fire against enemy vehicles,each successfull hit will increase firerate and armor penetration"
	icon_state = "mech_wm88_parts"
	equip_state = "redy_wm88"
	fire_sound = list('sound/weapons/gun_boomslang_fire.ogg')
	magazine_type = /obj/item/ammo_magazine/walker/wm88
	var/basic_fire_delay = 16
	fire_delay = 16
	scatter_value = 0
	automatic = TRUE
	var/overheat_reset_cooldown = 3 SECONDS
	var/overheat_rate = 2
	var/overheat = 0
	var/overheat_upper_limit = 8
	var/overheat_self_destruction_rate = 5 //при финальном перегреве начнет получать урон при стрельбе умноженный на перегрев
	var/steam_effect = /obj/effect/particle_effect/smoke/bad/wm88

/obj/item/walker_gun/wm88/active_effect(atom/target, mob/living/user)
	if(overheat) //has to go before actual firing
		var/obj/item/ammo_magazine/walker/new_ammo
		var/old_ammo = ammo
		var/ammo_rounds_memory = ammo.current_rounds
		switch(overheat)
			if(2)
				new_ammo = new/obj/item/ammo_magazine/walker/wm88/a20
			if(4)
				new_ammo = new/obj/item/ammo_magazine/walker/wm88/a30
			if(6)
				new_ammo = new/obj/item/ammo_magazine/walker/wm88/a40
			if(8)
				new_ammo = new/obj/item/ammo_magazine/walker/wm88/a50
		new_ammo.current_rounds = ammo_rounds_memory
		ammo = new_ammo //Создаём и удаляем магазины, весело
		qdel(old_ammo)
	//Оверрайд изначальной части, ибо рефактор потом сделаем чтобы использовать флаги xd
	if (!ammo)
		to_chat(user, "<span class='warning'>WARNING! System report: ammunition is depleted!</span>")
		SEND_SIGNAL(src, COMSIG_GUN_STOP_FIRE)
		return FALSE
	if(ammo.current_rounds <= 0)
		to_chat(user, "<span class='warning'>WARNING! System report: ammunition is depleted!</span>")
		ammo.loc = owner.loc
		ammo = null
		visible_message("[owner.name]'s systems deployed used magazine.","")
		SEND_SIGNAL(src, COMSIG_GUN_STOP_FIRE)
		return FALSE
	if(world.time < last_fire + fire_delay)
		to_chat(user, "<span class='warning'>WARNING! System report: weapon is not ready to fire again!</span>")
		return FALSE
	last_fire = world.time
	if(!owner.firing_arc(target))
		return FALSE
	var/obj/projectile/P = new
	P.generate_bullet(new ammo.default_ammo)
	for (var/trait in projectile_traits)
		GIVE_BULLET_TRAIT(P, trait, FACTION_MARINE)
	playsound(get_turf(owner), pick(fire_sound), 60)
	target = simulate_scatter(target, P)
	P.fire_at(target, owner, src, P.ammo.max_range, P.ammo.shell_speed)
	//////////
	if(overheat == overheat_upper_limit)
		var/turf/T = get_turf(owner)
		new steam_effect(T)
		var/damage = overheat_self_destruction_rate * overheat
		owner.health = max(0, owner.health - damage)
		to_chat(user, SPAN_WARNING("[owner] IS LOOSING INTEGRITY FROM EXTREAM HOT STEAM."))
	fire_delay = basic_fire_delay - overheat
	SEND_SIGNAL(src, COMSIG_GUN_AUTOFIREDELAY_MODIFIED, fire_delay)
	if(overheat < overheat_upper_limit)
		overheat += overheat_rate
	addtimer(CALLBACK(src, PROC_REF(reset_overheat_buff), user), overheat_reset_cooldown, TIMER_OVERRIDE|TIMER_UNIQUE)
	//////////
	ammo.current_rounds--

	display_ammo(user)
	visible_message("<span class='danger'>[owner.name] fires from [name]!</span>", "<span class='warning'>You hear [istype(P.ammo, /datum/ammo/bullet) ? "gunshot" : "blast"]!</span>")

	var/angle = round(Get_Angle(owner, target))
	muzzle_flash(angle)

	if(ammo && ammo.current_rounds <= 0)
		ammo.loc = owner.loc
		ammo = null
		visible_message("[owner.name]'s systems deployed used magazine.","")
	owner.healthcheck() //проверка саморазрушения после перегрева
	return TRUE

/obj/item/walker_gun/wm88/proc/reset_overheat_buff(mob/user)
	SIGNAL_HANDLER
	to_chat(user, SPAN_WARNING("[src] beeps as it's extinguish."))
	overheat = 0
	var/ammo_memory = ammo.current_rounds
	var/obj/item/ammo_magazine/walker/new_ammo
	var/old_ammo = ammo
	new_ammo = new/obj/item/ammo_magazine/walker/wm88
	ammo = new_ammo
	qdel(old_ammo)
	ammo.current_rounds = ammo_memory
	fire_delay = basic_fire_delay
	SEND_SIGNAL(src, COMSIG_GUN_AUTOFIREDELAY_MODIFIED, fire_delay)

/obj/effect/particle_effect/smoke/bad/wm88
	smokeranking = SMOKE_RANK_MED
	time_to_live = 8

/obj/effect/particle_effect/smoke/bad/wm88/affect(mob/living/carbon/affected_mob)
	. = ..()
	if(!.)
		return FALSE
	if(affected_mob.internal != null && affected_mob.wear_mask && (affected_mob.wear_mask.flags_inventory & ALLOWINTERNALS))
		return FALSE
	if(issynth(affected_mob))
		return FALSE

	if(prob(20))
		affected_mob.drop_held_item()

	affected_mob.apply_damage(15, BURN)
	to_chat(affected_mob, SPAN_WARNING("YOUR FLASH IS BURNED BY HOT STEAM"))

	if(affected_mob.coughedtime < world.time && !affected_mob.stat)
		affected_mob.coughedtime = world.time + 2 SECONDS
		if(ishuman(affected_mob)) //Humans only to avoid issues
			affected_mob.emote("scream")
	return TRUE

/datum/supply_packs/ammo_wm88_walker
	name = "M88 Mounted AMR Magazine (x2)"
	contains = list(
		/obj/item/ammo_magazine/walker/wm88,
		/obj/item/ammo_magazine/walker/wm88,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "M88 Mounted AMR Magazine crate"
	group = "Vehicle Ammo"
