/obj/structure/machinery/cm_vending/clothing/medical_crew
	name = "\improper Broken ColMarTech Medical Equipment Rack"
	desc = "An automated equipment vendor for the Medical Department. Sadly, it doesn't work."
	req_access = list(777)//ACCESS_MARINE_MEDBAY
	vendor_role = list(JOB_DOCTOR,JOB_NURSE,JOB_RESEARCHER,JOB_CMO)
	icon_state = "dress"

/*
/obj/structure/machinery/cm_vending/clothing/medical_crew/get_listed_products(mob/user)
	if(user.job == JOB_NURSE)
		return GLOB.cm_vending_clothing_nurse
	else if(user.job == JOB_RESEARCHER)
		return GLOB.cm_vending_clothing_researcher
	else if(user.job == JOB_CMO)
		return GLOB.cm_vending_clothing_cmo
	return ..()
*/
