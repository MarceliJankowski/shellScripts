##################################################
#                   CONSTANTS                    #
##################################################

readonly SCRIPT_NAME=$(basename "$0")

readonly TRUE=0
readonly FALSE=1

readonly INVALID_FLAG_ERROR_CODE=1
readonly INVALID_ARG_ERROR_CODE=2
readonly MISSING_ARG_ERROR_CODE=3
readonly TOO_MANY_ARGS_ERROR_CODE=4
readonly INTERNAL_ERROR_CODE=255

##################################################
#                   UTILITIES                    #
##################################################

# @desc format and print global MANUAL variable
printManual() {
	[[ $# -ne 0 ]] && throwInternalErr "printManual() expects no arguments"

	echo "$MANUAL" | sed -e '1d' -e '$d'
}

# @desc log `message` to stderr and exit with INTERNAL_ERROR_CODE
throwInternalErr() {
	local message="$1"

	[[ $# -ne 1 ]] && message="throwInternalErr() expects 'message' argument"

	echo -e "[INTERNAL_ERROR] - $message" 1>&2

	exit $INTERNAL_ERROR_CODE
}

# @desc log `message` to stderr
logErr() {
	[[ $# -ne 1 ]] && throwInternalErr "logErr() expects 'message' argument"

	local -r message="$1"
	echo -e "[ERROR] - $message" 1>&2
}

# @desc log warning `message` to stdout
logWarning() {
	[[ $# -ne 1 ]] && throwInternalErr "logWarning() expects 'message' argument"

	local -r message="$1"
	echo -e "[WARNING] - $message"
}

# @desc log `message` to stderr and exit with `exitCode`
throwErr() {
	[[ $# -ne 2 ]] && throwInternalErr "throwErr() expects 'message' and 'exitCode' arguments"

	local -r message="$1"
	local -r exit_code="$2"

	logErr "$message"
	exit "$exit_code"
}

# @desc log `message` to stdout if VERBOSE_MODE is on
logIfVerbose() {
	[[ $# -ne 1 ]] && throwInternalErr "logIfVerbose() expects 'message' argument"

	local -r message="$1"

	[[ $VERBOSE_MODE -eq $TRUE ]] && echo -e "[VERBOSE] - $message"
}

# @desc check if `cmd` is available on the system
# @return 0 if it's available, 1 otherwise
isCmdAvailable() {
	[[ $# -ne 1 ]] && throwInternalErr "isCmdAvailable() expects 'cmd' argument"

	local -r cmd="$1"
	command -v "$cmd" &>/dev/null || return 1 # unavailable

	return 0 # available
}

# @desc compare `v1` and `v2` versions
# @return 0 if `v1` is equal to or greater than `v2`, 1 otherwise (`v2` is newer)
compareVersions() {
	[[ $# -ne 2 ]] && throwInternalErr "compareVersions() expects 'v1' and 'v2' arguments"

	local -r v1="$1"
	local -r v2="$2"

	local -r newestVersion=$(echo -e "${v1}\n${v2}" | sort -V -r | head -n1)

	[[ "$v1" = "$newestVersion" ]] && return 0

	return 1
}
