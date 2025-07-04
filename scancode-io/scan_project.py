from datetime import datetime
from os import getenv
import subprocess
import requests

def get_git_commit_hash():
    try:
        result = subprocess.run(
            ["git", "rev-parse", "--short", "HEAD"],
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            check=True,
            text=True
        )
        return result.stdout.strip()
    except Exception:
        return "unknown"

def main():
    project_name = getenv("PROJECT_NAME", f"scan-{datetime.now().isoformat()}")
    commit_hash = get_git_commit_hash()
    project_name += f"@{commit_hash}"

    # Fallback to INPUT_URLS from .env or local environment
    input_urls = getenv("INPUT_URLS")
    if not input_urls:
        raise ValueError("INPUT_URLS must be set as a comma-separated string outside of GitHub Actions.")
    input_urls_list = [url.strip() for url in input_urls.split(",")]

    pipeline = getenv("PIPELINES")
    if not pipeline:
        raise ValueError("PIPELINES must be set as a comma-separated string.")

    pipeline_list = [p.strip() for p in pipeline.split(",")]

    session = requests.Session()
    scancodeio_url = getenv("SCANCODEIO_URL", "").rstrip("/")
    if not scancodeio_url:
        raise ValueError("SCANCODEIO_URL is required")

    api_key = getenv("SCANCODEIO_API_KEY")
    if api_key:
        session.headers.update({"Authorization": f"Token {api_key}"})

    projects_api_url = f"{scancodeio_url}/api/projects/"
    project_data = {
        "name": project_name,
        "input_urls": input_urls_list,
        "pipeline": pipeline_list,
        "execute_now": True,
    }

    response = session.post(projects_api_url, json=project_data)
    response.raise_for_status()
    print(response.json())

if __name__ == "__main__":
    main()
