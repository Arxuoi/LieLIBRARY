from pathlib import Path
import re, sys

root = Path(__file__).parents[1]
files = list((root / "src").rglob("*.luau"))
assert files and (root / "src/init.luau").exists()
for path in files:
    text = path.read_text()
    assert "TODO" not in text, f"placeholder in {path}"
    for dotted in re.findall(r"require\(script(?:\.Parent)*(\.[A-Za-z0-9_\.]+)\)", text):
        module = dotted.split(".")[-1]
        assert any(item.stem == module for item in files), f"missing required module {module} from {path}"
print(f"checked {len(files)} modules")
