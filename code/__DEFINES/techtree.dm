// Resource
#define RESOURCE_HEALTH 200

#define RESOURCE_PER_SECOND AMOUNT_PER_TIME(1, 60 SECONDS) // 1 per 60 seconds

/// Controls the passive increase amount.
#define PASSIVE_INCREASE_AMOUNT RESOURCE_PER_SECOND // Increases by RESOURCE_PER_SECOND every second.

#define RESOURCE_PLASMA_PER_REPAIR 3 // Calculated like this: RESOURCE_PLASMA_PER_REPAIR * damage_to_repair
#define RESOURCE_FUEL_TO_REPAIR 5 // Calculated like this: RESOURCE_FUEL_TO_REPAIR * (damage_to_repair / max_health)

// Droppods
#define DROPPOD_DROPPED (1<<0)
#define DROPPOD_DROPPING (1<<1)
#define DROPPOD_OPEN (1<<2)
#define DROPPOD_STRIPPED (1<<3)
#define DROPPOD_RETURNING (1<<4)
