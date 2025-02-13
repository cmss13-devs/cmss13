#define WIRE_ASSEMBLY_RECEIVE 1 //Allows Pulsed(0) to call Activate()
#define WIRE_ASSEMBLY_PULSE 2 //Allows Pulse(0) to act on the holder
#define WIRE_ASSEMBLY_PULSE_SPECIAL 4 //Allows Pulse(0) to act on the holders special assembly
#define WIRE_RADIO_RECEIVE 8 //Allows Pulsed(1) to call Activate()
#define WIRE_RADIO_PULSE 16 //Allows Pulse(1) to send a radio message

/obj/item/device/assembly
	name = "assembly"
	desc = "A small electronic device that should never exist."
	icon = 'icons/obj/items/new_assemblies.dmi'
	icon_state = ""
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_SMALL
	matter = list("metal" = 100)
	throwforce = 2
	throw_speed = SPEED_VERY_FAST
	throw_range = 10
	attack_speed = 3


	var/secured = 1
	var/list/attached_overlays = null
	var/obj/item/device/assembly_holder/holder = null
	var/cooldown = 0//To prevent spam
	var/wires = WIRE_ASSEMBLY_RECEIVE|WIRE_ASSEMBLY_PULSE

/obj/item/device/assembly/ui_state()
	return GLOB.deep_inventory_state

/obj/item/device/assembly/Destroy()
	if(holder)
		holder = null
	if(attached_overlays)
		attached_overlays.Cut()
	. = ..()

/obj/item/device/assembly/proc/activate() //What the device does when turned on
	if(!secured || (cooldown > 0))
		return 0
	cooldown = 2
	spawn(10)
		process_cooldown()
	return 1

/obj/item/device/assembly/proc/pulsed(radio = 0) //Called when another assembly acts on this one, radio will determine where it came from for wire calcs
	if(holder && (wires & WIRE_ASSEMBLY_RECEIVE))
		activate()
	if(radio && (wires & WIRE_RADIO_RECEIVE))
		activate()
	return 1

/obj/item/device/assembly/proc/pulse(radio = 0) //Called when this device attempts to act on another device, radio determines if it was sent via radio or direct
	if(holder && (wires & WIRE_ASSEMBLY_PULSE))
		holder.process_activation(src, 1, 0)
	if(holder && (wires & WIRE_ASSEMBLY_PULSE_SPECIAL))
		holder.process_activation(src, 0, 1)
	return 1

/obj/item/device/assembly/proc/toggle_secure() //Code that has to happen when the assembly is un\secured goes here
	secured = !secured
	update_icon()
	return secured

/obj/item/device/assembly/proc/attach_assembly(obj/A, mob/user) //Called when an assembly is attacked by another
	holder = new/obj/item/device/assembly_holder(get_turf(src))
	if(holder.attach(A,src,user))
		to_chat(user, SPAN_NOTICE("You attach \the [A] to \the [src]!"))
		return 1
	return 0

/obj/item/device/assembly/proc/process_cooldown() //Called via spawn(10) to have it count down the cooldown var
	cooldown--
	if(cooldown <= 0)
		return 0
	spawn(10)
		process_cooldown()
	return 1

/obj/item/device/assembly/attackby(obj/item/W as obj, mob/user as mob)
	if(isassembly(W))
		var/obj/item/device/assembly/A = W
		if((!A.secured) && (!secured))
			attach_assembly(A,user)
			return
	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		if(toggle_secure())
			to_chat(user, SPAN_NOTICE("\The [src] is ready!"))
		else
			to_chat(user, SPAN_NOTICE("\The [src] can now be attached!"))
		return
	..()

/obj/item/device/assembly/process()
	STOP_PROCESSING(SSobj, src)
	return

/obj/item/device/assembly/get_examine_text(mob/user)
	. = ..()
	if((in_range(src, user) || loc == usr))
		if(secured)
			. += "[src] is ready!"
		else
			. += "[src] can be attached!"

/obj/item/device/assembly/attack_self(mob/user)
	..()

	if(!user)
		return

	user.set_interaction(src)
	interact(user)

/obj/item/device/assembly/proc/holder_movement() //Called when the holder is moved
		return

/obj/item/device/assembly/interact(mob/user as mob) //Called when attack_self is called
		return
