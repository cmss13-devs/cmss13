import glob
import re

defineName = "GLOBAL_LIST_INIT_TYPED"

var_array = []
for file in glob.glob("./**/*.dm", recursive=True):
    # I want to record all variable instances into an array called var_array
    with open(file, "r", encoding="utf-8") as f:
        info = []
        for line in f.readlines():
            search = re.search(r"^/*var/(global/|)list/([a-zA-Z_/]+)/+([a-zA-Z_]+) = (.*)", line)
            if search is None:
                info.append(line)
                continue
            var_array.append(search.group(3))
            if(search.group(2) == "global"):
                info.append(line)
                continue
            info.append(defineName+"({}, /{}, {})".format(search.group(3), search.group(2), search.group(4)))

        with open(file, "w", encoding="utf-8") as f:
            f.write("".join(info))

for file in glob.glob("./**/*.dm", recursive=True):
    # I want to record all variable instances into an array called var_array
    with open(file, "r", encoding="utf-8") as f:
        info = f.read()
        for data in var_array:
            info = re.sub(r"\b"+re.escape(data)+r"\b", "GLOB."+data, info)
            info = info.replace(defineName+"(GLOB."+data, defineName+"("+data)
        with open(file, "w", encoding="utf-8") as f:
            f.write(info)
