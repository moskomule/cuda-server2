ARG image_name
FROM ${image_name}

USER root
ARG user_name
RUN usermod -l ${user_name} -s /bin/zsh user

USER ${user_name}
RUN echo "export PATH=$HOME/.miniconda/bin:$HOME/.linuxbrew/bin:$PATH" >> $HOME/.zshrc

USER root
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]