
//Gun attachable items code. Lets you add various effects to firearms.
//Some attachables are hardcoded in the projectile firing system, like grenade launchers, flamethrowers.
/*
When you are adding new guns into the attachment list, or even old guns, make sure that said guns
properly accept overlays. You can find the proper offsets in the individual gun dms, so make sure
you set them right. It's a pain to go back to find which guns are set incorrectly.
To summarize: rail attachments should go on top of the rail. For rifles, this usually means the middle of the gun.
For handguns, this is usually toward the back of the gun. SMGs usually follow rifles.
Muzzle attachments should connect to the barrel, not sit under or above it. The only exception is the bayonet.
Underrail attachments should just fit snugly, that's about it. Stocks are pretty obvious.

All attachment offsets are now in a list, including stocks. Guns that don't take attachments can keep the list null.
~N

Defined in conflicts.dm of the #defines folder.
#define ATTACH_REMOVABLE	1
#define ATTACH_ACTIVATION	2
#define ATTACH_PROJECTILE	4
#define ATTACH_RELOADABLE	8
#define ATTACH_WEAPON		16
*/

/obj/item/attachable
	name = "attachable item"
	desc = "It's an attachment. You should never see this."
	icon = 'icons/Marine/marine-weapons.dmi'
	icon_state = null
	item_state = null
	var/attach_icon //the sprite to show when the attachment is attached when we want it different from the icon_state.
	var/pixel_shift_x = 16 //Determines the amount of pixels to move the icon state for the overlay.
	var/pixel_shift_y = 16 //Uses the bottom left corner of the item.

	flags_atom =  FPRINT|CONDUCT
	matter = list("metal" = 2000)
	w_class = 2.0
	force = 1.0
	var/slot = null //"muzzle", "rail", "under", "stock"

	/*
	Anything that isn't used as the gun fires should be a flat number, never a percentange. It screws with the calculations,
	and can mean that the order you attach something/detach something will matter in the final number. It's also completely
	inaccurate. Don't worry if force is ever negative, it won't runtime.
	*/
	//These bonuses are applied only as the gun fires a projectile.

	//These are flat bonuses applied and are passive, though they may be applied at different points.
	var/accuracy_mod 	= 0 //Modifier to firing accuracy, works off a multiplier.
	var/accuracy_unwielded_mod = 0 //same as above but for onehanded.
	var/damage_mod 		= 0 //Modifer to the damage mult, works off a multiplier.
	var/damage_falloff_mod = 0 //Modifier to damage falloff, works off a multiplier.
	var/melee_mod 		= 0 //Changing to a flat number so this actually doesn't screw up the calculations.
	var/scatter_mod 	= 0 //Increases or decreases scatter chance.
	var/scatter_unwielded_mod = 0 //same as above but for onehanded firing.
	var/recoil_mod 		= 0 //If positive, adds recoil, if negative, lowers it. Recoil can't go below 0.
	var/recoil_unwielded_mod = 0 //same as above but for onehanded firing.
	var/burst_scatter_mod = 0 //Modifier to scatter from wielded burst fire, works off a multiplier.
	var/silence_mod 	= 0 //Adds silenced to weapon
	var/light_mod 		= 0 //Adds an x-brightness flashlight to the weapon, which can be toggled on and off.
	var/delay_mod 		= 0 //Changes firing delay. Cannot go below 0.
	var/burst_mod 		= 0 //Changes burst rate. 1 == 0.
	var/size_mod 		= 0 //Increases the weight class.
	var/aim_speed_mod	= 0 //Changes the aiming speed slowdown of the wearer by this value.
	var/wield_delay_mod	= 0 //How long ADS takes (time before firing)
	var/movement_acc_penalty_mod = 0 //Modifies accuracy/scatter penalty when firing onehanded while moving.

	var/activation_sound = 'sound/machines/click.ogg'

	var/flags_attach_features = ATTACH_REMOVABLE

	var/bipod_deployed = FALSE //only used by bipod
	var/current_rounds 	= 0 //How much it has.
	var/max_rounds 		= 0 //How much ammo it can store

	var/attachment_action_type

	var/has_marine_iff = FALSE //adds IFF to bullets



	attackby(obj/item/I, mob/user)
		if(flags_attach_features & ATTACH_RELOADABLE)
			if(user.get_inactive_hand() != src)
				user << "<span class='warning'>You have to hold [src] to do that!</span>"
			else
				reload_attachment(I, user)
			return TRUE
		else
			. = ..()



/obj/item/attachable/proc/Attach(obj/item/weapon/gun/G)
	if(!istype(G)) return //Guns only

	/*
	This does not check if the attachment can be removed.
	Instead of checking individual attachments, I simply removed
	the specific guns for the specific attachments so you can't
	attempt the process in the first place if a slot can't be
	removed on a gun. can_be_removed is instead used when they
	try to strip the gun.
	*/
	switch(slot)
		if("rail")
			if(G.rail) G.rail.Detach(G)
			G.rail = src
		if("muzzle")
			if(G.muzzle) G.muzzle.Detach(G)
			G.muzzle = src
		if("under")
			if(G.under) G.under.Detach(G)
			G.under = src
		if("stock")
			if(G.stock) G.stock.Detach(G)
			G.stock = src

	if(ishuman(loc))
		var/mob/living/carbon/human/M = src.loc
		M.drop_held_item(src)
	forceMove(G)

	G.accuracy_mult		+= accuracy_mod
	G.accuracy_mult_unwielded += accuracy_unwielded_mod
	G.damage_mult		+= damage_mod
	G.damage_falloff_mult += damage_falloff_mod
	G.w_class 			+= size_mod
	G.scatter			+= scatter_mod
	G.scatter_unwielded += scatter_unwielded_mod
	G.fire_delay 		+= delay_mod
	G.burst_amount 		+= burst_mod
	G.recoil 			+= recoil_mod
	G.recoil_unwielded	+= recoil_unwielded_mod
	G.force 			+= melee_mod
	G.aim_slowdown		+= aim_speed_mod
	G.wield_delay		+= wield_delay_mod
	G.burst_scatter_mult += burst_scatter_mod
	G.movement_acc_penalty_mult += movement_acc_penalty_mod

	if(G.burst_amount <= 1)
		G.flags_gun_features &= ~GUN_BURST_ON //Remove burst if they can no longer use it.
	G.update_force_list() //This updates the gun to use proper force verbs.

	if(silence_mod)
		G.flags_gun_features |= GUN_SILENCED
		G.muzzle_flash = null
		G.fire_sound = "gun_silenced"

	if(attachment_action_type)
		var/datum/action/A = new attachment_action_type(src, G)
		if(isliving(G.loc))
			var/mob/living/L = G.loc
			if(G == L.l_hand || G == L.r_hand)
				A.give_action(G.loc)

	G.check_iff()



/obj/item/attachable/proc/Detach(obj/item/weapon/gun/G)
	if(!istype(G)) return //Guns only


	if(flags_attach_features & ATTACH_ACTIVATION)
		activate_attachment(G, null, TRUE)

	switch(slot) //I am removing checks for the attachment being src.
		if("rail") 		G.rail = null//If it's being called on by this proc, it has to be that attachment. ~N
		if("muzzle") 	G.muzzle = null
		if("under")		G.under = null
		if("stock")		G.stock = null



	G.accuracy_mult		-= accuracy_mod
	G.accuracy_mult_unwielded -= accuracy_unwielded_mod
	G.damage_mult		-= damage_mod
	G.damage_falloff_mult -= damage_falloff_mod
	G.w_class 			-= size_mod
	G.scatter			-= scatter_mod
	G.scatter_unwielded -= scatter_unwielded_mod
	G.fire_delay 		-= delay_mod
	G.burst_amount 		-= burst_mod
	G.recoil 			-= recoil_mod
	G.recoil_unwielded	-= recoil_unwielded_mod
	G.force 			-= melee_mod
	G.aim_slowdown		-= aim_speed_mod
	G.wield_delay		-= wield_delay_mod
	G.burst_scatter_mult -= burst_scatter_mod
	G.movement_acc_penalty_mult -= movement_acc_penalty_mod
	G.update_force_list()

	if(silence_mod) //Built in silencers always come as an attach, so the gun can't be silenced right off the bat.
		G.flags_gun_features &= ~GUN_SILENCED
		G.muzzle_flash = initial(G.muzzle_flash)
		G.fire_sound = initial(G.fire_sound)

	for(var/X in G.actions)
		var/datum/action/DA = X
		if(DA.target == src)
			cdel(X)
			break

	loc = get_turf(G)

	G.check_iff()


/obj/item/attachable/ui_action_click(mob/living/user, obj/item/weapon/gun/G)
	if(G == user.get_active_hand())
		if(activate_attachment(G, user)) //success
			return
	else
		user << "<span class='warning'>[G] must be in our active hand to do this.</span>"




/obj/item/attachable/proc/activate_attachment(atom/target, mob/user) //This is for activating stuff like flamethrowers, or switching weapon modes.
	return

/obj/item/attachable/proc/reload_attachment(obj/item/I, mob/user)
	return

/obj/item/attachable/proc/fire_attachment(atom/target,obj/item/weapon/gun/gun, mob/user) //For actually shooting those guns.
	return


/////////// Muzzle Attachments /////////////////////////////////

/obj/item/attachable/suppressor
	name = "suppressor"
	desc = "A small tube with exhaust ports to expel noise and gas.\nDoes not completely silence a weapon, but does make it much quieter and a little more accurate and stable at the cost of slightly reduced damage."
	icon_state = "suppressor"
	slot = "muzzle"
	silence_mod = 1
	pixel_shift_y = 16
	attach_icon = "suppressor_a"

	New()
		..()
		accuracy_mod = config.low_hit_accuracy_mult
		damage_mod = -config.min_hit_damage_mult
		recoil_mod = -config.min_recoil_value
		scatter_mod = -config.min_scatter_value
		attach_icon = pick("suppressor_a","suppressor2_a")

		recoil_unwielded_mod = -config.min_recoil_value
		scatter_unwielded_mod = -config.min_scatter_value
		damage_falloff_mod = 0.4

/obj/item/attachable/bayonet
	name = "bayonet"
	desc = "A sharp blade for mounting on a weapon. It can be used to stab manually on anything but harm intent."
	icon_state = "bayonet"
	attach_icon = "bayonet_a"
	force = 20
	throwforce = 10
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	melee_mod = 20 //35 for a rifle, comparable to 37 before. 40 with the stock, comparable to 42.
	slot = "muzzle"
	pixel_shift_x = 14 //Below the muzzle.
	pixel_shift_y = 18

	attackby(obj/item/I, mob/user)
		if(istype(I,/obj/item/tool/screwdriver))
			user << "<span class='notice'>You modify the bayonet back into a combat knife.</span>"
			if(istype(loc, /obj/item/storage))
				var/obj/item/storage/S = loc
				S.remove_from_storage(src)
			if(loc == user)
				user.drop_inv_item_on_ground(src)
			var/obj/item/weapon/combat_knife/F = new(src.loc)
			user.put_in_hands(F) //This proc tries right, left, then drops it all-in-one.
			if(F.loc != user) //It ended up on the floor, put it whereever the old flashlight is.
				F.loc = src.loc
			cdel(src) //Delete da old bayonet
		else
			. = ..()

	New()
		..()
		accuracy_mod = -config.min_hit_accuracy_mult

		accuracy_unwielded_mod = -config.min_hit_accuracy_mult

/obj/item/attachable/extended_barrel
	name = "extended barrel"
	desc = "A lengthened barrel allows for greater accuracy, particularly at long range.\nHowever, natural resistance also slows the bullet, leading to slightly reduced damage."
	slot = "muzzle"
	icon_state = "ebarrel"
	attach_icon = "ebarrel_a"

	New()
		..()
		accuracy_mod = config.med_hit_accuracy_mult
		damage_mod = -config.min_hit_damage_mult




/obj/item/attachable/heavy_barrel
	name = "barrel charger"
	desc = "A hyper threaded barrel extender that fits to the muzzle of most firearms. Increases bullet speed and velocity.\nGreatly increases projectile damage at the cost of accuracy and firing speed."
	slot = "muzzle"
	icon_state = "hbarrel"
	attach_icon = "hbarrel_a"

	New()
		..()
		accuracy_mod = -config.hmed_hit_accuracy_mult
		damage_mod = config.hmed_hit_damage_mult
		delay_mod = config.low_fire_delay

		accuracy_unwielded_mod = -config.high_hit_accuracy_mult


/obj/item/attachable/compensator
	name = "recoil compensator"
	desc = "A muzzle attachment that reduces recoil by diverting expelled gasses upwards. \nIncreases accuracy and reduces recoil, at the cost of a small amount of weapon damage."
	slot = "muzzle"
	icon_state = "comp"
	attach_icon = "comp_a"
	pixel_shift_x = 17

	New()
		..()
		accuracy_mod = config.med_hit_accuracy_mult
		damage_mod = -config.low_hit_damage_mult
		recoil_mod = -config.med_recoil_value

		damage_falloff_mod = 0.4
		accuracy_unwielded_mod = config.med_hit_accuracy_mult
		recoil_unwielded_mod = -config.low_recoil_value


/obj/item/attachable/slavicbarrel
	name = "sniper barrel"
	icon_state = "slavicbarrel"
	desc = "A heavy barrel. CANNOT BE REMOVED."
	slot = "muzzle"

	pixel_shift_x = 20
	pixel_shift_y = 16
	flags_attach_features = NOFLAGS

	New()
		..()
		accuracy_mod = config.min_hit_accuracy_mult
		scatter_mod = -config.low_scatter_value

/obj/item/attachable/sniperbarrel
	name = "sniper barrel"
	icon_state = "sniperbarrel"
	desc = "A heavy barrel. CANNOT BE REMOVED."
	slot = "muzzle"
	flags_attach_features = NOFLAGS

	New()
		..()
		accuracy_mod = config.low_hit_accuracy_mult
		scatter_mod = -config.low_scatter_value

/obj/item/attachable/smartbarrel
	name = "smartgun barrel"
	icon_state = "smartbarrel"
	desc = "A heavy rotating barrel. CANNOT BE REMOVED."
	slot = "muzzle"
	flags_attach_features = NOFLAGS






///////////// Rail attachments ////////////////////////

/obj/item/attachable/reddot
	name = "S5 red-dot sight"
	desc = "An ARMAT S5 red-dot sight. A zero magnification optic that offers faster, and more accurate target aquisition."
	icon_state = "reddot"
	attach_icon = "reddot_a"
	slot = "rail"

	New()
		..()
		accuracy_mod = config.med_hit_accuracy_mult
		accuracy_unwielded_mod = config.min_hit_accuracy_mult
		movement_acc_penalty_mod = 1

/obj/item/attachable/reflex
	name = "S6 reflex sight"
	desc = "An ARMAT S6 reflex sight. A zero magnification alternative to iron sights with a more open optic window when compared to the S5 red-dot. Helps to reduce scatter during automated fire."
	icon_state = "reflex"
	attach_icon = "reflex_a"
	slot = "rail"

	New()
		..()
		accuracy_mod = config.low_hit_accuracy_mult
		accuracy_unwielded_mod = config.min_hit_accuracy_mult
		scatter_mod = -config.min_scatter_value
		burst_scatter_mod = -1
		movement_acc_penalty_mod = 1


/obj/item/attachable/flashlight
	name = "rail flashlight"
	desc = "A flashlight, for rails, on guns. Can be toggled on and off. A better light source than standard M3 pattern armor lights."
	icon_state = "flashlight"
	attach_icon = "flashlight_a"
	light_mod = 7
	slot = "rail"
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle

/obj/item/attachable/flashlight/activate_attachment(obj/item/weapon/gun/G, mob/living/user, turn_off)
	if(turn_off && !(G.flags_gun_features & GUN_FLASHLIGHT_ON))
		return
	var/flashlight_on = (G.flags_gun_features & GUN_FLASHLIGHT_ON) ? -1 : 1
	var/atom/movable/light_source =  ismob(G.loc) ? G.loc : G
	light_source.SetLuminosity(light_mod * flashlight_on)
	G.flags_gun_features ^= GUN_FLASHLIGHT_ON

	if(G.flags_gun_features & GUN_FLASHLIGHT_ON)
		icon_state = "flashlight-on"
		attach_icon = "flashlight_a-on"
	else
		icon_state = "flashlight"
		attach_icon = "flashlight_a"
	playsound(user, activation_sound, 15, 1)
	G.update_attachable(slot)

	for(var/X in G.actions)
		var/datum/action/A = X
		A.update_button_icon()
	return 1




/obj/item/attachable/flashlight/attackby(obj/item/I, mob/user)
	if(istype(I,/obj/item/tool/screwdriver))
		user << "<span class='notice'>You strip the the rail flashlight of its mount, converting it to a normal flashlight.</span>"
		if(istype(loc, /obj/item/storage))
			var/obj/item/storage/S = loc
			S.remove_from_storage(src)
		if(loc == user)
			user.temp_drop_inv_item(src)
		var/obj/item/device/flashlight/F = new(user)
		user.put_in_hands(F) //This proc tries right, left, then drops it all-in-one.
		cdel(src) //Delete da old flashlight
	else
		. = ..()

/obj/item/attachable/flashlight/grip //Grip Light is here because it is a child object. Having it further down might cause a future coder a headache.
	name = "underbarrel flashlight grip"
	desc = "Holy smokes RO man, they put a grip on a flashlight! \nReduces recoil and scatter by a tiny amount. Boosts accuracy by a tiny amount. Works as a light source."
	icon_state = "flashgrip"
	attach_icon = "flashgrip_a"
	light_mod = 6
	slot = "under"
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle

/obj/item/attachable/flashlight/grip/New()
	..()
	accuracy_mod = config.min_hit_accuracy_mult
	recoil_mod = -config.min_recoil_value
	scatter_mod = -config.min_scatter_value

/obj/item/attachable/flashlight/grip/attackby(obj/item/I, mob/user)
	if(istype(I,/obj/item/tool/screwdriver))
		user << "<span class='notice'>Hold on there cowboy, that grip is bolted on. You are unable to modify it.</span>"
	return

/obj/item/attachable/quickfire
	name = "quickfire adapter"
	desc = "An enhanced and upgraded autoloading mechanism to fire rounds more quickly. \nHowever, it also reduces accuracy and the number of bullets fired on burst."
	slot = "rail"
	icon_state = "autoloader"
	attach_icon = "autoloader_a"

/obj/item/attachable/quickfire/New()
	..()
	accuracy_mod = -config.low_hit_accuracy_mult
	scatter_mod = config.min_scatter_value
	delay_mod = -config.mlow_fire_delay
	burst_mod = -config.min_burst_value
	accuracy_unwielded_mod = -config.med_hit_accuracy_mult
	scatter_unwielded_mod = config.med_scatter_value


/obj/item/attachable/magnetic_harness
	name = "magnetic harness"
	desc = "A magnetically attached harness kit that attaches to the rail mount of a weapon. When dropped, the weapon will sling to any set of USCM armor."
	icon_state = "magnetic"
	attach_icon = "magnetic_a"
	slot = "rail"
	pixel_shift_x = 13

/obj/item/attachable/magnetic_harness/New()
	..()
	accuracy_mod = -config.min_hit_accuracy_mult
	accuracy_unwielded_mod = -config.min_hit_accuracy_mult

/datum/event_handler/scope_zoomout_removebuffs
	var/obj/item/weapon/gun/G = null
	var/obj/item/attachable/scope/scope
	single_fire = 1

/datum/event_handler/scope_zoomout_removebuffs/New(_g,_scope)
	G = _g
	scope = _scope

/datum/event_handler/scope_zoomout_removebuffs/handle(sender, datum/event_args/ev_args)
	if(!G.zoom)
		G.accuracy_mult -= scope.accuracy_scoped_buff
		G.fire_delay -= scope.delay_scoped_nerf
		G.damage_falloff_mult -= scope.damage_falloff_scoped_buff


/obj/item/attachable/scope
	name = "S8 telescoping sight"
	icon_state = "sniperscope"
	attach_icon = "sniperscope_a"
	desc = "An ARMAT S8 telescopic eye piece. Fixed at 4x zoom. Press the 'use rail attachment' HUD icon or use the verb of the same name to zoom."
	slot = "rail"
	aim_speed_mod = SLOWDOWN_ADS_SCOPE //Extra slowdown when aiming
	wield_delay_mod = WIELD_DELAY_FAST
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle
	var/zoom_offset = 11
	var/zoom_viewsize = 12
	var/allows_movement = 0
	var/accuracy_scoped_buff
	var/delay_scoped_nerf
	var/damage_falloff_scoped_buff

/obj/item/attachable/scope/New()
	..()
	delay_mod = config.min_fire_delay
	accuracy_mod = -config.min_hit_accuracy_mult
	movement_acc_penalty_mod = 2
	accuracy_unwielded_mod = 0

	accuracy_scoped_buff = config.high_hit_accuracy_mult + config.min_hit_accuracy_mult //to compensate initial debuff
	delay_scoped_nerf = config.low_fire_delay - config.min_fire_delay //to compensate initial debuff. We want "high_fire_delay"
	damage_falloff_scoped_buff = -0.4 //has to be negative

/obj/item/attachable/scope/proc/apply_scoped_buff(obj/item/weapon/gun/G, mob/living/carbon/user)
	if(G.zoom)
		G.accuracy_mult += accuracy_scoped_buff
		G.fire_delay += delay_scoped_nerf
		G.damage_falloff_mult += damage_falloff_scoped_buff
		var/datum/event_handler/eh = new /datum/event_handler/scope_zoomout_removebuffs(G,src)
		user.add_zoomout_handler(eh)

/obj/item/attachable/scope/activate_attachment(obj/item/weapon/gun/G, mob/living/carbon/user, turn_off)
	if(turn_off)
		if(G.zoom)
			G.zoom(user, zoom_offset, zoom_viewsize, allows_movement)
		return 1

	if(!G.zoom && !(G.flags_item & WIELDED))
		if(user)
			user << "<span class='warning'>You must hold [G] with two hands to use [src].</span>"
		return 0
	else
		G.zoom(user, zoom_offset, zoom_viewsize, allows_movement)
		apply_scoped_buff(G,user)
	return 1



/datum/event_handler/miniscope_zoomout
	var/obj/item/weapon/gun/G = null
	var/aim_slowdown = 0
	single_fire = 1
	handle(sender, datum/event_args/ev_args)
		if(G.zoom)
			G.slowdown -= aim_slowdown


/obj/item/attachable/scope/mini
	name = "S4 telescoping sight"
	icon_state = "miniscope"
	attach_icon = "miniscope_a"
	desc = "An ARMAT S4 telescoping eye piece. Fixed at a modest 2x zoom. Press the 'use rail attachment' HUD icon or use the verb of the same name to zoom."
	slot = "rail"
	zoom_offset = 6
	zoom_viewsize = 7
	var/dynamic_aim_slowdown = 2

/obj/item/attachable/scope/mini/New()
	..()
	damage_falloff_scoped_buff = -0.2 //has to be negative

/obj/item/attachable/scope/mini/activate_attachment(obj/item/weapon/gun/G, mob/living/carbon/user, turn_off)
	if(istype(G, /obj/item/weapon/gun/launcher/rocket))
		allows_movement	= 0
		if(do_after(user, 25, FALSE, 5, BUSY_ICON_HOSTILE))
			. = ..()
	else
		allows_movement	= 1
		. = ..()
		if(user && G.zoom)
			var/datum/event_handler/miniscope_zoomout/handler = new /datum/event_handler/miniscope_zoomout(src)
			handler.G = G
			handler.aim_slowdown = dynamic_aim_slowdown

			G.slowdown += dynamic_aim_slowdown

			user.add_zoomout_handler(handler)


/obj/item/attachable/scope/collimator
	name = "IFTX B8 Smart-Scope"
	icon_state = "collisight"
	attach_icon = "collisight_a"
	desc = "An experimental IFTX brand B8 Smart-Scope. Based on the technologies used in the Smart Gun by ARMAT, this sight has integrated IFF systems. However, it only attaches to the L42-MK1 Pulse Carbine."
	slot = "rail"
	zoom_offset = 6
	zoom_viewsize = 7
	pixel_shift_y = 15
	has_marine_iff = TRUE
	var/dynamic_aim_slowdown = 0.4

/obj/item/attachable/scope/collimator/New()
	..()
	movement_acc_penalty_mod = 0
	accuracy_unwielded_mod = 0
	damage_mod = -config.min_hit_damage_mult

	accuracy_scoped_buff = config.min_hit_accuracy_mult
	delay_scoped_nerf = 0
	damage_falloff_scoped_buff = 0

/obj/item/attachable/scope/collimator/activate_attachment(obj/item/weapon/gun/G, mob/living/carbon/user, turn_off)
	if(do_after(user, 8, FALSE, 5, BUSY_ICON_HOSTILE))
		allows_movement	= 1
		. = ..()
		if(user && G.zoom)
			var/datum/event_handler/miniscope_zoomout/handler = new /datum/event_handler/miniscope_zoomout(src)
			handler.G = G
			handler.aim_slowdown = dynamic_aim_slowdown

			G.slowdown += dynamic_aim_slowdown

			user.add_zoomout_handler(handler)


/obj/item/attachable/scope/slavic
	icon_state = "slavicscope"
	desc = "Oppa! How did you get this off glorious Stalin weapon? Blyat, put back on and do job tovarish. Yankee is not shoot self no?"



//////////// Stock attachments ////////////////////////////


/obj/item/attachable/stock //Generic stock parent and related things.
	name = "default stock"
	desc = "If you can read this, someone screwed up. Go Gitlab this and bug a coder."
	icon_state = "stock"
	slot = "stock"
	wield_delay_mod = WIELD_DELAY_VERY_FAST
	melee_mod = 5
	size_mod = 2
	pixel_shift_x = 30
	pixel_shift_y = 14

/obj/item/attachable/stock/shotgun
	name = "\improper M37 wooden stock"
	desc = "A non-standard heavy wooden stock for the M37 Shotgun. Less quick and more cumbersome than the standard issue stakeout, but reduces recoil and improves accuracy. Allegedly makes a pretty good club in a fight too.."
	slot = "stock"
	icon_state = "stock"
	wield_delay_mod = WIELD_DELAY_FAST

/obj/item/attachable/stock/shotgun/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = config.med_hit_accuracy_mult
	recoil_mod = -config.low_recoil_value
	scatter_mod = -config.low_scatter_value
	movement_acc_penalty_mod = -1
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -config.low_hit_accuracy_mult
	recoil_unwielded_mod = config.low_recoil_value
	scatter_unwielded_mod = config.low_scatter_value
	//but at the same time you are slow when 2 handed
	aim_speed_mod = 0.25


	matter = list("wood" = 2000)

	select_gamemode_skin(type)

/obj/item/attachable/stock/tactical
	name = "\improper MK221 tactical stock"
	icon_state = "tactical_stock"

/obj/item/attachable/stock/tactical/New()
	..()
	accuracy_mod = config.min_hit_accuracy_mult
	recoil_mod = -config.min_recoil_value
	scatter_mod = -config.min_scatter_value
	delay_mod = config.high_fire_delay
	movement_acc_penalty_mod = -1
	accuracy_unwielded_mod = config.min_hit_accuracy_mult
	recoil_unwielded_mod = -config.min_recoil_value
	scatter_unwielded_mod = -config.min_scatter_value

/obj/item/attachable/stock/slavic
	name = "wooden stock"
	desc = "A non-standard heavy wooden stock for Slavic firearms."
	icon_state = "slavicstock"
	pixel_shift_x = 32
	pixel_shift_y = 13
	flags_attach_features = NOFLAGS

/obj/item/attachable/stock/slavic/New()
	..()
	accuracy_mod = config.min_hit_accuracy_mult
	recoil_mod = -config.min_recoil_value
	scatter_mod = -config.min_scatter_value
	delay_mod = config.med_fire_delay
	movement_acc_penalty_mod = -1
	accuracy_unwielded_mod = config.min_hit_accuracy_mult
	recoil_unwielded_mod = -config.min_recoil_value
	scatter_unwielded_mod = -config.min_scatter_value


/obj/item/attachable/stock/rifle
	name = "\improper M41A skeleton stock"
	desc = "A rare stock distributed in small numbers to USCM forces. Compatible with the M41A, this stock reduces recoil and improves accuracy, but at a reduction to handling and agility. Seemingly a bit more effective in a brawl"
	slot = "stock"
	melee_mod = 5
	size_mod = 1
	icon_state = "riflestock"
	attach_icon = "riflestock_a"
	pixel_shift_x = 41
	pixel_shift_y = 10
	wield_delay_mod = WIELD_DELAY_FAST

/obj/item/attachable/stock/rifle/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = config.med_hit_accuracy_mult
	recoil_mod = -config.low_recoil_value
	scatter_mod = -config.low_scatter_value
	movement_acc_penalty_mod = -1
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -config.low_hit_accuracy_mult
	recoil_unwielded_mod = config.low_recoil_value
	scatter_unwielded_mod = config.low_scatter_value
	//but at the same time you are slow when 2 handed
	aim_speed_mod = 0.25

/obj/item/attachable/stock/carbine
	name = "\improper L42-MK1 synthetic stock"
	desc = "A special issue stock made of sturdy, yet lightweight materials. Attaches to the L42-MK1 Pulse Carbine. Not effective as a blunt force weapon."
	slot = "stock"
	size_mod = 1
	icon_state = "BRstock"
	attach_icon = "BRstock_a"
	pixel_shift_x = 41
	pixel_shift_y = 10
	wield_delay_mod = WIELD_DELAY_NORMAL

/obj/item/attachable/stock/carbine/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = config.med_hit_accuracy_mult
	recoil_mod = -config.low_recoil_value
	scatter_mod = -config.low_scatter_value
	movement_acc_penalty_mod = -1
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -config.low_hit_accuracy_mult
	recoil_unwielded_mod = config.low_recoil_value
	scatter_unwielded_mod = config.low_scatter_value


/obj/item/attachable/stock/rifle/marksman
	name = "\improper M41A marksman stock"
	icon_state = "m4markstock"
	attach_icon = "m4markstock"
	flags_attach_features = NOFLAGS


/obj/item/attachable/stock/smg
	name = "submachinegun stock"
	desc = "A rare stock distributed in small numbers to USCM forces. Compatible with the M39, this stock reduces recoil and improves accuracy, but at a reduction to handling and agility. Seemingly a bit more effective in a brawl"
	slot = "stock"
	melee_mod = 5
	size_mod = 1
	icon_state = "smgstock"
	attach_icon = "smgstock_a"
	pixel_shift_x = 39
	pixel_shift_y = 11
	wield_delay_mod = WIELD_DELAY_FAST

/obj/item/attachable/stock/smg/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = config.low_hit_accuracy_mult
	recoil_mod = -config.low_recoil_value
	scatter_mod = -config.low_scatter_value
	delay_mod = 0
	movement_acc_penalty_mod = -1
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -config.low_hit_accuracy_mult
	recoil_unwielded_mod = config.low_recoil_value
	scatter_unwielded_mod = config.low_scatter_value
	//but at the same time you are slow when 2 handed
	aim_speed_mod = 0.25


/obj/item/attachable/stock/smg/collapsible
	name = "submachinegun paratrooper's stock"
	desc = "Even rarer stock distributed in small numbers to USCM specialists forces. Compatible with the M39, this stock reduces recoil and improves accuracy, but at a reduction to handling and agility. Seemingly a bit more effective in a brawl. This stock can collapse in, removing almost all positive and negative effects, however it slightly increases spread due to weapon being off-balanced by the collapsed stock."
	slot = "stock"
	melee_mod = 5
	size_mod = 1
	icon_state = "smgstockc"
	attach_icon = "smgstockc_a"
	pixel_shift_x = 39
	pixel_shift_y = 11
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle
	var/activated = TRUE
	var/collapsed_stock_scatter = 0

/obj/item/attachable/stock/smg/collapsible/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = config.low_hit_accuracy_mult
	recoil_mod = -config.low_recoil_value
	scatter_mod = -config.low_scatter_value
	wield_delay_mod = WIELD_DELAY_FAST
	delay_mod = 0
	movement_acc_penalty_mod = -1
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -config.low_hit_accuracy_mult
	recoil_unwielded_mod = config.low_recoil_value
	scatter_unwielded_mod = config.low_scatter_value
	//but at the same time you are slow when 2 handed
	aim_speed_mod = 0.25

	collapsed_stock_scatter = config.mlow_scatter_value

/obj/item/attachable/stock/smg/collapsible/Detach(obj/item/weapon/gun/G)
	if(!activated)
		apply_on_weapon(G, TRUE)
	..()

/obj/item/attachable/stock/smg/collapsible/proc/apply_on_weapon(obj/item/weapon/gun/G, new_active)
	var/multiplier = -1
	if(new_active)
		multiplier = 1
	G.accuracy_mult += accuracy_mod * multiplier
	G.recoil += recoil_mod * multiplier
	G.scatter += scatter_mod * multiplier
	G.wield_delay += wield_delay_mod * multiplier
	G.movement_acc_penalty_mult = movement_acc_penalty_mod * multiplier
	//it makes stuff much worse when one handed
	G.accuracy_mult_unwielded += accuracy_unwielded_mod * multiplier
	G.recoil_unwielded += recoil_unwielded_mod * multiplier
	G.scatter_unwielded += scatter_unwielded_mod * multiplier
	//but at the same time you are slow when 2 handed
	G.aim_slowdown += aim_speed_mod * multiplier

	//additionally increases scatter when collapsed
	if(new_active)
		G.scatter_unwielded -= collapsed_stock_scatter
		G.w_class += size_mod
		icon_state = "smgstockc"
		attach_icon = "smgstockc_a"
	else
		G.scatter_unwielded += collapsed_stock_scatter
		G.w_class -= size_mod
		icon_state = "smgstockcc"
		attach_icon = "smgstockcc_a"

	G.update_overlays(src, "stock")

/obj/item/attachable/stock/smg/collapsible/activate_attachment(obj/item/weapon/gun/G, mob/living/carbon/user, turn_off)
	if(G.flags_item & WIELDED)
		if(activated)
			user << "<span class='notice'>You need a free hand to collapse [src].</span>"
		else
			user << "<span class='notice'>You need a free hand to extend [src].</span>"
		return 0
	activated = !activated
	apply_on_weapon(G, activated)
	playsound(user, activation_sound, 15, 1)
	if(!user)
		return 1

	if(activated)
		user << "<span class='notice'>You extend [src].</span>"
	else
		user << "<span class='notice'>You collapse [src].</span>"

/obj/item/attachable/stock/smg/brace
	name = "\improper  submachinegun arm brace"
	desc = "A specialized stock for use on an M39 submachine gun. It makes one handing perfectly accurate at the expense of fire rate. Wielding guns with this stock is very uncomfortable and inaccurate."
	size_mod = 1
	icon_state = "smg_brace"
	attach_icon = "smg_brace_a"
	pixel_shift_x = 39
	pixel_shift_y = 16
	flags_attach_features = ATTACH_REMOVABLE

/obj/item/attachable/stock/smg/brace/New()
	..()
	//Makes stuff better when one handed by a LOT.
	accuracy_unwielded_mod = config.high_hit_accuracy_mult
	recoil_unwielded_mod = -config.max_recoil_value
	delay_mod = config.mlow_fire_delay
	burst_scatter_mod = -6
	//But... it makes wielding something really, really bad.
	accuracy_mod = config.low_hit_accuracy_mult
	recoil_mod = config.high_recoil_value
	scatter_unwielded_mod = -7

/obj/item/attachable/stock/revolver
	name = "\improper M44 magnum sharpshooter stock"
	desc = "A wooden stock modified for use on a 44-magnum. Increases accuracy and reduces recoil at the expense of handling and agility. Less effective in melee as well."
	slot = "stock"
	melee_mod = -5
	size_mod = 1
	size_mod = 2
	icon_state = "44stock"
	pixel_shift_x = 35
	pixel_shift_y = 19
	wield_delay_mod = WIELD_DELAY_FAST

/obj/item/attachable/stock/revolver/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = config.high_hit_accuracy_mult
	recoil_mod = -config.low_recoil_value
	scatter_mod = -config.low_scatter_value
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -config.low_hit_accuracy_mult
	recoil_unwielded_mod = config.low_recoil_value
	scatter_unwielded_mod = config.low_scatter_value
	//but at the same time you are slow when 2 handed
	aim_speed_mod = 0.25




////////////// Underbarrel Attachments ////////////////////////////////////


/obj/item/attachable/attached_gun
	attachment_action_type = /datum/action/item_action/toggle
	//Some attachments may be fired. So here are the variables related to that.
	var/datum/ammo/ammo = null //If it has a default bullet-like ammo.
	var/max_range 		= 0 //Determines # of tiles distance the attachable can fire, if it's not a projectile.
	var/type_of_casings = null
	var/attachment_firing_delay = 0 //the delay between shots, for attachments that fires stuff
	var/fire_sound = null //Sound to play when firing it alternately
	var/gun_original_damage_mult = 1 //so you don't buff the underbarrell gun with charger for the wrong weapon

/obj/item/attachable/attached_gun/New() //Let's make sure if something needs an ammo type, it spawns with one.
	..()
	if(ammo)
		ammo = ammo_list[ammo]


/obj/item/attachable/attached_gun/Dispose()
	ammo = null
	. = ..()



/obj/item/attachable/attached_gun/activate_attachment(obj/item/weapon/gun/G, mob/living/user, turn_off)
	if(G.active_attachable == src)
		if(user)
			user << "<span class='notice'>You are no longer using [src].</span>"
		G.active_attachable = null
		var/diff = G.damage_mult - 1 //so that if we buffed gun in process, it still does stuff
		//yeah you can cheat by placing BC after switching to underbarrell, but that is one time and we can skip it for sake of optimization
		G.damage_mult = gun_original_damage_mult + diff
		icon_state = initial(icon_state)
	else if(!turn_off)
		if(user)
			user << "<span class='notice'>You are now using [src].</span>"
		G.active_attachable = src
		gun_original_damage_mult = G.damage_mult
		G.damage_mult = 1
		icon_state += "-on"

	for(var/X in G.actions)
		var/datum/action/A = X
		A.update_button_icon()
	return 1



//The requirement for an attachable being alt fire is AMMO CAPACITY > 0.
/obj/item/attachable/attached_gun/grenade
	name = "underslung grenade launcher"
	desc = "A weapon-mounted, reloadable, one-shot grenade launcher."
	icon_state = "grenade"
	attach_icon = "grenade_a"
	w_class = 3
	current_rounds = 0
	max_rounds = 2
	max_range = 7
	slot = "under"
	fire_sound = 'sound/weapons/gun_m92_attachable.ogg'
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_RELOADABLE|ATTACH_WEAPON
	var/list/loaded_grenades //list of grenade types loaded in the UGL


/obj/item/attachable/attached_gun/grenade/activate_attachment(atom/target, mob/user)
	playsound(user, activation_sound, 15, 1)
	..()

/obj/item/attachable/attached_gun/grenade/New()
	..()
	attachment_firing_delay = config.max_fire_delay * 3
	loaded_grenades = list()

/obj/item/attachable/attached_gun/grenade/examine(mob/user)
	..()
	if(current_rounds) 	user << "It has [current_rounds] grenade\s left."
	else 				user << "It's empty."





/obj/item/attachable/attached_gun/grenade/reload_attachment(obj/item/explosive/grenade/G, mob/user)
	if(!istype(G) || istype(G, /obj/item/explosive/grenade/spawnergrenade/))
		user << "<span class='warning'>[src] doesn't accept that type of grenade.</span>"
		return
	if(!G.active) //can't load live grenades
		if(!G.underslug_launchable)
			user << "<span class='warning'>[src] doesn't accept that type of grenade.</span>"
			return
		if(current_rounds >= max_rounds)
			user << "<span class='warning'>[src] is full.</span>"
		else
			playsound(user, 'sound/weapons/gun_shotgun_shell_insert.ogg', 25, 1)
			current_rounds++
			loaded_grenades += G.type
			user << "<span class='notice'>You load [G] in [src].</span>"
			user.temp_drop_inv_item(G)
			cdel(G)

/obj/item/attachable/attached_gun/grenade/fire_attachment(atom/target,obj/item/weapon/gun/gun,mob/living/user)
	if(get_dist(user,target) > max_range)
		user << "<span class='warning'>Too far to fire the attachment!</span>"
		return
	if(current_rounds > 0) prime_grenade(target,gun,user)


/obj/item/attachable/attached_gun/grenade/proc/prime_grenade(atom/target,obj/item/weapon/gun/gun,mob/living/user)
	set waitfor = 0
	var/nade_type = loaded_grenades[1]
	var/obj/item/explosive/grenade/HE/G = new nade_type (get_turf(gun))
	playsound(user.loc, fire_sound, 50, 1)
	message_admins("[key_name_admin(user)] fired an underslung grenade launcher (<A HREF='?_src_=admin_holder;adminplayerobservejump=\ref[user]'>JMP</A>)")
	log_game("[key_name_admin(user)] used an underslung grenade launcher.")
	G.det_time = 15
	G.throw_range = max_range
	G.activate()
	G.throw_at(target, max_range, 2, user)
	current_rounds--
	loaded_grenades.Cut(1,2)


//"ammo/flamethrower" is a bullet, but the actual process is handled through fire_attachment, linked through Fire().
/obj/item/attachable/attached_gun/flamer
	name = "mini flamethrower"
	icon_state = "flamethrower"
	attach_icon = "flamethrower_a"
	desc = "A weapon-mounted refillable flamethrower attachment.\nIt is designed for short bursts."
	w_class = 3
	current_rounds = 20
	max_rounds = 20
	max_range = 4
	slot = "under"
	fire_sound = 'sound/weapons/gun_flamethrower3.ogg'
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_RELOADABLE|ATTACH_WEAPON

/obj/item/attachable/attached_gun/flamer/activate_attachment(atom/target, mob/user)
	playsound(user, activation_sound, 15, 1)
	..()

/obj/item/attachable/attached_gun/flamer/New()
	..()
	attachment_firing_delay = config.max_fire_delay * 5

/obj/item/attachable/attached_gun/flamer/examine(mob/user)
	..()
	if(current_rounds > 0) user << "It has [current_rounds] unit\s of fuel left."
	else user << "It's empty."

/obj/item/attachable/attached_gun/flamer/reload_attachment(obj/item/ammo_magazine/flamer_tank/FT, mob/user)
	if(istype(FT))
		if(current_rounds >= max_rounds)
			user << "<span class='warning'>[src] is full.</span>"
		else if(FT.current_rounds <= 0)
			user << "<span class='warning'>[FT] is empty!</span>"
		else
			playsound(user, 'sound/effects/refill.ogg', 25, 1, 3)
			user << "<span class='notice'>You refill [src] with [FT].</span>"
			var/transfered_rounds = min(max_rounds - current_rounds, FT.current_rounds)
			current_rounds += transfered_rounds
			FT.current_rounds -= transfered_rounds
	else
		user << "<span class='warning'>[src] can only be refilled with an incinerator tank.</span>"

/obj/item/attachable/attached_gun/flamer/fire_attachment(atom/target, obj/item/weapon/gun/gun, mob/living/user)
	if(get_dist(user,target) > max_range+4)
		user << "<span class='warning'>Too far to fire the attachment!</span>"
		return
	if(current_rounds) unleash_flame(target, user)


/obj/item/attachable/attached_gun/flamer/proc/unleash_flame(atom/target, mob/living/user)
	set waitfor = 0
	var/list/turf/turfs = getline2(user,target)
	var/distance = 0
	var/turf/prev_T
	playsound(user, 'sound/weapons/gun_flamethrower2.ogg', 50, 1)
	for(var/turf/T in turfs)
		if(T == user.loc)
			prev_T = T
			continue
		if(!current_rounds) 		break
		if(distance >= max_range) 	break
		if(prev_T && LinkBlocked(prev_T, T))
			break
		current_rounds--
		flame_turf(T,user)
		distance++
		prev_T = T
		sleep(1)


/obj/item/attachable/attached_gun/flamer/proc/flame_turf(turf/T, mob/living/user)
	if(!istype(T)) return

	if(!locate(/obj/flamer_fire) in T) // No stacking flames!
		new/obj/flamer_fire(T)


/obj/item/attachable/attached_gun/shotgun
	name = "U7 underbarrel shotgun"
	icon_state = "masterkey"
	attach_icon = "masterkey_a"
	desc = "An ARMAT U7 tactical shotgun. Attaches to the underbarrel of most weapons. Only capable of loading up to three buckshot shells."
	w_class = 3
	max_rounds = 3
	current_rounds = 3
	ammo = /datum/ammo/bullet/shotgun/buckshot/masterkey
	slot = "under"
	fire_sound = 'sound/weapons/gun_shotgun.ogg'
	type_of_casings = "shell"
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_PROJECTILE|ATTACH_RELOADABLE|ATTACH_WEAPON

/obj/item/attachable/attached_gun/shotgun/activate_attachment(atom/target, mob/user)
	playsound(user, activation_sound, 15, 1)
	..()

/obj/item/attachable/attached_gun/shotgun/New()
	..()
	attachment_firing_delay = config.mhigh_fire_delay*3

/obj/item/attachable/attached_gun/shotgun/examine(mob/user)
	..()
	if(current_rounds > 0) 	user << "It has [current_rounds] shell\s left."
	else 					user << "It's empty."

/obj/item/attachable/attached_gun/shotgun/reload_attachment(obj/item/ammo_magazine/handful/mag, mob/user)
	if(istype(mag) && mag.flags_magazine & AMMUNITION_HANDFUL)
		if(mag.default_ammo == /datum/ammo/bullet/shotgun/buckshot)
			if(current_rounds >= max_rounds)
				user << "<span class='warning'>[src] is full.</span>"
			else
				current_rounds++
				mag.current_rounds--
				mag.update_icon()
				user << "<span class='notice'>You load one shotgun shell in [src].</span>"
				playsound(user, 'sound/weapons/gun_shotgun_shell_insert.ogg', 25, 1)
				if(mag.current_rounds <= 0)
					user.temp_drop_inv_item(mag)
					cdel(mag)
			return
	user << "<span class='warning'>[src] only accepts shotgun buckshot.</span>"



/obj/item/attachable/verticalgrip
	name = "vertical grip"
	desc = "A vertical foregrip that offers better accuracy, less recoil, and less scatter, especially during burst fire. \nHowever, it also increases weapon size."
	icon_state = "verticalgrip"
	attach_icon = "verticalgrip_a"
	size_mod = 1
	slot = "under"
	pixel_shift_x = 20

/obj/item/attachable/verticalgrip/New()
	..()
	accuracy_mod = config.low_hit_accuracy_mult
	recoil_mod = -config.min_recoil_value
	scatter_mod = -config.min_scatter_value
	burst_scatter_mod = -2
	movement_acc_penalty_mod = 1
	accuracy_unwielded_mod = -config.low_hit_accuracy_mult
	scatter_unwielded_mod = config.min_scatter_value


/obj/item/attachable/angledgrip
	name = "angled grip"
	desc = "An angled foregrip that improves weapon ergonomics and offers less recoil, and faster wielding time. \nHowever, it also increases weapon size."
	icon_state = "angledgrip"
	attach_icon = "angledgrip_a"
	wield_delay_mod = -WIELD_DELAY_FAST
	size_mod = 1
	slot = "under"
	pixel_shift_x = 20

/obj/item/attachable/angledgrip/New()
	..()
	recoil_mod = -config.min_recoil_value
	accuracy_mod = config.min_hit_accuracy_mult
	accuracy_unwielded_mod = -config.min_hit_accuracy_mult
	scatter_mod = -config.min_scatter_value
	scatter_unwielded_mod = config.min_scatter_value



/obj/item/attachable/gyro
	name = "gyroscopic stabilizer"
	desc = "A set of weights and balances to stabilize the weapon when fired with one hand. Slightly decreases firing speed."
	icon_state = "gyro"
	attach_icon = "gyro_a"
	slot = "under"

/obj/item/attachable/gyro/New()
	..()
	delay_mod = config.mlow_fire_delay
	scatter_mod = -config.min_scatter_value
	burst_scatter_mod = -2
	movement_acc_penalty_mod = -3
	scatter_unwielded_mod = -config.med_scatter_value
	accuracy_unwielded_mod = config.low_hit_accuracy_mult


/obj/item/attachable/lasersight
	name = "laser sight"
	desc = "A laser sight that attaches to the underside of most weapons. Increases accuracy, and decreases scatter when firing one-handed."
	icon_state = "lasersight"
	attach_icon = "lasersight_a"
	slot = "under"
	pixel_shift_x = 17
	pixel_shift_y = 17

/obj/item/attachable/lasersight/New()
	..()
	accuracy_mod = config.min_hit_accuracy_mult
	movement_acc_penalty_mod = -1
	scatter_unwielded_mod = -config.mlow_scatter_value
	accuracy_unwielded_mod = config.min_hit_accuracy_mult


/datum/event_handler/bipod_movement
	var/obj/item/attachable/bipod/attachment
	var/obj/item/weapon/gun/G
	handle(mob/living/sender, datum/event_args/mob_movement/ev_args)
		if(attachment.bipod_deployed)
			attachment.activate_attachment(G, sender)

/obj/item/attachable/bipod
	name = "bipod"
	desc = "A simple set of telescopic poles to keep a weapon stabilized during firing. \nGreatly increases accuracy and reduces recoil when properly placed, but also increases weapon size and slows firing speed."
	icon_state = "bipod"
	attach_icon = "bipod_a"
	slot = "under"
	size_mod = 2
	melee_mod = -10
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle
	var/datum/event_handler/bipod_movement/bipod_movement

/obj/item/attachable/bipod/New()
	..()
	delay_mod = config.mlow_fire_delay

/obj/item/attachable/bipod/Detach(obj/item/weapon/gun/G)
	if(bipod_deployed)
		undeploy_bipod(G)
	..()

/obj/item/attachable/bipod/proc/undeploy_bipod(obj/item/weapon/gun/G)
	bipod_deployed = FALSE
	G.aim_slowdown -= SLOWDOWN_ADS_SCOPE
	G.wield_delay -= WIELD_DELAY_FAST
	G.accuracy_mult -= config.hmed_hit_accuracy_mult
	G.burst_scatter_mult += config.low_scatter_value
	G.fire_delay += config.min_fire_delay + config.mlow_fire_delay
	if(istype(G,/obj/item/weapon/gun/rifle/lmg))
		G.fire_delay += config.min_fire_delay

/obj/item/attachable/bipod/activate_attachment(obj/item/weapon/gun/G,mob/living/user, turn_off)
	if(turn_off)
		if(bipod_deployed)
			undeploy_bipod(G)
			if(bipod_movement)
				user.remove_movement_handler(bipod_movement)
				bipod_movement = null
	else
		var/obj/support = check_bipod_support(G, user)
		if(!support&&!bipod_deployed)
			user << "<span class='notice'>You need a support to deploy bipod.</span>"
			return
		bipod_deployed = !bipod_deployed
		if(user)
			if(bipod_deployed)
				user << "<span class='notice'>You deploy [src][support ? " on [support]" : ""].</span>"
				G.aim_slowdown += SLOWDOWN_ADS_SCOPE
				G.wield_delay += WIELD_DELAY_FAST
				G.accuracy_mult += config.hmed_hit_accuracy_mult
				G.burst_scatter_mult -= config.low_scatter_value
				G.fire_delay -= config.min_fire_delay + config.mlow_fire_delay
				if(istype(G,/obj/item/weapon/gun/rifle/lmg))
					G.fire_delay -= config.min_fire_delay
				if(!bipod_movement)
					bipod_movement = new /datum/event_handler/bipod_movement()
					bipod_movement.attachment = src
					bipod_movement.G = G
					user.add_movement_handler(bipod_movement)

			else
				user << "<span class='notice'>You retract [src].</span>"
				undeploy_bipod(G,user)
				if(bipod_movement)
					user.remove_movement_handler(bipod_movement)
					bipod_movement = null

	if(bipod_deployed)
		icon_state = "bipod-on"
		attach_icon = "bipod_a-on"
	else
		icon_state = "bipod"
		attach_icon = "bipod_a"

	G.update_attachable(slot)

	for(var/X in G.actions)
		var/datum/action/A = X
		A.update_button_icon()
	return 1



//when user fires the gun, we check if they have something to support the gun's bipod.
/obj/item/attachable/proc/check_bipod_support(obj/item/weapon/gun/G, mob/living/user)
	return 0

/obj/item/attachable/bipod/check_bipod_support(obj/item/weapon/gun/G, mob/living/user)
	var/turf/T = get_turf(user)
	for(var/obj/O in T)
		if(O.throwpass && O.density && O.dir == user.dir && O.flags_atom & ON_BORDER)
			return O
	var/turf/T2 = get_step(T, user.dir)

	for(var/obj/O2 in T2)
		if(O2.throwpass && O2.density)
			return O2
	return 0




/obj/item/attachable/burstfire_assembly
	name = "burst fire assembly"
	desc = "A small angled piece of fine machinery that increases the burst count on some weapons, and grants the ability to others. \nIncreases weapon scatter."
	icon_state = "rapidfire"
	attach_icon = "rapidfire_a"
	slot = "under"

/obj/item/attachable/burstfire_assembly/New()
	..()
	accuracy_mod = -config.low_hit_accuracy_mult
	burst_mod = config.low_burst_value

	accuracy_unwielded_mod = -config.med_hit_accuracy_mult
