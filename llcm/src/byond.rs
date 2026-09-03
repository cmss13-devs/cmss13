use std::{
    backtrace::Backtrace,
    borrow::Cow,
    cell::RefCell,
    ffi::{CStr, CString},
    fs::OpenOptions,
    io::Write,
    os::raw::{c_char, c_int},
    slice,
    sync::Once,
};

static SET_HOOK: Once = Once::new();
static EMPTY_STRING: c_char = 0;
thread_local! {
    static RETURN_STRING: RefCell<CString> = RefCell::new(CString::default());
}

pub unsafe fn parse_args<'a>(argc: c_int, argv: *const *const c_char) -> Vec<Cow<'a, str>> {
    if argc == 0 || argv.is_null() {
        return Vec::new();
    }
    unsafe {
        slice::from_raw_parts(argv, argc as usize)
            .iter()
            .map(|ptr| CStr::from_ptr(*ptr))
            .map(|cstr| cstr.to_string_lossy())
            .collect()
    }
}

pub fn byond_return(value: Option<Vec<u8>>) -> *const c_char {
    match value {
        None => &EMPTY_STRING,
        Some(vec) if vec.is_empty() => &EMPTY_STRING,
        Some(vec) => RETURN_STRING.with(|cell| {
            // Panicking over an FFI boundary is bad form, so if a NUL ends up
            // in the result, just truncate.
            let cstring = match CString::new(vec) {
                Ok(s) => s,
                Err(e) => {
                    let (pos, mut vec) = (e.nul_position(), e.into_vec());
                    vec.truncate(pos);
                    CString::new(vec).unwrap_or_default()
                }
            };
            cell.replace(cstring);
            cell.borrow().as_ptr()
        }),
    }
}

#[macro_export]
macro_rules! byond_fn {
    (fn $name:ident() $body:block) => {
        #[unsafe(no_mangle)]
        #[allow(clippy::missing_safety_doc)]
        pub unsafe extern "C" fn $name(
            _argc: ::std::os::raw::c_int, _argv: *const *const ::std::os::raw::c_char
        ) -> *const ::std::os::raw::c_char {
            $crate::byond::set_panic_hook();
            let closure = || ($body);
            $crate::byond::byond_return(closure().map(From::from))
        }
    };

    (fn $name:ident($($arg:ident),* $(, ...$rest:ident)?) $body:block) => {
        #[unsafe(no_mangle)]
        #[allow(clippy::missing_safety_doc)]
        pub unsafe extern "C" fn $name(
            _argc: ::std::os::raw::c_int, _argv: *const *const ::std::os::raw::c_char
        ) -> *const ::std::os::raw::c_char {
            let __args = unsafe { $crate::byond::parse_args(_argc, _argv) };

            let mut __argn = 0;
            $(
                let $arg: &str = __args.get(__argn).map_or("", |cow| &*cow);
                __argn += 1;
            )*
            $(
                let $rest = __args.get(__argn..).unwrap_or(&[]);
            )?

            let closure = || ($body);
            $crate::byond::byond_return(closure().map(From::from))
        }
    };
}

// Easy version checker. It's in this file so it is always included
byond_fn!(
    fn get_version() {
        Some(env!("CARGO_PKG_VERSION"))
    }
);

/// Print any panics before exiting.
pub fn set_panic_hook() {
    SET_HOOK.call_once(|| {
        let default_panic_handler = std::panic::take_hook();
        std::panic::set_hook(Box::new(move |panic_info| {
            default_panic_handler(panic_info);
            let mut file = match OpenOptions::new()
                .append(true)
                .create(true)
                .open("llcm-panic.log")
            {
                Ok(file) => file,
                Err(res) => {
                    eprintln!("panic_hook: Cannot open file: {res:?}");
                    return;
                }
            };

            let payload = match panic_info
                .payload()
                .downcast_ref::<&'static str>()
                .map(|payload| payload.to_string())
                .or_else(|| panic_info.payload().downcast_ref::<String>().cloned())
            {
                Some(pl) => pl,
                None => {
                    eprintln!("panic_hook: Failed to extract panic payload");
                    return;
                }
            };

            match file.write_all(payload.as_bytes()) {
                Ok(_) => {}
                Err(err) => {
                    eprintln!("panic_hook: Failed to write error payload: {err:?}");
                    return;
                }
            };

            match file.write_all(Backtrace::capture().to_string().as_bytes()) {
                Ok(_) => {}
                Err(err) => {
                    eprintln!("panic_hook: Failed to extract backtrace: {err:?}");
                }
            };
        }))
    });
}
