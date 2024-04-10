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
            agent {
                docker {
                    image 'dockette/ssh:latest'
                    args '-u root'
                }
            }
            
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'deploy-server', keyFileVariable: 'SSH_KEY', usernameVariable: 'USER_NAME')]) {
                    sh '''
                        ssh -i $SSH_KEY $USER_NAME@35.173.171.21 << EOF
                            ip a
                            ls /home/ubuntu
                    '''
                }
            }
        }
    }

    post {
        success {
            stash includes: 'target/*.jar', name: 'my-artifact'
            echo 'Pipeline successful! Artifact saved in /target folder.'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
