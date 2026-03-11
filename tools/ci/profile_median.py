#!/usr/bin/env python3
import csv
import statistics

INPUTS = [f"startup-{i}.csv" for i in range(1, 6)]
OUTPUT = "startup-median.csv"

values = {}
rows = {}

for path in INPUTS:
    with open(path, newline="") as f:
        for row in csv.DictReader(f):
            name = row["name"]
            values.setdefault(name, []).append(float(row["total_ns"]))
            rows[name] = row

fieldnames = list(next(iter(rows.values())).keys())

with open(OUTPUT, "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    for name, vals in sorted(values.items()):
        row = dict(rows[name])
        row["total_ns"] = statistics.median(vals)
        writer.writerow(row)
