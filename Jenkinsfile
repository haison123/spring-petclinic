pipeline {
    agent {
                docker {
                    image 'haison123/maven-ssh:1.0.0'
                    args '-u root'
                    // args '-v $HOME/.m2:/root/.m2'
                }
            }

    stages {
        stage('Build') {
            steps {
                // Build the Maven project
                sh 'mvn clean compile -DskipTests'
            }
        }

        stage('Unit Test') {
            steps {
                // Run unit tests
                sh 'mvn test'
            }
        }

        stage('Package') {
            steps {
                // Build the Maven project
                sh 'mvn package'
            }
        }

        
        stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'deploy-server', keyFileVariable: 'SSH_KEY', usernameVariable: 'USER_NAME')]) {
                    def remote = [:]
                    remote.name = 'deploy-server'
                    remote.host = '35.173.171.21'
                    remote.user = $USER_NAME
                    remote.identity = $SSH_KEY
                    remote.allowAnyHosts = true
                    sshCommand remote: remote, command: "ls -lrt"
                }
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            echo 'Pipeline successful! Artifact saved in /target folder.'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
