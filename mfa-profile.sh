#!/bin/bash

# Usage:
# ./mfa-profile.sh <mfa_code> [--profile <profile_name>]

REGION="ap-northeast-2"
MFA_CODE=$1

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
  --profile)
    PROFILE_NAME="$2"
    export AWS_PROFILE=$PROFILE_NAME
    shift # past argument
    shift # past value
    ;;
  *) # unknown option
    PROFILE_NAME=$(aws configure list | grep profile | awk '{print $2}')
    shift # past argument
    ;;
  esac
done
echo "> Profile: $PROFILE_NAME"

IAM_ARN=$(aws sts get-caller-identity --query 'Arn' --output text)
echo "> IAM Arn: $IAM_ARN"

MFA_SERIAL=$(aws iam list-virtual-mfa-devices --query 'VirtualMFADevices[?User.Arn==`'"$IAM_ARN"'`].SerialNumber' --output text)
echo "> MFA Serial: $MFA_SERIAL"

CMD_GET_TOKEN="aws sts get-session-token --serial-number $MFA_SERIAL --token-code $MFA_CODE"
echo "> $CMD_GET_TOKEN"

SESSION_TOKEN=$(eval "$CMD_GET_TOKEN")
if [ $? -ne 0 ]; then
  echo "> Failed to get session token."
  exit 1
fi
echo "> Session Token: $SESSION_TOKEN"

NEW_PROFILE="${PROFILE_NAME}_mfa"
echo "> Profile using MFA: $NEW_PROFILE"

aws configure set region $REGION --profile "$NEW_PROFILE"
echo "$SESSION_TOKEN" |
  jq --arg profile "$NEW_PROFILE" -r '
    "aws configure set aws_access_key_id " + .Credentials.AccessKeyId + " --profile " + $profile,
    "aws configure set aws_secret_access_key " + .Credentials.SecretAccessKey + " --profile " + $profile,
    "aws configure set aws_session_token " + .Credentials.SessionToken + " --profile " + $profile' |
  bash

aws configure list --profile "$NEW_PROFILE"
echo "> You can use the profile '$NEW_PROFILE' with the session token."
echo "export AWS_PROFILE=$NEW_PROFILE # change profile to $NEW_PROFILE"
export AWS_PROFILE=$NEW_PROFILE