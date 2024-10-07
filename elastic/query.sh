#!/bin/bash

curl -k -X GET "http://localhost:9200/_cat/indices?v" -H "accept: application/json" -H "Content-Type: application/json"
