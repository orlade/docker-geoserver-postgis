# docker-geoserver-postgis

<a href="https://hub.docker.com/r/orlade/docker-geoserver-postgis/">
![Docker PostGIS and GeoServer logo](http://i.imgur.com/clmgpAg.png)

**orlade/docker-geoserver-postgis** on Docker Hub
</a>

Docker image for an instance of GeoServer with a connection to a remote PostGIS data store.
Builds on the [kartoza/geoserver][dockerhub] image ([GitHub][github]).

Provide the following environment variables at runtime to configure the connection to PostGIS:

* `PG_HOSTNAME`: The hostname of the PostgreSQL database server.
* `PG_PORT`: The port of the PostgreSQL database server that PostgreSQL is serving on.
* `PG_USERNAME` : The username of the PostgreSQL user used by the app.
* `PG_PASSWORD`: The password of the PostgreSQL user used by the app.
* `PG_DATABASE`: The name of the PostgreSQL database to connect to.

Note that the PostgreSQL and GeoServer passwords will be stored in plain text within the container.

You can optionally provide the following environment variables to configure GeoServer as well:

* `GEOSERVER_PASSWORD`: The password for the GeoServer admin user. Defaults to "geoserver".
* `GEOSERVER_WORKSPACE`: The workspace to set up for the app. Defaults to `PG_DATABASE`.
* `GEOSERVER_NAMESPACE`: The namespace to use within the workspace. Defaults to
  `http://$GEOSERVER_WORKSPACE.com`.
* `GEOSERVER_NAMESPACE_ID`: The ID of the new namespace. Defaults to `GEOSERVER_WORKSPACE`.
* `GEOSERVER_DATASTORE`: The name of the datastore to create in the workspace. Defaults to


[dockerhub]: https://hub.docker.com/r/kartoza/geoserver/
[github]: https://github.com/kartoza/docker-geoserver
