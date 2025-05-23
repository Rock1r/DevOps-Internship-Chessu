pipeline {
    agent{
        node{
            label 'node.js'
        }
    }

    environment {
        NODE_ENV = 'test'
    }

    stages {
        stage('Set Env') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                        env.NODE_ENV = 'production'
                    } else if (env.BRANCH_NAME == 'dev') {
                        env.NODE_ENV = 'staging'
                    } else {
                        env.NODE_ENV = 'test'
                    }

                    echo "Environment set to ${env.NODE_ENV}"
                }
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
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
                dir('client') {
                    sh 'pnpm lint'
                }
            }
        }

        stage('Format') {
            steps {
                sh 'pnpm format'
            }
        }

        stage('Test') {
            steps {
                script {
                    githubNotify context: 'tests', status: 'PENDING', description: 'Running tests'
                }
            }
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
            post {
                success {
                    script {
                        githubNotify context: 'tests', status: 'SUCCESS', description: 'Tests passed'
                    }
                }
                failure {
                    script {
                        githubNotify context: 'tests', status: 'FAILURE', description: 'Tests failed'
                    }
                }
            }
        }

        stage('Build Frontend') {
            steps {
                dir('client') {
                    sh 'pnpm build'
                }
            }
        }

        stage('Archive Frontend') {
            steps {
                archiveArtifacts artifacts: 'client/.next/**', fingerprint: true
            }
        }

        stage('Build Backend') {
            steps {
                dir('server') {
                    sh 'pnpm build'
                }
            }
        }

        stage('Archive Backend') {
            steps {
                archiveArtifacts artifacts: 'server/dist/**', fingerprint: true
            }
        }
    }

    post {
        success {
            echo "Build completed."
        }
        failure {
            echo "Build failed."
        }
    }
}
