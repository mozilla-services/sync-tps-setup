def testEnv = ''

pipeline {
  agent {
      dockerfile {
        filename 'Dockerfile' 
        args '-u root:root' 
        additionalBuildArgs '--no-cache'
      }
  }
  libraries {
    lib('fxtest@1.9')
  }
  options {
    ansiColor('xterm')
    timestamps()
    timeout(time: 1, unit: 'HOURS')
  }
  environment {
    TEST_ENV = "${TEST_ENV ?: JOB_NAME.split('\\.')[1]}"
    SYNC_TPS_EMAIL_RECIPIENT = "${SYNC_TPS_EMAIL_RECIPIENT}"
    SYNC_TPS_CONFIG_STAGE = credentials('SYNC_TPS_CONFIG_STAGE')
    SYNC_TPS_CONFIG_PROD = credentials('SYNC_TPS_CONFIG_PROD')
    TPS_BINARY = '/tests/venv/bin/runtps'
    FIREFOX_BINARY = '/tests/firefox-nightly/firefox' 
    CONFIG = '/tests/config.json'
  }
  stages {
    stage('Test') {
      steps {
	script {
	  if (env.TEST_ENV == 'stage') {
	    testEnv = 'stage' 
	    sh 'echo ${SYNC_TPS_CONFIG_STAGE} > ${CONFIG}'
	    sh "MOZ_HEADLESS=1 ${TPS_BINARY} --debug --binary=${FIREFOX_BINARY} --configfile=${CONFIG}"
	  } else if (env.TEST_ENV == 'prod') {
	    testEnv = 'prod' 
	    sh 'echo ${SYNC_TPS_CONFIG_PROD} > ${CONFIG}'
	    sh "MOZ_HEADLESS=1 ${TPS_BINARY} --debug --binary=${FIREFOX_BINARY} --configfile=${CONFIG} --testfile=test_sync.js"
	  } else {
	    testEnv = "${env.TEST_ENV}" 
	    sh 'echo "ERROR: ${TEST_ENV} is not a recognized TEST_ENV --> Aborting!"'
		sh 'exit 1'
	  } 
        }
      } 
    } 
  }
  post {
    always {
      sh 'gzip -f tps.log'
    } 
    success {
      emailext(
        attachmentsPattern: 'tps.log.gz',
        body: 'Test summary: $BUILD_URL\n\n',
        replyTo: '$DEFAULT_REPLYTO',
        subject: "TPS ${testEnv} succeeded!!",
        to: '$SYNC_TPS_EMAIL_RECIPIENT')
    }
    failure {
      emailext(
        attachmentsPattern: 'tps.log.gz',
        body: 'Test summary: $BUILD_URL\n\n',
        replyTo: '$DEFAULT_REPLYTO',
        subject: "TPS ${testEnv} failed!",
        to: '$SYNC_TPS_EMAIL_RECIPIENT')
    }
    changed {
      ircNotification('#fx-test-alerts')
    }
  }
}
