/obj/structure/machinery/computer
	name = "computer"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	density = FALSE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	layer = BELOW_OBJ_LAYER
	idle_power_usage = 300
	active_power_usage = 300
	projectile_coverage = PROJECTILE_COVERAGE_LOW
	unslashable = TRUE
	var/circuit = null //The path to the circuit board type. If circuit==null, the computer can't be disassembled.
	var/processing = FALSE //Set to true if computer needs to do /process()
	var/deconstructible = TRUE
	var/exproof = 0

/obj/structure/machinery/computer/Initialize()
	. = ..()
	if(processing)
		start_processing()
	power_change()

/obj/structure/machinery/computer/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

/obj/structure/machinery/computer/process()
	if(inoperable())
		return 0
	return 1

/obj/structure/machinery/computer/emp_act(severity)
	. = ..()
	if(prob(20/severity))
		set_broken()


/obj/structure/machinery/computer/ex_act(severity)
	if(exproof)
		return
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(25))
				verbs.Cut()
				set_broken()
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(25))
				qdel(src)
				return
			if (prob(50))
				verbs.Cut()
				set_broken()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
			return

/obj/structure/machinery/computer/bullet_act(obj/projectile/Proj)
	if(exproof)
		visible_message("[Proj] ricochets off [src]!")
		return 0
	else
		if(prob(floor(Proj.ammo.damage /2)))
			set_broken()
		..()
		return 1

/obj/structure/machinery/computer/update_icon()
	..()
	icon_state = initial(icon_state)
	// Broken
	if(stat & BROKEN)
		icon_state += "b"

	// Powered
	else if(stat & NOPOWER)
		icon_state = initial(icon_state)
		icon_state += "0"



/obj/structure/machinery/computer/power_change()
	..()
	update_icon()


/obj/structure/machinery/computer/proc/set_broken()
	stat |= BROKEN
	update_icon()

/obj/structure/machinery/computer/proc/decode(text)
	// Adds line breaks
	text = replacetext(text, "\n", "<BR>")
	return text


/obj/structure/machinery/computer/attackby(obj/item/I, mob/user)
	if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER) && circuit)
		if(!deconstructible)
			to_chat(user, SPAN_WARNING("You can't figure out how to deconstruct [src]..."))
			return
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You don't know how to deconstruct [src]..."))
			return
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
		if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_BUILD))
			var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
			var/obj/item/circuitboard/computer/M = new circuit( A )
			A.circuit = M
			A.anchored = TRUE
			for (var/obj/C in src)
				C.forceMove(loc)
			if (src.stat & BROKEN)
				to_chat(user, SPAN_NOTICE("The broken glass falls out."))
				new /obj/item/shard( src.loc )
				A.state = 3
				A.icon_state = "3"
			else
				to_chat(user, SPAN_NOTICE("You disconnect the monitor."))
				A.state = 4
				A.icon_state = "4"
			M.disassemble(src)
			deconstruct()
	else
		if(isxeno(user))
			src.attack_alien(user)
			return
		src.attack_hand(user)
	return ..()

/obj/structure/machinery/computer/attack_hand()
	. = ..()
	if(!.) //not broken or unpowered
		if(ishuman(usr))
			playsound(src, "keyboard", 15, 1)

/obj/structure/machinery/computer/fixer
	var/all_configs

/obj/structure/machinery/computer/fixer/New()
	all_configs = config
	..()
