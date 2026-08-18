from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]

required_files = [
    ROOT / "README.md",
    ROOT / "SOC-LAB-ROADMAP.md",
    ROOT / "PORTFOLIO-OPERATING-RULES.md",
]

required_project_readmes = [
    ROOT / "projects/cloud-native-student-qualifier/README.md",
    ROOT / "projects/windows-server-hybrid-infrastructure/README.md",
    ROOT / "projects/windows-powershell-admin-toolkit/README.md",
    ROOT / "projects/iot-human-detection-probe/README.md",
    ROOT / "projects/iot-aquasense/README.md",
    ROOT / "projects/database-sql-server/README.md",
    ROOT / "projects/information-networking/README.md",
]

# Deliberately conservative patterns: these are checks for obvious accidental
# credential commits, not a substitute for a full secret scanner.
secret_patterns = [
    re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----"),
    re.compile(r"AKIA[0-9A-Z]{16}"),
    re.compile(r"(?i)aws_secret_access_key\s*[:=]"),
    re.compile(r"(?i)(api[_-]?key|access[_-]?token|client[_-]?secret)\s*[:=]\s*['\"]?[A-Za-z0-9_\-]{12,}"),
]

errors = []

for path in required_files + required_project_readmes:
    if not path.exists() or path.stat().st_size == 0:
        errors.append(f"Missing or empty required file: {path.relative_to(ROOT)}")

for path in ROOT.rglob("*.md"):
    text = path.read_text(encoding="utf-8", errors="ignore")
    for pattern in secret_patterns:
        if pattern.search(text):
            errors.append(f"Possible secret pattern in {path.relative_to(ROOT)}: {pattern.pattern}")

readme = (ROOT / "README.md").read_text(encoding="utf-8")
for marker in ["Cybersecurity", "Security Operations", "home-lab", "certifications"]:
    if marker not in readme:
        errors.append(f"README is missing positioning marker: {marker}")

if errors:
    print("PORTFOLIO CHECK FAILED")
    for error in errors:
        print(f"- {error}")
    sys.exit(1)

print("PORTFOLIO CHECK PASSED")
print(f"Checked {len(required_files) + len(required_project_readmes)} required portfolio files.")
print("Scanned Markdown files for obvious credential patterns.")
