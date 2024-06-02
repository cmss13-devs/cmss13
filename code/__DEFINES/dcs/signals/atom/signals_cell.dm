/// (charge_amount)
#define COMSIG_CELL_USE_CHARGE "cell_use_charge"
	#define COMPONENT_CELL_NO_USE_CHARGE (1<<0)

/// (charge_amount)
#define COMSIG_CELL_ADD_CHARGE "cell_add_charge"

#define COMSIG_CELL_START_TICK_DRAIN "cell_start_tick_drain"

#define COMSIG_CELL_STOP_TICK_DRAIN "cell_stop_tick_drain"

/// (mob/living/user)
#define COMSIG_CELL_TRY_RECHARGING "cell_try_recharging"
	#define COMPONENT_CELL_NO_RECHARGE (1<<0)

#define COMSIG_CELL_OUT_OF_CHARGE "cell_out_of_charge"

/// (charge_amount)
#define COMSIG_CELL_CHECK_CHARGE "cell_check_charge"
	#define COMPONENT_CELL_CHARGE_INSUFFICIENT (1<<0)

#define COMSIG_CELL_TRY_INSERT_CELL "cell_try_insert_cell"
	#define COMPONENT_CANCEL_CELL_INSERT (1<<0)

/// (mob/living/user)
#define COMSIG_CELL_REMOVE_CELL "cell_remove_cell"
