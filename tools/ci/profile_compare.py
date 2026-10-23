#!/usr/bin/env python3
import csv
import math
import os
import statistics

BASE_INPUTS = [f"base-{i}.csv" for i in range(1, 11)]
PR_INPUTS = [f"pr-{i}.csv"   for i in range(1, 11)]
OUTPUT = "pr-comment.md"
REPOSITORY = os.environ["GITHUB_REPOSITORY"]
RUN_ID = os.environ["GITHUB_RUN_ID"]

CHANGE_ABS_NS = 10_000_000
COMMENT_MARKER = "<!-- tracy-profile-comment -->"

# One-tailed paired t critical values for p=0.05, indexed by degrees of freedom
T_CRITICAL = {
    1: 6.314, 2: 2.920, 3: 2.353, 4: 2.132,
    5: 2.015, 6: 1.943, 7: 1.895, 8: 1.860,
    9: 1.833, 10: 1.812,
}


def read_csv(path):
    with open(path, newline="") as f:
        return {row["name"]: row for row in csv.DictReader(f)}


def paired_t_test(base_vals, pr_vals):
    diffs = [p - b for b, p in zip(base_vals, pr_vals)]
    n = len(diffs)
    if n < 2:
        return 0
    mean_diff = statistics.mean(diffs)
    sd_diff = statistics.stdev(diffs)
    if sd_diff == 0:
        return (1 if mean_diff > 0 else -1) if mean_diff != 0 else 0
    t_stat = mean_diff / (sd_diff / math.sqrt(n))
    df = min(n - 1, max(T_CRITICAL.keys()))
    threshold = T_CRITICAL.get(df, 1.645)
    if t_stat > threshold:
        return 1
    if t_stat < -threshold:
        return -1
    return 0


base_runs = [read_csv(p) for p in BASE_INPUTS]
pr_runs = [read_csv(p) for p in PR_INPUTS]

all_zones = set().union(*[r.keys() for r in pr_runs])

def median_col(runs, zone, col):
    vals = [float(r[zone][col]) for r in runs if zone in r and r[zone].get(col)]
    return statistics.median(vals) if vals else 0.0

base_total_sum = sum(median_col(base_runs, z, "total_ns") for z in all_zones)
pr_total_sum = sum(median_col(pr_runs,   z, "total_ns") for z in all_zones)
total_delta = pr_total_sum - base_total_sum
total_pct = (total_delta / base_total_sum) * 100 if base_total_sum else 0

regressions = []
speedups    = []
all_changes = []

for zone in all_zones:
    base_self_vals = [float(r[zone]["self_ns"]) for r in base_runs if zone in r and r[zone].get("self_ns")]
    pr_self_vals = [float(r[zone]["self_ns"]) for r in pr_runs   if zone in r and r[zone].get("self_ns")]

    if len(base_self_vals) < 2 or len(pr_self_vals) < 2:
        continue

    base_self = statistics.median(base_self_vals)
    pr_self = statistics.median(pr_self_vals)
    self_delta = pr_self - base_self
    self_pct = (self_delta / base_self) * 100 if base_self else 0

    base_total = median_col(base_runs, zone, "total_ns")
    pr_total = median_col(pr_runs,   zone, "total_ns")
    total_delta_zone = pr_total - base_total
    total_pct_zone = (total_delta_zone / base_total) * 100 if base_total else 0

    if abs(self_delta) < CHANGE_ABS_NS:
        continue

    row = (zone, base_total, pr_total, total_delta_zone, total_pct_zone, base_self, pr_self, self_delta, self_pct)
    all_changes.append(row)

    direction = paired_t_test(base_self_vals, pr_self_vals)
    if direction == 1:
        regressions.append(row)
    elif direction == -1:
        speedups.append(row)

regressions.sort(key=lambda r: r[7], reverse=True)
speedups.sort(key=lambda r: r[7])
all_changes.sort(key=lambda r: r[7], reverse=True)

artifact_url = f"https://github.com/{REPOSITORY}/actions/runs/{RUN_ID}"

def fmt_row(row):
    zone, bt, pt, td, tp, bs, ps, sd, sp = row
    return (
        f"| `{zone}` "
        f"| {bt/1e6:.1f}ms | {pt/1e6:.1f}ms | {td/1e6:+.1f}ms ({tp:+.1f}%) "
        f"| {bs/1e6:.1f}ms | {ps/1e6:.1f}ms | {sd/1e6:+.1f}ms ({sp:+.1f}%) |"
    )

TABLE_HEADER = [
    "| Zone | Base Total | PR Total | Total Δ | Base Self | PR Self | Self Δ |",
    "|------|-----------|---------|---------|----------|--------|-------|",
]

lines = [
    COMMENT_MARKER,
    "## Startup Profile",
    f"**Total startup delta: {total_delta/1e6:+.0f}ms ({total_pct:+.1f}% vs base)**\n",
]

if regressions:
    lines += [f"### Regressions (> {CHANGE_ABS_NS // 1_000_000}ms self time, p < 0.05)"] + TABLE_HEADER
    lines += [fmt_row(r) for r in regressions]
    lines.append("")

if speedups:
    lines += [f"### Speedups (> {CHANGE_ABS_NS // 1_000_000}ms self time, p < 0.05)"] + TABLE_HEADER
    lines += [fmt_row(r) for r in speedups]
    lines.append("")

if not regressions and not speedups:
    lines.append("No significant changes detected.\n")

if all_changes:
    top_changes = sorted(all_changes, key=lambda r: abs(r[7]), reverse=True)[:20]
    lines += [
        "<details>",
        f"<summary>All changes >{CHANGE_ABS_NS // 1_000_000}ms (top 20 by magnitude)</summary>\n",
    ] + TABLE_HEADER + [fmt_row(r) for r in top_changes] + ["", "</details>"]

lines.append(f"\n_Full profiles available in the [workflow artifact]({artifact_url})._")

with open(OUTPUT, "w") as f:
    f.write("\n".join(lines) + "\n")
