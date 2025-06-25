#!/bin/bash

mkdir -p step
docker run --rm -v "$(pwd)/step:/home/step" smallstep/step-ca step ca init \
  --name "Pyke CA" \
  --dns "step-ca" \
  --address ":9000" \
  --provisioner "pyke-admin" \
  --password-file /home/step/password.txt
