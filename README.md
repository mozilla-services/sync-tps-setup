# TPS automation

TPS is Testing and Performance for (Firefox) Sync.  It's a test suite that lives in `mozilla-central`.  Documentation for TPS is on MDN at https://developer.mozilla.org/en-US/docs/Mozilla/Projects/TPS_Tests.

This automation is designed to run TPS from a Docker container and includes a Jenkinsfile to enable execution from a Jenkins instance.
It is used by the Firefox Test Engineering Team Jenkins CI system and executed once daily via cron.

PLEASE NOTE:
Config files for the STAGE and PROD environments are stored as credentials in the Firefox Test Jenkins and 
backed up to our team LastPass account. 

For more info, contact rpapa or kthiessen

# Docker 

## Summary

The Sync TPS tests will be downloaded from mozilla-central and executed from within a Docker container.

## Building Docker

```sh
docker build -t firefoxtesteng/sync-tps-setup .
```

## Running Docker 

**STAGE**

```sh
TEST_CONFIG=`cat stage-config.json` 
docker run -e "TEST_ENV=stage" -e "TEST_CONFIG=${TEST_CONFIG}" firefoxtesteng/sync-tps-setup
```

or

**PROD**

```sh
TEST_CONFIG=`cat prod-config.json`
docker run -e "TEST_ENV=prod" -e "TEST_CONFIG=${TEST_CONFIG}" firefoxtesteng/sync-tps-setup
```

## Running Docker via Jenkins 

Jenkins execution is configured via the Jenkinsfile included in this repo.  You can specify all your job configurations options via this file.

A few things of Note:

**triggers**

To run this job on a cron schedule, set cron values here.

**environment**

You will need to create a few of the environment variables in this section. They begin with: "SYNC\_TPS\_"

**post**

Configure your email confirmations here

**changed**

Turn IRC notifications on / off here

## Firefox Test Engineering Jenkins

**Schedule**

* STAGE:  9 UTC
* STAGE with buffer:  10 UTC
* PROD:   6:30 UTC

