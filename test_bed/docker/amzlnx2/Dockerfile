FROM docker.io/blutv/amazonlinux2-python3:latest
LABEL maintainer="tuongdevops1@gmail.com" 
COPY .bashrc /.bashrc
COPY .bashrc_eu_west_2 /.bashrc_eu_west_2
COPY .bashrc_us_east_2 /.bashrc_us_east_2
RUN  yum update -y yum-skip-broken && yum -y install bind bind-utils nmap bash-completion
#RUN source /.bashrc
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip &&  ./aws/install
RUN curl -LO https://dl.k8s.io/release/v1.25.0/bin/linux/amd64/kubectl &&  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

CMD ["/bin/bash", "-c", "sleep 100000d"]