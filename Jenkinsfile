pipeline {

    agent any

    environment {
        AWS_REGION = 'eu-west-1'
        ECR_REPOSITORY = 'my-devops-app'
        IMAGE_TAG = "${BUILD_NUMBER}"
        S3_BUCKET = 'my-devops-website-2026-2004'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Check Tools') {
            steps {
                sh '''
                    echo "===== Checking Tools ====="

                    java -version
                    docker --version
                    aws --version
                    terraform version
                    git --version

                    echo "===== AWS Identity ====="
                    aws sts get-caller-identity
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                    cd terraform
                    terraform init
                '''
            }
        }

        stage('Terraform Validate') {
            steps {
                sh '''
                    cd terraform
                    terraform validate
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                    cd terraform

                    terraform plan \
                        -var="aws_region=${AWS_REGION}" \
                        -var="s3_bucket_name=${S3_BUCKET}"
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "===== Building Docker Image ====="

                    docker build \
                        -f docker/Dockerfile \
                        -t ${ECR_REPOSITORY}:${IMAGE_TAG} .

                    echo "===== Docker Images ====="
                    docker images | head
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                    echo "===== Login to Amazon ECR ====="

                    ECR_URL=$(aws ecr describe-repositories \
                        --repository-names ${ECR_REPOSITORY} \
                        --region ${AWS_REGION} \
                        --query 'repositories[0].repositoryUri' \
                        --output text)

                    echo "ECR Repository: ${ECR_URL}"

                    aws ecr get-login-password \
                        --region ${AWS_REGION} \
                    | docker login \
                        --username AWS \
                        --password-stdin ${ECR_URL}
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '''
                    echo "===== Pushing Docker Image ====="

                    ECR_URL=$(aws ecr describe-repositories \
                        --repository-names ${ECR_REPOSITORY} \
                        --region ${AWS_REGION} \
                        --query 'repositories[0].repositoryUri' \
                        --output text)

                    docker tag \
                        ${ECR_REPOSITORY}:${IMAGE_TAG} \
                        ${ECR_URL}:${IMAGE_TAG}

                    docker push \
                        ${ECR_URL}:${IMAGE_TAG}

                    echo "===== Image Pushed Successfully ====="
                    echo "${ECR_URL}:${IMAGE_TAG}"
                '''
            }
        }

        stage('Deploy Website to S3') {
            steps {
                sh '''
                    echo "===== Deploying Website to S3 ====="

                    aws s3 cp \
                        website/index.html \
                        s3://${S3_BUCKET}/index.html \
                        --region ${AWS_REGION}

                    echo "===== S3 Contents ====="

                    aws s3 ls \
                        s3://${S3_BUCKET}/ \
                        --region ${AWS_REGION}
                '''
            }
        }
    }

    post {
        success {
            echo '======================================'
            echo 'PIPELINE COMPLETED SUCCESSFULLY!'
            echo '======================================'
            echo "S3 Bucket: ${S3_BUCKET}"
            echo "ECR Repository: ${ECR_REPOSITORY}"
            echo "Docker Image Tag: ${IMAGE_TAG}"
        }

        failure {
            echo '======================================'
            echo 'PIPELINE FAILED'
            echo 'Check the failed stage above.'
            echo '======================================'
        }
    }
}
