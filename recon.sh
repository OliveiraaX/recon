#!/bin/bash
# Script created by OliveiraX
# GitHub: https://github.com/OliveiraaX

if [ "$#" -lt 2 ] || [ "$#" -gt 4 ]; then
    echo "Usage: $0 <target> <user-agent> [wordlist] [extension]"
    exit 1
fi

read -p "---- Do you want to perform a DNS scan (x) or a domain scan (z)? (x/z): " choice
case "$choice" in
    z)
        echo "=================================================================="
        echo "                 [+] Performing scan"
        echo "=================================================================="

        service=$(curl -s -H "User-Agent: $2" "$1/auwn#!" | grep -oP '<address>\K[^<]*' | grep -oP '^[^ ]+')
        echo ""
        echo " - WebServer $service"
        echo ""
        echo "--------------------------- Scanning ----------------------------"
        for word in $(cat "${3:-/dev/stdin}"); do
            url="$1/$word"
            url_with_slash="$url/"

            # Check if the URL without a slash exists
            output=$(curl -s -H "User-Agent: $2" -o /dev/null -w "%{http_code}" "$url${4:+$4}")
            if [ "$output" == "200" ]; then
                if [ -n "$4" ]; then
                    echo "File found: $url$4"
                else
                    echo "File found: $url"
                fi
            fi

            # Check if the URL with a slash exists
            output=$(curl -s -H "User-Agent: $2" -o /dev/null -w "%{http_code}" "$url_with_slash")
            if [ "$output" == "200" ]; then
                echo "Directory found: $url_with_slash"
            fi
        done
        echo "-----------------------------------------------------------------"
        ;;

    x)
        echo "=================================================================="
        echo "                 [+] Performing scan"
        echo "=================================================================="
        service1=$(curl -s -H "User-Agent: $2" "$1/auwn#!" | grep -oP '<address>\K[^<]*' | grep -oP '^[^ ]+')
        echo ""
        echo " - WebServer $service1"
        echo ""
        echo "--------------------------- Scanning ----------------------------"
        for i in $(cat "$3"); do
            host $i.$1 | grep "address"
        done
        echo "-----------------------------------------------------------------"

        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac
