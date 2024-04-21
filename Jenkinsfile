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
                sh 'packer build packer-config.json 2>&1 | tee output.txt'
                script {
                    def lastLine = sh(script: 'tail -n 1 output.txt', returnStdout: true).trim()
                    // Extract the AMI ID using a regular expression
                    def amiID = (lastLine =~ /ami-[a-f0-9]+/)[0]
                    env.AMI_ID = amiID
                    echo "AMI_ID : ${env.AMI_ID}"
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
