#!/usr/bin/env bash
for (( ; ; ))
do
    ./gradlew 'assembleDebug'
    if [ $? -eq 0 ] 
    then
        echo "Done"
        break
    fi
    echo "Failed, trying again!"
done

