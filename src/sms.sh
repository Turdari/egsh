#!/bin/bash

sms_textbelt_test(){
	curl -X POST https://textbelt.com/text \
	   --data-urlencode phone='821096633758' \
	   --data-urlencode message='one more' \
	   -d key=textbelt	
	return 0
}

