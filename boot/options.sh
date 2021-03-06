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
# If set to yes the reboot will happen without a pause
# AUTO_RESTART=yes
# see http://xfree86.org/current/XKBproto.pdf
# see /etc/default/keyboard
# KEYBOARD=uk
# KEYBOARD=us
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
