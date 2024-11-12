pipeline {
    agent none
    stages {
        stage('CLONE GIT REPOSITORY') {
            agent {
                label 'ubuntu-Appserver-3120'
            }
            steps {
                checkout scm
            }
        }  
 
        stage('SCA-SAST-SNYK-TEST') {
            agent any
            steps {
                script {
                    snykSecurity(
                        snykInstallation: 'Snyk',
                        snykTokenId: 'synk_api',
                        severity: 'critical'
                    )
                }
            }
        }
 
        stage('SonarQube Analysis') {
            agent {
                label 'ubuntu-Appserver-3120'
            }
            steps {
                script {
                    def scannerHome = tool 'SonarQubeScanner'
                    withSonarQubeEnv('sonarqube') {
                        sh "${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=chatapp \
                            -Dsonar.sources=."
                    }
                }
            }
        }
 
        stage('BUILD-AND-TAG') {
            agent {
                label 'ubuntu-Appserver-3120'
            }
            steps {
                script {
                    def app = docker.build("penjack/chatapp")
                    app.tag("latest")
                }
            }
        }
 
        stage('POST-TO-DOCKERHUB') {    
            agent {
                label 'ubuntu-Appserver-3120'
            }
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub_credentials') {
                        def app = docker.image("penjack/chatapp")
                        app.push("latest")
                    }
                }
            }
        }

        stage('Prepare Environment') {
            agent {
                label 'ubuntu-Appserver-3120'
            }
            steps {
                script {
                    // Find and stop any Docker container using port 80
                        sh '''
                        CONTAINER_ID=$(docker ps -q --filter "publish=80")
                        if [ -n "$CONTAINER_ID" ]; then
                            echo "Stopping container using port 80: $CONTAINER_ID"
                            docker stop $CONTAINER_ID
                            docker rm $CONTAINER_ID
                        else
                            echo "No container using port 80."
                        fi
                        '''
                }
            }
        }
 
        stage('DEPLOYMENT') {    
            agent {
                label 'ubuntu-Appserver-3120'
            }
            steps {
                sh "docker-compose down"
                sh "docker-compose up -d"   
            }
        }
    }
}
