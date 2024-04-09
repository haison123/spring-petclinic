pipeline {
    agent none

    stages {
        // stage('Build') {
        //     agent {
        //         docker {
        //             image 'maven:latest'
        //             args '-u root'
        //             args '-v $HOME/.m2:/root/.m2'
        //         }
        //     }
        //     steps {
        //         // Build the Maven project
        //         sh 'mvn clean package'
        //     }
        // }

        // stage('Unit Test') {
        //     agent {
        //         docker {
        //             image 'maven:latest'
        //             args '-u root'
        //             args '-v $HOME/.m2:/root/.m2'
        //         }
        //     }
        //     steps {
        //         // Run unit tests
        //         sh 'mvn test'
        //     }
        // }
        
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
                        ssh -i $SSH_KEY $USER_NAME@35.173.171.21 <<'EOF'
                        ip a
                        echo "IM HERE"
                    EOF
                    '''
                }
            }
        }
    }

    // post {
    //     success {
    //         stash includes: 'target/*.jar', name: 'my-artifact'
    //         echo 'Pipeline successful! Artifact saved in /target folder.'
    //     }
    //     failure {
    //         echo 'Pipeline failed!'
    //     }
    // }
}
