#!/bin/sh

image_name=docker-fastqc_local  # local image name for testing

cwd=$(pwd)

# non=gz input
mkdir -p tmpout
docker run -it -v $cwd/sample_data/:/d/:ro -v $cwd/tmp_out/:/e/:rw $image_name sh -c 'run.sh /d/somefastq.fq 1 /e/'
if [ -z "$(ls -1 tmp_out/)"]; then
  echo "test failed - no output found"
  return 1;
fi
rm -rf tmpout  # cleanup

# gz input
mkdir -p tmpout
docker run -it -v $cwd/sample_data/:/d/:ro -v $cwd/tmp_out/:/e/:rw $image_name sh -c 'run.sh /d/somefastq.fq.gz 1 /e/'
if [ -z "$(ls -1 tmp_out/)"]; then
  echo "test failed - no output found"
  return 1;
fi
rm -rf tmpout  # cleanup
