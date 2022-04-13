# Rundeck Key Pair Remediation Options
**April 2022 - CONFIDENTIAL PAGERDUTY CUSTOMER DETAILS**
Content should not be shared directly with customers.  Use messages and content from this document to answer specific customer questions.

## Overview

PagerDuty has multiple options available to discover and remediate the recently announced key pair issue.

## Discovery  

To determine whether your systems are affected it is necessary to scan endpoints in your environment please use or adapt one of the options below.  The key details are included in the scripts if another method is chosen to scan for them.

### Automation Job

`Test_for_exposed_SSH_keys_xml.xml`
Rundeck has developed a job that can be run against nodes to check for the existence of the vulnerable keys on configured nodes.  The script will run on each node and if a vulnerable key exists on any node the job will fail.  The Log Output will show which nodes failed and include notes where the key was found.

### BASH Script

`rundeck_keys.sh`
When run on a Linux host the bash script will scan all `authorized_keys` files on that node to check for the vulnerable keys and report the results back.
Remediation

If the key is found on any node it should be removed and re-issued immediately.

##Prevention

###Key Revocation Lists

Setting up Key Revocation can help prevent access using the affected keys.  This step is optional but would help protect from authentication with the affected keys in the future.
[https://docs.rundeck.com/docs/learning/howto/revoke-ssh-keys.html](https://docs.rundeck.com/docs/learning/howto/revoke-ssh-keys.html)
