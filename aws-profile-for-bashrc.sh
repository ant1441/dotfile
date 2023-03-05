# MIT No Attribution
#
# Copyright 2022 Ben Kehoe
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# There are lots of well-built tools that completely manage your
# AWS profiles and login and credentials, like aws-vault and AWSume.
# This isn't that.
# I tend to prefer to go as lightweight as possible around AWS-produced tools.
# So all this does is set and unset your AWS_PROFILE environment variable.

# This code requires the AWS CLI v2 to function correctly, because it uses the
# aws configure list-profiles command for validation and auto-completion,
# and this command does not exist in the AWS CLI v1.
# AWS CLI v2 install instructions:
# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html

# You might also be interested in aws-whoami
# which improves upon `aws sts get-caller-identity`
# https://github.com/benkehoe/aws-whoami

aws-profile () {
  if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "USAGE:"
    echo "aws-profile              <- print out current value"
    echo "aws-profile PROFILE_NAME <- set PROFILE_NAME active"
    echo "aws-profile --unset      <- unset the env vars"
  elif [ -z "$1" ]; then
    if [ -z "$AWS_PROFILE$AWS_DEFAULT_PROFILE" ]; then
      echo "No profile is set"
      return 1
    else
      echo "$AWS_PROFILE$AWS_DEFAULT_PROFILE"
    fi
  elif [ "$1" = "--unset" ]; then
    AWS_PROFILE=
    AWS_DEFAULT_PROFILE=
    # removing the vars is needed because of https://github.com/aws/aws-cli/issues/5016
    export -n AWS_PROFILE AWS_DEFAULT_PROFILE
  else
    # this check needed because of https://github.com/aws/aws-cli/issues/5546
    # requires AWS CLI v2
    if ! aws configure list-profiles | grep --color=never -Fxq -- "$1"; then
      echo "$1 is not a valid profile"
      return 2
    else
      AWS_DEFAULT_PROFILE=
      export AWS_PROFILE=$1
      export -n AWS_DEFAULT_PROFILE
    fi;
  fi;
}
# completion is kinda slow, operating on the files directly would be faster but more work
# aws configure list-profiles is only available with the AWS CLI v2.
_aws-profile-completer () {
  COMPREPLY=(`aws configure list-profiles | grep --color=never ^${COMP_WORDS[COMP_CWORD]}`)
}
complete -F _aws-profile-completer aws-profile
