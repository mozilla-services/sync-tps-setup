# TPS automation

TPS is Testing and Performance for (Firefox) Sync.  It's a test suite that lives in `mozilla-central`.  Documentation for TPS is on MDN at https://developer.mozilla.org/en-US/docs/Mozilla/Projects/TPS_Tests.

This piece of automation is designed to run TPS on a designated schedule from an Ubuntu 16.04 LTS node in AWS.

PLEASE NOTE:
Make sure you have the keys necessary to decrypt the \*.asc config files provided. 
How to do this will vary -- ask kthiessen

# Docker 

## Summary
The Sync TPS tests will be downloaded from mozilla-central and can be executed within a Docker container.

## Building Docker
```
docker build -t firefoxtesteng/sync-tps-setup .
```

## Running Docker 

**STAGE**

```
TEST_CONFIG=`cat stage-config.json` 
docker run -e "TEST_CONFIG=${TEST_CONFIG}" firefoxtesteng/sync-tps-setup
```

or

**PROD**

```
TEST_CONFIG=`cat prod-config.json`
docker run -e "TEST_CONFIG=${TEST_CONFIG}" firefoxtesteng/sync-tps-setup
```
