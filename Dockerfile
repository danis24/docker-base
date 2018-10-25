FROM ubuntu:xenial
MAINTAINER Danis Yogaswara <danis@aniqma.com>

ENV OS_LOCALE="en_US.UTF-8"
RUN apt-get update && apt-get install -y locales && locale-gen ${OS_LOCALE}
ENV LANG=${OS_LOCALE} \
	LANGUAGE=en_US:en \
	LC_ALL=${OS_LOCALE}

ENV NGINX_DIR=/etc/nginx \
	PHP_CONF_DIR=/etc/php/7.1

RUN	\
	buildDeps='software-properties-common python-software-properties' \
	&& apt-get install --no-install-recommends -y $buildDeps \
	&& add-apt-repository -y ppa:ondrej/php \
	&& apt-get update \
	&& apt-get install -y curl nginx libapache2-mod-php7.1 php7.1-cli php7.1-readline php7.1-mbstring php7.1-zip php7.1-intl php7.1-xml php7.1-json php7.1-curl php7.1-mcrypt php7.1-gd php7.1-pgsql php7.1-mysql php-pear \
	# Nginx settings
	&& a2enmod rewrite php7.1 \
	# PHP settings
	&& phpenmod mcrypt \
	# Install composer
	&& curl -sS https://getcomposer.org/installer | php -- --version=1.4.1 --install-dir=/usr/local/bin --filename=composer \
	# Cleaning
	&& apt-get purge -y --auto-remove $buildDeps locales \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/*

# RUN curl -sL https://repos.influxdata.com/influxdb.key | apt-key add -
# RUN /bin/bash -c "source /etc/lsb-release"
# RUN echo "deb https://repos.influxdata.com/ubuntu bionic stable" | tee /etc/apt/sources.list.d/influxdb.list
RUN apt-get update
RUN apt-get install -y supervisor && service supervisor restart