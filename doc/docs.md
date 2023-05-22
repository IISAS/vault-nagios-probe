## About Secret store service

The full documentation of the Secret store service is available at https://vault.docs.fedcloud.eu/intro.html

## About the probe test for the service

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