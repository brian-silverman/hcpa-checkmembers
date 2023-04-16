COOKIE=/tmp/wpcookie.txt
USER=testtest
PASS=abc123FLEEKS
BASE_URL="https://www.howardcountypickleball.org/sandboxbri"
LOGIN_URL="$BASE_URL/4hcpalogin/"
MEMBER_URL="$BASE_URL/members/member_directory-3/"

rm -f $COOKIE
curl --silent --data "log=$USER&pwd=$PASS" -c $COOKIE "$LOGIN_URL"
PAGES=$(curl --silent -b $COOKIE "$MEMBER_URL" | awk -F "[<>]" '/\?s2-p=/{print $5}' | tail -1)
((PAGES > 100 || PAGES < 1 )) && { echo "ERROR: PAGES is wrong!!!"; exit; }
for ((i=1; i<=$PAGES; i++)); do
    curl --silent -b $COOKIE "$MEMBER_URL?s2-p=$i" | \
        grep -A4 "Email Address" | tr '"' "\\n" | grep "^mailto:" | cut -d: -f2
done

