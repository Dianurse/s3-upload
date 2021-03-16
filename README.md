# Upload to AWS S3 bucket and optionally invalidate Cloudfront distribution

This action uploads content of repo directory of choice to a directory in AWS S3 bucket. It optionally invalidates a Cloudfront distribution.

## Usage

### `workflow.yml` Example

Place in a `.yml` file such as this one in your `.github/workflows` folder. [Refer to the documentation on workflow YAML syntax here.](https://help.github.com/en/articles/workflow-syntax-for-github-actions)

```yaml
name: Test, build and deploy my static site to S3 bucket

on:
  push:
    branches:
      - main

  workflow_dispatch:


jobs:
  build_my_static_site:

    runs-on: ubuntu-latest  
    
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v1
        with:
          node-version: 12
      - name: Install dependencies
        working-directory: ./code-base
        run: |
          npm ci
      - name: Test
        working-directory: ./code-base
        run: |
          npm test
      - name: Build static site
        working-directory: ./code-base
        run: |
          npm run build
      - name: Deploy to S3
        uses: dianurse/s3-upload@master
        with:
          args: --acl public-read --delete
        env:
          AWS_S3_BUCKET: ${{ secrets.AWS_S3_BUCKET_NAME }}
          AWS_ACCESS_KEY: ${{ secrets.AWS_ACCESS_KEY }}
          AWS_SECRET_KEY: ${{ secrets.AWS_SECRET_KEY }}
          AWS_REGION: 'us-east-2'
          MAX_AGE: '1209600'
          SOURCE_DIRECTORY: './code-base/build'
          DESTINATION_DIRECTORY: ''
          IS_CACHE_INVALIDATION_REQUIRED: 'true'
          CLOUDFRONT_DISTRIBUTION_ID: ${{ secrets.CLOUDFRONT_DISTRIBUTION_ID }}
```

## Action inputs

The following settings must be passed as environment variables as shown in the example. Sensitive information, especially `AWS_ACCESS_KEY` and `AWS_SECRET_KEY`, should be [set as encrypted secrets](https://help.github.com/en/articles/virtual-environments-for-github-actions#creating-and-using-secrets-encrypted-variables) — otherwise, they'll be public to anyone browsing your repository's source code

| name                    | description                                                  |
| ----------------------- | ------------------------------------------------------------ |
| `AWS_ACCESS_KEY`            | (Required) Your AWS Access Key. [More info here.](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html) |
| `AWS_ACCESS_KEY` | (Required) Your AWS Secret Access Key. [More info here.](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html) |
| `AWS_S3_BUCKET`            | (Required) The name of the bucket you want to upload to.          |
| `AWS_REGION`            | | (Required) Your AWS Deployment Region. | 
| `SOURCE_DIRECTORY`            | (Optional) The local directory (or file) you wish to upload to S3. For a stic web page, this is normally build directory |
| `DESTINATION_DIRECTORY`       | (Optional) The destination directory in S3<br />If this field is excluded a [shortid](https://github.com/dylang/shortid) will be generated |
| `MAX_AGE`                     | (Optional) The expiration date of the files that are supposed to be uploaded. If omitted, it will be set to 1 year |
| `IS_CACHE_INVALIDATION_REQUIRED` | (Optional) True or false, depending on whether Cloudfront distribution needs to be invalidated |
| `CLOUDFRONT_DISTRIBUTION_ID`   | (Required, only if `IS_CACHE_INVALIDATION_REQUIRED` is true) The distribution id of the Cloudfront to be invalidated. |
