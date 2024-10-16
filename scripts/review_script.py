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
        'model': 'llama-3.1-sonar-large-128k-online',
        'messages': [
            {'role': 'system', 'content': '당신은 코드 리뷰어입니다. 주어진 코드 변경사항을 분석하고 개선점을 제안해주세요. 리뷰는 한글로 진행해 주세요'},
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