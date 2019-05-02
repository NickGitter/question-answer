# question-answer

## About this application

Web application for answer questions.

## How to run?

To initialize the application on the server side, you will run the initialization script:

    ./init.sh
    
This will launch the application itself.

Initialization needs to be started only at the first use **or** at change in the application.

To enable or disable an application, you can use the **on** / **off** options of the 
initialization script:

    ./init.sh [ on | off ]

## Specification.

### Purpose.

This project is a service to answer questions. The user of the service has the opportunity 
to register ( = signup), ask a question, answer questions from other users. Also, the user 
can mark questions with the help of the like button, changing rating for them.

### The main entities.

1. **User** - username, email, password, avatar.

2. **Question** - title, text, author, rating.

3. **Answer** - text, question, author, "true" flag.

4. **Like** - question, user.

### Forms && pages.

**URL = /** Main page. Purpose: is a list of "popular" questions. The list displays 
questions in descending order of rating.

**URL = /new/** List of new questions. Purpose: a list of questions by the date they 
are added, starting with the most recent.

**URL = /question/123/** One question page. Purpose: on this page you can read the 
text of the question and a list of answers to it. Authorized users can add their 
answer.

**URL = /signup/** Registration page. Purpose: the user can enter his email, password, 
name, select an avatar and register in the project.

**URL = /login/** Login page. Purpose: the user can enter username and password and 
log in in the project.

**URL = /ask/** Page for add a question. Purpose: an authorized user can ask a question 
and then go to this question page.

**URL = /like/123/** Like button. Purpose: the user can click the "Like" button on the 
question and this will increase the rating of the question. The user can click 
"Like" no more than 1 time for 1 question.


