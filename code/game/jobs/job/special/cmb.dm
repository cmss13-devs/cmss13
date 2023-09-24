// CMB Deputy
/datum/job/special/cmb/deputy
	title = JOB_CMB

// CMB Marshal
/datum/job/special/cmb/marshal
	title = JOB_CMB_TL

AddTimelock(/datum/job/special/cmb/marshal, list(
	JOB_SQUAD_LEADER = 5 HOURS,
))


// CMB Investigative Synthetic
/datum/job/special/cmb/synthetic
	title = JOB_CMB_SYN

// Interstellar Commerce Commission Corporate Liaison
/datum/job/special/cmb/icc_liaison
	title = JOB_CMB_ICC

AddTimelock(/datum/job/special/cmb/icc_liaison, list(
	JOB_CORPORATE_LIAISON = 1 HOURS,
))

// Interstellar Human Rights Observer
/datum/job/special/cmb/observer
	title = JOB_CMB_OBS
