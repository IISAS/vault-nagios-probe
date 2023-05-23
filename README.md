# Nagios probe script for Secret Store service

This is a script for monitoring status of Secret Store service. The script 
should detect various possible issues of the service during operation and 
give corresponding error or warning message. 

The full documentation of the Secret Store service and its probe test is available
at [here](https://vault.docs.fedcloud.eu/intro.html).

## Probe test for Secret Store service

The probe will perform test for Secret Store service via the 
[/sys/health](https://developer.hashicorp.com/vault/api-docs/system/health) endpoint 
of Vault. The probe will check the return codes from the requests and 
interpret them to Nagios OK/WARNING/CRITICAL/UNKNOWN  message accordingly.

If the Secret Store service is working, the probe will give one of the 
following messages and finish with exit code 0 (OK):

- OK - unsealed and standby. Return code 429 

- OK - unsealed and active. Return code 200

If the Secret Store service is unreachable, the probe will give one of the 
following messages and finish with exit code 2 (CRITICAL):

- CRITICAL - Server unreachable. Return code : $return_code from the request
(in the case service is down),

- CRITICAL - DNS error. Return code : $return_code (in the case of wrong 
server name or DNS error).

Other errors, if existed, are classified as UNKNOWN and will be classified 
later when more details of the probe tests are obtained and analyzed.

## Usage

The probe test needs only single parameter: the service URL defined on GOCDB. 
For compatibility with other probe test, the syntax is `-u URL`

```
$ ./nagios-plugin-secret-store.sh -h
Usage: nagios-plugin-secret-store.sh [-h] [-u URL] 

Nagios probe test for Secret Store service

Optional arguments:
        -h, --help, help                Display this help message and exit
        -u URL, --url URL               Vault endpoint (service URL in GOCDB)
        -t TIMEOUT, --timeout TIMEOUT   Global timeout for probe test
```

## Examples

- Making probe test of Secret Store node at IFCA:

```
$ ./nagios-plugin-secret-store.sh --url https://vault-ifca.services.fedcloud.eu:8200/
Checking https://vault-ifca.services.fedcloud.eu:8200/v1/sys/health. Status OK - unsealed and active. Return code 200
```

- Making probe test of the generic endpoint:

```
$ ./nagios-plugin-secret-store.sh -u https://secrets.egi.eu/
Checking https://secrets.egi.eu/v1/sys/health. Status OK - unsealed and standby. Return code 429
```