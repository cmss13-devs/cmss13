/datum/law/optional_law
	severity = OPTIONAL_CRIME

/datum/law/optional_law/minor_unruly
	name = "Minor Disorderly Conduct in Confinement"
	desc = "To cause disruption in a minor manner while in the Brig and under arrest. Disruption is considered breaking a Minor Law. This can be added on to any charge."
	brig_time = 7.5
/datum/law/optional_law/aiding
	name = "Aiding and Abetting"
	desc = "Assisting others in committing a crime, directly or indirectly, or encouraging them to commit one."
	brig_time = 10
	special_punishment = "Same as accused"

/datum/law/optional_law/resisting
	name = "Resisting Arrest"
	desc = "To resist a lawful arrest or search by a Military Police officer."
	brig_time = 10

/datum/law/optional_law/major_unruly
	name = "Major Disorderly Conduct in Confinement"
	desc = "To cause disruption in a major manner while in the Brig and under arrest. Disruption is considered breaking a Major Law. This can be added on to any charge."
	brig_time = 15
