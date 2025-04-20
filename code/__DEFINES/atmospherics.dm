/// This is used in handle_temperature_damage() for humans, and in reagents that affect body temperature. Temperature damage is multiplied by this amount.
#define TEMPERATURE_DAMAGE_COEFFICIENT 1.5
/// This is the divisor which handles how much of the temperature difference between the current body temperature and 310.15K (optimal temperature) humans auto-regenerate each tick. The higher the number, the slower the recovery. This is applied each tick, so long as the mob is alive.
#define BODYTEMP_AUTORECOVERY_DIVISOR 20
/// Minimum amount of kelvin moved toward 310.15K per tick. So long as abs(310.15 - bodytemp) is more than 50.
#define BODYTEMP_AUTORECOVERY_MINIMUM 1
/// Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is lower than their body temperature. Make it lower to lose bodytemp faster.
#define BODYTEMP_COLD_DIVISOR 6
/// Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is higher than their body temperature. Make it lower to gain bodytemp faster.
#define BODYTEMP_HEAT_DIVISOR 6
/// The maximum number of degrees that your body can cool in 1 tick, when in a cold area.
#define BODYTEMP_COOLING_MAX -30
/// The maximum number of degrees that your body can heat up in 1 tick, when in a hot area.
#define BODYTEMP_HEATING_MAX 30
/// The limit the human body can take before it starts taking damage from heat.
#define BODYTEMP_HEAT_DAMAGE_LIMIT 373.15 // 100degC
/// The limit the human body can take before it starts taking damage from coldness.
#define BODYTEMP_COLD_DAMAGE_LIMIT 260.15 // -13degC
/// The limit the human body will reach in extremely cold liquids (required for cryo effects).
#define BODYTEMP_CRYO_LIQUID_THRESHOLD 210 // -63.15degC

#define ONE_ATMOSPHERE 101.325 //kPa

#define O2STANDARD 0.21

#define T0C 273.15 // 0degC
#define T20C 293.15 // 20degC
#define T37C 310.15 // 37degC - body temp
#define T90C 363.15 // 90degC
#define T120C 393.15 // 120degC
#define TCMB 2.7 // -270.3degC
#define ICE_COLONY_TEMPERATURE 223 //-50degC
#define SOROKYNE_TEMPERATURE 223 // Same as Ice for now
#define TROPICAL_TEMP 303.7 //27degC, 81degF

#define GAS_TYPE_AIR "air"
#define GAS_TYPE_OXYGEN "oxygen"
#define GAS_TYPE_NITROGEN "nitrogen"
#define GAS_TYPE_N2O "anesthetic"
#define GAS_TYPE_PHORON "phoron"
#define GAS_TYPE_CO2 "carbon dioxyde"

/// Used in /obj/structure/pipes/vents/proc/create_gas
#define VENT_GAS_SMOKE "Smoke"
#define VENT_GAS_CN20 "CN20 Nerve Gas"
#define VENT_GAS_CN20_XENO "CN20-X Nerve Gas"
