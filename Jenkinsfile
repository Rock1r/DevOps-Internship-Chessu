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
                            sh '''
                            npm install -g pnpm
                            pnpm install --frozen-lockfile
                            '''
                        }
                    }
                }
                stage('Backend Install') {
                    steps {
                        dir('server') {
                            sh '''
                            npm install -g pnpm
                            pnpm install --frozen-lockfile
                            '''
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
                dir('backend') {
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
            echo "Release build for tag ${env.TAG_NAME} completed."
        }
        failure {
            echo "Build failed."
        }
    }
}
