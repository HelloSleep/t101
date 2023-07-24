해당 책을 내용을 기반으로 작성 하였습니다
[테라폼으로 시작하는 IaC - YES24](https://www.yes24.com/Product/Goods/119179333)

# Why Terraform

Terraform 을 "잘" 쓰기 위한 기술적인 지식 및 레퍼런스를 얻기 위해 스터디 시작.

Terraform은 IaC(Infrastructure as Code)로서 코드로 쉽게 인프라를 관리할 수 있게 해주는 툴이다.

테라폼을 사용하기 전에 IaC라는 개념을 알고, IaC라는 개념 전에는 DevOps라는 개념까지 안다면 좀 더이해가 쉬울 것이다.

테라폼의 경우 장점만 들은 경우 "원래 하는 일을 쉽게 만드는 툴이니 쓰는 게 무조건 이득 아닌가?"라는 생각이 들 수도 있지만 거기에는 조건이 붙는다. "잘" 써야 한다는 것이다.
테라폼의 경우 선언형이라는 특성으로 선언된 파일과 다를 경우 여러 문제가 발생하게 된다. 즉 코드로 짜놓은 상태를 A라고 했을 때, 간단한 코드이외의 동작으로 A+상태가 된다면 테라폼은 A라고 선언된 상태의 코드와 현재 A+로 선언된 상태의 리소스와 비교하여 에러를 반환하게된다. 추가적으로 여러명이 사용하는 경우 이 상태를 정의하는 코드가 여러개 발생하게 될 수 있는데 그런 경우 상황이 더 복잡하게된다.

이런 대표적인 이유들로 테라폼을 사용해보니 오히려 더 불편해지면서 테라폼을 사용안하게 되는 경우도 발생하니 테라폼을 사용하는 이유를 명확히 하는 것이 테라폼을 시작하기 전 해야할 일이라고 하겠다.

# Structure

레포 구조는 다음과 같다
각 주차 폴더에는 크게 공부한 내용인 베이직폴더, 과제 수행용 챌린지 폴더가 존재

```
.
├── 1week
│   ├── t101-1week-basic
│   │   ├── 03.Start
│   │   │   ├── terraform.tfstate
│   │   │   └── terraform.tfstate.backup
│   │   ├── 03.end
│   │   │   ├── terraform.tfstate
│   │   │   └── terraform.tfstate.backup
│   │   ├── 03.lifecycle
│   │   │   ├── terraform.tfstate
│   │   │   └── terraform.tfstate.backup
│   │   ├── terraform.tfstate
│   │   └── terraform.tfstate.backup
│   └── t101-1week-challenge
│       ├── AWS_provider
│       │   ├── main.tf
│       │   ├── terraform.tfstate
│       │   └── terraform.tfstate.backup
│       ├── ec2-web-server
│       │   ├── main.tf
│       │   ├── terraform.tfstate
│       │   └── terraform.tfstate.backup
│       ├── lifecycle
│       │   ├── main.tf
│       │   ├── terraform.tfstate
│       │   └── terraform.tfstate.backup
│       └── s3-backendfile
│           ├── backend.tf
│           ├── terraform.tfstate
│           └── terraform.tfstate.backup
└── README.md
```
##  1 Week
1주차 요약
- IaC와 테라폼의 개념 학습
- Win/Mac에서의 테라폼 환경 구성
- 기본 사용법
	- init, plan, apply, destroy
	- HCL(HashiCorp configuration language) 테라폼 블록, 버전
	- AWS resource
	- 종속성, lifecycle

각 챌린지에 관해서 사용 사례와 코드의 중요한 부분 위주로만 설명

- 사용 사례
- 코드
- 설명
- (개선점)

### ec2-web-server

사용 사례: EC2를 생성 했을 때 기본적인 패키지가 설치돼 간단 web-server를 동작시킬 때 사용

코드
```
# main.tf
resource "aws_instance" "example" {
  ami                    = "ami-0c9c942bd7bf113a2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash

              apt-get update
              apt-get install apache2 -y
              
              echo "Hello, Minchan" > /var/www/html/index.html
              systemctl enable apache2
              systemctl start apache2

              EOF

  tags = {
    Name = "Single-WebSrv"
  }
}
```
기본적인 linux, ubuntu 커맨드인 apt-get을 활용할 수 있어야 한다. 
참고로 처음 시도시 httpd 패키지를 다운받았으나, 해당 패키지 네임은 적용이 안되 실행이 안 됐었다. 이는 외부에서 봤을 때 표시가 전혀 안되기 때문에 내부에들어가서 오류 확인 후 수정함

개선점: 해당 스크립트가 오류가 발생시 로그 형태로 출력하고 이를 아웃풋으로 확인 하면 굳이 ec2에 들어가지 않아도 확인 할 수 있을듯

### s3-backendfile

사용 사례: terraform 에서 상태를 관리하는 tfstate파일을 협업이 가능하게 특정 remote저장소에서 관리
코드
```
resource "aws_s3_bucket" "mys3bucket" {
  bucket = "minchan-t101study-tfstate"
}
```
설명
해당 S3 관리에서는 AWS s3의명명규칙이 중요한데 글로벌하게 유니크한 값을 가지기에 자주 생길 수 있는 문제로는 이름이 겹치면 다른 사람이 못만든 다는 점이다

### lifecycle
#### 사용 사례
lifecycle 자체가 다양한 상태를 일컫는다.
- create_before_destroy (bool): 리소스 수정 시 신규 리소스를 우선 생성하고 기존 리소스를 삭제
- prevent_destroy (bool): 해당 리소스를 삭제 Destroy 하려 할 때 명시적으로 거부
- ignore_changes (list): 리소스 요소에 선언된 인수의 변경 사항을 테라폼 실행 시 무시
- precondition: 리소스 요소에 선언해 인수의 조건을 검증
- postcondition: Plan과 Apply 이후의 결과를 속성 값으로 검증

그래서 여러 방면에 사용할 수 있는데 이번 챌린지에서는 `특정한 조건을 가진 파일이름으로만 생성` 을 lifecycle에 이용하였다

#### 코드
```
variable "file_list" {

  type    = list(string)

  default = ["step0.txt", "step1.txt", "step2.txt", "step3.txt", "step4.txt", "step5.txt", "step6.txt"]

}

  

variable "file_name" {

  type    = string

  description = "This is file_name value. You should be adhere name convention step[0-6].txt"

}

  

resource "local_file" "abc" {

  content  = "You create ${var.file_name}"

  filename = "${path.module}/${var.file_name}"

  

  lifecycle {

    precondition {

      condition     = contains(var.file_list, var.file_name)

      error_message = "file name is not file_list"

    }

  }

}
```

####  설명
여기서는 큰 흐름을 전부 알아야하기에 코드를 전부 첨부하였다.
첫번째로는 **lifecycle** 블럭의 condition에서 조건을 정의 한다. 이부분은 사람마다 다르게 표현할 수 있다. 예시로는 step[0-6].txt 라는 이름을 가진 파일만 허용하는 조건인데 이를 수동으로 리스트에 선언 하는 방법이 있을 수 있다. 또는 step변수.txt라는 형태도 있을 것이다.

내가 사용한 방법은 **condition** 이라는 테라폼 함수를 사용한 방법이다
추가적으로 입력받은 파일 이름은 변수 처리 및 description을 사용하여 좀더 유연하게 대처할 수 있게 만들었다

#### 개선점
결국위와 같은 방법에서 필요한 조건이 step[0-99].txt와 같은 경우 리스트를 하나하나 선언해주어야 하기에 명확히 step[?].txt라는 양식이 정해져있어서 해당 숫자만 조건을 판단하는 경우 변수처리로 하는 것이 더 나은 방법일 수도 있겠다


### AWS_Provider

#### 사용 사례
이부분에 관해서는 default tag방식을 사용할 수 있다 생각한다. 즉 aws의 리소스를 생성할 때 모든 리소스에 일일히 태그를 다는 것이아닌 생성부터 정해진 태그를 첨부하는 방식으로 사용할 수 있을 것이다

#### 코드
```
provider "aws" {

  default_tags {

    tags = {

      Environment = "Test"

      Name        = "Provider Tag"

    }

  }

}

  

resource "aws_vpc" "example" {

  cidr_block = "20.0.0.0/16"

  tags = {

    Environment = "Production"

  }

}


```

#### 설명
provier레벨에서 선언된 태그속성에 의해 aws 리소스는 생성시 해당 태그를 default로 갖게 된다. 단 리소스레벨에서 같은 속성에 대한 선언이 있을경우 해당 리소스레벨의 속성이 우선순위가 더 높아 overriding 하게 된다.
결론적으로 해당 리소스의 태그는
tags
- Environment: Production
- Name: Provider Tag

