#!/bin/bash -e

PATH=/usr/local/bin/darwin-amd64:/bin:/usr/bin:/usr/local/bin/

NAMESPACE=$1

declare -a res=$(helm list  --tiller-namespace=$NAMESPACE | egrep -i deployed | awk -F"\t" '{print $1}')
for r in ${res[@]};
	do 
		related=$(helm status $r --tiller-namespace=$NAMESPACE | grep -A 2 '==> v1/Pod(related)' | sed -e '1,2d' | awk '/ [0-9]+h| [1-5]{1}d/' | while read a b c d e; do echo $a $e;done)
		deployment=$(helm status $r --tiller-namespace=$NAMESPACE | grep -A 2 '==> v1beta1/Deployment' | sed -e '1,2d' | awk '/ [0-9]+h| [1-5]{1}d/' | while read a b c d e f; do echo $a $f;done)
		svc=$(helm status $r --tiller-namespace=$NAMESPACE | grep -A 2 '==> v1/Service' | sed -e '1,2d' | awk '/ [0-9]+h| [1-5]{1}d/' | while read a b c d e f; do echo $a $f;done)
		cm=$(helm status $r --tiller-namespace=$NAMESPACE | grep -A 2 '==> v1/ConfigMap' | sed -e '1,2d' | awk '/ [0-9]+h| [1-5]{1}d/' | while read a b c; do echo $a $c;done)
		if [[ -z $related ]] && [[ -z $deployment ]] && [[ -z $svc ]] && [[ -z $cm ]];then
			echo "QA Deployment for $r is NOT required"
		else
			echo "QA Deployment for $r IS required"
			echo "$r $related $deployment $svc $cm" >> result.txt
		fi
	done