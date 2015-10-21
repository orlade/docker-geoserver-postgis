#!/bin/bash
# Sets up a workspace for a remote PostGIS database, and substitutes the sensitive properties (like
# username and password) from environment variables.

WORKSPACE=$PG_USERNAME
NAMESPACE=http://${WORKSPACE}.com

if [ ! -d $GEOSERVER_HOME/data_dir/workspaces/$WORKSPACE ] ; then
  echo "Configuring workspace and datastore $WORKSPACE..."
  cd $GEOSERVER_HOME/data_dir/workspaces
  mkdir $WORKSPACE
  cd $WORKSPACE
  echo "<workspace><id>$WORKSPACE</id><name>$WORKSPACE</name></workspace>" > workspace.xml
  echo "<namespace><id>$WORKSPACE</id><prefix>$WORKSPACE</prefix><uri>$NAMESPACE</uri></namespace>" > namespace.xml
  mkdir $WORKSPACE
  DATASTORE=`cat <<EOF
<dataStore>
  <id>$WORKSPACE</id>
  <name>$WORKSPACE</name>
  <type>PostGIS</type>
  <enabled>true</enabled>
  <workspace>
    <id>$WORKSPACE</id>
  </workspace>
  <connectionParameters>
    <entry key="database">$PG_DATABASE</entry>
    <entry key="host">$PG_HOSTNAME</entry>
    <entry key="port">$PG_PORT</entry>
    <entry key="passwd">$PG_PASSWORD</entry>
    <entry key="dbtype">postgis</entry>
    <entry key="user">$PG_USERNAME</entry>
  </connectionParameters>
  <__default>false</__default>
</dataStore>
EOF
`
  echo $DATASTORE > $WORKSPACE/datastore.xml
  
  cd $GEOSERVER_HOME
  echo "Added configuration for workspace and datastore $WORKSPACE"
fi

echo "Starting GeoServer..."
bin/startup.sh

