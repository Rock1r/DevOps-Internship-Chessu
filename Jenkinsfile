pipeline {
    agent none

    tools {
        nodejs 'node'
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

stage('Build & Push Docker Images') {
    parallel {
        stage('Build & Push Client') {
            agent { label 'docker' }
            stages {
                stage('Login to ECR') {
                    steps {
                        withAWS(region: "${env.ECR_REGION}") {
                            ecrLogin()
                        }
                    }
                }
                stage('Build & Push') {
                    steps {
                        script {
                            def image = docker.build("${env.ECR_URI}/chessu/client:${env.IMAGE_TAG}", "-t ${env.ECR_URI}/chessu/client:latest -f Dockerfile_client --build-arg API_URL=${env.API_URL} .")
                            image.push("${env.IMAGE_TAG}")
                            image.push("latest")
                        }
                    }
                }
            }
        }

        stage('Build & Push Server') {
            agent { label 'docker' }
            stages {
                stage('Login to ECR') {
                    steps {
                        withAWS(region: "${env.ECR_REGION}") {
                            ecrLogin()
                        }
                    }
                }
                stage('Build & Push') {
                    steps {
                        script {
                            def image = docker.build("${env.ECR_URI}/chessu/server:${env.IMAGE_TAG}", "-t ${env.ECR_URI}/chessu/server:latest -f Dockerfile_server .")
                            image.push("${env.IMAGE_TAG}")
                            image.push("latest")
                        }
                    }
                }
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
