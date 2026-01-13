#!/bin/bash

# --- Default vars ---
subject=""
body=""
hostname=$(hostname)
url=""

# --- Usage function ---
usage() {
    echo "Usage: $0 -s <subject> [-u <url>] [<body>]"
    echo "  -s   Subject of the alert"
    echo "  -u   The teams webshook URL, you can also set TEAMS_WEBHOOK_URL"
    echo "  -h   Show this help message"
    echo "  How to add a body: "
    echo "    Single Line Body - Append to the end of the command"
    echo "    Example:"
    echo "    $ $0 -s Test subject -u https://myurl.com this is the test body"
    echo ""
    echo "    Multi-Line Body - use EOF."
    echo "    Example:"
    echo "    $ $0 -s Test subject -u https://myurl.com >> EOF"
    echo "    this is some"
    echo "    Multi lined text output"
    echo "    That I want to send as a message"
    exit 1
}

# --- Parse flags ---
while getopts "s:u:h" opt; do
    case $opt in
        s) subject="$OPTARG" ;;
        u) url="$OPTARG" ;;
        h) usage ;;
        *) usage ;;
    esac
done

# --- Validation ---
if [[ -z "$subject" ]]; then
    echo "Error: subject is required"
    usage
fi

url="${url:-$TEAMS_WEBHOOK_URL}"
echo "$url"
if [[ -z "$url" ]]; then
    echo "Error: Please pass -u or define TEAMS_WEBHOOK_URL"
fi

raw_body="${5:-$(cat)}"
body=$(printf '%s' "$raw_body" | jq -Rs . | sed 's/^"//; s/"$//')
echo "$body"
curl -H "Content-Type: application/json" \
     -d @- "$url" << EOF

    {
       "type":"message",
       "attachments":[
          {
             "contentType":"application/vnd.microsoft.card.adaptive",
             "contentUrl":null,
             "content":{
                "$schema":"http://adaptivecards.io/schemas/adaptive-card.json",
                "type":"AdaptiveCard",
                "version":"1.2",
                "body":[
                    {
                    "type": "TextBlock",
                    "text": "[${hostname}] $subject"
                    },
                    {
                    "type": "TextBlock",
                    "isMultiline": true,
                    "wrap":true,
                    "text": "$body"
                    }
                ]
             }
          }
       ]
    }
EOF
