#!/bin/bash

set -e
set -u

trap '{
    rm -rf "${feh_flist[@]}" &>/dev/null
}' EXIT


ROOTPATH="${HOME}/wp"
TIME='60s'
ITERATIONS=-1
SCREENS=0
SCALE_OPTION='--bg-max'

WGAP=5
HGAP=5

REPEAT='false'
NODRYRUN='true'
VERBOSE='false'
SUPER_VERBOSE='false'

while getopts 'cfmg:1i:nvVp:rs:t:' opt ; do
    case ${opt} in
        c) SCALE_OPTION='--bg-center' ;;
        f) SCALE_OPTION='--bg-fill' ;;
        m) SCALE_OPTION='--bg-max' ;;
        g) WGAP="${OPTARG}"  HGAP="${OPTARG}" ;;
        1) ITERATIONS=1 ;;
        i) ITERATIONS="${OPTARG}" ;;
        n) NODRYRUN='false' ;;
        v) VERBOSE='true' ;;
        V) SUPER_VERBOSE='true' ;;
        p) ROOTPATH="${OPTARG}" ;;
        r) REPEAT='true' ;;
        s) SCREENS="${OPTARG}" ;;  # TODO: force screen number. Useful? to implement
        t) TIME="${OPTARG}" ;;
        ?) echo "Invalid option: -${OPTARG}" >&2
           exit 1 ;;
        :) echo "Option -${OPTARG} requires an argument." >&2
           exit 1 ;;
    esac
done

${SUPER_VERBOSE} && set -x



vconfig=()
while read VOUTPUT CONNECTED CONFIG __REST ; do
    [ "${CONNECTED}" != 'connected' ] && continue
    IFS+='x+' read weight height xoffset yoffset <<< ${CONFIG}
    vconfig+=( "${VOUTPUT} ${weight} ${height} ${xoffset} ${yoffset}" )
    ${VERBOSE} && echo "${VOUTPUT}: '${weight}.${height}.${xoffset}.${yoffset}'"
# The grep above below is just so we have less output lines in the verbose
# mode. Less iteration being executed.
done < <(xrandr --current | grep connected )
screens="${#vconfig[@]}"

${VERBOSE} && ( IFS=',' ; echo "vconfig[${#vconfig[@]}]: {${vconfig[*]}}" )




feh_flist=()
for i in "${vconfig[@]}" ; do
    read voutput __rest <<< "${i}"
    fehfile=$(mktemp --tmpdir --suffix ".txt" "$(basename $0).${voutput}.fehlist-XXX")
    feh --recursive --randomize -L '%f %w %h %l %u' "${ROOTPATH}" > "${fehfile}" #2>/dev/null || true
    #FEH_CMD="feh --recursive --randomize -L '%F %w %h %l %u' ${ROOTPATH}"
    #fehfd=<(eval "${FEH_CMD}")
    feh_flist+=( "${fehfile}" )
    ${VERBOSE} && echo "feh_file: '${fehfile}'"
done

${VERBOSE} && ( IFS=',' ; echo "feh_flist[${#feh_flist[@]}]: {${feh_flist[*]}}" )



#(( i = ITERATIONS ))
#while read FNAME_1 WIDTH_1 HEIGHT_1 TOTAL_1 NUMBER_1 \
#           FNAME_2 WIDTH_2 HEIGHT_2 TOTA L_2 NUMBER_2  __REST ; do
#    (( i-- == 0 )) && break
#    ${VERBOSE} && echo -e "wallpapers ($i):\n-> ${FNAME_1}\n-> ${FNAME_2}"
#    ${NODRYRUN} && feh --no-fehbg --bg-max "${FNAME_1}" "${FNAME_2}"
#    sleep "${TIME}"
#done < <(paste   "${feh_flist[@]}" )

while true ; do
    (( i = ITERATIONS ))
    while (( i != 0 )) ; do
        fnames=()
        for (( j = 0 ; j < screens ; j++ )) ; do
            read FNAME WIDTH HEIGHT TOTAL NUMBER __REST || break
    	fnames+=( "${FNAME}" )
        done
        (( i-- == 0 )) && break
        ${VERBOSE} && {
            echo "wallpapers ($i):" ;
            for f in "${fnames[@]}" ; do echo ">> ${f}" ; done
        }
    
        imgfiles=()
        for (( x = ${#fnames[@]} - 1 ; x >= 0 ; x-- )) ; do
            read voutput weight height xoffset yoffset __rest <<< "${vconfig[$x]}"
            #${VERBOSE} && echo "VOUTPUT: ${voutput}.${weight}.${height}.${xoffset}.${yoffset}.${__rest}|"
            (( imgweight = weight - (weight * WGAP * 2) / 100 ))
            (( imgheight = height - (height * HGAP * 2) / 100 ))
    
            imgfile=$(mktemp --tmpdir --suffix ".png" "$(basename $0).${voutput}.img_XXX")
            imgfiles+=( "${imgfile}" )
    
            convert "${fnames[$x]}" -resize ${imgweight}x${imgheight} ${imgfile}
    	${VERBOSE} && echo ">> tempimage ${imgweight}x${imgheight}: ${imgfile}"
        done
    
        ${NODRYRUN} && feh --no-fehbg ${SCALE_OPTION} "${imgfiles[@]}"
        rm -rf "${imgfiles[@]}" &>/dev/null
    
        sleep "${TIME}"
    done < <(paste  -d \\n "${feh_flist[@]}" )
    ${VERBOSE} && echo "Full sequence done."
    ${REPEAT} || break
    ${VERBOSE} && echo "Do it again \o/"
done

# Beeing removed in the EXIT trap. Maybe we don't need it here.
rm -rf "${feh_flist[@]}" &>/dev/null


# ONELINER
# find ~/wp -type f \( -name '*.jpg' -o -name '*.png' -o -name '*.gif' \) -print0 | shuf  -z | xargs -0 -L 2  /bin/bash -c '{ sleep 2s ; echo -e "wallpapers:\n-> $1\n-> $2" ; feh --no-fehbg  --bg-max "$1" "$2" ; }' wallsetter

