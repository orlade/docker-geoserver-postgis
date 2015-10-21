#!/bin/bash
# Sets up a workspace for a remote PostGIS database, and substitutes the sensitive properties (like
# username and password) from environment variables. Refer to the README for details.

GEOSERVER_WORKSPACE=${GEOSERVER_WORKSPACE=$PG_DATABASE}
GEOSERVER_NAMESPACE=${GEOSERVER_NAMESPACE=http://${GEOSERVER_WORKSPACE}.com}
GEOSERVER_NAMESPACE_ID=${GEOSERVER_NAMESPACE_ID=$GEOSERVER_WORKSPACE}
GEOSERVER_DATASTORE=${GEOSERVER_DATASTORE=$GEOSERVER_WORKSPACE}
GEOSERVER_PASSWORD=${GEOSERVER_PASSWORD=geoserver}

if [ ! -d $GEOSERVER_HOME/data_dir/workspaces/$GEOSERVER_WORKSPACE ] ; then
  echo "Configuring GEOSERVER_WORKSPACE and datastore $GEOSERVER_DATASTORE..."
  mkdir -p $GEOSERVER_HOME/data_dir/workspaces/$GEOSERVER_WORKSPACE
  cd $GEOSERVER_HOME/data_dir/workspaces/$GEOSERVER_WORKSPACE

  echo "Adding workspace $GEOSERVER_WORKSPACE..."
  echo "<workspace><id>$GEOSERVER_WORKSPACE</id><name>$GEOSERVER_WORKSPACE</name></workspace>" > workspace.xml

  echo "Adding namespace $GEOSERVER_WORKSPACE..."
  echo "<namespace><id>$GEOSERVER_NAMESPACE_ID</id><prefix>$GEOSERVER_WORKSPACE</prefix><uri>$GEOSERVER_NAMESPACE</uri></namespace>" > namespace.xml

  echo "Adding datastore $GEOSERVER_DATASTORE to $PG_HOSTNAME:$PG_PORT..."
  mkdir $GEOSERVER_WORKSPACE
  DATASTORE_CONFIG=`cat <<EOF
<dataStore>
  <id>$GEOSERVER_WORKSPACE</id>
  <name>$GEOSERVER_DATASTORE</name>
  <type>PostGIS</type>
  <enabled>true</enabled>
  <namespace>
    <id>$GEOSERVER_NAMESPACE_ID</id>
  </namespace>
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
  echo $DATASTORE_CONFIG > $GEOSERVER_WORKSPACE/datastore.xml

  echo "Setting GeoServer password to \$GEOSERVER_PASSWORD..." # Don't print the actual password.
  USERS_FILE=$GEOSERVER_HOME/data_dir/security/usergroup/default/users.xml
  sed -i "s/password=\"[^\"]*\"/password=\"plain:$GEOSERVER_PASSWORD\"/g" $USERS_FILE

  cd $GEOSERVER_HOME
  echo "GeoServer configuration complete"
fi

echo "Starting GeoServer..."
$GEOSERVER_HOME/bin/startup.sh
