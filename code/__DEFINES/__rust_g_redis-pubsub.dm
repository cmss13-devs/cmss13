#define RUSTG_REDIS_ERROR_CHANNEL "RUSTG_REDIS_ERROR_CHANNEL"

#define rustg_redis_connect(addr) RUSTG_CALL(RUST_G, "redis_connect")(addr)
/proc/rustg_redis_disconnect() return RUSTG_CALL(RUST_G, "redis_disconnect")()
#define rustg_redis_subscribe(channel) RUSTG_CALL(RUST_G, "redis_subscribe")(channel)
/proc/rustg_redis_get_messages() return RUSTG_CALL(RUST_G, "redis_get_messages")()
#define rustg_redis_publish(channel, message) RUSTG_CALL(RUST_G, "redis_publish")(channel, message)
