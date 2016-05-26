#!/usr/bin/env bash

source $HOME/i3/color.sh

ACPI=$(acpi -b)
CHARGE=$(echo -n "${ACPI}" | egrep -o "[0-9]+%" | sed -e "s,%,,g")

STATE=""
ICON=""

if grep -q "Charging\|Full" <(echo "${ACPI}" | awk '{ gsub("Unknown","Charging",$3); print $3}') ; then
	# >
	if [[ $CHARGE -gt 94 ]] ; then
		exit 0
	fi

    ICON="F0E7"
    #STATE=" (Charging)"
else
    STATE=$(echo "${ACPI}" | awk -F' ' '{print $5}' | awk -F':' '{print $1":"$2}')
    STATE=" (${STATE}h)"
fi

LEVEL=$(( (CHARGE - 1) / 20 ))
if [[ -z $ICON ]] ; then
	ICON="f$(( 244 - LEVEL ))"
fi

if [[ $1 == '-i' ]] ; then
	echo -e "  \u${ICON}"
	echo
	echo "${COLOR_ACCENT_HEX}"
else
	echo -e " ${CHARGE}${STATE}"
fi
#echo -e "  \u${ICON}  ${CHARGE}${STATE} "

if [ "${STATE}" != " (Charging)" ]; then
    [[ "${LEVEL}" = "0" ]] && {
        [[ -z "{STATE}" ]] || i3-msg "fullscreen disable"
        if [[ $1 != '-i' ]] ; then
		#echo "#fb4934" 
		echo "${COLOR_ACCENT_HEX}" 
	fi
        exit 0
    }
fi

exit 0
