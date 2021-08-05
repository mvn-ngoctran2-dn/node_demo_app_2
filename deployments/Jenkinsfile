def localDeploy = false

pipeline {
    agent any
    environment {
        KUBECONFIG = '~/.kube/config'
    }
    stages {
        stage('Fetch') {
            steps {
                echo 'Pulling ...' + env.CHANGE_BRANCH
                checkout scm
            }
        }

        stage('Build & Push') {
            when {
                expression { CHANGE_TARGET ==~ /init/ }
            }
            steps {
 //               slackSend color: "#439FE0", message: "Deploy Service Webfront Started: ${env.JOB_NAME} ${env.BUILD_NUMBER}, refers at: ${env.BUILD_URL}"
                script {
                    localDeploy=true
                    sh "sudo make kubeimages env=local"
                }
            }
        }
        }

        stage('Deploy') {
            when {
                expression { CHANGE_TARGET ==~ /init/ }
            }
            steps {
 //               slackSend color: "#439FE0", message: "Deploy Service Webfront Started: ${env.JOB_NAME} ${env.BUILD_NUMBER}, refers at: ${env.BUILD_URL}"
                script {
                    localDeploy=true
                    sh "sudo make kubeinit env=local"
                }
            }
        }
        stage('down') {
            when {
                expression { CHANGE_TARGET ==~ /down/ }
            }
            steps {
//                slackSend color: "#439FE0", message: "Delete Webfront Service Started: ${env.JOB_NAME} ${env.BUILD_NUMBER}, refers at: ${env.BUILD_URL}"
                script {
                    localDeploy=true
                    sh "sudo make kubedown env=local"
                }
            }
        }
        stage('local-deploy') {
            when {
                expression { CHANGE_TARGET ==~ /local_deploy/ }
            }
            steps {
   //             slackSend color: "#439FE0", message: "Rollout Webfront Build Started: ${env.JOB_NAME} ${env.BUILD_NUMBER}, refers at: ${env.BUILD_URL}"
                script {
                    localDeploy=true
                    sh "sudo make kubeupdate env=local"
                }
            }
        }
    }
    /*
    post {
        success {
            script {
                if (localDeploy) {
                    slackSend color: "#44F059",
                            channel: 'mvn-convano-api-deployment',
                            message: "Update Webfront successfully, please refers functions was deployed at: ${env.CHANGE_URL}"
                }
            }
        }
        failure {
            script {
                if (localDeploy) {
                    slackSend color: "#F72911",
                            channel: 'mvn-convano-api-deployment', 
                            message: "Update Webfront failed, refers logs at: ${env.BUILD_URL}/console"
                }
            }
        }
    }
    */
}
