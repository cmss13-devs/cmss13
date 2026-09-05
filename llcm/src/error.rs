use std::{
    io,
    num::{ParseFloatError, ParseIntError},
    result,
    str::Utf8Error,
};
use thiserror::Error;

pub type Result<T> = result::Result<T, Error>;

#[derive(Error, Debug)]
pub enum Error {
    #[error("Illegal null character in string.")]
    Null,
    #[error("Invalid UTF-8 character at position {position}.")]
    Utf8 { source: Utf8Error, position: usize },
    #[error("Invalid or empty filename specified.")]
    InvalidFilename,
    #[error(transparent)]
    Io(#[from] io::Error),
    #[error("Invalid algorithm specified.")]
    InvalidAlgorithm,
    #[error(transparent)]
    ParseInt(#[from] ParseIntError),
    #[error(transparent)]
    ParseFloat(#[from] ParseFloatError),
    #[error(transparent)]
    Formatting(#[from] std::fmt::Error),
    #[error("Panic during function execution: {0}")]
    Panic(String),
}

impl From<Utf8Error> for Error {
    fn from(source: Utf8Error) -> Self {
        Self::Utf8 {
            source,
            position: source.valid_up_to(),
        }
    }
}

impl From<Error> for String {
    fn from(error: Error) -> Self {
        error.to_string()
    }
}

impl From<Error> for Vec<u8> {
    fn from(error: Error) -> Self {
        error.to_string().into_bytes()
    }
}
