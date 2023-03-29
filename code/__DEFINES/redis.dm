#define REDIS_PUBLISH(_channel, data...) SSredis.publish(_channel, json_encode(list("source" = CONFIG_GET(string/instance_name), ##data)))

#define CONFIG_DISABLED "config_disabled"

#define SHUTDOWN "Server Shutdown"
#define TGS_COMPILE "TGS Compile"

