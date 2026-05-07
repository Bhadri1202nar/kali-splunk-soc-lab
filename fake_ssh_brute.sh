#!/bin/bash

TARGET="127.0.0.1"
FAKEUSER="fakeuser"
FAKEPASS=1234
echo "[*] Simulating SSH brute force with user: $FAKEUSER"

for i in $(seq 1 10); do
    echo "[*] Attempt $i"
    sshpass -p "$FAKEPASS" ssh -o StrictHostKeyChecking=no $FAKEUSER@$TARGET 2>/dev/null
done

echo "[*] Done! 10 failed attempts generated."
