# docker-geoserver-postgis

[**orlade/docker-geoserver-postgis** on Docker Hub][image]

Docker image for an instance of GeoServer with a connection to a remote PostGIS data store.
Builds on the [kartoza/geoserver][dockerhub] image ([GitHub][github]).

Provide the following environment variables at runtime to configure the connection to PostGIS:

* `PG_HOSTNAME`
* `PG_PORT`
* `PG_USERNAME` 
* `PG_PASSWORD`

Note that the password will be stored in plain text within the container.

[image]: https://hub.docker.com/r/orlade/docker-geoserver-postgis/
[dockerhub]: https://hub.docker.com/r/kartoza/geoserver/
[github]: https://github.com/kartoza/docker-geoserver
