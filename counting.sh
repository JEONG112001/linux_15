#!/bin/bash
# 목표: 후보별 득표 수 계산 및 출력 (총 투표자 1000명 기준)

echo "== 개표 통계 =="

# 후보 8명
candidates=("num_1" "num_2" "num_3" "num_4" "num_5" "num_6" "num_7" "num_8")

# 득표 수 초기화
votes=(0 0 0 0 0 0 0 0)

# 무효표 변수
invalid_votes=0

# 총 투표수 고정
total_votes=1000

# ELECTION.txt 파일 존재 확인
if [ ! -f ELECTION.txt ]; then
    echo "ELECTION.txt 파일이 없습니다."
    exit 1
fi