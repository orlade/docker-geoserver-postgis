FROM kartoza/geoserver
MAINTAINER Oliver Lade <piemaster21@gmail.com>

ADD config.sh /opt/config.sh

CMD ["/opt/config.sh"]
