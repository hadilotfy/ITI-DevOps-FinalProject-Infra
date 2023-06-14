FROM hadilotfy/jenkins-ubuntu-slave:v0

RUN echo "jenkins:0000" | chpasswd

ENTRYPOINT ["bash"]
CMD ["-c"," service ssh start  ; tail -f /dev/null"]
