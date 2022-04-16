import glob
import re

var_array = []
for file in glob.glob("./**/*.dm", recursive=True):
    # I want to record all variable instances into an array called var_array
    with open(file, "r", encoding="utf-8") as f:
        for line in f.readlines():
            search = re.search(r"^/*var/(global/|)list/([a-zA-Z_]+/)+([a-zA-Z_]+)", line)
            if search is None:
                continue
            var_array.append(search.group(3))




for file in glob.glob("./**/*.dm", recursive=True):
    # I want to record all variable instances into an array called var_array

    with open(file, "r", encoding="utf-8") as f:
        info = f.read()
        for data in var_array:
            info = re.sub(r"^"+re.escape(data)+r"$", "GLOB."+data, info)

