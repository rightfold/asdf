Feature: Log in
    Log in with valid or invalid credentials.

    Scenario: Invalid email address
        Given The email address "invalid@example.com" and the password "asdf"
        When A login attempt is made
        Then The login attempt fails

    Scenario: Invalid password
        Given The email address "asdf@example.com" and the password "invalid"
        When A login attempt is made
        Then The login attempt fails

    Scenario: Valid credentials
        Given The email address "asdf@example.com" and the password "asdf"
        When A login attempt is made
        Then The login attempt succeeds
