echo "✅ Building S3 Source LAND..."
docker build -t landing -f ${CODEBUILD_SRC_DIR}/codebuild/web/Dockerfile ${CODEBUILD_SRC_DIR}/${SRC_LAND}
docker run -itd --name landing landing
docker cp landing:/app/. ${CODEBUILD_SRC_DIR}/${SRC_LAND}
docker stop landing
