ARG image_name
FROM ${image_name}

USER root
ARG user_name
RUN usermod -l ${user_name} -s /bin/zsh user 

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]