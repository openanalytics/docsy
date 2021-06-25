pipeline {

    agent {
        kubernetes {
            yamlFile 'agent.pod.yaml'
        }
    }

    options {
        authorizationMatrix inheritanceStrategy: inheritingGlobal(), permissions: ['hudson.model.Item.Build:oa-infrastructure', 'hudson.model.Item.Read:oa-infrastructure']
        buildDiscarder(logRotator(numToKeepStr: '3'))
    }

    environment {
        shortCommit = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
        IMAGE = "docsy"
        NS = "oa-infrastructure"
        REG = "196229073436.dkr.ecr.eu-west-1.amazonaws.com"
    }
    
    stages {

        stage('Pulling Old Image'){
            steps {
                container('dind') {
                    // login to ecr
                    ecrPull "${env.REG}", "${env.NS}/${env.IMAGE}", "latest", '', 'eu-west-1'
                }
            }
        }
        
        stage('Build Image'){
            steps {
                container('dind'){
                    sh """
                        docker build --cache-from ${env.REG}/${env.NS}/${env.IMAGE}:latest -t ${env.NS}/${env.IMAGE} -t ${env.NS}/${env.IMAGE}:${env.shortCommit} .
                    """

                }
            }
        }
    }

    post {
        success  {
            container('dind'){
                sh "echo tagging and pushing images to registry"

                ecrPush "${env.REG}", "${env.NS}/${env.IMAGE}", "latest", '', 'eu-west-1' 
                ecrPush "${env.REG}", "${env.NS}/${env.IMAGE}", "${env.shortCommit}", '', 'eu-west-1'   
            }
        }
    }
}

