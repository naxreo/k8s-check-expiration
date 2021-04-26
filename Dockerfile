## named k8s_check_expiration
FROM idock.daumkakao.io/kakaobase/u18_base:latest
RUN apt update; apt install -y curl openssl; apt upgrade -y;
COPY ./check_expiration.sh /check_expiration.sh
RUN chmod +x /check_expiration.sh

CMD ["/bin/sh", "-c", "/check_expiration.sh noti"]