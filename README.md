
![](https://images.viblo.asia/d2359817-5d94-4aa3-b847-8ec46d8bf0dc.png)

# Github Actions là gì?
- Github Actions cho phép chúng ta tạo workflows vòng đời phát triển phần mềm cho dự án trực tiếp trên Github repository của chúng ta

- Github Actions giúp chúng ta tự động hóa quy trình phát triển phần mềm tại nơi chúng ta lưu trữ code và kết hợp với pull request và issues. Chúng ta có thể viết các tác vụ riêng lẻ, được gọi là các actions và kết hợp các actions đó lại với nhau để tạo ra một workflow theo ý của chúng ta. Workflow là các tiến trình tự động mà bạn có thể thiết lập trong repository của mình để build, test, publish package, release, hoặc deploy dự nào trên Github

- Với Github Actions chúng ta có thể tích hợp continuous integration (CI) và continuous deployment (CD) trực tiếp trên repository của mình

# Sử dụng Github Actions run rspec dự án
- Workflow của dự án sẽ được lưu trong folder **.github/workflows/**
Chúng ta tạo một **file .yml** trong folder workflow ( ví dụ: **github-pages.yml** ) hoặc vào repository trên github vào tab Actions vào vào bấm vào Set up workflow yourself, với nội dung file như sau:

```
name: Ruby

on: [pull_request]
  # push:
  #   branches: [ master ]
  # pull_request:
  #   branches: [ master ]

jobs:
  run_rspec:

    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres:11.5
        ports: ["5432:5432"]
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
    - uses: actions/checkout@v2
    - name: Set up Ruby
      uses: ruby/setup-ruby@ec106b438a1ff6ff109590de34ddc62c540232e0
      with:
        ruby-version: 2.6.5
    - name: Build and test with Rake
      env:
        PGHOST: localhost
        PGUSER: postgres
        RAILS_ENV: test
      run: |
        gem install bundler
        bundle install --jobs 4 --retry 3
        bundle exec rails db:create
        bundle exec rails db:migrate
        bundle exec rspec
```

Một workflow được tạo thành từ một hoặc nhiều job. Jobs chạy song song theo mặc định. Để chạy các job một cách tuần tự, bạn có thể xác định các dependencies vào các job khác bằng cách jobs.<job_id>.needs keyword. Mỗi job chạy trong một phiên bản mới của môi trường ảo được chỉ định bởi runs-on.
Ở đây chúng ta sử dụng ubuntu-latest
Ở trong phần steps:

```
- name: Build
  run: |
  	npm install
   	npm run-script build
```

# Creating and storing encrypted secrets
- Encrypted secrets allow you to store sensitive information, such as access tokens, in your repository.

> Secrets are encrypted environment variables that you create in a repository for use with GitHub Actions. GitHub uses a libsodium sealed box to help ensure that secrets are encrypted before they reach GitHub, and remain encrypted until you use them in a workflow

> **Warning:** GitHub automatically redacts secrets printed to the log, but you should avoid printing secrets to the log intentionally.

### Creating encrypted secrets
**1.** On GitHub, navigate to the main page of the repository.

**2** Under your repository name, click  **Settings**.
![](https://help.github.com/assets/images/help/repository/repo-actions-settings.png)

**3** In the left sidebar, click Secrets

**4** Type a name for your secret in the "Name" input box.

**5** Type the value for your secret.

**6** Click Add secret.

### Using encrypted secrets in a workflow

```
steps:
  - name: Hello world action
    with: # Set the secret as an input
      super_secret: ${{ secrets.SuperSecret }}
    env: # Or as an environment variable
      super_secret: ${{ secrets.SuperSecret }}
```

Example using Bash

```
steps:
  - shell: bash
    env:
      SUPER_SECRET: ${{ secrets.SuperSecret }}
    run: |
      example-command "$SUPER_SECRET"
```

# ssh deployments
This GitHub Action deploys specific directory from GITHUB_WORKSPACE to a folder on a server via rsync over ssh

This action would usually follow a build/test action which leaves deployable code in **GITHUB_WORKSPACE**, eg dist;

## Configuration
Pass configuration with env vars

**SSH-PRIVATE_KEY [required]**

This should be the private key part of an ssh key pair. The public key part should be added to the authorized_keys file on the server that receives the deployment.

The keys should be generated using the PEM format. You can us this command
`ssh-keygen -m PEM -t rsa -b 4096`

**REMOTE_HOST [required]**

`eg: mydomain.com`

**REMOTE_USER [required]**

`eg: myusername`

**REMOTE_PORT (optional, default '22')**

`eg: '59184'`

**ARGS (optional, default '-rltgoDzvO')**

`For any initial/required rsync flags, eg: -avzr --delete`

**SOURCE (optional, default '')**

`The source directory, path relative to $GITHUB_WORKSPACE root, eg: dist/`

**TARGET (optional, default '/home/REMOTE_USER/')**

`The target directory`

## Usage

```
  - name: Deploy to Staging server
    uses: easingthemes/ssh-deploy@v2.0.7
    env:
      SSH_PRIVATE_KEY: ${{ secrets.SERVER_SSH_KEY }}
      ARGS: "-rltgoDzvO"
      SOURCE: "dist/"
      REMOTE_HOST: ${{ secrets.REMOTE_HOST }}
      REMOTE_USER: ${{ secrets.REMOTE_USER }}
      TARGET: ${{ secrets.REMOTE_TARGET }}
```

## Example usage in workflow

```
name: Node CI

on: [push]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v1
    - name: Install Node.js
      uses: actions/setup-node@v1
      with:
        node-version: '10.x'
    - name: Install npm dependencies
      run: npm install
    - name: Run build task
      run: npm run build --if-present
    - name: Deploy to Server
      uses: easingthemes/ssh-deploy@v2.1.1
      env:
          SSH_PRIVATE_KEY: ${{ secrets.SERVER_SSH_KEY }}
          ARGS: "-rltgoDzvO --delete"
          SOURCE: "dist/"
          REMOTE_HOST: ${{ secrets.REMOTE_HOST }}
          REMOTE_USER: ${{ secrets.REMOTE_USER }}
          TARGET: ${{ secrets.REMOTE_TARGET }}
```
