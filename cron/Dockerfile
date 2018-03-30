FROM ide_os:latest

ARG USER=mzheng

USER root:root
WORKDIR /root

RUN echo "*/5 *   * * *   $USER   bin/generate-ctags 2>&1 > /tmp/cron-generate-ctags.log" >> /etc/crontab

CMD cron -f
