# Toolbox

The place the repo maintainers will find the tools to keep this project
up and running.


## ad_hosts.sh

This tool is a good tool for anyone who would like to contribute to this
project as it will ask you all the right questions you should be able to
answer to make a good contribution.


## del_hosts.sh

This tool is **MAINLY** to be used by projects maintainers.

It is a strong and also very powerful tool that is able to delete any
domain from any lists within the `submit_here` folder.  
As it is using the `sed` command, this tool do understand REGEX and
therefor will requires you're full attention before publishing anything.

As a safety precaution this script do setup a new branch before deleting
anything.

This means you easily can delete a branch and do things over, before
pushing for merging


## GenerateHostsFile.sh

The `GenerateHostsFile.sh` is used for generating the the `hosts` file
in various formats.

1. 0.0.0.0/hosts
2. 127.0.0.1/hosts
3. Mobile_0_0_0_0/hosts
4. SafeSearch/hosts
5. strict/hosts


## domain-test.sh

This script is used to test all records from the `submit_here/file`
to determine which is active records and which are dead (sub.)domain.tld

This is a powerful tool to maintain the project as a valid and trustworthy
source of records.
