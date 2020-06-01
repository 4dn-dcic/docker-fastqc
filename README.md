# docker-fastqc

This repo contains the source files for a docker image stored in `4dndcic/fastqc:v2`.


**Note:** The first version of the 4DN FastQC workflow is based on docker image `duplexa/4dn-hic:v32` which is identical to `4dndcic/fastqc:v1`. The updated image/CWL based on the source files in this repo begins with `v2`.

* FastQC `v1` corresponds to 4DN pipeline suite version `0.2.0`.
* FastQC `v2` corresponds to 4DN pipeline suite version `0.2.7`.

The soure files for FastQC `v1` (`0.2.0`) can be found in https://github.com/4dn-dcic/docker-4dn-hic/tree/v32 and https://github.com/4dn-dcic/pipelines-cwl/releases/tag/0.2.0.


## Table of contents
* [Cloning the repo](#cloning-the-repo)
* [Tool specifications](#tool-specifications)
* [Building docker image](#building-docker-image)
* [Benchmarking tools](#benchmarking-tools)
* [Sample data](#sample-data)
* [Tool wrappers](#tool-wrappers)
  * [run.sh](#run-fastqcsh)


## Cloning the repo
```
git clone https://github.com/4dn-dcic/docker-fastqc
cd docker-fastqc
```

## Tool specifications
Major software tools used inside the docker container are downloaded by the script `downloads.sh`. This script also creates a symlink to a version-independent folder for each software tool. In order to build an updated docker image with a new version of the tools, ideally only `downloads.sh` should be modified, but not `Dockerfile`, unless the new tool requires a specific APT tool that need to be downloaded. 
The `downloads.sh` file also contains comment lines that specifies the name and version of individual software tools.

## Building docker image
You need docker daemon to rebuild the docker image. If you want to push it to a different docker repo, replace `4dndcic/fastqc:v2` with your desired docker repo name. You need permission to push to `4dndcic/fastqc:v2`.
```
docker build -t 4dndcic/fastqc:v2 .
docker push 4dndcic/fastqc:v2
```
You can skip this if you want to use an already built image on docker hub (image name `4dndcic/fastqc:v2`). The command 'docker run' (below) automatically pulls the image from docker hub.


## Benchmarking tools
To obtain run time and max mem stats, use `usr/bin/time` that is installed in the docker container. For example, run the following to benchmark `du`.
```
docker run 4dndcic/fastqc:v2 /usr/bin/time du 2> log
cat log
```
The output looks as follows:
```
0.02user 0.82system 0:00.87elapsed 96%CPU (0avgtext+0avgdata 2024maxresident)k
0inputs+0outputs (0major+103minor)pagefaults 0swaps
```
The benchmarking result goes to STDERR, which can be collected by a file by redirecting with `2>`.
Maxmem is 2024KB in this case ('maxresident'). Run time is 0.87 second. ('elapsed')


## Sample data
Sample data files that can be used for testing the tools are included in the `sample_data` folder. These data are not included in the docker image.

## Tool wrappers

Tool wrappers are under the `scripts` directory and follow naming conventions `run*.sh`. These wrappers are copied to the docker image at built time and may be used as a single step in a workflow.

```
# default
docker run 4dndcic/fastqc:v2

# specific run command
docker run 4dndcic/fastqc:v2 <run_script> <arg1> <arg2> ...

# may need -v option to mount data file/folder if they are used as arguments.
docker run -v /data1/:/d1/:rw -v /data2/:/d2/:rw 4dndcic/fastqc:v2 <run_script> /d1/file1 /d2/file2 ...
```

### run.sh
Runs fastqc on a given fastq(.gz) file and produces a fastqc report.
* Input: a fastq file (either gzipped or not)
* Output: a fastqc report (data_report.zip)

#### Usage
Run the following in the container
```
run.sh <input_fastq> <nthread> <outdir>
# input_fastq : an input fastq file, either gzipped or not.
# nthread : number of threads to use
# outdir : output directory (This should be a mounted host directory, so that the output files are visible from the host and to avoid any bus error)
```
