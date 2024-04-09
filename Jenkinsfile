pipeline {
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
        stage('Build') {
            steps {
                // Build the Maven project
                sh 'mvn clean package'
            }
        }

        stage('Unit Test') {
            steps {
                // Run unit tests
                sh 'mvn test'
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Publish jar file and deploy.sh
                    sshPublisher(publishers: [
                        sshPublisherDesc(
                            configName: 'deploy-server',
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'target/*.jar',
                                    removePrefix: 'target/',
                                    remoteDirectory: '.'
                                ),
                                sshTransfer(
                                    sourceFiles: 'deploy.sh',
                                    remoteDirectory: '.'
                                ),
                                sshTransfer(
                                    execCommand: 'chmod +x /home/ubuntu/deploy.sh'
                                ),
                                sshTransfer(
                                    execCommand: '/home/ubuntu/deploy.sh'
                                )
                            ]
                        )
                    ])
                    
                    // Execute commands
                    // sshPublisher(publishers: [
                    //     sshPublisherDesc(
                    //         configName: 'deploy-server',
                    //         transfers: [
                    //             sshTransfer(
                    //                 execCommand: 'chmod +x /home/ubuntu/deploy.sh'
                    //             ),
                    //             sshTransfer(
                    //                 execCommand: '/home/ubuntu/deploy.sh'
                    //             )
                    //         ]
                    //     )
                    // ])
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
