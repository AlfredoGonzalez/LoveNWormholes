#!/usr/bin/env python3
"""Thin wrapper around tools/balance_sim.gd (the logic lives in GDScript so it cannot drift from the game).

Usage: python3 tools/balance_sim.py [--runs 40] [--seed 1] [--stages 1-10] [--profiles normal,casual,optimized]
Environment: GODOT=/path/to/godot (default: godot). Exit code is the simulator's (1 = release gate failed).
"""
import os
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def main(argv):
    godot = os.environ.get("GODOT", "godot")
    cmd = [godot, "--headless", "--path", ROOT, "--script", "res://tools/balance_sim.gd", "--"] + argv
    proc = subprocess.run(cmd, cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    skip = ("Godot Engine v", "Initialize ", "Using ")
    for line in proc.stdout.splitlines():
        if not line.startswith(skip):
            print(line)
    return proc.returncode


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
