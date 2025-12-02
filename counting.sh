#!/bin/bash
# 목표: 후보별 득표 수 계산 및 출력 (총 투표자 1000명 기준)
# ELECTION.txt 기반

echo "== 개표 통계 =="

# 후보 8명
candidates=("num_1" "num_2" "num_3" "num_4" "num_5" "num_6" "num_7" "num_8")

# 득표 수 초기화
votes=(0 0 0 0 0 0 0 0)
invalid_votes=0

# ELECTION.txt 파일 존재 확인
if [ ! -f ELECTION.txt ]; then
    echo "ELECTION.txt 파일이 없습니다."
    exit 1
fi

# 총 투표수 (파일 줄 수 기준)
total_votes=$(wc -l < ELECTION.txt)

# 퍼센트 계산 함수
calc_percent() {
    echo "scale=2; $1*100/$total_votes" | bc
}

# ELECTION.txt에서 투표 읽기
while read -r candidate; do
    valid=false
    for i in "${!candidates[@]}"; do
        if [[ "$candidate" == "${candidates[i]}" ]]; then
            votes[i]=$((votes[i]+1))
            valid=true
            break
        fi
    done
    # 후보가 아니면 무효표 증가
    if [ "$valid" = false ]; then
        invalid_votes=$((invalid_votes+1))
    fi
done < ELECTION.txt

# 출력 및 파일 저장 함수
print_results() {
    echo "후보 | 득표 | 퍼센트"
    for i in "${!candidates[@]}"; do
        percent=$(calc_percent "${votes[i]}")
        printf "%-5s | %-5d | %6s%%\n" "${candidates[i]}" "${votes[i]}" "$percent"
    done
    invalid_percent=$(calc_percent "$invalid_votes")
    printf "무효표 | %-5d | %6s%%\n" "$invalid_votes" "$invalid_percent"
}

# 화면 출력
print_results

# 파일 저장
{
    echo "== 전체 투표 결과 =="
    print_results
} > election_results.txt

echo "결과가 election_results.txt에 저장되었습니다."