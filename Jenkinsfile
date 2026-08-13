pipeline {

    agent any

    environment {
        AWS_REGION = 'eu-west-1'
        ECR_REPOSITORY = 'my-devops-app'
        IMAGE_TAG = "${BUILD_NUMBER}"
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
                    echo "Checking tools..."

                    java -version
                    docker --version
                    aws --version
                '''
            }
        }

       stage('Terraform Plan') {
           steps {
               sh '''
                   cd terraform
                   terraform plan \
                      -var="aws_region=${AWS_REGION}" \
                      -var="s3_bucket_name=my-devops-website-2026-2004"
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
                        -var="instance_type=t3.small" \
                        -var="s3_bucket_name=my-devops-website-2026-2004"
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build \
                    -f docker/Dockerfile \
                    -t ${ECR_REPOSITORY}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                    ECR_URL=$(aws ecr describe-repositories \
                        --repository-names ${ECR_REPOSITORY} \
                        --region ${AWS_REGION} \
                        --query 'repositories[0].repositoryUri' \
                        --output text)

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
                '''
            }
        }

        stage('Deploy Website to S3') {
            steps {
                sh '''
                    BUCKET=$(cd terraform && terraform output -raw s3_bucket_name)

                    aws s3 cp \
                        website/index.html \
                        s3://${BUCKET}/index.html \
                        --region ${AWS_REGION}
                '''
            }
        }
    }
}
