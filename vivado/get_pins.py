#!/usr/bin/env python3
import sys
import os
import json
import re

def get_pins_ecp5(part):
    part = part.upper()
    match = re.match(r"(LFE5U?M?-[0-9]+F)", part)
    if not match: return []
    
    base_part = match.group(1)
    db_path = "/usr/share/trellis/database/ECP5"
    if not os.path.exists(db_path):
        # Try apio path
        db_path = os.path.expanduser("~/.apio/packages/oss-cad-suite/share/trellis/database/ECP5")
    
    json_path = os.path.join(db_path, base_part, "iodb.json")
    if not os.path.exists(json_path):
        base_part_alt = base_part.replace("UM5G-", "-").replace("UM-", "-").replace("U-", "-")
        json_path = os.path.join(db_path, base_part_alt, "iodb.json")
        if not os.path.exists(json_path): return []

    package = "CABGA256"
    pkg_match = re.search(r"-([0-9])?([A-Z]+[0-9]+)", part)
    if pkg_match:
        raw_pkg = pkg_match.group(2)
        if raw_pkg.startswith("BG"): package = "CABGA" + raw_pkg[2:]
        elif raw_pkg.startswith("MG"): package = "CSFBGA" + raw_pkg[2:]
        else: package = raw_pkg

    try:
        with open(json_path, "r") as f:
            data = json.load(f)
        if "packages" in data and package in data["packages"]:
            return sorted(data["packages"][package].keys())
    except: pass
    return []

def get_pins_ice40(device, package):
    # device like hx1k, up5k
    # package like vq100, sg48
    size = re.search(r"(1|4|8)k|384|5k", device).group(0)
    db_path = os.path.expanduser(f"~/.apio/packages/oss-cad-suite/share/icebox/chipdb-{size}.txt")
    if not os.path.exists(db_path): return []
    
    pins = []
    with open(db_path, "r") as f:
        in_pins = False
        for line in f:
            if line.startswith(".pins"):
                in_pins = True
                continue
            if in_pins:
                if line.startswith("."): break
                parts = line.split()
                if len(parts) >= 3:
                    # line format: pin_name row col
                    # But we need package-specific pin names (e.g. 1, 2, A1, B2)
                    pass
    # Actually, icebox chipdb doesn't map to physical package pins easily without 'icebox_info' or similar
    # Let's try to use 'icebox_info' if available
    try:
        import subprocess
        # icebox_info -p <package> <chipdb>
        cmd = ["icebox_info", "-p", package, db_path]
        output = subprocess.check_output(cmd, stderr=subprocess.STDOUT).decode()
        for line in output.splitlines():
            # Extract pin names from output
            match = re.search(r"pin\s+([A-Z0-9]+)", line)
            if match: pins.append(match.group(1))
    except:
        # Generic fallback for common packages
        if package == "sg48":
            return [str(i) for i in range(1, 49)]
        elif package == "tq144":
            return [str(i) for i in range(1, 145)]
    
    return sorted(list(set(pins)))

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: get_pins.py <vendor> <part/device> [package]")
        sys.exit(1)
    
    vendor = sys.argv[1].lower()
    pins = []
    if vendor == "lattice" or vendor == "ecp5":
        pins = get_pins_ecp5(sys.argv[2])
    elif vendor == "ice40":
        pins = get_pins_ice40(sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else "")
    
    print(" ".join(pins))
