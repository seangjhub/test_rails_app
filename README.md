# Getting Setup

Once you clone the repo, install the required gems by running `bundle` command.

The database is configured to use `mysql` and you can see the configuration in `config/database.yml`.

You can install mysql using Homebrew, the version I am using is `5.6.46`. You can install this with the command `brew install mysql@5.6`.

Next is to prepare the database and setup a user. You can do this by running the following:

``````
mysql -u root -p
(type password & press enter/return)
``````

In mysql console run the following:

``````
mysql> CREATE USER 'seans_test_app'@'localhost' IDENTIFIED BY 's3ans_t3st_app';
Query OK, 0 rows affected (0.05 sec)

mysql> GRANT ALL PRIVILEGES ON *.* TO 'seans_test_app'@'localhost';
Query OK, 0 rows affected (0.01 sec)

mysql> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.01 sec)

mysql> quit;
``````

Now that this is setup you can create the DB locally and run a local rails server.

In the seed file there is already a user configured to test the login form, you can use this or create your own user in mysql client. 


## Features

### Authentication (`app/services/authentication_service.rb`)

This service object is responsible for validating a login based on the password passed to it from the `SessionsController` parameters.

It also handles tracking failed logins and locking the user account once the max number of failed attempts has been reached.

### Encryption (`app/services/encryption_service.rb`)

Since this project doesn't use any external libraries to handle authentication/encryption of data I have created an `EncryptionService` service object.  

It uses the `MessageEncryptor` library that is built in with rails. To use this you need to provide a salt and secret key to stop abusive users from brute forcing and using a rainbow table to crack the password. 

These values should be stored in an ENV variable on staging/production servers. For local development I have specified a hardcoded value that is checked into the repo.

The link to the rails docs for this is here:
https://api.rubyonrails.org/v5.2.4.4/classes/ActiveSupport/MessageEncryptor.html

To encrypt and decrypt a password you can simply do the following:

``````
encrypted_password  = EncryptionService.new.encrypt('password_text')
plain_text_password = EncryptionService.new.decrypt(encrypted_password)
``````

### Testing

#### User Factory (`test/factories/user_factory.rb`)

There is a `User` factory that allows you to easily create a `User` and re-use across the application. This gets used for creating the test data in the setup of other test classes.

#### Integration Testing (`test/integration/sessions_controller_test.rb`)

The login functionality and the authentication service is tested in `sessions_controller_test` where there are a number of test cases confirming that the application is working together as expected.

#### Unit Testing (`test/models/user_test.rb`)

The validation on `User` model is tested in `user_test.rb`.

#### Service Object Testing (`test/services/encryption_service_test.rb`)

The encryption & decryption service is tested in `encryption_service_test.rb`. 

