pipeline {
    agent {
        label 'maven'
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    
    stages {
        stage('BuildApp') {
            steps {
                sh 'mvn clean package'
            }
        }
        
        stage('PackerValidate') {
            steps {
                sh 'packer validate packer-config.json'
            }
        }
        
        stage('PackerBuild') {
            steps {
                script {
                    // Run packer build command and store output in output.txt
                    sh 'packer build packer-config.json 2>&1 | tee output.txt'

                    // Extract AMI ID from output.txt
                    def amiID = sh(script: 'tail -2 output.txt | head -1 | awk \'/ami-[a-f0-9]+/ { print $NF }\'', returnStdout: true).trim()

                    // Set AMI_ID environment variable
                    env.AMI_ID = amiID
                    echo "AMI_ID: ${env.AMI_ID}"
                }
            }
        }

        
        stage('TriggerDownstream') {
            steps {
                build job: 'spring-clinic-infra', parameters: [
                    [$class: 'StringParameterValue', name: 'AMI_ID', value: env.AMI_ID]
                ]
            }
        }
    }
}
