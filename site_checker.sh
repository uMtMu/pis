#!/bin/bash
FILE=site_check.response
if [ -f $FILE ];
then
    rm $FILE
fi

if [ -z "$1" ]
then
        site_url=https://www.sonteklif.com
else
        site_url=$1
fi
for i in $(seq 1 5);
do
        tim=$(date "+%H%M")
        curl_out=$(curl -o /dev/null -s -w %{time_total} $site_url)
        echo $tim $curl_out $site_url
        echo $tim $curl_out $site_url >> $FILE
        sleep 10
done


