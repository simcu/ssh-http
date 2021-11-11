FROM alpine
ENV server_port=22
ENV server_addr=0.0.0.0
ENV server_user=root
ENV server_cert=/id_rsa
RUN apk add --update privoxy openssh \
    && rm -rf /var/cache/apk/* \
    && echo "listen-address 0.0.0.0:8118" > /etc/privoxy/config \
    && echo "forward-socks5 / 127.0.0.1:1080 ." >> /etc/privoxy/config \
    && echo "max-client-connections 1024" >> /etc/privoxy/config \
    && echo "connection-sharing 1" >> /etc/privoxy/config \
    && echo "#!/bin/sh" > /run.sh \
    && echo "privoxy /etc/privoxy/config" >> /run.sh \
    && echo "ssh -ND 0.0.0.0:1080 -p \${server_port} -o StrictHostKeyChecking=no -i \${server_cert} \${server_user}@\${server_addr}" >> /run.sh \
    && chmod +x /run.sh 
ENTRYPOINT ["/run.sh"]
EXPOSE  8118