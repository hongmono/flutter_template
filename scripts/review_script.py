import os
import requests
from github import Github

def review_code_with_claude(file_content):
    api_key = os.environ['PPLX_API_KEY']
    headers = {
        'Authorization': f'Bearer {api_key}',
        'Content-Type': 'application/json'
    }
    data = {
        'model': 'claude-3-sonnet-20240229',
        'messages': [
            {'role': 'system', 'content': '''당신은 경험 많은 시니어 개발자이자 코드 리뷰어입니다. 주어진 코드 변경사항을 철저히 분석하고, 다음 사항들을 중점적으로 검토하여 개선점을 제안해주세요:

1. 코드 품질: 가독성, 유지보수성, 효율성을 평가하세요.
2. 버그 및 잠재적 문제: 발견된 버그나 잠재적인 문제점을 지적하세요.
3. 보안: 보안 취약점이 있는지 확인하고 개선 방안을 제시하세요.
4. 성능: 성능 개선이 필요한 부분을 찾아 최적화 방법을 제안하세요.
5. 코딩 표준: 프로젝트의 코딩 표준을 준수하고 있는지 확인하세요.
6. 테스트: 적절한 테스트 케이스가 추가되었는지 확인하고, 필요한 경우 추가 테스트를 제안하세요.
7. 문서화: 코드 주석이나 문서화가 적절한지 평가하세요.

리뷰는 한글로 작성하며, 건설적이고 구체적인 피드백을 제공해주세요. 긍정적인 부분도 언급하여 균형 잡힌 리뷰를 해주세요.'''},
            {'role': 'user', 'content': f'다음 코드 변경사항을 리뷰해주세요:\n\n{file_content}'}
        ],
        'max_tokens': 1500
    }
    try:
        response = requests.post('https://api.perplexity.ai/chat/completions', headers=headers, json=data)
        response.raise_for_status()
        return response.json()['choices'][0]['message']['content']
    except requests.RequestException as e:
        return f"API 요청 중 오류 발생: {str(e)}"
    except KeyError as e:
        return f"API 응답 파싱 중 오류 발생: {str(e)}"
    except Exception as e:
        return f"예상치 못한 오류 발생: {str(e)}"

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
        review = review_code_with_claude(diff)
        review_results.append(f'## {file} 리뷰 결과:\n\n{review}\n')

    overall_review = "# PR 변경사항 리뷰 결과 (Claude 3 Sonnet 사용)\n\n"
    overall_review += "이 PR에서 변경된 부분들에 대한 리뷰 결과입니다:\n\n"
    overall_review += "\n".join(review_results)

    pull_request.create_issue_comment(overall_review)

if __name__ == "__main__":
    main()