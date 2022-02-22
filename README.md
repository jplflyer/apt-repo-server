# APT-REPO-SERVER

apt-repo-server is a debian repository server. It monitors file changing event(inotify), then reproduce index file(Packages.gz) automatically.

# Building

    make image

# Usage

## Run server
    make up

    -or-

    $ docker run -d --name repo -e DISTS="bionic,focal" -v ${PWD}/data:/data -p 10000:80 jplflyer/apt-repo-server

The DISTS environment variable controls the distributions expected. See the instructions for configuring apt-get further below.

## Export a debian package
    $ cp qnap-fix-input_0.1_all.deb  data/dists/trusty/main/binary-amd64/

In this case, we're dumping into the `trusty` distribution. But the way we show to start it, you might want that to be `bionic` or `focal` or whatever you personally use.

Note that `scan.py` hardcodes the `main` part. You're stuck there unless you update the Python script.

## Structure
File structure looks like
```
$ tree data/
data/
└── dists
    ├── precise
    │   └── main
    │       ├── binary-amd64
    │       │   └── Packages.gz
    │       └── binary-i386
    │           └── Packages.gz
    └── trusty
        └── main
            ├── binary-amd64
            │   ├── Packages.gz
            │   └── qnap-fix-input_0.1_all.deb
            └── binary-i386
                └── Packages.gz
```

Packages.gz looks like
```
$ zcat data/dists/trusty/main/binary-amd64/Packages.gz
Package: qnap-fix-input
Version: 0.1
Architecture: all
Maintainer: Doro Wu <dorowu@qnap.com>
Installed-Size: 33
Filename: ./qnap-fix-input_0.1_all.deb
Size: 1410
MD5sum: 8c08f13d61da1b8dc355443044bb2608
SHA1: 6deef134c94da7f03846a6b74c9e4258c514868f
SHA256: 7441f1616810d5893510d31eac2da18d07b8c13225fd2136e6a380aefe33c815
Section: utils
Priority: extra
Description: QNAP fix
 UNKNOWN
```

# Configure apt-get
Update `/etc/apt/sources.list`

    echo deb http://127.0.0.1:10000 trusty main | sudo tee -a /etc/apt/sources.list

Or create a file in `/etc/apt/sources.list.d`. Files must end in `.list`.

    echo deb http://127.0.0.1:10000 trusty main > /etc/apt/sources.list.d/localhost.list

These set up for using `trusty` as the distribution, which is the original default. But the examples we use actually set up for `bionic` and `focal`, so you might want one of these:

For Ubuntu 18.04:

    echo deb http://127.0.0.1:10000 bionic main > /etc/apt/sources.list.d/localhost.list

For Ubuntu 20.04:
    echo deb http://127.0.0.1:10000 focal main > /etc/apt/sources.list.d/localhost.list

It just has to match what you did when you started the repo and where you are stuffing your .deb files. Using `bionic` or `focal` or `trusty` is just text, and you can put anything there, as long as they match and make sense.

# License

apt-repo is under the Apache 2.0 license. See the LICENSE file for details.
