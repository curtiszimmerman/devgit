
 #################################################################
###    ###    ###    #  ##  #     #     ##     #    #  ####     ###
### ##  #  ##  #  ####  #  ##  ####  ##  #  #####  ##  ####  ######
### ##  #  ##  #  ####    ###     #     ##     ##  ##  ####     ###
### ##  #  ##  #  ####  #  ##  ####  ##  #  #####  ##  ####  ######
###    ###    ###    #  ##  #     #  ##  #  ####    #     #     ###
 #################################################################

FROM alpine:3.6
MAINTAINER curtis zimmerman <software@curtisz.com>

# install software
RUN apk add --no-cache tini openssh-server git
# configure software
RUN mkdir -p /var/run/sshd
COPY ./sshd_config /etc/ssh/sshd_config
RUN ssh-keygen -A

# configure git user
RUN adduser -g "git" -DS -h /home/git -s /usr/bin/git-shell git
RUN passwd -u git
RUN mkdir -p /home/git/.ssh
ARG SSH_KEY
RUN echo "$SSH_KEY" > /home/git/.ssh/authorized_keys
COPY ./no-interactive-login /home/git/git-shell-commands/no-interactive-login
ADD ./test.tar.gz /home/git/repo.git/

EXPOSE 22

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/sbin/sshd", "-D", "-e"]
