/datum/job/special/wey_yu // Abstract type (null title)
	supervisors = "Weyland-Yutani Corporate Office"
	selection_class = "job_cl"
	flags_startup_parameters = ROLE_CUSTOM_SPAWN
	gear_preset = /datum/equipment_preset/wy/trainee

/datum/job/special/wey_yu/corporate/trainee
	title = JOB_TRAINEE
	gear_preset = /datum/equipment_preset/wy/trainee

/datum/job/special/wey_yu/corporate/junior_exec
	title = JOB_JUNIOR_EXECUTIVE
	gear_preset = /datum/equipment_preset/wy/junior_exec

/datum/job/special/wey_yu/corporate/exec
	title = JOB_EXECUTIVE
	gear_preset = /datum/equipment_preset/wy/exec

/datum/job/special/wey_yu/corporate/senior_exec
	title = JOB_SENIOR_EXECUTIVE
	gear_preset = /datum/equipment_preset/wy/senior_exec

/datum/job/special/wey_yu/corporate/exec_spec
	title = JOB_EXECUTIVE_SPECIALIST
	gear_preset = /datum/equipment_preset/wy/exec_spec

/datum/job/special/wey_yu/corporate/exec_supr
	title = JOB_EXECUTIVE_SUPERVISOR
	gear_preset = /datum/equipment_preset/wy/exec_supervisor

/datum/job/special/wey_yu/corporate/assist_man
	title = JOB_ASSISTANT_MANAGER
	gear_preset = /datum/equipment_preset/wy/manager/assistant_manager

/datum/job/special/wey_yu/corporate/div_man
	title = JOB_DIVISION_MANAGER
	gear_preset = /datum/equipment_preset/wy/manager/division_manager
	supervisors = "Weyland-Yutani Directorate"

/datum/job/special/wey_yu/corporate/chief_exec
	title = JOB_CHIEF_EXECUTIVE
	gear_preset = /datum/equipment_preset/wy/manager/chief_executive
	supervisors = "Weyland-Yutani Directorate"

/datum/job/special/wey_yu/corporate/deputy_director
	title = JOB_DEPUTY_DIRECTOR
	gear_preset = /datum/equipment_preset/wy/manager/director/deputy
	supervisors = "Weyland-Yutani Directorate"

/datum/job/special/wey_yu/corporate/director
	title = JOB_DIRECTOR
	gear_preset = /datum/equipment_preset/wy/manager/director
	supervisors = "Weyland-Yutani Directorate"


// PMCS //
/datum/job/special/wey_yu/pmc // Abstract type (null title)
	supervisors = "Weyland-Yutani PMC Dispatch"

/datum/job/special/wey_yu/pmc/standard
	title = JOB_PMC_STANDARD
	gear_preset = /datum/equipment_preset/pmc/pmc_standard

/datum/job/special/wey_yu/pmc/medic
	title = JOB_PMC_MEDIC
	gear_preset = /datum/equipment_preset/pmc/pmc_medic

/datum/job/special/wey_yu/pmc/engineer
	title = JOB_PMC_ENGINEER
	gear_preset = /datum/equipment_preset/pmc/technician

/datum/job/special/wey_yu/pmc/gunner
	title = JOB_PMC_GUNNER
	gear_preset = /datum/equipment_preset/pmc/pmc_gunner

/datum/job/special/wey_yu/pmc/sniper
	title = JOB_PMC_SNIPER
	gear_preset = /datum/equipment_preset/pmc/pmc_sniper

/datum/job/special/wey_yu/pmc/leader
	title = JOB_PMC_LEADER
	gear_preset = /datum/equipment_preset/pmc/pmc_leader

/datum/job/special/wey_yu/pmc/investigator
	title = JOB_PMC_INVESTIGATOR
	gear_preset = /datum/equipment_preset/pmc/pmc_med_investigator

/datum/job/special/wey_yu/pmc/lead_invest
	title = JOB_PMC_LEAD_INVEST
	gear_preset = /datum/equipment_preset/pmc/pmc_lead_investigator

/datum/job/special/wey_yu/pmc/crowd_control
	title = JOB_PMC_CROWD_CONTROL
	gear_preset = /datum/equipment_preset/pmc/pmc_riot_control

/datum/job/special/wey_yu/pmc/detainer
	title = JOB_PMC_SECURITY
	gear_preset = /datum/equipment_preset/pmc/pmc_security

/datum/job/special/wey_yu/pmc/crewman
	title = JOB_PMC_CREWMAN
	gear_preset = /datum/equipment_preset/pmc/pmc_crewman

/datum/job/special/wey_yu/pmc/doctor
	title = JOB_PMC_DOCTOR
	gear_preset = /datum/equipment_preset/pmc/doctor

/datum/job/special/wey_yu/pmc/synth
	title = JOB_PMC_SYNTH
	gear_preset = /datum/equipment_preset/pmc/synth

/datum/job/special/wey_yu/pmc/director
	title = JOB_PMC_DIRECTOR
	gear_preset = /datum/equipment_preset/pmc/director

/datum/job/special/wey_yu/pmc/commando
	title = JOB_WY_COMMANDO_STANDARD
	gear_preset = /datum/equipment_preset/pmc/commando/standard

/datum/job/special/wey_yu/pmc/commando_leader
	title = JOB_WY_COMMANDO_LEADER
	gear_preset = /datum/equipment_preset/pmc/commando/leader

/datum/job/special/wey_yu/pmc/commando_gunner
	title = JOB_WY_COMMANDO_GUNNER
	gear_preset = /datum/equipment_preset/pmc/commando/gunner

/datum/job/special/wey_yu/pmc/commando_dogcatcher
	title = JOB_WY_COMMANDO_DOGCATHER
	gear_preset = /datum/equipment_preset/pmc/commando/dogcatcher

