#![forbid(unsafe_op_in_unsafe_fn)]
#![cfg_attr(
    all(windows, not(all(target_vendor = "pc", target_env = "msvc"))),
    allow(clippy::missing_const_for_thread_local)
)]

#[macro_use]
mod byond;
#[allow(dead_code)]
mod error;

#[cfg(all(not(target_pointer_width = "32"), not(feature = "allow_non_32bit")))]
compile_error!(
    "Compiling for non-32bit is not allowed without enabling the `allow_non_32bit` feature."
);
