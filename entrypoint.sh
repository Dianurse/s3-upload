#!/bin/sh

set -e

if [ -z "$AWS_ACCESS_KEY" ]; then
  echo "AWS_ACCESS_KEY is NOT set. Pls go to repo settings and add it. Will exit now."
  exit 1
fi


if [ -z "$AWS_SECRET_KEY" ]; then
  echo "AWS_SECRET_KEY is NOT set. Pls go to repo settings and add it. Will exit now. "
  exit 1
fi


if [ -z "$AWS_S3_BUCKET" ]; then
  echo "AWS_S3_BUCKET is NOT set. Pls go to repo settings and add it. Will exit now."
  exit 1
fi


if [ -z "$AWS_REGION" ]; then
  echo "AWS_REGION is NOT set. Pls go to repo settings and add it. Will exit now."
fi

if [ -z "$MAX_AGE" ]; then
  echo "Expiration was NOT provided and will be set to default value 31536000"
  MAX_AGE="31536000"
fi


if [ -z "$SOURCE_DIRECTORY" ]; then
  echo "Source directory was NOT provided and will be set to default value ./"
  SOURCE_DIRECTORY="."
fi

if [ -z "$DESTINATION_DIRECTORY" ]; then
  echo "Destination directory was NOT provided and will be set to default value - root directory"
  DESTINATION_DIRECTORY=""
fi




aws configure --profile github-action <<-EOF > /dev/null 2>&1
${AWS_ACCESS_KEY}
${AWS_SECRET_KEY}
${AWS_REGION}
text
EOF


sh -c "aws s3 sync ${SOURCE_DIRECTORY} s3://${AWS_S3_BUCKET}/${DESTINATION_DIRECTORY} \
              --profile github-action \
              --cache-control max-age=${MAX_AGE},public"

aws configure --profile github-action <<-EOF > /dev/null 2>&1
null
null
null
text
EOF
