/datum/law/capital_law
	severity = CAPITAL_CRIME

/datum/law/capital_law/attempted_murder
	name = "Attempted Murder"
	desc = "Attempting to murder a person but failing to do so. If the evidence shows that the arrested person was clearly trying to kill someone with ill intent but failed in the action itself."
	brig_time = PERMABRIG_SENTENCE

/datum/law/capital_law/desertion
	name = "Desertion"
	desc = "Refusing to carry out the duties essential to one’s post or abandoning post unauthorized, without intent to return. (Retreating from the planet when the FOB is breached is not Desertion, refusing to return when ordered is)."
	brig_time = PERMABRIG_SENTENCE

/datum/law/capital_law/insanity
	name = "Insanity"
	desc = "Acting in such a manner which makes the offender not sound clear of mind. The CMO or Synthetic can declare insanity on a Marine if the Marine is believed to not be of sound mind. The Marine once cleared to be of sound mind may be released from this particular charge."
	brig_time = PERMABRIG_SENTENCE

/datum/law/capital_law/jailbreak_escape
	name = "Jailbreak/Escape"
	desc = "To escape, assist in an escape, attempt escape, or be willfully and knowingly broken out."
	brig_time = PERMABRIG_SENTENCE

/datum/law/capital_law/murder
	name = "Murder or Unauthorized Execution"
	desc = "Killing someone with malicious intent. This includes Synthetic units. Executions are only authorized as outlined in the Execution Procedure."
	special_punishment = "Demotion"
	brig_time = PERMABRIG_SENTENCE

/datum/law/capital_law/sedition
	name = "Sedition"
	desc = "To engage in actions or refuse to follow orders as to overthrow or usurp the legitimate command structure."
	brig_time = PERMABRIG_SENTENCE