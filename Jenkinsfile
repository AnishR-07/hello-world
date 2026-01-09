pipeline {
    agent any
    environment {
        DOCKER_HUB_REPO = "anishr0007/hello-world"
        DOCKER_HUB_CREDENTIALS_ID = "docker-id"
        KUBECONFIG_CRED = "KUBECONFIG_CRED"
        AWS_CRED_ID = "AWS_ID"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    stages {
        stage('Checkout Github') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-id', url: 'https://github.com/AnishR-07/hello-world.git']])
            }
        }        
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    dockerImage = docker.build("${DOCKER_HUB_REPO}:${IMAGE_TAG}")
                }
            }
        }
        stage('Push Image to DockerHub') {
            steps {
                script {
                    echo 'Pushing Docker image to DockerHub...'
                    docker.withRegistry('https://registry.hub.docker.com' , "${DOCKER_HUB_CREDENTIALS_ID}") {
                        dockerImage.push("${IMAGE_TAG}")
                    }
                }
            }
        }
        stage('Deployment YAML to EKS') {
            steps {
                script {
                    // 1. Fetch the Kubeconfig file
                    withCredentials([file(credentialsId: 'KUBECONFIG_CRED', variable: 'KUBECONFIG')]) {
                        
                        // 2. Fetch the AWS Keys using the ID "AWS_ID"
                        withCredentials([usernamePassword(credentialsId: "${AWS_CRED_ID}", 
                                         passwordVariable: 'AWS_SECRET', 
                                         usernameVariable: 'AWS_ACCESS')]) {
                            sh """
                            cd manifest
                            sed -i "s|IMAGE_TAG|${IMAGE_TAG}|g" deployment.yaml
                            export AWS_ACCESS_KEY_ID="${AWS_ACCESS}"
                            export AWS_SECRET_ACCESS_KEY="${AWS_SECRET}"
                            export AWS_DEFAULT_REGION="us-east-1"
                            kubectl apply -f deployment.yaml
                            kubectl apply -f service.yaml
                            kubectl rollout status deployment/hello-world-deployment
                            """
                        }
                    }
                }
            }
        }
    }
}