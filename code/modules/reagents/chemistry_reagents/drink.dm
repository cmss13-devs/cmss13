

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// DRINKS BELOW, Beer is up there though, along with cola. Cap'n Pete's Cuban Spiced Rum////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////


/datum/reagent/drink
	name = "Drink"
	id = "drink"
	description = "Uh, some kind of drink."
	reagent_state = LIQUID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#E78108" // rgb: 231, 129, 8
	var/adj_dizzy = 0
	var/adj_drowsy = 0
	var/adj_sleepy = 0
	var/adj_temp = 0

/datum/reagent/drink/on_mob_life(mob/living/M, alien)
	//This is all way too snowflake to accurately transition to the property system so it stays here
	if(alien == IS_YAUTJA || alien == IS_HORROR || !holder)
		return
	M.nutrition += nutriment_factor
	// Drinks should be used up faster than other reagents.
	holder.remove_reagent(src.id, FOOD_METABOLISM * 2)
	if(adj_dizzy)
		M.dizziness = max(0,M.dizziness + adj_dizzy)
	if(adj_drowsy)
		M.drowsyness = max(0,M.drowsyness + adj_drowsy)
	if(adj_sleepy)
		M.sleeping = max(0,M.sleeping + adj_sleepy)
	if(adj_temp && M.bodytemperature < 310) //310 is the normal bodytemp. 310.055
		M.bodytemperature = min(310, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
		M.recalculate_move_delay = TRUE

/datum/reagent/drink/cold
	name = "Cold drink"
	adj_temp = 0


//FRIUT JUICE//

/datum/reagent/drink/orangejuice
	name = "Orange juice"
	id = "orangejuice"
	description = "Both delicious AND rich in Vitamin C, what more do you need?"
	color = "#E78108" // rgb: 231, 129, 8

/datum/reagent/drink/orangejuice/on_mob_life(mob/living/M)
	. = ..()
	if(!.)
		return
	if(M.getOxyLoss() && prob(30))
		M.apply_damage(-1, OXY)

/datum/reagent/drink/tomatojuice
	name = "Tomato Juice"
	id = "tomatojuice"
	description = "Tomatoes made into juice. What a waste of big, juicy tomatoes, huh?"
	color = "#731008" // rgb: 115, 16, 8

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		if(M.getFireLoss() && prob(20)) M.heal_limb_damage(0,1)


/datum/reagent/drink/limejuice
	name = "Lime Juice"
	id = "limejuice"
	description = "The sweet-sour juice of limes."
	color = "#365E30" // rgb: 54, 94, 48
	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		if(M.getToxLoss() && prob(20)) M.apply_damage(-1*REM, TOX)

/datum/reagent/drink/carrotjuice
	name = "Carrot juice"
	id = "carrotjuice"
	description = "It is just like a carrot but without crunching."
	color = "#973800" // rgb: 151, 56, 0

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.eye_blurry = max(M.eye_blurry-1 , 0)
		M.eye_blind = max(M.eye_blind-1 , 0)
		if(!data) data = 1
		switch(data)
			if(1 to 20)
				//nothing
			if(21 to INFINITY)
				if(prob(data-10))
					M.disabilities &= ~NEARSIGHTED
		data++

/datum/reagent/drink/berryjuice
	name = "Berry Juice"
	id = "berryjuice"
	description = "A delicious blend of several different kinds of berries."
	color = "#990066" // rgb: 153, 0, 102

/datum/reagent/drink/grapejuice
	name = "Grape Juice"
	id = "grapejuice"
	description = "It's grrrrrape!"
	color = "#863333" // rgb: 134, 51, 51

/datum/reagent/drink/poisonberryjuice
	name = "Poison Berry Juice"
	id = "poisonberryjuice"
	description = "A tasty juice blended from various kinds of very deadly and toxic berries."
	color = "#863353" // rgb: 134, 51, 83

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.apply_damage(1, TOX)

/datum/reagent/drink/watermelonjuice
	name = "Watermelon Juice"
	id = "watermelonjuice"
	description = "Delicious juice made from watermelon."
	color = "#863333" // rgb: 134, 51, 51

/datum/reagent/drink/lemonjuice
	name = "Lemon Juice"
	id = "lemonjuice"
	description = "This juice is VERY sour."
	color = "#863333" // rgb: 175, 175, 0

/datum/reagent/drink/banana
	name = "Banana Juice"
	id = "banana"
	description = "The raw essence of a banana."
	color = "#863333" // rgb: 175, 175, 0

/datum/reagent/drink/potato_juice
	name = "Potato Juice"
	id = "potato"
	description = "Juice of the potato. Bleh."
	nutriment_factor = 2 * FOOD_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

/datum/reagent/drink/grenadine
	name = "Grenadine Syrup"
	id = "grenadine"
	description = "Made in the modern day with proper pomegranate substitute. Who uses real fruit, anyways?"
	color = "#FF004F" // rgb: 255, 0, 79



//MILK//

/datum/reagent/drink/milk
	name = "Milk"
	id = "milk"
	description = "An opaque white liquid produced by the mammary glands of mammals."
	color = "#DFDFDF" // rgb: 223, 223, 223

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		if(M.getBruteLoss() && prob(20)) M.heal_limb_damage(1,0)
		holder.remove_reagent("capsaicin", 10*REAGENTS_METABOLISM)
		holder.remove_reagent("hotsauce", 10*REAGENTS_METABOLISM)

/datum/reagent/drink/milk/soymilk
	name = "Soy Milk"
	id = "soymilk"
	description = "An opaque white liquid made from soybeans."
	color = "#DFDFC7" // rgb: 223, 223, 199

/datum/reagent/drink/milk/cream
	name = "Cream"
	id = "cream"
	description = "The fatty, still liquid part of milk. Why don't you mix this with sum scotch, eh?"
	color = "#DFD7AF" // rgb: 223, 215, 175

/datum/reagent/drink/milk/eggnog
	name = "Eggnog"
	id = "eggnog"
	description = "A rich, sweet, non-alcoholic beverage traditionally consumed around Christmastime."
	color = "#DFD7AF" // rgb: 223, 215, 175

/datum/reagent/drink/cold/milkshake
	name = "Milkshake"
	description = "Glorious brainfreezing mixture."
	id = "milkshake"
	color = "#AEE5E4" // rgb" 174, 229, 228
	adj_temp = 0

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		if(!M)
			M = holder.my_atom
		if(prob(1))
			M.emote("shiver")
		M.bodytemperature = max(M.bodytemperature - 10 * TEMPERATURE_DAMAGE_COEFFICIENT, 0)
		M.recalculate_move_delay = TRUE
		holder.remove_reagent("capsaicin", 5)
		holder.remove_reagent("hotsauce", 5)
		holder.remove_reagent(src.id, FOOD_METABOLISM)

//SOUTO//

/datum/reagent/drink/souto
	name = "Souto Classic"
	id = "souto_classic"
	description = "A tangerine flavored soda that's canned in Havana"
	color = "#802b00"
	adj_drowsy 	= 	-10
	chemclass = CHEM_CLASS_RARE

/datum/reagent/drink/souto/cherry
	name = "Cherry Souto"
	id = "souto_cherry"
	description = "A cherry flavored soda that's canned in Havanna"
	color = "#800000"

/datum/reagent/drink/souto/lime
	name = "Lime Souto"
	id = "souto_lime"
	description = "A lime flavored soda that's canned in Havanna"
	color = "#878F00"

/datum/reagent/drink/souto/grape
	name = "Grape Souto"
	id = "souto_grape"
	description = "A grape flavored soda that's canned in Havanna"
	color = "#421C52"

/datum/reagent/drink/souto/blueraspberry
	name = "Blue Raspberry Souto"
	id = "souto_blueraspberry"
	description = "A blue fruit flavored soda that's canned in Havana"
	color = "#005B96"

/datum/reagent/drink/souto/peach
	name = "Peach Souto"
	id = "souto_peach"
	description = "A peach flavored soda with flecks of peach pit floating inside that's canned in Havana"
	color = "#FFE5B4"

/datum/reagent/drink/souto/cranberry
	name = "Cranberry Souto"
	id = "souto_cranberry"
	description = "A cranberry flavored soda that's canned in Havana"
	color = "#950714"

/datum/reagent/drink/souto/vanilla
	name = "Vanilla Souto"
	id = "souto_vanilla"
	description = "A vanilla flavored soda that's canned in Havana"
	color = "#F9E5BC"

/datum/reagent/drink/souto/pineapple
	name = "Pineapple Souto"
	id = "souto_pineapple"
	description = "A pineapple flavored soda that's canned in Havana"
	color = "#FEEB75"

//OTHER SODA//

/datum/reagent/drink/cold/sodawater
	name = "Soda Water"
	id = "sodawater"
	description = "A can of club soda. Why not make a scotch and soda?"
	color = "#619494" // rgb: 97, 148, 148
	adj_dizzy = -5
	adj_drowsy = -3

/datum/reagent/drink/cold/grapesoda
	name = "Grape Soda"
	id = "grapesoda"
	description = "Grapes made into a fine drank."
	color = "#421C52" // rgb: 98, 57, 53
	adj_drowsy 	= 	-3

/datum/reagent/drink/cold/space_cola
	name = "Space Cola"
	id = "cola"
	description = "A refreshing beverage."
	reagent_state = LIQUID
	color = "#100800" // rgb: 16, 8, 0
	adj_drowsy 	= 	-3

/datum/reagent/drink/cold/wy_cola
	name = "Fruit Beer"
	id = "fruit_beer"
	description = "An insulting Mango flavored beverage. Tastes like rotten fruit."
	color = "#100800" // rgb: 16, 8, 0
	adj_drowsy = -3

/datum/reagent/drink/cold/nuka_cola
	name = "Nuka Cola"
	id = "nuka_cola"
	description = "Cola, cola never changes."
	color = "#100800" // rgb: 16, 8, 0
	adj_sleepy = -2

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.make_jittery(20)
		M.druggy = max(M.druggy, 30)
		M.dizziness +=5
		M.drowsyness = 0

/datum/reagent/drink/cold/spacemountainwind
	name = "Mountain Wind"
	id = "spacemountainwind"
	description = "Blows right through you like a space wind."
	color = "#102000" // rgb: 16, 32, 0
	adj_drowsy = -7
	adj_sleepy = -1

/datum/reagent/drink/cold/dr_gibb
	name = "Dr. Gibb"
	id = "dr_gibb"
	description = "A delicious blend of 42 different flavours"
	color = "#102000" // rgb: 16, 32, 0
	adj_drowsy = -6

/datum/reagent/drink/cold/space_up
	name = "Space-Up"
	id = "space_up"
	description = "Tastes like a hull breach in your mouth."
	color = "#202800" // rgb: 32, 40, 0
	adj_temp = 0



//BEER//

/datum/reagent/drink/wy_beer
	name = "Aspen Beer"
	id = "aspen"
	description = "Pretty good when you get past the fact that it tastes like piss. Canned by the Weyland-Yutani Corporation."
	color = "#ffcc66"



//COFFEE/TEA//

/datum/reagent/drink/coffee
	name = "Coffee"
	id = "coffee"
	description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
	color = "#482000" // rgb: 72, 32, 0
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL*6
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	adj_temp = 5
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/drink/coffee/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.make_jittery(5)
	if(adj_temp > 0)
		holder.remove_reagent("frostoil", 10*REAGENTS_METABOLISM)

	if(volume > overdose)
		if(!ishuman(M))
			return
		var/mob/living/carbon/human/H = M
		if(prob(5))
			M.emote(pick("twitch", "blink_r", "shiver"))
		if(volume > overdose_critical)
			M.apply_damage(2, TOX) //Overdose starts getting bad
			M.make_jittery(10)
			M.KnockOut(20)
			var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
			if(prob(10) && E)
				E.damage += 0.5
				M.emote(pick("twitch", "blink_r", "shiver"))

/datum/reagent/drink/coffee/icecoffee
	name = "Iced Coffee"
	id = "icecoffee"
	description = "Coffee and ice, refreshing and cool."
	color = "#102838" // rgb: 16, 40, 56
	adj_temp = 0
	chemclass = CHEM_CLASS_NONE

/datum/reagent/drink/coffee/soy_latte
	name = "Soy Latte"
	id = "soy_latte"
	description = "A nice and tasty beverage while you are reading your hippie books."
	color = "#664300" // rgb: 102, 67, 0
	adj_sleepy = 0
	adj_temp = 5
	chemclass = CHEM_CLASS_NONE

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.sleeping = 0
		if(M.getBruteLoss() && prob(20)) M.heal_limb_damage(1,0)

/datum/reagent/drink/coffee/cafe_latte
	name = "Cafe Latte"
	id = "cafe_latte"
	description = "A nice, strong and tasty beverage while you are reading."
	color = "#664300" // rgb: 102, 67, 0
	adj_sleepy = 0
	adj_temp = 5

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.sleeping = 0
		if(M.getBruteLoss() && prob(20)) M.heal_limb_damage(1,0)

/datum/reagent/drink/tea
	name = "Tea"
	id = "tea"
	description = "Black tea, containing antioxidants."
	color = "#101000" // rgb: 16, 16, 0
	adj_dizzy = -2
	adj_drowsy = -1
	adj_sleepy = -3
	adj_temp = 5
	chemclass = CHEM_CLASS_UNCOMMON

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		if(M.getToxLoss() && prob(20))
			M.apply_damage(-1, TOX)

/datum/reagent/drink/tea/icetea
	name = "Iced Tea"
	id = "icetea"
	description = "No relation to a certain rap artist/ actor."
	color = "#104038" // rgb: 16, 64, 56
	adj_temp = 0



//OTHER//

/datum/reagent/drink/nothing
	name = "Nothing"
	id = "nothing"
	description = "Absolutely nothing."

/datum/reagent/machosauce
	name = "Macho Sauce"
	id = "machosauce"
	description = "A backalley abomination born in the darkest corner of the brig. This cocktail of pepper spray and Souto is only drank by the craziest servicemen."
	reagent_state = LIQUID
	color = "#d1001c" // rgb: 209, 0, 28
	chemclass = CHEM_CLASS_RARE
	custom_metabolism = RAPID_METABOLISM

	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	properties = list(PROPERTY_HYPERTHERMIC = 8)

/datum/reagent/drink/cold/tonic
	name = "Tonic Water"
	id = "tonic"
	description = "It tastes strange but at least the quinine keeps the Space Malaria at bay."
	color = "#664300" // rgb: 102, 67, 0
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2

/datum/reagent/drink/cold/ice
	name = "Ice"
	id = "ice"
	description = "Frozen water, your dentist wouldn't like you chewing this."
	reagent_state = SOLID
	color = "#619494" // rgb: 97, 148, 148

/datum/reagent/drink/cold/lemon_lime
	name = "Lemon Lime"
	description = "A tangy substance made of 0.5% natural citrus!"
	id = "lemon_lime"
	color = "#878F00" // rgb: 135, 40, 0
	adj_temp = 0

/datum/reagent/drink/cold/lemonade
	name = "Lemonade"
	description = "Oh the nostalgia..."
	id = "lemonade"
	color = "#FFFF00" // rgb: 255, 255, 0



//////////////////////////////////////////////Remove When Safe//////////////////////////////////////////////

/datum/reagent/atomicbomb
	name = "Atomic Bomb"
	id = "atomicbomb"
	description = "Nuclear proliferation never tasted so good."
	reagent_state = LIQUID
	color = "#666300" // rgb: 102, 99, 0

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.druggy = max(M.druggy, 50)
		M.confused = max(M.confused+2,0)
		M.make_dizzy(10)
		if(!M.stuttering) M.stuttering = 1
		M.stuttering += 3
		if(!data) data = 1
		data++
		switch(data)
			if(51 to 200)
				M.sleeping++
			if(201 to INFINITY)
				M.sleeping++
				M.apply_damage(2, TOX)

/datum/reagent/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	id = "gargleblaster"
	description = "Whoah, this stuff looks volatile!"
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		if(!data) data = 1
		data++
		M.dizziness +=6
		if(data >= 15 && data <45)
			if(!M.stuttering) M.stuttering = 1
			M.stuttering += 3
		else if(data >= 45 && prob(50) && data <55)
			M.confused = max(M.confused+3,0)
		else if(data >=55)
			M.druggy = max(M.druggy, 55)
		else if(data >=200)
			M.apply_damage(2, TOX)

/datum/reagent/neurotoxin
	name = "Neurotoxin"
	id = "neurotoxin"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	reagent_state = LIQUID
	color = "#2E2E61" // rgb: 46, 46, 97

	on_mob_life(mob/living/carbon/M)
		. = ..()
		if(!.) return
		M.knocked_down = max(M.knocked_down, 3)
		if(!data) data = 1
		data++
		M.dizziness +=6
		if(data >= 15 && data <45)
			if(!M.stuttering) M.stuttering = 1
			M.stuttering += 3
		else if(data >= 45 && prob(50) && data <55)
			M.confused = max(M.confused+3,0)
		else if(data >=55)
			M.druggy = max(M.druggy, 55)
		else if(data >=200)
			M.apply_damage(2, TOX)

/datum/reagent/hippies_delight
	name = "Hippies' Delight"
	id = "hippiesdelight"
	description = "You just don't get it maaaan."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.druggy = max(M.druggy, 50)
		if(!data) data = 1
		data++
		switch(data)
			if(1 to 5)
				if(!M.stuttering) M.stuttering = 1
				M.make_dizzy(10)
				if(prob(10)) M.emote(pick("twitch","giggle"))
			if(5 to 10)
				if(!M.stuttering) M.stuttering = 1
				M.make_jittery(20)
				M.make_dizzy(20)
				M.druggy = max(M.druggy, 45)
				if(prob(20)) M.emote(pick("twitch","giggle"))
			if(10 to 200)
				if(!M.stuttering) M.stuttering = 1
				M.make_jittery(40)
				M.make_dizzy(40)
				M.druggy = max(M.druggy, 60)
				if(prob(30)) M.emote(pick("twitch","giggle"))
			if(200 to INFINITY)
				if(!M.stuttering) M.stuttering = 1
				M.make_jittery(60)
				M.make_dizzy(60)
				M.druggy = max(M.druggy, 75)
				if(prob(40)) M.emote(pick("twitch","giggle"))
				if(prob(30)) M.apply_damage(2, TOX)
		holder.remove_reagent(src.id, 0.2)

/datum/reagent/drink/cold/rewriter
	name = "Rewriter"
	description = "The secret of the sanctuary of the Librarian..."
	id = "rewriter"
	color = "#485000" // rgb:72, 080, 0

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.make_jittery(5)

/datum/reagent/doctor_delight
	name = "The Doctor's Delight"
	id = "doctorsdelight"
	description = "A gulp a day keeps the MediBot away. That's probably for the best."
	reagent_state = LIQUID
	color = "#FF8CFF" // rgb: 255, 140, 255
	nutriment_factor = 1 * FOOD_METABOLISM

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M:nutrition += nutriment_factor
		holder.remove_reagent(src.id, FOOD_METABOLISM)
		if(M:getOxyLoss() && prob(50)) M:apply_damage(-2, OXY)
		if(M:getBruteLoss() && prob(60)) M:heal_limb_damage(2,0)
		if(M:getFireLoss() && prob(50)) M:heal_limb_damage(0,2)
		if(M:getToxLoss() && prob(50)) M:apply_damage(-2, TOX)
		if(M.dizziness !=0) M.dizziness = max(0,M.dizziness-15)
		if(M.confused !=0) M.confused = max(0,M.confused - 5)

/datum/reagent/drink/cold/kiraspecial
	name = "Kira Special"
	description = "Long live the guy who everyone had mistaken for a girl. Baka!"
	id = "kiraspecial"
	color = "#CCCC99" // rgb: 204, 204, 153

/datum/reagent/drink/cold/brownstar
	name = "Brown Star"
	description = "It's not what it sounds like..."
	id = "brownstar"
	color = "#9F3400" // rgb: 159, 052, 000
	adj_temp = 0


/datum/reagent/drink/hot_coco
	name = "Hot Chocolate"
	id = "hot_coco"
	description = "Heated beverage of chocolate."
	reagent_state = LIQUID
	nutriment_factor = 2 * FOOD_METABOLISM
	color = "#403010" // rgb: 64, 48, 16
	chemclass = CHEM_CLASS_RARE
	adj_temp = 5


