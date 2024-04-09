pipeline {
    // agent any
    agent {
        docker {
            // Use an image with Maven installed
            image 'maven:latest'
            // Set up a volume to mount the Maven repository to avoid downloading dependencies on each build
            args '-u root'
            // args '-v $HOME/.m2:/root/.m2'
        }
    }

    stages {
        // stage('Build') {
        //     steps {
        //         // Build the Maven project
        //         sh 'mvn clean package'
        //     }
        // }

        // stage('Unit Test') {
        //     steps {
        //         // Run unit tests
        //         sh 'mvn test'
        //     }
        // }
        
        stage('Deploy') {
            steps {
                // Use withCredentials to securely access SSH private key
                withCredentials([sshUserPrivateKey(credentialsId: 'deploy-server', keyFileVariable: 'SSH_KEY')]) {
                    // Define the SSH command to run the script
                    def sshCommand = '''
                        echo "hello world"
                    '''

                    // Execute SSH command
                    sshCommand remote: [
                        host: '35.173.171.21',
                        user: 'ubuntu',  // Replace with your remote server username
                        identityFile: env.SSH_KEY  // Use the injected SSH key
                    ], command: sshCommand
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
    }
}
