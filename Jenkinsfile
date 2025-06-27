pipeline {
    agent {
        node {
            label 'node.js'
        }
    }

    triggers {
        pollSCM('H/1 * * * *')
    }

    stages {
        stage('Start Notification') {
          steps {
              discordSend(
                webhookURL: env.DISCORD_WEBHOOK,
                title: env.JOB_NAME,
                description: "Pipeline STARTED: build #${env.BUILD_NUMBER}",
                link: env.BUILD_URL,
              )
            }
        }
        stage('Install Deps') {
            parallel {
                stage('Frontend Install') {
                    steps {
                        dir('client') {
                            sh 'pnpm install --frozen-lockfile'
                        }
                    }
                }
                stage('Backend Install') {
                    steps {
                        dir('server') {
                            sh 'pnpm install --frozen-lockfile'
                        }
                    }
                }
            }
        }

        stage('Lint') {
            steps {
                dir('chessu') {
                    sh 'pnpm lint'
                }
            }
        }

        stage('Test') {
            parallel {
                stage('Frontend Test') {
                    steps {
                        dir('client') {
                            sh 'pnpm test'
                        }
                    }
                }
                stage('Backend Test') {
                    steps {
                        dir('server') {
                            sh 'pnpm test'
                        }
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            def scannerHome = tool 'SonarScanner';
            withSonarQubeEnv() {
              sh "${scannerHome}/bin/sonar-scanner"
            }
        }
        
        stage('Init Tag Info') {
            steps {
                script {
                    def branch = env.GIT_BRANCH?.replaceAll(/^origin\//, '')?.replaceAll('/', '-') ?: 'unknown'
                    def shortCommit = env.GIT_COMMIT?.take(7) ?: '0000000'
                    def timestamp = new Date(currentBuild.startTimeInMillis).format("yyyyMMdd-HHmm", TimeZone.getTimeZone('UTC'))
                    env.IMAGE_TAG = "${branch}-${shortCommit}-${timestamp}"
                }
            }
        }

        stage('Docker Build') {
            parallel {
                stage('Build Client Image') {
                    steps {
                        script {
                            client = docker.build("chessu/client:${IMAGE_TAG}", "-t chessu/client:latest -f Dockerfile_client --build-arg ${env.NGINX_URL} .")
                        }
                    }
                }
                stage('Build Server Image') {
                    steps {
                        script {
                            server = docker.build("chessu/server:${IMAGE_TAG}", "-t chessu/server:latest -f Dockerfile_server .")
                        }
                    }
                }
            }
        }
        stage('Push images to AWS ECR'){
            steps{
                script{
                    docker.withRegistry("https://${env.ECR_URI}", "ecr:${env.ECR_REGION}:aws-jenkins"){
                        client.push()
                        server.push()
                    }
                }
            }
        }
    }
    post {
    success {
        discordSend(
          webhookURL: env.DISCORD_WEBHOOK,
          title: env.JOB_NAME,
          description: "SUCCESS: build #${env.BUILD_NUMBER}",
          link: env.BUILD_URL,
          result: 'SUCCESS'
        )
    }
    failure {
        discordSend(
          webhookURL: env.DISCORD_WEBHOOK,
          title: env.JOB_NAME,
          description: "FAILED: build #${env.BUILD_NUMBER}",
          link: env.BUILD_URL,
          result: 'FAILURE'
        )
    }
  }
}
