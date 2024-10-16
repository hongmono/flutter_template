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
        'model': 'mistral-7b-instruct',
        'messages': [
            {'role': 'system', 'content': '당신은 코드 리뷰어입니다. 주어진 코드를 분석하고 개선점을 제안해주세요. 리뷰는 한글로 진행해 주세요'},
            {'role': 'user', 'content': f'다음 코드를 리뷰해주세요:\n\n{file_content}'}
        ]
    }
    response = requests.post('https://api.perplexity.ai/chat/completions', headers=headers, json=data)
    return response.json()['choices'][0]['message']['content']

def get_changed_files():
    g = Github(os.environ['GITHUB_TOKEN'])
    repo = g.get_repo(os.environ['GITHUB_REPOSITORY'])
    pr_number = int(os.environ['GITHUB_REF'].split('/')[-2])
    pull_request = repo.get_pull(pr_number)
    return [file.filename for file in pull_request.get_files()]

def get_file_content(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as file:
            return file.read()
    except FileNotFoundError:
        return f'파일을 찾을 수 없습니다: {filepath}'
    except Exception as e:
        return f'파일 읽기 오류: {str(e)}'

def main():
    g = Github(os.environ['GITHUB_TOKEN'])
    repo = g.get_repo(os.environ['GITHUB_REPOSITORY'])
    pr_number = int(os.environ['GITHUB_REF'].split('/')[-2])
    pull_request = repo.get_pull(pr_number)

    changed_files = get_changed_files()
    review_results = []
    for file in changed_files:
        content = get_file_content(file)
        review = review_code(content)
        review_results.append(f'## {file} 리뷰 결과:\n\n{review}\n')

    overall_review = "# PR 전체 리뷰 결과\n\n"
    overall_review += "이 PR에서 변경된 파일들에 대한 리뷰 결과입니다:\n\n"
    overall_review += "\n".join(review_results)

    pull_request.create_issue_comment(overall_review)

if __name__ == "__main__":
    main()
