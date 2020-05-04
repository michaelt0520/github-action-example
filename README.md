# Introduction CI

* Chúng ta tiến hành thêm thư mục .circleci vào root của project và bên trong tạo file config.yml

* Circle có cung cấp các mẫu sample cho tùy từng ngôn ngữ mà dự án đó sử dụng.
Ở đây mình lấy ra sample config của project ruby on rails:

```
# Ruby CircleCI 2.0 configuration file
#
# Check https://circleci.com/docs/2.0/language-ruby/ for more details
#
version: 2
jobs:
  build:
    docker:
      # specify the version you desire here
       - image: circleci/ruby:2.4.1-node-browsers
      
      # Specify service dependencies here if necessary
      # CircleCI maintains a library of pre-built images
      # documented at https://circleci.com/docs/2.0/circleci-images/
      # - image: circleci/postgres:9.4

    working_directory: ~/repo

    steps:
      - checkout

      # Download and cache dependencies
      - restore_cache:
          keys:
          - v1-dependencies-{{ checksum "Gemfile.lock" }}
          # fallback to using the latest cache if no exact match is found
          - v1-dependencies-

      - run:
          name: install dependencies
          command: |
            bundle install --jobs=4 --retry=3 --path vendor/bundle

      - save_cache:
          paths:
            - ./vendor/bundle
          key: v1-dependencies-{{ checksum "Gemfile.lock" }}
        
      # Database setup
      - run: bundle exec rake db:create
      - run: bundle exec rake db:schema:load

      # run tests!
      - run:
          name: run tests
          command: |
            mkdir /tmp/test-results
            TEST_FILES="$(circleci tests glob "spec/**/*_spec.rb" | circleci tests split --split-by=timings)"
            
            bundle exec rspec --format progress \
                            --format RspecJunitFormatter \
                            --out /tmp/test-results/rspec.xml \
                            --format progress \
                            $TEST_FILES

      # collect reports
      - store_test_results:
          path: /tmp/test-results
      - store_artifacts:
          path: /tmp/test-results
          destination: test-results
```


Gồm có 2 phần chính là docker và steps

Tiếp đó phần steps là các bước lần lượt mà chúng ta sẽ chạy cho project của chúng ta, cụ thể:

- **checkout** - Clone code từ github - đây là lệnh mặc định của CircleCI.
- **run:** [lệnh] - Các lệnh cần thực hiện.
- **restore_cache** - Khôi phục lại folder chứa cái package (vendor/) dựa trên file composer.lock
- **save_cache** - Lưu lại folder vendor nesu file composer.lock bị thay đổi hay do bạn xóa hoặc thêm package mới.
