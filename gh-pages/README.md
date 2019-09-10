# Github Pages Action

깃허브 페이지 배포용 액션

## 시작하기

```yml
name: Build and Deploy

on:
push:
  branches:
  - master

jobs:
build-and-deploy:
  runs-on: ubuntu-18.04

  steps:
  - name: Checkout
  uses: actions/checkout@v1

  - name: Build and Deploy
  uses: wooritech/github-actions/gh-pages@master
  env:
    ACCESS_TOKEN: ${{ secrets.ACCESS_TOKEN }}
    BUILD_SCRIPT: npm install && npm run build
    FOLDER: docs
```

## 옵션

| Key | Value Information | Type | Required |
| ------------- | ------------- | ------------- | ------------- |
| `ACCESS_TOKEN` | 깃헙 브랜치에 접근할 수 있는 [personal access token](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line)을 지정합니다. **토큰 정보는 반드시 secret으로 저장되야합니다.** | `secrets` | **Yes** |
| `FOLDER`  | 문서가 저장된 폴더의 경로를 지정합니다. **폴더 경로는 `/` 또는 `./`로 시작할 수 없습니다**. | `env` | **Yes** |
| `BRANCH` | 문서를 배포할 최종 브랜치를 지정합니다. (기본값: `gh-pages`)  | `env` | **No** |
| `BASE_BRANCH` | 배포하기 전에 원본 코드를 가져올 브랜치를 지정합니다. (기본값: `master`)  | `env` | **No** |
| `BUILD_SCRIPT` | 문서를 생성하기 위한 쉘기반 빌드 명령을 지정합니다. (npm, yarn 지원)| `env` | **No** |
| `CNAME` | [커스텀 도메인](https://help.github.com/en/articles/using-a-custom-domain-with-github-pages)을 지정합니다. (예시: `docs.example.com` | `env` | **No** |
| `COMMIT_NAME` | 커밋에 사용할 이름을 지정합니다. (기본값: gihtub 유저명) | `env` | **No** |
| `COMMIT_EMAIL` | 커밋에 사용할 이메일을 지정합니다. (기본값: `username@users.noreply.github.com`) | `env` | **No** |

## 라이선스

- [MIT License](./LICENSE)
