# Check K8S Expiration of Certification date
kubeadm으로 구축된 kubernetes cluster의 crt 파일을 확인하여 지정된 날짜 안쪽이라면 Watchtower를 보내주는 기능.  

## How to
- kubectl create -f Cronjob.yaml
- EXDAY 만료일까지 남은 기간
  - 90으로 지정 시 만료일 90일 안쪽으로 들어오면 cronjob 실행될때마다 알림 발생
  - WTID로 watchtower 지정

===
check cerificated expired date for self-hosted kubernetes cluster by kubeadm.  

## How to
- working on cronjob based
- use EXDAY environment
  - ex> if EXDAY=90, this pod will send notification since 90 days
- write your own notification api


