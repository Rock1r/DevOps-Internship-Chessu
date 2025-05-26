pipeline {
    agent {
        node {
            label 'node.js'
        }
    }

    triggers {
        pollSCM('H/1 * * * *')
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
