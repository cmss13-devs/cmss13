
/mob/living/carbon/Xenomorph/proc/upgrade_xeno(newlevel)
	upgrade = newlevel
	upgrade_stored = 0
	visible_message("<span class='xenonotice'>\The [src] begins to twist and contort.</span>", \
	"<span class='xenonotice'>You begin to twist and contort.</span>")
	xeno_jitter(25)
	sleep(25)

	switch(upgrade)
		//FIRST UPGRADE
		if(1)
			src << "<span class='xenodanger'>You feel a bit stronger.</span>"
		//SECOND UPGRADE
		if(2)
			src << "<span class='xenodanger'>You feel a whole lot stronger.</span>"
		//Final UPGRADE
		if(3)
			switch(caste.caste_name)
				if("Runner")
					src << "<span class='xenoannounce'>You are the fastest assassin of all time. Your speed is unmatched.</span>"
				if("Lurker")
					src << "<span class='xenoannounce'>You are the epitome of the hunter. Few can stand against you in open combat.</span>"
				if("Ravager")
					src << "<span class='xenoannounce'>You are death incarnate. All will tremble before you.</span>"
				if ("Defender")
					src << "<span class='xenoannounce'>You are a incredibly resilient, you can control the battle through sheer force.</span>"
				if ("Warrior")
					src << "<span class='xenoannounce'>None can stand before you. You will annihilate all weaklings who try.</span>"
				if("Crusher")
					src << "<span class='xenoannounce'>You are the physical manifestation of a Tank. Almost nothing can harm you.</span>"
				if("Sentinel")
					src << "<span class='xenoannounce'>You are the stun master. Your stunning is legendary and causes massive quantities of salt.</span>"
				if("Spitter")
					src << "<span class='xenoannounce'>You are a master of ranged stuns and damage. Go fourth and generate salt.</span>"
				if("Boiler")
					src << "<span class='xenoannounce'>You are the master of ranged artillery. Bring death from above.</span>"
				if("Praetorian")
					src << "<span class='xenoannounce'>You are the strongest range fighter around. Your spit is devestating and you can fire nearly a constant stream.</span>"
				if("Drone")
					src <<"<span class='xenoannounce'>You are the ultimate worker of the Hive. Time to clock in, and clock the tallhosts out.</span>"
				if("Hivelord")
					src <<"<span class='xenoannounce'>You are the builder of walls. Ensure that the marines are the ones who pay for them.</span>"
				if("Carrier")
					src << "<span class='xenoannounce'>You are the master of huggers. Throw them like baseballs at the marines!</span>"
				if("Burrower")
					src << "<span class='xenoannounce'>You are the master of traps. You are the bane of marine pushes!</span>"
				if("Queen")
					src << "<span class='xenoannounce'>You are the Alpha and the Omega. The beginning and the end.</span>"

	update_caste()

	generate_name() //Give them a new name now

	hud_set_queen_overwatch() //update the upgrade level insignia on our xeno hud.

	//One last shake for the sake of it
	xeno_jitter(25)


//Tiered spawns.
/mob/living/carbon/Xenomorph/Runner/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Runner/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Runner/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Drone/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Drone/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Drone/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Carrier/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Carrier/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Carrier/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Hivelord/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Hivelord/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Hivelord/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Praetorian/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Praetorian/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Praetorian/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Ravager/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Ravager/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Ravager/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Sentinel/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Sentinel/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Sentinel/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Spitter/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Spitter/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Spitter/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Lurker/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Lurker/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Lurker/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Queen/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Queen/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Queen/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Crusher/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Crusher/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Crusher/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Boiler/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Boiler/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Boiler/ancient/New()
	..()
	upgrade_xeno(3)



/mob/living/carbon/Xenomorph/Defender/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Defender/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Defender/ancient/New()
	..()
	upgrade_xeno(3)


/mob/living/carbon/Xenomorph/Warrior/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Warrior/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Warrior/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Burrower/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Burrower/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Burrower/ancient/New()
	..()
	upgrade_xeno(3)
