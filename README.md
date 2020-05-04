
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

on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

jobs:
  run_rspec:

    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:11.5
        ports: ["5432:5432"]
        options: --health-cmd pg_isready --health-interval 10s --health-timeout 5s --health-retries 5

    steps:
    - uses: actions/checkout@v2
    - name: Set up Ruby
      uses: ruby/setup-ruby@ec106b438a1ff6ff109590de34ddc62c540232e0
      with:
        ruby-version: 2.6.5

    - name: Install app
      env:
        PGHOST: localhost
        PGUSER: postgres
        RAILS_ENV: test
      run: |
        gem install bundler
        bundle install --jobs 4 --retry 3
        bin/rails db:setup

    - name: Run Tests
      env:
        PGHOST: localhost
        PGUSER: postgres
        RAILS_ENV: test
      run: bundle exec rspec
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
