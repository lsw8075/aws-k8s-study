
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
