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
                            sh 'npm ci'
                        }
                    }
                }
                stage('Backend Install') {
                    steps {
                        dir('server') {
                            sh 'npm ci'
                        }
                    }
                }
            }
        }

        stage('Lint') {
            parallel {
                stage('Frontend Lint') {
                    steps {
                        dir('client') {
                            sh 'npm run lint'
                        }
                    }
                }
                stage('Backend Lint') {
                    steps {
                        dir('server') {
                            sh 'npm run lint'
                        }
                    }
                }
            }
        }

        stage('Test') {
            parallel {
                stage('Frontend Test') {
                    steps {
                        dir('client') {
                            sh 'npm test'
                        }
                    }
                }
                stage('Backend Test') {
                    steps {
                        dir('server') {
                            sh 'npm test'
                        }
                    }
                }
            }
        }

        stage('Build Frontend') {
            steps {
                dir('client') {
                    sh 'npm run build'
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
                    sh 'npm run build'
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
