# Send Teams Alert

A Bash utility script for sending formatted alerts to Microsoft Teams channels via incoming webhooks. Supports multiline messages, command output embedding, and flexible input methods.

## Features

- Send alerts to Teams with custom subjects and message bodies
- Support for multiline input via heredocs, pipes, or command substitution
- Automatic JSON escaping for Teams Adaptive Cards
- Configurable webhook URL via parameter or environment variable
- Properly formatted output with line breaks preserved

## Requirements

- Bash 4.0+
- `curl`
- `jq` (for JSON escaping)

## Installation

```bash
# Clone the repository
git clone https://github.com/lilrebel17/send-teams-alert.git
cd send-teams-alert

# Make executable
chmod +x send_teams_alert.sh

# Optional: Add to PATH
sudo cp send_teams_alert.sh /usr/local/bin/

# Optional: Add TEAMS_WEBHOOK_URL to path
You can also just specify -u with the webhook URL in your scripts.
```

## Usage

- The Subject can be only a single line.
- You can do both single and multi-line blocks for the body
- Be aware with Teams Adaptive cards, they require two newlines to space out correctly on all devices. Using the examples below for multi-line bodies, notice everything has two new lines in between them.

### Full Example with Single Line Body:
```bash
send_teams_alert.sh -s "Test Subject" -u https://teams_webhook_url.com "This is a full single line body that I prepared"
```

### Full Example with Multi Line Body - Simple:
```bash
send_teams_alert.sh -s "Test Subject" -u https://teams_webhook_url.com << EOF
Failure on $(hostname)

See $LOG_FILE for more information
EOF
```

### Full Example with Multi Line Body - Advanced:
```bash
send_teams_alert.sh -s "Error during backup script" -u $TEAMS_WEBHOOK_URL << EOF
BACKUP FAILED on $(hostname)

See $LOG_FILE for more information

S3 Target: s3://not_real/fake_s3

Recent Logs:

$(tail -n 15 "$LOG_FILE" | sed 's/^/* /') # this works because * starts a list in teams.
EOF
```
