#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

today_date=`date +"%Y-%m-%d_%T"`

echo "[$(hostname -s)]" >> results/${today_date}.txt
echo "OS: $(cut -d'=' -f2 <<<$(cat /etc/os-release | grep "PRETTY_NAME="))" >> results/${today_date}.txt

IFS=';' read updates security_updates < <(/usr/lib/update-notifier/apt-check 2>&1)

if (( updates == 0 && security_updates == 0 )); then
        echo "No updates available" >> results/${today_date}.txt
else
        echo "There are ${updates} updates and ${security_updates} security updates" >> results/${today_date}.txt
fi

users=$(grep '^root' /etc/group)
list_users="$(cut -d':' -f4 <<<"$users")"

output="Comptes du groupe root:"
while [ "$list_users" ];do
        iter=${list_users%%,*}
        output="${output} ${iter}, "

        [ "$list_users" = "$iter" ] && \
                list_users='' || \
                list_users="${list_users#*,}"
        done

echo $output >> results/${today_date}.txt

echo "Date: $(date +"%d-%m-%Y %T %Z")" >> results/${today_date}.txt

echo "" >> results/${today_date}.txt

ssh -i /home/samba/.ssh/id_rsa srv@192.168.1.5 -T "cat >> ~/supervision/rapport.txt" < results/${today_date}.txt
