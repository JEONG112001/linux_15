#!/bin/bash

# 원본 투표 데이터 확인
if [ ! -f ELECTION.txt ]; then
    echo "ELECTION.txt 파일이 없습니다."
    exit 1
fi