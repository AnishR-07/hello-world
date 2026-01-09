pipeline {
    agent any
    environment {
        DOCKER_HUB_REPO = "anishr0007/hello-world"
        DOCKER_HUB_CREDENTIALS_ID = "docker-id"
        KUBECONFIG_CRED = "KUBECONFIG_CRED"
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
                    withCredentials([usernamePassword(credentialsId: 'KUBECONFIG_CRED', usernameVariable: 'KUBECONFIG', passwordVariable: 'GIT_PASS')]) {
                        sh '''
                        sed -i "s|IMAGE_TAG|${IMAGE_TAG}|g" deployment.yaml
                        kubectl apply -f deployment.yaml
                        kubectl apply -f service.yaml
                        kubectl rollout status deployment/hello-world-deployment
                        '''
                    }
                }
            }
        }
    
    }
}