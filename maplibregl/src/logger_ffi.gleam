@external(javascript, "./javascript_logger_ffi.mjs", "debug")
pub fn debug(msg: String) -> Nil

@external(javascript, "./javascript_logger_ffi.mjs", "error")
pub fn error(msg: String) -> Nil

@external(javascript, "./javascript_logger_ffi.mjs", "info")
pub fn info(msg: String) -> Nil

@external(javascript, "./javascript_logger_ffi.mjs", "trace")
pub fn trace(msg: String) -> Nil

@external(javascript, "./javascript_logger_ffi.mjs", "warn")
pub fn warn(msg: String) -> Nil
