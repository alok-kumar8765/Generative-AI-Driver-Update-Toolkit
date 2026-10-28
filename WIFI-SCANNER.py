import subprocess
import re
import sys


def scan_wifi_networks():
    """Scan nearby Wi-Fi networks on Windows using netsh."""

    if sys.platform != "win32":
        raise OSError("This script requires Windows and the netsh utility.")

    command = [
        "netsh",
        "wlan",
        "show",
        "networks",
        "mode=bssid",
    ]

    result = subprocess.run(
        command,
        capture_output=True,
        text=True,
        errors="replace",
        check=False,
        timeout=15,
    )

    if result.returncode != 0:
        error = result.stderr.strip() or result.stdout.strip()
        raise RuntimeError(
            f"Wi-Fi scan failed (exit code {result.returncode}): "
            f"{error or 'No error details provided'}"
        )

    networks = []
    network_defaults = None
    current_ap = None

    def save_ap():
        nonlocal current_ap

        if current_ap is not None:
            networks.append(current_ap)
            current_ap = None

    def save_network_without_bssid():
        nonlocal network_defaults

        if network_defaults is not None:
            networks.append(network_defaults.copy())
            network_defaults = None

    for raw_line in result.stdout.splitlines():
        line = raw_line.strip()

        # Start of a new SSID section.
        match = re.match(r"^SSID\s+\d+\s*:\s*(.*)$", line, re.I)
        if match:
            save_ap()
            save_network_without_bssid()

            network_defaults = {
                "ssid": match.group(1).strip() or "<Hidden SSID>",
                "signal": "N/A",
                "channel": "N/A",
                "security": "N/A",
                "bssid": "N/A",
            }
            continue

        if network_defaults is None:
            continue

        # Start of a new access point under this SSID.
        match = re.match(r"^BSSID\s+\d+\s*:\s*(.*)$", line, re.I)
        if match:
            save_ap()
            current_ap = network_defaults.copy()
            current_ap["bssid"] = match.group(1).strip() or "N/A"
            continue

        # Parse key/value fields without truncating values at colons.
        key, separator, value = line.partition(":")
        if not separator:
            continue

        key = key.strip().casefold()
        value = value.strip()

        target = current_ap if current_ap is not None else network_defaults

        if key == "signal":
            target["signal"] = value or "N/A"
        elif key == "channel":
            target["channel"] = value or "N/A"
        elif key == "authentication":
            target["security"] = value or "N/A"

    save_ap()
    save_network_without_bssid()

    return networks


def main():
    try:
        networks = scan_wifi_networks()
    except (OSError, RuntimeError, subprocess.TimeoutExpired) as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1

    print("\nNearby Wi-Fi Networks\n")

    if not networks:
        print("No Wi-Fi networks found.")
        return 0

    for index, net in enumerate(networks, start=1):
        print(f"{index}. {net['ssid']}")
        print(f"   BSSID    : {net['bssid']}")
        print(f"   Signal   : {net['signal']}")
        print(f"   Channel  : {net['channel']}")
        print(f"   Security : {net['security']}")
        print()

    print(f"Total access points: {len(networks)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())