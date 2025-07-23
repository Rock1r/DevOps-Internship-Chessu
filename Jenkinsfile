pipeline {
    agent none

    tools {
        nodejs 'node'
        docker 'docker'
    }

    stages {
        stage('Start Notification') {
            agent { label 'node.js' }
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
                    agent { label 'node.js' }
                    steps {
                        dir('client') {
                            sh 'pnpm install --frozen-lockfile'
                        }
                    }
                }
                stage('Backend Install') {
                    agent { label 'node.js' }
                    steps {
                        dir('server') {
                            sh 'pnpm install --frozen-lockfile'
                        }
                    }
                }
            }
        }

        stage('Lint') {
            agent { label 'node.js' }
            steps {
                dir('chessu') {
                    sh 'pnpm lint'
                }
            }
        }

        stage('Test') {
            parallel {
                stage('Frontend Test') {
                    agent { label 'node.js' }
                    steps {
                        dir('client') {
                            sh 'pnpm test'
                        }
                    }
                }
                stage('Backend Test') {
                    agent { label 'node.js' }
                    steps {
                        dir('server') {
                            sh 'pnpm test'
                        }
                    }
                }
            }
        }

        stage('Snyk Test') {
            agent any
            steps {
                script {
                    try {
                        snykSecurity(
                            snykInstallation: 'snyk',
                            snykTokenId: 'snyk_token',
                            additionalArguments: '--all-projects'
                        )
                    } catch (Exception e) {
                        discordSend(
                            webhookURL: env.DISCORD_WEBHOOK,
                            title: env.JOB_NAME,
                            description: "Snyk test failed: ${e.getMessage()}",
                            link: env.BUILD_URL,
                            result: 'FAILURE'
                        )
                    }
                }
            }
        }

        stage('Init Tag Info') {
            agent any
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
                    agent { label 'docker' }
                    steps {
                        script {
                            client = docker.build("chessu/client:${IMAGE_TAG}", "-t chessu/client:latest -f Dockerfile_client --build-arg ${env.API_URL} .")
                        }
                    }
                }
                stage('Build Server Image') {
                    agent { label 'docker' }
                    steps {
                        script {
                            server = docker.build("chessu/server:${IMAGE_TAG}", "-t chessu/server:latest -f Dockerfile_server .")
                        }
                    }
                }
            }
        }

        stage('Push images to AWS ECR') {
            agent { label 'node.js' }
            steps {
                script {
                    docker.withRegistry("https://${env.ECR_URI}", "ecr:${env.ECR_REGION}:aws-jenkins") {
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
