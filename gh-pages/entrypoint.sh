#!/bin/sh -l

set -e

if [ -z "$ACCESS_TOKEN" ]
then
  echo "저장소에 접근할 수 있는 Github Personal Access Token을 입력 하세요."
  exit 1
fi

if [ -z "$FOLDER" ]
then
  echo "문서 코드가 저장된 폴더명을 입력하세요. (ex. dist)"
  exit 1
fi

case "$FOLDER" in /*|./*)
  echo "폴더명에는 '/' 또는 './'가 포함될 수 없습니다."
  exit 1
esac

if [ -z "$BRANCH" ]
then
  BRANCH="gh-pages"
fi

if [ -z "$BASE_BRANCH" ]
then
  BASE_BRANCH="master"
fi

if [ -z "$COMMIT_EMAIL" ]
then
  COMMIT_EMAIL="${GITHUB_ACTOR}@users.noreply.github.com"
fi

if [ -z "$COMMIT_NAME" ]
then
  COMMIT_NAME="${GITHUB_ACTOR}"
fi

# git 명령어 설치
apt-get update && \
apt-get install -y git && \

# 깃헙 워크스페이스로 이동
cd $GITHUB_WORKSPACE && \

# git 설정
git init && \
git config --global user.email "${COMMIT_EMAIL}" && \
git config --global user.name "${COMMIT_NAME}" && \

# 저장소 경로 지정
REPOSITORY_PATH="https://${ACCESS_TOKEN}@github.com/${GITHUB_REPOSITORY}.git" && \

# 배포 브랜치가 없으면 새로 생성
if [ "$(git ls-remote --heads "$REPOSITORY_PATH" "${BRANCH}" | wc -l)" -eq 0 ];
then
  echo "배포 브랜치(${BRANCH})를 생성합니다...\n"
  git checkout $BASE_BRANCH && \
  git checkout --orphan $BRANCH && \
  git rm -rf . && \
  touch README.md && \
  git add README.md && \
  git commit -m "Initial $BRANCH commit" && \
  git push $REPOSITORY_PATH $BRANCH
fi

# 기본 브랜치 체크아웃
git checkout $BASE_BRANCH && \

# 빌드 스크립트 실행
echo "빌드 스크립트를 실행합니다... ${BUILD_SCRIPT}\n" && \
# eval "$BUILD_SCRIPT" && \
yarn && yarn build && \

# 커스텀 도메인 설정
if [ "$CNAME" ]; then
  echo "$FOLDER 폴더에 CNAME 파일을 생성합니다...\n"
  echo $CNAME > $FOLDER/CNAME
fi

# 배포 브랜치에 배포
echo "배포 브랜치(${BRANCH})에 배포합니다...\n" && \
git add -f $FOLDER && \

git commit -m "Deploying to $BRANCH - $(date +"%T")" && \
git push $REPOSITORY_PATH `git subtree split --prefix $FOLDER ${BASE_BRANCH}`:$BRANCH --force && \

echo "Github Pages 배포가 완료되었습니다.\n"