FROM kartoza/geoserver
MAINTAINER Oliver Lade <piemaster21@gmail.com>

ENV GEO_WORKSPACE=cite
ENV GEO_STORE_NAME=$PG_USERNAME

# Add a configuration file defining a data store with the same name as the PostgreSQL user.
RUN echo "<dataStore>
  <id>$GEO_STORE_NAME</id>
  <name>$GEO_STORE_NAME</name>
  <type>PostGIS</type>
  <enabled>true</enabled>
  <connectionParameters>
    <entry key="dbtype">postgis</entry>
    <entry key="user">$PG_USERNAME</entry>
    <entry key="passwd">$PG_PASSWORD</entry>
    <entry key="host">$PG_HOSTNAME</entry>
    <entry key="port">$PG_PORT</entry>
    <entry key="database">$PG_DATABASE</entry>
    
    <!-- Default parameters -->
  </connectionParameters>
</dataStore>" > $GEOSERVER_HOME/data_dir/workspaces/$GEO_WORKSPACE/$GEO_STORE_NAME
