# Docker CLI Guide

The original CNA261 project documented a Docker Hub workflow for the Student Qualification application.

## Pull

```bash
docker pull <dockerhub-user>/studentqualificationapp:latest
```

## Run

```bash
docker run -it <dockerhub-user>/studentqualificationapp:latest
```

## Inputs

- Test 1
- Test 2
- Assignment 1
- Project

The application calculates:

`30% Test 1 + 50% Test 2 + 10% Assignment 1 + 10% Project`

The supplied project evidence shows successful Docker build/publish/pull/run activity and both qualifying and non-qualifying test cases.

The Docker Hub username is parameterised here so the portfolio does not publish a third-party/group account as if it were this repository owner's account.
