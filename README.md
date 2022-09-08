# docker_cutom_pytorch
Deeplearning, Computer vision, ML을 위한 All-in-one docker 환경제작. due-ke custom.


## Spec:
- [x] ML, CV, DL 모두 무리없이 동작하도록 환경을 구성
- [x] 리눅스 기본 명령어 및 응용 프로그램도 apt-get으로 설치
- [x] 도커 동작시, 컨테이너에서 root로 접속하게 되는데 이 경우 특정 프로그램을 설치할때 root 권한이 방해가 되는 경험이 기억남. 사용자를 직접 추가하여 호스트 서버의 UID와 동일하도록 제작하며 필요시 `sudo su`로 root에 접속가능하도록 구현
- [x] jupyter notebook도 설치하여 jupyter를 컨테이너 내에 접속가능하도록 구현

## 제작 방법:
docker hub에 있는 torch최신버전(runtime ver.)을 base로 필요 환경 설정하는 dockerfile을 생성

## 사용 방법:
1. 디렉토리로 이동
1. Dockerfile 수정
   * UID 변경 : host UID입력
   * username 설정 : 하고픈 이름
   * 기타 필요 라이브러리는 스크립트 추가/수정
2. Dockerfile을 build
   ```bash
   # docker build -t {YOUR TAG NAME} .
   docker build -t ke_torch_1.11 .
   ```
3. Container 생성
   * 아래 실행 명령어 옵션은 예제를 보고 필요한것만 따서 실행.
   ```bash
   # GPU driver 존재시, server환경에서 portforward 설정 필요시
   # docker run -it -d -gpus all --ipc=host -u $(id -u):$(id -g) -v {HOSTDIR}:{CONTAINER DIR} -p {H PORT}:{C PORT} --name {YOUR CONTAINER NAME} {YOUR TAG NAME}
   docker run -it -d --gpus all --ipc=host  -u $(id -u):$(id -g) -v /data:/data -p 8901:8888 -p 8902:16006 --name ke_torch ke_torch_1.11

   # GPU driver 없고 컴퓨터 재부팅시 자동 container 실행 필요시
   # docker run -it -d --restart=unless-stopped --ipc=host -u $(id -u):$(id -g) -v {HOSTDIR}:{CONTAINER DIR} -p {H PORT}:{C PORT} --name {YOUR CONTAINER NAME} {YOUR TAG NAME}
   docker run -it -d --restart=unless-stopped --ipc=host  -u $(id -u):$(id -g) -v /data:/data -p 8888:8888 -p 16006:16006 --name ke_torch ke_torch_1.11
   ```
4. 접속
   ```bash
   # docker exec -it {YOUR CONTAINER NAME} bash
   docker exec -it ke_torch bash
   ```
5. jupyter background 실행
   * 기본 password : ducke
     * 필요시, container 내부에서 변경가능
     ```bash
     jupyter notebook password
     ```
   * jupyter 실행
     * contrainer 내부에서 jupyter 실행 후, 웹브라우저에서 접속
   ```bash
   # screen 혹은 tmux 추천
   jupyter notebook
   ```
   * 웹 브라우저 접속
   ```bash
   # http://localhost:{YOUR PORT NUM}
   http://localhost:8888
   ```
