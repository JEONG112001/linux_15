#!/bin/sh

# 초기값
independent_type=0    
partyA=1              

# 입력부1
printf "후보 이름  : "
read cand_name        

printf "후보 정당  : "
read cand_party       

printf "기호 : "
read symbol           

# 입력부2
clear
echo "$cand_name 정보"
printf "당선횟수(선수) (초선, 재선, 3선 등) : "
read cand_term        

echo
echo "(장관 : 8, 현역정치인 : 7, 신인정치인 : 3, 유명방송인 : 8, 대권주자급 : 13, 전직정치인 : 6) (중복 시 가장 높은 숫자에 + 나머지 1/2)"
echo "(총리 : 10, 광역단체장 : 10, 3선 이상 다선정치인 : + 2, 정당 지도부급 인사 : 10)"
echo "(광역의원 5, 광역의회의장 6, 기초의원 4, 기초의회의장 5)"
printf "인지도 : "
read cand_rec         

echo
echo "(현역의원 : 10, 전직의원 : 8, 후보의 고향 : 5, 후보의 거주지 : 3, 없음 : 0)"
printf "후보의 지역연고 (0~10) : "
read relation         

echo
printf "현역의원 (Y/N) : "
read is_incumbent     

printf "전직의원 (Y/N) : "
read is_former        

printf "신인정치인 여부 (Y/N) : "
read is_newbie        

echo
printf "%s 지지율 (무소속 : 무) : " "$cand_party"
read partyA_input     

# 무소속 여부 판별
if [ "$partyA_input" = "무" ]; then
    clear
    echo "$cand_name 정보"
    printf "(비수도권 권역 : 1, 수도권 권역 : 2) : "
    read independent_type
else
    partyA=0
fi

# 계산
if [ "$cand_term" -eq 0 ] 2>/dev/null; then
    cand_term_bonus=1
else
    cand_term_bonus=$(( cand_term * 13 ))
fi

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

recognition=$(( cand_rec * 4 ))
relation_score=$relation

calc1=$(( cand_term_bonus - replace_rate ))
calc2=$(( inc_bonus + former_bonus ))
calc3=$(( recognition + relation_score ))
calc4=$(( calc1 + calc2 ))
calc5=$(( calc3 + newbie_bonus3 ))

personal_comp=$(( (calc4 + calc5) / 2 ))

if [ "$independent_type" -eq 1 ]; then
    partyA=$(( personal_comp / 2 ))
elif [ "$independent_type" -eq 2 ]; then
    partyA=$(( personal_comp / 4 ))
fi

final_comp=$personal_comp

# 파일 출력
if [ "$independent_type" -ne 0 ]; then
    echo "$partyA" > minus.txt
    echo "$partyA" > "party_${symbol}.txt"
fi

echo "$final_comp" > "candidate_${symbol}.txt"

exit 0