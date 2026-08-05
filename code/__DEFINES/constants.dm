/// Initialize a global constants datum that you can reference in code as needed
/// Datum acts as a namespace for constants
#define CONSTANT(name, constant_typepath) GLOBAL_REAL(name, constant_typepath) = new;
