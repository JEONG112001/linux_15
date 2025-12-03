#!/bin/bash

# 후보/정당 파일이 없으면 기본값 1로 생성
for i in 1 2 3 4 5 6 7 8; do
    [ -f "candidate_${i}.txt" ] || echo 1 > "candidate_${i}.txt"
    [ -f "party_${i}.txt" ] || echo 1 > "party_${i}.txt"
done

# 출마자 수 읽기
if [ -f "출마자.txt" ]; then
    read -r num_candidates < "출마자.txt"
else
    num_candidates=8
fi

#가장 높은 정당지지율(기본값 55)
top_party_support=55

# 정당 지지율
read -r party1 < party_1.txt
read -r party2 < party_2.txt
read -r party3 < party_3.txt
read -r party4 < party_4.txt
read -r party5 < party_5.txt
read -r party6 < party_6.txt
read -r party7 < party_7.txt
read -r party8 < party_8.txt

# 4. 후보 경쟁력
read -r compA < candidate_1.txt
read -r compB < candidate_2.txt
read -r compC < candidate_3.txt
read -r compD < candidate_4.txt
read -r compE < candidate_5.txt
read -r compF < candidate_6.txt
read -r compG < candidate_7.txt
read -r compH < candidate_8.txt

# +5 보정(최소 보정)
compA=$(( compA + 5 ))
compB=$(( compB + 5 ))
compC=$(( compC + 5 ))
compD=$(( compD + 5 ))
compE=$(( compE + 5 ))
compF=$(( compF + 5 ))
compG=$(( compG + 5 ))
compH=$(( compH + 5 ))

# 후보자 평균
total_comp=$(( compA + compB + compC + compD + compE + compF + compG + compH ))
[ "$num_candidates" -gt 0 ] || num_candidates=8
avg_comp=$(( total_comp / num_candidates ))

# 정당 ×100
calc1=$(( party1*100 ))
calc2=$(( party2*100 ))
calc3=$(( party3*100 ))
calc4=$(( party4*100 ))
calc5=$(( party5*100 ))
calc6=$(( party6*100 ))
calc7=$(( party7*100 ))
calc8=$(( party8*100 ))

# 제일 높은 정당 지지율로 나누기
w1=$(( calc1 / top_party_support ))
w2=$(( calc2 / top_party_support ))
w3=$(( calc3 / top_party_support ))
w4=$(( calc4 / top_party_support ))
w5=$(( calc5 / top_party_support ))
w6=$(( calc6 / top_party_support ))
w7=$(( calc7 / top_party_support ))
w8=$(( calc8 / top_party_support ))

# 후보자 평균 × 가중값
w2_1=$(( avg_comp * w1 ))
w2_2=$(( avg_comp * w2 ))
w2_3=$(( avg_comp * w3 ))
w2_4=$(( avg_comp * w4 ))
w2_5=$(( avg_comp * w5 ))
w2_6=$(( avg_comp * w6 ))
w2_7=$(( avg_comp * w7 ))
w2_8=$(( avg_comp * w8 ))

# / 100
w3_1=$(( w2_1 / 100 ))
w3_2=$(( w2_2 / 100 ))
w3_3=$(( w2_3 / 100 ))
w3_4=$(( w2_4 / 100 ))
w3_5=$(( w2_5 / 100 ))
w3_6=$(( w2_6 / 100 ))
w3_7=$(( w2_7 / 100 ))
w3_8=$(( w2_8 / 100 ))

# 최종 경쟁력
compA=$(( compA + w3_1 ))
compB=$(( compB + w3_2 ))
compC=$(( compC + w3_3 ))
compD=$(( compD + w3_4 ))
compE=$(( compE + w3_5 ))
compF=$(( compF + w3_6 ))
compG=$(( compG + w3_7 ))
compH=$(( compH + w3_8 ))

# 토너먼트용 저장
base1=$compA
base2=$compB
base3=$compC
base4=$compD
base5=$compE
base6=$compF
base7=$compG
base8=$compH

# 무효 = 0
priority=0

rm -f ELECTION.txt

# ELECTION.txt 새로 생성
touch ELECTION.txt

# 투표
for ((a=1; a<=1000; a++)); do

    # 랜덤 점수 생성
    s1=$(( RANDOM % base1 + 20 ))
    s2=$(( RANDOM % base2 + 20 ))
    s3=$(( RANDOM % base3 + 20 ))
    s4=$(( RANDOM % base4 + 20 ))
    s5=$(( RANDOM % base5 + 20 ))
    s6=$(( RANDOM % base6 + 20 ))
    s7=$(( RANDOM % base7 + 20 ))
    s8=$(( RANDOM % base8 + 20 ))

# 1단계: 1vs2
    if [ $s1 -gt $s2 ]; then id1=1; sc1=$s1
    elif [ $s2 -gt $s1 ]; then id1=2; sc1=$s2
    else id1=$priority; sc1=$s1; fi

# 1단계: 3vs4
    if [ $s3 -gt $s4 ]; then id2=3; sc2=$s3
    elif [ $s4 -gt $s3 ]; then id2=4; sc2=$s4
    else id2=$priority; sc2=$s3; fi

# 1단계: 5vs6
    if [ $s5 -gt $s6 ]; then id3=5; sc3=$s5
    elif [ $s6 -gt $s5 ]; then id3=6; sc3=$s6
    else id3=$priority; sc3=$s5; fi

# 1단계: 7vs8
    if [ $s7 -gt $s8 ]; then id4=7; sc4=$s7
    elif [ $s8 -gt $s7 ]; then id4=8; sc4=$s8
    else id4=$priority; sc4=$s7; fi

 # 2단계
    if [ $sc1 -gt $sc2 ]; then id5=$id1; sc5=$sc1
    elif [ $sc2 -gt $sc1 ]; then id5=$id2; sc5=$sc2
    else id5=$priority; sc5=$sc1; fi

    if [ $sc3 -gt $sc4 ]; then id6=$id3; sc6=$sc3
    elif [ $sc4 -gt $sc3 ]; then id6=$id4; sc6=$sc4
    else id6=$priority; sc6=$sc3; fi

# 최종 대결
    if [ $sc5 -gt $sc6 ]; then vote=$id5
    elif [ $sc6 -gt $sc5 ]; then vote=$id6
    else vote=$priority; fi

#투표
    echo "num_$vote" >> ELECTION.txt
#투표 진행상황
    echo "$a"
done

echo "투표 종료"

