#!/bin/bash
kubectl patch svc lb-nginx -p '{"spec":{"loadBalancerIP":"'"${EXT_IP}"'"}}'