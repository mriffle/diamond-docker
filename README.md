# diamond-docker
Create a Docker image for Diamond that includes Blast DB support and extra features

## build
```
docker image build -t mriffle/diamond:2.1.10
```

## use
```
docker run --rm -it -v `pwd`:`pwd` -w `pwd` --user $(id -u):$(id -g) mriffle/diamond:2.1.10 diamond
```
