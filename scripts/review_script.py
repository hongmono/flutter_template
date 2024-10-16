import os
import requests
from github import Github

def review_code(file_content):
    api_key = os.environ['PPLX_API_KEY']
    headers = {
        'Authorization': f'Bearer {api_key}',
        'Content-Type': 'application/json'
    }
    data = {
        'model': 'llama-3.1-sonar-huge-128k-online',
        'messages': [
            {'role': 'system', 'content': '''당신은 이제 다음과 같은 역할을 맡은 숙련된 시니어 Flutter 개발자입니다:

- 경력: 7년 이상의 모바일 앱 개발 경험, 그 중 5년은 Flutter 전문
- 전문 분야: 크로스 플랫폼 모바일 앱 개발, 성능 최적화, 클린 아키텍처
- 주요 기술: Dart, Flutter, Firebase, 상태 관리 (Provider, Riverpod), 비동기 프로그래밍
- 강점: 코드 리팩토링, 디자인 패턴 적용, 성능 튜닝

당신의 임무는 주어진 Flutter 코드를 철저히 분석하고 리뷰하는 것입니다. 리뷰 시 다음 사항을 고려해주세요:

1. 코드 구조와 아키텍처의 적절성
2. Flutter와 Dart의 최신 베스트 프랙티스 준수 여부
3. 성능 최적화 가능성
4. 코드 가독성 및 유지보수성
5. 잠재적인 버그나 보안 취약점
6. 테스트 가능성 및 테스트 코드 품질

리뷰 결과는 다음 형식으로 제공해주세요:

1. 전반적인 코드 품질 평가 (5점 만점)
2. 주요 강점 (3-5개 항목)
3. 개선이 필요한 영역 (우선순위 순으로 3-5개)
4. 구체적인 리팩토링 제안 (코드 예시 포함)
5. 성능 최적화 팁
6. 추가 학습이 권장되는 Flutter/Dart 개념이나 기술

귀하의 전문성을 바탕으로 건설적이고 실용적인 피드백을 제공해주세요. 코드의 장단점을 균형있게 다루되, 개선 방향에 초점을 맞춰주세요.'''},
            {'role': 'user', 'content': f'다음 코드 변경사항을 리뷰해주세요:\n\n{file_content}'}
        ]
    }
    response = requests.post('https://api.perplexity.ai/chat/completions', headers=headers, json=data)
    return response.json()['choices'][0]['message']['content']

def get_changed_files_with_diff():
    g = Github(os.environ['GITHUB_TOKEN'])
    repo = g.get_repo(os.environ['GITHUB_REPOSITORY'])
    pr_number = int(os.environ['GITHUB_REF'].split('/')[-2])
    pull_request = repo.get_pull(pr_number)
    return [(file.filename, file.patch) for file in pull_request.get_files()]

def main():
    g = Github(os.environ['GITHUB_TOKEN'])
    repo = g.get_repo(os.environ['GITHUB_REPOSITORY'])
    pr_number = int(os.environ['GITHUB_REF'].split('/')[-2])
    pull_request = repo.get_pull(pr_number)

    changed_files = get_changed_files_with_diff()
    review_results = []
    for file, diff in changed_files:
        review = review_code(diff)
        review_results.append(f'## {file} 리뷰 결과:\n\n{review}\n')

    overall_review = "# PR 변경사항 리뷰 결과\n\n"
    overall_review += "이 PR에서 변경된 부분들에 대한 리뷰 결과입니다:\n\n"
    overall_review += "\n".join(review_results)

    pull_request.create_issue_comment(overall_review)

if __name__ == "__main__":
    main()