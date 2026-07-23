#!/usr/bin/env python3
import csv
import sys

total_path, self_path, out_path = sys.argv[1], sys.argv[2], sys.argv[3]

with open(total_path, newline="") as f:
    total_rows = {r["name"]: r for r in csv.DictReader(f)}

with open(self_path, newline="") as f:
    self_rows = {r["name"]: r for r in csv.DictReader(f)}

fieldnames = [
    "name", "src_file", "src_line",
    "total_ns", "total_perc", "counts", "total_mean_ns", "total_min_ns", "total_max_ns", "total_std_ns",
    "self_ns", "self_perc", "self_mean_ns", "self_min_ns", "self_max_ns", "self_std_ns",
]

with open(out_path, "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    for name, t in total_rows.items():
        s = self_rows.get(name, {})
        writer.writerow({
            "name": name,
            "src_file": t["src_file"],
            "src_line": t["src_line"],
            "total_ns": t["total_ns"],
            "total_perc": t["total_perc"],
            "counts": t["counts"],
            "total_mean_ns": t["mean_ns"],
            "total_min_ns": t["min_ns"],
            "total_max_ns": t["max_ns"],
            "total_std_ns": t["std_ns"],
            "self_ns": s.get("total_ns", ""),
            "self_perc": s.get("total_perc", ""),
            "self_mean_ns": s.get("mean_ns", ""),
            "self_min_ns": s.get("min_ns", ""),
            "self_max_ns": s.get("max_ns", ""),
            "self_std_ns": s.get("std_ns", ""),
        })
