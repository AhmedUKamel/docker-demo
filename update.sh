#!/bin/bash

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --commit-message)
          COMMIT_MESSAGE="$2"
          shift
          shift
          ;;
        --version)
          VERSION="$2"
          shift
          shift
          ;;
        *)
          echo "Unknown option: $key"
          exit 1
          ;;
    esac
done

print_status() {
    echo "$(date +"%Y-%m-%d %T"): $1"
}

if [ -z "$COMMIT_MESSAGE" ]; then
    print_status "Commit message is required."
    exit 1
fi

if [ -z "$VERSION" ]; then
    print_status "version number is required."
    exit 1
fi

# Constants
PROJECT_DIRECTORY="/media/Linux_Partition/Projects/static-demo"
SSH_HOST="191.101.2.187"
SSH_USERNAME="root"
DOCKER_IMAGE_NAME="ahmedukamel/demo"

# Change directory to project directory
print_status "Changing directory to project directory ..."
cd "$PROJECT_DIRECTORY" || { print_status "Changing directory failed."; exit 1; }

# Maven clean
print_status "Running Maven clean ..."
./mvnw clean >> /tmp/maven_clean_output.txt || { print_status "Maven clean failed."; exit 1; }

# Maven package
print_status "Running Maven package ..."
./mvnw package -DskipTests >> /tmp/maven_package_output.txt || { print_status "Maven package failed."; exit 1; }

# Building docker image
print_status "Building $DOCKER_IMAGE_NAME:$VERSION ..."
docker build -t "$DOCKER_IMAGE_NAME:$VERSION" . >> /tmp/docker_build_output.txt || { print_status "Docker build failed."; exit 1; }

# Pushing docker image
print_status "Pushing docker image -> $DOCKER_IMAGE_NAME:$VERSION ..."
docker push "$DOCKER_IMAGE_NAME:$VERSION" >> /tmp/docker_push_output.txt || { print_status "Docker push failed."; exit 1; }

# Tagging docker image as latest
print_status "Tagging docker image as latest ..."
docker tag "$DOCKER_IMAGE_NAME:$VERSION" "$DOCKER_IMAGE_NAME:latest" >> /tmp/docker_push_output.txt || { print_status "Docker tag failed."; exit 1; }

# Pushing docker image (latest)
print_status "Pushing docker image -> $DOCKER_IMAGE_NAME:latest ..."
docker push "$DOCKER_IMAGE_NAME:latest" >> /tmp/docker_push_output.txt || { print_status "Docker push failed."; exit 1; }

# Add changes
print_status "Adding changes ..."
git add . || { print_status "Git add failed."; exit 1; }

print_status "Committing changes with message: $COMMIT_MESSAGE"
git commit -m "$COMMIT_MESSAGE" >> /tmp/git_commit_output.txt || { print_status "Git commit failed."; exit 1; }

# Push changes
print_status "Pushing changes..."
git push >> /tmp/git_push_output.txt 2>&1 || { print_status "Git push failed."; exit 1; }

# SSH to remote server and run specific bash file
print_status "SSHing to remote server and running specific bash file..."
ssh "$SSH_USERNAME@$SSH_HOST" "bash /root/update.sh" >> /tmp/ssh_bash_output.txt || { print_status "SSH connection to remote server failed."; exit 1; }

print_status "Process completed successfully."
exit 0;