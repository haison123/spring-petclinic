#!/bin/bash
export APP_PID=$(ps -ef | grep 'java -jar /home/ubuntu/spring-petclinic' | awk '{print $2}' | head -n 1)
if [ -z "$APP_PID" ]; then echo "[INFO] APPLICATION IS STARTING..."; else echo "[INFO] APPLICATION IS RUNNING WITH PID IS: $APP_PID"; echo "[INFO] STOPPING THE OLD VERSION..."; kill -9 $APP_PID; fi
echo "[INFO] STARTING THE NEW VERSION OF APPLICATION..."
nohup java -jar /home/ubuntu/spring-petclinic-*.jar &
sleep 15
export APP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/actuator/health)
if [ "$APP_STATUS" == "200" ]; then echo "[INFO] APPLICATION STARTED SUCCESSFULLY..."; else echo "[ERROR] UNKNOWN ERROR"; fi
