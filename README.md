# email-notify

Send an email message

## Options

### required

* `from` - From address.
* `to` - To addresses. Multiple addresses can be specified as CSV.
* `host` - The host of your SMTP server.
* `username` - The username for your SMTP server.
* `password` - The password for your SMTP server.

### optional

* `passed-subject` - Use this option to override the default passed subject.
* `failed-subject` -  Use this option to override the default failed subject.
* `passed-body` - Use this option to specify the passed body.
* `failed-body` -  Use this option to specify the failed body.
* `on` - Possible values: `always` and `failed`, default `always`


# Example

Add EMAIL_PASSWORD as deploy target or application environment variable.


    build:
        after-steps:
            - s-kawaguchi/email-notify:
                from: alerts@company.com
                to: admin@company.com,member@company.com
                username: username
                password: $EMAIL_PASSWORD
                host: smtp.gmail.com:587


