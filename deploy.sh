#!/bin/bash

export APP_PID=$(ps -ef | grep '[j]ava -jar /home/ubuntu/spring-petclinic' | awk '{print $2}')
if [ -z "$APP_PID" ]; then
    echo "[INFO] APPLICATION IS STARTING..."
else
    echo "[INFO] APPLICATION IS RUNNING WITH PID(S): $APP_PID"
    echo "[INFO] STOPPING THE OLD VERSION..."
    for pid in $APP_PID; do
        kill -9 $pid
    done
fi

echo "[INFO] STARTING THE NEW VERSION OF APPLICATION..."
nohup java -jar /home/ubuntu/spring-petclinic-*.jar  >/home/ubuntu/output.log 2>&1 &

sleep 15

export APP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/actuator/health)
if [ "$APP_STATUS" == "200" ]; then
    export NEW_APP_PID=$(ps -ef | grep '[j]ava -jar /home/ubuntu/spring-petclinic' | awk '{print $2}')
    echo "[INFO] APPLICATION STARTED SUCCESSFULLY WITH PID $NEW_APP_PID..."
else
    echo "[ERROR] UNKNOWN ERROR"
fi
