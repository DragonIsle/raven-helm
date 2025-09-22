#!/bin/bash

minikube stop
minikube delete
minikube start --cpus=6 --memory=11900

minikube dashboard