import json
import os
import shutil
from git import Repo
from tempfile import mkdtemp

# Function to clone the repository and get commit messages
def get_commit_messages(repo_url):
    temp_dir = mkdtemp()  # Create a temporary directory
    commits = []

    try:
        repo = Repo.clone_from(repo_url, temp_dir)  # Clone the repository
        for commit in repo.iter_commits():
            commits.append({
                'hash': commit.hexsha,
                'message': commit.message.strip().split('\n')[0]  # Get the first line of commit message
            })
    finally:
        shutil.rmtree(temp_dir)  # Remove the temporary directory
    print(json.dumps(commits, indent=4))

    return commits

# Read the JSON file to get the list of repositories
with open('dataset-v1.json', 'r') as file:
    data = json.load(file)

# Process each repository
enriched_data = []
for app in data['apps']:  # Assuming the key to the list of repositories is 'apps'
    repo_url = app['url']  # The key for the repository URL is assumed to be 'repo'
    app_commits = app['commits']

    # Get all commit messages
    all_commits = get_commit_messages(repo_url)

    # Map the commit messages to the existing commit data
    for commit in app_commits:
        commit_hash = commit['tag']  # Assuming that the commit hash is stored under the 'tag' key
        matching_commit = next((c for c in all_commits if c['hash'].startswith(commit_hash) ), None)
        if matching_commit:
            commit['message'] = matching_commit['message']

    enriched_data.append(app)

# Write the enriched data to a new JSON file
with open('enriched_dataset.json', 'w') as file:
    json.dump({'apps': enriched_data}, file, indent=4)

print('Dataset has been enriched and saved as enriched_dataset.json.')
