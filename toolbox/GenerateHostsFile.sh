#!/usr/bin/env bash

# Fail if exit != 0
set -e

# Run script in verbose
# set -x

printf "\n\tRunning GenerateHostFile.sh\n\n"

# *********************************************************************
# Define root dir for git, for working with relative dir to this repo #
# *********************************************************************

git_dir="$(git rev-parse --show-toplevel)"

# ******************
# Set Some Variables
# ******************

now=$(date '+%F %T %z (%Z)')
my_git_tag="build: $(date '+%j')" # When travis comes to play use `${TRAVIS_BUILD_NUMBER}`


# **********************************************************************
# Set some dirs
# **********************************************************************

sourcedir="${git_dir}/test_results"
outdir="${git_dir}/download_here" # no trailing / as it would make a double //

# *******************************************
# Set the sources (file names in submit_here)
# *******************************************

porn="$sourcedir/hosts.active.txt"
mobile="sourcedir/mobile.active.txt"
snuff="sourcedir/snuff.active.txt"
strict_list="sourcedir/strict_adult.active.txt"


# **********************************************************************
# Ordinary without safe search records
# **********************************************************************
hosts="${outdir}/0.0.0.0/hosts"
hosts127="${outdir}/127.0.0.1/hosts"
mobile="${outdir}/mobile/hosts"
strict="${outdir}/strict/0.0.0.0/hosts"
strict127="${outdir}/strict/127.0.0.1/hosts"

# **********************************************************************
# Safe Search enabled output
# **********************************************************************
ssoutdir="${outdir}/safesearch" # no trailing / as it would make a double //

sshosts="${ssoutdir}/0.0.0.0/hosts"
sshosts127="${ssoutdir}/127.0.0.1/hosts"
ssmobile="${ssoutdir}/mobile/hosts"
ssstrict="${ssoutdir}/strict/0.0.0.0/hosts"
ssstrict127="${ssoutdir}/strict/127.0.0.1/hosts"

# ****************
# End of variables
# ****************


# **************
# Script at work
# **************

# **********************************************************************
# Next ensure all output folders is there
# **********************************************************************
mkdir -p \
  "${outdir}/0.0.0.0" \
  "${outdir}/127.0.0.1" \
  "${outdir}/mobile" \
  "${outdir}/strict/" \
  "${ssoutdir}/0.0.0.0" \
  "${ssoutdir}/127.0.0.1" \
  "${ssoutdir}/mobile" \
  "${ssoutdir}/strict/"
  

# First let us clean up old data in output folders

find "${outdir}" -type f -delete

#bad_referrers=$(wc -l < "${rawlist}")

# **********************************************************************
# Print some stats
# **********************************************************************
#printf "\n\tRows in active list: $(wc -l < "${activelist}")\n"
#printf "\n\tRows of raw data: ${bad_referrers}\n"



# **********************************************************************
# Set templates path
# **********************************************************************
templpath="${git_dir}/toolbox/templates"

hostsTempl=${templpath}/hosts.template
mobileTempl=${templpath}/mobile.template

# **********************************************************************
# Safe Search is in sub-path
# **********************************************************************

# TODO Get templates from the master source at 
# https://gitlab.com/my-privacy-dns/matrix/matrix/tree/master/safesearch
# Template file for 0.0.0.0 and 127.0.0.1 are the same

sstemplpath="${templpath}/safesearch"

sshostsTempl="${sstemplpath}/safesearch.template" # same for mobile

# **********************************************************************
printf "\n\tUpdate our safe search templates\n"
# **********************************************************************
# Append this to the bottom of the Safesearch generated files

wget -qO "${sshostsTempl}" 'https://raw.githubusercontent.com/mypdns/matrix/master/safesearch/safesearch.hosts'




# ***********************************
# Print the header in all hosts files
# ***********************************


printf "# Last Updated: ${now} Build: ${my_git_tag}\n#" | tee -ai \
  "${hosts}" "${hosts127}" "${mobile}" "${strict}" "${sshosts}" \
    "${sshosts127}" "${ssmobile}" "${ssstrict}"


# *************************************
# Import templates into the hosts files
# *************************************

cat "${hostsTempl}" | tee -ai "${hosts}" "${hosts127}" "${mobile}" \
  "${strict}" "${sshosts}" "${sshosts127}" "${ssmobile}" "${ssstrict}"


# **********************************************************************
printf "\nGenerating hosts\n"
# **********************************************************************

while read DOMAINS

	printf ("0.0.0.0 %s",tolower($1)) "${DOMAINS}" | tee -ai "${hosts}" \
	  "${mobile}" "${strict}" "${sshosts}" "${ssmobile}" "${ssstrict}"

	printf ("127.0.0.1 %s",tolower($1)) "${DOMAINS}" | tee -ai "${hosts127}" \
	  "${sshosts127}"

done < "${porn}"


# **********************************************************************
printf "\nAdding snuff to hosts\n"
# **********************************************************************

while read SNUFF

	printf ("0.0.0.0 %s",tolower($1)) "${SNUFF}" | tee -ai "${hosts}" \
	  "${mobile}" "${strict}" "${sshosts}" "${ssmobile}" "${ssstrict}"

	printf ("127.0.0.1 %s",tolower($1)) "${SNUFF}" | tee -ai "${hosts127}" \
	  "${sshosts127}"

done < "${snuff}"

# **********************************************************************
printf "\nAppending the mobile to the mobile lists only\n"
# **********************************************************************

while read MOB

	printf ("0.0.0.0 %s",tolower($1)) "${MOB}" | tee -ai "${mobile}" \
	  "${ssmobile}"

done < "${mobile}"

# **********************************************************************
printf "\nGenerate strict\n"
# **********************************************************************

while read WEIRD

	printf ("0.0.0.0 %s",tolower($1)) "${WEIRD}" | tee -ai "${strict}" \
	  "${ssstrict}"

	printf ("127.0.0.1 %s",tolower($1)) "${WEIRD}" | tee -ai "${strict127}" \
	  "${ssstrict127}"

done < "${strict_list}"


# *******************************************
printf "\nAppending the SafeSeach template\n"
# *******************************************

cat "$sshostsTempl" | tee -ai "${sshosts}" "${sshosts127}" "${ssmobile}" \
  "${ssstrict}"

# *************************************************************
# Copy newly generated hosts file to old locations for backward
# compatibility
# *************************************************************


exit ${?}

# Copyright: https://www.mypdns.org/
# Content: https://www.mypdns.org/p/Spirillen/
# Source: https://github.com/Import-External-Sources/pornhosts
# License: https://www.mypdns.org/w/License
# License Comment: GNU AGPLv3, MODIFIED FOR NON COMMERCIAL USE
#
# License in short:
# You are free to copy and distribute this file for non-commercial uses,
# as long the original URL and attribution is included.
#
# Please forward any additions, corrections or comments by logging an
# issue at https://www.mypdns.org/maniphest/
