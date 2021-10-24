# Apache ActiveMQ Artemis Docker Image

Based on [apache/activemq-artemis](https://github.com/apache/activemq-artemis/tree/main/artemis-docker)

This is an example on how you could create your own Docker Image For Apache 
ActiveMQ Artemis based on Debian or Alpine.

# Preparing

Use the script ./prepare-docker.sh as it will copy the docker files under the 
binary distribution.

Below is shown the command to prepare the build of the Docker Image starting 
from the local distribution (from the source codes of ActiveMQ Artemis)
```
# Prepare for build the Docker Image from the local distribution. Replace the 
# {local-distribution-directory} with your directory.
$ ./prepare-docker.sh --from-local-dist --local-dist-path {local-distribution-directory}
```

The output of the previous command is shown below.

```
$ ./prepare-docker.sh --from-local-dist --local-dist-path ../artemis-distribution/target/apache-artemis-2.17.0-SNAPSHOT-bin/apache-artemis-2.17.0-SNAPSHOT

Using Artemis dist: ../artemis-distribution/target/apache-artemis-2.17.0-SNAPSHOT-bin/apache-artemis-2.17.0-SNAPSHOT
Clean up the ../artemis-distribution/target/apache-artemis-2.17.0-SNAPSHOT-bin/apache-artemis-2.17.0-SNAPSHOT/docker directory
Docker file support files at : ../artemis-distribution/target/apache-artemis-2.17.0-SNAPSHOT-bin/apache-artemis-2.17.0-SNAPSHOT/docker
../artemis-distribution/target/apache-artemis-2.17.0-SNAPSHOT-bin/apache-artemis-2.17.0-SNAPSHOT/docker
├── debian.Dockerfile
├── alpine.Dockerfile
└── docker-run.sh

0 directories, 4 files

Well done! Now you can continue with the Docker image build.
Building the Docker Image:
  Go to ../artemis-distribution/target/apache-artemis-2.17.0-SNAPSHOT-bin/apache-artemis-2.17.0-SNAPSHOT where you prepared the binary with Docker files.

  # Go to ../artemis-distribution/target/apache-artemis-2.17.0-SNAPSHOT-bin/apache-artemis-2.17.0-SNAPSHOT
  $ cd ../artemis-distribution/target/apache-artemis-2.17.0-SNAPSHOT-bin/apache-artemis-2.17.0-SNAPSHOT

  # For Debian
  $ docker build -f ./docker/debian.Dockerfile -t artemis-debian .

  # For Alpine
  $ docker build -f ./docker/alpine.Dockerfile -t artemis-alpine .

For more info read the readme.md

```

The command to prepare the build of the Docker Image starting from the official 
release of ActiveMQ Artemis is shown below
```
# Prepare for build the Docker Image from the release version. Replace the
# {release-version} with the version that you want 
$ ./prepare-docker.sh --from-release --artemis-version {release-version}
```

The output of the previous command is shown below.

```
$ ./prepare-docker.sh --from-release --artemis-version 2.16.0

Downloading apache-artemis-2.16.0-bin.tar.gz from https://downloads.apache.org/activemq/activemq-artemis/2.16.0/...
################################################################################################################################################################################################################################ 100,0%
Expanding _TMP_/artemis/2.16.0/apache-artemis-2.16.0-bin.tar.gz...
Removing _TMP_/artemis/2.16.0/apache-artemis-2.16.0-bin.tar.gz...
Using Artemis dist: _TMP_/artemis/2.16.0
Docker file support files at : _TMP_/artemis/2.16.0/docker
_TMP_/artemis/2.16.0/docker
├── debian.Dockerfile
├── alpine.Dockerfile
└── docker-run.sh

0 directories, 4 files

Well done! Now you can continue with the Docker image build.
Building the Docker Image:
  Go to _TMP_/artemis/2.16.0 where you prepared the binary with Docker files.

  # Go to _TMP_/artemis/2.16.0
  $ cd _TMP_/artemis/2.16.0

  # For Debian
  $ docker build -f ./docker/debian.Dockerfile -t artemis-debian .

  # For Alpine
  $ docker build -f ./docker/alpine.Dockerfile -t artemis-alpine .

For more info read the readme.md
```

# Building

Go to `$ARTEMIS_DIST` where you prepared the binary with Docker files.

## For Debian

From within the `$ARTEMIS_DIST` folder:
```
$ docker build -f ./docker/debian.Dockerfile -t artemis-debian .
```

## For Alpine

From within the `$ARTEMIS_DIST` folder:
```
$ docker build -f ./docker/alpine.Dockerfile -t artemis-alpine .
```

**Note:**
`-t artemis-debian`,`-t artemis-centos`,`artemis-adoptopenjdk-11` are just tag 
names for the purpose of this guide


# Environment Variables

Environment variables determine the options sent to `artemis create` on first execution of the Docker
container. The available options are: 

**`ARTEMIS_USER`**

The administrator username. The default is `artemis`.

**`ARTEMIS_PASSWORD`**

The administrator password. The default is `artemis`.

**`ANONYMOUS_LOGIN`**

Set to `true` to allow anonymous logins. The default is `false`.

**`EXTRA_ARGS`**

Additional arguments sent to the `artemis create` command. The default is `--http-host 0.0.0.0 --relax-jolokia`.
Setting this value will override the default. See the documentation on `artemis create` for available options.

**Final broker creation command:**

The combination of the above environment variables results in the `docker-run.sh` script calling
the following command to create the broker instance the first time the Docker container runs:

    ${ARTEMIS_HOME}/bin/artemis create --user ${ARTEMIS_USER} --password ${ARTEMIS_PASSWORD} --silent ${LOGIN_OPTION} ${EXTRA_ARGS}

Note: `LOGIN_OPTION` is either `--allow-anonymous` or `--require-login` depending on the value of `ANONYMOUS_LOGIN`.

# Mapping point

- `/var/lib/artemis-instance`

It's possible to map a folder as the instance broker.
This will hold the configuration and the data of the running broker. This is useful for when you want the data persisted outside of a container.


# Lifecycle of the execution

A broker instance will be created during the execution of the instance. If you pass a mapped folder for `/var/lib/artemis-instance` an image will be created or reused depending on the contents of the folder.
