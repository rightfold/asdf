Feature: Create group
    Create a group with no accounts and an empty ledger. A group name must be
    given, and it will be stored in the group metadata.

    Scenario: Empty group name
        Given The group name is empty
        When A group creation attempt is made
        Then The group creation attempt fails
        And The group is not saved
