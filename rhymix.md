# Rhymix ECR 셋팅법

## 이미지 만들기

### docker 설치

```
sudo apt update
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
```

### rhymix 다운로드

```
git clone https://github.com/rhymix/rhymix.git
```

### Dockerfile 작성
`rhymix/Dockerfile` 에 다음 내용 작성

```
FROM php:8.1-fpm

# 필수 PHP 확장 설치
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libzip-dev unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo_mysql zip opcache

# 소스 코드 복사
COPY . /var/www/html/

# 권한 설정
RUN chown -R www-data:www-data /var/www/html

# FPM은 기본적으로 9000 포트를 사용합니다.
EXPOSE 9000
```

### ECR repo 생성 및 docker 로그인
<AWS_ACCOUNT_ID> 부분은 12자리 ID로 대체할 것.
```
aws ecr create-repository --repository-name rhymix-repo --region ap-northeast-2
aws ecr get-login-password --region ap-northeast-2 | sudo docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.ap-northeast-2.amazonaws.com
```

### docker 이미지 만들고 push
```
# 1. Rhymix 전용 이미지 빌드
sudo docker build -t rhymix-fpm .

# 2. 태그 지정
sudo docker tag rhymix-fpm:latest <AWS_ACCOUNT_ID>.dkr.ecr.ap-northeast-2.amazonaws.com/rhymix-repo:latest

# 3. 푸시
sudo docker push <AWS_ACCOUNT_ID>.dkr.ecr.ap-northeast-2.amazonaws.com/rhymix-repo:latest
```

