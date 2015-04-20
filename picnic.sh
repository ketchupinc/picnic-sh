#!/bin/bash

# SET YOUR PICNIC API KEY ON THE NEXT LINE
API_KEY=''
BASE_URL="https://picnic.sh"

if [ -z "$API_KEY" ]; then
    echo "API_KEY is not set! Open this script and set the API_KEY variable on top to be your key";
    exit 1;
fi

function usage {
    echo "Available commands are:";
    echo "$0 -c DOMAIN HTML";
    echo "$0 -u DOMAIN HTML";
    echo "$0 -p DOMAIN";
    echo
    echo "Example:";
    echo "$0 -c foobar.com \"<html><body><h1>BAZ!</h1></body></html>\"";
    echo "$0 -u foobar.com \"<html><body><h1>MORE BAZ!</h1></body></html>\"";
    echo "$0 -p foobar.com";
    exit 1;
}

function check_domain {
    if [ -z "$domain" ]; then
        echo "Your domain argument is missing!";
        echo
        usage;
    fi
}

function check_html {
    if [ -z "$html" ]; then
        echo "Your html is missing!";
        echo
        usage;
    fi
}

function create_domain {
    check_domain;
    check_html;

    echo "Creating $domain"
    curl -s -X POST -H "Content-Type: application/json" -d "{\"domain_name\": \"$domain\", \"html\": \"$html\"}" "$BASE_URL/api/websites/?api_key=$API_KEY" | python -m json.tool

    exit 0;
}

function update_domain {
    check_domain;
    check_html;
    echo "Updating $domain"
    curl -s -X PUT -H "Content-Type: application/json" -d "{\"html\": \"$html\"}" "$BASE_URL/api/websites/$domain?api_key=$API_KEY" | python -m json.tool

    exit 0;
}

function list_domain {
    curl -s "$BASE_URL/api/websites/?api_key=$API_KEY" | python -m json.tool | grep domain_name | cut -d'"' -f4
    exit 0;
}

function price {
    check_domain;

    echo "Checking price for: $domain";
    response=$(curl -s "$BASE_URL/api/price/$domain?api_key=$API_KEY")
    if [[ $response =~ "\"available\": true" ]]; then
        price=$(echo $response | egrep -o '"price": ([0-9]+)' | cut -d':' -f2)
        price_in_dollars=$(bc <<< "scale=2; $price/100")
        echo "Domain is available for \$$price_in_dollars";
    else
        echo "Domain not available"
    fi
    exit 0;
}

while [[ $# > 0 ]]
do
    case "$1" in
        -c|--create)
            domain="$2"
            shift
            html="$2"
            shift
            create_domain
            ;;
        -u|--update)
            domain="$2"
            shift
            html="$2"
            shift
            update_domain
            ;;
        -p|--price)
            domain="$2"
            shift
            price
            ;;
        -l|--list)
            list_domain
            ;;
    esac
    shift
done

usage