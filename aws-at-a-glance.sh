#!/bin/bash
echo `date +"%a, %l:%M %p"`  
# Add aws to the PATH (for GeekTool) 
export PATH=$PATH:/usr/local/bin  
JSON_STATUS=`aws ec2 describe-instances --output json`  
INSTANCE_COUNT=`echo $JSON_STATUS | jq '.Reservations | length' 2>&1`  
CURRENT_MS=`date -u +"%s"`  
echo "Running instances: $INSTANCE_COUNT"  
for (( INSTANCE_IDX=0; INSTANCE_IDX<$INSTANCE_COUNT; INSTANCE_IDX++ ))  
do  
        INSTANCE_STATUS=`echo $JSON_STATUS | jq ".Reservations[$INSTANCE_IDX].Instances[0].State.Name"`
        INSTANCE_NAME=`echo $JSON_STATUS | jq ".Reservations[$INSTANCE_IDX].Instances[0].Tags[0].Value"`
        INSTANCE_IP=`echo $JSON_STATUS | jq ".Reservations[$INSTANCE_IDX].Instances[0].NetworkInterfaces[0].Association.PublicIp"`
        INSTANCE_DATE_UP=`echo $JSON_STATUS | jq ".Reservations[$INSTANCE_IDX].Instances[0].LaunchTime"`
        # Remove trailing quote
        temp="${INSTANCE_DATE_UP%\"}"
        # Remove leading quote
        temp="${temp#\"}"
        # This is our final date string
        INSTANCE_DATE_UP=$temp
        INSTANCE_MS_SINCE_EPOCH=`date -u -j -f "%Y-%m-%dT%k:%M:%S" $INSTANCE_DATE_UP "+%s" 2>/dev/null`
        DIFF_IN_MS=`expr $CURRENT_MS - $INSTANCE_MS_SINCE_EPOCH`
        DIFF_UNIT='min'
        DIFF_IN_MIN=`expr $DIFF_IN_MS / 60`
        if [ $DIFF_IN_MIN -gt 120 ]
        then
                DIFF_IN_MIN=`expr $DIFF_IN_MS / 3600`
                DIFF_UNIT='hr'
                if [ $DIFF_IN_MIN -gt 24 ]
                then
                        DIFF_IN_MIN=`expr $DIFF_IN_MS / 86400`
                        DIFF_UNIT='days'
                fi
        fi
        echo "INSTANCE $INSTANCE_IDX [$INSTANCE_NAME]: $INSTANCE_STATUS @ $INSTANCE_IP [ Up $DIFF_IN_MIN $DIFF_UNIT ]" 
done  
