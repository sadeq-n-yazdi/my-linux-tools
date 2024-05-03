#!/bin/bash
# This tool is used to download latest firmware bin files  used by i915 from kernel project
# to use other folders, set the $FWFOLDER to other things
# it do not copy the firmware to the usr/lib/firmware/... folder, you have do this yourself
# use force as first option to delete current donwloded files and fetch them again

# https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain
ROOTURL=https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/
ROOTi915="${ROOTURL}/${FWURL:-"i915"}"
MYDIR=$(pwd)
TMPFLD="${MYDIR}/tmp"


[ -d "${TMPFLD}/" ] && rm -r "${TMPFLD}/"

if [ "$1" == "force" ] ; then
    [ -d "${MYDIR}/old" ] && rm -r ${MYDIR}/old/*.bin
    mkdir -p ${MYDIR}/old
    mv ${MYDIR}/*.bin ${MYDIR}/old
fi

mkdir -p "${MYDIR}/tmp"
cd "${TMPFLD}"
wget -nv -k -np -N "${ROOTi915}/"
cd "${MYDIR}"
[ -f "${MYDIR}/url.list" ] && mv "${MYDIR}/url.list" "${MYDIR}/url.list.old"
if [ ! -f "${TMPFLD}/index.html" ] ; then
    echo "Can not download index file"; 
    exit 1
fi    
cat "${TMPFLD}/index.html" \
| egrep -o 'https://[a-z0-9._/-]+\.bin'  \
| tee "${MYDIR}/url.list"
wget -N  -nv -p -nH -nd --timestamping -i "${MYDIR}/url.list"
[ -d ${MYDIR}/ ] && rm -r ${TMPFLD}/

