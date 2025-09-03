#!/bin/bash

minikube stop
minikube delete
minikube start --cpus=5 --memory=11900

minikube dashboard