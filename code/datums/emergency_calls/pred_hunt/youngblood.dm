/datum/emergency_call/young_bloods/one_member //For if a pred wants to teach a single youngblood
	name = "Hunting Grounds - Solo Youngblood"
	blooding_name = "Solo Youngblood (One member)"
	mob_max = 1
	mob_min = 1
	time_required_for_job = 5 HOURS
	youngblood_time = 0 HOURS
	youngblood_time_required_for_job = 0 HOURS

/datum/emergency_call/young_bloods/one_member/experienced //For if a pred wants to teach a more experienced youngblood but still one on one
	name = "Hunting Grounds - Solo Youngblood (Experienced)"
	blooding_name = "Solo Youngblood (One member - Experienced)"
	youngblood_time = 7 HOURS
	youngblood_time_required_for_job = 5 HOURS

/datum/emergency_call/young_bloods/three_members
	name = "Hunting Grounds - Inexperienced Youngblood Party" //For completly new youngblood players
	blooding_name = "Inexperienced Youngblood Party (Three members)"
	time_required_for_job = 5 HOURS
	youngblood_time = 2 HOURS
	youngblood_time_required_for_job = 0 HOURS
	mob_max = 3
	mob_min = 2

/datum/emergency_call/young_bloods/three_members/intermediate
	name = "Hunting Grounds - Intermediate Youngblood Party" //For players who have played a few rounds as youngblood
	blooding_name = "Intermediate Youngblood Party (Three members)"
	time_required_for_job = 10 HOURS
	youngblood_time = 5 HOURS
	youngblood_time_required_for_job = 2 HOURS

/datum/emergency_call/young_bloods/three_members/experienced //Regular youngblood party
	name = "Hunting Grounds - Experienced Youngblood Party"
	blooding_name = "Experienced Youngblood Party (Three members)"
	time_required_for_job = 20 HOURS
	youngblood_time = 10 HOURS
	youngblood_time_required_for_job = 3 HOURS

/datum/emergency_call/young_bloods/three_members/lowpop //draws from every skill level to fill the party
	name = "Hunting Grounds - Mixed experience Youngblood Party"
	blooding_name = "Mixed experience Youngblood Party (Three members)"
	youngblood_time = 10 HOURS
	youngblood_time_required_for_job = 0 HOURS

/datum/emergency_call/young_bloods/six_members //Larger group for highpop rounds
	name = "Hunting Grounds - Youngblood Hunting Pack (Six members)"
	blooding_name = "Youngblood Hunting Pack (Six members)"
	mob_max = 6
	mob_min = 4
	time_required_for_job = 5 HOURS
	youngblood_time = 10 HOURS
	youngblood_time_required_for_job = 0 HOURS
