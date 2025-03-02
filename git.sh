#!/bin/bash

gpm() {
    git add -A;
    git commit -m "auto update";
    git push origin main;
    echo "updated to origin main";
}
