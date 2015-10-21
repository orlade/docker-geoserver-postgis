# docker-geoserver-postgis

[**orlade/docker-geoserver-postgis** on Docker Hub][image]

Docker image for an instance of GeoServer with a connection to a remote PostGIS data store.
Builds on the [kartoza/geoserver][dockerhub] image ([GitHub][github]).

Provide the following environment variables at runtime to configure the connection to PostGIS:

* `PG_HOSTNAME`: The hostname of the PostgreSQL database server.
* `PG_PORT`: The port of the PostgreSQL database server that PostgreSQL is serving on.
* `PG_USERNAME` : The username of the PostgreSQL user used by the app.
* `PG_PASSWORD`: The password of the PostgreSQL user used by the app.
* `PG_DATABASE`: The name of the PostgreSQL database to connect to.
* `GEOSERVER_PASSWORD`: The password for the GeoServer admin user. Default is "geoserver".

Note that the PostgreSQL and GeoServer passwords will be stored in plain text within the container.

[image]: https://hub.docker.com/r/orlade/docker-geoserver-postgis/
[dockerhub]: https://hub.docker.com/r/kartoza/geoserver/
[github]: https://github.com/kartoza/docker-geoserver
