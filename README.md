# Rundeck Key Pair Remediation Options

## Overview

Docker distributions for PagerDuty® Process Automation On Prem and Rundeck versions 4.0 and earlier contain a hard-coded SSH key pair generated at packaging time. In Docker installations, new projects have a default path pointing to the exposed key. If no new key pair was generated, and a user copied the public key to the `authorized_keys` files on a remote host, anyone with the exposed private key would have access to the host with the same privileges as the PagerDuty Process Automation On Prem user.

## Discovery  

To determine whether your systems are affected it is necessary to scan endpoints in your environment. Please use or adapt one of the options below. The key details are included in the scripts and the [GitHub Security Advisory](https://github.com/rundeck/rundeck/security/advisories/GHSA-qxjx-xr2m-hgqx) if another method is chosen to scan for them.

### Job Definitions

`Test_for_exposed_SSH_keys_xml.xml`
This is a Rundeck/Process Automation job that can be run against nodes to check for the existence of the vulnerable keys on configured nodes. The script will run on each node and if a vulnerable key exists on any node the job will fail. The Log Output will show which nodes failed and include notes where the key was found.

`Identify_exposed_SSH_keys_nodes.xml`
This is a Rundeck/Process Automation job that can be run against nodes to check for the existence of the vulnerable keys on configured nodes. The script will run on each node and if a vulnerable key exists log it to the output. The Log Output will show which nodes failed and include notes where the key was found with summary information in the Result Data output.
> Note: This job is only supported on product versions 4.0+

`Identify_exposed_SSH_keys_nodes_(3.x).xml`
This is the same as the previous job without the Result Data output feature. It should be compatible with supported Enterprise and Community product versions (3.4.0+)

### BASH Script

`rundeck_keys.sh`
When run on a Linux host the bash script will scan all `authorized_keys` files on that node to check for the vulnerable keys and report the results back.


## Remediation

If the key is found on any node it should be removed and a new one issued immediately.

## Prevention

### Key Revocation Lists

Setting up Key Revocation can help prevent access using the affected keys.  This step is optional but would help protect from authentication with the affected keys in the future.
[https://docs.rundeck.com/docs/learning/howto/revoke-ssh-keys.html](https://docs.rundeck.com/docs/learning/howto/revoke-ssh-keys.html)
