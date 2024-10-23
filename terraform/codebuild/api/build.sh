#!/bin/bash
IMAGE_TAG="${ECR_URI}"
echo "✅ Building ECS NodeJS API"
docker build -t ${IMAGE_TAG} -f ${CODEBUILD_SRC_DIR}/codebuild/api/Dockerfile ${CODEBUILD_SRC_DIR}/${SRC_NODE}
docker push ${IMAGE_TAG}
sed -i "s|task_definition|${TASK_DEFINITION}|g" ${CODEBUILD_SRC_DIR}/codedeploy/appspec.yml
sed -i "s|image_url|${IMAGE_TAG}|g" ${CODEBUILD_SRC_DIR}/codedeploy/taskdef.json
