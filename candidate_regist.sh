#!/bin/bash

# 초기값
independent_type=0 # 0: 정당 후보, 1: 비수도권 무소속, 2: 수도권 무소속
partyA=0             

# 입력부1
printf "후보 이름  : "
read cand_name        

printf "후보 정당  : "
read cand_party       

printf "기호 (1~8) : "
read symbol           

# 입력부2
clear
echo "$cand_name 정보"
printf "당선횟수(선수) (초선=1, 재선=2 등) : "
read cand_term        

echo
echo "(장관 : 8, 현역정치인 : 7, 신인정치인 : 3, 유명방송인 : 8, 대권주자급 : 13, 전직정치인 : 6)"
echo "(총리 : 10, 광역단체장 : 10, 3선 이상 다선정치인 : +2, 정당 지도부 : 10)"
echo "(광역의원 5, 광역의회의장 6, 기초의원 4, 기초의회의장 5)"
printf "인지도 점수 : "
read cand_rec         

echo
echo "(현역의원 : 10, 전직의원 : 8, 후보의 고향 : 5, 후보의 거주지 : 3, 없음 : 0)"
printf "후보의 지역연고 점수 (0~10) : "
read relation         

echo
printf "현역의원 (Y/N) : "
read is_incumbent     

printf "전직의원 (Y/N) : "
read is_former        

printf "신인정치인 여부 (Y/N) : "
read is_newbie        

echo
printf "%s 지지율 입력 (무소속이면 '무' 입력) : " "$cand_party"
read partyA_input     

# 무소속 여부 판별
if [ "$partyA_input" = "무" ] || [ "$partyA_input" = "무소속" ]; then
    clear
    echo "$cand_name 정보 (무소속)"
    printf "(비수도권 권역 : 1, 수도권 권역 : 2) : "
    read independent_type
# 무소속 후보 분기
else
# 정당 후보는 입력한 지지율을 그대로 사용
    partyA=$partyA_input
fi

# 계산

# 선수 보너스
if [ "$cand_term" -eq 0 ] 2>/dev/null; then
    cand_term_bonus=1
else
    cand_term_bonus=$(( cand_term * 13 ))
fi

# 교체여론 기준값
term_limit=40
[ "$is_incumbent" = "Y" ] || [ "$is_incumbent" = "y" ] && term_limit=50
[ "$is_former"    = "Y" ] || [ "$is_former"    = "y" ] && term_limit=43

replace_mind=$(( RANDOM % cand_term_bonus + term_limit ))
replace_rate=0

if [ "$replace_mind" -ge 50 ] && [ "$cand_term" -ne 0 ]; then
    cand_term_bonus2=$(( cand_term * 5 ))
    cand_term_bonus3=$(( cand_term * 7 ))
    replace_rate=$(( RANDOM % cand_term_bonus2 + cand_term_bonus3 ))
fi

[ "$cand_term" -eq 0 ] && replace_rate=1

# 현역/전직/신인 가감산
inc_bonus=0
former_bonus=0
newbie_bonus3=0

[ "$is_incumbent" = "Y" ] || [ "$is_incumbent" = "y" ] && inc_bonus=15
[ "$is_former"    = "Y" ] || [ "$is_former"    = "y" ] && former_bonus=10

if [ "$is_newbie" = "Y" ] || [ "$is_newbie" = "y" ]; then
    newbie_bonus1=$(( 2 * cand_rec ))
    if [ "$cand_rec" -gt 0 ]; then
        newbie_bonus2=$(( RANDOM % cand_rec + newbie_bonus1 ))
    else
        newbie_bonus2=$newbie_bonus1
    fi
    [ "$newbie_bonus2" -ge 16 ] && newbie_bonus2=$(( newbie_bonus2 + 13 ))
    newbie_bonus3=$(( newbie_bonus2 / 2 ))
fi

# 인지도 / 지역연고 점수
recognition=$(( cand_rec * 4 ))
relation_score=$relation

# 중간 계산
calc1=$(( cand_term_bonus - replace_rate ))
calc2=$(( inc_bonus + former_bonus ))
calc3=$(( recognition + relation_score ))
calc4=$(( calc1 + calc2 ))
calc5=$(( calc3 + newbie_bonus3 ))

# 최종 개인 경쟁력
personal_comp=$(( (calc4 + calc5) / 2 ))

# 무소속이면 개인 경쟁력으로 정당지지율 환산
if [ "$independent_type" -eq 1 ]; then
    partyA=$(( personal_comp / 2 ))
elif [ "$independent_type" -eq 2 ]; then
    partyA=$(( personal_comp / 4 ))
fi

final_comp=$personal_comp


# 출력

# 정당 지지율
echo "$partyA" > "party_${symbol}.txt"

# 무소속이면 minus.txt 저장 (이 만큼 원소속 정당에서 뻴셈)
if [ "$independent_type" -ne 0 ]; then
    echo "$partyA" > minus.txt
fi

# 후보최종 개인 경쟁력
echo "$final_comp" > "candidate_${symbol}.txt"

exit 0