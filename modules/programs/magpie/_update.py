import argparse
import base64
import json
import os
import pathlib
import re
import stat
import sys
import tempfile
import urllib.request


ASSET = "magpie-cli-linux-amd64"
RELEASES = "https://github.com/yetone/magpie-releases/releases/download"


def update(pin_path: pathlib.Path, release: dict) -> bool:
    if not isinstance(release, dict):
        raise ValueError("The release metadata must be an object.")
    if release.get("draft") is not False or release.get("prerelease") is not False:
        raise ValueError("The release must be published and stable.")
    tag = release.get("tag_name")
    if not isinstance(tag, str) or not re.fullmatch(r"v[0-9]+[.][0-9]+[.][0-9]+", tag):
        raise ValueError("The release tag must have the form v1.2.3.")
    assets = release.get("assets")
    if not isinstance(assets, list):
        raise ValueError("The release must contain an asset list.")
    matches = [asset for asset in assets if isinstance(asset, dict) and asset.get("name") == ASSET]
    if len(matches) != 1 or matches[0].get("state") != "uploaded":
        raise ValueError("The release must contain exactly one uploaded terminal Linux amd64 asset.")
    asset = matches[0]
    if asset.get("browser_download_url") != f"{RELEASES}/{tag}/{ASSET}":
        raise ValueError("The asset URL does not match the pinned repository and release tag.")
    digest = asset.get("digest")
    if not isinstance(digest, str) or not re.fullmatch(r"sha256:[0-9a-fA-F]{64}", digest):
        raise ValueError("The asset must have a valid SHA-256 digest.")
    version = tag[1:]
    source_hash = "sha256-" + base64.b64encode(bytes.fromhex(digest[7:])).decode("ascii")

    pins = json.loads(pin_path.read_text(encoding="utf-8"))
    if not isinstance(pins, dict) or not isinstance(pins.get("version"), str):
        raise ValueError("The existing pin must contain a version.")
    if not re.fullmatch(r"[0-9]+[.][0-9]+[.][0-9]+", pins["version"]):
        raise ValueError("The existing pin version must have the form 1.2.3.")
    if not isinstance(pins.get("hash"), str):
        raise ValueError("The existing pin must contain a hash.")
    current = tuple(map(int, pins["version"].split(".")))
    candidate = tuple(map(int, version.split(".")))
    if candidate < current:
        raise ValueError("The release version is lower than the existing pin.")
    if candidate == current:
        if source_hash != pins["hash"]:
            raise ValueError("The hash changed for the same release version.")
        return False

    content = json.dumps({"version": version, "hash": source_hash}, indent=2) + "\n"
    mode = stat.S_IMODE(pin_path.stat().st_mode)
    fd, temporary = tempfile.mkstemp(prefix=f".{pin_path.name}.", dir=pin_path.parent)
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as output:
            os.fchmod(output.fileno(), mode)
            output.write(content)
        os.replace(temporary, pin_path)
    finally:
        pathlib.Path(temporary).unlink(missing_ok=True)
    return True


def main() -> int:
    parser = argparse.ArgumentParser(description="Update the pinned Magpie terminal release.")
    parser.add_argument("pin_path", type=pathlib.Path)
    args = parser.parse_args()
    request = urllib.request.Request(
        "https://api.github.com/repos/yetone/magpie-releases/releases/latest",
        headers={
            "Accept": "application/vnd.github+json",
            "User-Agent": "dotfiles-magpie-updater",
        },
    )
    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            release = json.load(response)
        changed = update(args.pin_path, release)
    except (OSError, ValueError) as error:
        print(f"Magpie update failed: {error}", file=sys.stderr)
        return 1
    print("Magpie source pins changed." if changed else "Magpie source pins already match.")
    print("Run dfs to install the pinned release.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
