#!/bin/bash
PERSON1=ram
PERSON2=ramesh
echo "Hello $PERSON1,How are you?"
echo "Hai $PERSON2, i am fine"

PERSON1=$1
PERSON2=$2
echo "Hello $PERSON1,How are you?"
echo "Hai $PERSON2, i am fine"

echo  "enter your name:"
read -s 
echo  "enter your password:"
read -s