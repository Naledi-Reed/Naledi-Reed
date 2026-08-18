# SOC Lab Roadmap

This is the practical security track of my portfolio.

## Goal

Build a repeatable home security lab that lets me practise:

- Security monitoring
- Windows event analysis
- Linux administration and logging
- Network traffic analysis
- Vulnerability assessment
- Incident response
- Threat detection
- Security automation
- Cloud security foundations

## Lab stages

### Stage 1 — Isolated environment

- Kali Linux as the analysis/attacker workstation
- Metasploitable 2 and 3 as intentionally vulnerable targets
- Windows 11 as a clean endpoint baseline
- Ubuntu as a Linux server/workstation
- Windows 7 retained only for controlled legacy-security experiments

### Stage 2 — Visibility

- Create a safe host-only / isolated lab network
- Record IP addresses and host roles
- Enable useful Windows and Linux logging
- Capture network traffic with Wireshark
- Establish a clean baseline before testing attacks

### Stage 3 — Detection

Build controlled scenarios such as:

- Failed-login bursts
- Password spraying simulations
- Suspicious PowerShell activity
- Port scanning
- Web-service enumeration
- Malware-safe test indicators
- Privilege or account changes

For every scenario, document:

1. What was simulated
2. What evidence appeared
3. How it was detected
4. How it was investigated
5. How it was contained
6. What detection could be improved

### Stage 4 — SOC workflow

Turn investigations into professional-style case notes:

`Alert → Triage → Evidence → Investigation → Containment → Recovery → Lessons Learned`

### Stage 5 — Automation

Use PowerShell/Python and GitHub Actions for repeatable documentation, evidence checks and detection-content validation.

## Safety rules

- Keep intentionally vulnerable VMs isolated from the normal home network.
- Never test against systems you do not own or have explicit permission to assess.
- Do not publish credentials, private IP details, tokens or sensitive screenshots.
- Prefer snapshots before destructive experiments.

## Portfolio outcome

The end result should show **evidence of security operations**, not just a list of security tools I have installed.
