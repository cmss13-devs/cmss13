#define REDIS_PUBLISH(channel, data...) SSredis.publish(channel, json_encode(list("source" = CONFIG_GET(string/instance_name), ##data)))
#define LOG_REDIS(type, contents) SSredis.publish("byond.log.[type]", "{\"source\": \"[GLOB.instance_name]\",\"text\":\"[contents]\"}")

#define CONFIG_DISABLED "config_disabled"

#define SHUTDOWN "Server Shutdown"
#define TGS_COMPILE "TGS Compile"

