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

Script_Name="PaiNoob DNS Enumeration 1.0";

if [[ "$1" == "" ]]
then
    echo -e "${LGreen}"
    echo "$Script_Name"
    echo "Usage: $0 <HOST> <OPTIONS>"
    echo ""
    echo "OPTIONS:"
    echo "          -o: Save output to 'output.log'."
    echo ""
    echo -e "Ex.: $0 yourdomain.com ${NoColor}"
else
    if [[ "$2" == "-o" ]]
    then
        echo "" > output.log
        tee_cmd="tee -a output.log";
    else
        tee_cmd="tee";
    fi

    echo -e "${white}" | $tee_cmd
    echo "-----------------------------------------------------------" | $tee_cmd
    echo "               $Script_Name               " | $tee_cmd
    echo "-----------------------------------------------------------" | $tee_cmd
    idx=0;
    if [[ $(echo $1 | grep ".br") != "" ]]
    then
        locate_ns=$(whois $1 | grep "nserver" | cut -d " " -f6);
    else
        locate_ns=$(whois $1 | grep "Server:" | cut -d " " -f3 | grep "\." | sort);
    fi
    for ns in $locate_ns; do

        idx=$((idx + 1))
        if (( $idx % 2 )); then
            echo -e "${Green}" | $tee_cmd
        else
            echo -e "${Yellow}" | $tee_cmd
        fi

        if [[ $(echo $1 | grep ".br") != "" ]]
        then
            ns_ip=$(host -n $ns | cut -d " " -f4 | grep "\.");
            net_block=$(whois $ns_ip | grep "inetnum" | cut -d ":" -f2 | tr -d ' ');
            origin=$(whois $ns_ip | grep "origin" | cut -d ":" -f2 | tr -d ' ');
        else
            ns_ip=$(host -n $ns | cut -d " " -f4 | grep "\.");
            net_block=$(whois $ns_ip | grep "NetRange" | cut -d ":" -f2 | tr -d ' ');
            origin=$(whois $ns_ip | grep "OriginAS" | cut -d ":" -f2 | tr -d ' ');
        fi
        echo "Name: $ns"| $tee_cmd;
        echo "Address: $ns_ip" | $tee_cmd;
        echo "NetBlock: $net_block" | $tee_cmd;
        echo "Origin Code: $origin" | $tee_cmd;
        echo "-----------------------------------------------------------" | $tee_cmd
        echo "Subdomains in Netblock (Reverse DNS):" | $tee_cmd;
        echo "-----------------------------------------------------------" | $tee_cmd
        prefix1_ip=$(echo $net_block | cut -d "." -f1);
        prefix2_ip=$(echo $net_block | cut -d "." -f2);
        prefix3_ip=$(echo $net_block | cut -d "." -f3);
        range_start=$(echo $net_block | cut -d "." -f4 | cut -d "-" -f1);
        range_end=$(echo $net_block | cut -d "-" -f2 | cut -d "." -f4);
        addr="$prefix1_ip.$prefix2_ip.$prefix3_ip.";

        sub_idx=0
        for range in $(seq $range_start $range_end); do
            sub_idx=$((sub_idx + 1))
            host -t ptr $addr$range | grep "$1" | awk -v addr=$addr '{print addr substr( $1, 0, 3 )"    ->  "$5}' | sed 's/.$//'| $tee_cmd;
        done

        echo "" | $tee_cmd;

        tz_cmd=$(host -l $1 $ns | egrep -v "Using domain server:|Name:|Address:|Aliases:" | grep "failed";)
        if [[ $tz_cmd == "" ]]
        then
            echo "-----------------------------------------------------------" | $tee_cmd
            echo "Subdomains in Transfer Zone:" | $tee_cmd;
            echo "-----------------------------------------------------------" | $tee_cmd
            host -l $1 $ns | egrep -v "Using domain server:|Name:|Address:|Aliases:"| sed -n '1!p' | grep "has address" | awk '{print $1"    ->  "$4}' | sort | column -t | $tee_cmd;
            echo "" | $tee_cmd;
            echo "TOTAL: $sub_idx subdomains located in '$ns' name server." | $tee_cmd
        else
            echo -e "${Red}The '$ns' name server refused to show the transfer zone list." | $tee_cmd
        fi
    done
fi
