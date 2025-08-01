pipeline {
    agent any
    tools{
        jdk "jdk23"
        maven "maven3.9"
    }
    environment{
        SCANNER_HOME= tool 'sonar-scanner'
    }
    stages {
        stage('git checkout') {
            steps {
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/SrivamsiGovinda/maven-app.git'
            }
        }
        stage('compile') {
            steps {
                sh "mvn compile"
            }
        }
        stage('sonarqube analysis') {
            steps {
                sh ''' $SCANNER_HOME/bin/sonar-scanner \
                -Dsonar.host.url=http://localhost:9000 \
                -Dsonar.login=squ_3fac2f8020172e0ab4ff9d05202c69e3177397ec \
                -Dsonar.projectName=docker-desktop \
                -Dsonar.java.binaries=. \
                -Dsonar.projectKey=docker-desktop '''
            }
        }
        stage('owasp') {
            steps {
                dependencyCheck additionalArguments: ' --scan ./ ', odcInstallation: 'DP'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('build') {
            steps {
                sh "mvn clean install"
            }
        }
        stage('docker build and push') {
            steps {
                withDockerRegistry(credentialsId: 'docker-cred', url: 'https://index.docker.io/v1/') {
                    sh "docker build -t srivamsivamsi90/docker-desktop:latest ."
                    sh "trivy image --exit-code 0 --format table -o trivy-report.txt srivamsivamsi90/docker-desktop:latest || true"
                    sh "docker push srivamsivamsi90/docker-desktop:latest"
                }
            }
        }
        stage('deploy to docker') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', url: 'https://index.docker.io/v1/') {
                        sh "docker run -d --name docker-desktop -p 8081:8081 srivamsivamsi90/docker-desktop:latest"
                    }
                }
            }
        }
    }  
}




