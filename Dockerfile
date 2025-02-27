# Dockerfile for CaseBox V1, huridocs/casebox fork
# It uses supervisord to manange run and check health of multiple applications
# inside a same docker container, something that could be used when you do not
# have time to optimize or even rewrite part of the application to play nicier
# with docker.
#
# Note: Dockerfile best practices (https://docs.docker.com/develop/develop-images/dockerfile_best-practices)
#       suggest do not use All-in-one containers, but we will just try follow
#       https://github.com/KETSE/casebox/wiki/Ubuntu-14.04-x64
#       instructions for now (fititnt, 2018-04-08 00:48 BRT)
#
# Note: Last note was for CaseBox V1. The public documentation that provably
#       is for V1 branch is https://www.casebox.org/dev/install/
#       (fititnt, 2018-04-13 06:10)

FROM amazonlinux:2

# Install prerequisities for Ansible
RUN yum update -y && \
    yum install -y amazon-linux-extras && \
    amazon-linux-extras install python3 && \
#    PYTHON=python3 amazon-linux-extras enable php8.2 && \
    yum install -y \
#        php-cli \
#        php-pdo \
#        php-fpm \
#        php-json \
#        php-pear \
#        php-gd \
#        php-mbstring \
#        php-opcache \
#        php-zip \
#        unzip \
#        git \
#        rsync \
#        zip \
        nginx \
        python-pip
#        patch && \
#    yum clean all && \
#    rm -rf /var/cache/yum

# Install ansible
RUN pip install ansible

# Copy your ansible configuration into the image
COPY provision/ansible /ansible

# Run ansible to configure things
#RUN ansible-playbook /playbook.yml

WORKDIR /
COPY docker-entrypoint.sh /docker-entrypoint.sh

#RUN ls -lha /var/www/
#RUN ls -lha /var/www/casebox
#RUN ls -lha /var/www/casebox/logs/
#RUN chmod 777 /var/www/casebox/logs/

RUN amazon-linux-extras install php8.2

RUN amazon-linux-extras install nginx1.12

RUN mkdir -p /usr/share/nginx/app && \
    echo "NGINX App Test Page" > /usr/share/nginx/app/index.html && \
    mkdir -p /usr/share/nginx/images && \
    mkdir -p /usr/share/nginx/php && \
    mkdir -p /usr/share/nginx/images && \
    touch /var/log/nginx/access.log

ADD docker/www.conf /etc/php-fpm-7.0.d/www.conf
ADD docker/php-7.0.ini /etc/php-7.0.ini
ADD docker/landing.php /usr/share/nginx/php/landing.php
ADD docker/nginx.png /usr/share/nginx/images/nginx.png
ADD docker/favicon.ico /usr/share/nginx/images/favicon.ico
ADD docker/app.conf /etc/nginx/conf.d/app.conf

EXPOSE 80 8100

CMD php-fpm -d variables_order="EGPCS" && (tail -F /var/log/nginx/access.log &) && exec nginx -g "daemon off;"