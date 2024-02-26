#!/usr/bin/env bash

set -o pipefail

source "$(dirname $0)/../lib.sh"

# to get info on this script run it with '-h' flag

##################################################
#                GLOBAL VARIABLES                #
##################################################

readonly MAX_ARG_COUNT=0

# options (can be set through CLI)
VERBOSE_MODE=$FALSE

readonly MANUAL="
NAME
      $SCRIPT_NAME -

SYNOPSIS
      $SCRIPT_NAME [-h] [-v]

DESCRIPTION
      Description...

OPTIONS
      -h
          Get help, print out the manual and exit.

      -v
          Turn on VERBOSE_MODE (increases output).

EXIT CODES
      Exit code indicates whether $SCRIPT_NAME successfully executed, or failed for some reason.
      Different exit codes indicate different failure causes:

      0  $SCRIPT_NAME successfully run, without raising any exceptions.

      $INVALID_FLAG_ERROR_CODE  Invalid flag supplied.

      $INVALID_ARG_ERROR_CODE  Invalid argument supplied.

      $MISSING_ARG_ERROR_CODE  Missing mandatory argument.

      $TOO_MANY_ARGS_ERROR_CODE  Too many arguments supplied (max number: ${MAX_ARG_COUNT}).

      $INTERNAL_ERROR_CODE  Developer fuc**d up, blame him!
"

##################################################
#                   FUNCTIONS                    #
##################################################

# @desc ...
main() {}

##################################################
#             EXECUTION ENTRY POINT              #
##################################################

# handle flags
while getopts ':hv' FLAG; do
	case "$FLAG" in
	h) printManual && exit 0 ;;
	v) VERBOSE_MODE=$TRUE ;;
	:) throwErr "flag '-${OPTARG}' requires argument" $MISSING_ARG_ERROR_CODE ;;
	?) throwErr "invalid flag '-${OPTARG}' supplied" $INVALID_FLAG_ERROR_CODE ;;
	esac
done

# turn options into constants
readonly VERBOSE_MODE

# remove flags, leaving script arguments
shift $((OPTIND - 1))

# check if too many arguments were supplied
[[ $# -gt $MAX_ARG_COUNT ]] &&
	throwErr "too many arguments supplied (max number: ${MAX_ARG_COUNT})" $TOO_MANY_ARGS_ERROR_CODE

main

exit 0
