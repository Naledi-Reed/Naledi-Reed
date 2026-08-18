# Hybrid IT Infrastructure Lab

**Module:** OPS261 — Operating Systems  
**Focus:** Windows Server 2019, Active Directory, Group Policy, security hardening

## What this project demonstrates

A simulated enterprise environment covering server installation, Active Directory, DNS, DHCP, Group Policy, user/group management, remote-access planning, file services and security hardening.

## Technical design

```text
                 Windows Server
                       │
              ┌────────┴────────┐
              │                 │
        Active Directory     DNS / DHCP
              │                 │
        ┌─────┴─────┐           │
        │           │           │
      Users       Groups     Name / IP services
        │
        ▼
  Group Policy / Access Control
        │
        ▼
  File Services / Remote Access
        │
        ▼
  Certificates + Security Hardening
```

## Evidence to add

- Network / domain diagram
- OU structure
- User and group structure
- Group Policy screenshots
- Security hardening evidence
- Certificate / CA evidence
- Practical implementation report

## Why this matters for security

This project is useful security evidence because it demonstrates the infrastructure layer underneath identity and access management. It gives context for later SOC work involving Windows authentication, Group Policy changes, privileged accounts, services and endpoint events.

## Portfolio rule

The public version contains technical summaries and sanitised evidence. Student identifiers, private correspondence and unredacted assessment material remain private.

## Key takeaway

The portfolio version emphasises **why each infrastructure decision was made**, not only the steps taken.
