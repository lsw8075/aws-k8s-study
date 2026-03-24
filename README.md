
## 기본 셋팅 절차

### terraform 설치
```
# 필수 패키지 설치 및 HashiCorp GPG 키 등록
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

# HashiCorp 저장소 추가
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Terraform 설치
sudo apt-get update && sudo apt-get install terraform

# 설치 확인
terraform -version
```

### AWS CLI 설치

```
# 설치 파일 다운로드 및 압축 해제
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip

# 설치 실행
sudo ./aws/install

# 설치 확인
aws --version
```

### kubectl 설치

```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# 설치 확인
kubectl version --client
```

### AWS 인증 설정

AWS 인증 설정 (Credentials)
Terraform이 내 AWS 계정에 접속해서 리소스를 만들 수 있게 "열쇠"를 줘야 합니다.

AWS Console 접속 → IAM 서비스 이동.

사용자(User) 생성 후 Access Key와 Secret Access Key를 발급받습니다. (권한은 AdministratorAccess 권한이 필요합니다.)

터미널에 아래 명령어를 입력하고 정보를 넣습니다.
```
Bash
aws configure
# AWS Access Key ID [None]: 발급받은 키 입력
# AWS Secret Access Key [None]: 발급받은 비밀키 입력
# Default region name [None]: ap-northeast-2 (서울)
# Default output format [None]: json

```
### Terraform apply 이후
```
Bash
aws eks update-kubeconfig --region ap-northeast-2 --name {kihoon-eks-cluster}
```
