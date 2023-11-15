#define REDIS_PUBLISH(channel, data...) SSredis.publish(channel, json_encode(list("source" = SSredis.instance_name, "round_id" = GLOB.round_id, ##data)))
#define LOG_REDIS(type, contents) if(SSredis.redis_logging) SSredis.publish("byond.log.[SSredis.instance_name].[type]", contents)

#define CONFIG_DISABLED "config_disabled"

#define SHUTDOWN "Server Shutdown"
#define TGS_COMPILE "TGS Compile"

