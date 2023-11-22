#!/bin/bash
# Script create by OliveiraX
# GitHub: https://github.com/OliveiraaX
if [ "$#" -lt 2 ] || [ "$#" -gt 4 ]; then
    echo "Uso: $0 <alvo> <user-agent> [wordlist] [extensao]"
    exit 1
fi

read -p "---- Deseja executar varredura dns(x) ou dominio(z)?(x/z): " choice
case "$choice" in
    z)
        echo "=================================================================="
        echo "                 [+] Executando varredura"
        echo "=================================================================="

        servico=$(curl -s -H "User-Agent: $2" "$1/auwn#!" | grep -oP '<address>\K[^<]*' | grep -oP '^[^ ]+')
        echo ""
        echo " - WebServer $servico"
        echo ""
        echo "--------------------------- Scanning ----------------------------"
        for palavra in $(cat "${3:-/dev/stdin}"); do
            url="$1/$palavra"
            url_com_barra="$url/"

            # Verifica se a URL sem barra existe
            saida=$(curl -s -H "User-Agent: $2" -o /dev/null -w "%{http_code}" "$url${4:+$4}")
            if [ "$saida" == "200" ]; then
                if [ -n "$4" ]; then
                    echo "Arquivo encontrado: $url$4"
                else
                    echo "Arquivo encontrado: $url"
                fi

            fi

            # Verifica se a URL com barra existe
            saida=$(curl -s -H "User-Agent: $2" -o /dev/null -w "%{http_code}" "$url_com_barra")
            if [ "$saida" == "200" ]; then
                echo "Diretório encontrado: $url_com_barra"
            fi

        done
           echo "-----------------------------------------------------------------"
        ;;

    x)
        echo "=================================================================="
        echo "                 [+] Executando varredura"
        echo "=================================================================="
        servico1=$(curl -s -H "User-Agent: $2" "$1/auwn#!" | grep -oP '<address>\K[^<]*' | grep -oP '^[^ ]+')
        echo ""
        echo " - WebServer $servico1"
        echo ""
        echo "--------------------------- Scanning ----------------------------"
        for i in $(cat "$3");do
            host $i.$1 | grep "address"
        done
        
        echo "-----------------------------------------------------------------"

        ;;
    *)
        echo "Escolha inválida. Saindo."
        exit 1
        ;;
esac

