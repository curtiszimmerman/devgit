
# devgit

Build an SSH-based git remote for automation (like Docker image builds).

### Build

When building devgit, supply the SSH key you will be using to connect:

```sh
$ export GIT_SSH_KEY=$(cat ~/.ssh/id_rsa.pub)
$ docker build -t=devgit --build-arg="SSH_KEY=${GIT_SSH_KEY}" .
```

### Run

You can run devgit with the default test repository:

```sh
$ docker run -d -P --name devgit devgit
```

But most of the time, you want to supply your git repository as a volume:

```sh
$ docker run -d -P --name devgit -v "/home/foo/git/myrepo:/home/git/repo.git" devgit
```

You can also listen on localhost (or a specific IP address) and on a different port:

```sh
$ docker run -d --name devgit -v "/home/foo/git/myrepo:/home/git/repo.git" -p 10.20.30.40:2222:22 devgit
```

### Use

#### Normal git workflow

Now you can interact with the source:

```sh
$ export DEVGIT_REMOTE=10.20.30.40:2222
$ git clone ssh://git@${DEVGIT_REMOTE}/home/git/repo.git
...
$ git push origin master
```

#### Docker image builds

You can also use devgit as part of your development and testing workflow with existing Docker image builds. This is useful for testing with a mock that interacts via the SSH-based git with your actual repository:

```sh
FROM alpine:latest AS base
# ...
FROM base AS build
RUN apk add --no-cache git
ADD build.key /root/.ssh/id_rsa
ARG GIT_REMOTE=localhost
RUN ssh-keyscan -T 30 ${GIT_REMOTE} > /root/.ssh/known_hosts
RUN git clone git@${GIT_REMOTE} /build
WORKDIR /build
```

Then, when building your image, supply the git remote to use:

```sh
$ # build app image using devgit running locally on tcp/22 (defaults)
$ docker build -t=myimage .
$ # build app image from devgit running remotely
$ docker build -t=myimage --build-arg "GIT_REMOTE=git.example.com" .
$ # build app image from devgit running remotely
$ docker build -t=myimage --build-arg "GIT_REMOTE=10.20.30.40:2222" .
```


### Contribute

Contributions are welcome but stylistic or semantic changes will be rejected.

### License

MIT
