# Github Pages Action

깃헙 페이지 배포용 액션

## 사용법

```yml
name: Build and Deploy
on:
push:
  branches:
  - master
jobs:
build-and-deploy:
  runs-on: ubuntu-latest
  steps:
  - name: Checkout
  uses: actions/checkout@master

  - name: Build and Deploy
  uses: wooritech/github-actions/gh-pages@master
  env:
    ACCESS_TOKEN: ${{ secrets.ACCESS_TOKEN }}
    BRANCH: gh-pages
    FOLDER: docs
    BUILD_SCRIPT: npm install && npm run build
    CNAME: docs.wooritech.com # 생략가능
```
