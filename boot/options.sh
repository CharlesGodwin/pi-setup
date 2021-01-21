NEW_HOSTNAME=
# If NEW_PASSWORD is valued it will be used 
#  otherwise you will be prompted for a new password
#  NEW_PASSWORD will be cleared when used
NEW_PASSWORD=
#  run the following line on a Pi for a list of available locales
# cat /etc/locale.gen
LOCALE="en_US.UTF-8"
# https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
TIMEZONE=UTC
INITIAL_PACKAGES="python3 python3-pip zip"
PYTHON_MODULES=
function post_install () {
    # add custom post install bash code see README.md
}
#
# GMAIL= your gmail email address
# GMAIL_AUTH= the authorization string you got from google for applications to use your account. 
#             Refer to https://myaccount.google.com/permissions
#
GMAIL=
GMAIL_AUTH=
