# email-notify

Send an email message

## Options

### required

* `host` - The host of your SMTP server.
* `username` - The username for your SMTP server.
* `password` - The password for your SMTP server.
* `from` - From address.
* `to` - To addresses. Multiple addresses can be specified as CSV.

### optional

* `on` - Possible values: `always` and `failed`, default `always`
* `passed-subject` - Use this option to override the default passed subject.
* `failed-subject` -  Use this option to override the default failed subject.
* `passed-body` - Use this option to specify the passed body.
* `failed-body` -  Use this option to specify the failed body.

# Example

Add EMAIL_PASSWORD as deploy target or application environment variable.


    build:
        after-steps:
            - s-kawaguchi/email-notify:
                host: smtp.gmail.com:587
                username: username
                password: $EMAIL_PASSWORD
                from: alerts@company.com
                to: admin@company.com,member@company.com


