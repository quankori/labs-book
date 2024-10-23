echo "✅ Updating new artifarct!!!"
cd ${CODEBUILD_SRC_DIR}/codedeploy/
zip appspec.zip appspec.yml taskdef.json
aws s3 rm s3://${S3_ARC}/ChangeParameter/appspec.zip
aws s3 cp appspec.zip s3://${S3_ARC}/ChangeParameter/appspec.zip
