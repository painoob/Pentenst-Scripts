#!/bin/bash
#Cores Normais:         0;3Xm
#Cores Vivas:           0;9Xm
#Cores Negrito:         1;3Xm
#Cores Negrito Vivo:    1;9Xm
NoColor='\033[0m'       # Text Reset
Black='\033[0;30m'      # Black
Red='\033[0;31m'        # Red
Green='\033[0;32m'      # Green
LGreen='\033[0;92m'     # Light Green
Yellow='\033[0;33m'     # Yellow
Blue='\033[0;34m'       # Blue
Purple='\033[0;35m'     # Purple
Cyan='\033[0;36m'       # Cyan
White='\033[0;37m'      # White

if [[ "$1" == "" ]] || [[ "$2" == "" ]]
then
    echo -e "${LGreen}"
    echo "PaiNoob Scan Metadata 1.0"
    echo "Usage: $0 <TARGET> <FILETYPE> <OPTIONS = -o>"
    echo ""
    echo "-o: Save output to 'metadata.txt'. (Optional - disabled by default)"
    echo ""
    echo -e "Ex1.: $0 yoursite.com pdf"
    echo -e "Ex2.: $0 yoursite.com pdf -o ${NoColor}"
else
    if [[ "$3" == "-o" ]]
    then
        echo > metadata.txt
        tee_cmd="tee -a metadata.txt"
    else
        tee_cmd="tee";
    fi
    echo -e "${Blue}" | $tee_cmd
    echo "---------------------------------------------------------" | $tee_cmd
    echo "|               PaiNoob Scan Metadata 1.0               |" | $tee_cmd
    echo "---------------------------------------------------------" | $tee_cmd
    echo "" | $tee_cmd
    echo "Scanning '$1' for '*.$2' filetype ..." | $tee_cmd
    idx=0
    cmd=$(lynx --dump "https://google.com/search?q=site:$1+ext:pdf" | grep "\.$2" | cut -d "=" -f2 | sed 's/...$//');
    if [[ "$cmd" != "" ]]
    then
    for url in $cmd;
    do
        idx=$((idx + 1))
        if (( $idx % 2 )); then
            echo -e "${Green}" | $tee_cmd
        else
            echo -e "${Purple}" | $tee_cmd
        fi
        wget -q $url;
        echo "SOURCE FILE: $url" | $tee_cmd;
        exiftool $(basename "$url") | $tee_cmd;
    done
    rm *.$2*
    fi
    echo ""
    echo -e "${Blue}TOTAL: $idx files located in '$1' host with '.$2' filetype.${NoColor}" | $tee_cmd
fi