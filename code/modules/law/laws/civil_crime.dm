/datum/law/civilian_law/terror_association
	name = "Terror Association"
	desc = "Being a member of, or providing aid to a member of, a terrorist organisation."
	brig_time = PERMABRIG_SENTENCE
	conditions = "Not applicable if the defendant has engaged in terror attacks. Not applicable for execution on its own."

/datum/law/civilian_law/terrorism
	name = "Terrorism"
	desc = "Conducting terror attacks against the United Americas or its allies."
	brig_time = PERMABRIG_SENTENCE
	conditions = "Not applicable if the defendant has not engaged in terror attacks."

/datum/law/civilian_law/minor_civil_insubordination
	name = "Minor Civil Insubordination"
	desc = "Failing to follow a lawful order from a member of the department (if any) to which you have been assigned. Additionally applicable for being disrespectful to the Commander or Duty Officer."
	brig_time = 5
	conditions = "Only Applicable to Non-USCM personnel."

/datum/law/civilian_law/major_civil_insubordination
	name = "Major Civil Insubordination"
	desc = "Failing to follow a lawful order from the Commander or Duty Officer (or assigned department head, if any) during an active Military Operation."
	brig_time = 10
	conditions = "Only Applicable to Non-USCM personnel."

/datum/law/civilian_law/black_marketeering
	name = "Blackmarketeering"
	desc = "Illegally procuring or selling restricted products, excluding firearms or explosives."
	brig_time = 7.5
	conditions = "Enforced by Civil Authorities such as the CMB."
	special_punishment = "Confiscation of Contraband"

/datum/law/civilian_law/arms_dealing
	name = "Arms Dealing"
	desc = "Illegally procuring or selling firearms or explosives."
	brig_time = 15
	conditions = "Enforced by Civil Authorities such as the CMB."
	special_punishment = "Confiscation of Contraband"
