#!/usr/bin/env bash

# Fail if exit != 0
set -e

# Run script in verbose
 set -x

printf "\n\tRunning %s\n\n" "${0}"

# *********************************************************************
# Define root dir for git, for working with relative dir to this repo #
# *********************************************************************

git_dir="$(git rev-parse --show-toplevel)"

# ******************
# Set Some Variables
# ******************

now=$(date '+%F %T %z (%Z)')
my_git_tag="Build: $(date '+%j')" # When travis comes to play use `${TRAVIS_BUILD_NUMBER}`


# **********************************************************************
# Set some dirs
# **********************************************************************

sourcedir="${git_dir}/test_results"
outdir="${git_dir}/download_here" # no trailing / as it would make a double //

# *******************************************
# Set the INPUT (file names in submit_here)
# *******************************************

porn_active="${sourcedir}/hosts.active.txt"
mobile_active="${sourcedir}/mobile.active.txt"
snuff_active="${sourcedir}/snuff.active.txt"
strict_active="${sourcedir}/strict_adult.active.txt"


# **********************************************************************
# Ordinary OUTPUT without safe search records
# **********************************************************************
hosts="${outdir}/0.0.0.0/hosts"
hosts127="${outdir}/127.0.0.1/hosts"
mobile="${outdir}/mobile/hosts"
strict="${outdir}/strict/0.0.0.0/hosts"
strict127="${outdir}/strict/127.0.0.1/hosts"

# **********************************************************************
# Safe Search enabled OUTPUT
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
  "${outdir}/strict/0.0.0.0/" \
  "${outdir}/strict/127.0.0.1/" \
  "${ssoutdir}/0.0.0.0" \
  "${ssoutdir}/127.0.0.1" \
  "${ssoutdir}/mobile" \
  "${ssoutdir}/strict/0.0.0.0/" \
  "${ssoutdir}/strict/127.0.0.1/"


# First let us clean up old data in output folders

find "${outdir}" -type f -iname 'hosts' -delete
find "${ssoutdir}" -type f -iname 'hosts' -delete

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

wget -qO "${sshostsTempl}" \
  'https://raw.githubusercontent.com/mypdns/matrix/master/safesearch/safesearch.hosts'

touch "${hosts}" "${hosts127}" "${strict}" "${strict127}" "${sshosts}" \
  "${sshosts127}" "${ssstrict}" "${ssstrict127}" "${mobile}" "${ssmobile}"

# ***********************************
# Print the header in all hosts files
# ***********************************

printf "# Last Updated: ${now} ${my_git_tag}\n#" >> "${hosts}"
printf "# Last Updated: ${now} ${my_git_tag}\n#" >> "${hosts127}"
printf "# Last Updated: ${now} ${my_git_tag}\n#" >> "${mobile}"
printf "# Last Updated: ${now} ${my_git_tag}\n#" >> "${strict}"
printf "# Last Updated: ${now} ${my_git_tag}\n#" >> "${strict127}"
printf "# Last Updated: ${now} ${my_git_tag}\n#" >> "${sshosts}"
printf "# Last Updated: ${now} ${my_git_tag}\n#" >> "${sshosts127}"
printf "# Last Updated: ${now} ${my_git_tag}\n#" >> "${ssmobile}"
printf "# Last Updated: ${now} ${my_git_tag}\n#" >> "${ssstrict}"
printf "# Last Updated: ${now} ${my_git_tag}\n#" >> "${ssstrict127}"


# *************************************
# Import templates into the hosts files
# *************************************

cat "${hostsTempl}" | tee -ai >> "${hosts}" "${hosts127}" "${strict}" "${strict127}" "${sshosts}" "${sshosts127}" "${ssstrict}" "${ssstrict127}"

cat "${mobileTempl}" | tee -ai >> "${mobile}" "${ssmobile}"

# **********************************************************************
printf '\nAppending the MOBILE to the mobile lists only\n'
#
# We should keep these in the top of the hosts file, to minimize the I/O
# For traversing through the file over and over and over....
# See https://www.mypdns.org/w/dnshosts/ For more info.
# **********************************************************************
printf "\n# Mobile domains\n" >> "${mobile}"
printf "\n# Mobile domains\n" >> "${ssmobile}"

awk '{ printf("0.0.0.0 %s\n",tolower($1)) }' "${mobile_active}" >> "${mobile}"
awk '{ printf("0.0.0.0 %s\n",tolower($1)) }' "${mobile_active}" >> "${ssmobile}"

# **********************************************************************
printf "\nGenerating PORN hosts\n"
# **********************************************************************

printf "\n# Porn domains\n" >> "${hosts}"
printf "\n# Porn domains\n" >> "${hosts127}"
printf "\n# Porn domains\n" >> "${strict}"
printf "\n# Porn domains\n" >> "${strict127}"
printf "\n# Porn domains\n" >> "${sshosts}"
printf "\n# Porn domains\n" >> "${sshosts127}"
printf "\n# Porn domains\n" >> "${ssstrict}"
printf "\n# Porn domains\n" >> "${ssstrict127}"
printf "\n# Porn domains\n" >> "${mobile}"
printf "\n# Porn domains\n" >> "${ssmobile}"

# Standard 0.0.0.0
awk '{ printf("0.0.0.0 %s\n",tolower($1)) }' "${porn_active}" >> "${hosts}"
awk '{ printf("0.0.0.0 %s\n",tolower($1)) }' "${porn_active}" >> "${mobile}"
awk '{ printf("0.0.0.0 %s\n",tolower($1)) }' "${porn_active}" >> "${strict}"

# SafeSearch
awk '{ printf("0.0.0.0 %s\n",tolower($1)) }' "${porn_active}" >> "${sshosts}"
awk '{ printf("0.0.0.0 %s\n",tolower($1)) }' "${porn_active}" >> "${ssmobile}"
awk '{ printf("0.0.0.0 %s\n",tolower($1)) }' "${porn_active}" >> "${ssstrict}"

# Windows 127.0.0.1
awk '{ printf("127.0.0.1 %s\n",tolower($1)) }' "${porn_active}" >> "${hosts127}"
awk '{ printf("127.0.0.1 %s\n",tolower($1)) }' "${porn_active}" >> "${strict127}"
awk '{ printf("127.0.0.1 %s\n",tolower($1)) }' "${porn_active}" >> "${sshosts127}"
awk '{ printf("127.0.0.1 %s\n",tolower($1)) }' "${porn_active}" >> "${ssstrict127}"


# **********************************************************************
printf "\nAdding SNUFF to hosts\n"
# **********************************************************************

printf "\n# snuff domains\n" >> "${hosts}"
printf "\n# snuff domains\n" >> "${hosts127}"
printf "\n# snuff domains\n" >> "${strict}"
printf "\n# snuff domains\n" >> "${strict127}"
printf "\n# snuff domains\n" >> "${sshosts}"
printf "\n# snuff domains\n" >> "${sshosts127}"
printf "\n# snuff domains\n" >> "${ssstrict}"
printf "\n# snuff domains\n" >> "${ssstrict127}"
printf "\n# snuff domains\n" >> "${mobile}"
printf "\n# snuff domains\n" >> "${ssmobile}"

# Standard 0.0.0.0
awk '{ printf("0.0.0.0 %s\n",tolower($1)) }' "${snuff_active}" >> "${hosts}"
awk '{ printf("0.0.0.0 %s\n",tolower($1)) }' "${snuff_active}" >> "${mobile}"
awk '{ printf("0.0.0.0 %s\n",tolower($1)) }' "${snuff_active}" >> "${strict}"

# SafeSearch
awk '{ printf("0.0.0.0 %s\n",tolower($1)) }' "${snuff_active}" >> "${sshosts}"
awk '{ printf("0.0.0.0 %s\n",tolower($1)) }' "${snuff_active}" >> "${ssmobile}"
awk '{ printf("0.0.0.0 %s\n",tolower($1)) }' "${snuff_active}" >> "${ssstrict}"

# Windows 127.0.0.1
awk '{ printf("127.0.0.1 %s\n",tolower($1)) }' "${snuff_active}" >> "${hosts127}"
awk '{ printf("127.0.0.1 %s\n",tolower($1)) }' "${snuff_active}" >> "${strict127}"
awk '{ printf("127.0.0.1 %s\n",tolower($1)) }' "${snuff_active}" >> "${sshosts127}"
awk '{ printf("127.0.0.1 %s\n",tolower($1)) }' "${snuff_active}" >> "${ssstrict127}"


# **********************************************************************
printf "\nGenerate Grey Area\n"
# **********************************************************************
printf "\n# strict domains\n" >> "${strict}"
printf "\n# strict domains\n" >> "${strict127}"
printf "\n# strict domains\n" >> "${ssstrict}"
printf "\n# strict domains\n" >> "${sshosts127}"


awk '{ printf("0.0.0.0 %s\n",tolower($1)) }' "${strict_active}" >> "${strict}"
awk '{ printf("0.0.0.0 %s\n",tolower($1)) }' "${strict_active}" >> "${ssstrict}"

awk '{ printf("127.0.0.1 %s\n",tolower($1)) }' "${strict_active}" >> "${strict127}"
awk '{ printf("127.0.0.1 %s\n",tolower($1)) }' "${strict_active}" >> "${sshosts127}"

# *******************************************
printf "\nAppending the SafeSeach template\n"
# *******************************************

printf "\n\n" >> "${sshosts}"
printf "\n\n" >> "${sshosts127}"
printf "\n\n" >> "${ssmobile}"
printf "\n\n" >> "${ssstrict}"
printf "\n\n" >> "${ssstrict127}"

cat "$sshostsTempl" | tee -a >> "${sshosts}" "${sshosts127}" \
  "${ssmobile}" "${ssstrict}" "${ssstrict127}"

# *************************************************************
# Copy newly generated hosts file to old locations for backward
# compatibility
# *************************************************************

rm "${git_dir}/0.0.0.0/hosts" "${git_dir}/127.0.0.1/hosts"

cp "${hosts}" "${git_dir}/0.0.0.0/hosts"
cp "${hosts127}" "${git_dir}/127.0.0.1/hosts"

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
