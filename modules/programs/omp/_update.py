import json
from pathlib import Path
import re
import tempfile
from urllib.request import urlopen


def update(package, release):
    tag = release["tag_name"]
    if not re.fullmatch(r"v[0-9]+\.[0-9]+\.[0-9]+", tag):
        raise ValueError(f"Invalid OMP release tag: {tag!r}")
    assets = {asset["name"]: asset.get("digest") for asset in release["assets"]}
    original = package.read_text()

    def replace_hash(match):
        name = match[2]
        digest = assets.get(name)
        if not isinstance(digest, str) or not re.fullmatch(r"sha256:[0-9a-f]{64}", digest):
            raise ValueError(f"Missing or invalid SHA-256 digest for {name}")
        return f'{match[1]}{digest}";'

    updated, hashes = re.subn(
        r'(asset = "([^"]+)";\s+hash = ")[^"]+";', replace_hash, original
    )
    updated, versions = re.subn(r'version = "[^"]+";', f'version = "{tag[1:]}";', updated)
    if hashes != 4 or versions != 1:
        raise ValueError("Expected four OMP asset hashes and one version")
    if updated != original:
        with tempfile.NamedTemporaryFile(mode="w", dir=package.parent, delete=False) as temporary:
            temporary.write(updated)
        temporary_path = Path(temporary.name)
        try:
            temporary_path.chmod(package.stat().st_mode)
            temporary_path.replace(package)
        finally:
            temporary_path.unlink(missing_ok=True)
    return tag


if __name__ == "__main__":
    with urlopen("https://api.github.com/repos/can1357/oh-my-pi/releases/latest", timeout=30) as response:
        release = json.load(response)
    tag = update(Path(__file__).with_name("_package.nix"), release)
    print(f"OMP prebuilt pins: {tag}")
