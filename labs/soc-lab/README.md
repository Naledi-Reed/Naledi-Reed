# SOC Home Lab

## Mission

Turn the VirtualBox environment into a controlled security-training environment where I can practise detection, investigation, response and documentation.

## Current virtual machines

| VM | Role | Lab purpose |
|---|---|---|
| Kali Linux | Analysis / attacker workstation | Reconnaissance, packet analysis, controlled attack simulation |
| Ubuntu | Linux host | Linux administration, services and logging |
| Metasploitable 2 | Vulnerable target | Controlled vulnerability and exploitation practice |
| Metasploitable 3 | Vulnerable target | Controlled exploitation and service investigation |
| Windows 7 | Legacy target | Controlled legacy-security experiments only |
| Windows 11 CyberLab | Clean endpoint baseline | Windows security monitoring and hardening |

## Phase 1: Build the lab safely

1. Keep vulnerable machines on an isolated Host-Only/Internal Network.
2. Give Kali access to the isolated lab network.
3. Add Ubuntu, Windows and vulnerable targets to the same isolated network as needed.
4. Keep the normal home network separate from intentionally vulnerable systems.
5. Take clean VM snapshots before experiments.
6. Record each VM's role and IP address in private lab notes.

## Phase 2: Establish a baseline

Before any attack simulation:

- Record running services.
- Record open ports.
- Record Windows security settings.
- Record Linux logging configuration.
- Capture a normal network traffic sample.
- Confirm the environment can be restored from snapshots.

## Phase 3: First investigations

Start with safe, observable scenarios:

- Failed authentication attempts
- Port scans against the vulnerable targets
- Web-service enumeration
- Suspicious PowerShell test activity on the Windows lab machine
- User/account changes
- Unusual outbound connections in the isolated network

For each scenario, document the evidence and investigation path.

## Phase 4: SOC-style case files

Each completed scenario should become:

```text
Alert
  ↓
Triage
  ↓
Evidence collection
  ↓
Investigation
  ↓
Containment
  ↓
Recovery
  ↓
Lessons learned
```

## Portfolio rule

The public repository should contain sanitized methodology, screenshots and lessons learned. It should never contain passwords, tokens, private IP information that exposes the home network, or uncontrolled exploit material.

## Next build

The first hands-on exercise will be **Network Discovery → Evidence Collection → Investigation → Report** using only the isolated lab network.
