# How to expand SNO (UPI)

# Ignition file info

API VIP: 10.0.0.182

machine configure URIs:
- https://10.0.0.182:22623/config/master
- https://10.0.0.182:22623/config/worker


## Dump ignition files
```
# dump control ign
oc extract secrets/master-user-data -n openshift-machine-api --keys=userData --to=- > master.ign
# dump worker ign
oc extract secrets/worker-user-data -n openshift-machine-api --keys=userData --to=- > worker.ign
```

Example OpenShift Wrapped Ignition from secrets/worker-user-data

Note: The ignition generated at the https://10.0.0.182:22623/config/worker is v2 and is wrapped in an ignition v3 config below

```
{
  "ignition": {
    "config": {
      "merge": [
        {
          "source": "https://10.0.0.182:22623/config/worker"
        }
      ]
    },
    "security": {
      "tls": {
        "certificateAuthorities": [
          {
            "source": "data:text/plain;charset=utf-8;base64,< insert machine config cert here >"
          }
        ]
      }
    },
    "version": "3.2.0"
  }
}
```

## Create a custom ISO
```
coreos-installer iso ignition embed -i worker.ign -o worker.iso -f rhcos-custom.iso
coreos-installer iso ignition embed -i worker.ign -o worker.iso -f rhcos-custom.iso
```



## Certificates

Grab machine config cert
```
# openssl
echo | openssl s_client 10.0.0.182:22623

# oc
oc extract secret/machine-config-server-tls --keys=tls.crt --to=- -n openshift-machine-config-operator > machine-config-server.crt
```

Decode/Encode certs
```
# encode
cat machine-config-server.crt | base64 -w0

# decode
printf '<base64>' | base64 -d
```


# Links
- https://coreos.github.io/coreos-installer/getting-started
- CoreOS Installer
  - https://console.redhat.com/openshift/downloads#tool-coreos-installer
  - https://mirror.openshift.com/pub/openshift-v4/clients/coreos-installer/latest/coreos-installer_amd64
- https://rcarrata.com/openshift/ocp4_ipi_vmware_deep_dive
