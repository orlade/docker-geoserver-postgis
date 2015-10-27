#!/usr/bin/env python
#
# Sets up a workspace for a remote PostGIS database, and substitutes the sensitive properties (like
# username and password) from environment variables. Refer to the README for details.

import os
from distutils.dir_util import mkpath
import re

# Regular expression pattern to match envrionment variables.
ENV_PATTERN = re.compile('\$([A-Za-z0-9_]+)')

DEFAULT_GEOSERVER_USERNAME = 'admin'
DEFAULT_GEOSERVER_PASSWORD = 'geoserver'
GEOSERVER_DATA_DIR = os.path.realpath('%s/data_dir' % os.environ['GEOSERVER_HOME'])

# Environment variables that must be defined for the setup to execute.
REQUIRED_ENVS = ['PG_USERNAME', 'PG_PASSWORD', 'PG_HOSTNAME', 'PG_PORT', 'PG_DATABASE']


def env(var):
    """Simple, short-named getter function for environment variables."""
    return os.environ[var]


def default_env(var, default_value):
    """Sets the environment variable to the default_value if it's not defined."""
    if var not in os.environ:
        os.environ[var] = default_value


def init_geoserver_env():
    """
    Initializes all GeoServer environment variables with default values if not already defined.
    """
    # Validate that the required PostgreSQL environment variables are defined.
    for var in REQUIRED_ENVS:
        if var not in os.environ:
            raise Exception('%s not defined in environment' % var)

    default_env('GEOSERVER_WORKSPACE', env('PG_DATABASE'))
    default_env('GEOSERVER_NAMESPACE', 'http://%s.com' % env('GEOSERVER_WORKSPACE'))
    default_env('GEOSERVER_NAMESPACE_ID', env('GEOSERVER_WORKSPACE'))
    default_env('GEOSERVER_DATASTORE', env('GEOSERVER_WORKSPACE'))
    default_env('GEOSERVER_STYLENAME', env('GEOSERVER_WORKSPACE'))
    default_env('GEOSERVER_USERNAME', DEFAULT_GEOSERVER_USERNAME)
    default_env('GEOSERVER_PASSWORD', DEFAULT_GEOSERVER_PASSWORD)


def get_workspace_dir():
    return '%s/workspaces/%s' % (GEOSERVER_DATA_DIR, env('GEOSERVER_WORKSPACE'))


def replace_write(filename, destination):
    """
    Opens the named file, replaces all of its environment variable references with their values from
    the environment, then writes the result to the destination.
    """
    if not os.path.isfile(filename):
        print "WARNING: File not found at %s, skipping write" % filename
        return

    with open(filename, 'r') as infile:
        content = infile.read()
        content_expanded = re.sub(ENV_PATTERN, lambda match: env(match.group(1)), content)
        mkpath(os.path.dirname(os.path.realpath(destination)))

        verb = "Overwriting" if os.path.isfile(destination) else "Writing"
        with open(destination, 'w') as outfile:
            print "%s file to %s" % (verb, destination)
            outfile.write(content_expanded)


def add_workspace():
    workspace_dir = get_workspace_dir()
    if not os.path.isdir(workspace_dir):
        print "Creating workspace directory at %s..." % workspace_dir
        mkpath(workspace_dir)

    print "Adding workspace %s..." % env('GEOSERVER_WORKSPACE')
    replace_write('data/workspace.xml', '%s/workspace.xml' % workspace_dir)


def add_namespace():
    print "Adding namespace %s..." % env('GEOSERVER_NAMESPACE_ID')
    replace_write('data/namespace.xml', '%s/namespace.xml' % get_workspace_dir())


def add_datastore():
    print "Adding datastore %s to %s@%s:%s..." % (env('GEOSERVER_DATASTORE'), env('PG_USERNAME'),
                                                  env('PG_HOSTNAME'), env('PG_PORT'))
    replace_write('data/datastore.xml',
                  '%s/%s/datastore.xml' % (get_workspace_dir(), env('GEOSERVER_DATASTORE')))


def add_style():
    workspace_dir = get_workspace_dir()
    sld_path = 'data/styles/style.sld'

    if not os.path.isfile(sld_path):
        print "WARNING: Style Layer Descriptor not found at %s, not adding style" % sld_path
        return

    print "Adding style %s..." % env('GEOSERVER_STYLENAME')
    for ext in ['xml', 'sld']:
        replace_write('data/styles/style.%s' % ext,
                      '%s/styles/%s.%s' % (workspace_dir, env('GEOSERVER_STYLENAME'), ext))


def set_user():
    # Don't print the actual password to the console.
    print "Setting username:password to %s:$GEOSERVER_PASSWORD..." % env('GEOSERVER_USERNAME')

    users_dir = '%s/security/usergroup/default' % GEOSERVER_DATA_DIR
    replace_write('data/users.xml', '%s/users.xml' % users_dir)


if __name__ == '__main__':
    # Load relative file paths relative to the script directory.
    os.chdir(os.path.dirname(os.path.realpath(__file__)))
    print "Configuring GeoServer..."
    init_geoserver_env()
    add_workspace()
    add_namespace()
    add_datastore()
    add_style()
    set_user()
    print "GeoServer configuration complete"
