echo "✅ Syncing new feature to S3 Landing..."
aws s3 sync --delete ${CODEBUILD_SRC_DIR}/${SRC_LAND}/build s3://${S3_FRONT}
echo "✅ Clearing cache CloudFront FRONT"
aws cloudfront create-invalidation --paths '/*' --distribution-id ${CF_ID}
