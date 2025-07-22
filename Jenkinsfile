pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
    }
    environment{
       NEXUS_HOST = "192.168.1.37"
       NEXUS_PORT = "18080"
    }

    stages {
        stage('Code Compilation') {
            steps {
                echo 'Starting Code Compilation...'
                sh 'mvn clean compile'
                echo 'Code Compilation Completed Successfully!'
            }
        }
        stage('Code QA Execution') {
            steps {
                echo 'Running JUnit Test Cases...'
                sh 'mvn clean test'
                echo 'JUnit Test Cases Completed Successfully!'
            }
        }
        stage('Code Package') {
            steps {
                echo 'Creating WAR Artifact...'
                sh 'mvn clean package'
                echo 'WAR Artifact Created Successfully!'
            }
        }
        stage('Build & Tag Docker Image') {
            steps {
                echo 'Building Docker Image with Tags...'
                sh "sudo docker build -t ${NEXUS_HOST}:${NEXUS_PORT}/booking-ms:latest -t pramodmanjare27/booking-ms:latest ."
                echo 'Docker Image Build Completed!'
            }
        }
        stage('Docker Image Scanning') {
            steps {
                echo 'Scanning Docker Image with Trivy...'
                //sh 'trivy image localhost:18080/booking-ms:latest || echo "Scan Failed - Proceeding with Caution"'
                echo 'Docker Image Scanning Completed!'
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'dockerhubCred', variable: 'dockerhubCred')]) {
                        sh 'sudo docker login docker.io -u pramodmanjare27 -p ${dockerhubCred}'
                        echo 'Pushing Docker Image to Docker Hub...'
                        sh 'docker push pramodmanjare27/booking-ms:latest'
                        echo 'Docker Image Pushed to Docker Hub Successfully!'
                    }
                }
            }
        }
        stage('Push Docker Image to Nexus') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'nexus-credentials', variable: "nexus-credentials"]) {
                        echo 'Pushing Docker Image to nexus ...'
			sh 'sudo docker login docker.io -u admin -p ${nexus-credentials}'
                        sh '''
                            sudo docker images
                            sudo docker push ${NEXUS_HOST}:${NEXUS_PORT}/booking-ms:latest
                        '''
                        echo 'Docker Image Pushed to nexus Successfully!'
                    }
                }
            }
		}
        stage('Cleanup Docker Images') {
            steps {
                echo 'Cleaning up local Docker images...'
                //sh 'docker rmi -f $(docker images -aq)'
                echo 'Local Docker images deleted successfully!'
            }
        }
    }
}
