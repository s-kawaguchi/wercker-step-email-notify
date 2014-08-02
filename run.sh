
if [ ! -n "$WERCKER_EMAIL_NOTIFY_FROM" ]; then
  error 'Please specify from property'
  exit 1
fi

if [ ! -n "$WERCKER_EMAIL_NOTIFY_TO" ]; then
  error 'Please specify to property'
  exit 1
fi

if [ ! -n "$WERCKER_EMAIL_NOTIFY_USERNAME" ]; then
  error 'Please specify username property'
  exit 1
fi
if [ ! -n "$WERCKER_EMAIL_NOTIFY_PASSWORD" ]; then
  error 'Please specify password property'
  exit 1
fi
if [ ! -n "$WERCKER_EMAIL_NOTIFY_HOST" ]; then
  error 'Please specify host property'
  exit 1
fi


if [ ! -n "$WERCKER_EMAIL_NOTIFY_FAILED_SUBJECT" ]; then
  if [ ! -n "$DEPLOY" ]; then
    export WERCKER_EMAIL_NOTIFY_FAILED_SUBJECT="[wercker][$WERCKER_APPLICATION_NAME] Build Failed - $WERCKER_GIT_BRANCH"
  else
    export WERCKER_EMAIL_NOTIFY_FAILED_SUBJECT="[wercker][$WERCKER_APPLICATION_NAME] Deploy Failed - $WERCKER_DEPLOYTARGET_NAME"
  fi
fi

if [ ! -n "$WERCKER_EMAIL_NOTIFY_PASSED_SUBJECT" ]; then
  if [ ! -n "$DEPLOY" ]; then
    export WERCKER_EMAIL_NOTIFY_PASSED_SUBJECT="[wercker][$WERCKER_APPLICATION_NAME] Build Passed - $WERCKER_GIT_BRANCH"
  else
    export WERCKER_EMAIL_NOTIFY_PASSED_SUBJECT="[wercker][$WERCKER_APPLICATION_NAME] Deploy Passed - $WERCKER_DEPLOYTARGET_NAME"
  fi
fi

if [ "$WERCKER_RESULT" = "passed" ]; then
  export WERCKER_EMAIL_NOTIFY_SUBJECT="$WERCKER_EMAIL_NOTIFY_PASSED_SUBJECT"
  export WERCKER_EMAIL_NOTIFY_BODY="$WERCKER_EMAIL_NOTIFY_PASSED_BODY"
else
  export WERCKER_EMAIL_NOTIFY_SUBJECT="$WERCKER_EMAIL_NOTIFY_FAILED_SUBJECT"
  export WERCKER_EMAIL_NOTIFY_BODY="$WERCKER_EMAIL_NOTIFY_FAILED_BODY"
fi

if [ ! -n "$WERCKER_EMAIL_NOTIFY_BODY" ]; then
  DEFAULT_BODY=""

  if [ ! -n "$DEPLOY" ]; then
    DEFAULT_BODY="See <$WERCKER_BUILD_URL>\n"
  else
    DEFAULT_BODY="See <$WERCKER_DEPLOY_URL>\n"
    DEFAULT_BODY="$DEFAULT_BODY\nDeploy Target: $WERCKER_DEPLOYTARGET_NAME"
  fi

  DEFAULT_BODY="$DEFAULT_BODY\nGit Repository: https://$WERCKER_GIT_DOMAIN/$WERCKER_GIT_OWNER/$WERCKER_GIT_REPOSITORY"
  DEFAULT_BODY="$DEFAULT_BODY\nGit Branch: $WERCKER_GIT_BRANCH"
  DEFAULT_BODY="$DEFAULT_BODY\nGit Commit: $(git log -n 1 --format=%s $WERCKER_GIT_COMMIT) ($WERCKER_GIT_COMMIT)"
  DEFAULT_BODY="$DEFAULT_BODY\nStarted By: $WERCKER_STARTED_BY"

  export WERCKER_EMAIL_NOTIFY_BODY=$(echo -e "$DEFAULT_BODY")
fi


if [ "$WERCKER_EMAIL_NOTIFY_ON" = "failed" ]; then
  if [ "$WERCKER_RESULT" = "passed" ]; then
    echo "Skipping.."
    return 0
  fi
fi


python "$WERCKER_STEP_ROOT/main.py" \
  "$WERCKER_EMAIL_NOTIFY_FROM" \
  "$WERCKER_EMAIL_NOTIFY_TO" \
  "$WERCKER_EMAIL_NOTIFY_SUBJECT" \
  "$WERCKER_EMAIL_NOTIFY_BODY" \
  "$WERCKER_EMAIL_NOTIFY_USERNAME" \
  "$WERCKER_EMAIL_NOTIFY_PASSWORD" \
  "$WERCKER_EMAIL_NOTIFY_HOST"
