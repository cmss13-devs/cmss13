////////////////
// MEGALODON HARDPOINTS // START
////////////////

/obj/item/walker_gun
	name = "walker gun"
	icon = 'fray-marines/icons/obj/vehicles/mecha_guns.dmi'
	var/equip_state = ""
	w_class = 12.0
	var/obj/vehicle/walker/owner = null
	var/magazine_type = /obj/item/ammo_magazine/walker
	var/obj/item/ammo_magazine/walker/ammo = null
	var/fire_sound = 'sound/weapons/gun_smartgun1.ogg'
	var/fire_delay = 0
	var/last_fire = 0
	var/burst = 1

	w_class = 12.0

	var/muzzle_flash 	= "muzzle_flash"
	var/muzzle_flash_lum = 3 //muzzle flash brightness

/obj/item/walker_gun/proc/get_icon_image(hardpoint)
	if(!owner)
		return

	return image(owner.icon, equip_state + hardpoint)

/obj/item/walker_gun/proc/active_effect(atom/target)
	if(ammo.current_rounds <= 0 || !ammo)
		to_chat(owner.pilot, "<span class='warning'>WARNING! System report: ammunition is depleted!</span>")
		if(ammo)
			ammo.loc = owner.loc
			ammo = null
			visible_message("[owner.name]'s systems deployed used magazine.","")
		return
	if(world.time < last_fire + fire_delay)
		to_chat(owner.pilot, "<span class='warning'>WARNING! System report: weapon is not ready to fire again!</span>")
		return
	last_fire = world.time
	var/obj/projectile/P
	for(var/i = 1 to burst)
		if(!owner.firing_arc(target))
			if(i == 1)
				return
			to_chat(owner.pilot , "<span class='warning'>[name] fired! [ammo.current_rounds]/[ammo.max_rounds] remaining!")
			visible_message("<span class='danger'>[owner.name] fires from [name]!</span>", "<span class='warning'>You hear [istype(P.ammo, /datum/ammo/bullet) ? "gunshot" : "blast"]!</span>")
			return
		P = new
		P.generate_bullet(new ammo.default_ammo)
		playsound(src, fire_sound, 60)
		target = simulate_scatter(target, P)
		P.fire_at(target, owner, src, P.ammo.max_range, P.ammo.shell_speed)
		ammo.current_rounds--
		if(ammo.current_rounds <= 0)
			ammo.loc = owner.loc
			ammo = null
			visible_message("[owner.name]'s systems deployed used magazine.","")
			break
		sleep(3)
	to_chat(owner.pilot , "<span class='warning'>[name] fired! [ammo.current_rounds]/[ammo.max_rounds] remaining!")
	visible_message("<span class='danger'>[owner.name] fires from [name]!</span>", "<span class='warning'>You hear [istype(P.ammo, /datum/ammo/bullet) ? "gunshot" : "blast"]!</span>")

	var/angle = round(Get_Angle(owner,target))
	muzzle_flash(angle)

	if(ammo.current_rounds <= 0)
		ammo.loc = owner.loc
		ammo = null
		visible_message("[owner.name]'s systems deployed used magazine.","")
	return TRUE

/obj/item/walker_gun/proc/muzzle_flash(angle, x_offset = 0, y_offset = 5)
	if(!muzzle_flash ||  isnull(angle))
		return //We have to check for null angle here, as 0 can also be an angle.
	if(!istype(owner) || !istype(owner.loc,/turf))
		return

	if(owner.luminosity <= muzzle_flash_lum)
		owner.set_light(muzzle_flash_lum)
		spawn(10)
			owner.set_light(-muzzle_flash_lum)

/obj/item/walker_gun/proc/simulate_scatter(atom/target, obj/projectile/projectile_to_fire)
	var/total_chance = projectile_to_fire.scatter
	if(total_chance <= 0)
		return target
	var/targdist = get_dist(target, owner)
	if(targdist <= (4 + rand(-1, 1)))
		return target
	if(burst > 1)
		total_chance += burst * 2

	var/turf/targloc = get_turf(target)
	if(prob(total_chance)) //Scattered!
		var/scatter_x = rand(-1,1)
		var/scatter_y = rand(-1,1)
		var/turf/new_target = locate(targloc.x + round(scatter_x),targloc.y + round(scatter_y),targloc.z) //Locate an adjacent turf.
		if(new_target)
			target = new_target//Looks like we found a turf.
	return target


/obj/item/walker_gun/smartgun
	name = "M56 Double-Barrel Mounted Smartgun"
	desc = "Modifyed version of standart USCM Smartgun System, mounted on military walkers"
	icon_state = "mecha_smartgun"
	equip_state = "mech-shot"
	magazine_type = /obj/item/ammo_magazine/walker/smartgun
	burst = 2
	fire_delay = 6

/obj/item/walker_gun/hmg
	name = "M30 Machine Gun"
	desc = "High-caliber machine gun firing small bursts of AP bullets, tearing into shreds unfortunate fellas on its way."
	icon_state = "mecha_machinegun"
	equip_state = "mech-gatt"
	fire_sound = 'sound/weapons/gun_minigun.ogg'
	magazine_type = /obj/item/ammo_magazine/walker/hmg
	fire_delay = 20
	burst = 3

/obj/item/walker_gun/flamer
	name = "F40 \"Hellfire\" Flamethower"
	desc = "Powerful flamethower, that can send any unprotected target straight to hell."
	icon_state = "mecha_flamer"
	equip_state = "mech-flam"
	fire_sound = 'sound/weapons/gun_flamethrower2.ogg'
	magazine_type = /obj/item/ammo_magazine/walker/flamer
	var/burnlevel = 50
	var/burntime = 27
	var/max_range = 6
	fire_delay = 30

/obj/item/walker_gun/flamer/active_effect(atom/target)
	if(ammo.current_rounds <= 0 || !ammo)
		to_chat(owner.pilot, "<span class='warning'>WARNING! System report: ammunition is depleted!</span>")
		if(ammo)
			ammo.loc = owner.loc
			ammo = null
			visible_message("[owner.name]'s systems deployed used magazine.","")
		return
	if(world.time < last_fire + fire_delay)
		to_chat(owner.pilot, "<span class='warning'>WARNING! System report: weapon is not ready to fire again!</span>")
		return
	last_fire = world.time
	var/list/turf/turfs = getline(owner, target)
	playsound(owner, fire_sound, 50, 1)
	ammo.current_rounds--
	var/distance = 1
	var/turf/prev_T

	for (var/F in turfs)
		var/turf/T = F

		if(T == owner.loc)
			prev_T = T
			continue
		if((T.density && !istype(T, /turf/closed/wall/resin)))
			break
		if(distance > max_range)
			break

		var/blocked = FALSE
		for(var/obj/O in T)
			if(O.density && !O.throwpass && !(O.flags_atom & ON_BORDER))
				blocked = TRUE
				break

		var/turf/TF
		if(!prev_T.Adjacent(T) && (T.x != prev_T.x || T.y != prev_T.y)) //diagonally blocked, it will seek for a cardinal turf by the former target.
			blocked = TRUE
			var/turf/Ty = locate(prev_T.x, T.y, prev_T.z)
			var/turf/Tx = locate(T.x, prev_T.y, prev_T.z)
			for(var/turf/TB in shuffle(list(Ty, Tx)))
				if(prev_T.Adjacent(TB) && (!TB.density) || istype(T, /turf/closed/wall/resin))
					TF = TB
					break
			if(!TF)
				break
		else
			TF = T

		flame_turf(TF,owner.pilot, burntime, burnlevel)
		if(blocked)
			break
		distance++
		prev_T = T
		sleep(1)

	to_chat(owner.pilot , "<span class='warning'>[name] fired! [ammo.current_rounds]/[ammo.max_rounds] charges remaining!")

	if(ammo.current_rounds <= 0 || !ammo)
		to_chat(owner.pilot, "<span class='warning'>WARNING! System report: ammunition is depleted!</span>")
		ammo.loc = owner.loc
		ammo = null
		visible_message("[owner.name]'s systems deployed used magazine.","")
		return

/obj/item/walker_gun/flamer/proc/flame_turf(turf/T, mob/living/user, heat, burn, f_color = "red")
	if(!istype(T))
		return

	new /obj/flamer_fire(T, heat, burn, f_color)

	var/fire_mod
	for(var/mob/living/M in T) //Deal bonus damage if someone's caught directly in initial stream
		if(M.stat == DEAD)
			continue

		fire_mod = 1

		if(ishuman(M))
			var/mob/living/carbon/human/H = M //fixed :s

			if(istype(H.wear_suit, /obj/item/clothing/suit/fire) || (istype(H.wear_suit, /obj/item/clothing/suit/storage/marine/M35) && istype(H.head, /obj/item/clothing/head/helmet/marine/pyro)))
				continue

		var/armor_block = M.getarmor(null, "fire")
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(istype(H.wear_suit, /obj/item/clothing/suit/fire) || (istype(H.wear_suit, /obj/item/clothing/suit/storage/marine/M35) && istype(H.head, /obj/item/clothing/head/helmet/marine/pyro)))
				H.show_message(text("Your suit protects you from most of the flames."), 1)
				armor_block = Clamp(armor_block * 1.5, 0.75, 1) //Min 75% resist, max 100%
		M.apply_damage(rand(burn,(burn*2))* fire_mod, BURN, null, armor_block) // Make it so its the amount of heat or twice it for the initial blast.

		M.adjust_fire_stacks(rand(5,burn*2))
		M.IgniteMob()

		to_chat(M, "[isxeno(M)?"<span class='xenodanger'>":"<span class='highdanger'>"]Augh! You are roasted by the flames!")

///////////////
// AMMO MAGS // START
///////////////

/obj/item/ammo_magazine/walker
	w_class = 12.0

/obj/item/ammo_magazine/walker/smartgun
	name = "M56 Double-Barrel Magazine (Standart)"
	desc = "A armament MG magazine"
	caliber = "10x28mm" //Correlates to smartguns
	icon_state = "ua571c"
	default_ammo = /datum/ammo/bullet/smartgun
	max_rounds = 700
	gun_type = /obj/item/walker_gun/smartgun

/*
/obj/item/ammo_magazine/walker/smartgun/ap
	name = "M56 Double-Barrel Magazine (AP)"
	desc = "A armament MG magazine"
	caliber = "10x28mm" //Correlates to smartguns
	icon_state = "big_ammo_box_ap"
	default_ammo = /datum/ammo/bullet/smartgun/walker/ap
	max_rounds = 500
	gun_type = /obj/item/walker_gun/smartgun
/obj/item/ammo_magazine/walker/smartgun/incendiary
	name = "M56 Double-Barrel \"Scorcher\" Magazine"
	desc = "A armament MG magazine"
	caliber = "10x28mm" //Correlates to smartguns
	icon_state = "ammoboxslug"
	default_ammo = /datum/ammo/bullet/smartgun/walker/incendiary
	max_rounds = 500
	gun_type = /obj/item/walker_gun/smartgun
*/

/obj/item/ammo_magazine/walker/hmg
	name = "M30 Machine Gun Magazine"
	desc = "A armament M30 magazine"
	icon_state = "ua571c"
	max_rounds = 300
	default_ammo = /datum/ammo/bullet/machinegun
	gun_type = /obj/item/walker_gun/hmg

/obj/item/ammo_magazine/walker/flamer
	name = "F40 Canister"
	desc = "Canister for mounted flamethower"
	icon_state = "flametank_large"
	max_rounds = 40
	default_ammo = /datum/ammo/flamethrower
	gun_type = /obj/item/walker_gun/flamer

///////////////
// AMMO MAGS // END
///////////////
////////////////
// MEGALODON HARDPOINTS // END
////////////////
